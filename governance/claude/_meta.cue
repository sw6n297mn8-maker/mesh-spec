package claude

meta: "governance/claude": {
	canonicalPath: "governance/claude"
	purpose:       "Source of truth das regras comportamentais do agente (CLAUDE.md é artefato derivado)."
	conventions: [
		"config.cue é a instância; schema.cue e output.cue governam shape e renderização.",
		"CLAUDE.md nunca editado diretamente — regenerado por cue export.",
		"Schema conforma com portfolio-wide #ClaudeConfig adotado em governance/adopted-artifacts.cue.",
	]
	rationale: "Regras comportamentais governadas como CUE permitem cue vet, review por PR e evolução rastreável — mesmo regime dos demais artefatos."
}
