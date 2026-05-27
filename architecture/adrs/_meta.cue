package adr

meta: "architecture/adrs": {
	canonicalPath: "architecture/adrs"
	purpose:       "ADRs globais do sistema (stack, patterns, deploy strategy, protocolos cross-context)."
	conventions: [
		"Formato adr-NNN-slug.cue com numeração contínua e incremental.",
		"Cada ADR conforma com architecture/artifact-schemas/adr.cue.",
		"Supersession atualiza os dois ADRs no mesmo commit (ADR novo + status do antigo).",
	]
	rationale: "ADR é a forma canônica de registrar decisão com contexto, alternativas consideradas e consequências — histórico imutável evita perda de justificativa."
}
