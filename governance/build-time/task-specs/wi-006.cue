package task_specs

taskSpecs: "WI-006": {
	version:               1
	title:                 "Validar schema #DomainDefinition existente"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/domain-definition.cue"
		type:     "validate"
	}]
	affects: []
	rationale: "domain-definition.cue schema já existe. Validar completude antes de WI-001 criar a instância."
}
