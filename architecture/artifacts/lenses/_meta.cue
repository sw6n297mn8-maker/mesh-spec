package artifacts_lenses

meta: "architecture/artifacts/lenses": {
	canonicalPath: "architecture/artifacts/lenses"
	purpose:       "Outputs produzidos pela aplicação de lenses analíticas em decisões concretas."
	conventions: [
		"Um arquivo por output; nome referencia a lens aplicada e o artefato analisado.",
		"Conteúdo derivado da execução de lens, não definição da lens.",
	]
	rationale: "Container de derivados: lenses em architecture/lenses/ são protocolos de raciocínio; seus outputs são instâncias materializadas aqui. Diretório reservado antecipadamente — outputs surgem on-demand quando agente aplica lens em decisão."
}
