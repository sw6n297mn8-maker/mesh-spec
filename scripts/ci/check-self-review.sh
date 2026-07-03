#!/usr/bin/env bash
set -euo pipefail

# check-self-review.sh — Enforcement de self-review evidence para CI.
#
# Estratégia:
#   1. cue vet valida self-reviews package (inclui união discriminada)
#   2. REGRA A (adr-167, invariante global de staleness): em TODO run,
#      nenhuma entry transient da bootstrap policy pode ter SRR matching
#      já existente. Violação → falha alto nomeando a entry ("exceção
#      stale: quitar"). Independe do que o PR toca — detecção no primeiro
#      PR após o SRR nascer (mata a invisibilidade; caso real: 7 semanas
#      da PG structural-check, fatia def-012).
#   3. Para cada artefato governado alterado, verifica existência e
#      associação do self-review report correspondente. REGRA B
#      (adr-167): isenção perdoa o passado, não o presente — artefato
#      listado na bootstrap policy NÃO recebe SKIP; o SRR é exigido
#      normalmente. A policy é proveniência histórica (permanent) + fila
#      de quitação enforçada (transient), não mecanismo de isenção.
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
#
# Duas fontes, unidas e deduplicadas:
#   (1) git diff origin/main...HEAD — o que já foi COMMITADO nesta branch vs main.
#   (2) git status --porcelain -uall — o WORKING TREE (staged + unstaged + untracked).
# Sem (2) o gate é cego a mudanças NÃO-commitadas e dá FALSO-VERDE em execução local
# (o diff-vs-main vem vazio → nada é checado → passa). Remédio portado do
# scripts/regenerate.sh do mesh-runtime (rtd-014: `git diff` é cego a untracked;
# unir `git status --porcelain -uall`). Em CI o working tree == HEAD, então (2) é
# vazio e o comportamento é IDÊNTICO ao anterior — o conserto só ADICIONA cobertura
# local, sem alterar a política de enforcement.
changed_committed="$(git diff --name-only origin/main...HEAD)"
changed_worktree="$(git status --porcelain -uall | cut -c4- | sed 's/.* -> //')"
changed_files="$(printf '%s\n%s\n' "$changed_committed" "$changed_worktree" | sort -u)"

artifact_type_for_path() {
  local path="$1"
  case "$path" in
    */_meta.cue)                                            echo "" ;;
    architecture/adrs/*.cue)                                echo "adr" ;;
    architecture/artifact-schemas/*.cue)                    echo "artifact-schema" ;;
    architecture/lenses/*.cue)                              echo "lens" ;;
    architecture/deferred-decisions/def-*.cue)              echo "deferred-decision" ;;
    architecture/production-guides/*.cue)                   echo "production-guide" ;;
    architecture/structural-checks/*.cue)                   echo "structural-check" ;;
    architecture/validation-prompts/validate-*.cue)         echo "validation-prompt" ;;
    contexts/*/canvas.cue)                                  echo "canvas" ;;
    contexts/*/glossary.cue)                                echo "glossary" ;;
    domain/domain-definition.cue)                           echo "domain-definition" ;;
    domain/stakeholder-map.cue)                             echo "stakeholder-map" ;;
    ai-orchestration/agent-instructions/task-templates.cue) echo "task-template" ;;
    governance/wave-plan.cue)                               echo "wave-plan" ;;
    contexts/*/agents/*-primary-agent.cue)                  echo "agent-spec" ;;
    contexts/*/agents/*.governance.cue)                     echo "agent-governance" ;;
    *)                                                      echo "" ;;
  esac
}

# ── Step 2: Regra A (adr-167) — invariante global de staleness ──
#
# Transient-only por contrato: permanent não tem exitCondition (proveniência
# histórica, não dívida). Roda em TODO run, independente de changed_files.

check_stale_transient_exceptions() {
  [[ ! -f "$BOOTSTRAP_POLICY" ]] && return 0
  python3 - "$BOOTSTRAP_POLICY" "$REPORT_DIR" <<'PYEOF'
import glob, re, sys

policy_path, report_dir = sys.argv[1], sys.argv[2]
text = open(policy_path).read()
# Pares (artifactPath, lifecycle) por entry: artifactPath abre o bloco;
# [^}]*? não atravessa entries (blocos não contêm '}' interno).
entries = re.findall(
    r'artifactPath:\s*"([^"]+)"[^}]*?lifecycle:\s*"([^"]+)"', text, re.S)
srr_paths = set()
for report in glob.glob(f"{report_dir}/*.self-review.cue"):
    for m in re.finditer(r'artifactPath:\s*"([^"]+)"', open(report).read()):
        srr_paths.add(m.group(1))
stale = [p for p, lc in entries if lc == "transient" and p in srr_paths]
for p in stale:
    print(f"  ERROR: exceção stale: quitar {p} (SRR matching existe; "
          f"exitCondition satisfeito — remover a entry da bootstrap policy)")
if stale:
    sys.exit(1)
n = sum(1 for _, lc in entries if lc == "transient")
print(f"  Regra A: {n} transient entries, 0 stale.")
PYEOF
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

echo "Regra A: checking transient bootstrap exceptions for staleness..."
if ! check_stale_transient_exceptions; then
  failed=1
fi

while IFS= read -r file; do
  [[ -z "$file" ]] && continue

  artifact_type="$(artifact_type_for_path "$file")"
  [[ -z "$artifact_type" ]] && continue

  # Self-review reports não são governados por si mesmos.
  [[ "$file" == governance/build-time/self-reviews/* ]] && continue

  # Regra B (adr-167): sem SKIP para artefatos na bootstrap policy —
  # isenção perdoa o passado, não o presente. O SRR é exigido normalmente.

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
