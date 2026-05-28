package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// asyncapi-spec.cue — Production guide para autoria de superfície assíncrona
// (async-api.yaml) de um BC. Schema alvo: #AsyncAPISpec (api-spec.cue).
// Escopo: cada BC com canvas.capabilities.hasAsyncSurface=true tem um
// async-api.yaml. Materializado por sc-cv-03 (conditional-file-presence).

asyncapiSpecGuide: artifact_schemas.#ProductionGuide & {

	prerequisites: {
		description: """
			Antes de autorar async-api.yaml de um BC, o agente lê: schema
			#AsyncAPISpec (architecture/artifact-schemas/api-spec.cue), convenção
			(architecture/conventions/api-spec-convention.cue), canvas do BC
			(capability flags + integration patterns), domain-model do BC (lista de
			events com fields), schemas/events.cue do BC (payload schemas CUE), e o
			context-map (quais events cruzam fronteira de BC). Spec externo AsyncAPI
			2.6.0 é referência de conformance.
			"""
		collectFromFounder: [
			"BC alvo: code + name; confirmação de canvas.capabilities.hasAsyncSurface=true.",
			"Estratégia de payload: dataschema aponta pro CUE de contexts/<bc>/schemas/events.cue (referência) E mirror JSON Schema inline em components.schemas. Padrão: dataschema URI + x-mesh-cue-ref no schema mirror (vínculo de auditoria manual, não automação).",
			"Transport bindings: se ADR de stack ainda não decidiu o transport, deixar bindings fora do arquivo + registrar como tension-entry OU def-XXX. NUNCA inventar binding sem decisão arquitetural.",
			"Channel naming convention: padrão 'mesh.<bc-code>.<event-name>.v1' (kebab event-name + sufixo de versão); a versão no nome do canal evita ambiguidade quando v2 coexistir.",
			"Quais events deste BC são publicados externamente: usar strategic/context-map.cue relationships como fonte; events sem relationship ficam de fora do async-api.yaml.",
		]
	}

	workOrder: ["info-header", "channels", "messages", "components-schemas", "bindings-or-deferred"]

	sections: {
		"info-header": {
			target:    "#AsyncAPISpec"
			objective: "Declarar asyncapi version, info bloco (title/version/description) e tag mesh.bc."
			process: [{
				action: "Declarar asyncapi: '2.6.0' no topo do arquivo."
			}, {
				action: "Preencher info: title='<BC name> async surface'."
				detail: "Title concreto deriva do canvas.name; description curta em uma frase referenciando o canvas como source."
			}, {
				action: "Definir info.version semver inicial '1.0.0'."
			}, {
				action: "Adicionar tag mesh com bc=<code> em tags[]."
			}]
			doneCriteria: "info.title e info.version estão concretos e asyncapi='2.6.0' declarado."
			sources: ["contexts/<bc>/canvas.cue: name e description"]
			heuristics: [
				"Description curta — referenciar canvas como source, não duplicar.",
			]
		}
		"channels": {
			target:    "#AsyncAPISpec"
			objective: "Listar channels publish-only por event publicado em context-map, com naming versionado."
			process: [{
				action: "Listar events de contexts/<bc>/domain-model.cue."
			}, {
				action: "Cross-check com strategic/context-map.cue relationships."
				detail: "Para cada event, verificar se aparece como publicação numa relationship; events sem relationship ficam de fora."
			}, {
				action: "Criar um channel 'mesh.<bc-code>.<event-name>.v1' por event publicado."
				detail: "Kebab event-name; sufixo .v1 reserva espaço para evolução sem quebrar consumer existente."
			}, {
				action: "Declarar APENAS operação 'publish' em cada channel (este BC é o producer)."
				detail: "Consumidores são descobertos via context-map relationships, não via 'subscribe' aqui. Nenhuma operação subscribe deve existir no arquivo deste BC."
			}]
			doneCriteria: "Cada event publicado em context-map relationships tem channel correspondente com naming versionado; zero operações subscribe no arquivo."
			sources: [
				"contexts/<bc>/domain-model.cue: events[]",
				"strategic/context-map.cue: relationships",
				"contexts/<bc>/canvas.cue: integration patterns",
			]
			heuristics: [
				"Channel é canal de transporte versionado; o sufixo .v1 reserva espaço pra evolução sem quebrar consumer.",
				"Se um event não está em context-map mas você acha que deveria estar publicado, pare e registre em openQuestions — não invente publicação aqui.",
			]
		}
		"messages": {
			target:    "#AsyncAPISpec"
			objective: "Bindar message a cada channel, com payload por $ref a components/schemas."
			process: [{
				action: "Declarar message por channel com name=PascalCase do evento."
				detail: "Ex: CommitmentProposed para o channel mesh.cmt.commitment-proposed.v1."
			}, {
				action: "payload via $ref para components/schemas/<MessageName> — nunca inline."
			}, {
				action: "headers: declarar SÓ se houver header semântico (correlationId, traceparent, idempotencyKey)."
			}, {
				action: "contentType: 'application/json' (revisitar se adoção Ion for decidida em ADR)."
			}]
			doneCriteria: "Toda channel.publish.message resolve para components.schemas.<Name> via $ref."
			sources: ["contexts/<bc>/schemas/events.cue (CUE event types canônicos)"]
			heuristics: [
				"Nunca inline payload no channel; sempre $ref pra components/schemas — facilita reuso e mantém um único shape canônico por message.",
			]
		}
		"components-schemas": {
			target:    "#AsyncAPISpec"
			objective: "Materializar mirror JSON Schema do CUE event type, com x-mesh-cue-ref de auditoria."
			process: [{
				action: "Para cada message, definir components.schemas.<MessageName> como JSON Schema (object com properties)."
			}, {
				action: "Mirror MANUAL dos campos envelope+data do CUE #<MessageName> em contexts/<bc>/schemas/events.cue."
				detail: "Não existe gerador automático CUE→JSON Schema hoje; a tradução é manual e auditável."
			}, {
				action: "Anotar com extension x-mesh-cue-ref: 'contexts/<bc>/schemas/events.cue##<MessageName>'."
				detail: "Vínculo de auditoria pra revisão humana detectar drift; NÃO é mecanismo automático."
			}, {
				action: "Opaque refs cross-BC (RiskLevel, ParticipantId, etc.) viram string com description='owned by <BC-owner>'."
			}, {
				action: "Money inline → object {amount: integer minimum 0, currency: string pattern '^[A-Z]{3}$'}."
			}]
			doneCriteria: "Toda schema referenciada por messages existe em components.schemas, tem x-mesh-cue-ref, e opaque refs cross-BC têm description com owner."
			sources: ["contexts/<bc>/schemas/events.cue: #<MessageName>"]
			heuristics: [
				"JSON Schema é MIRROR, não autoridade — o CUE em schemas/events.cue é a fonte da verdade. Se houver discrepância, o CUE vence.",
				"A tradução é manual hoje; drift entre CUE e JSON Schema deve ser detectado em revisão humana até gate cross-file gerador-aware existir.",
			]
		}
		"bindings-or-deferred": {
			target:    "#AsyncAPISpec"
			objective: "Materializar bindings só com ADR de transport, ou registrar gap rastreável."
			process: [{
				action: "Verificar se existe ADR de stack com transport decidido (kafka/amqp/mqtt/outro)."
				detail: "Grep em architecture/adrs/ por 'kafka', 'amqp', 'mqtt', 'broker', 'transport'."
			}, {
				action: "SE existe ADR: declarar bindings (channelBindings, operationBindings, messageBindings) coerentes com o transport do ADR."
			}, {
				action: "SE NÃO existe ADR: omitir bindings do arquivo + abrir tension-entry OU def-XXX explicando que transport é decisão pendente."
				detail: "O gap deve ficar rastreável em architecture/tension-log/ ou architecture/deferred-decisions/, NÃO escondido."
			}, {
				action: "NUNCA inventar binding sem ADR de transport — vira dívida invisível e fixa contrato escondido."
			}]
			doneCriteria: "bindings presentes E coerentes com ADR-XXX de transport, OU ausência registrada em tension-entry/def-XXX rastreável."
			sources: ["architecture/adrs/ (busca por ADR de transport)"]
			heuristics: [
				"Sem ADR de transport, bindings é chute. Melhor ficar sem do que inventar.",
			]
		}
	}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/asyncapi-spec\\.cue$"
			fileNameRegex:      "^asyncapi-spec\\.cue$"
			description:        "Production guide para autoria de async-api.yaml por BC com hasAsyncSurface=true."
			rationale:          "AsyncAPI 2.x é spec externa; PG aterra as convenções mesh (channel naming versionado, payload referencing CUE via x-mesh-cue-ref, bindings só com ADR de transport). Sem PG, a tradução events.cue → async-api.yaml fica improvisada por BC e diverge cross-BC."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-async-01"
			description: "Coverage: todo event publicado em context-map relationships tem channel correspondente"
			test:        "Para cada event de contexts/<bc>/domain-model.cue referenciado em strategic/context-map.cue relationships (qualquer dimensão de publicação), verifica que existe um channel em async-api.yaml com message correspondente. Events sem relationship NÃO devem ter channel."
			severity:    "fail"
			rationale:   "Sem coverage, contratos prometidos no context-map ficam sem materialização — consumidor declarado não tem canal pra assinar. visibility está no context-map, não no domain-model; usar context-map.relationships como fonte da verdade da publicação."
		}, {
			id:          "tq-async-02"
			description: "Fidelidade: payload schema é mirror manual do CUE event type, com x-mesh-cue-ref como vínculo de auditoria"
			test:        "Para cada components/schemas/<MessageName>, x-mesh-cue-ref aponta pro #<MessageName> em contexts/<bc>/schemas/events.cue; shapes batem (revisão humana hoje, advisory). Não há gerador automático — x-mesh-cue-ref é elo de auditoria, não automação."
			severity:    "fail"
			rationale:   "Drift entre CUE (SoT) e JSON Schema rompe contrato cross-BC; consumer e producer divergem silenciosamente. x-mesh-cue-ref explicita o vínculo pra revisão humana detectar drift até gate cross-file existir."
		}, {
			id:          "tq-async-03"
			description: "Channel naming convention consistente com versão no nome"
			test:        "Todos channels seguem 'mesh.<bc-code>.<event-name>.v<N>' (kebab event-name + sufixo .v<N>). Exceções precisam de justificativa em openQuestions do arquivo."
			severity:    "warn"
			rationale:   "Consistência cross-BC reduz fricção de integração; versão no nome do canal evita ambiguidade quando v2 coexistir com v1. Warn (não fail) porque exceções legítimas existem."
		}, {
			id:          "tq-async-04"
			description: "Bindings: presentes E coerentes com ADR de transport, OU ausentes E gap registrado"
			test:        "Ou existe ADR de stack/transport e bindings concretos coerentes no arquivo, ou não há ADR e o gap está em architecture/tension-log/ OU architecture/deferred-decisions/. Bindings inventados sem ADR falham."
			severity:    "fail"
			rationale:   "Binding sem decisão arquitetural fixa contrato de transporte de forma escondida — vira dívida invisível que acopla o BC a um broker sem decisão registrada."
		}]
		rationale: "4 critérios cobrem: coverage events↔context-map (tq-async-01), fidelidade contrato↔CUE-SoT (tq-async-02), consistência de naming versionado (tq-async-03 warn), e disciplina anti-binding-fantasma (tq-async-04). Fail onde o risco é drift contratual cross-BC ou dívida arquitetural escondida; warn onde exceções legítimas existem."
	}
}
