package task_specs

taskSpecs: "WI-004": {
	version:               1
	title:                 "Criar schema #WavePlan"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/wave-plan.cue"
		type:     "create"
	}]
	affects: [
		"governance/wave-plan.cue",
	]
	rationale: "Schema de validação para wave-plan. Bootstrapping: instância criada antes do schema, schema retrovalida."
}
