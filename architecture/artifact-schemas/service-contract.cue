package artifact_schemas

// service-contract.cue — Schema para Service Contract de Bounded Context.
//
// O service contract é o contrato canônico da superfície de um BC na Mesh.
// É a source of truth (SoT) autoral em CUE da qual OpenAPI e AsyncAPI
// YAMLs são derivados mecanicamente — nunca autorais (P1).
//
// ── Escopo e fronteira ──
//
// ServiceContract governa semântica da superfície do BC: operações
// (commands, queries), eventos (publicados, consumidos), erros de
// domínio, links HATEOAS e política de autenticação.
//
// O que NÃO vive aqui (vive em políticas de plataforma ou overlays):
// - retry policy              → platform policy
// - rate limiting / throttling → platform policy
// - pagination profile         → platform convention
// - SLA metadata               → platform overlay
// - observability / tracing    → platform policy
// - deprecation schedule       → platform overlay
// - consumer hints / SDK config → platform overlay
//
// Extensões futuras de plataforma devem ser derivadas de políticas
// comuns ou overlays, não inline neste contrato. ServiceContract
// não é saco de tudo — é semântica de superfície.
//
// ── Derivação ──
//
//   service-contract.cue (SoT autoral)
//       ├── generator-openapi  → contexts/{bc}/api.yaml      (se sync presente)
//       └── generator-asyncapi → contexts/{bc}/async-api.yaml (se async presente)
//
// Presença de cada output é governada pela api-spec-convention.cue
// (bicondicionalidade com canvas.capabilities flags) e enforçada
// pelos structural-checks sc-cv-02/sc-cv-03.
//
// ── Princípios ──
//
// - CUE como SoT, YAML derivado (P1)
// - Operações referenciam domain model por refs canônicas, não nomes
// - Union discriminated types eliminam estados inválidos
// - Erros no contrato são exclusivamente de domínio; erros de
//   transporte são cross-cutting e vivem fora
//
// ADR correspondente: adr-050.

#ServiceContract: {
	// Nome legível do contrato.
	name: string & !=""

	// Versão do contrato (semver).
	apiVersion: string & =~"^[0-9]+\\.[0-9]+\\.[0-9]+$"

	// Referência ao BC que este contrato expõe.
	// Runner valida que corresponde ao canvas.code do BC.
	// Identidade do BC é derivada deste ref — campo code
	// separado seria duplicação.
	boundedContextRef: #BoundedContextRef

	// Descrição do propósito da superfície exposta.
	description: string & !=""

	// ── Superfícies ──
	// Presença de sync/async alinha com canvas.capabilities flags.
	// tq-ct-04 valida bicondicionalidade como duas equivalências.
	sync?:  #SyncSurface
	async?: #AsyncSurface

	// ── Erros de domínio ──
	// SOMENTE erros semânticos de negócio do BC.
	// Erros de transporte (4xx/5xx genéricos, rate limit, auth
	// failure, request validation) são cross-cutting e vivem no
	// mesh-common derivado ou platform policy — não neste contrato.
	errors: [...#DomainError]

	// ── Autenticação default ──
	// Override por operação é possível via auth? em cada command/query.
	defaultAuth: #AuthPolicy

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/service-contract\\.cue$"
			fileNameRegex:      "^service-contract\\.cue$"
			description:        "Service Contract: contrato canônico da superfície síncrona e assíncrona de um BC."
			rationale:          "Service contract vive na raiz do BC junto ao canvas e domain model. É a SoT da qual OpenAPI e AsyncAPI são derivados. Nome service-contract.cue distingue de contratos legais, financeiros ou de integração."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-ct-01"
			description: "Refs de operações apontam para building blocks existentes no domain model"
			test:        "Cada commandRef em sync.commands[] existe em domain-model.cue commands[].code. Cada queryRef em sync.queries[] existe em domain-model.cue projections[].queryCapabilities[].code. Cada eventRef em async.publishedEvents[] e async.consumedEvents[] existe em domain-model.cue events[].code. Cada ref em correlatedWith[] segue regex de building block válido e existe no catálogo correspondente do domain model. Verificação mecânica de existência — não avalia semântica de alinhamento (tq-ct-11 e tq-ct-12 cobrem essa camada). Validação por runner."
			severity:    "fail"
			rationale:   "Ref que não resolve é contrato fantasma. Este critério é a camada base de integridade referencial; tq-ct-11 e tq-ct-12 adicionam invariantes semânticas sobre refs que já passaram neste gate."
		}, {
			id:          "tq-ct-02"
			description: "Erros referenciados nas operações existem no catálogo"
			test:        "Cada ref em possibleErrors[] de commands e queries existe em errors[].code."
			severity:    "fail"
			rationale:   "Erro referenciado mas não catalogado gera projeção OpenAPI com referência quebrada."
		}, {
			id:          "tq-ct-03"
			description: "Links referenciam operationIds válidos do mesmo contrato"
			test:        "Cada links[].targetOperationId existe como operationId em alguma operação (command ou query) do mesmo ServiceContract."
			severity:    "fail"
			rationale:   "Link para operação inexistente gera HATEOAS fantasma na projeção."
		}, {
			id:          "tq-ct-04"
			description: "Superfícies presentes são bicondicional com canvas capability flags"
			test:        "Equivalência 1 (sync): sync presente no contrato ↔ canvas.capabilities.hasSyncSurface == true. Sync presente sem flag true é contrato não declarado no canvas. Flag true sem sync é superfície declarada no canvas mas não contratada. Equivalência 2 (async): async presente no contrato ↔ canvas.capabilities.hasAsyncSurface == true. Async presente sem flag true é contrato não declarado no canvas. Flag true sem async é superfície declarada no canvas mas não contratada. Cada equivalência é testada nos dois sentidos. Adicionalmente, superfície presente deve conter ao menos uma operação (command, query, published event ou consumed event) — superfície vazia é estruturalmente válida em CUE mas semanticamente equivalente a ausência. Validação por runner."
			severity:    "fail"
			rationale:   "Bicondicionalidade garante que canvas e contrato são mutuamente consistentes. Teste em sentido único permite drift silencioso no sentido não verificado."
		}, {
			id:          "tq-ct-05"
			description: "Todo evento consumido declara sourceContext e aclBoundary estruturado"
			test:        "Cada async.consumedEvents[] tem sourceContext preenchido e aclBoundary com kind válido e description não-vazia."
			severity:    "fail"
			rationale:   "Evento consumido sem fronteira ACL explícita é acoplamento escondido — dependência cross-BC sem contorno declarado."
		}, {
			id:          "tq-ct-06"
			description: "operationId segue camelCase verb-first"
			test:        "Cada operationId em commands e queries segue regex ^[a-z]+[A-Z][a-zA-Z0-9]*$ (camelCase iniciando com verbo). Verbo é inglês e descreve a ação ou consulta."
			severity:    "warn"
			rationale:   "Naming consistente facilita descoberta por agentes AI e tooling. Warn porque domínios especializados podem exigir verbos fora de qualquer allowlist predefinida — consistência de formato é mais importante que lista fechada de verbos."
		}, {
			id:          "tq-ct-07"
			description: "Descriptions são não-triviais e orientadas ao consumidor"
			test:        "Cada description em commands, queries, publishedEvents e consumedEvents tem ao menos 20 caracteres e descreve o que a operação faz do ponto de vista do consumidor, não repete o nome."
			severity:    "warn"
			rationale:   "Descriptions alimentam documentação derivada e tool discovery por agentes. Qualidade semântica é advisory, não gate estrutural."
		}, {
			id:          "tq-ct-08"
			description: "Erros de domínio têm guidance acionável"
			test:        "Cada errors[].description explica ao consumidor o que causou o erro e que ação tomar. Não é mensagem de debug interno."
			severity:    "warn"
			rationale:   "Erro sem guidance é caixa preta para o consumidor. Qualidade de guidance é dimensão semântica — warn, não fail."
		}, {
			id:          "tq-ct-09"
			description: "Operações não expõem estado interno do aggregate"
			test:        "Nenhum campo de operação expõe diretamente lifecycle state, internal flags ou campos marcados como internal no domain model. Contrato expõe superfície pública. Critério interpretativo — avaliação por design review, não por runner mecânico. NUNCA automatizar como gate determinístico: julgamento semântico sobre exposição de estado interno não é mecanizável de forma confiável (P10)."
			severity:    "warn"
			rationale:   "Exposição de estado interno acopla consumidor à implementação. Warn porque distinção exata exige julgamento semântico que não é mecanizável."
		}, {
			id:          "tq-ct-10"
			description: "httpStatusCode é semanticamente adequado ao erro de domínio"
			test:        "Faixa 4xx/5xx válida é garantida pelo type system (int & >=400 & <600). Este critério avalia adequação semântica: 409 para conflitos de concorrência, 422 para violação de invariant, 404 para recurso inexistente. StatusCode válido mas semanticamente inadequado (e.g., 500 para erro de negócio, 400 genérico para conflito de concorrência) falha neste critério. Avaliação por design review. NUNCA automatizar como gate determinístico: adequação semântica de HTTP status exige julgamento contextual que LLM pode recomendar mas não decidir (P10)."
			severity:    "warn"
			rationale:   "Adequação semântica do statusCode dirige qualidade da projeção OpenAPI mas exige julgamento interpretativo. Faixa válida é gate estrutural (type system); adequação semântica é advisory."
		}, {
			id:          "tq-ct-11"
			description: "Commands satisfazem invariantes de wiring do domain model"
			test:        "Além de existir (tq-ct-01), cada sync.commands[].commandRef aponta para command handled por exatamente um aggregate no domain model. Aggregate inexistente ou command handled por zero ou mais de um aggregate falha. Validação por runner cruzando commandRef com domain-model handlesCommands."
			severity:    "fail"
			rationale:   "Existência da ref (tq-ct-01) não garante que o wiring tático está correto. Command sem aggregate handler é operação sem executor. Command em dois aggregates viola consistency boundary."
		}, {
			id:          "tq-ct-12"
			description: "Eventos satisfazem invariantes de visibility e sourceContext do domain model"
			test:        "Além de existir (tq-ct-01), cada async.publishedEvents[].eventRef aponta para event com visibility 'published' no domain model. Cada async.consumedEvents[].eventRef aponta para event com sourceContext preenchido no domain model. Evento publicado com visibility 'internal' ou consumido sem sourceContext falha. Validação por runner."
			severity:    "fail"
			rationale:   "Existência da ref (tq-ct-01) não garante alinhamento de visibility. Publicar evento internal expõe sinal que não deveria cruzar fronteira. Consumir evento sem sourceContext perde rastreabilidade ACL."
		}, {
			id:          "tq-ct-13"
			description: "availability não é vazio quando presente"
			test:        "Cada links[].availability, quando presente, contém ao menos um dos campos stateIn ou roleIn com pelo menos um valor. availability: {} é estruturalmente válido em CUE mas semanticamente redundante com ausência de availability. Validação por runner — CUE não suporta 'at least one optional' (mesmo problema de #GovernanceScope em canvas.cue)."
			severity:    "fail"
			rationale:   "availability: {} introduz ambiguidade: link condicional sem condição é indistinguível de link incondicional. Sem este critério, instâncias podem satisfazer o type system e ainda violar a intenção do schema."
		}]
		rationale: "Três camadas por natureza epistemológica: (1) integridade referencial (tq-ct-01 a 03) é mecânica — ref existe ou não; (2) alinhamento cross-artifact (tq-ct-04/05/11/12) é determinístico mas exige cruzamento entre artefatos; (3) qualidade advisory (tq-ct-06 a 10) exige julgamento semântico que LLM recomenda mas não decide (P10). tq-ct-13 é gate estrutural que CUE não consegue expressar nativamente — enforcement por runner como workaround documentado. Separação importa porque misturar fail estrutural com fail semântico produz falsos bloqueios — o mesmo problema que adr-040 resolve na camada pós-commit. Layering tq-ct-01 como prerequisite de tq-ct-11/12 evita findings redundantes."
	}
}

// ==============================
// SYNC SURFACE
// ==============================

#SyncSurface: {
	commands: [...#CommandOperation]
	queries:  [...#QueryOperation]
}

// ── Commands (union discriminada por kind) ──
//
// #CreateCommand: criação de recurso.
//   - idempotência obrigatória (recurso ainda não existe)
//   - concorrência proibida (não há state para conflitar)
//
// #ActionCommand: ação sobre recurso existente.
//   - concorrência obrigatória (recurso existe, precisa de controle otimista)
//   - idempotência declarada (pode ser required ou não)

#CommandOperation:
	#CreateCommand |
	#ActionCommand

_#CommandBase: {
	operationId: string & =~"^[a-z]+[A-Z][a-zA-Z0-9]*$"
	commandRef:  #CommandRef
	name:        string & !=""
	description: string & !=""

	// Erros de domínio possíveis nesta operação.
	possibleErrors: [...#DomainErrorRef]

	// Links HATEOAS para navegabilidade.
	links?: [...#OperationLink]

	// Override de auth para esta operação. Se ausente, usa defaultAuth.
	auth?: #AuthPolicy

	// Supervisão humana antes de execução, se aplicável.
	supervision?: #SupervisionRequirement

	rationale: string & !=""

	// Open for extension by subtypes.
	...
}

// Criação de recurso: idempotência obrigatória, concorrência proibida.
#CreateCommand: _#CommandBase & {
	kind: "create"
	idempotency: #IdempotencyPolicy & {
		required: true
	}
	// Concorrência proibida: recurso não existe ainda.
	concurrency?: _|_
}

// Ação sobre recurso existente: concorrência obrigatória.
#ActionCommand: _#CommandBase & {
	kind:        "action"
	idempotency: #IdempotencyPolicy
	concurrency: #ConcurrencyPolicy
}

// ── Queries (union discriminada por kind) ──
//
// #SingleQuery: retorna item único.
//   - paginação proibida
//
// #CollectionQuery: retorna coleção.
//   - cursor-based pagination por default

#QueryOperation:
	#SingleQuery |
	#CollectionQuery

_#QueryBase: {
	operationId: string & =~"^[a-z]+[A-Z][a-zA-Z0-9]*$"
	queryRef:    #QueryCapabilityRef
	name:        string & !=""
	description: string & !=""

	// Erros de domínio possíveis.
	possibleErrors: [...#DomainErrorRef]

	// Links HATEOAS.
	links?: [...#OperationLink]

	// Override de auth para esta query. Se ausente, usa defaultAuth.
	auth?: #AuthPolicy

	// Cache tier para projeção de headers HTTP.
	cacheTier: #CacheTier

	rationale: string & !=""

	// Open for extension by subtypes.
	...
}

#SingleQuery: _#QueryBase & {
	kind: "single"
	// Paginação proibida para item único.
	paginated?: _|_
}

#CollectionQuery: _#QueryBase & {
	kind: "collection"
	// Cursor-based por default.
	paginated: bool | *true
}

#CacheTier: "volatile" | "list" | "terminal"

// ==============================
// ASYNC SURFACE
// ==============================

#AsyncSurface: {
	publishedEvents: [...#PublishedEventEntry]
	consumedEvents:  [...#ConsumedEventEntry]
}

#PublishedEventEntry: {
	eventRef:    #EventRef
	name:        string & !=""
	description: string & !=""

	// Declaração contratual de ordenação, se aplicável.
	ordering?: #OrderingDeclaration

	rationale: string & !=""
}

#ConsumedEventEntry: {
	eventRef:    #EventRef
	name:        string & !=""
	description: string & !=""

	// BC ou sistema externo de origem.
	sourceContext: #SourceContextRef

	// Fronteira ACL estruturada: tipo de tradução + descrição.
	aclBoundary: #ACLBoundary

	// O que este BC faz ao consumir o evento.
	// Wave 0: texto livre descritivo.
	// ADR-050 registra este campo como o de maior probabilidade de
	// virar ref estruturada na próxima iteração (e.g., reactionRef
	// apontando para cmd-*, pol-* ou prj-*). Não estruturar agora
	// sem instâncias que revelem o padrão dominante. Quando duas ou
	// mais instâncias reais mostrarem convergência, criar tipo
	// dedicado via ADR — não estender este string ad-hoc.
	// Hotspot prioritário de red team: campo com maior risco de
	// virar depósito semântico inconsistente entre BCs e agentes.
	reaction: string & !=""

	// Refs de building blocks correlacionados no domain model.
	// Aceita qualquer building block code válido (cmd-, evt-, agg-,
	// inv-, vo-, prj-, qry-). Runner valida existência (tq-ct-01).
	correlatedWith?: [...string & =~"^(cmd|evt|agg|inv|vo|prj|qry)-[a-z][a-z0-9-]*$"]

	rationale: string & !=""
}

// ==============================
// SUPPORTING TYPES
// ==============================

// Política de idempotência — union por required.
// required: false → mechanism proibido (não há o que declarar).
// required: true → mechanism obrigatório (generator precisa para projeção).
// Padrão consistente com CreateCommand.concurrency?: _|_ e
// #PublishedDomainEvent.sourceContext?: _|_ em domain-model.cue.
#IdempotencyPolicy: ({
	required:   false
	mechanism?: _|_
} | {
	required:  true
	mechanism: #IdempotencyMechanism
}) & {
	rationale: string & !=""
}

// Mecanismos de idempotência com semântica projetável.
// - idempotency-key: cliente envia header Idempotency-Key (POST)
// - natural-key: operação é naturalmente idempotente (PUT com recurso completo)
// Extensão por ADR se novos mecanismos surgirem.
#IdempotencyMechanism: "idempotency-key" | "natural-key"

// Controle de concorrência para ações sobre recursos existentes.
// Wave 0 suporta apenas optimistic — é o padrão adequado para APIs
// HTTP (ETag/If-Match). Extensão para pessimistic (se necessário)
// exigiria union discriminada por strategy com campos estruturais
// distintos, via ADR.
#ConcurrencyPolicy: {
	strategy: "optimistic"

	// Campo do aggregate usado como version token.
	// Generator projeta como ETag (response) e If-Match (request)
	// no OpenAPI derivado. Deve referenciar um campo existente
	// no aggregate root ou entity do domain model.
	//
	// Follow-up estrutural: hoje aceita qualquer string — é ref
	// por convenção, não por tipo. Quando a ontologia de domain
	// fields suportar refs tipadas a campos (e.g., #FieldRef),
	// este campo deve migrar para tipo formal. Até lá, é "string
	// com narrativa" — runner valida por convenção de nomes, não
	// por type system. Registrar em ADR-050.
	versionField: string & !=""

	rationale: string & !=""
}

// Placeholder estrutural mínimo para Wave 0 — union por required.
// required: false → approver proibido.
// required: true → approver obrigatório.
// ADR-050 registra que supervision policy provavelmente evolui
// para tipo próprio (#SupervisionPolicy) quando instâncias
// revelarem distinções necessárias: role exigido, número de
// aprovadores, tipo de supervisão, policy ref.
// NÃO estender este shape ad-hoc — criar tipo dedicado via ADR.
#SupervisionRequirement: ({
	required:  false
	approver?: _|_
} | {
	required: true
	approver: string & !=""
}) & {
	rationale: string & !=""
}

// ── Erros de domínio ──
//
// Somente erros semânticos de negócio do BC.
// Erros de transporte (4xx/5xx genéricos, rate limit, auth failure,
// request validation) são cross-cutting e vivem no mesh-common
// derivado ou platform policy. O contrato não os cataloga.
//
// httpStatusCode é hint de projeção: informa ao generator qual
// HTTP status o erro de domínio projeta. Não mistura domínio com
// transporte — é a ponte semântica entre o conceito de negócio e
// a representação HTTP. Faixa válida enforçada pelo type system;
// adequação semântica avaliada por design review (tq-ct-10, warn).
#DomainError: {
	code:           string & =~"^err-[a-z][a-z0-9-]*$"
	name:           string & !=""
	description:    string & !=""
	httpStatusCode: int & >=400 & <600
	rationale:      string & !=""
}

#DomainErrorRef: string & =~"^err-[a-z][a-z0-9-]*$"

// ── ACL Boundary ──
//
// Tipo de tradução na fronteira de consumo de evento externo.
// Enum fechada nos padrões DDD canônicos relevantes para consumidor:
// - conformist: aceita modelo upstream sem tradução
// - anticorruption-layer: traduz modelo upstream para linguagem local
//
// Extensão por ADR se novos padrões emergirem.
#ACLBoundary: {
	kind:        "conformist" | "anticorruption-layer"
	description: string & !=""
	rationale:   string & !=""
}

// ── Links HATEOAS ──

#OperationLink: {
	rel:               string & !=""
	targetOperationId: string & =~"^[a-z]+[A-Z][a-zA-Z0-9]*$"
	description:       string & !=""

	// Quando o link está disponível — estruturado e verificável.
	// Se ausente, link é incondicional (sempre disponível).
	availability?: #LinkAvailability
}

// Condições de disponibilidade de link — fechada e verificável.
// Estrutura pobre e verificável > string rica e ambígua.
// Ao menos um de stateIn ou roleIn deve estar presente.
// CUE não tem "at least one optional" nativo (mesmo problema
// de #GovernanceScope em canvas.cue). Enforcement por runner:
// availability: {} sem condição é equivalente a link
// incondicional — redundante com ausência de availability.
#LinkAvailability: {
	stateIn?: [string & !="", ...(string & !="")]
	roleIn?:  [string & !="", ...(string & !="")]
}

// ── Ordenação contratual ──
//
// Declaração contratual de ordenação — não prova de implementação.
// Declara a garantia contratual esperada pelo consumidor sobre a
// ordem dos eventos publicados. Enforcement é responsabilidade do
// runtime (broker + producer), não deste contrato. A declaração
// permite que consumidores projetem lógica de reordering/dedup
// com base no que o contrato garante.
//
// scope "global" excluído deliberadamente no Wave 0 — promessa
// forte demais sem infraestrutura que a sustente. Abertura por
// ADR quando houver implementação real que garanta ordering global.
#OrderingDeclaration: {
	scope:     "within-aggregate" | "within-partition"
	guarantor: "producer" | "broker"

	// Campo usado como chave de sequência/partição.
	// Radar: quando guarantor == "broker" com scope "within-partition",
	// o campo canônico pode estar implícito no envelope do broker
	// (e.g., partition key do Kafka). Caso futuro em que declaração
	// local seria redundante com infraestrutura. Não mudar agora —
	// reavaliar quando houver instância real com broker guarantee.
	sequenceField: string & !=""

	rationale: string & !=""
}

// ── Autenticação ──
//
// Enum de schemes fechada para Wave 0. Extensão por ADR quando
// novos schemes forem necessários. Restrição intencional: qualquer
// string como scheme válido enfraquece o valor do tipo e permite
// proliferação silenciosa de policies não governadas.
#AuthPolicy: {
	scheme: #AuthScheme

	// Scopes são deliberadamente string livre — scopes OAuth/JWT
	// variam por BC e por deployment. Enum aqui seria prematura.
	// Flexibilidade é decisão consciente, não omissão.
	//
	// Área de futura governança: proliferação silenciosa de scopes
	// é risco real em sistema multi-BC. Quando n >= 3 BCs com
	// service contracts, avaliar se scopes devem migrar para
	// catálogo centralizado ou convenção de naming. Não tratar
	// esta flexibilidade como estado final neutro.
	scopes?: [...string & !=""]

	rationale: string & !=""
}

#AuthScheme: "bearer-jwt"

// ==============================
// REFS (cross-artifact)
// ==============================

// #CommandRef, #EventRef, #BoundedContextRef e #SourceContextRef
// são definidos em domain-model.cue (mesmo package artifact_schemas).
// CUE unifica automaticamente — não redefinir aqui.

// Ref para query capability do domain model.
//
// Follow-up ontológico: este ref é local a service-contract.cue
// porque query capabilities são nested em projections no domain
// model (projections[].queryCapabilities[].code) e não têm ref
// type top-level em domain-model.cue. Isso sugere lacuna na
// ontologia do domain model: query capability talvez devesse
// ganhar ref formal (#QueryCapabilityRef) em domain-model.cue.
// Até lá, esta definição local é workaround consciente — não
// deve virar exceção permanente silenciosa.
#QueryCapabilityRef: string & =~"^qry-[a-z][a-z0-9-]*$"
