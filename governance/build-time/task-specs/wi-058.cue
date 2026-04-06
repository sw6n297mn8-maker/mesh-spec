package task_specs

taskSpecs: "WI-058": {
	version:               1
	title:                 "Criar artefatos de domínio para Platform & Infrastructure Services (PLT)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — PLT é transversal: serviços de plataforma e infraestrutura consumidos por todos os BCs",
	]
	outputs: [{
		artifact: "contexts/plt/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/plt/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/plt/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/plt/agents/plt-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/plt/agents/plt-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting PLT. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — fornece serviços de plataforma e
		infraestrutura. Capability transversal consumida por todos
		os BCs de domínio. Wardley evolution commodity.

		Criticality medium (default template) — infraestrutura de
		plataforma, sem decisão financeira ou regulatória.
		"""
}
