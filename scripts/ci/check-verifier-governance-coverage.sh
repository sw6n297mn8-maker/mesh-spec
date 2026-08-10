#!/usr/bin/env bash
set -euo pipefail

# check-verifier-governance-coverage.sh — Cobertura EXAUSTIVA entre os caminhos
# de mutação do Verifier Registry e as ações autorizáveis (adr-189 dec 1/2).
#
# Prova IGUALDADE DE CONJUNTOS (não subset) entre:
#   (a) event types da união #VerifierRegistryEvent ADOTADA, e
#   (b) resultingEventType declarados na Authority Surface
#       (governance/build-time/verifier-governance-authority.cue).
#
# Divisão com o tipo: o sentido (b) ⊆ (a) JÁ é enforçado em cue vet — cada
# resultingEventType é validado contra a união adotada. O valor NOVO deste gate
# é o sentido inverso (a) ⊆ (b): se a união adotada crescer, este gate nasce
# VERMELHO até a Authority Surface evoluir conscientemente — mata o bypass
# silencioso de um caminho de mutação sem ação autorizante.
#
# EXTRAÇÃO HÍBRIDA FAIL-CLOSED (caracterização honesta): a MEMBERSHIP da união é
# descoberta textualmente da definição NORMALIZADA emitida por `cue def` (CUE não
# oferece reflection sobre membros de disjunção); o LITERAL .event de cada membro
# é resolvido SEMANTICAMENTE pelo próprio CUE, via unificação
# (#Member & {event: string}).event. Qualquer forma que deixe de ser extraível
# falha como INFRAESTRUTURA (exit 2) — nunca como cobertura verde.
#
# Exit: 0 ok · 1 divergência de cobertura · 2 infra (introspecção/export falhou).

SCHEMA_PKG="./architecture/artifact-schemas/"
AUTH_PKG="./governance/build-time/"
AUTH_EXPR="verifierGovernanceAuthority.entries"

# ── (a) membership da união adotada (descoberta textual sobre `cue def`) ──
UNION_LINE="$(cue def "${SCHEMA_PKG}" 2>/dev/null | grep -E '^#VerifierRegistryEvent:' || true)"
if [ -z "${UNION_LINE}" ]; then
	echo "::error::coverage: união #VerifierRegistryEvent não localizável na definição normalizada — fail-closed (representação mudou?)." >&2
	exit 2
fi
MEMBERS="$(printf '%s' "${UNION_LINE}" | sed 's/^#VerifierRegistryEvent:[[:space:]]*//' | tr '|' '\n' | tr -d ' ' | grep -E '^#' || true)"
if [ -z "${MEMBERS}" ]; then
	echo "::error::coverage: união localizada mas sem membros extraíveis — fail-closed." >&2
	exit 2
fi

# ── literal .event de cada membro (resolução semântica pelo CUE) ──
ADOPTED=""
for m in ${MEMBERS}; do
	lit="$(cue eval "${SCHEMA_PKG}" -e "(${m} & {event: string}).event" 2>/dev/null | tr -d '"' || true)"
	case "${lit}" in
	"" | *"_|_"* | *" "*)
		echo "::error::coverage: membro ${m} da união sem literal .event resolvível — fail-closed." >&2
		exit 2
		;;
	esac
	ADOPTED="${ADOPTED}${lit}"$'\n'
done

# ── (b) resultingEventType declarados na Authority Surface (semântico) ──
if ! ENTRIES_JSON="$(cue export "${AUTH_PKG}" -e "${AUTH_EXPR}" --out json 2>/dev/null)"; then
	echo "::error::coverage: cue export da Authority Surface falhou — fail-closed." >&2
	exit 2
fi

printf '%s' "${ENTRIES_JSON}" | ADOPTED_LIST="${ADOPTED}" python3 -c '
import json, os, sys

adopted = set(filter(None, os.environ["ADOPTED_LIST"].split()))
if not adopted:
    sys.stderr.write("::error::coverage: conjunto adotado vazio — fail-closed.\n")
    sys.exit(2)

entries = json.load(sys.stdin)
declared = [e["resultingEventType"] for e in entries]
declared_set = set(declared)

if len(declared) != len(declared_set):
    sys.stderr.write("::error::coverage: resultingEventType duplicado na Authority Surface.\n")
    sys.exit(1)

missing = sorted(adopted - declared_set)   # caminho de mutacao SEM acao autorizante
extra = sorted(declared_set - adopted)     # acao apontando para event type inexistente
if missing:
    sys.stderr.write("::error::coverage: event type(s) do Registry sem acao autorizante: %s\n" % ", ".join(missing))
    sys.exit(1)
if extra:
    sys.stderr.write("::error::coverage: acao(oes) apontando para event type inexistente: %s\n" % ", ".join(extra))
    sys.exit(1)

print("coverage ok: %d event type(s) adotado(s) == %d acao(oes) autorizante(s)." % (len(adopted), len(declared_set)))
'
