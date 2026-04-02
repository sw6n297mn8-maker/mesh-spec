package task_specs

taskSpecs: "WI-029": {
	version:               1
	title:                 "Criar schema #StakeholderMap"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"Canvas schema com campo stakeholders que usa prefixo sh-*",
	]
	outputs: [{
		artifact: "architecture/artifact-schemas/stakeholder-map.cue"
		type:     "create"
	}]
	affects: [
		"domain/stakeholder-map.cue",
	]
	rationale: "Schema para catálogo de stakeholders. Canvas referencia stakeholders via sh-*. Sem schema, refs são unverified pointers."
}
