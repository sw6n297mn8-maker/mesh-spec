package task_specs

taskSpecs: "WI-011": {
	version:               1
	title:                 "Criar schema #Canvas"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/canvas.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/canvas.cue",
		"governance/bounded-context-completeness.cue",
	]
	rationale: "Schema de validação para BC canvas. Afeta todas as futuras instâncias e regras de completude."
}
