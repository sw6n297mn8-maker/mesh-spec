#!/bin/bash
# Hook PreToolUse: bloqueia Write/Edit em artefatos governados
# quando nao existe self-review report com artifactPath correspondente.
#
# Verifica: (1) existencia do report, (2) artifactPath aponta para o artefato.
# Nao verifica: hash do conteudo, freshness temporal do report.
# Camada complementar: CI valida schema completo (ci-sr-01..07).
#
# Manutencao: ao adicionar governed types em self-review-ci-policy.cue,
# atualizar o case statement abaixo.
set -uo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null) || exit 0

[[ -z "$FILE_PATH" || -z "$CWD" ]] && exit 0
[[ "$FILE_PATH" != *.cue ]] && exit 0

CWD="${CWD%/}"
FILE_PATH=$(realpath -m "$FILE_PATH" 2>/dev/null) || true
CWD=$(realpath -m "$CWD" 2>/dev/null) || true

REL_PATH="${FILE_PATH#$CWD/}"

# Arquivo fora do projeto
[[ "$REL_PATH" == "$FILE_PATH" ]] && exit 0

# Self-review reports: sempre permite
[[ "$REL_PATH" == governance/build-time/self-reviews/* ]] && exit 0

# Tipos governados (ref: self-review-ci-policy.cue governedTypes)
GOVERNED=false
case "$REL_PATH" in
  architecture/adrs/adr-[0-9][0-9][0-9]-*.cue)  GOVERNED=true ;;
  domain/domain-definition.cue)                    GOVERNED=true ;;
  architecture/artifact-schemas/*.cue)             GOVERNED=true ;;
  architecture/lenses/*.cue)                       GOVERNED=true ;;
  # Extensao futura: stakeholder-map, task-template, wave-plan
  # Adicionar patterns quando paths forem definidos no repo
esac

[[ "$GOVERNED" == "false" ]] && exit 0

BASENAME=$(basename "$REL_PATH" .cue)
REPORT="$CWD/governance/build-time/self-reviews/${BASENAME}.self-review.cue"

if [[ ! -f "$REPORT" ]]; then
  cat >&2 <<EOF
BLOQUEADO: Self-review report nao encontrado.

Artefato: $REL_PATH
Report esperado: governance/build-time/self-reviews/${BASENAME}.self-review.cue

Execute o protocolo de quality-gate.cue, produza o report, e tente novamente.
EOF
  exit 2
fi

# Valida que o report aponta para este artefato especifico
report_matches_artifact() {
  local report="$1"
  local rel_path="$2"
  local reported_path
  reported_path=$(sed -n 's/^[[:space:]]*artifactPath:[[:space:]]*"\([^"]*\)".*/\1/p' "$report" | head -1) || return 1
  [[ "$reported_path" == "$rel_path" ]]
}

if ! report_matches_artifact "$REPORT" "$REL_PATH"; then
  cat >&2 <<EOF
BLOQUEADO: Self-review report nao corresponde ao artefato.

Artefato: $REL_PATH
Report encontrado: governance/build-time/self-reviews/${BASENAME}.self-review.cue

O campo artifactPath do report nao aponta para este artefato.
Regenere o report com artifactPath apontando para o artefato correto.
EOF
  exit 2
fi

exit 0
