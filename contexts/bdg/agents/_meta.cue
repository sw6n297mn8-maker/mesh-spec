package bdg

meta: "contexts/bdg/agents": {
	canonicalPath: "contexts/bdg/agents"
	purpose:       "Specs e governance envelopes dos agentes do BC Budget & Approval."
	conventions: [
		"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
		"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
		"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
	]
	rationale: "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
}
