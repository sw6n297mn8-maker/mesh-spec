#!/usr/bin/env bash
set -euo pipefail

# evaluate-deferred-triggers.sh — Runner determinístico de triggers
# de deferred-decisions (per adr-062).
#
# Estratégia:
#   1. cue export do package deferred_decisions → JSON com todas instâncias
#   2. Para cada def-XXX com status=open, avalia cada trigger por kind
#   3. Triggers que disparam emitem GitHub Action annotations (::warning::)
#      + entrada em workflow output. NÃO muta arquivos.
#   4. Exit 0 sempre (advisory; não bloqueia CI).
#
# Triggers machine-evaluable (per adr-062 + adr-071):
#   - recurrence:       grep do pattern no scope (filename/file-content/
#                       commit-message); fires quando count >= threshold
#   - adjacent-need:    file-exists OU file-contains; fires quando condição
#                       satisfeita
#   - volume-threshold: count de arquivos por glob de artifactType;
#                       fires quando count >= threshold
#   - temporal:         date math vs def.date; fires quando age_days >= maxAgeDays
#   - manual-review:    skip (founder revisa via edit manual)
#   - file-content-occurrence-count:
#                       conta regex matches DENTRO de UM arquivo singleton
#                       (per adr-071); USO RESTRITO a singleton governance
#                       file (não mecanismo geral de busca no repo).
#
# Limitação conhecida: avaliação é sobre filesystem state atual + git log
# para commit-message scope. Não há state persistido entre runs — trigger
# fired in run N stays "open" until founder edits status manualmente.

DEFERRED_DIR="architecture/deferred-decisions"

# ── Step 0: cue vet (sanity) ──

echo "Step 0: Validating deferred-decisions CUE shape..."
if ! cue vet "./$DEFERRED_DIR/" 2>/dev/null; then
  # Diretório pode estar vazio ou só ter .gitkeep
  if [[ ! -d "$DEFERRED_DIR" ]] || ! ls "$DEFERRED_DIR"/*.cue >/dev/null 2>&1; then
    echo "  No deferred-decisions found; nothing to evaluate."
    exit 0
  fi
  echo "ERROR: cue vet failed for $DEFERRED_DIR"
  exit 1
fi
echo "  cue vet passed."

# ── Step 1: Export JSON ──

echo "Step 1: Exporting deferred-decisions to JSON..."
JSON_DATA="$(cue export "./$DEFERRED_DIR/" --out json)"

# ── Step 2: Evaluate triggers per def ──

echo "Step 2: Evaluating triggers..."

python3 - <<'PYEOF'
import json
import os
import re
import subprocess
import sys
from datetime import date, datetime

json_data = os.environ.get("JSON_DATA", "")
if not json_data:
    json_data = subprocess.check_output(
        ["cue", "export", "./architecture/deferred-decisions/", "--out", "json"],
        text=True,
    )

data = json.loads(json_data)
defs = data.get("deferredDecisions", {})

triggered_count = 0
output_lines = []

today = date.today()


def evaluate_recurrence(trigger):
    pattern = trigger["pattern"]
    scope = trigger["scope"]
    threshold = trigger["threshold"]
    try:
        if scope == "filename":
            cmd = ["git", "ls-files"]
            files = subprocess.check_output(cmd, text=True).splitlines()
            count = sum(1 for f in files if re.search(pattern, f))
        elif scope == "file-content":
            cmd = ["git", "grep", "-l", "-E", pattern]
            try:
                files = subprocess.check_output(cmd, text=True).splitlines()
                count = len(files)
            except subprocess.CalledProcessError:
                count = 0  # grep returns 1 when no match
        elif scope == "commit-message":
            cmd = ["git", "log", "--format=%H", f"--grep={pattern}", "-E"]
            commits = subprocess.check_output(cmd, text=True).splitlines()
            count = len(commits)
        else:
            return False, f"unknown recurrence scope: {scope}"
        if count >= threshold:
            return True, f"recurrence(scope={scope}, pattern={pattern!r}) found {count} >= threshold {threshold}"
        return False, f"recurrence count {count} < threshold {threshold}"
    except Exception as e:
        return False, f"recurrence eval error: {e}"


def evaluate_adjacent_need(trigger):
    cond = trigger["condition"]
    kind = cond["kind"]
    path = cond["path"]
    if kind == "file-exists":
        if os.path.exists(path):
            return True, f"adjacent-need.file-exists: {path} exists"
        return False, f"adjacent-need.file-exists: {path} does not exist"
    if kind == "file-contains":
        pattern = cond["pattern"]
        if not os.path.exists(path):
            return False, f"adjacent-need.file-contains: {path} does not exist"
        try:
            with open(path) as f:
                content = f.read()
            if re.search(pattern, content):
                return True, f"adjacent-need.file-contains: {path} matches pattern {pattern!r}"
            return False, f"adjacent-need.file-contains: {path} no match for {pattern!r}"
        except Exception as e:
            return False, f"adjacent-need eval error: {e}"
    return False, f"unknown adjacent-need kind: {kind}"


def evaluate_volume_threshold(trigger):
    artifact_type = trigger["artifactType"]
    threshold = trigger["threshold"]
    # Best-effort: count files matching common patterns for known types.
    # Future: could derive from artifact schema's canonicalPathRegex.
    patterns = {
        "adr": "architecture/adrs/adr-*.cue",
        "lens": "architecture/lenses/*.cue",
        "tension-entry": "architecture/tension-log/ten-*.cue",
        "deferred-decision": "architecture/deferred-decisions/def-*.cue",
        "task-template": "ai-orchestration/agent-instructions/task-templates.cue",
        "structural-check": "architecture/structural-checks/*.cue",
        "validation-prompt": "architecture/validation-prompts/*.cue",
        "production-guide": "architecture/production-guides/*.cue",
        "self-review-report": "governance/build-time/self-reviews/*.cue",
        "subdomain": "strategic/subdomains/*.cue",
    }
    pat = patterns.get(artifact_type)
    if not pat:
        return False, f"volume-threshold: unknown artifactType {artifact_type}"
    try:
        cmd = ["bash", "-c", f"ls {pat} 2>/dev/null | wc -l"]
        count = int(subprocess.check_output(cmd, text=True).strip())
        if count >= threshold:
            return True, f"volume-threshold({artifact_type}): {count} >= threshold {threshold}"
        return False, f"volume-threshold({artifact_type}): {count} < threshold {threshold}"
    except Exception as e:
        return False, f"volume-threshold eval error: {e}"


def evaluate_temporal(trigger, def_date):
    max_age = trigger["maxAgeDays"]
    try:
        d = datetime.strptime(def_date, "%Y-%m-%d").date()
        age_days = (today - d).days
        if age_days >= max_age:
            return True, f"temporal: age {age_days} days >= maxAgeDays {max_age}"
        return False, f"temporal: age {age_days} days < maxAgeDays {max_age}"
    except Exception as e:
        return False, f"temporal eval error: {e}"


def evaluate_manual_review(trigger):
    return False, f"manual-review: skip (reason: {trigger.get('reason', 'n/a')[:60]}...)"


def evaluate_file_content_occurrence_count(trigger):
    # Conta occurrences do regex DENTRO de UM arquivo singleton.
    # Distinto de recurrence scope=file-content (conta arquivos com matches).
    # Uso restrito: trigger de singleton governance file (ver schema doc).
    path = trigger["path"]
    pattern = trigger["pattern"]
    threshold = trigger["threshold"]
    if not os.path.exists(path):
        return False, f"file-content-occurrence-count: {path} does not exist"
    try:
        with open(path) as f:
            text = f.read()
        count = len(re.findall(pattern, text))
        if count >= threshold:
            return True, f"file-content-occurrence-count(path={path}, pattern={pattern!r}) found {count} >= threshold {threshold}"
        return False, f"file-content-occurrence-count: {count} < threshold {threshold}"
    except Exception as e:
        return False, f"file-content-occurrence-count eval error: {e}"


for def_id, d in defs.items():
    status = d.get("status", "")
    if status != "open":
        print(f"  SKIP {def_id} (status={status})")
        continue

    print(f"  EVAL {def_id}: {d.get('title', '')[:80]}")
    triggers = d.get("triggers", [])
    fired = False
    fired_condition = None

    for i, trigger in enumerate(triggers):
        kind = trigger["kind"]
        if kind == "recurrence":
            ok, msg = evaluate_recurrence(trigger)
        elif kind == "adjacent-need":
            ok, msg = evaluate_adjacent_need(trigger)
        elif kind == "volume-threshold":
            ok, msg = evaluate_volume_threshold(trigger)
        elif kind == "temporal":
            ok, msg = evaluate_temporal(trigger, d.get("date", ""))
        elif kind == "manual-review":
            ok, msg = evaluate_manual_review(trigger)
        elif kind == "file-content-occurrence-count":
            ok, msg = evaluate_file_content_occurrence_count(trigger)
        else:
            ok, msg = False, f"unknown kind: {kind}"

        marker = "FIRED" if ok else "..."
        print(f"    trigger[{i}] {kind}: {marker} {msg}")
        if ok and not fired:
            fired = True
            fired_condition = msg

    if fired:
        triggered_count += 1
        title = d.get("title", "")
        line = f"::warning title=Deferred Trigger Fired::{def_id}: {title} | condition: {fired_condition}"
        output_lines.append(line)
        # GitHub Actions annotation
        print(line)

# ── Step 3: Summary ──
summary = f"\nDeferred-trigger evaluation complete. {triggered_count} of {len(defs)} fired."
print(summary)
if triggered_count > 0:
    print("Founder should review fired def-XXX and update status (open → triggered)")
    print("by editing the corresponding architecture/deferred-decisions/def-*.cue file.")

# Write summary to GitHub Actions output if available
gh_summary = os.environ.get("GITHUB_STEP_SUMMARY")
if gh_summary and triggered_count > 0:
    with open(gh_summary, "a") as f:
        f.write(f"## Deferred-trigger evaluation\n\n")
        f.write(f"{triggered_count} of {len(defs)} deferrals had a trigger fire:\n\n")
        for line in output_lines:
            f.write(f"- {line}\n")

# Always exit 0 (advisory)
sys.exit(0)
PYEOF

echo "Done."
