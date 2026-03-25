package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

eventDrivenArchitecturePatterns: artifact_schemas.#AnalyticalLens & {
id:     "lens-event-driven-architecture-patterns"
name:   "Patterns de Arquitetura Event-Driven"

purpose: "Orientar decisões sobre como usar eventos como primitiva arquitetural — event sourcing, CQRS, async messaging, ordering e idempotência."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve usar eventos como mecanismo primário de comunicação entre componentes ou bounded contexts",
		"a decisão envolve event sourcing — armazenar estado como sequência de eventos em vez de snapshot mutável",
		"a decisão envolve CQRS — separar modelo de escrita (commands) do modelo de leitura (queries)",
		"a decisão envolve projetar event catalog — quais eventos existem, quem produz, quem consome, que schema",
		"a decisão envolve escolher entre choreography (reação descentralizada) e orchestration (coordenação central) de eventos",
		"a decisão envolve como projetar schemas de eventos para evolução sem breaking change",
		"a decisão envolve como construir projeções (read models) a partir de event log para queries específicas",
		"a decisão envolve como lidar com ordering, deduplicação e delivery guarantees de eventos",
		"a decisão envolve como reconstruir estado do sistema a partir do event log (replay, temporal queries)",
		"a decisão envolve escolher entre event broker (Kafka, Pulsar, NATS) e patterns de delivery",
		"a decisão envolve como eventos internos se relacionam com eventos externos (webhooks para integradores)",
		"a decisão envolve como garantir auditabilidade e compliance usando event log como source of truth",
	]
	keywords: [
		"evento", "event", "event-driven", "EDA",
		"event sourcing", "event store", "event log", "append-only",
		"CQRS", "command", "query", "read model", "projeção", "projection",
		"domain event", "integration event", "event catalog",
		"choreography", "orchestration", "saga", "process manager",
		"Kafka", "Pulsar", "NATS", "event broker", "message broker",
		"schema evolution", "Avro", "Protobuf", "schema registry",
		"replay", "rebuild", "temporal query", "time travel",
		"publish", "subscribe", "consumer group", "partition",
		"exactly-once", "at-least-once", "delivery guarantee",
		"eventual consistency", "projeção eventual", "read-after-write",
		"dead letter", "poison pill", "error channel",
	]
	excludeWhen: [
		"a decisão é sobre consistency models, sagas e coordenação distribuída em geral — usar distributed-systems-design",
		"a decisão é sobre design de API pública para integradores — usar api-design-as-product",
		"a decisão é sobre observabilidade e monitoramento de pipelines — usar observability-operational-intelligence",
		"a decisão é sobre modelagem de dados para analytics — usar data-modeling-for-analytical-power",
		"a decisão é sobre segurança e criptografia de eventos — usar security-trust-infrastructure",
	]
	rationale: "Toda plataforma que opera com múltiplos bounded contexts, integrações externas e necessidade de auditabilidade se beneficia de arquitetura event-driven. Na Mesh como intermediário financeiro, eventos são naturais: cada operação de antecipação é sequência de transições de estado (solicitada → validada → scored → aprovada → liquidada → registrada) que produzem eventos que múltiplos consumers precisam processar. Event sourcing é especialmente relevante para intermediário financeiro: o regulador exige reconstituição de toda operação — event log como source of truth satisfaz esse requisito por design, não por adição posterior. CQRS é relevante porque queries de fornecedor (status das minhas operações), de construtora (dashboard de cadeia), e de gestor FIDC (relatório de carteira) têm necessidades radicalmente diferentes — um único modelo de leitura não serve todos. DSD cobre distributed systems em geral; esta lens cobre os patterns específicos de event-driven que são core da arquitetura Mesh."
}

concepts: [
	{
		id:         "eda-event-sourcing"
		name:       "Event Sourcing: Estado como Sequência de Fatos Imutáveis"
		nature:     "theoretical"
		role:       "framework"
		definition: "Fowler (2005, 'Event Sourcing'): em vez de armazenar o estado atual de uma entidade como snapshot mutável, armazenar a sequência completa de eventos que levaram ao estado atual. Estado é derivado fazendo replay dos eventos. Eventos são imutáveis — nunca editados, apenas novos eventos são adicionados. Young (2010, CQRS Documents): event sourcing garante audit trail completo por design (todo evento é fato imutável com timestamp), permite temporal queries (reconstruir estado em qualquer ponto no tempo), e habilita novos consumers sem alterar producers. Overbeek (2023, Practical Event-Driven Microservices): event sourcing não é obrigatório para EDA — pode ter EDA sem event sourcing (eventos como notificação, não como source of truth) e event sourcing sem EDA ampla. Conceito contemporâneo de 'event store as system of record' (EventStoreDB 2020+, Marten 2022+, Axon 2023+): databases projetados especificamente para event sourcing — append-only, projeções built-in, subscriptions nativas. PostgreSQL como event store (Marten): aproveita infra existente com event sourcing capabilities adicionadas como library. Conceito de 'event sourcing for regulated industries' (Boner 2023, Reactive Architecture): em setores regulados, event sourcing satisfaz requisitos de auditabilidade por design — o event log é o audit trail, não uma derivação."
		meshManifestation: "Na Mesh como intermediário financeiro, event sourcing é naturalmente alinhado: (1) operação de antecipação — AnticipationRequested, DocumentsValidated, BuyerScored, AnticipationApproved, SettlementInitiated, SettlementConfirmed, OperationRegistered. Cada evento é fato imutável. Estado atual (operation.status = 'settled') é derivado do replay. Se regulador pergunta 'reconstituir esta operação': replay dos eventos fornece timeline completa com timestamps, actors, e dados de cada transição. (2) scoring — ScoreCalculated com inputs, features, model_version, output. Imutável. Se scoring é questionado depois: evento preserva exatamente que dados e modelo foram usados. (3) fornecedor lifecycle — SupplierOnboarded, DocumentsSubmitted, ComplianceValidated, SupplierQualified, SupplierSuspended. Timeline completa de qualificação. (4) FIDC — cada evento com impacto no lastro é registrado: antecipação afeta carteira, liquidação afeta fluxo, default afeta inadimplência. Event log é a source of truth para relatórios de carteira."
		meshImplication: "Implementar event sourcing para bounded contexts com requisito de auditabilidade: (1) ECL (Economic Commitment Lifecycle) — core. Toda transição de estado de operação como evento imutável. Event store: Marten sobre PostgreSQL (infra existente, event sourcing capabilities, projeções .NET/JVM). (2) Scoring — ScoreCalculated como evento com snapshot de inputs e modelo. Permite reproduzir qualquer score passado. (3) Network Growth — SupplierQualified, SupplierDisqualified como eventos para reconstituir timeline de qualificação. Para cada event-sourced aggregate: (a) definir eventos no event catalog (eda-event-catalog). (b) projeção para read model de cada consumidor (eda-projections). (c) snapshot strategy: se aggregate tem >1000 eventos, manter snapshot periódico para evitar replay lento (snapshot a cada 100 eventos). (d) eventos são append-only — correção é novo evento (AnticipationCorrected), não edição do evento anterior. (e) retenção: eventos financeiros retidos por 5+ anos (regulação). Eventos operacionais: 1+ ano. Anti-pattern: event sourcing para todo bounded context — BCs sem requisito de auditabilidade ou temporal queries podem usar CRUD normal. Event sourcing adiciona complexidade; usar quando o benefício (auditabilidade, temporal queries, multi-consumer) justifica."
		rationale: "Fowler 2005: event sourcing como pattern. Young 2010: audit trail por design. Marten 2022+: PostgreSQL como event store. Boner 2023: event sourcing para regulated industries. Na Mesh como intermediário financeiro com requisito regulatório de reconstituição, event sourcing não é pattern opcional — é a arquitetura que satisfaz compliance por design."
	},
	{
		id:         "eda-cqrs"
		name:       "CQRS: Separar o Modelo que Escreve do Modelo que Lê"
		nature:     "theoretical"
		role:       "framework"
		definition: "Young (2010, 'CQRS Documents'): Command Query Responsibility Segregation — modelo de escrita (commands que mudam estado) é separado do modelo de leitura (queries que consultam estado). Cada lado pode ter schema, storage, e scaling independentes. Motivação: o modelo ótimo para escrita (normalizado, consistente, validado por domain rules) é frequentemente subótimo para leitura (desnormalizado, otimizado para query patterns específicos). CQRS permite otimizar cada lado independentemente. Meyer (1988, CQS): Command-Query Separation — todo método é command (muda estado, não retorna dado) ou query (retorna dado, não muda estado). CQRS é CQS elevado a arquitetura. Conceito contemporâneo de 'CQRS with event sourcing' (Overbeek 2023): combinação natural — eventos são escritos no event store (command side), projeções são construídas a partir dos eventos para read models otimizados (query side). Projeções são eventual consistent com o event store. Conceito de 'polyglot read models' (Khononov 2024): cada projeção pode usar storage diferente — relacional para queries estruturadas, search engine para full-text, time-series para analytics, graph database para relações."
		meshManifestation: "Na Mesh, diferentes consumidores precisam de read models radicalmente diferentes: (1) fornecedor — 'minhas operações com status e valor.' Read model: tabela desnormalizada por fornecedor, otimizada para listagem com filtro por status. (2) construtora — 'dashboard da minha cadeia: fornecedores qualificados, operações pendentes, compliance status, gastos por categoria.' Read model: view pré-calculada agregando dados de múltiplos BCs. (3) gestor FIDC — 'carteira: lastro total, inadimplência, concentração por comprador, performance de safra.' Read model: time-series com agregações por período e dimensão. (4) agente de scoring — 'features do comprador para scoring.' Read model: feature store com dados desnormalizados otimizados para inferência. Cada read model é projeção diferente dos mesmos eventos. Sem CQRS: uma única tabela tenta servir 4 consumidores com necessidades conflitantes — ou é lenta para o FIDC (sem pré-agregação) ou é complexa para o fornecedor (campos demais)."
		meshImplication: "Implementar CQRS onde consumidores têm necessidades divergentes: (1) command side — event-sourced aggregates (ECL, NGR, Scoring). Writes são eventos no event store. Domain validation acontece antes de persistir evento. (2) query side — projeções para cada consumidor: (a) supplier_operations_view: desnormalizada, por fornecedor, indexada por status. Alimentada por eventos de ECL. (b) builder_dashboard_view: agregação cross-BC, atualizada por eventos de ECL + NGR + Compliance. (c) fidc_portfolio_view: time-series, alimentada por eventos financeiros. (d) scoring_feature_store: features pré-calculadas para inferência rápida. (3) projeção como código — cada projeção é subscriber de eventos com lógica de atualização do read model. Projeção é rebuild-able: se corrompida ou se schema muda, rebuild do zero a partir do event log (conecta com eda-replay). (4) eventual consistency — read models são eventualmente consistentes com event store. Latência de projeção: <5s para fornecedor (percebe delay), <1min para dashboard (refresh periódico), <5min para FIDC (batch). (5) read-after-write: se fornecedor submete operação e imediatamente consulta, pode não ver — implementar causal consistency para write-then-read do mesmo client (return projeção do write direto, não do read model). Anti-pattern: CQRS para sistema simples com 1 tipo de consumidor — overhead de manter projeções sem benefício. CQRS quando consumidores têm necessidades divergentes; CRUD quando não têm."
		dependsOn: ["eda-event-sourcing"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-cap-pacelc"
			context:   "DSD define trade-off entre consistency e latency (PACELC). CQRS operacionaliza: command side é strongly consistent (write validado por domain rules); query side é eventualmente consistent (projeção eventual). O trade-off é explícito e por design: writes são corretos; reads podem ser stale. DSD provê o framework teórico; CQRS implementa a separação."
		}]
		rationale: "Young 2010: CQRS como pattern. Khononov 2024: polyglot read models. Overbeek 2023: CQRS + event sourcing. Na Mesh com 4 tipos de consumidores (fornecedor, construtora, FIDC, scoring) com necessidades radicalmente diferentes, CQRS é o que permite otimizar cada experiência sem comprometer as demais."
	},
	{
		id:            "eda-event-catalog"
		name:          "Event Catalog: Inventário Canônico de Eventos do Sistema"
		nature:        "operational"
		role:          "framework"
		reviewCadence: "quarterly"
		definition:    "Conceito de domain event (Evans 2003, DDD): 'algo que aconteceu no domínio que domain experts se importam.' Cada domain event é fato imutável com significado de negócio. Hohpe/Woolf (2003, Enterprise Integration Patterns): distinção entre event notification (aviso leve que algo aconteceu), event-carried state transfer (evento carrega dados completos para que consumidor não precise buscar), e event sourcing event (evento é a source of truth). Conceito contemporâneo de 'event catalog as product' (EventCatalog.dev 2022+, AsyncAPI 2023+): catálogo de eventos versionado, documentado e navigável — equivalente a OpenAPI para eventos. Cada evento tem: schema, producer, consumers, examples, ownership. AsyncAPI Specification (2019+, v3 2023): standard para descrever APIs assíncronas — channels, messages, schemas, bindings. Analogia: OpenAPI é para REST o que AsyncAPI é para eventos. Conceito de 'event design thinking' (Brandolini 2021, Event Storming evolution): usar event storming não apenas como tool de discovery mas como input direto para o event catalog — cada sticky note é candidato a evento no catálogo."
		meshManifestation: "Na Mesh, eventos candidatos (ECL como exemplo): (1) AnticipationRequested — fornecedor solicitou antecipação. Payload: operation_id, supplier_id, buyer_id, invoice_ref, value, requested_at. (2) DocumentsValidated — documentos da operação foram validados. Payload: operation_id, documents_validated: [{doc_id, type, status}], validated_by (agent/human), validated_at. (3) BuyerScored — comprador recebeu score. Payload: operation_id, buyer_id, score, model_version, features_snapshot, scored_at. (4) AnticipationDecided — decisão tomada. Payload: operation_id, decision (approved/rejected), decided_by, reason, decided_at. (5) SettlementInitiated — liquidação iniciada. Payload: operation_id, settlement_id, amount, bank_ref, initiated_at. (6) SettlementConfirmed — banco confirmou liquidação. Payload: operation_id, settlement_id, confirmed_at, bank_confirmation_ref. (7) OperationRegistered — registrada na registradora. Payload: operation_id, registration_ref, registered_at. Cada evento tem producer (qual BC), consumers (quais projeções e BCs downstream), e schema versionado."
		meshImplication: "Manter event catalog como artefato canônico no mesh-spec: (1) para cada evento: id (formato: bc.EventName — ecl.AnticipationRequested), schema (CUE ou Avro/Protobuf para serialização), producer (BC owner), consumers (lista de BCs e projeções que subscrevem), version, changelog. (2) AsyncAPI spec como formato do catálogo — machine-readable, gerável para documentação e code stubs. (3) classificação de eventos: (a) domain events — fatos de negócio que domain experts se importam (AnticipationApproved). (b) integration events — eventos publicados para consumo cross-BC (subconjunto de domain events, possivelmente com schema simplificado). (c) technical events — eventos de infraestrutura (AgentTaskCompleted, CircuitBreakerOpened) — não fazem parte do domain mas são relevantes para observabilidade. (4) ownership: cada evento tem BC owner que é responsável pelo schema. Mudança de schema requer review (PR no mesh-spec). Breaking change de evento: tratada como breaking change de API (sunset protocol de api-versioning-evolution). (5) event naming convention: past tense (algo que aconteceu) — AnticipationApproved, não ApproveAnticipation. Substantivo + verbo passado. Sem ambiguidade. (6) payload design: event-carried state transfer como default — evento carrega dados suficientes para consumidor processar sem buscar. Reduz coupling (consumidor não precisa chamar API do producer). Anti-pattern: evento com payload vazio ('AnticipationApproved' sem operation_id nem valor) que obriga consumidor a query o producer — acoplamento temporal."
		dependsOn: ["eda-event-sourcing"]
		crossDependsOn: [{
			lensId:    "lens-knowledge-management"
			conceptId: "km-knowledge-as-code"
			context:   "KM define knowledge as code — versionado, testável, auditável. Event catalog é knowledge as code para a dimensão de eventos. AsyncAPI schema é o 'CUE schema' dos eventos — machine-readable, validável, e source of truth. Event catalog no mesh-spec é consultável por agentes para entender quais eventos existem, quem produz, quem consome. KM diz 'se não está codificado, não existe'; EDA diz 'evento sem entry no catálogo não existe oficialmente'."
		}]
		rationale: "Evans 2003: domain events. Hohpe/Woolf 2003: event patterns. EventCatalog.dev 2022+: catalog as product. AsyncAPI v3 2023: standard para async APIs. Brandolini 2021: event storming como input. Na Mesh, o event catalog é o mapa canônico do que acontece no sistema — sem ele, novos agentes e novos BCs não sabem quais eventos existem, quem produz, e como consumir."
	},
	{
		id:         "eda-schema-evolution"
		name:       "Evolução de Schema de Eventos: Mudar o Formato Sem Quebrar Consumidores"
		nature:     "theoretical"
		role:       "property"
		definition: "Kleppmann (2017): schemas de mensagens evoluem — campos são adicionados, removidos, renomeados. Três tipos de compatibilidade: (1) backward compatible — consumidor novo lê evento antigo (consumidor tolerante). (2) forward compatible — consumidor antigo lê evento novo (producer pode evoluir livremente). (3) full compatible — ambos. Avro, Protobuf e Thrift suportam evolution com regras: campos novos devem ter default, campos removidos devem ser deprecated (não removidos do schema). Confluent Schema Registry (2019+): registry centralizado que valida compatibilidade de schema a cada publicação — se novo schema viola backward compatibility: publicação rejeitada. Conceito contemporâneo de 'schema registry for event sourcing' (EventStoreDB, Marten): em event sourcing, schemas evoluem ao longo de anos (eventos de 2024 coexistem com eventos de 2028 no mesmo log). Upcasting: transformar evento em formato antigo para formato novo durante replay. Downcasting: inverso (raramente necessário). Buf (2022+): plataforma de schema management que vai além de Protobuf — linting, breaking change detection, e code generation para múltiplas linguagens. Conceito de 'schema as contract' — evolução de schema é evolução de contrato com todos os consumidores."
		meshManifestation: "Na Mesh com event sourcing, schema evolution é inevitável: (1) AnticipationRequested v1 não tem campo 'modalidade_cessao'. Regulação exige. V2 adiciona campo com default. Eventos v1 no log precisam ser legíveis pelo consumidor que espera v2 (upcasting: adicionar default durante replay). (2) BuyerScored v1 tem features como lista flat. V2 reestrutura como nested object (features.financial, features.operational). Breaking change se consumidor espera flat. (3) evento novo: SettlementReversed não existia — comprador deu default e liquidação é revertida. Adicionar ao catálogo sem afetar consumidores que não processam este tipo. (4) ao longo de 5 anos (retenção regulatória): event log acumula eventos em v1, v2, v3. Replay precisa deserializar todos."
		meshImplication: "Estratégia de schema evolution: (1) serialização com suporte nativo a evolution — Avro (schema evolution + compact binary) ou Protobuf (schema evolution + tooling). Amazon Ion (escolha atual da Mesh): verificar capacidade de schema evolution — Ion é self-describing mas não tem schema registry nativo. Se insuficiente: usar Avro/Protobuf para eventos, Ion para outros payloads. (2) schema registry — registrar schema de cada evento com version. Validar compatibilidade a cada publicação: backward compatibility como mínimo (consumidor novo lê evento antigo). Forward compatibility desejável (consumidor antigo lê evento novo — tolera campos desconhecidos). (3) regras de evolução: (a) adicionar campo com default → backward + forward compatible. Ok. (b) remover campo → breaking para consumidor que usa o campo. Deprecar primeiro (marcar como deprecated por 2 versões), depois remover. (c) mudar tipo de campo → breaking. Criar campo novo com tipo novo, deprecar antigo. (d) renomear campo → breaking. Criar campo novo com nome novo, deprecar antigo. (4) upcasting para replay — quando fazer replay de eventos antigos: transformer que converte evento v1 para v2 (adiciona defaults, reestrutura). Transformer é código no pipeline de replay, não modificação do evento original (imutável). (5) versionamento no evento — cada evento carrega schema_version. Consumer verifica version e aplica parser adequado. (6) CI validation — a cada PR que modifica schema de evento: CI verifica backward compatibility. Se viola: PR bloqueada com explicação do que quebrou e como evoluir de forma compatível."
		dependsOn: ["eda-event-catalog"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-consistency-at-boundary"
			context:   "DSD define schema registry e contract evolution na fronteira entre BCs. EDA aplica especificamente a eventos — schema de evento é contrato entre producer e consumers. DSD provê o princípio (evolução sem breaking change na boundary); EDA operacionaliza para schemas de eventos com upcasting, compatibility validation, e registry."
		}]
		rationale: "Kleppmann 2017: schema evolution rules. Confluent 2019+: schema registry. Buf 2022+: schema management platform. Na Mesh com event sourcing e retenção de 5+ anos, eventos de 2025 coexistem com eventos de 2030 — schema evolution disciplinada é o que permite replay e reconstituição ao longo do tempo."
	},
	{
		id:         "eda-choreography-vs-orchestration"
		name:       "Choreography vs Orchestration: Quem Coordena o Fluxo?"
		nature:     "theoretical"
		role:       "method"
		definition: "Hohpe/Woolf (2003): dois styles de coordenação em EDA: (1) choreography — cada serviço reage a eventos sem coordenador central. Producer publica evento; consumers que se interessam reagem. Nenhum componente sabe o fluxo completo. Pros: desacoplamento máximo, cada serviço é autônomo. Cons: fluxo 'invisível' (distribuído entre consumers), difícil rastrear, compensação complexa. (2) orchestration — coordenador central (orchestrator/process manager) define e executa o fluxo. Envia commands para serviços e reage a eventos de conclusão. Pros: fluxo visível num lugar, compensação centralizada, fácil rastrear. Cons: coordenador é ponto de coupling e potencial bottleneck. Richardson (2018): sagas podem ser choreographed ou orchestrated — cada style tem trade-offs. Conceito contemporâneo de 'durable execution' (Temporal 2020+, Restate 2024+): workflow engines que combinam o melhor — fluxo definido como código (visibilidade de orchestration), executado de forma durável (retry, compensation, state persistence), com serviços autônomos (independência de choreography). Temporal workflow é código que 'parece' orchestration mas cada activity é serviço independente. Restate (2024+): durable execution sem server — state machine como função, estado persistido automaticamente."
		meshManifestation: "Na Mesh, ambos os styles coexistem: (1) fluxo de antecipação — orchestration. 7 steps em sequência com compensações complexas (conecta com dsd-saga-coordination). Coordenador (Temporal workflow) define sequência, gerencia timeouts, e executa compensação. Visibilidade: status de cada operação é o estado do workflow. (2) propagação de qualificação — choreography. Quando fornecedor é qualificado (SupplierQualified): múltiplos consumers reagem independentemente — projeção de dashboard da construtora atualiza, feature store de scoring atualiza, notificação é enviada, catálogo de fornecedores atualiza. Nenhum coordenador — cada consumer reage ao evento. (3) analytics e reporting — choreography. Eventos de operação são consumidos independentemente por projeção de FIDC, projeção de métricas, e pipeline de anomaly detection. Cada consumer é autônomo. Regra: orchestration para fluxos que requerem coordenação e compensação (operações financeiras). Choreography para propagação de estado e analytics (side effects independentes)."
		meshImplication: "Critérios de escolha: (1) orchestration quando: fluxo tem sequência definida com dependências entre steps, compensação é necessária se step falha, visibilidade end-to-end é crítica (operações financeiras, regulatório), e existe single owner do fluxo. Tool: Temporal/Restate para durable execution. (2) choreography quando: consumers são independentes (failure de um não afeta outros), não há compensação cross-consumer, e novos consumers podem ser adicionados sem modificar producers. Tool: event broker (Kafka/NATS) com consumers independentes. (3) híbrido é o padrão real: fluxo core é orchestrated (antecipação), side effects são choreographed (notificações, projeções, analytics). O workflow de antecipação é orquestrado e publica eventos que consumers choreographed processam. (4) anti-pattern: choreography para fluxo financeiro com compensação — a história completa do fluxo está distribuída entre 7 consumers, nenhum sabe o estado global, compensação requer coordenar 7 serviços que não se conhecem. (5) anti-pattern: orchestration para side effects simples — coordenador para enviar notificação + atualizar dashboard é overhead sem benefício."
		dependsOn: ["eda-event-sourcing", "eda-event-catalog"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-saga-coordination"
			context:   "DSD define sagas com choreography vs orchestration para transações distribuídas. EDA operacionaliza: qual style para cada fluxo da Mesh e como eventos são o mecanismo de comunicação em ambos. DSD é o pattern de coordenação; EDA é o mecanismo (eventos) e os critérios de escolha no contexto Mesh."
		}]
		rationale: "Hohpe/Woolf 2003: choreography vs orchestration. Richardson 2018: sagas com ambos. Temporal 2020+: durable execution. Restate 2024+: durable execution sem server. Na Mesh, a coexistência de orchestration (fluxo financeiro) e choreography (side effects) é o pattern natural — não é um ou outro, é cada um para seu contexto."
	},
	{
		id:         "eda-projections"
		name:       "Projeções: Construir Read Models Otimizados a Partir de Eventos"
		nature:     "theoretical"
		role:       "method"
		definition: "Young (2010): projeção é a transformação de uma sequência de eventos em um read model otimizado para um pattern de query específico. Cada projeção é consumer de eventos que materializa view customizada. Projeções são rebuild-able: se corrompida ou se schema muda, reconstruir do zero a partir do event log. Conceito de 'projection as materialized view' — projeção é o equivalente de materialized view em database, mas alimentada por event stream em vez de query. Conceito contemporâneo de 'living projections' (Marten 2022+, Eventuous 2023+): projeções que são automaticamente mantidas pelo framework — developer define a transformação, framework gerencia subscription, checkpoint, e error handling. Conceito de 'multi-model projections' (Khononov 2024): mesma stream de eventos projeta para múltiplos storage types — relacional, search, time-series, graph — cada um otimizado para seu query pattern."
		meshManifestation: "Na Mesh, projeções necessárias: (1) supplier_operations_view — tabela PostgreSQL desnormalizada. Eventos consumidos: AnticipationRequested, AnticipationDecided, SettlementConfirmed, OperationRegistered. Atualiza: status, decided_at, settled_at. Query: GET /operations?supplier_id=X&status=approved. Latência de projeção target: <5s. (2) builder_dashboard_view — view agregada cross-BC. Eventos consumidos: de ECL (operações), NGR (fornecedores), Compliance (status). Atualiza: counters, status aggregations. Query: dashboard da construtora com fornecedores qualificados, operações pendentes, compliance alerts. Latência target: <1min. (3) fidc_portfolio_view — time-series. Eventos consumidos: SettlementConfirmed, DefaultRegistered, PaymentReceived. Atualiza: carteira total, inadimplência acumulada, concentração por comprador, performance de safra. Query: relatórios de FIDC com filtros por período e dimensão. Latência target: <5min. (4) scoring_feature_store — key-value ou columnar. Eventos consumidos: de múltiplos BCs que produzem features (faturamento, pagamentos, operações históricas). Atualiza: features pré-calculadas por comprador. Query: scoring pipeline busca features por buyer_id. Latência target: <1s."
		meshImplication: "Para cada projeção: (1) definir: eventos consumidos (subscription), transformação (como evento vira update no read model), storage (PostgreSQL, ElasticSearch, time-series DB), latência target, rebuild strategy. (2) checkpoint — projeção mantém posição (offset/sequence number) do último evento processado. Se projeção crashar: retoma do checkpoint, não do início. (3) rebuild — toda projeção deve ser rebuild-able do zero: drop read model, replay todos os eventos, reconstruir. Testar rebuild periodicamente (trimestral). Se rebuild leva >1h para projeção crítica: otimizar (parallel replay, batching). (4) error handling — se projeção encontra evento que não sabe processar: (a) evento desconhecido (novo tipo): skip com warning — projeção pode ignorar eventos que não conhece (forward compatibility). (b) evento com dados inválidos: dead letter com log — não travar projeção inteira por 1 evento problemático. (c) projeção out of order: se ordering importa (financial totals), rejeitar e retry. Se não (dashboard counters): processar e aceitar eventual reordering. (5) idempotência — projeção deve ser idempotente: processar mesmo evento 2x produz mesmo estado. Essencial para replay e retry. (6) monitoring — para cada projeção: lag (distância entre último evento produzido e último processado), throughput (eventos/s), error rate, rebuild time. Se lag cresce continuamente: consumer está lento — otimizar ou escalar."
		dependsOn: ["eda-event-sourcing", "eda-cqrs", "eda-event-catalog"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-sli-slo-error-budget"
			context:   "OOI define SLIs/SLOs para serviços. Projeções precisam de SLOs: latência de projeção é SLI (quanto tempo entre evento produzido e read model atualizado). SLO por projeção: supplier_operations <5s, builder_dashboard <1min, fidc_portfolio <5min. Error budget: se projeção viola SLO em >5% das vezes, investir em otimização. OOI monitora; EDA define os targets."
		}]
		rationale: "Young 2010: projeções como read models. Marten 2022+: living projections. Khononov 2024: multi-model projections. Na Mesh com 4 consumidores com necessidades diferentes, projeções são o mecanismo que torna CQRS prático — cada consumidor tem seu read model otimizado, todos alimentados pelo mesmo event log."
	},
	{
		id:         "eda-replay-temporal-queries"
		name:       "Replay e Temporal Queries: Viajar no Tempo do Sistema"
		nature:     "theoretical"
		role:       "property"
		definition: "Young (2010): em event sourcing, estado em qualquer ponto no tempo é derivável fazendo replay dos eventos até aquele momento. Temporal query: 'qual era o estado da operação X em 15 de março de 2026 às 14:30?' — replay eventos até esse timestamp. Fowler (2005): replay habilita 'what-if' analysis — 'se scoring model v2 tivesse existido em janeiro, quais operações teriam sido aprovadas diferentemente?' — replay com model v2 em vez de v1. Conceito contemporâneo de 'event replay for compliance and audit' (Boner 2023): reguladores perguntam 'reconstrua a decisão X com todos os dados e context que existiam no momento.' Event sourcing satisfaz por design — replay até o momento da decisão produz exatamente o estado que existia. Conceito de 'retroactive events' (Fowler 2005): eventos que corrigem o passado sem alterar — PaymentDateCorrected com old_date e new_date. O fato original (PaymentReceived com date X) permanece; a correção é novo fato. Conceito de 'event sourcing for model backtesting' (2023+): em financial systems, replay de eventos com modelo novo permite backtesting — 'se tivéssemos usado modelo v3, qual seria a inadimplência da carteira?' Replay com model v3, comparar resultados com v2."
		meshManifestation: "Na Mesh, replay e temporal queries são usados em: (1) auditoria regulatória — Bacen pergunta: 'reconstrua a operação 12345 com todos os dados no momento da aprovação.' Replay de eventos até AnticipationDecided: reconstituir score, features, documents que existiam naquele momento. (2) backtesting de scoring — 'modelo v3 é melhor que v2? Replay 6 meses de BuyerScored events com model v3, comparar AUROC.' Permite validar modelo novo contra histórico real antes de deploy. (3) correção — antecipação registrada com valor errado (erro de digitação). Não editar evento original. Publicar OperationCorrected com old_value e new_value. Projeções processam correção e atualizam read model. Audit trail preserva ambos: o fato original e a correção. (4) what-if analysis — 'se tivéssemos exigido score >70 em vez de >60 nos últimos 3 meses, quantas operações teriam sido rejeitadas? Qual o impacto em receita? Qual o impacto em inadimplência?' Replay com threshold diferente."
		meshImplication: "Implementar replay como capability do sistema: (1) event store com replay eficiente — read sequencial rápido (Marten sobre PostgreSQL suporta nativamente). Para replay de todo o log: batch processing, parallel por aggregate. (2) temporal queries — para auditoria: replay por aggregate_id até timestamp X. Output: snapshot do estado da entidade naquele momento + lista de eventos processados. (3) backtesting pipeline — replay de eventos de scoring com modelo alternativo. Input: events stream + model version. Output: scores recalculados + métricas comparativas (AUROC, falsos positivos, falsos negativos). Ferramenta core para evolução de scoring. (4) retroactive events — convenção: OperationCorrected, PaymentDateCorrected, SupplierInfoCorrected. Cada correção referencia o evento original (original_event_id) e carrega old_value + new_value. Projeções processam correções como qualquer outro evento. (5) snapshot optimization — para aggregates com muitos eventos (>1000): manter snapshot periódico. Replay: carregar último snapshot + replay eventos posteriores. Reduz tempo de replay de O(n) para O(1 + delta). (6) testar replay: trimestralmente, selecionar 5 operações aleatórias e reconstruir estado via replay. Comparar com estado atual no read model. Se diverge: bug na projeção ou evento missing."
		dependsOn: ["eda-event-sourcing", "eda-schema-evolution"]
		crossDependsOn: [
			{
				lensId:    "lens-credit-risk"
				conceptId: "cr-model-monitoring"
				context:   "CR monitora performance de modelos de scoring. EDA replay habilita backtesting — replay de eventos com modelo novo para comparar com modelo atual antes de deploy. CR diz 'AUROC caiu, modelo precisa de atualização'; EDA diz 'replay 6 meses de eventos com modelo candidato para validar antes de substituir'. Replay é o mecanismo que torna model evolution segura."
			},
			{
				lensId:    "lens-ai-agent-governance"
				conceptId: "aag-audit-trail"
				context:   "AAG define audit trail para decisões de agentes. Event sourcing com replay é a implementação que satisfaz audit trail por design — reconstituir qualquer decisão fazendo replay até o momento. AAG define o requisito (reconstituir decisão X); EDA provê o mecanismo (replay de eventos até decisão X com estado completo)."
			},
		]
		rationale: "Young 2010: replay como capability. Fowler 2005: temporal queries e retroactive events. Boner 2023: replay para compliance. Na Mesh como intermediário financeiro regulado, a capacidade de reconstruir qualquer operação em qualquer momento é requisito regulatório — event sourcing com replay satisfaz por design, não por adição posterior."
	},
	{
		id:         "eda-event-broker-choice"
		name:       "Escolha de Event Broker: Trade-offs entre Kafka, NATS, Pulsar e Alternativas"
		nature:     "theoretical"
		role:       "method"
		definition: "Três categorias de broker com trade-offs: (1) log-based (Kafka, Redpanda, Amazon MSK): eventos persistidos em log ordenado, consumers lêem por offset, replay nativo, retention configurável. Pros: ordering forte por partição, replay, throughput alto. Cons: complexidade operacional (ZooKeeper/KRaft, partições, rebalancing), latência higher que message brokers. (2) message brokers (RabbitMQ, ActiveMQ): filas com routing, exchange patterns, acknowledgment. Pros: simplicidade, routing flexível, low latency. Cons: sem replay nativo (mensagem consumida é removida), ordering limitado. (3) modern hybrids (NATS JetStream 2021+, Apache Pulsar): combinam log-based persistence com features de message broker. NATS JetStream: lightweight, operacionalmente simples, persistence e replay, consumer groups. Pulsar: multi-tenancy, tiered storage, geo-replication. Conceito contemporâneo de 'Kafka without Kafka' (Redpanda 2021+): Kafka-compatible API sem JVM, sem ZooKeeper, deployment mais simples. 'Right-size your broker' (2023+): para early-stage, PostgreSQL LISTEN/NOTIFY ou Transactional Outbox pode ser suficiente sem broker dedicado — complexidade de broker quando volume justificar."
		meshManifestation: "Na Mesh, requirements para broker: (1) ordering por aggregate — eventos de mesma operação devem ser ordenados (operação aprovada antes de liquidada). Partition by operation_id ou buyer_id. (2) persistence e replay — event sourcing requer replay. Broker deve persistir eventos. (3) at-least-once delivery — consumidor pode receber duplicata, idempotência no consumer (dsd-idempotency). (4) consumer groups — múltiplos consumers independentes (projeções) processando mesma stream. (5) volume: pré-revenue <1000 eventos/dia. Escala: 100.000/dia. 1M/dia. (6) complexidade operacional — solo founder não pode operar cluster Kafka de 5 nós com ZooKeeper. Avaliação: (a) pré-revenue: Transactional Outbox + PostgreSQL (já existe) como 'poor man's event bus'. Events escritos em tabela outbox na mesma transação do aggregate. Poller lê outbox e publica para consumers. Sem broker adicional. (b) tração: NATS JetStream ou Redpanda — lightweight, operacionalmente simples, persistence + replay. (c) escala: Kafka managed (Amazon MSK, Confluent Cloud) — quando volume justifica managed service."
		meshImplication: "Estratégia por estágio: (1) pré-revenue: Transactional Outbox pattern com PostgreSQL. Evento é escrito na tabela 'outbox' na mesma transação que o aggregate update. Background worker (agente ou cron) lê outbox e despacha para consumers. Vantagem: zero infra adicional, ACID guarantee (evento é publicado se e somente se transação do aggregate commitou), simples de implementar. Limitação: polling-based (latência = polling interval), scaling limitado. Suficiente para <1000 eventos/dia. (2) tração (1.000-50.000 eventos/dia): migrar para NATS JetStream. Lightweight, binary único, sem ZooKeeper. JetStream persiste, ordena, e permite replay. Consumer groups para múltiplas projeções. Operational overhead: mínimo. (3) escala (>50.000 eventos/dia): avaliar Kafka managed (MSK, Confluent) ou Redpanda. Quando partitioning, multi-tenant isolation, e geo-replication justificarem complexidade. (4) independente do broker: Transactional Outbox como pattern de publicação — mesmo com Kafka, evento é escrito primeiro na outbox (ACID com aggregate), depois publicado para broker. Previne dual-write problem (aggregate commitou mas publicação falhou). (5) abstrair broker atrás de interface — code não depende de Kafka/NATS diretamente. Adapter pattern: trocar broker requer trocar adapter, não reescrever consumers. Anti-pattern: Kafka cluster de 5 nós para solo founder com 100 eventos/dia — complexidade sem benefício."
		dependsOn: ["eda-event-sourcing", "eda-event-catalog"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-throughput-constraint"
			context:   "ORA identifica que horas do founder são constraint. EDA broker choice minimiza overhead operacional dado o constraint — PostgreSQL outbox para pré-revenue (zero ops adicional), NATS para tração (ops mínimo), Kafka managed para escala (ops delegado). ORA diz 'constraint é founder time'; EDA diz 'broker choice deve minimizar ops overhead nesse estágio'."
		}]
		rationale: "Kafka para high-throughput, NATS para simplicidade, Redpanda para Kafka sem complexidade. Na Mesh solo founder, Transactional Outbox com PostgreSQL é satisficing: zero infra adicional, ACID guarantee, suficiente para bootstrap. A opção de migrar para broker dedicado quando volume justificar é preservada pela abstração (adapter pattern)."
	},
	{
		id:         "eda-domain-vs-integration-events"
		name:       "Domain Events vs Integration Events: O Que Fica Dentro e O Que Cruza Fronteiras"
		nature:     "theoretical"
		role:       "property"
		definition: "Evans (2003): domain events são fatos do domínio interno de um bounded context — expressam a linguagem ubíqua daquele contexto. Vernon (2013, Implementing DDD): quando domain event precisa cruzar fronteira de BC, deve ser traduzido para integration event — versão simplificada ou adaptada que faz sentido para o consumidor. Domain event é detalhe interno; integration event é contrato externo. Analogia com API: domain model ≠ API resource model (api-resource-modeling). Domain event ≠ integration event. Conceito contemporâneo de 'thin vs fat events' (Fowler 2017, 'What do you mean by event-driven?'): thin event (notification) carrega mínimo de dados (just_happened + id); fat event (event-carried state transfer) carrega dados completos. Trade-off: thin = mais desacoplado mas consumer precisa buscar dados. Fat = menos queries mas coupling de schema. Recomendação para cross-BC: fat events (consumer não precisa chamar producer) com schema mínimo suficiente (não propagar todo o domain model)."
		meshManifestation: "Na Mesh: (1) domain event (interno ao ECL): AnticipationStateChanged com todos os campos internos (ecl_commitment_id, previous_state_code, new_state_code, transition_metadata com 20+ campos). Faz sentido para lógica interna do ECL. (2) integration event (publicado para outros BCs): OperationApproved com campos relevantes para consumidores (operation_id, supplier_id, buyer_id, value, approved_at, settlement_deadline). Schema simplificado, estável, orientado ao consumidor. (3) integration event para API (publicado para integradores via webhook): operation.approved com campos do API resource model (id, status, value, timestamps). Schema diferente do integration event interno (pode ter naming e formato diferentes). Três níveis: domain event → integration event interno → integration event externo (webhook). Cada nível é ACL que protege o nível inferior de propagação de mudança."
		meshImplication: "Para cada BC que publica eventos: (1) domain events — internos, schema pode mudar livremente, consumers são apenas projeções do mesmo BC. (2) integration events — publicados para outros BCs via event catalog. Schema versionado e sujeito a compatibility rules (eda-schema-evolution). Transformação: mapper/translator entre domain event e integration event. Mudança de domain event não afeta integration event — apenas o mapper muda. (3) webhook events — publicados para integradores externos via API. Schema versionado por api-versioning-evolution. Transformação: mapper entre integration event e webhook event. (4) regra: BC nunca consome domain events de outro BC — apenas integration events. Se BC A precisa de dado de BC B: BC B publica integration event. BC A nunca lê domain events ou tabelas internas de BC B. Isso é enforcement da boundary. (5) fat vs thin: integration events são fat (event-carried state transfer) — consumer não precisa chamar producer. Domain events podem ser thin (apenas para trigger de projeção interna que já tem acesso ao aggregate). (6) anti-pattern: publicar domain event diretamente como integration event — coupling máximo. Mudança no domain model interno propaga para todos os BCs consumidores."
		dependsOn: ["eda-event-catalog", "eda-schema-evolution"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-resource-modeling"
			context:   "API separa resource model público do domain model interno. EDA separa integration events de domain events — mesma ACL, dimensão diferente. API é ACL para consumidores humanos/sistemas externos; integration events são ACL para outros BCs. O princípio é idêntico: proteger consumidor da complexidade interna do producer."
		}]
		rationale: "Evans 2003: domain events. Vernon 2013: integration events como tradução. Fowler 2017: thin vs fat events. Na Mesh, a separação em 3 níveis (domain → integration → webhook) é o que permite evoluir cada BC internamente sem propagar breaking changes para outros BCs ou para integradores."
	},
	{
		id:         "eda-error-handling-dead-letters"
		name:       "Error Handling em Event Consumers: Quando o Evento Não Pode Ser Processado"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Hohpe/Woolf (2003): Dead Letter Channel — mensagens que não podem ser processadas após múltiplas tentativas são movidas para fila separada para análise. 'Poison pill' — mensagem que causa falha no consumer repetidamente (parsing error, business rule violation, bug no consumer). Conceito contemporâneo de 'error channels with observability' (2023+): dead letter não é apenas dump — é fila observável com: razão da falha, contagem de retries, timestamp, metadata do evento original. Alert quando DLQ cresce. Dashboard para investigação. Conceito de 'consumer error classification' — three types: (1) transient (rede falhou, database slow) → retry com backoff. (2) permanent (schema inválido, business rule violation) → dead letter imediatamente. (3) poisoned (bug no consumer code) → circuit breaker + dead letter + alerta. Distinguir transient de permanent antes de retry é o que previne retry loop infinito em erro permanente."
		meshManifestation: "Na Mesh, cenários de erro em consumers: (1) transient — projeção de dashboard tenta escrever em PostgreSQL que está reiniciando. Retry em 5s, sucesso. (2) permanent — evento AnticipationRequested com CNPJ inválido (14 dígitos em vez de 14). Retry 100x não resolve — dado é inválido. Dead letter + alerta + investigação (como CNPJ inválido passou pela validação de command?). (3) poisoned — nova versão de projeção tem bug que causa NullPointerException para eventos com campo X nulo. Todo evento com campo X nulo falha. Consumer trava processando 1 evento em loop. (4) ordering-sensitive — projeção financeira recebe SettlementConfirmed antes de AnticipationApproved (out of order). Processar geraria saldo inconsistente. Deve rejeitar e aguardar."
		meshImplication: "Error handling em 4 camadas: (1) classificação — consumer classifica erro antes de decidir ação. Transient (network error, timeout, database unavailable): retry com exponential backoff (1s, 5s, 30s, 5min). Max retries: 5. Se todos falham: dead letter. Permanent (invalid data, business rule violation): dead letter imediatamente — retry é desperdício. Poisoned (consumer bug): circuit breaker — parar consumer, alerta imediato, dead letter para evento problemático. (2) dead letter queue — por consumer, não global. DLQ da projeção de FIDC é separada da DLQ de notificação. Cada DLQ tem: evento original, razão da falha, retry count, timestamps. (3) alerting — DLQ >0 para consumer de operação financeira: alerta imediato (projeção de carteira com evento não-processado afeta relatório). DLQ >10 para consumer de dashboard: alerta warning. DLQ >0 para consumer com classification 'poisoned': alerta critical + circuit breaker. (4) recovery — para eventos em DLQ: investigar causa raiz, corrigir (fix consumer bug, corrigir dado na source), e re-drive (mover de DLQ de volta para stream principal para reprocessamento). Re-drive é idempotente (consumer processa evento sem duplicar efeito). (5) ordering-sensitive consumers: se evento chega out of order: enfileirar localmente e aguardar evento predecessor (buffer window). Se predecessor não chega em X minutos: dead letter + investigação. Anti-pattern: retry infinito sem classificação — consumer tenta processar evento permanentemente inválido em loop, consumindo recursos sem progresso e bloqueando eventos posteriores."
		dependsOn: ["eda-projections", "eda-event-catalog"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-incident-management"
			context:   "OOI define incident management lifecycle (detect → triage → resolve → post-mortem). EDA error handling alimenta: DLQ growing é incident detectável. Poisoned consumer é SEV-2/3 dependendo do impacto. Post-mortem de consumer failure revela se causa é schema change não-handled, data quality issue, ou bug. OOI é o lifecycle; EDA é o mecanismo de error handling que gera os sinais."
		}]
		rationale: "Hohpe/Woolf 2003: dead letter channel. Classification de erros é o que diferencia retry inteligente de retry desesperado. Na Mesh, consumer de projeção financeira em retry loop infinito por dado inválido é desperdício de compute e delay de projeção — classificar e dead letter imediatamente é superior."
	},
	{
		id:         "eda-transactional-outbox"
		name:       "Transactional Outbox: Publicar Eventos com Garantia ACID"
		nature:     "theoretical"
		role:       "method"
		definition: "Richardson (2018): dual-write problem — quando aggregate é atualizado E evento deve ser publicado, duas operações em sistemas diferentes (database + broker) não podem ser atômicas. Se database commita e publicação falha: estado atualizado sem evento (consumers não sabem). Se publicação acontece e database rollback: evento publicado para estado que não existe. Transactional Outbox: escrever evento na tabela outbox na mesma transação que o aggregate update. Background process (poller ou CDC) lê outbox e publica para broker. Guarantee: evento existe se e somente se transação commitou (ACID). Conceito contemporâneo de 'change data capture (CDC) for outbox' (Debezium 2019+, Marten 2022+): em vez de poller, usar CDC do database (PostgreSQL logical replication, Debezium connector) para capturar inserts na outbox e publicar para broker — menor latência que polling, sem necessidade de poller custom. Conceito de 'listen/notify for outbox' (PostgreSQL LISTEN/NOTIFY): lightweight push notification quando row é inserida na outbox — consumer é notificado em milliseconds sem polling. Adequado para volume baixo/médio."
		meshManifestation: "Na Mesh, dual-write é risco em todo fluxo: (1) ECL persiste AnticipationApproved E precisa publicar evento para projeções + saga de liquidação. Se persistência commitou mas publicação falhou: operação está aprovada no database mas saga de liquidação nunca inicia — fornecedor espera indefinidamente. (2) Scoring calcula score E precisa publicar BuyerScored. Se publicação falha: projeção de scoring fica stale, decisão downstream não recebe score. (3) correção: OperationCorrected é persistida E publicada. Se publicação falha: projeção mostra valor errado enquanto aggregate está correto."
		meshImplication: "Implementar Transactional Outbox como pattern universal de publicação: (1) tabela outbox: id, aggregate_type, aggregate_id, event_type, event_data (JSON/Ion), created_at, published_at (null até publicar), status (pending/published/failed). (2) na transação do aggregate: INSERT INTO outbox (...) na mesma transação que UPDATE do aggregate. ACID garante: evento existe ↔ aggregate updated. (3) publicação: (a) pré-revenue: poller (cron ou background job) a cada 1-5s lê outbox WHERE status = 'pending', publica para consumers, marca published_at. Latência: 1-5s. Suficiente para <1000 eventos/dia. (b) tração: PostgreSQL LISTEN/NOTIFY — trigger na outbox notifica worker que publica imediatamente. Latência: <100ms. (c) escala: Debezium CDC captura inserts via logical replication e publica para Kafka. Latência: <1s, throughput alto. (4) idempotência: consumer deve ser idempotente porque poller pode republicar evento (crash após publicar mas antes de marcar published_at). Event id garante deduplicação. (5) cleanup: outbox events com published_at > 30 dias podem ser archivados — dados completos estão no event store, outbox é mecanismo de transporte. (6) monitoring: outbox queue depth (pending count). Se crescente: publicação está lenta ou falhando. Alerta se depth > 100 ou idade do evento mais antigo > 5min. Anti-pattern: publicar evento diretamente para broker na mesma request que atualiza aggregate (sem outbox) — dual-write. Se broker está down: aggregate atualizado, evento perdido. Se aggregate rollback: evento fantasma publicado."
		dependsOn: ["eda-event-sourcing", "eda-event-broker-choice"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-idempotency"
			context:   "DSD define idempotência para operações distribuídas. Transactional outbox requer idempotência no consumer porque republication é possível (poller reprocessa após crash). DSD provê o requisito (consumer idempotente); EDA outbox é um dos mecanismos que gera a necessidade (republication possível). São co-dependentes."
		}]
		rationale: "Richardson 2018: dual-write problem + outbox pattern. Debezium 2019+: CDC for outbox. PostgreSQL LISTEN/NOTIFY: lightweight push. Na Mesh como intermediário financeiro, o dual-write problem não é edge case — é modo de falha que ocorre toda vez que database e broker estão em transações diferentes. Outbox elimina o problema por design."
	},
	{
		id:            "eda-event-architecture-review"
		name:          "Revisão de Arquitetura Event-Driven: Inventário Periódico de Eventos, Projeções e Saúde"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) event catalog — atualizado? Novos eventos sem entry? Eventos deprecated sem sunset? (2) event sourcing — replay testado? Snapshots atualizados? Temporal queries funcionais? (3) CQRS — projeções healthy? Lag dentro do SLO? Rebuild testado? (4) schema evolution — schemas compatíveis? Upcasters implementados para eventos antigos? (5) choreography/orchestration — novos fluxos com style adequado? Sagas com compensações completas? (6) broker — outbox queue depth estável? Broker health? Volume vs capacidade? (7) domain vs integration events — boundary enforcement? Domain events expostos como integration? (8) error handling — DLQ size por consumer? Poisoned events? Recovery pendente? (9) context propagation — trace_id propagado em todos os eventos?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (projeção lag, DLQ size, outbox depth, broker health). Trimestral: macro-revisão com inventário completo."
		meshImplication: "Mensal (30min): projeção lag — todas dentro do SLO? Alguma crescendo? DLQ — eventos pendentes em dead letter? Para consumers financeiros: zero tolerance, investigar imediatamente. Outbox depth — publicação saudável? Broker health — partições balanced? Consumer groups healthy? Trimestral (2h): event catalog — cada BC produz os eventos documentados? Novos eventos foram adicionados sem documentar? Schema evolution — backward compatibility mantida? Algum breaking change não-comunicado? Projeções — rebuild de projeção aleatória funciona? Tempo de rebuild aceitável? Replay — reconstruir estado de 5 operações aleatórias via replay. Resultado coincide com read model? Se não: bug em projeção ou evento missing. Sagas — novos fluxos multi-BC modelados como saga? Compensações completas? Domain vs integration — algum BC consumindo domain events de outro? Enforcement de boundary. Error handling — classificação de erros adequada? Retry loops detectados? Context propagation — trace_id presente em todos os eventos? Se revisão não identifica pelo menos uma ação: ou a arquitetura está perfeita (improvável) ou a revisão é superficial."
		dependsOn: ["eda-event-sourcing", "eda-cqrs", "eda-event-catalog", "eda-schema-evolution", "eda-choreography-vs-orchestration", "eda-projections", "eda-replay-temporal-queries", "eda-event-broker-choice", "eda-domain-vs-integration-events", "eda-error-handling-dead-letters", "eda-transactional-outbox"]
		rationale: "Sem revisão periódica, arquitetura event-driven degrada: eventos não-documentados aparecem, projeções ficam stale, DLQs acumulam, schemas evoluem sem compatibility check. O inventário periódico mantém a arquitetura viva e saudável."
	},
]

reasoningProtocol: [
	{
		question:  "Este bounded context se beneficia de event sourcing? Tem requisito de auditabilidade, temporal queries, ou múltiplos consumers do mesmo estado?"
		reveals:   "Se event sourcing é justificado — ou se CRUD simples é suficiente. Event sourcing sem necessidade é complexidade desnecessária."
		rationale: "Overbeek 2023: event sourcing não é obrigatório para EDA. Na Mesh, ECL e Scoring têm requisito regulatório de auditabilidade — event sourcing justificado. Dashboard config: CRUD suficiente."
	},
	{
		question:  "Consumidores deste estado têm necessidades de query diferentes? Um único read model serve todos ou é compromisso para todos?"
		reveals:   "Se CQRS é justificado — fornecedor, construtora, FIDC e scoring precisam de views diferentes do mesmo dado."
		rationale: "Young 2010: CQRS quando read e write têm necessidades divergentes. Se 1 consumidor: CRUD. Se 4 consumidores divergentes: CQRS."
	},
	{
		question:  "Cada evento no sistema tem entry no event catalog com schema, producer, consumers e version?"
		reveals:   "Se o mapa de eventos é conhecido e governado — ou se eventos aparecem sem documentação e consumers descobrem por acidente."
		rationale: "AsyncAPI v3: event catalog como standard. Evento não-catalogado é evento não-governado."
	},
	{
		question:  "O schema deste evento é backward e forward compatible com versões anteriores? Se não: como consumers antigos processam?"
		reveals:   "Se schema evolution é disciplinada — ou se consumer antigo quebra quando producer evolui."
		rationale: "Kleppmann 2017: compatibility rules. Na Mesh com retenção de 5+ anos, eventos de 2025 coexistem com eventos de 2030."
	},
	{
		question:  "Este fluxo deve ser orchestrated ou choreographed? Requer compensação centralizada? Visibilidade end-to-end?"
		reveals:   "Se o style de coordenação é adequado ao tipo de fluxo — orchestration para financeiro, choreography para side effects."
		rationale: "Richardson 2018: sagas com ambos. Temporal 2020+: durable execution. Choreography para operação financeira = compensação invisível e distribuída."
	},
	{
		question:  "Cada projeção tem SLO de latência, é rebuild-able, e tem error handling com dead letter classification?"
		reveals:   "Se projeções são mantidas como infraestrutura confiável — ou se são scripts frágeis que silenciosamente param de atualizar."
		rationale: "Marten 2022+: living projections. Projeção que parou de atualizar e ninguém sabe é read model stale servindo dados errados."
	},
	{
		question:  "O event store suporta replay eficiente? Temporal queries são possíveis para auditoria regulatória?"
		reveals:   "Se a capability de 'time travel' existe — ou se event sourcing foi implementado mas replay é tão lento que é impraticável."
		rationale: "Boner 2023: replay para compliance. Regulador pergunta 'reconstrua operação X' — se replay leva 1h: impraticável."
	},
	{
		question:  "O broker de eventos é proporcional ao estágio? Transactional outbox garante ACID na publicação?"
		reveals:   "Se a infraestrutura de eventos é adequada ao volume e ao constraint — ou se é over-engineered (Kafka para 100 eventos/dia) ou under-engineered (publicação sem guarantee)."
		rationale: "Richardson 2018: outbox pattern. Na Mesh pré-revenue: PostgreSQL outbox. Kafka quando volume justificar."
	},
	{
		question:  "Domain events estão separados de integration events? BCs consomem apenas integration events de outros BCs?"
		reveals:   "Se boundaries são enforced — ou se domain events cruzam fronteiras gerando coupling máximo."
		rationale: "Vernon 2013: integration events como tradução. Domain event direto como integration = coupling do domain model inteiro."
	},
	{
		question:  "DLQ de consumers está vazia? Se não: quais eventos falharam, por que, e recovery está pendente?"
		reveals:   "Se erro handling está funcionando e eventos problemáticos são tratados — ou se DLQ é dump onde eventos vão morrer."
		rationale: "Hohpe/Woolf 2003: dead letter channel. DLQ que cresce sem investigação = data loss silenciosa."
	},
	{
		question:  "Eventos carregam trace context (trace_id, span_id, causality_refs)? Um fluxo end-to-end pode ser reconstruído?"
		reveals:   "Se context propagation está implementada nos eventos — ou se debugging requer correlação manual impossível."
		rationale: "DSD (dsd-context-propagation): propagação de contexto é decisão de design. Se evento não carrega trace_id: observabilidade não pode reconstruir o fluxo."
	},
]

meshExamples: [
	{
		id:       "ex-event-sourcing-ecl"
		scenario: "Mesh precisa projetar o bounded context ECL (Economic Commitment Lifecycle) com requisito de auditabilidade completa para regulador e suporte a backtesting de scoring models."
		analysis: "Dois requisitos que apontam para event sourcing: (1) auditabilidade — Bacen pode exigir reconstituição de qualquer operação com todos os dados do momento da decisão. Snapshot mutável (UPDATE status = 'approved') perde o timestamp, actor, e dados da transição. Event sourcing preserva cada transição como fato imutável. (2) backtesting — 'se modelo v3 tivesse existido, quais operações teriam sido aprovadas diferentemente?' requer replay de BuyerScored events com modelo diferente. Sem event sourcing: backtest requer snapshot de features a cada score (duplicação de dados). Com event sourcing: replay é nativo."
		recommendation: "ECL como event-sourced aggregate: (1) aggregate root: Operation. Commands: RequestAnticipation, ValidateDocuments, ScoreBuyer, DecideAnticipation, InitiateSettlement, ConfirmSettlement, RegisterOperation. (2) eventos: AnticipationRequested, DocumentsValidated, BuyerScored, AnticipationDecided, SettlementInitiated, SettlementConfirmed, OperationRegistered. Cada evento com: event_id, operation_id, timestamp, actor (agent_id ou human_id), trace_id, schema_version, e payload específico. (3) event store: Marten sobre PostgreSQL. Vantagens: PostgreSQL já é infra existente, Marten oferece event sourcing + projeções + snapshots como library. (4) snapshots: a cada 50 eventos por operation (operação típica tem 7-10 eventos, mas com corrections e updates pode crescer). (5) projeções: supplier_operations (live, <5s), builder_dashboard (live, <1min), fidc_portfolio (async, <5min), scoring_features (live, <1s). (6) outbox: eventos publicados via transactional outbox para consumers cross-BC. (7) replay: capability de reconstruir estado de qualquer operação em qualquer ponto no tempo. Testar trimestralmente. (8) retenção: 5+ anos para eventos financeiros."
		principlesApplied: ["ax-01", "ax-03", "ax-07", "dp-01"]
		assumptions: [
			"Marten sobre PostgreSQL é maduro o suficiente para produção — verificar versão e community health",
			"7-10 eventos por operação é estimativa — pode ser mais com corrections e retries",
			"snapshot a cada 50 eventos é frequência adequada — calibrar com dados reais",
			"5 anos de retenção é suficiente para regulação — verificar com assessoria jurídica",
		]
		rationale: "Boner 2023: event sourcing para regulated industries. Young 2010: audit trail por design. Marten 2022+: PostgreSQL como event store. ECL é o BC mais crítico da Mesh — auditabilidade por design (event sourcing) é superior a auditabilidade por adição (audit table separada)."
	},
	{
		id:       "ex-cqrs-multiview"
		scenario: "Construtora reclama que dashboard demora 8s para carregar. Investigação: query JOIN de 5 tabelas normalizadas (operações + fornecedores + compliance + scores + pagamentos) com agregações. Mesmo tempo de leitura impacta endpoint de fornecedor (que é simples: listar minhas operações)."
		analysis: "Read model único tentando servir construtora (dashboard agregado cross-BC) e fornecedor (lista simples por supplier_id). JOIN de 5 tabelas é necessário para dashboard mas desnecessário para fornecedor. Ambos competem pelo mesmo database e query engine. Problema: write model normalizado é ótimo para write (ACID, sem duplicação) mas subótimo para read (JOINs caros, latência alta para views complexas)."
		recommendation: "Implementar CQRS com projeções separadas: (1) manter write model normalizado (event-sourced aggregates). (2) criar projeções: (a) supplier_operations_view — tabela flat por fornecedor. Campos: operation_id, status, value, created_at, decided_at, settled_at. Índice: supplier_id + status. Query: <10ms. (b) builder_dashboard_view — tabela pré-agregada por construtora. Campos: total_operations, pending_count, approved_value_total, qualified_suppliers_count, compliance_alerts. Atualizada por eventos de 3 BCs. Query: <50ms (sem JOIN). (c) fidc_portfolio_view — time-series com pré-agregação. (3) projeções alimentadas por event stream. Cada projeção é consumer independente. Latência: supplier <5s, dashboard <1min, FIDC <5min. (4) read-after-write para fornecedor: quando fornecedor submete operação e imediatamente consulta, retornar projeção do write (não esperar event propagation). (5) monitoring: latência de projeção como SLI. Se dashboard_view lag >2min: investigar. (6) rebuild: se projeção corrompe ou schema muda, rebuild do zero via replay. Testar rebuild de cada projeção trimestralmente."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"8s de latência é causada por JOIN e não por indexação ruim — verificar query plan",
			"projeções separadas resolvem o problema — se volume é o issue, pode precisar de read replica também",
			"read-after-write implementável com causal consistency — pode ser complexo dependendo de stack",
			"rebuild de projeção é rápido o suficiente para ser prático — depende de volume de eventos",
		]
		rationale: "Young 2010: CQRS quando reads e writes divergem. Khononov 2024: polyglot read models. Na Mesh, 4 consumidores com queries radicalmente diferentes não devem compartilhar um único read model — cada projeção é otimizada para seu consumidor."
	},
	{
		id:       "ex-outbox-dual-write-prevention"
		scenario: "Operação de antecipação é aprovada. Aggregate ECL é atualizado no PostgreSQL. Evento AnticipationApproved deve ser publicado para: (1) saga de liquidação, (2) projeção de dashboard, (3) webhook para integrador. Broker (NATS) está momentaneamente indisponível."
		analysis: "Dual-write: transaction no PostgreSQL + publish no NATS são duas operações não-atômicas. Se PostgreSQL commitou e NATS está down: operação está aprovada mas ninguém sabe — saga de liquidação não inicia, dashboard não atualiza, integrador não recebe webhook. Fornecedor não recebe dinheiro. Se publish no NATS primeiro e PostgreSQL rollback: evento fantasma — saga inicia liquidação de operação que não foi aprovada. Ambos cenários são corrupção de estado. Frequência: NATS indisponível por 30s durante upgrade ou network glitch. Com 100 operações/dia: ~3 operações afetadas por mês."
		recommendation: "Transactional outbox: (1) na mesma transação que UPDATE do aggregate ECL (status = 'approved'): INSERT INTO outbox (aggregate_type='Operation', aggregate_id=op_id, event_type='AnticipationApproved', event_data=payload, status='pending'). ACID: se transação commita, evento está na outbox. Se rollback: nem aggregate nem evento existem. (2) publicação: worker lê outbox WHERE status = 'pending' ORDER BY created_at. Para cada: publica para NATS. Se sucesso: UPDATE outbox SET status = 'published', published_at = now(). Se falha (NATS down): retry no próximo poll (5s). Evento permanece pending. (3) NATS volta: worker publica eventos pending acumulados. Consumers processam. Saga inicia. Dashboard atualiza. Webhook dispara. Delay: tempo de indisponibilidade do NATS + tempo de poll. Para NATS down por 30s: delay de ~35s. Aceitável. (4) idempotência: consumer pode receber evento 2x (worker crashou após publish mas antes de marcar published). Consumer verifica event_id — se já processou, ignora. (5) monitoring: outbox pending count. Se >10 por >5min: alerta (broker provavelmente down ou worker travou). (6) cleanup: outbox events published há >7 dias movidos para archive."
		principlesApplied: ["ax-03", "ax-05", "dp-01"]
		assumptions: [
			"NATS indisponível por <1h é cenário realista — se >1h: investigar causa e escalation",
			"delay de 35s é aceitável para saga de liquidação — se time-sensitive: reduzir poll interval para 1s",
			"worker de outbox é single process sem redundância — se crashar, recovery na próxima execução. Para produção: 2 workers com leader election",
			"PostgreSQL performance com outbox table não degrada — cleanup regular mantém tabela pequena",
		]
		rationale: "Richardson 2018: outbox pattern elimina dual-write. Na Mesh, operação aprovada que não publica evento = fornecedor esperando dinheiro indefinidamente. Outbox garante: se operação foi aprovada, evento será publicado — eventual delay, nunca perda."
	},
	{
		id:       "ex-replay-regulatory-audit"
		scenario: "Bacen solicita reconstituição da operação 12345: todos os dados, decisões, e contexto no momento da aprovação (6 meses atrás). Objetivo: verificar que scoring e aprovação foram adequados."
		analysis: "Sem event sourcing: database tem apenas estado atual (operation.status = 'settled', score = 78). Não tem: qual modelo de scoring foi usado, quais features estavam disponíveis naquele momento, quem aprovou, quais documentos estavam validados, qual era o faturamento do comprador naquela data. Reconstrução é impossível ou requer colagem manual de logs. Com event sourcing: replay de eventos até AnticipationDecided produz estado completo no momento da decisão."
		recommendation: "Executar replay regulatório: (1) query event store: SELECT * FROM events WHERE aggregate_id = 'operation_12345' AND timestamp <= '2025-09-15T14:30:00Z' ORDER BY sequence_number. (2) eventos retornados: AnticipationRequested (solicitation data, invoice, value), DocumentsValidated (quais docs, status, validated_by), BuyerScored (score=78, model_version='v2.1', features_snapshot={faturamento_mensal: 850000, historico_pagamentos: 0.95, ...}), AnticipationDecided (decision='approved', decided_by='scoring-agent', reason='score 78 > threshold 60'). (3) reconstituir estado: no momento da decisão, operação tinha: documentos A, B, C validados, score 78 com modelo v2.1, features X, Y, Z. Decisão: aprovada por agente de scoring com threshold 60. (4) gerar relatório: timeline completa com timestamps, actors, dados de cada transição. Formato: JSON ou PDF conforme requisito do regulador. (5) validação: replay é determinístico — executar novamente produz o mesmo resultado. Se regulador questiona 'o scoring era adequado?': features_snapshot no evento prova exatamente quais dados informaram o score. (6) se modelo v2.1 tivesse bug conhecido que foi corrigido em v2.2: replay com v2.2 mostra qual seria o score correto. Transparência total."
		principlesApplied: ["ax-07", "ax-06", "dp-01"]
		assumptions: [
			"event store retém eventos de 6 meses atrás — retenção de 5+ anos configurada",
			"features_snapshot no evento BuyerScored captura todos os inputs — se features são calculadas at inference time sem snapshot: reconstituição é parcial",
			"formato de relatório para Bacen é conhecido — se não: preparar em JSON e adaptar",
			"replay é rápido o suficiente para resposta em tempo razoável — se operação tem 1000+ eventos: snapshot + delta replay",
		]
		rationale: "Boner 2023: event sourcing para compliance. Young 2010: temporal queries. Na Mesh, a pergunta do regulador 'reconstrua esta operação' é respondida nativamente por event sourcing — não requer sistema adicional de auditoria, não depende de logs que podem ser incompletos, e produz resultado determinístico. O event log é o audit trail."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-06", "ax-07", "dp-01", "dp-05"]

relatedLenses: [
	{
		lensId:   "lens-distributed-systems-design"
		relation: "complementsWith"
		context:  "DSD define patterns de sistemas distribuídos (consistency, sagas, idempotência, ordering). EDA define os patterns específicos de event-driven que implementam muitos desses conceitos. DSD (dsd-saga-coordination) é implementado por EDA (eda-choreography-vs-orchestration). DSD (dsd-consistency-at-boundary) é implementado por EDA (eda-domain-vs-integration-events). DSD (dsd-idempotency) é requerido por EDA (eda-transactional-outbox + consumers idempotentes). DSD (dsd-event-ordering-causality) é implementado por EDA (event log com ordering). DSD (dsd-context-propagation) é implementado por EDA (trace context em eventos). DSD é a teoria de distribuição; EDA é a implementação via eventos."
	},
	{
		lensId:   "lens-api-design-as-product"
		relation: "complementsWith"
		context:  "API define interface para consumidores externos. EDA define interface de eventos para consumidores internos. API (api-resource-modeling) separa resource model de domain model. EDA (eda-domain-vs-integration-events) separa domain events de integration events. Mesmo princípio (ACL), dimensão diferente (sync API vs async events). Webhooks de API são projeção de integration events: evento interno → transformação → webhook event externo."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG define audit trail para decisões de agentes. EDA (eda-event-sourcing + eda-replay-temporal-queries) implementa audit trail por design — event log é o audit trail. AAG diz 'reconstituir decisão X'; EDA diz 'replay até decisão X produz estado completo'. Agentes como consumers de eventos: agente de scoring consome events para calcular score; governado por AAG, alimentado por EDA."
	},
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitora sistema em produção. EDA projeções têm SLOs monitorados por OOI. DLQ size é métrica de OOI. Outbox depth é métrica de OOI. Consumer lag é métrica de OOI. OOI (ooi-anomaly-detection) detecta anomalias em event patterns. EDA é a arquitetura; OOI é a observabilidade sobre a arquitetura."
	},
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR modela risco de crédito e scoring. EDA (eda-replay-temporal-queries) habilita backtesting — replay de scoring events com modelo candidato antes de deploy. CR diz 'modelo v3 é candidato a substituir v2'; EDA diz 'replay 6 meses de BuyerScored com v3, comparar AUROC'. Replay é a ferramenta que torna model evolution segura e evidence-based."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM define knowledge as code e event catalog é knowledge as code para eventos. AsyncAPI schema no mesh-spec é o equivalente de CUE schema para APIs de eventos. KM (km-decision-records) documenta por que event sourcing foi escolhido para ECL; EDA implementa."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI protege dados em eventos — encryption de event payload, access control por consumer, audit trail imutável. EDA event log como append-only satisfaz requisito de imutabilidade de STI. STI (sti-backup-disaster-recovery) cobre backup do event store — RPO ≈ 0 para event log financeiro requer synchronous replication (DSD replication)."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos proporcionalmente ao estágio. EDA (eda-event-broker-choice) respeita: PostgreSQL outbox para pré-revenue (zero ops adicional), NATS para tração, Kafka managed para escala. ORA (ora-satisficing) governa: outbox satisfice para bootstrap. ORA (ora-reversibility-indexed-speed) informa: event sourcing é decisão tipo 2 (arquitetural) que merece análise proporcional."
	},
]

limitations: [
	{
		description: "Event sourcing adiciona complexidade significativa — event schemas, projeções, replay, snapshots, upcasting. Para bounded contexts sem requisito de auditabilidade ou temporal queries, CRUD é mais simples e suficiente."
		alternative: "Usar event sourcing seletivamente: apenas BCs com requisito regulatório de auditabilidade (ECL, Scoring) ou necessidade de backtesting. Outros BCs (config, user management): CRUD normal. EDA (eventos como comunicação entre BCs) pode existir sem event sourcing (eventos como notificação, não source of truth)."
		rationale: "Overbeek 2023: event sourcing ≠ EDA. Event sourcing sem necessidade é complexidade sem benefício. Na Mesh, ECL é event-sourced; dashboard config não precisa ser."
	},
	{
		description: "CQRS com projeções eventuais significa que consumidor pode ver estado stale. Para operações financeiras onde 'vejo saldo de 5 segundos atrás' pode levar a over-commitment: eventual consistency da projeção é insuficiente."
		alternative: "Para decisões financeiras que dependem de saldo atual: ler do command side (aggregate) com strong consistency, não da projeção. Projeções servem para consulta informacional; decisões financeiras usam source of truth. CQRS não proíbe ler do command side — proíbe que queries complexas impactem write path."
		rationale: "Young 2010: CQRS não significa 'sempre ler da projeção'. Decisão financeira que depende de estado current lê do aggregate. Projeção para dashboard."
	},
	{
		description: "Event log que cresce indefinidamente (append-only + retenção longa) pode se tornar caro em storage e lento em replay. 5 anos de eventos para cada operação = volume significativo em escala."
		alternative: "Tiered storage: eventos hot (últimos 30 dias) em SSD, eventos warm (30 dias - 1 ano) em HDD, eventos cold (>1 ano) em object storage (S3). Snapshots reduzem necessidade de replay completo. Compaction para aggregates encerrados (operação completed: compactar em single snapshot + eventos de correção)."
		rationale: "Event log infinito tem custo. Tiered storage + snapshots mantém custo proporcional ao valor — eventos recentes acessíveis rapidamente, eventos antigos acessíveis para auditoria."
	},
	{
		description: "Schema evolution com retenção de 5+ anos significa que upcasters precisam lidar com eventos muito antigos. Se upcaster tem bug ou se schema mudou de forma que upcasting é impossível: replay parcial falha."
		alternative: "Testar upcasters com eventos reais de cada versão como parte do CI. Manter sample events de cada schema version como test fixtures. Se upcasting é impossível para versão muito antiga: manter parser legacy como fallback."
		rationale: "Schema evolution é fácil no papel e difícil na prática quando 5 anos de versões acumulam. Teste com fixtures reais é a defesa."
	},
	{
		description: "Transactional outbox com poller introduz latência (polling interval). CDC (Debezium) reduz latência mas adiciona componente de infraestrutura. Trade-off entre simplicidade e latência."
		alternative: "Proporcional ao estágio: poller para pré-revenue (latência aceitável, complexidade mínima). PostgreSQL LISTEN/NOTIFY para tração (latência <100ms sem componente adicional). Debezium CDC para escala (latência mínima, componente adicional justificado por volume)."
		rationale: "Na Mesh pré-revenue, 5s de latência na publicação de evento é aceitável — fornecedor não nota diferença entre 'aprovado em 5s' e 'aprovado em 10s'. Otimizar latência quando volume justificar."
	},
]

rationale: "Toda plataforma com múltiplos bounded contexts, integrações externas e requisitos de auditabilidade se beneficia de arquitetura event-driven. Na Mesh como intermediário financeiro AI-native, eventos são naturais — cada operação é sequência de transições de estado que múltiplos consumers processam. Esta lens operacionaliza: event sourcing como audit trail por design para regulated industries (Fowler 2005, Young 2010, Boner 2023, Marten 2022+), CQRS com projeções multi-model para 4 consumidores divergentes (Young 2010, Khononov 2024, Overbeek 2023), event catalog como artefato canônico com AsyncAPI (Evans 2003, Hohpe/Woolf 2003, EventCatalog.dev 2022+, AsyncAPI v3 2023), schema evolution com compatibility rules e upcasting para retenção de 5+ anos (Kleppmann 2017, Confluent 2019+, Buf 2022+), choreography vs orchestration com durable execution (Hohpe/Woolf 2003, Richardson 2018, Temporal 2020+, Restate 2024+), projeções como living read models com rebuild capability (Young 2010, Marten 2022+, Eventuous 2023+), replay e temporal queries para auditoria regulatória e backtesting de modelos (Fowler 2005, Boner 2023), event broker proporcional ao estágio com transactional outbox (Richardson 2018, Debezium 2019+, NATS JetStream 2021+, Redpanda 2021+), domain vs integration events como ACL entre BCs (Evans 2003, Vernon 2013, Fowler 2017), error handling com dead letter classification (Hohpe/Woolf 2003), e transactional outbox como solução para dual-write problem (Richardson 2018, Debezium 2019+). Universal, agnóstica a estágio, aplicável a qualquer organização com bounded contexts que se comunicam por eventos."

}
