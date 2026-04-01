package task_specs

taskSpecs: "WI-022": {
	version:               1
	title:                 "Criar schema #AgentSpec"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"Canvas CMT com ownership.domainAgentSpec e governanceScope como referência de requisitos",
	]
	outputs: [{
		artifact: "architecture/artifact-schemas/agent-spec.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/agents/*.cue",
	]
	rationale: "Schema para agent specs. Canvas aponta via ownership.domainAgentSpec. Define capabilities, boundaries e protocolo de operação do agente de domínio."
}
