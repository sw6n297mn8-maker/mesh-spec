#!/usr/bin/env bash
set -euo pipefail

# modeling-health.sh — Painel de saúde de modelagem de build-time (def-034 / adr-136).
#
# Reporter read-only das 4 métricas North-Star de modelagem, para revisão founder
# de cadência periódica (gatilho externo, não vigilância contínua — o desenho
# certo para o perfil do founder, per def-034). NÃO é gate: não muta nada, não
# bloqueia, exit 0 sempre. Standalone por design — fora de qualquer workflow CI
# (observabilidade sob demanda, não ruído em todo PR). Precedente: dd-status.sh.
#
# As 4 métricas:
#   (1) Fronteira-volatility  — atividade de edição em contexts/*/canvas.cue na
#       janela (default 30d), via git log. Proxy GROSSO: conta QUALQUER commit que
#       toca um canvas (inclusive refactor mecânico), não só mudança semântica de
#       fronteira (adr-136 N2). Alta volatilidade = sinal (não veredito).
#   (2) Falsificação — declarada (presença): nº de ADRs com o campo
#       falsificationCondition. PRESENÇA, não 'acionada' — medir disparo exigiria
#       campo falsificationActioned no #ADR + detecção (adr-136 N1).
#   (3) Flows verdes — cross-context-flows sem evento órfão, derivado do parse do
#       structural-check-runner (sc-ccf-03, flow-event-closure). X/Y.
#   (4) Cobertura probe — canvases com >=1 agent-probe-record, derivado do parse
#       do runner (sc-apr-02, directory-pair-coverage). X/<nº de canvases>.
#
# Métricas 3 e 4 DERIVAM do structural-check-runner — não recomputam a regra
# (P0/zero-duplicação: o painel é ponteiro para o gate, não 2ª fonte). Se o parse
# divergir do runner, o painel mente: é exatamente a falsificationCondition do
# adr-136 (N3).
#
# Uso: bash scripts/ci/modeling-health.sh   (rodar da raiz do repo)
#   MODELING_HEALTH_WINDOW_DAYS=N → janela da métrica 1 (default 30).
# Toolchain: git + python3 + cue (mesmo do runner de structural-checks). Exit 0 sempre.

WINDOW_DAYS="${MODELING_HEALTH_WINDOW_DAYS:-30}"

# ── Step 0: stdout do structural-check-runner (fonte das métricas 3 e 4) ──
# --mode warn força report-only (exit 0 garantido mesmo se houver reject noutro
# check); || true blinda set -e. Capturamos só stdout; stderr é descartado.
RUNNER_OUT="$(python3 scripts/ci/structural-check-runner.py . --mode warn 2>/dev/null || true)"

export RUNNER_OUT WINDOW_DAYS

python3 - <<'PYEOF'
import glob
import os
import re
import subprocess

try:
    window_days = int(os.environ.get("WINDOW_DAYS", "30"))
except ValueError:
    window_days = 30
runner_out = os.environ.get("RUNNER_OUT", "")


def runner_violation_sources(check_id, splitter):
    # Extrai os 'sources' das linhas de violação de UM check no stdout do runner.
    # Bloco = linha header '[WARN|FAIL] <check_id> (' seguida de linhas '    - '.
    # splitter delimita o source no início da linha de violação (': ' p/ ccf,
    # ' -> ' p/ apr). Retorna set distinto de paths. Se o check não tem violação,
    # ele NÃO aparece no output do runner → set vazio (estado verde natural).
    sources = set()
    in_block = False
    header = re.compile(r"^\[(?:WARN|FAIL)\] " + re.escape(check_id) + r" \(")
    for line in runner_out.splitlines():
        if header.match(line):
            in_block = True
            continue
        if in_block:
            if line.startswith("    - "):
                body = line[len("    - "):]
                sources.add(body.split(splitter, 1)[0].strip())
            else:
                in_block = False
    return sources


# ── Métrica 1: fronteira-volatility (git, janela) ──
canvases = sorted(glob.glob("contexts/*/canvas.cue"))
since = "%d days ago" % window_days
commits = subprocess.run(
    ["git", "log", "--since=" + since, "--format=%H", "--"] + canvases,
    capture_output=True, text=True,
).stdout.split()
n_commits = len([c for c in commits if c.strip()])
touched = subprocess.run(
    ["git", "log", "--since=" + since, "--name-only", "--format=", "--"] + canvases,
    capture_output=True, text=True,
).stdout.splitlines()
n_touched = len({t.strip() for t in touched if t.strip().endswith("canvas.cue")})

# ── Métrica 2: falsificação declarada (presença) ──
adrs = glob.glob("architecture/adrs/*.cue")
n_falsif = 0
for f in adrs:
    try:
        if "falsificationCondition:" in open(f, encoding="utf-8").read():
            n_falsif += 1
    except OSError:
        pass

# ── Métrica 3: flows verdes (parse sc-ccf-03) ──
# Conjunto de flows = MESMO que o gate enxerga: canonicalPathRegex do
# cross-context-flow é '^architecture/cross-context-workflows/[a-z][a-z0-9-]*\.cue$'
# — exclui _meta.cue (#DirectoryMeta) e qualquer arquivo de leading '_'. Globbar
# '*.cue' cru contaria _meta como flow e inflaria o denominador (painel mentiria —
# adr-136 N3). Filtramos pelo basename para casar o denominador do gate.
_flow_re = re.compile(r"^[a-z][a-z0-9-]*\.cue$")
flows = {p for p in glob.glob("architecture/cross-context-workflows/*.cue")
         if _flow_re.match(os.path.basename(p))}
n_flows = len(flows)
flows_red = runner_violation_sources("sc-ccf-03", ":") & flows
n_flows_green = n_flows - len(flows_red)

# ── Métrica 4: cobertura probe (parse sc-apr-02) ──
n_canvases = len(canvases)
missing = runner_violation_sources("sc-apr-02", " -> ") & set(canvases)
n_covered = n_canvases - len(missing)

bar = "=" * 72
print(bar)
print("MODELING-HEALTH DASHBOARD — saúde de modelagem de build-time (def-034)")
print(bar)
print()
print("1. Fronteira-volatility (janela %dd, git log contexts/*/canvas.cue)" % window_days)
print("   %d commit(s) · %d canvas(es) distinto(s) editado(s)" % (n_commits, n_touched))
print("   nota: proxy grosso — conta qualquer edição (incl. refactor mecânico),")
print("         não só mudança semântica de fronteira (adr-136 N2).")
print()
print("2. Falsificação — declarada (presença): %d ADRs" % n_falsif)
print("   nota: PRESENÇA do campo falsificationCondition, NÃO 'acionada'")
print("         (medir disparo é residual — adr-136 N1).")
print()
print("3. Flows verdes (sc-ccf-03 / flow-event-closure): %d/%d" % (n_flows_green, n_flows))
for p in sorted(flows_red):
    print("   - vermelho (evento órfão): %s" % p)
print()
print("4. Cobertura probe (sc-apr-02 / canvas->probe-record): %d/%d" % (n_covered, n_canvases))
if missing:
    print("   - %d canvas(es) sem probe-record" % len(missing))
print()
print(bar)
print("FONTE: métricas 3-4 derivam de scripts/ci/structural-check-runner.py")
print("       (parse de sc-ccf-03 / sc-apr-02). Painel é observabilidade, não gate.")
print(bar)
PYEOF

exit 0
