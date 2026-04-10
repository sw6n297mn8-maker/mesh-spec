package task_specs

taskSpecs: "WI-064": {
	version:               1
	title:                 "Criar artefatos de domínio para Storage & Document Management (STR)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — STR é transversal: armazenamento e gestão documental consumidos por todos os BCs",
	]
	outputs: [{
		artifact: "contexts/str/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/str/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/str/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/str/agents/str-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/str/agents/str-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC generic STR. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Generic domain — fornece armazenamento e gestão documental.
		Capability transversal consumida por todos os BCs de domínio.
		Wardley evolution commodity.

		Criticality medium (default template) — infraestrutura de
		storage, sem decisão financeira ou regulatória.
		"""
}
