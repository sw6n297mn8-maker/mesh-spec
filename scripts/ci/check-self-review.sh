#!/usr/bin/env bash
set -euo pipefail

# check-self-review.sh — Enforcement de self-review evidence para CI.
#
# Estratégia:
#   1. cue vet valida self-reviews package (inclui união discriminada)
#   2. Para cada artefato governado alterado, verifica existência e
#      associação do self-review report correspondente.
#   3. Bootstrap exceptions consultadas antes de exigir report.
#
# Limitação conhecida: campos extraídos via regex Python.
# Migrar para cue export quando pipeline suportar.
#
# Pré-requisito para execução local: git fetch origin main

REPORT_DIR="governance/build-time/self-reviews"
BOOTSTRAP_POLICY="governance/build-time/self-review-bootstrap-policy.cue"

# ── Step 0: cue vet da package self_reviews ──

echo "Step 0: Validating CUE structural integrity..."
if [[ -d "$REPORT_DIR" ]] && ls "$REPORT_DIR"/*.cue >/dev/null 2>&1; then
  if ! cue vet "./$REPORT_DIR/"; then
    echo "ERROR: cue vet failed for $REPORT_DIR"
    exit 1
  fi
  echo "  cue vet passed for self-reviews."
else
  echo "  No self-review reports found; skipping cue vet."
fi

# ── Step 1: Identificar artefatos governados alterados ──

changed_files="$(git diff --name-only origin/main...HEAD)"

artifact_type_for_path() {
  local path="$1"
  case "$path" in
    architecture/adrs/*.cue)                                echo "adr" ;;
    architecture/artifact-schemas/*.cue)                    echo "artifact-schema" ;;
    architecture/lenses/*.cue)                              echo "lens" ;;
    domain/domain-definition.cue)                           echo "domain-definition" ;;
    domain/stakeholder-map.cue)                             echo "stakeholder-map" ;;
    ai-orchestration/agent-instructions/task-templates.cue) echo "task-template" ;;
    governance/wave-plan.cue)                               echo "wave-plan" ;;
    contexts/*/agents/*-primary-agent.cue)                  echo "agent-spec" ;;
    contexts/*/agents/*.governance.cue)                     echo "agent-governance" ;;
    *)                                                      echo "" ;;
  esac
}

# ── Step 2: Bootstrap exceptions ──

is_bootstrap_exempt() {
  local path="$1"
  [[ ! -f "$BOOTSTRAP_POLICY" ]] && { echo "false"; return; }

  python3 -c "
import re, sys
text = open(sys.argv[1]).read()
mode = re.search(r'mode:\s*\"([^\"]+)\"', text)
if not mode or mode.group(1) != 'bootstrap-exception':
    print('false'); sys.exit(0)
paths = re.findall(r'artifactPath:\s*\"([^\"]+)\"', text)
print('true' if sys.argv[2] in paths else 'false')
" "$BOOTSTRAP_POLICY" "$path"
}

# ── Step 3: Associação report↔artefato ──

find_report_for_artifact() {
  local artifact_path="$1"
  [[ ! -d "$REPORT_DIR" ]] && return 1

  for report in "$REPORT_DIR"/*.self-review.cue; do
    [[ -f "$report" ]] || continue
    if grep -q "artifactPath: *\"${artifact_path}\"" "$report"; then
      echo "$report"
      return 0
    fi
  done
  return 1
}

# ── Step 4: Validações relacionais por report ──

check_artifact_type_match() {
  local expected_type="$1" report="$2"
  python3 -c "
import re, sys
text = open(sys.argv[1]).read()
m = re.search(r'artifactType:\s*\"([^\"]+)\"', text)
if not m: sys.exit('missing artifactType in report')
if m.group(1) != sys.argv[2]:
    sys.exit(f'artifactType mismatch: expected {sys.argv[2]}, got {m.group(1)}')
" "$report" "$expected_type"
}

check_round_count() {
  local report="$1"
  python3 -c "
import re, sys
text = open(sys.argv[1]).read()
m = re.search(r'roundsExecuted:\s*([0-9]+)', text)
if not m: sys.exit('missing roundsExecuted')
rounds = int(m.group(1))
entries = len(re.findall(r'\bround:\s+[0-9]+', text))
if entries != rounds:
    sys.exit(f'roundDetails count ({entries}) != roundsExecuted ({rounds})')
" "$report"
}

# ── Main ──

echo "Checking self-review enforcement..."
failed=0

while IFS= read -r file; do
  [[ -z "$file" ]] && continue

  artifact_type="$(artifact_type_for_path "$file")"
  [[ -z "$artifact_type" ]] && continue

  # Self-review reports não são governados por si mesmos.
  [[ "$file" == governance/build-time/self-reviews/* ]] && continue

  exempt="$(is_bootstrap_exempt "$file")"
  if [[ "$exempt" == "true" ]]; then
    echo "  SKIP (bootstrap-exempt): $file"
    continue
  fi

  echo "  CHECK: $file ($artifact_type)"

  if ! report="$(find_report_for_artifact "$file")"; then
    echo "    ERROR: missing self-review report"
    failed=1
    continue
  fi

  echo "    Report: $report"

  if ! check_artifact_type_match "$artifact_type" "$report"; then
    echo "    ERROR: artifactType mismatch"
    failed=1
  fi

  if ! check_round_count "$report"; then
    echo "    ERROR: roundDetails count mismatch"
    failed=1
  fi

done <<< "$changed_files"

if [[ "$failed" -ne 0 ]]; then
  echo "Self-review enforcement FAILED."
  exit 1
fi

echo "Self-review enforcement PASSED."
