package task_specs

taskSpecs: "WI-061": {
	version:               1
	title:                 "Criar artefatos de domínio para Treasury & Cash Management (TCM)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — TCM governa tesouraria corporativa; consome de FCE e CMT; informa disponibilidade para FCE",
	]
	outputs: [{
		artifact: "contexts/tcm/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/tcm/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/tcm/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/tcm/agents/tcm-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/tcm/agents/tcm-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting TCM. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — governa visão de tesouraria corporativa:
		posição de caixa, projeção de fluxo, estratégia de liquidez
		e exposição cambial. Consome sinais de FCE e CMT; informa
		disponibilidade de caixa para FCE.

		Criticality medium (default template) — tesouraria informa
		decisões mas não controla movimento de dinheiro diretamente
		(FCE controla).
		"""
}
