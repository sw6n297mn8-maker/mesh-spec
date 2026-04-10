package task_specs

taskSpecs: "WI-047": {
	version:               1
	title:                 "Criar artefatos de domínio para Accounting & Tax Operations (ATO)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — ATO consome eventos de INV, FCE, SCF e ITC em modo conformist; traduz para linguagem fiscal/contábil",
	]
	outputs: [{
		artifact: "contexts/ato/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/ato/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/ato/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/ato/agents/ato-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/ato/agents/ato-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting ATO. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — registra lançamentos fiscais e contábeis
		derivados de INV, FCE, SCF e ITC. Conformist em relação a
		todos os upstream: traduz para linguagem fiscal/contábil sem
		alterar linguagem dos publicadores.

		Criticality high — boundary regulatório e obrigação acessória.
		Regulação tributária brasileira e aduaneira impõe constraints
		de compliance que não toleram erro de especificação. Diferente
		de FCE/REW que controlam decisão sobre dinheiro, ATO materializa
		obrigações legais derivadas dessas decisões.
		"""
}
