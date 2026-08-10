#!/usr/bin/env bash
set -euo pipefail

# check-verifier-registry-terminal-quiescence.sh — Dente de QUIESCÊNCIA TERMINAL
# do Verifier Registry (adr-189, Slice C1).
#
# Regra normativa (adr-189): após um (verifier id, version) atingir "revoked",
# NENHUM evento subsequente dirigido a essa versão é válido. Só "revoked" é
# terminal; "deprecated" NÃO é (admite operações válidas de lifecycle,
# notadamente revoke). Valida o stream candidato INTEIRO (independente da base).
#
# Divisão de responsabilidades (adr-189) — este gate NÃO reimplementa as outras:
#   - validade causal/estrutural interna (invariantes R/U + projeção) é
#     responsabilidade de `cue vet` sobre `#VerifierRegistry`;
#   - imutabilidade histórica base×candidato é responsabilidade do gate append-only.
#
# FAIL-CLOSED: se surgir um tipo de evento cujo alvo (id,version) o gate não
# saiba extrair, FALHA (exit 1) em vez de ignorar — o trust root não passa
# eventos opacos. (Na prática, tipos fora da união fechada #VerifierRegistryEvent
# são rejeitados antes por `cue vet`/`cue export`; este branch é defesa de
# evolução para quando a união ganhar um tipo novo e o gate não for atualizado.)
#
# Exit: 0 ok · 1 violação (evento pós-revoked, ou tipo sem alvo extraível) · 2 infra (export).

PKG_DIR="./governance/build-time/"
EXPR="verifierRegistry.events"

TMP="$(mktemp -d)"
trap 'rm -rf "${TMP}" 2>/dev/null || true' EXIT
EVENTS_FILE="${TMP}/events.json"

if ! cue export "${PKG_DIR}" -e "${EXPR}" --out json >"${EVENTS_FILE}" 2>/dev/null; then
	echo "::error::terminal-quiescence: cue export do candidato falhou (verifier-registry.cue inválido?)." >&2
	exit 2
fi

python3 - "${EVENTS_FILE}" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    events = json.load(f)

REGISTER = "verifier-registered"
TARGET_VIA_VERIFIERREF = {
    "verifier-deprecated", "verifier-revoked",
    "verifier-granted", "verifier-grant-revoked",
}


def target(ev, i):
    et = ev.get("event")
    if et == REGISTER:
        ref = ev.get("contract", {}).get("ref", {})
    elif et in TARGET_VIA_VERIFIERREF:
        ref = ev.get("verifierRef", {})
    else:
        sys.stderr.write(
            f"::error::terminal-quiescence: evento[{i}] tipo {et!r} sem alvo (id,version) "
            f"extraivel — fail-closed (o trust root nao passa eventos opacos).\n")
        sys.exit(1)
    vid, ver = ref.get("id"), ref.get("version")
    if vid is None or ver is None:
        sys.stderr.write(
            f"::error::terminal-quiescence: evento[{i}] ({et}) sem id/version no alvo — fail-closed.\n")
        sys.exit(1)
    return (vid, ver)


revoked = set()
for i, ev in enumerate(events):
    tgt = target(ev, i)
    if tgt in revoked:
        sys.stderr.write(
            f"::error::terminal-quiescence: evento[{i}] ({ev.get('event')}) dirigido a "
            f"{tgt[0]}::{tgt[1]} APOS revoked — violacao de quiescencia terminal.\n")
        sys.exit(1)
    if ev.get("event") == "verifier-revoked":
        revoked.add(tgt)

print(f"terminal-quiescence ok: {len(events)} evento(s), nenhum apos revoked.")
PY
