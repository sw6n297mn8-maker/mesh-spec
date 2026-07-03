package task_specs

taskSpecs: "WI-150": {
	version:     1
	title:       "Gate de frescura de materialização per adr-168 — G1 tip + G2 renumeração + G3 eco; script + testes + step CI + regra no contrato do agente"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-168-materialization-freshness-gate.cue (accepted) — a decisão: o disco decide no ato da escrita; enforcement no ponto de uso (padrão adr-167), zero memória humana. Incidente motivador: WI-147-stale nesta sessão (origin/main avançou 4 PRs entre proposta e escrita, consumindo o WI citado).",
		"scripts/ci/materialization-freshness.sh — o gate (G1 tip via git rev-list HEAD..origin/main; G2 --assert FAM=N re-derivando do tree remoto; G3 --echo; --ci add/add). Nasce neste WI.",
		"scripts/ci/tests/test_materialization_freshness.py — fixtures git reproduzindo o incidente real (G1 nomeia commits; G2 pára em WI-147; exit 0 pós-rebase WI-149; --ci add/add). Nasce neste WI; roda no job da suite adr-166.",
		"governance/claude/config.cue — nova seção 'Freshness de Materialização (gate de escrita)' que institui a regra no contrato do agente; CLAUDE.md regenerado.",
		"O próprio gate re-derivou este número na escrita: WI-150 == próximo-livre em origin/main @ 5925a0d (a fatia nasce validada pela regra que institui).",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-168-materialization-freshness-gate.cue"
		type:     "create"
	}, {
		artifact: "scripts/ci/materialization-freshness.sh"
		type:     "create"
	}, {
		artifact: "scripts/ci/tests/test_materialization_freshness.py"
		type:     "create"
	}, {
		artifact: "governance/claude/config.cue"
		type:     "update"
	}, {
		artifact: ".github/workflows/validate.yml"
		type:     "update"
	}]
	affects: [
		"CLAUDE.md",
	]
	rationale: """
		A frescura da árvore de trabalho era ACIDENTE do container
		efêmero (clone fresco no session-start) decaindo silenciosamente
		pela vida da sessão — a regra de sincronização com o remoto NÃO
		existia escrita em lugar nenhum. O incidente WI-147-stale desta
		sessão a expôs: proposta aprovada citando WI-147, origin/main
		avançou 4 PRs (#196–#199) consumindo WI-147/WI-148, colisão só
		vista no fetch pré-commit. Este WI escreve a regra pela primeira
		vez, JÁ como gate (adr-168): G1 (branch parte do tip), G2
		(números re-derivados do remoto no ato da escrita; divergência →
		STOP + confirmação do arquiteto), G3 (todo reporte de proposta
		abre com eco de estado).

		Commit único no padrão vivo (adr-166/167 empacotaram
		adr+mecanismo+fixtures+wi juntos): adr-168 + script + teste +
		step CI + seção no config.cue + CLAUDE.md regen. O SRR do
		adr-168 (isolated-subagent review) precede a escrita do ADR per
		hook enforce-self-review.

		A fatia nasce conforme a si mesma: branch criada do tip pós-#200
		(a regra que institui G1), e o número WI-150 foi re-derivado
		pelo próprio gate na escrita (G2 confirmou == próximo-livre).

		NON-GOAL registrado no ADR: Modo 2 (ordem perdida no relay) —
		resíduo do desenho de relay, mitigado por ordens consolidadas +
		G3; fora do escopo. DIREÇÃO FUTURA (não executada): portar o
		padrão aos repos irmãos (mesh-runtime/frontend-runtime têm
		rtd-NNN sequencial) quando incidente equivalente ocorrer lá;
		rtd permanece echo-only via relay nesta fatia.

		CLASSIFICAÇÃO: semântica/estrutural (institui regra de governança
		no contrato do agente + gate determinístico) → adr-168 no mesmo
		PR. Reversível com custo (remover script+step+regra re-abre a
		classe WI-147-stale) — metadata no ADR.
		"""
}
