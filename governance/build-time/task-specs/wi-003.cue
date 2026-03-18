package task_specs

taskSpecs: "WI-003": {
	version:               1
	title:                 "Validar governance/repo-structure.cue"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "governance/repo-structure.cue"
		type:     "validate"
	}]
	affects: []
	rationale: "repo-structure.cue já existe. Validar que cobre todos os paths necessários para W001."
}
