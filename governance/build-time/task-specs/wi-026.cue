package task_specs

taskSpecs: "WI-026": {
	version:               1
	title:                 "Atualizar context-map domainAgentSpec para path canônico"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: [
		"Convenção de domainAgentSpec por path canônico estabelecida no canvas CMT",
		"Pelo menos um agent spec instanciado como referência de formato",
	]
	outputs: [{
		artifact: "strategic/context-map.cue"
		type:     "update"
	}]
	affects: [
		"contexts/*/canvas.cue",
	]
	rationale: "Canvas CMT estabeleceu convenção de domainAgentSpec por path canônico. Context-map usa ID lógico curto. Alinhar 21 BCs para consistência e verificabilidade por runner."
}
