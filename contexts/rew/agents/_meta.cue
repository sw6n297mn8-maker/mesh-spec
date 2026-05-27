package rew

meta: "contexts/rew/agents": {
	canonicalPath: "contexts/rew/agents"
	purpose:       "Specs e governance envelopes dos agentes do BC Risk Engine & Risk Observability."
	conventions: [
		"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
		"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
		"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
	]
	rationale: "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
}
