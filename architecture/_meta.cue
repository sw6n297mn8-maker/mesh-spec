package architecture

meta: "architecture": {
	canonicalPath: "architecture"
	purpose:       "Layer 3 da espec: decisões arquiteturais globais que não pertencem a nenhum BC individual."
	conventions: [
		"Artefatos cross-context (ADRs globais, schemas, lenses, princípios) vivem aqui.",
		"design-principles.cue é top-level; demais artefatos em subdiretórios por tipo.",
	]
	rationale: "Concentrar decisões que afetam múltiplos BCs em um só lugar evita espalhar conhecimento transversal pelas pastas de contexto."
}
