package task_specs

taskSpecs: "WI-048": {
	version:               1
	title:                 "Criar artefatos de domínio para Budget & Approval (BDG)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — BDG consome CommitmentAccepted de CMT; publica BudgetApproved para DLV",
	]
	outputs: [{
		artifact: "contexts/bdg/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/bdg/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/bdg/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/bdg/agents/bdg-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/bdg/agents/bdg-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting BDG. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — aprova ou rejeita cobertura orçamentária
		para compromissos. Consome CommitmentAccepted de CMT; publica
		BudgetApproved para DLV. Gate orçamentário entre compromisso
		e execução.

		Criticality medium (default template) — gate operacional
		interno, sem boundary regulatório direto.
		"""
}
