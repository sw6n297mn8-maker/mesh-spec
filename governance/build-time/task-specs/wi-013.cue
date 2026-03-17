package task_specs

taskSpecs: "WI-013": {
	version:               1
	title:                 "Criar schema #ValidationPrompt"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/validation-prompt.cue"
		type:     "create"
	}]
	affects: [
		"architecture/validation-prompts/*.cue",
	]
	rationale: "Schema de validação para validation prompts. Afeta todas as futuras instâncias."
}
