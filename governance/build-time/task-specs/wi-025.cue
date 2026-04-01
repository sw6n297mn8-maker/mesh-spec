package task_specs

taskSpecs: "WI-025": {
	version:               1
	title:                 "Criar contexts/cmt/domain-model.cue"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Canvas CMT com communication entries definindo events e commands canônicos",
		"Glossary CMT com termos da Ubiquitous Language do BC",
	]
	outputs: [{
		artifact: "contexts/cmt/domain-model.cue"
		type:     "create"
	}]
	affects: []
	rationale: "Primeira instância de domain model. Define building blocks táticos do CMT: aggregates, entities, VOs, events, commands, invariants, policies, projections e lifecycle."
}
