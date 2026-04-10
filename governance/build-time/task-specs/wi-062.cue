package task_specs

taskSpecs: "WI-062": {
	version:               1
	title:                 "Criar artefatos de domínio para Banking Rails & Settlement (BKR)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — FCE depende de BKR para settlement físico; BKR define boundary com sistema financeiro externo",
	]
	outputs: [{
		artifact: "contexts/bkr/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/bkr/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/bkr/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/bkr/agents/bkr-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/bkr/agents/bkr-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC generic BKR. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Generic domain — capability transversal de integração com
		rails bancários e sistemas de liquidação externos (SPB, PIX,
		câmaras de liquidação). Define a boundary entre a Mesh e o
		sistema financeiro regulado. Consumido por FCE para execução
		física de settlement.

		Criticality high — controla movimento de dinheiro na camada
		de execução física. Especificação incorreta de rails ou
		protocolos de settlement pode gerar falhas de liquidação
		ou non-compliance com Bacen.
		"""
}
