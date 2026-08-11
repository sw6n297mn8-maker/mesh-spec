#!/usr/bin/env bash
set -euo pipefail

# check-verifier-resolution-consumer-declaration.sh — Consumerhood da resolução
# de verifier via abstração canônica (adr-190 item 11 [norma] + adr-191 dec 7
# [contrato de enforcement re-apontado]).
#
# CONTRATO ESTREITO E VERDADEIRO — três regras sobre .cue em governance/build-time/,
# sempre em linhas NÃO-COMENTADAS; verifier-resolution.cue (a DEFINIÇÃO da
# abstração) está isento de R1 e é a única morada legal do idioma e dos internals:
#   R1 (declaração): arquivo que INSTANCIA/UNIFICA #VerifierResolution — o
#      token em posição de binding (após ':' ou '=', ou seguido de '&') — DEVE
#      conter a declaração canônica _verifierResolutionConsumer: (aninhada, per
#      adr-190 item 11). O arquivo que define a abstração não é consumidor;
#      menção em comentário ou em prosa de string (fora de binding) não conta.
#   R2 (anti-bypass do idioma): a comprehension crua de re-derivação — filtro de
#      eventos "verifier-registered" — FORA de verifier-resolution.cue é
#      VIOLAÇÃO: re-derivar fora da abstração é bypass da localização canônica
#      (P0), não consumerhood legítima.
#   R3 (anti-bypass de internals): o token _resolvableRefKeys FORA de
#      verifier-resolution.cue é VIOLAÇÃO — hidden em CUE é package-scoped e o
#      compilador NÃO impede o acesso dentro do package (adr-191 dec 4); este é
#      o observador textual explícito dessa fronteira.
#
# O QUE ESTE GATE NÃO FAZ (ten-018): não prova a norma universal de consumerhood
# nem detecta uma implementação futura da MESMA semântica por construção
# sintaticamente nova. R1-R3 cobrem o caminho canônico e os DOIS bypasses
# conhecidos; o detector permanece textual. Ignorar linhas comentadas REDUZ
# falso-positivo e falso-verde; não os elimina.
#
# Exit: 0 ok · 1 violação (R1, R2 ou R3) · 2 infra.

SCOPE_DIR="governance/build-time"
DEF_FILE="${SCOPE_DIR}/verifier-resolution.cue"
ABSTRACTION_BINDING='([:=][[:space:]]*#VerifierResolution([^A-Za-z0-9_]|$))|(#VerifierResolution[[:space:]]*&)'
IDIOM='event == "verifier-registered"'
INTERNALS='_resolvableRefKeys'
DECLARATION='_verifierResolutionConsumer:'

if [ ! -d "${SCOPE_DIR}" ]; then
	echo "::error::consumer-declaration: diretório ${SCOPE_DIR} ausente — fail-closed." >&2
	exit 2
fi

# linhas não-comentadas de um arquivo
noncomment() { grep -vE '^[[:space:]]*//' "$1"; }

R1_MISSING=""
R2_BYPASS=""
R3_BYPASS=""
CONSUMERS=0

while IFS= read -r f; do
	[ "${f}" = "${DEF_FILE}" ] && continue
	nc="$(noncomment "${f}")"
	if printf '%s' "${nc}" | grep -qF "${IDIOM}"; then
		R2_BYPASS="${R2_BYPASS}${f} "
	fi
	if printf '%s' "${nc}" | grep -qF "${INTERNALS}"; then
		R3_BYPASS="${R3_BYPASS}${f} "
	fi
	if printf '%s' "${nc}" | grep -qE "${ABSTRACTION_BINDING}"; then
		CONSUMERS=$((CONSUMERS + 1))
		if ! printf '%s' "${nc}" | grep -qF "${DECLARATION}"; then
			R1_MISSING="${R1_MISSING}${f} "
		fi
	fi
done < <(find "${SCOPE_DIR}" -name '*.cue' -type f | sort)

FAIL=0
if [ -n "${R2_BYPASS}" ]; then
	echo "::error::consumer-declaration R2: idioma cru de re-derivação (${IDIOM}) fora de ${DEF_FILE} — bypass da abstração canônica (adr-191 dec 7): ${R2_BYPASS}" >&2
	FAIL=1
fi
if [ -n "${R3_BYPASS}" ]; then
	echo "::error::consumer-declaration R3: acesso a ${INTERNALS} fora de ${DEF_FILE} — bypass de internals (adr-191 dec 4/7): ${R3_BYPASS}" >&2
	FAIL=1
fi
if [ -n "${R1_MISSING}" ]; then
	echo "::error::consumer-declaration R1: arquivo(s) instanciam/unificam #VerifierResolution (binding) SEM a declaração canônica de consumerhood (${DECLARATION}): ${R1_MISSING}" >&2
	FAIL=1
fi
[ "${FAIL}" -eq 1 ] && exit 1

if [ "${CONSUMERS}" -eq 0 ]; then
	echo "consumer-declaration ok: nenhum consumidor da abstração canônica em ${SCOPE_DIR} (nada a exigir); zero bypass."
else
	echo "consumer-declaration ok: ${CONSUMERS} consumidor(es) da abstração canônica, todos com declaração; zero bypass."
fi
