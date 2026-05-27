package artifact_schemas

meta: "architecture/artifact-schemas": {
	canonicalPath: "architecture/artifact-schemas"
	purpose:       "Schemas de validação para cada tipo de artefato instanciado no repo (#Canvas, #ADR, #Lens, etc.)."
	conventions: [
		"Um arquivo por tipo de artefato; nome em singular kebab-case (canvas.cue, adr.cue).",
		"Schemas definem shape + rationale + location + qualityCriteria.",
		"CI valida que toda instância do tipo conforma com seu schema.",
	]
	rationale: "Schemas são meta-nível: governam validade de instâncias. Centralizar em um diretório permite discovery e auditoria de cobertura por tipo."
}
