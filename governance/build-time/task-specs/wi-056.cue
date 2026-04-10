package task_specs

taskSpecs: "WI-056": {
	version:               1
	title:                 "Criar artefatos de domínio para Observability & Operational Intelligence (OBS)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — OBS é transversal: observabilidade e inteligência operacional consumida por todos os BCs",
	]
	outputs: [{
		artifact: "contexts/obs/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/obs/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/obs/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/obs/agents/obs-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/obs/agents/obs-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting OBS. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — fornece observabilidade e inteligência
		operacional. Capability transversal consumida por todos os
		BCs de domínio. Wardley evolution commodity.

		Criticality medium (default template) — infraestrutura de
		observabilidade, sem decisão financeira ou regulatória.
		"""
}
