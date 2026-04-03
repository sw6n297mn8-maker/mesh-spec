package task_specs

taskSpecs: "WI-030": {
	version:               1
	title:                 "Criar schema #ArchitectureCommunicationCanvas"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"Canvas schema para entender a fronteira entre decisões de negócio e decisões técnicas",
		"Design principles para alinhar critérios de qualidade",
	]
	outputs: [{
		artifact: "architecture/artifact-schemas/architecture-communication-canvas.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/architecture-communication-canvas.cue",
	]
	rationale: "Schema para documentação técnica estruturada por BC: infrastructure transversals, tecnologia de implementação, SLA/availability, conformance tests, decisões técnicas. Complementa o canvas de negócio com perspectiva de implementação."
}
