#!/usr/bin/env bash
set -euo pipefail

# regenerate-derived.sh -- Regenera (ou verifica drift de) os 3 derivados de
# discovery: structure-index.cue (adr-090), tree-generated.cue + README.md (adr-115).
# Receita unica consumida pelo gate de CI (validate.yml) E pelo autor (P0, wiring b
# per adr-152, que substituiu o auto-commit pos-merge por gate de drift no PR).
#
# Usage:
#   scripts/ci/regenerate-derived.sh                   regenera os 3 no working tree (autor commita no PR)
#   scripts/ci/regenerate-derived.sh --check           verifica os 3 (drift -> exit 1) -- pre-push local
#   scripts/ci/regenerate-derived.sh --check <alvo>    verifica 1 (structure-index|tree|readme) -- uso do gate
#
# --check NUNCA muta o working tree (regenera em tmp e diffa). Sem flag reescreve os 3.
# NUNCA auto-commita: a escrita do derivado fica no PR governado (adr-152).
#
# Ordem de dependencia (modo regenerar): structure-index -> tree -> README, pois o
# README (cue export ./governance/readme) consome tree-generated.cue. Em --check cada
# alvo e verificado contra suas FONTES; o README e verificado contra o tree-committed
# -- o drift do tree e pego pelo --check do tree (que regenera de _meta.cue), nao
# escondido por um tree-committed-stale. Os 3 --check juntos cobrem a cadeia. (adr-152)

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

SI_PATH="governance/readme/structure-index.cue"
TREE_PATH="governance/readme/tree-generated.cue"
README_PATH="README.md"

gen_structure_index() { python3 scripts/ci/generate-structure-index.py .; }
gen_tree() { python3 scripts/ci/generate-repo-tree.py .; }
gen_readme() { cue export ./governance/readme -e output --out text; }

# check_one <nome> <path-committed> <generator-fn>: regenera em tmp, diffa, ::error:: em drift.
check_one() {
	local name="$1" path="$2" genfn="$3" tmp
	tmp="$(mktemp)"
	"$genfn" >"$tmp"
	if diff -u "$path" "$tmp"; then
		echo "  $name: em sync"
		rm -f "$tmp"
		return 0
	fi
	echo "::error::Derivado '$name' fora de sync ($path). Regenere com 'scripts/ci/regenerate-derived.sh' (sem flag) e commite a regeneracao no PR (adr-152)."
	rm -f "$tmp"
	return 1
}

regen_all() {
	echo "Regenerando os 3 derivados no working tree (structure-index -> tree -> README)..."
	gen_structure_index >"$SI_PATH"
	echo "  $SI_PATH"
	gen_tree >"$TREE_PATH"
	echo "  $TREE_PATH"
	gen_readme >"$README_PATH"
	echo "  $README_PATH"
	echo "Pronto. Revise e commite a regeneracao no PR (NUNCA auto-commit -- adr-152)."
}

MODE="regen"
TARGET="all"
if [[ "${1:-}" == "--check" ]]; then
	MODE="check"
	TARGET="${2:-all}"
fi

if [[ "$MODE" == "regen" ]]; then
	regen_all
	exit 0
fi

rc=0
case "$TARGET" in
structure-index) check_one "structure-index" "$SI_PATH" gen_structure_index || rc=1 ;;
tree) check_one "tree-generated" "$TREE_PATH" gen_tree || rc=1 ;;
readme) check_one "README" "$README_PATH" gen_readme || rc=1 ;;
all)
	check_one "structure-index" "$SI_PATH" gen_structure_index || rc=1
	check_one "tree-generated" "$TREE_PATH" gen_tree || rc=1
	check_one "README" "$README_PATH" gen_readme || rc=1
	;;
*)
	echo "::error::alvo desconhecido '$TARGET' (use: structure-index|tree|readme|all)"
	exit 2
	;;
esac
exit $rc
