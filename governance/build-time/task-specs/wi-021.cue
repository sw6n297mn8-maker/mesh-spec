package task_specs

taskSpecs: "WI-021": {
	version:               1
	title:                 "Criar schema #Glossary"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/glossary.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/glossary.cue",
	]
	rationale: "Schema para Ubiquitous Language local de cada BC. Canvas aponta via ubiquitousLanguageRef. Mais simples dos schemas, desbloqueia preenchimento do canvas."
}
