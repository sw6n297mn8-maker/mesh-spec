package artifact_schemas

// api-spec.cue — Schemas esqueletais para specs autorais governados por
// padrões externos (OpenAPI 3.x, AsyncAPI 2.x).
//
// Estes tipos existem apenas para declarar localização canônica e
// participar do regime ontológico do package artifact_schemas. Não
// contêm _qualityCriteria: conformance estrutural a OpenAPI/AsyncAPI é
// delegada ao padrão externo; invariantes cross-artifact (presença
// condicionada a flags do canvas, coerência com interaction-contracts)
// vivem na convenção api-spec-convention.cue e são enforçados via
// structural-check dedicado.
//
// Justificativa arquitetural (adr-040): schema declara ontologia
// ("este tipo existe e vive aqui"); structural-check declara enforcement
// ("estas invariantes devem valer"). Schema sem _qualityCriteria é
// legítimo quando o tipo não tem invariantes intra-artifact expressáveis
// sem consultar o padrão externo.
//
// Limitação conhecida: file classification em repo-structure.cue
// processa apenas arquivos .cue. Enquanto isso não mudar,
// canonicalPathRegex destes schemas não alimenta o fluxo de classification
// automática — a cobertura de presença é feita pelo structural-check
// da convenção, que ancora nas flags hasSyncSurface/hasAsyncSurface
// do canvas.

#OpenAPISpec: {
	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/api\\.yaml$"
			fileNameRegex:      "^api\\.yaml$"
			description:        "OpenAPI 3.x spec autoral da superfície síncrona de um bounded context."
			rationale:          "Specs síncronos vivem ao lado do canvas.cue do BC. Presença é condicionada por canvas.hasSyncSurface — enforçada por structural-check da convenção, não por este schema."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}

#AsyncAPISpec: {
	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/async-api\\.yaml$"
			fileNameRegex:      "^async-api\\.yaml$"
			description:        "AsyncAPI 2.x spec autoral da superfície assíncrona de um bounded context."
			rationale:          "Specs assíncronos vivem ao lado do canvas.cue do BC. Presença é condicionada por canvas.hasAsyncSurface — enforçada por structural-check da convenção, não por este schema."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}
