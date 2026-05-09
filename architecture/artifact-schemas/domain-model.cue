package artifact_schemas

// domain-model.cue — Schema para Domain Model (DDD tactical design).
//
// O domain model formaliza os building blocks do DDD dentro de um BC.
// Catálogos de events, commands, invariants e value objects são top-level.
// Aggregates são a camada de wiring que conecta building blocks.
//
// Estratégia desta versão:
// - behavior-first: events → commands → invariants → value objects → aggregates
// - aggregates declaram o que handlam, emitem e protegem (wiring layer)
// - entities são nested em aggregates (ownership); value objects são catálogo (reúso)
// - lifecycle é state machine opcional por aggregate com transições validáveis
// - policies formalizam automação event → command com guards opcionais
// - domain services coordenam múltiplos aggregates (lógica que não pertence a nenhum)
// - visibility em events distingue internal de published
// - sourceContext em events marca traduções ACL de sinais externos
// - prefixos por catálogo eliminam refs cross-type inválidas por regex
// - domain fields e identity types são union discriminado (primitive / value-object-ref / domain-type)
// - modules são agrupamento organizacional com rationale obrigatório
// - refs são internas ao domain model; cross-artifact validado por runner
//
// Ancoragem nos princípios Mesh:
// - behavior-first ordering: events como building block primário porque
//   Event Log é SoT de fatos (P3). Commands e invariants definem
//   vocabulário comportamental antes de aggregates.
// - lifecycle com guards referenciando invariants: gates determinísticos
//   (P10) formalizados no nível tático.
// - visibility em events: canvas Mesh declara comunicação cross-BC como
//   identidade; domain model alinha via internal/published.
// - sourceContext para traduções ACL: rastreabilidade de sinais externos
//   na arquitetura multi-BC da Mesh.
// - prefixed refs: type-safety por construção (P1, CUE como SoT).
// - policies (event → command): formaliza "agentes recomendam, gates
//   validam" (P10) como automação tática.
// - quality criteria cross-artifact com canvas: canvas é documento de
//   identidade do BC na Mesh; domain model deve alinhar.
//
// Limitações conhecidas:
// - Saga/Process Manager não tem building block first-class. Coordenação
//   cross-aggregate com compensação é modelada via domain service ou
//   deferida ao Workflow History (P5). Avaliar building block dedicado
//   quando instâncias revelarem padrão recorrente.
// - #DomainTypeField aceita qualquer PascalCase. Validação cross-glossary
//   depende de #Glossary (WI-021).
//
// O que NÃO vive aqui:
// - SoT affinity (Event Log, Ledger, Workflow History) → Architecture Communication Canvas
// - wire format de events/commands (Ion, JSON) → AsyncAPI / OpenAPI specs
// - infrastructure ports (EventLogPort, LedgerPort) → design-principles.cue / Architecture Communication Canvas

#DomainModel: {
	code: string & =~"^[a-z][a-z0-9-]*$"
	name: string & !=""

	// Referência ao BC que este domain model realiza.
	// Runner valida que corresponde ao canvas.code do BC.
	boundedContextRef: #BoundedContextRef

	// =============================================
	// BUILDING BLOCK CATALOGS (behavior-first order)
	// =============================================

	// Domain events: fatos que aconteceram.
	events: [#DomainEvent, ...#DomainEvent]

	// Commands: intenções de mutação de estado.
	commands: [#Command, ...#Command]

	// Invariants: regras de negócio que nunca podem ser violadas.
	invariants: [#Invariant, ...#Invariant]

	// Value objects: tipos de domínio imutáveis sem identidade.
	// Catálogo top-level para reúso entre aggregates.
	valueObjects?: [...#ValueObject]

	// =============================================
	// AGGREGATES (consistency boundaries / wiring)
	// =============================================

	aggregates: [#Aggregate, ...#Aggregate]

	// =============================================
	// ORGANIZATIONAL GROUPING (optional)
	// =============================================

	// Modules agrupam aggregates para futura extração em microservices.
	// Cross-module consistency via events, não database constraints.
	modules?: [...#Module]

	// =============================================
	// CROSS-AGGREGATE CONCERNS
	// =============================================

	// Lógica que não pertence a nenhum aggregate individual.
	// Existe para coordenação de múltiplos aggregates.
	// Se a lógica é automação simples event → command, usar policy.
	domainServices?: [...#DomainService]

	// Automação event → command com guards opcionais (Policy do EventStorming).
	// Policy é automação local: um event dispara um command sob condições.
	// Para orquestração complexa entre múltiplos aggregates, usar domain service.
	policies?: [...#Policy]

	// Read models derivados de events para consulta.
	projections?: [...#Projection]

	// =============================================
	// INTERPRETATION CONTRACTS (optional, per adr-081)
	// =============================================

	// Declara modelo global de consistência do sistema. Sem declaração,
	// consumers assumem consistência mais forte possível por construção.
	systemConsistencyModel?: #SystemConsistencyModel

	// Declara papel do BC no ecosystem cross-BC (authoritative /
	// advisory / hybrid). Sem declaração, integração cross-BC quebra
	// silenciosamente.
	decisionAuthorityModel?: #DecisionAuthorityModel

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/domain-model\\.cue$"
			fileNameRegex:      "^domain-model\\.cue$"
			description:        "Domain model: design tático com building blocks DDD formalizados."
			rationale:          "Domain model vive na raiz do BC junto ao canvas. É o segundo artefato que um agente lê após o canvas."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-dm-01"
			description: "Todo command é handled por exatamente um aggregate"
			test:        "Cada commands[].code aparece em exatamente um aggregates[].handlesCommands[]. Command em zero aggregates é órfão. Command em dois aggregates viola consistency boundary."
			severity:    "fail"
			rationale:   "Em DDD, um command é endereçado a exatamente um aggregate root."
		}, {
			id:          "tq-dm-02"
			description: "Todo event é emitted por ao menos um aggregate"
			test:        "Cada events[].code aparece em ao menos um aggregates[].emitsEvents[]."
			severity:    "fail"
			rationale:   "Evento sem aggregate de origem é fato sem causa."
		}, {
			id:          "tq-dm-03"
			description: "Toda invariant é protected por ao menos um aggregate"
			test:        "Cada invariants[].code aparece em ao menos um aggregates[].protectsInvariants[]."
			severity:    "fail"
			rationale:   "Invariante sem aggregate protetor é regra sem enforcement."
		}, {
			id:          "tq-dm-04"
			description: "Todo value object é usado por ao menos um aggregate ou entity"
			test:        "Se valueObjects está presente, cada valueObjects[].code aparece em ao menos um aggregates[].usesValueObjects[] ou em aggregates[].entities[].usesValueObjects[]."
			severity:    "warn"
			rationale:   "Value object órfão indica tipo definido mas não utilizado."
		}, {
			id:          "tq-dm-05"
			description: "Policies referenciam events, commands e invariants válidos"
			test:        "Cada policies[].triggeredByEvent existe em events[].code. Cada policies[].issuesCommand existe em commands[].code. Cada ref em policies[].guards[] existe em invariants[].code."
			severity:    "fail"
			rationale:   "Policy com referência quebrada é automação fantasma."
		}, {
			id:          "tq-dm-06"
			description: "Projections referenciam events válidos"
			test:        "Cada ref em projections[].consumesEvents[] existe em events[].code."
			severity:    "fail"
			rationale:   "Projection consumindo evento inexistente é read model sem fonte."
		}, {
			id:          "tq-dm-07"
			description: "Lifecycle transitions referenciam building blocks válidos"
			test:        "Em cada aggregate com lifecycle, cada transition.triggeredByCommand existe em commands[].code, cada ref em transition.emitsEvents existe em events[].code, e cada ref em transition.guards existe em invariants[].code."
			severity:    "fail"
			rationale:   "Transição com referência quebrada é estado inatingível ou inconsistente."
		}, {
			id:          "tq-dm-08"
			description: "Lifecycle states em transitions existem na lista de states"
			test:        "Em cada aggregate com lifecycle, cada transition.from e transition.to existe em lifecycle.states[]. lifecycle.initialState existe em lifecycle.states[]."
			severity:    "fail"
			rationale:   "Transição referenciando estado inexistente é state machine inválida."
		}, {
			id:          "tq-dm-09"
			description: "Domain services referenciam aggregates válidos"
			test:        "Cada ref em domainServices[].orchestrates[] existe em aggregates[].code."
			severity:    "fail"
			rationale:   "Service orquestrando aggregate inexistente é coordenação fantasma."
		}, {
			id:          "tq-dm-10"
			description: "Modules referenciam aggregates válidos sem sobreposição"
			test:        "Se modules está presente, cada ref em modules[].aggregateRefs[] existe em aggregates[].code. Nenhum aggregate aparece em mais de um module."
			severity:    "fail"
			rationale:   "Aggregate em dois modules viola separação modular."
		}, {
			id:          "tq-dm-11"
			description: "Events publicados alinham com canvas outbound event-publishers"
			test:        "Cada events[] com visibility 'published' deve ter correspondência em canvas communication outbound como event-publisher. Validação por runner."
			severity:    "fail"
			rationale:   "Evento published sem declaração no canvas é contrato invisível."
		}, {
			id:          "tq-dm-12"
			description: "Commands alinham com canvas inbound command-handlers"
			test:        "Cada command handled por um aggregate deve ter correspondência em canvas communication inbound como command-handler. Validação por runner."
			severity:    "warn"
			rationale:   "Nem todo command precisa aparecer no canvas (commands internos emitidos por policies). Commands expostos externamente devem estar no canvas."
		}, {
			id:          "tq-dm-13"
			description: "Codes são únicos dentro de cada catálogo e prefixos são corretos"
			test:        "Nenhum code duplicado em events[], commands[], invariants[], valueObjects[], aggregates[], modules[], domainServices[], policies[], projections[]. Cada code segue o prefixo do seu catálogo (evt-, cmd-, inv-, vo-, agg-, mod-, svc-, pol-, prj-). Entities seguem ent-. Query capabilities seguem qry-."
			severity:    "fail"
			rationale:   "Code duplicado quebra integridade referencial. Prefixo incorreto permite ref cross-type acidental."
		}, {
			id:          "tq-dm-14"
			description: "Value object refs em domain fields apontam para catálogo válido"
			test:        "Cada #DomainField com kind 'value-object-ref' tem valueObjectRef que existe em valueObjects[].code. Cada #IdentityType com kind 'value-object-ref' tem valueObjectRef que existe em valueObjects[].code."
			severity:    "fail"
			rationale:   "Field ou identity referenciando value object inexistente é tipo fantasma."
		}, {
			id:          "tq-dm-15"
			description: "Eventos consumidos no canvas têm correspondência no domain model"
			test:        "Cada canvas inbound event-consumer tem um evento correspondente com sourceContext preenchido no catálogo events[], ou uma policy triggeredByEvent que reage ao sinal traduzido. Validação por runner."
			severity:    "warn"
			rationale:   "Evento consumido pelo canvas sem representação no domain model é sinal externo sem reação formalizada. Warn porque a modelagem pode ser via command direto do adapter sem evento intermediário."
		}, {
			id:          "tq-dm-16"
			description: "Projections cobrem query-surfaces declaradas no canvas"
			test:        "Para cada query-surface no canvas do BC, ao menos uma projection.queryCapabilities no domain model descreve a mesma capability. Validação por runner/unificação."
			severity:    "warn"
			rationale:   "Sem este critério, canvas pode declarar query-surface sem modelo de projeção correspondente, criando contrato sem implementação conceitual."
		}, {
			id:          "tq-dm-17"
			description: "Cross-aggregate state dependency refs (intra-BC) resolvem"
			test:        "Para cada invariant com dependsOnAggregateState onde boundedContextRef está ausente: aggregateRef existe em aggregates[].code do mesmo domain-model. Quando accessVia.kind='projection', projectionRef existe em projections[].code. Refs cross-BC (boundedContextRef presente) delegadas a runner cross-file."
			severity:    "fail"
			rationale:   "Dependência intra-BC com ref quebrada é guard fantasma — invariant declara dependência de aggregate ou projection inexistente. Per adr-055."
		}]
		rationale: "Critérios cobrem integridade referencial interna (tq-dm-01 a tq-dm-10, tq-dm-13, tq-dm-14, tq-dm-17), alinhamento cross-artifact com canvas Mesh (tq-dm-11, tq-dm-12, tq-dm-15, tq-dm-16) e consistência de lifecycle com gates determinísticos (tq-dm-07, tq-dm-08)."
	}
}

// ==============================
// DOMAIN EVENTS
// ==============================

// Union discriminada por visibility:
// - internal: sourceContext permitido (tradução ACL de sinal externo)
// - published: sourceContext proibido (evento nasce neste BC)
// Estado inválido (published + sourceContext) é irrepresentável.
#DomainEvent:
	#InternalDomainEvent |
	#PublishedDomainEvent

_#DomainEventBase: {
	code:        string & =~"^evt-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""
	rationale:   string & !=""

	// Domain-level fields. Wire format (Ion/JSON) vive no AsyncAPI.
	fields?: [...#DomainField]

	// Rastreabilidade ao EventStorming.
	eventStormingRef?: string & !=""

	// Open for extension by subtypes (visibility, sourceContext).
	...
}

#InternalDomainEvent: _#DomainEventBase & {
	// Eventos internal ficam dentro do BC.
	visibility: "internal"

	// Origem externa para traduções ACL.
	// Quando presente, indica que este evento interno é tradução de um
	// sinal externo recebido via ACL. O domain model permanece puro
	// (evento tem semântica local), mas a rastreabilidade ao BC ou
	// sistema externo de origem é preservada.
	// Runner valida contra canvas event-consumers.
	sourceContext?: #SourceContextRef
}

#PublishedDomainEvent: _#DomainEventBase & {
	// Eventos published cruzam fronteiras do BC e devem aparecer no AsyncAPI.
	// sourceContext proibido: evento publicado é originário deste BC.
	visibility:    "published"
	sourceContext?: _|_
}

// ==============================
// COMMANDS
// ==============================

#Command: {
	code:        string & =~"^cmd-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""
	rationale:   string & !=""

	// Domain-level fields.
	fields?: [...#DomainField]

	// Rastreabilidade ao EventStorming.
	eventStormingRef?: string & !=""
}

// ==============================
// INVARIANTS
// ==============================

#Invariant: {
	code: string & =~"^inv-[a-z][a-z0-9-]*$"
	name: string & !=""

	// Regra de negócio em linguagem natural.
	rule: string & !=""

	// Por que esta regra existe.
	rationale: string & !=""

	// Rastreabilidade ao EventStorming (gates, business rules).
	eventStormingRef?: string & !=""

	// Cross-aggregate state dependency (CQRS read path).
	// Quando esta invariant depende de state de outro aggregate
	// (intra-BC ou cross-BC) para enforcement, declarar aqui em vez
	// de só prose. Per adr-055.
	// Granularidade per-invariant derivada de evidência empírica:
	// 4 de 27 invariants em mesh-spec (~15%) são cross-aggregate;
	// aggregate-level field super-estimaria a dependência.
	dependsOnAggregateState?: #CrossAggregateStateDependency
}

// Dependência de state cross-aggregate. Read-only por construção
// (CQRS). Intra-BC: aggregate alvo no mesmo domain-model. Cross-BC:
// aggregate alvo em outro BC, acessado via canvas query-surface.
// Per adr-055.
#CrossAggregateStateDependency: {
	// BC alvo. Omitido = mesma BC do parent #DomainModel.
	// Presente = dependência cross-BC (runner cross-file futuro valida).
	boundedContextRef?: #BoundedContextRef

	// Aggregate alvo (prefix agg-). Validado por tq-dm-17 apenas
	// quando boundedContextRef ausente (intra-BC); cross-BC delegado
	// a runner cross-file.
	aggregateRef: #AggregateRef

	// Mecanismo de read.
	accessVia: #AccessVia

	// Por que esta dependência existe e não pode ser modelada como
	// invariant local do aggregate dependido.
	rationale: string & !=""
}

// Mecanismo de acesso a state cross-aggregate. Discriminated union:
// projection (read model nomeado, intra-BC) ou sync-query (canvas
// query-surface, intra ou cross-BC). Ambos read-only por construção.
#AccessVia:
	#AccessViaProjection |
	#AccessViaSyncQuery

#AccessViaProjection: {
	kind:          "projection"
	projectionRef: #ProjectionRef
}

#AccessViaSyncQuery: {
	kind: "sync-query"
	// Nome PascalCase de query-surface declarada no canvas do BC alvo
	// (cross-BC) ou do BC corrente (intra-BC raro). Não validado
	// sintaticamente contra canvas no schema; runner cross-file valida.
	canvasQuerySurface: string & =~"^[A-Z][A-Za-z0-9]*$"
}

// ==============================
// VALUE OBJECTS
// ==============================

// Tipos de domínio imutáveis sem identidade.
// Catálogo top-level para reúso entre aggregates.
#ValueObject: {
	code:        string & =~"^vo-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""
	fields:      [#DomainField, ...#DomainField]
	constraints?: [...string]

	rationale: string & !=""
}

// ==============================
// DOMAIN FIELDS
// ==============================

// Campos domain-level com tipo discriminado.
// Distingue primitivos, referências a value objects e named domain types.
// Isso evita mistura de conceitos de domínio com tipos de linguagem.
//
// Limitação conhecida: #DomainTypeField aceita qualquer PascalCase.
// Validação cross-glossary será adicionada quando schema #Glossary
// existir (WI-021). Até lá, consistência é responsabilidade do agente.
#DomainField:
	#PrimitiveField |
	#ValueObjectRefField |
	#DomainTypeField

#PrimitiveField: {
	kind:         "primitive"
	name:         string & !=""
	type:         #PrimitiveType
	description?: string & !=""
}

#ValueObjectRefField: {
	kind:           "value-object-ref"
	name:           string & !=""
	valueObjectRef: #ValueObjectRef
	description?:   string & !=""
}

// Named domain types são conceitos de domínio que não são primitivos nem VOs
// catalogados neste domain model. Exemplos: Money, ParticipantId, DateRange.
// O campo type deve ser nome de conceito de domínio na Ubiquitous Language,
// não tipo de linguagem (BigDecimal, UUID) nem wire type (string, int64).
// Regex impõe PascalCase para reforçar que é tipo de domínio nomeado.
#DomainTypeField: {
	kind:         "domain-type"
	name:         string & !=""
	type:         string & =~"^[A-Z][A-Za-z0-9]*$"
	description?: string & !=""
}

#PrimitiveType:
	"string" |
	"boolean" |
	"integer" |
	"decimal" |
	"date" |
	"datetime"

// ==============================
// IDENTITY TYPES
// ==============================

// Tipo de identidade para aggregate roots e entities.
// Usa a mesma distinção de domain fields para evitar
// mistura de conceitos de domínio com tipos de linguagem.
#IdentityType:
	#PrimitiveIdentity |
	#ValueObjectIdentity |
	#DomainTypeIdentity

#PrimitiveIdentity: {
	kind: "primitive"
	type: #PrimitiveType
}

#ValueObjectIdentity: {
	kind:           "value-object-ref"
	valueObjectRef: #ValueObjectRef
}

// Named domain type como identity (e.g., CommitmentId, ParticipantId).
// Regex impõe PascalCase.
#DomainTypeIdentity: {
	kind: "domain-type"
	type: string & =~"^[A-Z][A-Za-z0-9]*$"
}

// ==============================
// AGGREGATES
// ==============================

// Aggregate é a raiz de consistência transacional.
// Declara quais commands aceita, quais events emite e quais invariants protege.
// Entities são nested (owned). Value objects são referenciados do catálogo.
#Aggregate: {
	code:        string & =~"^agg-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""

	// Identidade do aggregate root.
	rootIdentity: {
		field: string & !=""
		type:  #IdentityType
	}

	// Campos do aggregate root.
	// O aggregate root é uma entity com estado próprio. Campos que
	// não são entities nem value objects vivem aqui (e.g., status,
	// timestamps, flags). Simétrico com #Entity.fields.
	fields?: [...#DomainField]

	// === WIRING ===

	// Commands que este aggregate aceita.
	handlesCommands: [#CommandRef, ...#CommandRef]

	// Events que este aggregate emite.
	emitsEvents: [#EventRef, ...#EventRef]

	// Invariants que este aggregate protege.
	protectsInvariants: [#InvariantRef, ...#InvariantRef]

	// === INTERNAL STRUCTURE ===

	// Child entities owned por este aggregate.
	entities?: [...#Entity]

	// Value objects do catálogo usados por este aggregate.
	usesValueObjects?: [...#ValueObjectRef]

	// === LIFECYCLE (optional) ===

	// State machine do aggregate.
	lifecycle?: #Lifecycle

	// === INTERPRETATION CONTRACT (optional, per adr-081) ===

	// Declara contrato de consistência transacional do aggregate.
	// Distingue garantias intra-aggregate (atomic/ACID) de side-effects
	// cross-aggregate (eventual via events). Optional — ausência implica
	// default eventual via systemConsistencyModel do parent #DomainModel.
	consistencyBoundary?: #ConsistencyBoundary

	// Por que este é um consistency boundary separado.
	rationale: string & !=""
}

// ==============================
// ENTITIES
// ==============================

// Objetos com identidade dentro de um aggregate.
// Owned pelo aggregate — não existem fora dele.
#Entity: {
	code:        string & =~"^ent-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""

	identity: {
		field: string & !=""
		type:  #IdentityType
	}

	fields?: [...#DomainField]

	// Value objects do catálogo usados por esta entity.
	usesValueObjects?: [...#ValueObjectRef]

	// Por que esta entity tem identidade própria e não é value object,
	// e por que não é aggregate root separado.
	rationale: string & !=""
}

// ==============================
// LIFECYCLE
// ==============================

// State machine de um aggregate.
// States são nomes; transitions conectam states a commands, events e guards.
// initialState deve existir em states[] (validado por tq-dm-08).
#Lifecycle: {
	initialState: string & !=""

	// Ao menos 2 states (initial + pelo menos um destino).
	states: [string & !="", string & !="", ...(string & !="")]

	// Ao menos uma transition.
	transitions: [#StateTransition, ...#StateTransition]
}

#StateTransition: {
	from: string & !=""
	to:   string & !=""

	// Command que dispara a transição.
	triggeredByCommand: #CommandRef

	// Events emitidos quando a transição ocorre.
	emitsEvents: [#EventRef, ...#EventRef]

	// Invariants verificadas antes de permitir a transição (guards).
	guards?: [...#InvariantRef]

	description?: string & !=""
}

// ==============================
// MODULES
// ==============================

// Agrupamento organizacional de aggregates.
// Prepara separação futura em microservices.
// Cross-module consistency via events, não database constraints.
#Module: {
	code:        string & =~"^mod-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""
	aggregateRefs: [#AggregateRef, ...#AggregateRef]

	// Por que este agrupamento existe.
	rationale: string & !=""
}

// ==============================
// DOMAIN SERVICES
// ==============================

// Lógica de domínio que coordena múltiplos aggregates.
// Existe quando a lógica não pertence a nenhum aggregate individual.
// Se a lógica é automação simples event → command, usar policy.
#DomainService: {
	code:        string & =~"^svc-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""

	// Aggregates que este service coordena.
	orchestrates: [#AggregateRef, ...#AggregateRef]

	// Por que esta lógica não está em um aggregate.
	rationale: string & !=""
}

// ==============================
// POLICIES
// ==============================

// Automação event → command com guards opcionais (Policy do EventStorming).
// Quando um event ocorre e os guards são satisfeitos, esta policy emite um command.
// Policy é automação local: um event, um command, condições opcionais.
// Para coordenação de múltiplos aggregates ou orquestração complexa, usar domain service.
#Policy: {
	code:        string & =~"^pol-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""

	// Event que dispara esta policy.
	triggeredByEvent: #EventRef

	// Command que esta policy emite.
	issuesCommand: #CommandRef

	// Condições que devem ser satisfeitas para a policy executar.
	// Referências a invariants do catálogo.
	guards?: [...#InvariantRef]

	// Por que esta automação existe.
	rationale: string & !=""
}

// ==============================
// PROJECTIONS
// ==============================

// Read models derivados de events para consulta.
// Projeções não mutam estado — são visões otimizadas para leitura.
#Projection: {
	code:        string & =~"^prj-[a-z][a-z0-9-]*$"
	name:        string & !=""
	description: string & !=""

	// Events que esta projection consome para construir a view.
	consumesEvents: [#EventRef, ...#EventRef]

	// Queries que esta projection habilita.
	queryCapabilities: [#QueryCapability, ...#QueryCapability]

	// Por que esta projeção existe.
	rationale: string & !=""
}

#QueryCapability: {
	code:        string & =~"^qry-[a-z][a-z0-9-]*$"
	description: string & !=""

	rationale: string & !=""
}

// ==============================
// INTERPRETATION CONTRACTS (per adr-081)
// ==============================
// Marca semântica via #InterpretationContractMarker embedding: estes
// types declaram CONTRATOS DE INTERPRETAÇÃO do domínio (consistência,
// autoridade, failure handling). NÃO são dados operacionais — são
// metadata governando como consumers + integradores devem interpretar
// comportamento sob concorrência + integração cross-BC + falhas.
// Marker via embedding (não inline _meta literal) preserva single
// source of truth do _meta value + aproveita CUE hidden field
// semantics (`_*` não exportado em cue export).

// Marker reusable embebido em todos interpretation contract types.
// Single source of truth para _meta value; previne drift cross-type.
#InterpretationContractMarker: {
	_meta: "interpretation-contract"
}

// Aggregate-level interpretation contract — declara contrato de
// consistência transacional do aggregate. Distingue garantias intra-
// aggregate (atomic/ACID) de side-effects cross-aggregate (eventual).
// Listas non-empty: contrato vazio é pior que ausência de contrato.
// failureModes declara classes de falha esperadas + handling — sem
// isso, consistência é promessa falsa.
#ConsistencyBoundary: {
	#InterpretationContractMarker
	guarantees: [string & !="", ...string & !=""]
	explicitlyDoesNotGuarantee: [string & !="", ...string & !=""]
	failureModes: [string & !="", ...string & !=""]
	rationale: string & !=""
}

// Domain-level interpretation contract — declara modelo global de
// consistência do sistema composto por todos os aggregates. Sem
// declaração explícita, consumers assumem consistência mais forte
// possível por construção (over-promise). conflictResolution declara
// estratégia canonical de resolução para casos de divergência —
// 'eventual consistency sem estratégia = comportamento indefinido'.
#SystemConsistencyModel: {
	#InterpretationContractMarker
	type: "eventual" | "strong" | "causal"
	intraAggregateGuarantees: [string & !="", ...string & !=""]
	crossAggregateGuarantees: [string & !="", ...string & !=""]
	explicitlyDoesNotGuarantee: [string & !="", ...string & !=""]
	conflictResolution: {
		strategy: "last-write-wins" | "explicit-command" | "causal-ordering"
		rationale: string & !=""
	}
	rationale: string & !=""
}

// Domain-level interpretation contract — declara papel do BC no
// ecosystem cross-BC. Sem declaração explícita, integração cross-BC
// quebra silenciosamente (consumers não sabem se devem obedecer ou
// podem ignorar resultados do BC). Discriminated union por type
// paralelo a #DomainEvent pattern — cada branch obriga scope field
// correspondente E PROÍBE scopes não-aplicáveis via _|_ (bottom).
// Estado misto (advisory com authoritativeScope) é IRREPRESENTÁVEL
// por construção.
#DecisionAuthorityModel:
	#AuthoritativeAuthority |
	#AdvisoryAuthority |
	#HybridAuthority

#AuthoritativeAuthority: {
	#InterpretationContractMarker
	type: "authoritative"
	authoritativeScope: string & !=""
	advisoryScope?: _|_
	rationale: string & !=""
}

#AdvisoryAuthority: {
	#InterpretationContractMarker
	type: "advisory"
	authoritativeScope?: _|_
	advisoryScope: string & !=""
	rationale: string & !=""
}

#HybridAuthority: {
	#InterpretationContractMarker
	type: "hybrid"
	authoritativeScope: string & !=""
	advisoryScope: string & !=""
	rationale: string & !=""
}

// ==============================
// REFS (internas ao domain model)
// ==============================

// Prefixos distintos por catálogo tornam refs cross-type
// irrepresentáveis por regex. Um #CommandRef não pode apontar
// para um event porque o prefixo cmd- não unifica com evt-.
#EventRef:          string & =~"^evt-[a-z][a-z0-9-]*$"
#CommandRef:        string & =~"^cmd-[a-z][a-z0-9-]*$"
#InvariantRef:      string & =~"^inv-[a-z][a-z0-9-]*$"
#ValueObjectRef:    string & =~"^vo-[a-z][a-z0-9-]*$"
#AggregateRef:      string & =~"^agg-[a-z][a-z0-9-]*$"
#BoundedContextRef: string & =~"^[a-z][a-z0-9-]*$"

// Referência a BC interno ou sistema externo como source de tradução ACL.
// Aceita BCs internos ("cmt", "rew") e sistemas externos ("ext-banco-central").
// Alinhado com #ContextOrSystemRef do canvas.
#SourceContextRef: string & =~"^([a-z][a-z0-9-]*|ext-[a-z][a-z0-9-]*)$"
