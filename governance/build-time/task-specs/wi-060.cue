package task_specs

taskSpecs: "WI-060": {
	version:               1
	title:                 "Criar artefatos de domínio para Strategic Sourcing & Category (SSC)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — SSC governa seleção estratégica de fornecedores; publica decisões para P2P e CTR; consome qualificação de NPM",
	]
	outputs: [{
		artifact: "contexts/ssc/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/ssc/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/ssc/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/ssc/agents/ssc-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/ssc/agents/ssc-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting SSC. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — governa seleção estratégica de fornecedores
		e gestão de categorias: cotação, equalização TCO, spend analysis.
		Publica decisões para P2P (procurement) e CTR (contratos);
		consome qualificação de NPM.

		Criticality medium (default template) — sourcing estratégico
		é operacional, sem boundary regulatório direto.
		"""
}
