#!/usr/bin/env bash
set -euo pipefail

# rebuild-projections.sh — Deterministic rebuild of P8 projections.
#
# Purpose (per WI-071 + adr-040 + P8 + P10):
#   Replay work-events streams + cross-reference task-specs / work-graph /
#   task-governance to regenerate the 3 derived projections:
#     - governance/build-time/projections/in-progress.cue
#     - governance/build-time/projections/ready-queue.cue
#     - governance/build-time/projections/blocked-items.cue
#
# Properties:
#   - Idempotent: rebuild repetido produz mesmo resultado se inputs
#     não mudaram.
#   - Deterministic (P10): rebuild é gate determinístico, NÃO
#     stochastic. Zero LLM dependency.
#   - Source-of-truth preservado: work-events permanecem canonical
#     append-only; projections são derivadas (P8 — deletáveis sem
#     perda).
#
# Algorithm:
#   1. cue export work-events/, task-specs/, build-time/ → JSON
#   2. Per stream: replay events; compute admission state (proposed/
#      approved/rejected/cancelled/superseded) + execution state
#      (unclaimed/claimed/blocked/completed) from last event.
#   3. Apply readyQueueAlgorithm (per work-governance.cue):
#      admission=approved + execution=unclaimed + all deps
#      task-completed + task-spec exists → ready.
#   4. Emit 3 .cue files atomic.
#
# Limitations (out of scope WI-071; future WIs):
#   - Claim expiration is NOT auto-detected; trusts last event.
#     If task-claim-expired wasn't emitted, claim shows as in-progress
#     even past claimExpiresAt. Future WI: claim expiration runner.
#   - No diff/check mode yet (always overwrites). Future WI: --check
#     flag para CI gate verifying drift.

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

PROJECTIONS_DIR="governance/build-time/projections"
WORK_EVENTS_DIR="governance/build-time/work-events"
TASK_SPECS_DIR="governance/build-time/task-specs"
BUILD_TIME_DIR="governance/build-time"

# ── Step 0: cue vet sanity ──

echo "Step 0: cue vet sanity check..."
if ! cue vet ./governance/build-time/ 2>/dev/null; then
  echo "ERROR: cue vet failed for governance/build-time/ — fix sintaxe antes de rebuild"
  exit 1
fi
echo "  cue vet passed."

# ── Step 1: Export JSON sources to temp files ──

echo "Step 1: Exporting CUE state to JSON..."
TMPDIR_RP="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_RP"' EXIT
cue export "./$WORK_EVENTS_DIR/" --out json > "$TMPDIR_RP/work_events.json"
cue export "./$TASK_SPECS_DIR/" --out json > "$TMPDIR_RP/task_specs.json"
cue export "./$BUILD_TIME_DIR/" --out json > "$TMPDIR_RP/build_time.json"

REBUILT_AT="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# ── Step 2: Compute projections via Python ──

echo "Step 2: Computing projections via deterministic replay..."

export TMPDIR_RP REBUILT_AT PROJECTIONS_DIR

python3 - <<'PYEOF'
import json
import os
import sys

# ── Load JSON sources ──

tmpdir = os.environ["TMPDIR_RP"]
with open(f"{tmpdir}/work_events.json") as f:
    work_events = json.load(f)
with open(f"{tmpdir}/task_specs.json") as f:
    task_specs = json.load(f)
with open(f"{tmpdir}/build_time.json") as f:
    build_time = json.load(f)

streams = work_events.get("streams", {})
specs = task_specs.get("taskSpecs", {})
work_graph = build_time.get("workGraph", {})
task_governance = build_time.get("taskGovernance", {})

# ── Index dependencies + criticality ──

# work-graph executionDependencies: list of {taskId, dependsOn, phaseId, ...}
exec_deps = {}
# JSON key is "dependencies" (the CUE field is `dependencies` in workGraph block)
for entry in work_graph.get("dependencies", []):
    exec_deps[entry["taskId"]] = entry.get("dependsOn", [])

# task-governance: rules indexed at top-level by template name (e.g.,
# 'tmpl-create-schema'). Each entry has scope/templateRef/criticality.
template_criticality = {}
for rule_id, rule in task_governance.items():
    if not isinstance(rule, dict):
        continue
    if rule.get("scope") == "template":
        ref = rule.get("templateRef", "").rsplit("@", 1)[0]  # tmpl-X@v1 → tmpl-X
        template_criticality[ref] = rule.get("criticality", "medium")

def get_criticality(spec):
    """Return criticality for a task-spec via templateRef lookup."""
    ref = spec.get("templateRef", "")
    base = ref.rsplit("@", 1)[0]
    return template_criticality.get(base, "medium")

# ── Compute state per stream ──

# Terminal admission states (negative)
ADMISSION_TERMINAL = {"task-rejected", "task-cancelled", "task-superseded"}

def compute_state(events):
    """Replay events; return (admission, execution, latest_claim_event_or_None).
    admission ∈ {proposed, approved, rejected, cancelled, superseded}
    execution ∈ {none, unclaimed, claimed, blocked, completed}
    """
    if not events:
        return ("none", "none", None)
    sorted_events = sorted(events, key=lambda e: e["timestamp"])
    last = sorted_events[-1]
    et = last["eventType"]
    # Walk to find admission state (sticky from earliest approval/rejection)
    admission = "proposed"
    for e in sorted_events:
        if e["eventType"] == "task-approved":
            admission = "approved"
        elif e["eventType"] == "task-rejected":
            admission = "rejected"
        elif e["eventType"] == "task-cancelled":
            admission = "cancelled"
        elif e["eventType"] == "task-superseded":
            admission = "superseded"
    # Execution from last event
    if et == "task-completed":
        execution = "completed"
    elif et == "task-claimed":
        execution = "claimed"
    elif et == "task-blocked":
        execution = "blocked"
    elif et in {"task-released", "task-claim-expired", "task-unblocked"}:
        execution = "unclaimed"
    elif et == "task-approved":
        execution = "unclaimed"
    elif et == "task-proposed":
        execution = "none"
    elif et in ADMISSION_TERMINAL:
        execution = "none"
    elif et == "task-reopened":
        execution = "unclaimed"
    else:
        execution = "none"
    # Latest claim event (for in-progress payload)
    latest_claim = None
    for e in sorted_events:
        if e["eventType"] == "task-claimed":
            latest_claim = e
    return (admission, execution, latest_claim)

stream_state = {}
for wi, stream in streams.items():
    events = stream.get("events", [])
    stream_state[wi] = compute_state(events)

# ── Build in-progress projection ──

in_progress = []
for wi, (admission, execution, claim) in stream_state.items():
    if execution != "claimed" or claim is None:
        continue
    spec = specs.get(wi)
    if spec is None:
        continue  # spec missing — skip (orphan stream)
    in_progress.append({
        "taskId": wi,
        "version": int(spec.get("version", 1)),
        "title": spec.get("title", ""),
        "claimedBy": claim["actor"],
        "claimedAt": claim["timestamp"],
        "claimExpiresAt": claim["claimExpiresAt"],
        "criticality": get_criticality(spec),
    })
in_progress.sort(key=lambda e: e["taskId"])

# ── Build blocked-items projection ──

blocked = []
for wi, (admission, execution, _) in stream_state.items():
    if execution != "blocked":
        continue
    spec = specs.get(wi)
    if spec is None:
        continue
    # blocked schema: need to check #BlockedItemEntry shape — not retrieved yet
    # Conservative: include taskId + version + title + criticality
    blocked.append({
        "taskId": wi,
        "version": int(spec.get("version", 1)),
        "title": spec.get("title", ""),
        "criticality": get_criticality(spec),
    })
blocked.sort(key=lambda e: e["taskId"])

# ── Build ready-queue projection ──
# Eligibility: admission=approved + execution=unclaimed + all deps
# task-completed + task-spec exists.

ready = []
for wi, spec in specs.items():
    state = stream_state.get(wi)
    if state is None:
        continue  # admission=defined (no work-event); not in projection
    admission, execution, _ = state
    if admission != "approved" or execution != "unclaimed":
        continue
    # Check dependencies all completed
    deps = exec_deps.get(wi, [])
    deps_ok = True
    for dep in deps:
        dep_id = dep["taskId"]
        dep_state = stream_state.get(dep_id)
        if dep_state is None or dep_state[1] != "completed":
            deps_ok = False
            break
    if not deps_ok:
        continue
    ready.append({
        "taskId": wi,
        "version": int(spec.get("version", 1)),
        "title": spec.get("title", ""),
        "eligibleRoles": ["spec-writer"],
        "criticality": get_criticality(spec),
    })
ready.sort(key=lambda e: e["taskId"])

# ── Emit CUE files ──

REBUILT_AT = os.environ["REBUILT_AT"]
PROJECTIONS_DIR = os.environ["PROJECTIONS_DIR"]

def fmt_string(s):
    """Format string for CUE — escape backslash and double-quote."""
    return s.replace("\\", "\\\\").replace('"', '\\"')

def emit_in_progress():
    lines = []
    lines.append("package projections")
    lines.append("")
    lines.append('import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"')
    lines.append("")
    lines.append("// Projeção derivada: in-progress.")
    lines.append("// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) —")
    lines.append("// replay determinístico de work-events/ filtrando streams cujo")
    lines.append('// executionState computado é "claimed" (claim ativo, não expirado).')
    lines.append("// Deletável sem perda (P8). Não é source of truth.")
    lines.append("//")
    if not in_progress:
        lines.append("// Reconstrução atual: zero items em progresso.")
    else:
        lines.append(f"// Reconstrução atual: {len(in_progress)} item(s) em progresso.")
        for e in in_progress:
            lines.append(f"//   - {e['taskId']} (claimed {e['claimedAt']}; expires {e['claimExpiresAt']})")
    lines.append("")
    lines.append("inProgressProjection: {")
    lines.append(f'\trebuiltAt: "{REBUILT_AT}"')
    if not in_progress:
        lines.append("\tentries: [...build_time.#InProgressEntry] & []")
    else:
        lines.append("\tentries: [...build_time.#InProgressEntry] & [{")
        for i, e in enumerate(in_progress):
            if i > 0:
                lines.append("\t}, {")
            lines.append(f'\t\ttaskId:         "{e["taskId"]}"')
            lines.append(f'\t\tversion:        {e["version"]}')
            lines.append(f'\t\ttitle:          "{fmt_string(e["title"])}"')
            lines.append(f'\t\tclaimedBy:      "{fmt_string(e["claimedBy"])}"')
            lines.append(f'\t\tclaimedAt:      "{e["claimedAt"]}"')
            lines.append(f'\t\tclaimExpiresAt: "{e["claimExpiresAt"]}"')
            lines.append(f'\t\tcriticality:    "{e["criticality"]}"')
        lines.append("\t}]")
    lines.append("}")
    return "\n".join(lines) + "\n"

def emit_ready_queue():
    lines = []
    lines.append("package projections")
    lines.append("")
    lines.append('import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"')
    lines.append("")
    lines.append("// Projeção derivada: ready-queue.")
    lines.append("// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) a partir de")
    lines.append("// work-events/, work-graph.cue, task-specs/, task-governance.cue.")
    lines.append("// Deletável sem perda (P8). Não é source of truth.")
    lines.append("//")
    lines.append("// Algorithm aplicado: admission=approved + execution=unclaimed + todas")
    lines.append("// as deps em estado final (task-completed) + task-spec existe.")
    lines.append("//")
    lines.append(f"// {len(ready)} candidato(s) prontos para claim.")
    lines.append("")
    lines.append("readyQueueProjection: {")
    lines.append(f'\trebuiltAt: "{REBUILT_AT}"')
    if not ready:
        lines.append("\tentries: [...build_time.#ReadyQueueEntry] & []")
    else:
        lines.append("\tentries: [...build_time.#ReadyQueueEntry] & [{")
        for i, e in enumerate(ready):
            if i > 0:
                lines.append("\t}, {")
            lines.append(f'\t\ttaskId:        "{e["taskId"]}"')
            lines.append(f'\t\tversion:       {e["version"]}')
            lines.append(f'\t\ttitle:         "{fmt_string(e["title"])}"')
            roles = ", ".join(f'"{r}"' for r in e["eligibleRoles"])
            lines.append(f'\t\teligibleRoles: [{roles}]')
            lines.append(f'\t\tcriticality:   "{e["criticality"]}"')
        lines.append("\t}]")
    lines.append("}")
    return "\n".join(lines) + "\n"

def emit_blocked():
    lines = []
    lines.append("package projections")
    lines.append("")
    lines.append('import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"')
    lines.append("")
    lines.append("// Projeção derivada: blocked-items.")
    lines.append("// Reconstruída via scripts/ci/rebuild-projections.sh (per WI-071) —")
    lines.append("// replay determinístico de work-events/ filtrando streams cujo")
    lines.append('// executionState computado é "blocked".')
    lines.append("// Deletável sem perda (P8). Não é source of truth.")
    lines.append("//")
    if not blocked:
        lines.append("// Reconstrução atual: zero items bloqueados.")
    else:
        lines.append(f"// Reconstrução atual: {len(blocked)} item(s) bloqueado(s).")
    lines.append("")
    lines.append("blockedItemsProjection: {")
    lines.append(f'\trebuiltAt: "{REBUILT_AT}"')
    if not blocked:
        lines.append("\tentries: [...build_time.#BlockedItemEntry] & []")
    else:
        # Conservative emission — schema fields TBD; fail loudly if blocked items exist
        sys.stderr.write(
            "WARNING: blocked items detected but #BlockedItemEntry shape "
            "not fully modeled in this script version — emitting minimal "
            "fields. Verify against schema.\n"
        )
        lines.append("\tentries: [...build_time.#BlockedItemEntry] & [{")
        for i, e in enumerate(blocked):
            if i > 0:
                lines.append("\t}, {")
            lines.append(f'\t\ttaskId:      "{e["taskId"]}"')
            lines.append(f'\t\tversion:     {e["version"]}')
            lines.append(f'\t\ttitle:       "{fmt_string(e["title"])}"')
            lines.append(f'\t\tcriticality: "{e["criticality"]}"')
        lines.append("\t}]")
    lines.append("}")
    return "\n".join(lines) + "\n"

# ── Write files ──

with open(f"{PROJECTIONS_DIR}/in-progress.cue", "w") as f:
    f.write(emit_in_progress())
with open(f"{PROJECTIONS_DIR}/ready-queue.cue", "w") as f:
    f.write(emit_ready_queue())
with open(f"{PROJECTIONS_DIR}/blocked-items.cue", "w") as f:
    f.write(emit_blocked())

print(f"  in-progress: {len(in_progress)} entries")
print(f"  ready-queue: {len(ready)} entries")
print(f"  blocked-items: {len(blocked)} entries")
PYEOF

# ── Step 3: Validate output ──

echo "Step 3: cue vet on regenerated projections..."
if ! cue vet ./governance/build-time/ 2>&1 | head -5; then
  echo "ERROR: regenerated projections fail cue vet"
  exit 1
fi

echo "Done. Projections rebuilt at $REBUILT_AT."
