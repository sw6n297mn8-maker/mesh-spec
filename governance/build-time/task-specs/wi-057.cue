package task_specs

taskSpecs: "WI-057": {
	version:               1
	title:                 "Criar artefatos de domínio para Procure-to-Pay (P2P)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — P2P governa ciclo de demanda-compra; publica pedidos para CMT; consome decisões de SSC",
		"contexts/cmt/domain-model.cue — CMT consome pedidos de compra de P2P como trigger de compromisso",
	]
	outputs: [{
		artifact: "contexts/p2p/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/p2p/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/p2p/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/p2p/agents/p2p-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/p2p/agents/p2p-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting P2P. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — governa ciclo interno de demanda-compra:
		requisição, aprovação, emissão de pedido de compra. Publica
		pedidos para CMT (compromisso econômico); consome decisões
		de SSC (sourcing estratégico).

		Criticality medium (default template) — procurement
		operacional, sem boundary regulatório direto.
		"""
}
