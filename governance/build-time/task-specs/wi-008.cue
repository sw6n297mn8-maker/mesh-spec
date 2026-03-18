package task_specs

taskSpecs: "WI-008": {
	version:               1
	title:                 "Criar strategic/context-map.cue"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "strategic/context-map.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/context-dependencies.cue",
	]
	rationale: "Context-map define topologia de integração entre BCs. Depende de subdomínios para saber quais BCs existem."
}
