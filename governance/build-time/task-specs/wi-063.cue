package task_specs

taskSpecs: "WI-063": {
	version:               1
	title:                 "Criar artefatos de domínio para Notifications & Communications (NTF)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — NTF é transversal: notificações e comunicações consumidas por todos os BCs",
	]
	outputs: [{
		artifact: "contexts/ntf/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/ntf/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/ntf/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/ntf/agents/ntf-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/ntf/agents/ntf-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC generic NTF. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Generic domain — fornece notificações e comunicações.
		Capability transversal consumida por todos os BCs de domínio.
		Wardley evolution commodity.

		Criticality medium (default template) — infraestrutura de
		comunicação, sem decisão financeira ou regulatória.
		"""
}
