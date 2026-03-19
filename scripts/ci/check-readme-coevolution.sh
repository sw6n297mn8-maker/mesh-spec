#!/usr/bin/env bash
set -euo pipefail

# check-readme-coevolution.sh — CI phase: readme-coevolution
#
# Verifica que o estado atual do filesystem está refletido nos blocos
# machine-readable do README.md. Usa o filesystem como fonte de
# verificação, não o diff — resolve drift legado além do delta do PR.
#
# Três classes de trigger:
#   A. Estrutural — diretório depth ≤ 2 existente não declarado
#   B. Tipológico — arquivo existente em architecture/artifact-schemas/ não declarado
#   C. Governança — protocolo/enforcement existente em zonas governadas não declarado
#
# Uso: ./scripts/ci/check-readme-coevolution.sh

README="README.md"
EXIT_CODE=0

# ── Helpers ──

extract_block() {
    local marker="$1"
    sed -n "/BEGIN:${marker}/,/END:${marker}/p" "$README" \
        | grep -v "$marker" \
        | sed 's/^[[:space:]]*//' \
        | grep -v '^$'
}

fail() {
    echo "FAIL: $1"
    EXIT_CODE=1
}

warn() {
    echo "WARN: $1"
}

# ── Trigger A: Estrutural (diretórios depth ≤ 2) ──

check_structural() {
    local known_paths
    known_paths=$(extract_block "repo-structure-paths")
    if [ -z "$known_paths" ]; then
        warn "Bloco repo-structure-paths não encontrado no README.md — trigger A inoperante."
        return
    fi

    local -a excluded=(".git/" ".github/" "cue.mod/")

    # Diretórios que existem no HEAD
    while IFS= read -r dir; do
        dir="${dir}/"
        # Profundidade ≤ 2
        local depth
        depth=$(echo "${dir%/}" | tr -cd '/' | wc -c)
        [ "$depth" -gt 2 ] && continue
        # Excluir plataforma
        local skip=false
        for prefix in "${excluded[@]}"; do
            [[ "$dir" == "$prefix"* ]] && skip=true && break
        done
        [ "$skip" = true ] && continue
        # Verificar contra bloco
        if ! echo "$known_paths" | grep -qF "$dir"; then
            fail "Diretório '$dir' existe mas não consta em repo-structure-paths"
        fi
    done < <(git ls-tree -d --name-only -r HEAD | sed 's|$||' | sort -u)

    # Warn: items no bloco que não existem no filesystem
    while IFS= read -r declared; do
        [ -z "$declared" ] && continue
        if [ ! -d "${declared%/}" ]; then
            warn "Diretório '$declared' declarado em repo-structure-paths mas não existe no filesystem"
        fi
    done <<< "$known_paths"
}

# ── Trigger B: Tipológico (artifact schemas) ──

check_artifact_schemas() {
    local known_schemas
    known_schemas=$(extract_block "repo-artifact-schemas")
    if [ -z "$known_schemas" ]; then
        warn "Bloco repo-artifact-schemas não encontrado no README.md — trigger B inoperante."
        return
    fi

    local schema_dir="architecture/artifact-schemas"

    # Arquivos que existem
    if [ -d "$schema_dir" ]; then
        for f in "$schema_dir"/*.cue; do
            [ -f "$f" ] || continue
            local basename
            basename=$(basename "$f")
            if ! echo "$known_schemas" | grep -qF "$basename"; then
                fail "Artifact schema '$basename' existe mas não consta em repo-artifact-schemas"
            fi
        done
    fi

    # Warn: schemas no bloco que não existem
    while IFS= read -r declared; do
        [ -z "$declared" ] && continue
        if [ ! -f "$schema_dir/$declared" ]; then
            warn "Schema '$declared' declarado em repo-artifact-schemas mas não existe em $schema_dir/"
        fi
    done <<< "$known_schemas"
}

# ── Trigger C: Governança (protocolos e enforcement) ──

check_governance_protocols() {
    local known_protocols
    known_protocols=$(extract_block "repo-governance-protocols")
    if [ -z "$known_protocols" ]; then
        warn "Bloco repo-governance-protocols não encontrado no README.md — trigger C inoperante."
        return
    fi

    # Zonas governadas (depth 1 dentro de cada zona)
    local -a zones=(
        "governance"
        "governance/build-time"
        "governance/claude"
        "scripts/ci"
    )

    for zone in "${zones[@]}"; do
        [ -d "$zone" ] || continue
        for f in "$zone"/*; do
            [ -f "$f" ] || continue
            if ! echo "$known_protocols" | grep -qF "$f"; then
                fail "Protocolo '$f' existe mas não consta em repo-governance-protocols"
            fi
        done
    done

    # Warn: items no bloco que não existem
    while IFS= read -r declared; do
        [ -z "$declared" ] && continue
        if [ ! -f "$declared" ]; then
            warn "Protocolo '$declared' declarado em repo-governance-protocols mas não existe"
        fi
    done <<< "$known_protocols"
}

# ── Main ──

echo "=== readme-coevolution: Trigger A (estrutural) ==="
check_structural

echo ""
echo "=== readme-coevolution: Trigger B (tipológico) ==="
check_artifact_schemas

echo ""
echo "=== readme-coevolution: Trigger C (governança) ==="
check_governance_protocols

echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
    echo "OK: README coevolução verificada — todos os items existentes estão declarados."
else
    echo "RESULTADO: Findings acima requerem atualização do README.md."
fi

exit "$EXIT_CODE"
