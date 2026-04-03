package task_specs

taskSpecs: "WI-028": {
	version:               1
	title:                 "Criar architecture/agent-governance.cue"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Schema #AgentSpec definido para alinhar vocabulário de governance",
	]
	outputs: [{
		artifact: "architecture/agent-governance.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/agents/*.cue",
	]
	rationale: "Políticas transversais de governança de agentes. Canvas referencia via globalGovernanceRef. Define boundaries, escalation e protocolos comuns a todos os agent specs."
}
