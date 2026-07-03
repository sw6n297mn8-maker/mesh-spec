#!/usr/bin/env bash
set -euo pipefail

# evaluate-deferred-triggers.sh — Runner determinístico de triggers
# de deferred-decisions (per adr-062; escopo/exclusões/predicados per adr-166).
#
# Wrapper fino: Step 0 (cue vet sanity) + dispatch para o core testável em
# scripts/ci/evaluate_deferred_triggers.py (extração per adr-166 item 5).
#
# Contratos (detalhados no docstring do .py):
#   - Exclusões de engine por construção (def nunca conta pro próprio sensor)
#   - pathScope obrigatório em recurrence file-content (schema é o gate)
#   - structural-predicate via cue export sobre registry dd-predicates.cue
#   - Malformação → ::error + exit 1 (nunca count 0 silencioso)
#   - Gate de carência (adr-162) avaliado sobre TODOS os triggers disparados
#   - DD_GATE_ENABLED setado → def open além da carência trava o CI (exit 1)

DEFERRED_DIR="architecture/deferred-decisions"

# ── Step 0: cue vet (sanity + gate de malformação de trigger per adr-166) ──

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

# ── Steps 1-3: export + avaliação + summary/gate (core python) ──

echo "Step 1-3: Evaluating triggers..."
python3 scripts/ci/evaluate_deferred_triggers.py

echo "Done."
