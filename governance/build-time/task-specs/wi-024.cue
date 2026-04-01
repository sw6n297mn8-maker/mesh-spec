package task_specs

taskSpecs: "WI-024": {
	version:               1
	title:                 "Criar contexts/cmt/agents/cmt-primary-agent.cue"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Canvas CMT com ownership.domainAgentSpec e governanceScope definidos",
	]
	outputs: [{
		artifact: "contexts/cmt/agents/cmt-primary-agent.cue"
		type:     "create"
	}]
	affects: []
	rationale: "Primeira instância de agent spec. Desbloqueia ownership.domainAgentSpec do canvas CMT com referência verificável por runner."
}
