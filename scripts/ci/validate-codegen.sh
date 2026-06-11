#!/usr/bin/env bash
# validate-codegen.sh -- harness do golden-example CMT (WI-137 / W006).
#
# O QUE FAZ: delega os 5 passos (gerar -> compilar -> testar -> avaliar gates ->
# gravar evidencia-de-run em scratch) a toolchain distribuida pelo mesh-runtime
# (MESH_CODEGEN_TOOLCHAIN pipeline; adr-148 item 3), rodando A PARTIR deste
# checkout do mesh-spec. A toolchain le o golden-example
# contexts/cmt/golden-examples/bd-mutual-acceptance.cue e os artefatos da fatia,
# re-emite todo o codigo gerado FRESCO da spec num workspace de scratch, compila,
# roda assertion-tests (>=1 valido + >=1 invalido) + contract-tests, e avalia os
# gates de adr-138 item 7.
#
# P1 ESTRITO: o codigo gerado vai SO para scratch (fora desta arvore; a toolchain
# rejeita scratch dentro dela); o mesh-runtime NAO e tocado. Edicao semantica do
# gerado e PROIBIDA (gate ABANDONAR).
#
# CONTRATO DE FALHA (codegen-contract nota 2b; adr-148): falha deterministica
# com EX_CONFIG=78 quando (a) MESH_CODEGEN_TOOLCHAIN ausente; (b) nao resolve
# para um executavel; (c) a identidade/versao da ferramenta nao puder ser
# registrada na evidencia -- versao vazia/falha OU '-dirty' (working tree sujo:
# identidade nao-rastreavel; escape explicito MESH_CODEGEN_ALLOW_DIRTY=1 para
# dev local, com warning logado; NUNCA setado em CI).
#
# EXIT-MAP (pre-fixado; exit codes INFORMAM, o veredito por causa-raiz e do
# founder -- adr-148):
#   CONTINUAR = 0 · PIVOTAR = 75 (EX_TEMPFAIL) · ABANDONAR = 70 (EX_SOFTWARE)
#   78 = EX_CONFIG (contrato de falha acima) · 1 = bug do harness/pipeline
#
# EVIDENCE: este harness e GATE-ONLY. A evidencia produzida pelo run vai para
# <scratch>/evidence/ como artefato de log (descartavel). O artefato canonico
# governance/build-time/codegen-validation-evidence.cue registra runs de
# PROMOCAO com veredito do founder embutido -- write-back e processo humano
# gated (precedente run-001/#126), NUNCA escrita de CI.
set -euo pipefail

readonly EX_CONFIG=78
readonly GOLDEN_EXAMPLE="contexts/cmt/golden-examples/bd-mutual-acceptance.cue"

# (a) variavel ausente -> EX_CONFIG.
TOOLCHAIN="${MESH_CODEGEN_TOOLCHAIN:-}"
if [[ -z "${TOOLCHAIN}" ]]; then
	{
		echo "MESH_CODEGEN_TOOLCHAIN ausente -- o mesh-runtime distribui o executavel (adr-148; codegen-contract 2b)."
		echo "exit ${EX_CONFIG} (EX_CONFIG) deliberado: NAO 0 (falso-verde), NAO 1 (bug)."
	} >&2
	exit "${EX_CONFIG}"
fi

# (b) nao resolve para executavel -> EX_CONFIG.
TOOLCHAIN_BIN="$(command -v -- "${TOOLCHAIN}" || true)"
if [[ -z "${TOOLCHAIN_BIN}" || ! -x "${TOOLCHAIN_BIN}" ]]; then
	echo "MESH_CODEGEN_TOOLCHAIN='${TOOLCHAIN}' nao resolve para um executavel (codegen-contract 2b). exit ${EX_CONFIG}." >&2
	exit "${EX_CONFIG}"
fi

# (c) identidade/versao nao-registravel -> EX_CONFIG.
TOOLCHAIN_VERSION="$("${TOOLCHAIN_BIN}" version 2>/dev/null || true)"
if [[ -z "${TOOLCHAIN_VERSION}" ]]; then
	echo "toolchain nao reporta identidade/versao ('${TOOLCHAIN_BIN} version' vazio/falhou) -- evidencia nao-registravel (codegen-contract 2b). exit ${EX_CONFIG}." >&2
	exit "${EX_CONFIG}"
fi
if [[ "${TOOLCHAIN_VERSION}" == *"-dirty"* ]]; then
	if [[ "${MESH_CODEGEN_ALLOW_DIRTY:-}" == "1" ]]; then
		echo "WARNING: toolchain '-dirty' (versao '${TOOLCHAIN_VERSION}') aceita por MESH_CODEGEN_ALLOW_DIRTY=1 -- dev local APENAS; identidade nao-rastreavel; NUNCA usar em CI." >&2
	else
		echo "toolchain construida de working tree sujo (versao '${TOOLCHAIN_VERSION}') -- identidade nao-rastreavel na evidencia (codegen-contract 2b); rebuild de commit limpo. exit ${EX_CONFIG}." >&2
		exit "${EX_CONFIG}"
	fi
fi
echo "toolchain: mesh-codegen ${TOOLCHAIN_VERSION} (${TOOLCHAIN_BIN})"

# Checkout do mesh-runtime (workspace hand-authored do pipeline): SEMPRE
# explicito via MESH_RUNTIME_DIR -- o layout interno do mesh-runtime e decisao
# runtime-local (adr-148), nao contrato deste harness; nada e derivado dele.
RUNTIME_DIR="${MESH_RUNTIME_DIR:-}"
if [[ -z "${RUNTIME_DIR}" || ! -x "${RUNTIME_DIR}/gradlew" ]]; then
	echo "MESH_RUNTIME_DIR ausente ou invalido ('${RUNTIME_DIR:-}': gradlew nao encontrado) -- aponte o checkout do mesh-runtime. exit ${EX_CONFIG}." >&2
	exit "${EX_CONFIG}"
fi

# Scratch: fora desta arvore (a toolchain rejeita scratch dentro dela).
# Default efemero; MESH_CODEGEN_SCRATCH como override para debugging.
SCRATCH_DIR="${MESH_CODEGEN_SCRATCH:-$(mktemp -d /tmp/mesh-codegen-scratch.XXXXXX)}"

[[ -f "${GOLDEN_EXAMPLE}" ]] || {
	echo "golden-example ausente: ${GOLDEN_EXAMPLE}. exit ${EX_CONFIG}." >&2
	exit "${EX_CONFIG}"
}

# Delegacao: os 5 passos + exit-map vivem na toolchain (mesh-codegen pipeline).
rc=0
"${TOOLCHAIN_BIN}" pipeline \
	--spec "$(pwd)" \
	--runtime "${RUNTIME_DIR}" \
	--scratch "${SCRATCH_DIR}" || rc=$?

echo "harness: exit ${rc} (0 CONTINUAR · 75 PIVOTAR · 70 ABANDONAR · 78 config · 1 bug)."
echo "evidencia de run (log, gate-only): ${SCRATCH_DIR}/evidence/codegen-validation-evidence.cue"
echo "promocao ao artefato canonico = processo humano gated (precedente run-001/#126)."
exit "${rc}"
