package task_specs

taskSpecs: "WI-002": {
	version:               1
	title:                 "Validar architecture/design-principles.cue contra schema"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/design-principles.cue"
		type:     "validate"
	}]
	affects: []
	rationale: "design-principles.cue já existe. Validar conformidade e completude antes de ser consumido por outros artefatos."
}
