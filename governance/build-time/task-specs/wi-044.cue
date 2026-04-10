package task_specs

taskSpecs: "WI-044": {
	version:               1
	title:                 "Criar artefatos de domínio para Network Growth & Reach (NGR)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — NGR direciona crescimento usando insights de NIM; opera em parceria com NPM para onboarding",
	]
	outputs: [{
		artifact: "contexts/ngr/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/ngr/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/ngr/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/ngr/agents/ngr-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/ngr/agents/ngr-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC core NGR. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Core domain — direciona crescimento da rede usando insights
		de NIM (inteligência de rede) e opera em parceria com NPM
		(gestão de participantes) para onboarding. Wardley evolution
		genesis — linguagem e mecanismos ainda em formação.

		Criticality medium (default template) — não controla decisão
		sobre dinheiro nem boundary regulatório. Estratégia de growth
		é operacional, não financeira.
		"""
}
