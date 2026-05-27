package tension_log

meta: "architecture/tension-log": {
	canonicalPath: "architecture/tension-log"
	purpose:       "Tensões arquiteturais: fricções cross-artifact que não são defeito de nenhum lado individual."
	conventions: [
		"Nome no formato ten-NNN-slug.cue.",
		"Cada tensão referencia artefatos em tensão e descreve por que não é defeito de um deles.",
		"Conformam com architecture/artifact-schemas/tension-entry.cue.",
	]
	rationale: "Registrar tensões torna explícita fricção estrutural que seria perdida se tratada como bug isolado em cada lado."
}
