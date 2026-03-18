package task_specs

taskSpecs: "WI-012": {
	version:               1
	title:                 "Criar schema #Subdomain"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/subdomain.cue"
		type:     "create"
	}]
	affects: [
		"strategic/subdomains/*.cue",
	]
	rationale: "Schema de validação para subdomínios. Afeta todas as futuras instâncias."
}
