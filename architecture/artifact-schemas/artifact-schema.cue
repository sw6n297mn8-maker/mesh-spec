package artifact_schemas

// artifact-schema.cue — Meta-schema para artifact schemas.
//
// Define critérios de qualidade que todo artifact schema deve satisfazer.
// Auto-referencial: este arquivo é ele próprio um artifact schema e
// deve satisfazer seus próprios critérios.
//
// _qualityCriteria e _schema estão aninhados em _artifactSchemaMeta
// porque CUE unifica campos top-level de todos os arquivos no package.
// lens.cue já ocupa _qualityCriteria no top-level. Padrão preferido
// (per adr.cue) é aninhar dentro da definição do tipo.

_artifactSchemaMeta: {
	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-as-01"
			description: "Schema declara localização canônica"
			test:        "_schema.location está presente e preenchido com canonicalPathRegex, fileNameRegex, description, rationale e cardinality. Sem _schema.location, instâncias do tipo não são localizáveis pelo CI e pelo sistema de quality gate."
			severity:    "fail"
			rationale:   "Sem _schema.location, instâncias do tipo não são localizáveis pelo CI e pelo sistema de quality gate."
		}, {
			id:          "tq-as-02"
			description: "Critérios type-specific são acionáveis"
			test:        "Cada critério em _qualityCriteria tem test que descreve verificação concreta — não aspiracional. Um agente deve conseguir aplicar o test e chegar a pass/fail sem interpretação subjetiva."
			severity:    "fail"
			rationale:   "Critério não-acionável gera inconsistência entre agentes — cada um interpreta diferente."
		}, {
			id:          "tq-as-03"
			description: "Rationale do conjunto explica cobertura"
			test:        "_qualityCriteria.rationale explica que aspecto do tipo os critérios cobrem coletivamente. Não é repetição dos rationales individuais."
			severity:    "warn"
			rationale:   "Rationale do conjunto orienta extensão futura — sem ele, novos critérios são adicionados sem coerência."
		}]
		rationale: "Meta-critérios garantem que artifact schemas tenham estrutura mínima para participar do regime de self-review — _schema.location para localizabilidade, critérios acionáveis para consistência entre agentes."
	}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/artifact-schemas/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Meta-schema para artifact schemas do sistema Mesh."
			rationale:          "Artifact schemas vivem em architecture/artifact-schemas/ — este meta-schema governa os critérios que todos devem satisfazer."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}
