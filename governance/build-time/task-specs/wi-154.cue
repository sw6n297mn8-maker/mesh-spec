package task_specs

taskSpecs: "WI-154": {
	version:     1
	title:       "Higiene A do gate agente↔modelo (adr-175) — coevoluir os agent-specs de bdg, p2p e ssc com os deltas das fatias WI-151/152/153: cobertura em operationalScope/actions, exclusões conscientes onde legítimo, e correção da prosa envelhecida (classe-2)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-175-agent-model-coverage-gate.cue — a decisão que esta fatia executa: gate sc-ag-02 born-warn acusando o baseline; esta higiene fecha a parcela do baseline causada pelas 3 fatias (bdg 3, p2p 16, ssc 5 itens no anúncio de ativação). Critério de exclusão legítima vive no adr-175 decisão 3 — exclusões propostas aqui devem satisfazê-lo.",
		"contexts/bdg/agents/ + contexts/p2p/agents/ + contexts/ssc/agents/ — superfícies de escrita. PRIORIDADE bdg: além da incompletude (classe-1), a prosa está FALSA pós-WI-153 (action de aprovação diz que emite BudgetApproved — o re-papel moveu a emissão para a efetivação; enum morto 'pending, approved, rejected, released' na action de query — o vo quebrou approved em reserved|confirmed). Classe-2 é exatamente o que tq-dmg-12 passa a vigiar; este é o caso vivo.",
		"contexts/bdg/domain-model.cue + contexts/p2p/domain-model.cue + contexts/ssc/domain-model.cue — os catálogos contra os quais a cobertura é medida (leitura; NÃO são outputs desta fatia).",
		"Saída do runner estrutural (sc-ag-02) no tip da branch da higiene — a lista viva de ids nem cobertos nem excluídos por BC é a spec operacional da fatia; não retrabalhar de memória.",
		"O número WI-154 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/bdg/agents/bdg-primary-agent.cue"
		type:     "update"
	}, {
		artifact: "contexts/p2p/agents/p2p-primary-agent.cue"
		type:     "update"
	}, {
		artifact: "contexts/ssc/agents/ssc-primary-agent.cue"
		type:     "update"
	}]
	affects: [
		"architecture/structural-checks/agent-spec.cue",
	]
	rationale: """
		As 3 fatias da 1ª domain story materializaram building blocks sem
		coevoluir os agentes — o drift que motivou o adr-175. Esta higiene
		fecha a parcela recente do baseline: para cada id acusado pelo
		sc-ag-02 em bdg/p2p/ssc, decidir cobertura (operationalScope/actions —
		responsabilidade operacional real) ou exclusão consciente
		(scopeExclusions por id/classe, satisfazendo o critério de
		legitimidade do adr-175). No bdg, adicionalmente, corrigir a prosa
		envelhecida das actions (classe-2) — o contrato do agente deve voltar
		a ser verdadeiro contra o modelo re-papelizado.

		O BACKFILL do work-event do wi-151 NÃO pertence a esta fatia (decisão
		do founder na fatia do adr-175): é higiene de event-sourcing de
		governança (governance/build-time/work-events/, convenção -backfill),
		natureza distinta de coevolução de artefato de BC — registro em
		separado quando priorizado.

		CLASSIFICAÇÃO: edições em instâncias de schema existente (#AgentSpec)
		→ tmpl-create-instance@v1. Nenhuma mudança de schema/motor aqui — a
		fundação é do adr-175.
		"""
}
