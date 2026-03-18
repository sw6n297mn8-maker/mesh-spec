package task_specs

taskSpecs: "WI-001": {
	version:     1
	title:       "Criar domain/domain-definition.cue"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Founder forneceu definições de tese central, mecanismos e axiomas do domínio",
	]
	outputs: [{
		artifact: "domain/domain-definition.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/canvas.cue",
		"strategic/context-map.cue",
	]
	rationale: "Identidade do domínio é pré-requisito de tudo. Instância de #DomainDefinition."
}
