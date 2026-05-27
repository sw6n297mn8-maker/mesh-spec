package production_guides

meta: "architecture/production-guides": {
	canonicalPath: "architecture/production-guides"
	purpose:       "Production guides: instruções de produção executadas por agente antes de criar instância de cada tipo de artefato governado (simétricos a validation-prompts, que validam depois)."
	conventions: [
		"Nome no formato {schema-basename}.cue (1:1 com architecture/artifact-schemas/{schema-basename}.cue).",
		"Conformam com architecture/artifact-schemas/production-guide.cue.",
		"Cobertura universal por convenção: todo artifact-schema instanciável tem guide correspondente (adr-053).",
	]
	rationale: "Production guides são localização canônica única para 'como produzir instância de schema X' — orientação que não cabe no schema (process, gapPolicy, heuristics, doneCriteria) ganha lugar próprio."
}
