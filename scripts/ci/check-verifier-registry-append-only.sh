#!/usr/bin/env bash
set -euo pipefail

# check-verifier-registry-append-only.sh — Dente temporal APPEND-ONLY do
# Verifier Registry (adr-189, Slice C1).
#
# Enforça que a história de verifierRegistry.events da BASE (origin/main) é
# PREFIXO EXATO da do CANDIDATO (working tree): impede rewrite / reorder /
# delete de história já committada.
#
# Divisão de responsabilidades (adr-189) — este gate NÃO reimplementa as outras:
#   - Validade causal/estrutural interna do stream (invariantes R/U + projeção,
#     e.g. "registro válido / grant-após-registro / grant-antes-de-registro")
#     são responsabilidade de `cue vet` sobre `#VerifierRegistry`; este gate não
#     as reimplementa.
#   - A restrição Mesh pós-revogação é responsabilidade do gate
#     terminal-quiescence; este gate não a reimplementa.
# Este gate cobre EXCLUSIVAMENTE imutabilidade histórica base×candidato.
#
# Comparação por IGUALDADE PROFUNDA do JSON semântico exportado pelo CUE —
# reformatar o .cue sem alterar eventos NÃO dispara o gate. É type-agnostic por
# desenho: compara o evento inteiro, sem extrair "alvo" nem conhecer tipos.
#
# Exit: 0 ok · 1 violação (prefixo quebrado) · 2 infra (fetch/export inesperado).
# Pré-requisito local: acesso a origin (git fetch).

REMOTE="origin"
BASE_BRANCH="main"
BASE_REF="${REMOTE}/${BASE_BRANCH}"
REGISTRY_PATH="governance/build-time/verifier-registry.cue"
PKG_DIR="./governance/build-time/"
EXPR="verifierRegistry.events"

# WT_PARENT é o diretório temporário de TODOS os artefatos do gate (worktree da
# base + os dois JSON exportados). Criado cedo para servir a ambos.
WT_PARENT=""
cleanup() {
	if [ -n "${WT_PARENT}" ]; then
		git worktree remove --force "${WT_PARENT}/base" 2>/dev/null || true
		rm -rf "${WT_PARENT}" 2>/dev/null || true
		git worktree prune 2>/dev/null || true
	fi
}
trap cleanup EXIT

# ── base fresca ──
if ! git fetch "${REMOTE}" "${BASE_BRANCH}" --quiet 2>/dev/null; then
	echo "::error::append-only: git fetch ${BASE_REF} falhou — sem base fresca, não avalie." >&2
	exit 2
fi

WT_PARENT="$(mktemp -d)"
WT="${WT_PARENT}/base"
CAND_JSON_FILE="${WT_PARENT}/candidate-events.json"
BASE_JSON_FILE="${WT_PARENT}/base-events.json"

# ── eventos do CANDIDATO (working tree) → arquivo ──
if ! cue export "${PKG_DIR}" -e "${EXPR}" --out json >"${CAND_JSON_FILE}" 2>/dev/null; then
	echo "::error::append-only: cue export do candidato falhou (verifier-registry.cue inválido?)." >&2
	exit 2
fi

# ── eventos da BASE (checkout isolado de origin/main) → arquivo ──
if ! git worktree add --detach --quiet "${WT}" "${BASE_REF}" 2>/dev/null; then
	echo "::error::append-only: git worktree add da base (${BASE_REF}) falhou." >&2
	exit 2
fi
if [ -f "${WT}/${REGISTRY_PATH}" ]; then
	# arquivo presente na base → export DEVE funcionar; erro de export NÃO vira []
	if ! ( cd "${WT}" && cue export "${PKG_DIR}" -e "${EXPR}" --out json ) >"${BASE_JSON_FILE}" 2>/dev/null; then
		echo "::error::append-only: cue export da base falhou — base presente mas não-exportável (não trato como [])." >&2
		exit 2
	fi
else
	# ausência do Registry na base = nascimento esperado do artefato → base vazia
	printf '[]' >"${BASE_JSON_FILE}"
fi

# ── prefixo exato por igualdade profunda do JSON semântico ──
python3 - "${BASE_JSON_FILE}" "${CAND_JSON_FILE}" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    base = json.load(f)
with open(sys.argv[2], encoding="utf-8") as f:
    cand = json.load(f)

if len(cand) < len(base):
    sys.stderr.write(
        f"::error::append-only: candidato tem {len(cand)} evento(s) < base {len(base)} "
        f"— historia encurtada (delete de prefixo).\n")
    sys.exit(1)
for i in range(len(base)):
    if cand[i] != base[i]:  # igualdade profunda dos objetos parseados
        sys.stderr.write(
            f"::error::append-only: evento[{i}] diverge da base "
            f"(rewrite/reorder de historia committada).\n")
        sys.exit(1)
print(f"append-only ok: base ({len(base)}) e prefixo exato do candidato ({len(cand)}).")
PY
