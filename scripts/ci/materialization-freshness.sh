#!/usr/bin/env bash
set -euo pipefail

# materialization-freshness.sh — gate de frescura no ATO da escrita (adr-168).
#
# "o disco decide": antes de materializar uma mudança, a branch DEVE partir do
# tip de origin/main (G1) e os números citados na proposta aprovada DEVEM bater
# com o próximo-livre re-derivado do REMOTO (G2). Todo reporte de proposta abre
# com um eco de estado (G3). Enforcement no PONTO DE USO (padrão adr-167), zero
# memória humana — a frescura deixa de ser acidente do container efêmero
# (clone fresco decaindo pela vida da sessão) e passa a ser condição verificada.
#
# Modos (mutuamente exclusivos):
#   (default)          gate local de materialização: G1 (tip) + G2 (--assert) + G3
#   --echo             só o eco de estado G3 (abre todo reporte de proposta)
#   --ci               invariante durável p/ CI (barato): nenhum arquivo numerado
#                      ADICIONADO pelo diff pode reusar número já vivo na base
#   --assert FAM=N     número citado na proposta; repetível; combina com o default
#
# Famílias numeradas G2 (sequencial-global, derivadas do tree de origin/main):
#   WI  = max(governance/build-time/{task-specs,work-events}/wi-NNN)
#   adr = max(architecture/adrs/adr-NNN)
#   def = max(architecture/deferred-decisions/def-NNN)
#   ten = max(architecture/tension-log/ten-NNN)
# rtd fica FORA (vive no mesh-runtime; echo-only via relay — adr-168 non-goal).
# Escopadas (oq-{bc}-N, sc-*, tq-*, ddp-*) ficam fora: namespace local, sem
# corrida global. PRs são do GitHub.
#
# Exit: 0 ok; 1 violação de gate (G1 stale / G2 renumeração / colisão --ci);
#       2 infraestrutura (fetch de base falhou — sem base fresca, não materialize).

REMOTE="origin"
BASE_BRANCH="main"
BASE_REF="$REMOTE/$BASE_BRANCH"

# ── Derivação de números por família a partir de um ref git ──

_nums_in() { # $1=ref $2=family → números (um por linha, ordenados únicos)
	local ref="$1" fam="$2" paths pat
	case "$fam" in
	WI)  paths="governance/build-time/task-specs governance/build-time/work-events"; pat="wi-[0-9]+" ;;
	adr) paths="architecture/adrs";               pat="adr-[0-9]+" ;;
	def) paths="architecture/deferred-decisions"; pat="def-[0-9]+" ;;
	ten) paths="architecture/tension-log";        pat="ten-[0-9]+" ;;
	*)   echo "materialization-freshness: família desconhecida '$fam' (use WI|adr|def|ten)" >&2; return 3 ;;
	esac
	# shellcheck disable=SC2086
	# `|| true`: família vazia (grep no-match sob pipefail) é estado normal
	# (adr/ten podem não existir no fixture) — não é erro a propagar.
	git ls-tree -r "$ref" --name-only -- $paths 2>/dev/null \
		| grep -oE "$pat" | grep -oE '[0-9]+' | sort -n -u || true
}

_next_num() { # $1=ref $2=family → próximo-livre (max+1; 0-based se família vazia)
	local m
	m="$(_nums_in "$1" "$2" | tail -1)"
	echo "$(( 10#${m:-0} + 1 ))"
}

# ── G3: eco de estado ──

echo_state() {
	local wi adr def ten
	wi="$(_nums_in "$BASE_REF" WI  | tail -1)"
	adr="$(_nums_in "$BASE_REF" adr | tail -1)"
	def="$(_nums_in "$BASE_REF" def | tail -1)"
	ten="$(_nums_in "$BASE_REF" ten | tail -1)"
	local hash; hash="$(git rev-parse --short "$BASE_REF" 2>/dev/null || echo '???????')"
	echo "assumo $BASE_BRANCH @ $hash; últimos consumidos: WI-${wi:-0}, adr-${adr:-0}, def-${def:-0}, ten-${ten:-0} (rtd: echo-only via relay)"
}

# ── fetch da base (G1/G2/echo dependem de origin/main atualizado) ──

fetch_base() {
	if ! git fetch "$REMOTE" "$BASE_BRANCH" --quiet 2>/dev/null; then
		echo "::error::materialization-freshness: git fetch $REMOTE $BASE_BRANCH falhou — sem base fresca, não materialize (rede? credencial?)." >&2
		exit 2
	fi
}

# ── G1: a branch DEVE partir do tip ──

check_tip() {
	local behind
	behind="$(git rev-list --count "HEAD..$BASE_REF" 2>/dev/null || echo 0)"
	if [[ "$behind" -gt 0 ]]; then
		echo "::error::materialization-freshness G1: a branch está $behind commit(s) atrás de $BASE_REF — parta do tip antes de materializar." >&2
		echo "  commits novos em $BASE_REF (rebase/merge antes de escrever):" >&2
		git log --oneline "HEAD..$BASE_REF" | sed 's/^/    /' >&2
		return 1
	fi
	return 0
}

# ── G2: número citado na proposta == próximo-livre re-derivado ──

check_assert() { # $1="FAM=N"
	local fam num next
	fam="${1%%=*}"; num="${1##*=}"
	if ! [[ "$num" =~ ^[0-9]+$ ]]; then
		echo "::error::materialization-freshness G2: --assert '$1' malformado (esperado FAM=N inteiro)." >&2
		return 1
	fi
	next="$(_next_num "$BASE_REF" "$fam")" || return 1
	if [[ "$(( 10#$num ))" -ne "$next" ]]; then
		echo "::error::materialization-freshness G2 STOP renumeração: $fam citado $num ≠ próximo-livre $next em $BASE_REF." >&2
		echo "  o disco avançou desde a proposta. Renumere para $fam-$next e confirme com o arquiteto (1 linha) antes de materializar." >&2
		return 1
	fi
	echo "  G2 ok: $fam-$num == próximo-livre em $BASE_REF."
	return 0
}

# ── --ci: invariante durável (número adicionado não reusa número vivo na base) ──

check_ci() {
	fetch_base
	local base_sha added rc=0
	base_sha="$(git merge-base HEAD "$BASE_REF" 2>/dev/null || echo "$BASE_REF")"
	# arquivos numerados ADICIONADOS por este diff (status A vs merge-base)
	added="$(git diff --diff-filter=A --name-only "$base_sha...HEAD" 2>/dev/null \
		| grep -E '/(wi|adr|def|ten)-[0-9]+.*\.cue$' || true)"
	if [[ -z "$added" ]]; then
		echo "materialization-freshness --ci: nenhum arquivo numerado adicionado; nada a checar."
		return 0
	fi
	local f fam num base_nums
	while IFS= read -r f; do
		[[ -z "$f" ]] && continue
		case "$f" in
		governance/build-time/task-specs/*|governance/build-time/work-events/*) fam="WI" ;;
		architecture/adrs/*)               fam="adr" ;;
		architecture/deferred-decisions/*) fam="def" ;;
		architecture/tension-log/*)        fam="ten" ;;
		*) continue ;;
		esac
		num="$(echo "$f" | grep -oE '(wi|adr|def|ten)-[0-9]+' | grep -oE '[0-9]+' | head -1)"
		base_nums="$(_nums_in "$BASE_REF" "$fam")"
		if echo "$base_nums" | grep -qx "$(( 10#$num ))"; then
			echo "::error::materialization-freshness --ci: $f adiciona $fam-$num que JÁ existe em $BASE_REF (colisão add/add — renumere para o próximo-livre)." >&2
			rc=1
		fi
	done <<< "$added"
	[[ "$rc" -eq 0 ]] && echo "materialization-freshness --ci: nenhum número reusado; ok."
	return "$rc"
}

# ── Dispatch ──

main() {
	local mode="gate" asserts=()
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--echo) mode="echo" ;;
		--ci)   mode="ci" ;;
		--assert) shift; asserts+=("$1") ;;
		--assert=*) asserts+=("${1#--assert=}") ;;
		*) echo "materialization-freshness: argumento desconhecido '$1'" >&2; exit 3 ;;
		esac
		shift
	done

	case "$mode" in
	echo)
		fetch_base
		echo_state
		;;
	ci)
		check_ci
		;;
	gate)
		fetch_base
		echo_state
		local rc=0
		check_tip || rc=1
		local a
		for a in "${asserts[@]:-}"; do
			[[ -z "$a" ]] && continue
			check_assert "$a" || rc=1
		done
		if [[ "$rc" -ne 0 ]]; then
			echo "::error::materialization-freshness: gate REPROVADO — não materialize até resolver (G1/G2 acima)." >&2
			exit 1
		fi
		echo "materialization-freshness: gate ok — pode materializar."
		;;
	esac
}

main "$@"
