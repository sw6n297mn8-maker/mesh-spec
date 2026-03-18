package task_specs

taskSpecs: "WI-005": {
	version:               1
	title:                 "Validar schema #ADR existente"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/adr.cue"
		type:     "validate"
	}]
	affects: []
	rationale: "adr.cue já existe. Validar que todos os ADRs existentes passam cue vet contra o schema."
}
