#!/usr/bin/env bash
set -euo pipefail

# check-readme-coevolution.sh — CI phase: readme-coevolution
#
# Valida coevolução entre filesystem (versionável), tree.entries e
# README.md materializado. Modo único (per ADR-051).
#
# Falha com exit 1 se:
#   (1) algum tree.entries[].path não existir no filesystem;
#   (2) algum diretório governado do filesystem (após aplicar
#       tooling.excludedPaths como prefixos) não aparecer em
#       tree.entries;
#   (3) README.md materializado divergir da saída de
#       cue export ./governance/readme -e output --out text.
#
# "Diretório governado" = diretório que contém arquivo versionável
# (tracked ou untracked-não-ignorado) — derivado de git ls-files.
# .gitignore decide o que é local; CUE decide o que é excluído de
# governance.
#
# Histórico: ADR-016/ADR-017 estabeleceram blocos machine-readable
# com auto-fix por blockId. ADR-051 deprecou em favor de tree.entries
# como SoT canônica. Flags --fix e --block removidas; regeneração de
# README.md é comando explícito (cue export) chamado fora do script.

README="README.md"
CONFIG_PKG="./governance/readme"
REPO_STRUCTURE_PKG="./governance"
EXIT_CODE=0

fail() { echo "FAIL: $1"; EXIT_CODE=1; }

# ── Guarda: raiz do repo, README, e tooling ──

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "FAIL: não foi possível localizar a raiz do repo via git."
    exit 1
}
cd "$ROOT"

[ -f "$README" ] || { echo "FAIL: $README não encontrado."; exit 1; }
command -v cue >/dev/null 2>&1 || { echo "FAIL: cue CLI não encontrada no PATH."; exit 1; }
command -v jq  >/dev/null 2>&1 || { echo "FAIL: jq não encontrado no PATH."; exit 1; }

# ── Carregar tree.entries do config.cue ──

DECLARED_PATHS="$(
    cue export "$CONFIG_PKG" -e 'config.tree.entries' --out json \
        | jq -r '.[].path' \
        | sed 's:/$::' \
        | sort -u
)"

if [ -z "$DECLARED_PATHS" ]; then
    echo "FAIL: tree.entries vazio em $CONFIG_PKG/config.cue."
    exit 1
fi

# ── Carregar exclusões via entrypoint estável tooling.excludedPaths ──
# Política vive no CUE; bash apenas executa.

EXCLUDED_PREFIXES="$(
    cue export "$REPO_STRUCTURE_PKG" -e 'tooling.excludedPaths' --out json \
        | jq -r '.[]' \
        | sed 's:/$::' \
        | sort -u
)"

is_excluded() {
    local path="$1"
    while IFS= read -r prefix; do
        [ -z "$prefix" ] && continue
        [[ "$path" == "$prefix" || "$path" == "$prefix/"* ]] && return 0
    done <<< "$EXCLUDED_PREFIXES"
    return 1
}

# ── Enumerar diretórios governados ──
# Fonte: arquivos versionáveis do git (tracked + untracked-não-ignorado).
# .gitignore filtra clutter local; tooling.excludedPaths filtra escopo
# de governance. Cada arquivo contribui o diretório que o contém.

GOVERNED_DIRS="$(
    {
        git ls-files
        git ls-files --others --exclude-standard
    } \
        | awk -F/ 'NF>1 {
            path=$1
            for (i=2; i<NF; i++) path=path "/" $i
            print path
        }' \
        | sort -u \
        | while IFS= read -r dir; do
            [ -z "$dir" ] && continue
            is_excluded "$dir" && continue
            echo "$dir"
        done \
        | sort -u
)"

# ── Check 1: cada tree.entries[].path existe no filesystem ──

echo "=== readme-coevolution: Check 1 (tree.entries -> filesystem) ==="
while IFS= read -r path; do
    [ -z "$path" ] && continue
    [ -d "$path" ] || fail "tree.entries declara '$path/' mas o diretório não existe no filesystem"
done <<< "$DECLARED_PATHS"

# ── Check 2: cada diretório governado aparece em tree.entries ──

echo ""
echo "=== readme-coevolution: Check 2 (filesystem -> tree.entries) ==="
while IFS= read -r dir; do
    [ -z "$dir" ] && continue
    if ! grep -qxF "$dir" <<< "$DECLARED_PATHS"; then
        fail "Diretório governado '$dir/' contém arquivo versionável mas não consta em tree.entries"
    fi
done <<< "$GOVERNED_DIRS"

# ── Check 3: README.md materializado equivale ao export do template ──
# Compara arquivo-vs-arquivo via tempfile (estável para arquivos grandes).

echo ""
echo "=== readme-coevolution: Check 3 (README.md <-> cue export) ==="
TMP_EXPECTED="$(mktemp)"
trap 'rm -f "$TMP_EXPECTED"' EXIT
cue export "$CONFIG_PKG" -e output --out text > "$TMP_EXPECTED"
if ! diff -q "$TMP_EXPECTED" "$README" >/dev/null 2>&1; then
    fail "README.md está stale — diverge da saída de 'cue export $CONFIG_PKG -e output --out text'. Regenere com: cue export $CONFIG_PKG -e output --out text > README.md"
fi

echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
    echo "OK: README coevolução verificada — tree.entries, filesystem e README.md materializado consistentes."
else
    echo "RESULTADO: findings acima requerem correção em config.cue, no filesystem, ou regeneração do README."
fi

exit "$EXIT_CODE"
