package task_specs

taskSpecs: "WI-035": {
	version:               1
	title:                 "Criar agent-governance envelope para CMT primary agent"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Agent spec CMT definido (contexts/cmt/agents/cmt-primary-agent.cue)",
		"Schema de agent-governance definido (architecture/artifact-schemas/agent-governance.cue)",
	]
	outputs: [{
		artifact: "contexts/cmt/agents/cmt-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: [
		"contexts/cmt/canvas.cue",
		"contexts/cmt/agents/cmt-primary-agent.cue",
	]
	rationale: "Agent spec referencia governanceRef 'cmt-primary-agent' mas envelope não existe (tq-ag-09 falharia). Canvas governance scope não referencia envelope explicitamente (vc-cv-05 warn). Envelope define thresholds, blast radius caps e calibração operacional do agente."
}
