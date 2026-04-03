package task_specs

taskSpecs: "WI-020": {
	version:               1
	title:                 "Criar schema #DomainModel"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"Canvas CMT commitado com communication entries que referenciam events, commands e queries — serve como input para design do schema",
	]
	outputs: [{
		artifact: "architecture/artifact-schemas/domain-model.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/domain-model.cue",
	]
	rationale: "Schema para building blocks táticos: events, commands, invariants, VOs, aggregates, entities, policies, domain services, projections, lifecycle. Estruturante para todos os BCs."
}
