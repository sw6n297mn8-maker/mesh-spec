package cmt

meta: "contexts/cmt/agents": {
	canonicalPath: "contexts/cmt/agents"
	purpose:       "Specs e governance envelopes dos agentes do BC Commitment Management."
	conventions: [
		"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
		"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
		"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
	]
	rationale: "Container de instâncias: agentes de domínio vivem dentro do BC porque dependem de canvas, invariants e schemas locais; separar spec de envelope mantém capacidade e autoridade auditáveis."
}
