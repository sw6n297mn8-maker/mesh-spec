package contexts

meta: "contexts": {
	canonicalPath: "contexts"
	purpose:       "Layer 2 da espec: bounded contexts autocontidos, cada um um pacote completo."
	conventions: [
		"Um subdiretório por BC, nome lowercase de 3 letras (ex.: cmt, ssc, bkr).",
		"Cada BC contém canvas, invariants, commands, events, workflows e demais artefatos declarados em governance/bounded-context-completeness.cue.",
	]
	rationale: "Autocontenção do BC é o que permite paralelizar trabalho entre agentes — dependências cross-BC passam por contratos explícitos em strategic/context-map.cue."
}
