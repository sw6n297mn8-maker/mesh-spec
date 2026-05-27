package validation_prompts

meta: "architecture/validation-prompts": {
	canonicalPath: "architecture/validation-prompts"
	purpose:       "Prompts de design review advisory executados por agente isolado pós-commit."
	conventions: [
		"Nome no formato validate-{artifactType}.cue.",
		"Findings são recomendações, nunca veredito de gate (P10).",
		"Matching via matchPatterns declarados em cada prompt.",
	]
	rationale: "Revisão semântica complementa gate estrutural cobrindo dimensões interpretativas — separar prompts de checks preserva a categorização."
}
