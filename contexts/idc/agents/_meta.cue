package idc

meta: "contexts/idc/agents": {
	canonicalPath: "contexts/idc/agents"
	purpose:       "Specs e governance envelopes dos agentes do BC Identity & Data Governance."
	conventions: [
		"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
		"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
		"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
	]
	rationale: "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
}
