#!/usr/bin/env bash
set -uo pipefail

# local-gate.sh — Roda localmente o conjunto de gates BLOQUEANTES do CI.
#
# POR QUE EXISTE. Em 2026-08-01 o PR #228 quebrou em cue-validate com
# "Derivado 'structure-index' fora de sync". O agente havia rodado cinco
# verificações antes do push — de MEMÓRIA — e o CI roda onze. A causa não
# foi esquecimento pontual: o conjunto local vivia na cabeça do agente e na
# prosa do CLAUDE.md, enquanto o conjunto real vive nos workflows. Este
# script tira a lista da memória e a põe num arquivo executável.
#
# ── DÍVIDA CONHECIDA, DECLARADA ────────────────────────────────────────
# Este script DUPLICA a lista de passos de .github/workflows/. Isso é
# violação de P0 (localização canônica única) e está aqui de propósito,
# com prazo: a correção certa é INVERTER a direção — um script único
# invocado tanto pelo CI quanto localmente, em vez de duas listas que
# derivam. A inversão NÃO foi feita agora porque tornaria este arquivo o
# ponto único do CI, o que é mudança semântica em enforcement e exige ADR.
# Decisão do founder em 2026-08-01: antes de decidir a camada de gates,
# fazer o LEVANTAMENTO dela (workflows, passos bloqueantes, scripts
# invocados, o que cada um cobre, onde há duplicação) — mesma disciplina
# que o adr-183 pagou em sete rounds. Possivelmente junto da fatia de
# saneamento (def-083).
#
# CONSEQUÊNCIA OPERACIONAL enquanto a dívida existe: passo NOVO adicionado
# a um workflow NÃO aparece aqui sozinho. Quem editar .github/workflows/
# atualiza este script no mesmo commit.
#
# ── COBERTURA ──────────────────────────────────────────────────────────
# COBRE (bloqueantes, em ordem de validate.yml e depois os workflows
# de propósito único):
#   cue vet · testes do runner de triggers · freshness --ci · sync do
#   CLAUDE.md · 3 drift gates de derivados · structural-check runner ·
#   check-self-review · deferred-trigger runner · anti-phantom gate
#
# NÃO COBRE, e é deliberado:
#   ci-liveness — assertivas sobre o texto de validate.yml, inline no
#     yaml; copiá-las aqui seria uma terceira cópia da mesma coisa. Só
#     quebra se alguém editar validate.yml, e aí o CI pega.
#   codegen-validation — gated por checkout cross-repo; não roda local.
#   materialization-freshness --echo/--assert — é gate de ESCRITA (G1/G2/G3
#   do adr-168), roda no ato da proposta, não aqui. Este script roda o
#   modo --ci, que é a rede durável contra colisão add/add.
#
# USO: bash scripts/ci/local-gate.sh
# Saída: uma linha por gate + resumo. Exit 0 se todos passam.

cd "$(git rev-parse --show-toplevel)" || exit 1

FAILED=()
PASSED=0

run_gate() {
    local name="$1"; shift
    local out rc
    out="$("$@" 2>&1)"; rc=$?
    if [ $rc -eq 0 ]; then
        printf '  OK    %s\n' "$name"
        PASSED=$((PASSED + 1))
    else
        printf '  FAIL  %s\n' "$name"
        printf '%s\n' "$out" | tail -20 | sed 's/^/          /'
        FAILED+=("$name")
    fi
}

check_claude_sync() {
    local tmp
    tmp="$(mktemp)"
    cue export ./governance/claude -e output --out text > "$tmp" || return 1
    if ! diff -q CLAUDE.md "$tmp" > /dev/null; then
        echo "CLAUDE.md divergente da fonte. Regenere com:"
        echo "  cue export ./governance/claude -e output --out text > CLAUDE.md"
        rm -f "$tmp"
        return 1
    fi
    rm -f "$tmp"
}

check_phantom() {
    local si ph n
    # O sufixo .cue é OBRIGATÓRIO: cue export recusa arquivo sem extensão
    # conhecida ("unknown file extension").
    si="$(mktemp --suffix=.cue)"; ph="$(mktemp)"
    python3 scripts/ci/generate-structure-index.py . > "$si" || return 1
    cue export "$si" -e structureIndex.phantomCandidates --out json > "$ph" || return 1
    n="$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))))" "$ph")"
    if [ "$n" -gt 0 ]; then
        echo "$n path(s) .cue referenciados no config que não resolvem:"
        python3 -c "import json,sys;[print('- '+p) for p in json.load(open(sys.argv[1]))]" "$ph"
        rm -f "$si" "$ph"
        return 1
    fi
    rm -f "$si" "$ph"
}

echo "local-gate — conjunto bloqueante do CI (ver DÍVIDA CONHECIDA no cabeçalho)"
echo

run_gate "cue vet ./..."                     cue vet ./...
run_gate "testes do runner de triggers"      python3 -m unittest discover -s scripts/ci/tests
run_gate "freshness --ci (colisão add/add)"  bash scripts/ci/materialization-freshness.sh --ci
run_gate "sync do CLAUDE.md"                 check_claude_sync
run_gate "drift: structure-index"            bash scripts/ci/regenerate-derived.sh --check structure-index
run_gate "drift: tree"                       bash scripts/ci/regenerate-derived.sh --check tree
run_gate "drift: README"                     bash scripts/ci/regenerate-derived.sh --check readme
run_gate "structural-check runner"           python3 scripts/ci/structural-check-runner.py .
run_gate "check-self-review"                 bash scripts/ci/check-self-review.sh
run_gate "deferred-trigger runner"           bash scripts/ci/evaluate-deferred-triggers.sh
run_gate "anti-phantom gate"                 check_phantom

echo
if [ ${#FAILED[@]} -eq 0 ]; then
    echo "TODOS OS $PASSED GATES PASSARAM."
    echo "Não cobertos aqui: ci-liveness, codegen-validation (ver cabeçalho)."
    exit 0
fi

echo "FALHOU: ${#FAILED[@]} de $((PASSED + ${#FAILED[@]}))"
for f in "${FAILED[@]}"; do echo "  - $f"; done
exit 1
