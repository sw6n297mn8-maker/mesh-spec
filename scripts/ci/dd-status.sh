#!/usr/bin/env bash
set -euo pipefail

# dd-status.sh — Reporter read-only de status das deferred-decisions.
#
# Complementa evaluate-deferred-triggers.sh (que AVALIA triggers de DDs
# status=open e emite annotations). Este script NÃO avalia triggers nem muta
# nada: apenas REPORTA o estado atual de todas as DDs agrupadas por status,
# dando visibilidade founder-owned sobre o que está open/triggered/resolved/
# withdrawn — em especial DDs triggered que estão paradas há muito tempo sem
# resolução (staleness).
#
# Motivação (per PR follow-up #90): o runner re-avalia stateless e pula
# status != open; uma DD marcada triggered some do radar do runner. Sem um
# resumo dedicado, DDs triggered acumulam sem visibilidade de quanto tempo
# estão pendentes. Este reporter fecha esse gap.
#
# Uso: bash scripts/ci/dd-status.sh
#   DD_STATUS_STALE_DAYS=N  → threshold de staleness para DDs triggered
#                            (default 30). DD triggered há > N dias é flagged
#                            com ⚠ STALE.
#
# Standalone por design: NÃO faz parte de nenhum workflow CI (visibilidade sob
# demanda, evita poluir output de todo PR). Exit 0 sempre (reporter, não gate).
# Sem dependência de gh; só cue + python3 (mesmo toolchain do runner de triggers).

DEFERRED_DIR="architecture/deferred-decisions"

# ── Step 0: cue vet (sanity) ──

if ! cue vet "./$DEFERRED_DIR/" 2>/dev/null; then
  if [[ ! -d "$DEFERRED_DIR" ]] || ! ls "$DEFERRED_DIR"/*.cue >/dev/null 2>&1; then
    echo "No deferred-decisions found; nothing to report."
    exit 0
  fi
  echo "ERROR: cue vet failed for $DEFERRED_DIR" >&2
  exit 1
fi

# ── Step 1: Report ──
#
# NÃO exportamos o JSON via env (valores grandes em env estouram exec → E2BIG
# "Argument list too long"). Como evaluate-deferred-triggers.sh, o python chama
# cue export via subprocess. DEFERRED_DIR + threshold vão por env (pequenos).

export DEFERRED_DIR
export DD_STATUS_STALE_DAYS="${DD_STATUS_STALE_DAYS:-30}"

python3 - <<'PYEOF'
import json
import os
import re
import subprocess
from datetime import date, datetime

deferred_dir = os.environ.get("DEFERRED_DIR", "architecture/deferred-decisions")
json_data = subprocess.check_output(
    ["cue", "export", f"./{deferred_dir}/", "--out", "json"],
    text=True,
)
data = json.loads(json_data)

try:
    stale_days = int(os.environ.get("DD_STATUS_STALE_DAYS", "30"))
except ValueError:
    stale_days = 30

today = date.today()

# ── Dual-source discovery (mesmo contrato de evaluate-deferred-triggers.sh) ──
# (a)+(b) nested em deferredDecisions; (c) top-level keys defXXX. Rekey pela id
# canônica do value, não pela chave do author (que varia entre styles).
def _is_def_value(v):
    if not isinstance(v, dict):
        return False
    vid = v.get("id", "")
    return (isinstance(vid, str)
            and re.match(r"^def-\d{3}$", vid)
            and isinstance(v.get("triggers"), list))

defs = {}
for _key, value in data.get("deferredDecisions", {}).items():
    if _is_def_value(value):
        defs[value["id"]] = value
for _key, value in data.items():
    if _key in ("deferredDecisions", "meta"):
        continue
    if _is_def_value(value):
        defs[value["id"]] = value

# ── Filesystem sanity check (regressão contra discovery drift) ──
import glob as _glob
fs_def_ids = set()
for path in _glob.glob(f"{os.environ.get('DEFERRED_DIR', 'architecture/deferred-decisions')}/def-*.cue"):
    m = re.match(r".*/(def-\d{3})-", path)
    if m:
        fs_def_ids.add(m.group(1))
missing = fs_def_ids - set(defs.keys())
if missing:
    print(f"  ⚠ WARNING: {len(missing)} def-NNN file(s) NOT discovered: {sorted(missing)}")
    print(f"  (discovery drift — mesmo gap rastreado em evaluate-deferred-triggers.sh)")
    print()

def _age_days(date_str):
    try:
        d = datetime.strptime(date_str, "%Y-%m-%d").date()
        return (today - d).days
    except Exception:
        return None

# ── Agrupar por status ──
buckets = {"open": [], "triggered": [], "resolved": [], "withdrawn": [], "_other": []}
for def_id, d in sorted(defs.items()):
    st = d.get("status", "_other")
    buckets.get(st, buckets["_other"]).append((def_id, d))

total = len(defs)
stale_count = 0

print("=" * 72)
print(f"DEFERRED-DECISION STATUS REPORT — {total} DDs (stale threshold: {stale_days}d)")
print("=" * 72)

# ── open ──
print(f"\n── OPEN ({len(buckets['open'])}) ──")
for def_id, d in buckets["open"]:
    triggers = d.get("triggers", [])
    kinds = {}
    for t in triggers:
        k = t.get("kind", "?")
        kinds[k] = kinds.get(k, 0) + 1
    kinds_str = ", ".join(f"{v}×{k}" for k, v in sorted(kinds.items())) or "no triggers"
    age = _age_days(d.get("date", ""))
    age_str = f"{age}d old" if age is not None else "age?"
    print(f"  {def_id}  [{age_str}]  triggers: {kinds_str}")
    print(f"           {d.get('title', '')[:78]}")

# ── triggered (com staleness) ──
print(f"\n── TRIGGERED ({len(buckets['triggered'])}) ──")
for def_id, d in buckets["triggered"]:
    tat = d.get("triggeredAt", "")
    age = _age_days(tat)
    if age is None:
        flag = "  (triggeredAt ausente — schema deveria exigir)"
        age_str = "age?"
    else:
        age_str = f"{age}d since triggered"
        if age > stale_days:
            flag = f"  ⚠ STALE (>{stale_days}d — revisit pendente)"
            stale_count += 1
        else:
            flag = ""
    print(f"  {def_id}  [{age_str}]{flag}")
    print(f"           {d.get('title', '')[:78]}")

# ── resolved ──
print(f"\n── RESOLVED ({len(buckets['resolved'])}) ──")
for def_id, d in buckets["resolved"]:
    rby = d.get("resolvedBy", "(no resolvedBy)")
    print(f"  {def_id}  resolvedBy={rby[:60]}")

# ── withdrawn ──
if buckets["withdrawn"]:
    print(f"\n── WITHDRAWN ({len(buckets['withdrawn'])}) ──")
    for def_id, d in buckets["withdrawn"]:
        rby = d.get("resolvedBy", "(no resolvedBy)")
        print(f"  {def_id}  {rby[:50]}")

# ── other (status inesperado) ──
if buckets["_other"]:
    print(f"\n── OTHER/UNKNOWN STATUS ({len(buckets['_other'])}) ──")
    for def_id, d in buckets["_other"]:
        print(f"  {def_id}  status={d.get('status', '?')}")

# ── Summary ──
print("\n" + "=" * 72)
print(f"SUMMARY: {len(buckets['open'])} open · {len(buckets['triggered'])} triggered "
      f"({stale_count} stale) · {len(buckets['resolved'])} resolved · "
      f"{len(buckets['withdrawn'])} withdrawn")
if stale_count > 0:
    print(f"⚠ {stale_count} triggered DD(s) parada(s) há > {stale_days}d — revisar resolução.")
print("=" * 72)

# Reporter advisory: exit 0 sempre.
PYEOF

exit 0
