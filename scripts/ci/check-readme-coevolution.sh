#!/usr/bin/env bash
set -euo pipefail

# check-readme-coevolution.sh — CI phase: readme-coevolution
#
# Verifica que o estado atual do filesystem está refletido nos blocos
# machine-readable e na árvore visual do README.md. Usa o filesystem
# como fonte de verificação, não o diff — resolve drift legado além
# do delta do PR.
#
# Modos:
#   (sem flag)        — check-only: FAIL se bloco ou árvore inconsistentes
#   --fix             — regenera blocos do filesystem, depois verifica árvore
#   --block <blockId> — output conteúdo esperado de um bloco para stdout
#                       (usado por derived-artifact-sync)
#
# Três classes de trigger:
#   A. Estrutural — diretório depth ≤ 2 existente não declarado
#   B. Tipológico — arquivo existente em architecture/artifact-schemas/ não declarado
#   C. Governança — protocolo/enforcement existente em zonas governadas não declarado
#
# Tree presence check:
#   Após validar/regenerar blocos, verifica que cada item dos blocos
#   tem presença textual no README (busca por basename via grep).
#   Esta é uma heurística deliberada: o sistema não parseia markdown
#   tree syntax. Presença textual do nome do item em qualquer lugar
#   do README é aceita como evidência de documentação.
#
# Uso:
#   ./scripts/ci/check-readme-coevolution.sh                              # CI / check manual
#   ./scripts/ci/check-readme-coevolution.sh --fix                       # pre-commit hook
#   ./scripts/ci/check-readme-coevolution.sh --block repo-structure-paths # derived-artifact-sync

README="README.md"
EXIT_CODE=0
FIX_MODE=false
BLOCK_MODE=""

case "${1:-}" in
    --fix)   FIX_MODE=true ;;
    --block) BLOCK_MODE="${2:-}" ;;
esac

# ── Guarda: README deve existir ──

if [ ! -f "$README" ]; then
    echo "FAIL: $README não encontrado."
    exit 1
fi

# ── Helpers ──

extract_block() {
    local marker="$1"
    sed -n "/BEGIN:${marker}/,/END:${marker}/p" "$README" \
        | grep -v "$marker" \
        | sed 's/^[[:space:]]*//' \
        | grep -v '^$'
}

replace_block() {
    local marker="$1"
    local new_content="$2"
    local tmp="${README}.tmp.$$"

    awk -v marker="$marker" -v content="$new_content" '
        $0 ~ "BEGIN:" marker { print; printf "%s\n", content; skip=1; next }
        $0 ~ "END:" marker   { skip=0 }
        !skip { print }
    ' "$README" > "$tmp"

    if ! diff -q "$README" "$tmp" > /dev/null 2>&1; then
        mv "$tmp" "$README"
        echo "FIX: Bloco $marker atualizado."
        return 0
    else
        rm -f "$tmp"
        return 1
    fi
}

fail() {
    echo "FAIL: $1"
    EXIT_CODE=1
}

warn() {
    echo "WARN: $1"
}

# ── Geração de conteúdo dos blocos a partir do filesystem ──

generate_structure_paths() {
    local -a excluded=(".git" ".github" "cue.mod")
    git ls-tree -d --name-only -r HEAD | while IFS= read -r dir; do
        local depth
        depth=$(echo "$dir" | tr -cd '/' | wc -c)
        [ "$depth" -gt 1 ] && continue
        local skip=false
        for prefix in "${excluded[@]}"; do
            [[ "$dir" == "$prefix" || "$dir" == "$prefix/"* ]] && skip=true && break
        done
        [ "$skip" = true ] && continue
        echo "${dir}/"
    done | sort -u
}

generate_artifact_schemas() {
    local schema_dir="architecture/artifact-schemas"
    [ -d "$schema_dir" ] || return
    for f in "$schema_dir"/*.cue; do
        [ -f "$f" ] || continue
        basename "$f"
    done | sort
}

generate_governance_protocols() {
    # Inclui protocolos de governança e enforcement tooling operacional.
    # O nome "governance-protocols" é mantido por estabilidade de contrato;
    # o escopo real inclui qualquer arquivo operacional nas zonas listadas.
    local -a zones=(
        "governance"
        "governance/build-time"
        "governance/claude"
        "scripts/ci"
        "scripts/hooks"
    )
    for zone in "${zones[@]}"; do
        [ -d "$zone" ] || continue
        for f in "$zone"/*; do
            [ -f "$f" ] || continue
            echo "$f"
        done
    done | sort
}

# ── Check: blocos contra filesystem ──

check_block() {
    local block_name="$1"
    local current_content="$2"
    local expected_content="$3"
    local item_type="$4"

    if [ -z "$current_content" ]; then
        warn "Bloco $block_name não encontrado no README.md — trigger inoperante."
        return
    fi

    # Items no filesystem não declarados no bloco
    while IFS= read -r item; do
        [ -z "$item" ] && continue
        if ! echo "$current_content" | grep -qF "$item"; then
            fail "$item_type '$item' existe mas não consta em $block_name"
        fi
    done <<< "$expected_content"

    # Items no bloco que não existem no filesystem
    while IFS= read -r declared; do
        [ -z "$declared" ] && continue
        if ! echo "$expected_content" | grep -qF "$declared"; then
            warn "$item_type '$declared' declarado em $block_name mas não existe no filesystem"
        fi
    done <<< "$current_content"
}

# ── Check: presença textual no README ──
#
# Heurística deliberada: busca pelo basename do item no README inteiro.
# Não parseia markdown tree syntax. Presença textual é aceita como
# evidência de documentação. Falsos negativos raros — filenames são
# suficientemente específicos para evitar ambiguidade.

check_textual_presence() {
    local block_name="$1"
    local items="$2"
    local item_type="$3"

    while IFS= read -r item; do
        [ -z "$item" ] && continue
        local search_term
        search_term=$(basename "$item")
        if ! grep -qF "$search_term" "$README"; then
            fail "$item_type '$item' consta em $block_name mas não aparece no texto do README"
        fi
    done <<< "$items"
}

# ── Block mode: output single block content to stdout ──
# Used by derived-artifact-sync to compare expected vs actual.

if [ -n "$BLOCK_MODE" ]; then
    case "$BLOCK_MODE" in
        repo-structure-paths)      generate_structure_paths ;;
        repo-artifact-schemas)     generate_artifact_schemas ;;
        repo-governance-protocols) generate_governance_protocols ;;
        *) echo "ERROR: unknown block '$BLOCK_MODE'" >&2; exit 1 ;;
    esac
    exit 0
fi

# ── Main ──

echo "=== readme-coevolution: Trigger A (estrutural) ==="
expected_paths=$(generate_structure_paths)
current_paths=$(extract_block "repo-structure-paths")
if [ "$FIX_MODE" = true ] && [ -n "$current_paths" ]; then
    replace_block "repo-structure-paths" "$expected_paths" && current_paths="$expected_paths"
fi
check_block "repo-structure-paths" "$current_paths" "$expected_paths" "Diretório"
check_textual_presence "repo-structure-paths" "$expected_paths" "Diretório"

echo ""
echo "=== readme-coevolution: Trigger B (tipológico) ==="
expected_schemas=$(generate_artifact_schemas)
current_schemas=$(extract_block "repo-artifact-schemas")
if [ "$FIX_MODE" = true ] && [ -n "$current_schemas" ]; then
    replace_block "repo-artifact-schemas" "$expected_schemas" && current_schemas="$expected_schemas"
fi
check_block "repo-artifact-schemas" "$current_schemas" "$expected_schemas" "Artifact schema"
check_textual_presence "repo-artifact-schemas" "$expected_schemas" "Artifact schema"

echo ""
echo "=== readme-coevolution: Trigger C (governança) ==="
expected_protocols=$(generate_governance_protocols)
current_protocols=$(extract_block "repo-governance-protocols")
if [ "$FIX_MODE" = true ] && [ -n "$current_protocols" ]; then
    replace_block "repo-governance-protocols" "$expected_protocols" && current_protocols="$expected_protocols"
fi
check_block "repo-governance-protocols" "$current_protocols" "$expected_protocols" "Protocolo"
check_textual_presence "repo-governance-protocols" "$expected_protocols" "Protocolo"

echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
    echo "OK: README coevolução verificada — blocos e presença textual consistentes."
else
    echo "RESULTADO: Findings acima requerem atualização do README.md."
fi

exit "$EXIT_CODE"
