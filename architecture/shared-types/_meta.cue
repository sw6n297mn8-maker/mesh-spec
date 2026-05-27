package shared_types

meta: "architecture/shared-types": {
	canonicalPath: "architecture/shared-types"
	purpose:       "Tipos reutilizáveis entre artifact-schemas (#StrategicClassification, #VerticalApplicability)."
	conventions: [
		"Tipos de baixo nível usados por múltiplos schemas.",
		"Não contém instâncias; apenas definições de tipo.",
	]
	rationale: "Extrair tipos compartilhados evita que cada artifact-schema redefina os mesmos tipos — previne drift de definição."
}
