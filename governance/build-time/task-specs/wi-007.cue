package task_specs

taskSpecs: "WI-007": {
	version:     1
	title:       "Criar instâncias de subdomínios"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Subdomínios candidatos identificados em domain-definition.cue",
	]
	outputs: [{
		artifact: "strategic/subdomains/"
		type:     "create"
	}]
	affects: []
	rationale: "Subdomínios posicionam BCs na taxonomia estratégica. Dependem de domain-definition (identidade) e schema #Subdomain (estrutura)."
}
