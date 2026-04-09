package artifact_schemas

// api-spec.cue — Schemas esqueletais para specs autorais governados por
// padrões externos (OpenAPI 3.x, AsyncAPI 2.x).
//
// Estes tipos existem apenas para declarar localização canônica e
// participar do regime ontológico do package artifact_schemas. Não
// contêm _qualityCriteria: conformance estrutural a OpenAPI/AsyncAPI é
// delegada ao padrão externo; invariantes cross-artifact (presença
// condicionada a flags do canvas, coerência com interaction-contracts)
// serão codificadas na convenção api-spec-convention.cue (a ser criada
// em architecture/conventions/ por WI-027 B.1) e enforçadas via
// structural-check dedicado (a ser criado em WI-027 B.2). Nem a
// convenção nem o structural-check existem no repositório no momento
// da criação deste schema — são dependências prospectivas da
// sequência planejada de WI-027.
//
// Justificativa arquitetural (adr-040): schema declara ontologia
// ("este tipo existe e vive aqui"); structural-check declara enforcement
// ("estas invariantes devem valer"). Schema sem _qualityCriteria é
// legítimo quando o tipo não tem invariantes intra-artifact expressáveis
// sem consultar o padrão externo.
//
// Limitações conhecidas:
//
// 1. File classification em repo-structure.cue processa apenas arquivos
//    .cue. Enquanto isso não mudar, canonicalPathRegex destes schemas
//    não alimenta o fluxo de classification automática — a cobertura
//    de presença depende do structural-check prospectivo da convenção,
//    que ancorará nas flags hasSyncSurface/hasAsyncSurface do canvas.
//
// 2. canonicalPathRegex/fileNameRegex codificam os nomes api.yaml e
//    async-api.yaml mas não codificam compromisso versionado com
//    OpenAPI 3.x ou AsyncAPI 2.x. Verificação de conformance ao
//    padrão externo é responsabilidade da convenção/structural-check
//    prospectivos, não deste schema.
//
// 3. Bloqueador mecânico do enum #ArtifactType para criação do
//    structural-check (pré-B.2 de WI-027), resolvido por adr-047
//    (extensão com openapi-spec e asyncapi-spec).

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
