#!/usr/bin/env bash
set -euo pipefail

# check-verifier-resolution-consumer-declaration.sh — Declaração canônica de
# consumerhood da resolução de verifier (adr-190 item 11).
#
# CONTRATO ESTREITO E VERDADEIRO (leia antes de ampliar a expectativa):
#   Qualquer arquivo .cue em governance/build-time/ que utilize o IDIOMA
#   ATUALMENTE CANÔNICO de re-derivação de contratos de verifier — a
#   comprehension que filtra eventos "verifier-registered" do stream do Registry
#   — DEVE conter a declaração canônica de consumerhood
#   (_verifierResolutionConsumer:).
#
# Idioma e declaração são procurados apenas em linhas NÃO-COMENTADAS: comentário
# que mencione o idioma não compele declaração falsa, e declaração que exista só
# em comentário não satisfaz o gate. Isso REDUZ falso-positivo e falso-verde; não
# os elimina — o detector permanece textual/híbrido e pode coincidir com formas
# não-consumidoras (ten-018).
#
# O QUE ESTE GATE NÃO FAZ (ten-018): ele NÃO prova a norma universal "todo
# consumidor governado da resolução declara consumerhood". Ele detecta OMISSÃO no
# caminho que conhecemos hoje — o idioma canônico. Uma implementação futura que
# resolva verifier por outra construção escapa do detector. A diferença entre a
# norma (semântica) e a cobertura automática (sintática, limitada ao idioma
# conhecido) está registrada em architecture/tension-log/ten-018-*.cue.
#
# Por que a declaração é uma FORMA CUE fechada e não uma string solta: uma
# substring solta contaria menção incidental (comentário + campo = duas
# ocorrências), produzindo falso disparo no sensor de def-085. A declaração
# canônica é um campo hidden, procurado com o dois-pontos.
#
# Exit: 0 ok · 1 arquivo usa o idioma sem declarar consumerhood · 2 infra.

SCOPE_DIR="governance/build-time"
IDIOM='event == "verifier-registered"'
DECLARATION='_verifierResolutionConsumer:'

if [ ! -d "${SCOPE_DIR}" ]; then
	echo "::error::consumer-declaration: diretório ${SCOPE_DIR} ausente — fail-closed." >&2
	exit 2
fi

# Arquivos no escopo que usam o idioma canônico em linha NÃO-COMENTADA.
CANDIDATES="$(grep -rlF "${IDIOM}" --include='*.cue' "${SCOPE_DIR}" 2>/dev/null || true)"
USERS=""
for c in ${CANDIDATES}; do
	if grep -vE '^[[:space:]]*//' "${c}" | grep -qF "${IDIOM}"; then
		USERS="${USERS}${c} "
	fi
done

if [ -z "${USERS}" ]; then
	echo "consumer-declaration ok: nenhum arquivo em ${SCOPE_DIR} usa o idioma canônico de re-derivação (nada a exigir)."
	exit 0
fi

MISSING=""
COUNT=0
for f in ${USERS}; do
	COUNT=$((COUNT + 1))
	if ! grep -vE '^[[:space:]]*//' "${f}" | grep -qF "${DECLARATION}"; then
		MISSING="${MISSING}${f} "
	fi
done

if [ -n "${MISSING}" ]; then
	echo "::error::consumer-declaration: arquivo(s) usam o idioma canônico de re-derivação de verifier SEM a declaração canônica de consumerhood (${DECLARATION}): ${MISSING}" >&2
	exit 1
fi

echo "consumer-declaration ok: ${COUNT} arquivo(s) com o idioma canônico, todos com declaração de consumerhood."
