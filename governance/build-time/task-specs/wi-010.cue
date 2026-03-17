package task_specs

taskSpecs: "WI-010": {
	version:               1
	title:                 "Criar validation prompts fundacionais"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/validation-prompts/validate-domain-definition.cue"
		type:     "create"
	}, {
		artifact: "architecture/validation-prompts/validate-canvas.cue"
		type:     "create"
	}]
	affects: []
	rationale: "Validation prompts para os dois artefatos mais críticos. Depende de domain-definition, canvas e validation-prompt schema."
}
