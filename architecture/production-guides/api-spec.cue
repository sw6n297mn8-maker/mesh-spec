package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// api-spec.cue — Production guide para autoria de superfície síncrona
// (api.yaml) de um BC. Schema alvo: #APISpec (api-spec.cue).
// Escopo: cada BC com canvas.capabilities.hasSyncSurface=true tem um
// api.yaml. Materializado por sc-cv-02 (conditional-file-presence).
//
// Princípio editorial não-negociável: OpenAPI é SÓ transporte HTTP do modelo
// operacional Mesh. NÃO força resource-oriented REST sobre commands/queries
// — commands são intenções mutáveis (POST RPC), queries são leituras (GET),
// e PUT/PATCH/DELETE não são adicionados "porque REST" se o modelo de domínio
// não tem operação correspondente.

apiSpecGuide: artifact_schemas.#ProductionGuide & {

	prerequisites: {
		description: """
			Antes de autorar api.yaml de um BC, o agente lê: schema #APISpec
			(architecture/artifact-schemas/api-spec.cue), convenção
			(architecture/conventions/api-spec-convention.cue), canvas do BC
			(capability flags + integration patterns), domain-model do BC (commands,
			projections, aggregate lifecycle, emitsEvents), schemas/events.cue do BC
			(payload schemas CUE — viram response references), e o context-map (quais
			BCs chamam este BC via sync). Spec externo OpenAPI 3.0.3 é referência de
			conformance.

			Nota sobre request schemas: NÃO existe schemas/commands.cue hoje, e NÃO
			é criado por este PG. Request bodies são mirror inline no api.yaml a
			partir dos commands declarados em domain-model.cue (que é SoT atual).
			schemas/commands.cue só nasce quando houver 2º consumidor real ou
			necessidade clara de reutilização/auditoria independente — abstração
			prematura é evitada (mesma lógica do def-022 pra envelope/Money).
			"""
		collectFromFounder: [
			"BC alvo: code + name; confirmação de canvas.capabilities.hasSyncSurface=true.",
			"Quais commands do domain-model são EXPOSED via sync API vs apenas issued internamente por policies? Default: expor todos exceto os explicitamente marcados como internos pelo founder. Listar exposed E internal em openQuestions se houver dúvida.",
			"Quais projections viram queries GET? Default: expor todas; cada uma tem 1 endpoint GET dedicado.",
			"Auth scheme: se ADR de auth ainda não decidiu, omitir security do arquivo + registrar def-XXX (mesma disciplina de def-023 pra transport). NUNCA inventar auth sem ADR.",
			"Servers (URLs base por ambiente): se ADR de deploy ainda não decidiu, omitir + registrar def-XXX. NUNCA inventar URL.",
			"Versionamento de rota: padrão '/v1/<bc-code>/...' (URL-versioned). Confirmar.",
			"Naming: paths em kebab; commands viram 'POST /v1/<bc>/commands/<command-name-kebab>' (RPC-style, NÃO REST resource); queries viram 'GET /v1/<bc>/queries/<query-name-kebab>'. operationId em camelCase.",
			"Error envelope: RFC 7807 Problem (application/problem+json) é CROSS-BC SHARED CONTRACT — NÃO customizável por BC. Cada rota referencia o mesmo Problem schema por $ref.",
		]
		gapPolicy: "Gaps em exposed vs internal de commands: registrar em openQuestions do arquivo, NÃO expor automaticamente. Gaps em auth (sem ADR): omitir security + def-XXX rastreável. Gaps em servers (sem ADR): omitir + def-XXX. Gaps em request schemas ↔ domain-model.cue: revisão humana até gate cross-file existir. Gaps em comportamento operacional não-óbvio (idempotência, side-effects): documentar em description da operation."
	}

	finalValidation: {
		steps: [
			"Rodar cue vet ./contexts/<bc>/... para garantir que domain-model.cue (request SoT) e schemas/events.cue (response SoT) são válidos.",
			"Cross-check cobertura de commands: cada command exposed em domain-model.cue tem 1 POST em api.yaml; cada projection exposed tem 1 GET.",
			"Cross-check fidelidade: request body schema bate com command.fields do CUE; success response usa $ref pra schemas/events.cue#<EventName> emitido pelo command (per aggregate.handlesCommands+emitsEvents).",
			"Validar naming: '/v1/<bc>/commands/<kebab>' (POST) e '/v1/<bc>/queries/<kebab>' (GET); nenhum PUT/PATCH/DELETE injetado por reflexo REST.",
			"Validar errors: todas rotas declaram error responses via $ref pra Problem cross-BC; nenhum shape inline.",
			"Confirmar auth e servers: presentes E coerentes com ADR, OU ausentes E gap registrado em tension-entry/def-XXX.",
			"Submeter ao founder para aprovação antes de commit.",
		]
	}

	workOrder: ["info-header", "servers-or-deferred", "paths-and-operations", "components-schemas", "components-responses-and-errors", "security-or-deferred"]

	sections: {
		"info-header": {
			target:    "#APISpec"
			objective: "Declarar openapi version, info bloco, tag mesh.bc e contentType padrão."
			process: [{
				action: "Declarar openapi: '3.0.3' no topo do arquivo."
				detail: "3.0.3 por compatibilidade ampla de tooling; 3.1.0 traz JSON Schema 2020-12 completo mas o ecossistema ainda está atrás."
			}, {
				action: "Preencher info: title='<BC name> sync surface', version semver inicial '0.1.0' (pre-1.0 enquanto não há produção), description curta."
			}, {
				action: "Adicionar tag mesh com bc=<code> em tags[]."
			}]
			doneCriteria: "openapi='3.0.3' declarado; info.title/version concretos; tag mesh.bc presente."
			sources: ["contexts/<bc>/canvas.cue: name, description"]
			heuristics: [
				"Description curta — referenciar canvas como source, não duplicar.",
				"info.version 0.1.0 pré-prod é honestidade de status; só sobe pra 1.0.0 quando o BC for liberado em produção.",
			]
		}
		"servers-or-deferred": {
			target:    "#APISpec"
			objective: "Declarar servers só com ADR de deploy, ou registrar gap em def-XXX."
			process: [{
				action: "Verificar se existe ADR de deploy/transport com URLs base decididas."
				detail: "Grep em architecture/adrs/ por 'deploy', 'host', 'environment', 'server'."
			}, {
				action: "SE existe ADR: declarar servers[] com url + description por ambiente (dev/stg/prod) coerente com o ADR."
			}, {
				action: "SE NÃO existe ADR: omitir servers do arquivo + criar def-XXX referenciando o gap (mesma disciplina do def-023 pra bindings)."
			}, {
				action: "NUNCA inventar URL sem ADR — vira contrato escondido."
			}]
			doneCriteria: "servers presentes E coerentes com ADR-XXX de deploy, OU ausência registrada em def-XXX rastreável."
			sources: ["architecture/adrs/ (busca por ADR de deploy)"]
			heuristics: [
				"Sem ADR de deploy, URL é chute. Melhor ficar sem do que inventar.",
			]
		}
		"paths-and-operations": {
			target:    "#APISpec"
			objective: "Mapear commands→POST e projections→GET sob /v1/<bc>/, sem REST resource forçado."
			process: [{
				action: "Listar commands de contexts/<bc>/domain-model.cue."
			}, {
				action: "Para cada command EXPOSED (confirmado no prerequisites): criar path 'POST /v1/<bc-code>/commands/<command-name-kebab>'."
				detail: "operationId em camelCase único (ex: 'proposeCommitment'); commands são INTENÇÕES MUTÁVEIS, não recursos — RPC POST é a forma honesta. NÃO PUT/PATCH/DELETE 'porque REST'."
			}, {
				action: "Listar projections de contexts/<bc>/domain-model.cue."
			}, {
				action: "Para cada projection EXPOSED: criar path 'GET /v1/<bc-code>/queries/<query-name-kebab>' com queryParameters derivados de queryCapabilities."
				detail: "Queries são LEITURAS PURAS — GET sem side-effects. Body em GET é proibido por convenção; tudo via query params ou path params."
			}, {
				action: "Cada operation declara: summary, description, requestBody (POST) OU parameters (GET), responses (success + errors via $ref)."
			}, {
				action: "PROIBIDO injetar PUT/PATCH/DELETE 'porque REST' se o domain-model não tem command correspondente."
				detail: "OpenAPI é só transporte HTTP do modelo operacional Mesh; o domain-model é a autoridade do que existe como operação. Aderir ao REST cargo cult contradiz o spec."
			}]
			doneCriteria: "Cada command exposed tem POST /v1/<bc>/commands/<kebab>; cada projection exposed tem GET /v1/<bc>/queries/<kebab>; zero PUT/PATCH/DELETE não-justificados por command no domain-model."
			sources: [
				"contexts/<bc>/domain-model.cue: commands[], projections[], aggregate.handlesCommands, aggregate.emitsEvents",
				"contexts/<bc>/canvas.cue: integration patterns",
			]
			heuristics: [
				"Commands são ações; mapear como verb-named POST é fiel ao modelo. REST resource forçaria substantivar o que é verbo — perdas semânticas garantidas.",
				"Se uma 'rota REST' parece tentadora mas não tem command correspondente, pare: ou o domain-model está incompleto (criar command), ou a rota é desnecessária.",
			]
		}
		"components-schemas": {
			target:    "#APISpec"
			objective: "Materializar request schemas (inline mirror do domain-model) e response schemas (via $ref pra events.cue)."
			process: [{
				action: "Para cada command exposed, definir components.schemas.<CommandName>Request como JSON Schema (object com properties)."
				detail: "Mirror MANUAL dos campos do command em domain-model.cue (NÃO de schemas/commands.cue — esse arquivo não existe; criar agora seria abstração prematura). Anotar com x-mesh-cue-ref: 'contexts/<bc>/domain-model.cue#commands.<command-code>' como vínculo de auditoria."
			}, {
				action: "Para cada command, success response referencia schemas/events.cue#<EventName> via $ref."
				detail: "Quando o command emite um único evento (per aggregate.emitsEvents), response usa esse evento; quando emite múltiplos, response declara wrapper { emittedEvents: [<refs>] } ou similar — flagar em openQuestions se for o caso."
			}, {
				action: "Para cada projection, definir components.schemas.<QueryName>Response como JSON Schema mirror da projection."
				detail: "Anotar x-mesh-cue-ref: 'contexts/<bc>/domain-model.cue#projections.<projection-code>'."
			}, {
				action: "Opaque refs cross-BC (RiskLevel, ParticipantId, ContractTermsId, etc.) viram string com description='owned by <BC-owner>' — mesma convenção do async-api."
			}, {
				action: "QUANDO schemas/commands.cue for criado no futuro (def-XXX disparado), ele vira SoT dos request bodies; este section refatora pra apontar x-mesh-cue-ref pra ele."
			}]
			doneCriteria: "Todo request body referenciado por rotas tem schema em components.schemas com x-mesh-cue-ref pra domain-model.cue#commands.<code>; todo response success usa $ref pra events.cue ou domain-model.cue#projections.<code>."
			sources: [
				"contexts/<bc>/domain-model.cue: commands[].fields, projections[].queryCapabilities, aggregate.emitsEvents",
				"contexts/<bc>/schemas/events.cue: #<EventName>",
			]
			heuristics: [
				"Request mirror manual do domain-model é a verdade hoje; quando commands.cue existir, a auditoria fica mais ergonômica via x-mesh-cue-ref direto ao type CUE.",
				"Drift entre request e command semantics (campos extras, faltantes, ou required wrong) é o risco principal — revisão humana é a defesa até gate cross-file existir.",
			]
		}
		"components-responses-and-errors": {
			target:    "#APISpec"
			objective: "Declarar error responses padronizadas via RFC 7807 Problem, sem custom shape por rota."
			process: [{
				action: "Definir UM components.schemas.Problem conformante com RFC 7807 (type, title, status, detail, instance + ext fields como traceId, causeType)."
				detail: "Problem é CROSS-BC SHARED CONTRACT — todos os BCs usam EXATAMENTE este shape, sem customização por BC. Customizar por BC fragmenta o cliente; é proibido."
			}, {
				action: "Definir error responses padronizadas: 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity, 500 Internal Server Error."
				detail: "Cada uma referencia content 'application/problem+json' com $ref pro #/components/schemas/Problem."
			}, {
				action: "Cada operation declara responses referenciando essas error responses comuns via $ref."
				detail: "Nenhum shape inline — toda rota usa $ref. Quebrar esta regra é proibido."
			}, {
				action: "Documentar quais códigos cada operation pode retornar — não enumerar todos em todas; só os realmente possíveis."
			}]
			doneCriteria: "components.schemas.Problem único e conformante RFC 7807; error responses padronizadas declaradas uma vez; toda operation usa $ref pra error responses comuns (zero shapes inline)."
			sources: ["RFC 7807 (https://datatracker.ietf.org/doc/html/rfc7807) — referência externa"]
			heuristics: [
				"Errors fragmentados criam consumer-side soup; um Problem cross-BC é a defesa contra error explosion.",
				"NÃO customizar Problem por BC. Se um BC sente necessidade de campos extras, abrir tension-entry pra discutir extensão CROSS-BC, não fork local.",
			]
		}
		"security-or-deferred": {
			target:    "#APISpec"
			objective: "Declarar securitySchemes só com ADR de auth, ou registrar gap em def-XXX."
			process: [{
				action: "Verificar se existe ADR de auth (OAuth2/OIDC/JWT/mTLS/outro)."
				detail: "Grep em architecture/adrs/ por 'auth', 'jwt', 'oauth', 'oidc', 'mtls'."
			}, {
				action: "SE existe ADR: declarar components.securitySchemes coerente com o tipo decidido + security global no root."
			}, {
				action: "SE NÃO existe ADR: omitir security do arquivo + criar def-XXX rastreável (mesma disciplina do def-023 pra bindings)."
			}, {
				action: "NUNCA inventar auth scheme sem ADR — exposição não-decidida vira incidente."
			}]
			doneCriteria: "security presente E coerente com ADR-XXX de auth, OU ausência registrada em def-XXX rastreável."
			sources: ["architecture/adrs/ (busca por ADR de auth)"]
			heuristics: [
				"Sem ADR de auth, security é chute. Mesma disciplina anti-fantasma do servers e bindings.",
			]
		}
	}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/api-spec\\.cue$"
			fileNameRegex:      "^api-spec\\.cue$"
			description:        "Production guide para autoria de api.yaml por BC com hasSyncSurface=true."
			rationale:          "OpenAPI 3.x é spec externa; PG aterra as convenções mesh (RPC POST pra commands, GET pra queries, sem REST forçado; request SoT em domain-model até commands.cue existir; Problem cross-BC; auth/servers só com ADR). Sem PG, a tradução domain-model + events.cue → api.yaml fica improvisada e diverge cross-BC."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-api-01"
			description: "Coverage: todo command exposed do domain-model tem path POST; toda projection exposed tem GET"
			test:        "Para cada command exposed em contexts/<bc>/domain-model.cue (confirmado no prerequisites), existe path POST /v1/<bc>/commands/<kebab> em api.yaml; análogo para projections via GET /v1/<bc>/queries/<kebab>. Commands/projections marcados internal ficam fora; ausência sem registro em openQuestions falha."
			severity:    "fail"
			rationale:   "Sem coverage, contratos prometidos no canvas/domain-model ficam sem materialização. Founder define exposed vs internal em prerequisites; agente NÃO infere por conta própria."
		}, {
			id:          "tq-api-02"
			description: "Fidelidade semântica: request schemas mirror command fields E não divergem do command intent"
			test:        "Para cada request body de POST /v1/<bc>/commands/<kebab>, mirror dos commands[].fields do domain-model com x-mesh-cue-ref apontando pra contexts/<bc>/domain-model.cue#commands.<command-code>. Shapes batem (campos required, types). E o request NÃO PODE DIVERGIR SEMANTICAMENTE do command intent declarado: required fields, lifecycle transitions implícitas (qual estado o command produz), e emitted events declarados em aggregate.emitsEvents devem ser coerentes com o que a operation promete. Drift de shape OU drift de intenção operacional falham."
			severity:    "fail"
			rationale:   "O risco real no sync surface não é só shape drift — é drift de INTENÇÃO operacional (command que aceita request 'incompleto' mas produz lifecycle 'completo' silenciosamente; ou response que afirma transition que o aggregate não faz). Schema mirror sem semântica casada vira contrato pseudo-fiel."
		}, {
			id:          "tq-api-03"
			description: "Naming convention RPC-style versionada, sem REST forçado"
			test:        "Todos paths seguem '/v1/<bc-code>/commands/<kebab>' (POST) ou '/v1/<bc-code>/queries/<kebab>' (GET). NENHUM PUT/PATCH/DELETE existe sem command correspondente no domain-model. operationId em camelCase único."
			severity:    "warn"
			rationale:   "Commands são ações; mapear como RPC POST verb-named é fiel ao modelo Mesh. REST cargo cult força substantivar o que é verbo e injeta verbos HTTP (PUT/PATCH/DELETE) sem comando correspondente — drift de modelo. Warn (não fail) porque exceções legítimas (CRUD genuíno) podem existir, mas raras."
		}, {
			id:          "tq-api-04"
			description: "Error envelope único RFC 7807 cross-BC, referenciado por $ref"
			test:        "Existe components.schemas.Problem conformante RFC 7807. Todos error responses (4xx, 5xx) declaram content 'application/problem+json' com $ref pra esse Problem. NENHUM shape de erro inline em rota. Problem NÃO é customizado por BC — é o MESMO shape em todos os api.yaml."
			severity:    "fail"
			rationale:   "Errors fragmentados criam consumer-side soup; Problem cross-BC é a defesa. Customizar por BC fragmenta o cliente. RFC 7807 é interoperável e standard."
		}, {
			id:          "tq-api-05"
			description: "Auth e servers: presentes E coerentes com ADR, OU ausentes E gap registrado"
			test:        "Ou existe ADR de auth/deploy e securitySchemes/servers concretos coerentes, ou não há ADR e cada gap (auth, servers) está em def-XXX rastreável. Auth/servers inventados sem ADR falham."
			severity:    "fail"
			rationale:   "Auth ausente sem registro = exposição não-decidida; auth inventado = contrato escondido. Mesma disciplina anti-binding-fantasma do tq-async-04. Aplica também a servers (URL fantasma).",
		}]
		rationale: "5 critérios cobrem: coverage commands/queries↔domain-model (tq-api-01), fidelidade DE INTENÇÃO além de shape (tq-api-02), naming RPC anti-REST-cargo-cult (tq-api-03 warn), error envelope único cross-BC (tq-api-04), auth+servers só com ADR (tq-api-05). Fail onde o risco é drift contratual cross-BC, drift semântico de operações, ou dívida arquitetural escondida; warn onde exceções legítimas podem existir."
	}
}
