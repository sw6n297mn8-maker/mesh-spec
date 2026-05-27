package npm

meta: "contexts/npm/agents": {
	canonicalPath: "contexts/npm/agents"
	purpose:       "Specs e governance envelopes dos agentes do BC Network Participant Management."
	conventions: [
		"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
		"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
		"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
	]
	rationale: "Container de instâncias: mesmo padrão dos demais BCs — localização por bounded context preserva autonomia operacional sem perder uniformidade estrutural."
}
