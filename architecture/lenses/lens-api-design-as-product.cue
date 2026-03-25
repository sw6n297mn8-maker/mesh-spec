package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

apiDesignAsProduct: artifact_schemas.#AnalyticalLens & {
	id:     "lens-api-design-as-product"
	name:   "Design de API como Produto"

	purpose: "Orientar decisões sobre como projetar APIs que são produto — developer experience, versionamento, naming, error handling e documentation."
	status: "draft"

	trigger: {
		conditions: [
			"a decisão envolve projetar interface programática que será consumida por sistemas ou desenvolvedores externos",
			"a decisão envolve como expor funcionalidades da Mesh para integração com ERPs, sistemas de construtoras ou fornecedores",
			"a decisão envolve versionamento de API — quando e como evoluir sem quebrar consumidores existentes",
			"a decisão envolve trade-offs entre expressividade, simplicidade e performance de uma API",
			"a decisão envolve autenticação, autorização e rate limiting para consumidores de API",
			"a decisão envolve design de payloads, error handling, paginação ou idempotência em API",
			"a decisão envolve como a API comunica estado de operações assíncronas (webhooks, polling, SSE)",
			"a decisão envolve documentação, sandbox, SDKs ou onboarding técnico para integradores",
			"a decisão envolve backward/forward compatibility e contratos de evolução de API",
			"a decisão envolve como métricas de uso de API informam decisões de produto",
			"a decisão envolve escolher entre paradigmas de API (REST, GraphQL, gRPC, event-driven)",
		]
		keywords: [
			"API", "endpoint", "REST", "GraphQL", "gRPC", "webhook",
			"integração", "integrador", "SDK", "client library",
			"versionamento", "backward compatibility", "breaking change",
			"payload", "schema", "request", "response", "error",
			"rate limit", "throttling", "quota", "API key",
			"documentação de API", "OpenAPI", "Swagger", "API reference",
			"sandbox", "ambiente de teste", "mock", "playground",
			"developer experience", "DX", "onboarding técnico",
			"paginação", "cursor", "offset", "filtro",
			"idempotência", "retry", "idempotency key",
			"webhook", "callback", "polling", "event stream", "SSE",
			"contract", "consumer-driven", "provider-driven",
			"deprecation", "sunset", "migration", "changelog",
		]
		excludeWhen: [
			"a decisão é sobre design de sistemas distribuídos internos (consistency, sagas, replication) — usar distributed-systems-design",
			"a decisão é sobre segurança e controle de acesso ao sistema — usar security-trust-infrastructure",
			"a decisão é sobre event sourcing e patterns de eventos internos — usar event-driven-architecture-patterns",
			"a decisão é sobre observabilidade de APIs em produção — usar observability-operational-intelligence",
			"a decisão é sobre experiência do integrador como estratégia de go-to-market — usar developer-and-integrator-experience",
		]
		rationale: "Toda plataforma B2B que cresce além de uso manual expõe APIs para que integradores (construtoras com ERPs, fornecedores com sistemas próprios, gestores FIDC com back-office) se conectem programaticamente. A API é o produto para esses consumidores — a experiência deles com a Mesh é a experiência com a API. API mal projetada gera: integração frágil (quebra a cada mudança), adoção lenta (integrador desiste), support burden alto (dúvidas sobre como usar), e lock-in fraco (integrador migra facilmente). API bem projetada é moat: quanto mais sistemas se integram, maior o switching cost e o valor da rede. Na Mesh AI-native, a API é a interface primária — não existe UI de dashboard como produto principal; a plataforma é consumida programaticamente."
	}

	concepts: [
		{
			id:         "api-design-first"
			name:       "Design-First: API Projetada Antes de Implementada"
			nature:     "theoretical"
			role:       "method"
			definition: "Sturgeon (2016, 'API Design First'): design-first significa definir a interface (schema, endpoints, payloads, erros) antes de escrever código — a API é contrato, não efeito colateral da implementação. Lauret (2019, The Design of Web APIs): API design-first produz interfaces mais consistentes, mais usáveis e mais estáveis porque o design é avaliado pela perspectiva do consumidor, não pela conveniência da implementação. OpenAPI Specification (2017+, OAS 3.0/3.1): standard para descrever APIs REST — schema machine-readable que serve como contrato, documentação e base para code generation. Conceito contemporâneo de 'API-as-product' (Jacobson et al. 2021, APIs as Digital Factories): APIs são produtos com ciclo de vida, roadmap, versionamento e customer experience — não são endpoints técnicos. Wilde/Amundsen/Mitra (2022, Design and Build Great Web APIs): API design é information architecture — estruturar recursos, relações e operações de forma que o modelo mental do consumidor corresponda à interface."
			meshManifestation: "Na Mesh, APIs expostas incluem: (1) API de fornecedor — solicitar antecipação, consultar status, listar operações, fazer upload de documentos. (2) API de construtora — consultar fornecedores qualificados, aprovar operações, visualizar pipeline de pagamentos, consultar compliance. (3) API de gestor FIDC — consultar carteira, acessar dados de lastro, visualizar indicadores de risco. (4) API interna — comunicação entre bounded contexts. Sem design-first: API do fornecedor expõe a estrutura interna do database (campo 'ecl_status_code' em vez de 'operation_status'). Construtora precisa fazer 5 requests para montar um dashboard que deveria ser 1 request. Gestor FIDC não encontra o dado de lastro porque o recurso se chama 'antecipacao' e ele procura 'cessao'. Design-first: projetar a API pela perspectiva do consumidor, não pela conveniência do backend."
			meshImplication: "Workflow de design-first para toda API externa: (1) identificar o consumidor — quem vai usar? Que job está fazendo? (conecta com ps-jobs-to-be-done se existir). (2) modelar os recursos pela perspectiva do consumidor — não pela estrutura do database. 'Operações de antecipação' (consumidor) vs 'ecl_commitment_entities' (interno). (3) definir o schema em OpenAPI 3.1 antes de implementar. Schema versionado no mesh-spec. (4) review do schema: agente ou humano avalia — o consumidor consegue completar seu job com esses endpoints e payloads? Se precisa de >3 requests para uma tarefa comum: design é subótimo. (5) mock server gerado a partir do schema — integrador pode testar antes de implementação real existir. (6) implementar a partir do schema — código gerado ou validado contra schema. Se implementação diverge do schema: CI falha (conecta com ooi-integration-contract-testing). Anti-pattern: code-first onde a API é gerada a partir de annotations no código — produz APIs que refletem estrutura interna, não necessidade do consumidor."
			rationale: "Sturgeon 2016: design antes de código. Lauret 2019: API pela perspectiva do consumidor. Jacobson et al. 2021: API como produto. Na Mesh, a API é o produto para integradores — design-first garante que a interface serve o consumidor, não o implementador."
		},
		{
			id:         "api-resource-modeling"
			name:       "Modelagem de Recursos: Vocabulário Compartilhado entre Plataforma e Consumidor"
			nature:     "theoretical"
			role:       "framework"
			definition: "Fielding (2000, REST): recursos são abstrações de informação — qualquer conceito que pode ser nomeado é recurso. A interface é sobre recursos e suas representações, não sobre operações. Richardson Maturity Model (Fowler 2010): Level 0 (RPC), Level 1 (recursos), Level 2 (HTTP verbs), Level 3 (HATEOAS). Level 2 é o sweet spot para maioria das APIs B2B — recursos nomeados + verbos HTTP padronizados. Amundsen (2020, Design and Build Great Web APIs): resource modeling é information architecture — organizar recursos em hierarquias e relações que correspondam ao domínio do consumidor. Conceito contemporâneo de 'API domain model' (Higginbotham 2021, Principles of Web API Design): o domain model da API não é o domain model interno — é uma visão simplificada, estável e orientada ao consumidor. Mudanças no modelo interno não devem propagar para a API. Anti-Corruption Layer (Evans 2003) entre domínio interno e API pública."
			meshManifestation: "Na Mesh, resource model público vs domain model interno: (1) interno: 'EconomicCommitmentLifecycle' com 7 states (INITIATED, VALIDATED, SCORED, APPROVED, SETTLED, REGISTERED, COMPLETED). Externo para fornecedor: 'Operation' com 4 status visíveis (submitted, approved, paid, completed). Fornecedor não precisa saber sobre states internos. (2) interno: 'NetworkGrowthAndReach' com funnel de 7 stages. Externo para construtora: 'Suppliers' com status (qualified, pending, disqualified). Construtora não precisa ver o funnel interno. (3) interno: CUE schemas com 50+ campos por entity. Externo: payloads com 10-15 campos relevantes para o consumidor. A ACL entre domínio e API é o que permite evoluir o domínio interno sem quebrar integradores."
			meshImplication: "Para cada API pública: (1) definir resource model público separado do domain model interno. Recursos públicos têm nomes orientados ao consumidor (português ou inglês conforme estratégia de localização). (2) ACL explícita — mapper/translator entre domain entities e API resources. Mudança no domain model: atualizar mapper. API resource permanece estável. (3) hierarquia de recursos intuitiva: /operations/{id} (operação de antecipação), /operations/{id}/documents (documentos da operação), /suppliers/{id} (fornecedor), /suppliers/{id}/qualifications (qualificações). Profundidade máxima: 3 níveis. Além disso: flatten ou usar query parameters. (4) naming conventions consistentes: plural para collections (/operations, não /operation), camelCase ou snake_case — escolher um e nunca misturar, verbos em ações que não são CRUD (POST /operations/{id}/approve, não PUT /operations/{id} com body {status: 'approved'}). (5) relações entre recursos: usar links (HATEOAS light) ou embedding seletivo — resposta de /operations/{id} inclui supplier_id com link para /suppliers/{supplier_id}, não embedding do supplier inteiro por default (permite opt-in via query parameter ?expand=supplier)."
			dependsOn: ["api-design-first"]
			crossDependsOn: [{
				lensId:    "lens-distributed-systems-design"
				conceptId: "dsd-consistency-at-boundary"
				context:   "DSD define Anti-Corruption Layer na fronteira entre bounded contexts. API resource modeling é ACL na fronteira entre domínio interno e consumidores externos. Mesmo princípio (proteger cada lado da complexidade do outro), escopo diferente: DSD para boundaries internas; API para boundaries externas. A API pública é a ACL mais importante do sistema — é a que integradores dependem."
			}]
			rationale: "Fielding 2000: recursos como abstrações. Amundsen 2020: resource modeling como information architecture. Higginbotham 2021: API domain model ≠ internal domain model. Na Mesh, separar resource model público do domain model interno é o que permite evolução interna sem quebrar integradores — e o que torna a API estável e intuitiva."
		},
		{
			id:            "api-versioning-evolution"
			name:          "Versionamento e Evolução: Mudar Sem Quebrar"
			nature:        "operational"
			role:          "framework"
			reviewCadence: "quarterly"
			definition:    "Amundsen (2020): APIs evoluem — o desafio é evoluir sem quebrar consumidores existentes. Três estratégias: (1) URL versioning (/v1/operations, /v2/operations) — claro mas custa manter múltiplas versões. (2) header versioning (Accept: application/vnd.mesh.v2+json) — menos visível mas mais flexível. (3) additive-only evolution — nunca remover campos, nunca mudar tipos, apenas adicionar. Se additive é insuficiente: nova versão. Sturgeon (2016): a regra de ouro — breaking change é qualquer mudança que faz um client existente falhar. Adicionar campo: não-breaking. Remover campo: breaking. Mudar tipo: breaking. Mudar semântica: breaking (mesmo que schema não mude). Conceito contemporâneo de 'API lifecycle management' (Postman State of APIs 2023, SmartBear 2024): APIs têm lifecycle — design → development → testing → deployment → monitoring → deprecation → sunset. Deprecation é fase ativa (aviso), sunset é remoção. Minimum sunset period para APIs B2B financeiras: 6-12 meses (integradores têm cycles de release longos). Conceito de 'API changelog as product communication' (Stripe, Twilio): changelog público, versionado, com classificação (breaking/non-breaking), datas, e migration guides."
			meshManifestation: "Na Mesh, evolução de API é inevitável: (1) model de scoring evolui — campos de response mudam. (2) novo tipo de operação (ex: desconto de duplicata além de antecipação) — novo resource ou extensão de existente? (3) requisito regulatório muda — campo obrigatório novo no registro de operação. (4) feedback de integrador — 'preciso de campo X que não existe na response.' Cada mudança é avaliação: additive (sem impacto) ou breaking (impacto em integradores)? Se a Mesh tem 5 integradores ativos: breaking change requer coordenação com 5 sistemas que têm release cycles próprios. Se tem 50: coordenação é impraticável — versioning obrigatório."
			meshImplication: "Estratégia de evolução em 3 camadas: (1) additive-only como default — todo campo novo é opcional. Nunca remover campo em versão existente. Nunca mudar tipo. Se campo precisa mudar semântica: criar campo novo com nome descritivo, deprecar campo antigo com header/metadata. (2) URL versioning quando additive é insuficiente — /v1, /v2. Suportar v1 por mínimo 12 meses após lançamento de v2 (B2B financial: integradores têm release cycles de 3-6 meses). (3) sunset protocol — 6 meses antes do sunset: comunicar via header (Sunset: <date>), via changelog, e via notificação direta ao integrador. 3 meses antes: reminder. No sunset: v1 retorna 410 Gone com link para migration guide. Changelog público: toda mudança de API documentada com: data, versão afetada, tipo (additive/deprecation/breaking), descrição, migration guide (se breaking). Para integradores: changelog é RSS/webhook subscriptable — integrador recebe notificação de mudança. Anti-pattern: 'silent breaking change' — mudar semântica de campo sem comunicar porque schema não mudou. É a breaking change mais insidiosa porque client não detecta até que resultado esteja errado."
			dependsOn: ["api-design-first", "api-resource-modeling"]
			crossDependsOn: [{
				lensId:    "lens-stakeholder-communication"
				conceptId: "sc-expectation-management"
				context:   "SC calibra expectativas de stakeholders. API versioning é expectation management para integradores: sunset period de 12 meses é promessa de estabilidade; changelog é transparência sobre evolução. Breaking change não-comunicada destrói confiança do integrador — mesmo padrão que SC modela para todos os stakeholders. SC diz 'nunca surpreender negativamente'; API versioning implementa isso para a interface programática."
			}]
			rationale: "Amundsen 2020: evolução sem quebrar. Sturgeon 2016: breaking change definition. Postman 2023: API lifecycle. Na Mesh B2B com integradores financeiros, breaking change não-comunicada pode causar falha em pipeline de pagamento do integrador — o custo de instabilidade de API é desproporcional ao custo de versioning disciplinado."
		},
		{
			id:         "api-error-design"
			name:       "Design de Erros: Falhar de Forma que o Consumidor Consiga Resolver"
			nature:     "theoretical"
			role:       "property"
			definition: "Lauret (2019): erros de API devem responder três perguntas para o consumidor: (1) o que aconteceu? (error code + message), (2) por que? (detail), (3) como resolver? (guidance). IETF RFC 9457 (2023, Problem Details for HTTP APIs — evolução do RFC 7807): standard para representação estruturada de erros — type (URI categorizando o erro), title (resumo humano), status (HTTP status code), detail (explicação específica desta instância), instance (URI da request que falhou). Conceito contemporâneo de 'error taxonomy as product decision' (Stripe API 2023+, Plaid 2024): categorizar erros por acionabilidade — (a) erros do client que o consumidor pode corrigir (400, 422 — payload inválido, campo ausente), (b) erros de negócio que o consumidor deve tratar (409 — operação já existe, 403 — não autorizado para este recurso), (c) erros de servidor que o consumidor não pode resolver (500, 503 — retry ou escalar). Cada categoria tem behavior diferente: client error = corrigir e reenviar. Business error = tratar no fluxo. Server error = retry com backoff. Twilio/Stripe: error codes estáveis e documentados que integradores codificam contra — 'card_declined' não muda de nome nunca."
			meshManifestation: "Na Mesh, erros de API incluem: (1) client errors — payload de solicitação de antecipação com campo 'valor' ausente (422), documento em formato não-suportado (400), idempotency key já usada com payload diferente (409). (2) business errors — operação rejeitada por scoring insuficiente (422 com business reason), fornecedor não qualificado para esta construtora (403), limite de concentração excedido (422 com detail). (3) server errors — scoring timeout (503), banco parceiro indisponível (502), erro interno não-classificado (500). Sem error design: integrador recebe '500 Internal Server Error' quando fornecedor não é qualificado — não sabe se é bug, se é regra de negócio, ou se deve retry. Com error design: recebe structured error com type, detail, e guidance — sabe exatamente o que aconteceu e o que fazer."
			meshImplication: "Implementar RFC 9457 como standard de erro: (1) todo erro retorna JSON estruturado com: type (URI permanente — 'https://mesh.com/errors/scoring-insufficient'), title ('Score insuficiente para antecipação'), status (422), detail ('Score do comprador CNPJ 12.345.678/0001-90 é 42, mínimo para antecipação é 60'), instance (URI da request). (2) error taxonomy codificada: criar catálogo de error types com código estável (SCORING_INSUFFICIENT, SUPPLIER_NOT_QUALIFIED, CONCENTRATION_LIMIT_EXCEEDED, DOCUMENT_FORMAT_INVALID, etc.). Códigos nunca mudam — integradores codificam contra eles. Adicionar novos: ok. Remover: breaking change. (3) por categoria: client errors (4xx) → incluir quais campos estão errados e o que é esperado. Business errors (4xx com business code) → incluir a regra de negócio que foi violada e, quando possível, o que o consumidor pode fazer (ex: 'solicite qualificação do fornecedor antes de solicitar antecipação'). Server errors (5xx) → incluir retry-after header e request-id para support. (4) nunca expor stack traces, internal IDs ou detalhes de implementação em erros de produção — é information disclosure (STI). (5) documentar todo error type no API reference com: quando ocorre, o que significa, e como resolver. Error documentation é tão importante quanto endpoint documentation."
			dependsOn: ["api-resource-modeling"]
			crossDependsOn: [{
				lensId:    "lens-distributed-systems-design"
				conceptId: "dsd-idempotency"
				context:   "DSD define idempotência para operações financeiras. API error design deve comunicar claramente quando idempotency key já foi usada (409 Conflict com detail 'idempotency_key already used with different payload') vs quando request é retry legítimo (retornar resultado anterior). O error design é a interface que torna idempotência usável pelo integrador — sem erro claro, integrador não sabe se deve retry ou corrigir."
			}]
			rationale: "Lauret 2019: erros devem ser resolvíveis. RFC 9457 2023: standard para problem details. Stripe/Twilio: error codes estáveis como contrato. Na Mesh, integrador que recebe '500 Internal Server Error' quando regra de negócio rejeita operação vai abrir ticket de support — custo para Mesh e para integrador. Erro estruturado elimina 80% do support."
		},
		{
			id:         "api-async-patterns"
			name:       "Patterns Assíncronos: Comunicar Estado de Operações que Demoram"
			nature:     "theoretical"
			role:       "method"
			definition: "Kleppmann (2017): operações que demoram (>500ms) não devem bloquear a response — usar padrão assíncrono. Três mechanisms: (1) polling — client faz GET periódico no recurso para verificar estado. Simples mas ineficiente (requests desperdiçadas) e com latência de descoberta (polling interval). (2) webhooks — server envia POST para URL registrada pelo client quando estado muda. Eficiente mas requer que client tenha endpoint acessível. (3) Server-Sent Events (SSE) / WebSocket — stream em tempo real. Máxima eficiência e mínima latência. Complexidade de conexão mantida. Conceito contemporâneo de 'webhook reliability patterns' (Svix 2023+, Hookdeck 2024): webhooks falham — endpoint do client pode estar down, request pode timeout. Patterns de confiabilidade: retry com exponential backoff, dead letter queue, signature verification (HMAC), event ordering via sequence number, idempotent delivery. Stripe (2023+): webhook events são idempotentes com event_id — client processa cada event_id uma vez. 'Webhook-first' como pattern para APIs financeiras: toda mudança de estado gera webhook, polling é fallback."
			meshManifestation: "Na Mesh, operações assíncronas: (1) antecipação — solicitação aceita (202 Accepted) → scoring → decisão → liquidação → registro. Cada transição de estado é evento que integrador precisa saber. Se integrador faz polling a cada 5min: descobre aprovação 5min depois. Se webhook: descobre em segundos. (2) qualificação de fornecedor — submissão aceita → análise de compliance → qualificação. Dias, não segundos. Polling impraticável. Webhook essencial. (3) upload de documento — aceito → processado → validado. Webhook com resultado. (4) liquidação — aprovada → em processamento → creditada. Timing depende de banco parceiro. Webhook quando crédito é confirmado."
			meshImplication: "Implementar webhook-first com polling como fallback: (1) webhook registration — integrador registra URL de callback + eventos de interesse (operation.approved, operation.settled, supplier.qualified). HMAC signature para autenticação de webhook (integrador verifica que webhook veio da Mesh). (2) webhook delivery — retry com exponential backoff (1s, 5s, 30s, 5min, 30min, 2h). Max retries: 8 (cobre ~3h de indisponibilidade). Dead letter queue: após max retries, evento vai para DLQ, integrador é notificado por email. (3) idempotência — cada webhook event tem event_id único. Client deve deduplicar por event_id. Mesh pode reenviar mesmo evento em retry — client não deve processar duas vezes. (4) ordering — eventos de mesma operação carregam sequence_number. Se client recebe seq 3 antes de seq 2: aguardar (ou consultar API para estado atual). (5) polling como fallback — GET /operations/{id} sempre retorna estado atual. Integrador sem webhook capability pode pollar. Rate limit: 60 requests/min para polling. (6) webhook dashboard — integrador pode ver: eventos enviados, status de delivery, retry history, DLQ. Self-service para reenviar eventos falhados. (7) webhook testing — sandbox envia webhooks para URL do integrador com dados de teste. Integrador valida implementação antes de produção."
			dependsOn: ["api-resource-modeling"]
			crossDependsOn: [{
				lensId:    "lens-distributed-systems-design"
				conceptId: "dsd-event-ordering-causality"
				context:   "DSD define ordering e causalidade de eventos internos. API async patterns define como essa causalidade é comunicada ao integrador externo. DSD garante que eventos internos estão ordenados; API garante que webhooks entregues ao integrador preservam a ordenação (sequence_number) e são idempotentes (event_id). DSD é o ordering interno; API é o ordering externamente visível."
			}]
			rationale: "Kleppmann 2017: async para operações longas. Svix/Hookdeck 2023+/2024: webhook reliability. Stripe 2023+: webhook-first com idempotência. Na Mesh onde operações financeiras levam horas/dias (scoring + liquidação + registro), polling é insuficiente e webhook é o mecanismo que torna a integração viável — mas webhook unreliable é pior que polling (integrador perde evento e não sabe)."
		},
		{
			id:         "api-rate-limiting-fairness"
			name:       "Rate Limiting e Fairness: Proteger o Sistema Sem Punir o Bom Integrador"
			nature:     "theoretical"
			role:       "heuristic"
			definition: "Jacobson et al. (2021): rate limiting protege o backend de overload e garante fairness entre consumidores — um integrador não pode consumir toda a capacidade. Três estratégias: (1) fixed window (N requests/minuto) — simples mas burst-prone na fronteira da window. (2) sliding window — mais justo, calcula rate sobre janela deslizante. (3) token bucket — permite burst controlado com rate sustentável definida. Conceito contemporâneo de 'adaptive rate limiting' (Cloudflare 2023+, Kong 2024): rate limits que se ajustam baseado em: health do backend (se backend está degradado, limit mais agressivo), tier do consumidor (tier premium = limit maior), e padrão de uso (burst legítimo vs abuse). 'Rate limit as product tier' (Stripe, Plaid): diferentes tiers de API = diferentes rate limits, throughputs, e SLAs. Rate limit é parte do pricing, não apenas proteção técnica. Response headers (IETF draft-ietf-httpapi-ratelimit-headers 2024): RateLimit-Limit, RateLimit-Remaining, RateLimit-Reset — informam o client quanto pode consumir sem adivinhação."
			meshManifestation: "Na Mesh, consumidores de API com padrões diferentes: (1) construtora grande com ERP integrado — requests automatizados em batch (500 requests de consulta de fornecedores no início do dia). Volume alto, padrão previsível. (2) fornecedor pequeno com sistema simples — requests manuais ou semi-automatizados (5-10 requests/dia). Volume baixo, padrão irregular. (3) gestor FIDC com sistema de monitoramento — queries periódicas de carteira (1 request/hora para dashboard). Volume baixo, consistente. (4) integrador abusivo ou mal-implementado — retry loop sem backoff que envia 1000 requests/minuto (bug, não malícia). Sem rate limit: integrador abusivo degrada API para todos. Com rate limit uniforme: construtora grande é penalizada por volume legítimo."
			meshImplication: "Rate limiting em 3 camadas: (1) global — proteção do backend: rate limit alto que previne DoS e bugs de retry (ex: 1000 requests/min por API key). Qualquer client que excede: 429 Too Many Requests com Retry-After header. (2) por tier — produto: tier free (60 requests/min), tier standard (300/min), tier premium (1000/min). Rate limit é parte do produto, não apenas proteção — tier premium paga mais e recebe mais capacidade. (3) por endpoint — sensibilidade: endpoints que consomem LLM (scoring) têm rate limit mais baixo que endpoints de consulta (GET operations). POST que cria operação: 10/min. GET que consulta status: 300/min. Implementar: token bucket para burst controlado (construtora pode batchear 500 GETs se fez <300 no minuto anterior). Response headers em toda response: RateLimit-Limit (limit configurado), RateLimit-Remaining (quanto resta), RateLimit-Reset (quando reseta). Client pode ajustar behavior sem trial-and-error. Monitoring: rate limit hits como métrica de produto — se integrador legítimo atinge limit regularmente: tier é insuficiente (conversar) ou endpoint é ineficiente (precisa de batch endpoint). Anti-pattern: rate limit sem headers — client não sabe o limit e descobre quando 429."
			dependsOn: ["api-design-first"]
			crossDependsOn: [{
				lensId:    "lens-distributed-systems-design"
				conceptId: "dsd-backpressure-flow-control"
				context:   "DSD define backpressure como mecanismo entre produtor e consumidor internos. API rate limiting é backpressure na fronteira com consumidores externos. DSD diz 'produtor interno respeita capacidade do consumidor'; API diz 'consumidor externo respeita capacidade da plataforma'. Ambos previnem overload; o mecanismo é diferente (backpressure via queue vs rate limit via 429)."
			}]
			rationale: "Jacobson et al. 2021: rate limiting como proteção e fairness. Cloudflare/Kong 2023+/2024: adaptive rate limiting. Stripe: rate limit como tier de produto. IETF 2024: rate limit headers. Na Mesh, rate limiting é simultaneamente proteção (contra abuse) e produto (tiers com capacidade diferente) — projetar como ambos desde o início."
		},
		{
			id:            "api-documentation-as-interface"
			name:          "Documentação de API como Interface Primária: O Integrador Lê Antes de Integrar"
			nature:        "operational"
			role:          "property"
			reviewCadence: "monthly"
			definition:    "Jacobson et al. (2021): documentação de API é a interface primária para o integrador — antes de escrever código, o integrador lê a documentação. Se a documentação é confusa, incompleta ou desatualizada: integrador desiste ou integra errado. Três camadas de documentação: (1) reference — lista completa de endpoints, payloads, erros, gerada a partir do OpenAPI schema (machine-generated, sempre sync com implementação). (2) guides — tutoriais orientados por tarefa ('como solicitar uma antecipação', 'como configurar webhooks'). (3) concepts — explicação de conceitos do domínio que o integrador precisa entender ('o que é antecipação de recebíveis', 'como scoring funciona'). Redocly/ReadMe/Mintlify (2023+): plataformas de documentação com 'try it' embutido — integrador testa endpoint diretamente na documentação sem sair da página. Conceito contemporâneo de 'docs-as-code' (Procida 2023, Diátaxis Framework): documentação estruturada em 4 tipos — tutorials (learning-oriented), how-to guides (task-oriented), reference (information-oriented), explanation (understanding-oriented). Cada tipo serve necessidade diferente; misturá-los degrada todos."
			meshManifestation: "Na Mesh, integradores são: (1) desenvolvedores de ERP de construtora — técnicos, querem reference + how-to guides. 'Como integrar lista de fornecedores qualificados no nosso SAP?' (2) desenvolvedor do fornecedor — pode ser não-técnico usando no-code/low-code. Quer tutorial step-by-step. 'Como solicitar minha primeira antecipação via API?' (3) equipe de TI do gestor FIDC — técnica, quer reference completo + concepts sobre o modelo de dados. 'Como os dados de lastro são estruturados?' Cada persona precisa de documentação diferente — mas todas precisam de reference atualizado."
			meshImplication: "Documentação em 4 camadas (Diátaxis): (1) reference — gerado a partir do OpenAPI schema. Auto-sync com implementação (se schema muda, docs atualizam). Cada endpoint: description, parameters, request body schema, response schema, error codes, exemplos de request/response. 'Try it' embutido conectado ao sandbox. (2) tutorials — onboarding orientado: 'Primeira antecipação em 10 minutos'. Step-by-step com code snippets em Python, Node, curl. (3) how-to guides — task-oriented: 'Como configurar webhooks', 'Como implementar retry com idempotência', 'Como paginar resultados'. (4) concepts — domain explanation: 'O que é antecipação de recebíveis', 'Como funciona o scoring da Mesh', 'Fluxo de vida de uma operação'. Docs-as-code: documentação versionada em Git, buildada em CI, reviewada em PR. Mudança de API sem atualização de docs = PR rejeitada. Métrica: time-to-first-successful-call — quanto tempo do 'li a documentação' até 'primeira request com sucesso no sandbox'. Se >1h para caso simples: documentação ou onboarding precisa melhorar."
			dependsOn: ["api-design-first", "api-error-design"]
			crossDependsOn: [{
				lensId:    "lens-knowledge-management"
				conceptId: "km-knowledge-as-code"
				context:   "KM define knowledge as code — versionado, testável, auditável. API documentation-as-code é o mesmo princípio aplicado ao conhecimento que integradores precisam. OpenAPI schema é o 'CUE schema' da API — machine-readable, validável por CI, e source of truth para docs geradas. KM diz 'conhecimento que não está codificado não existe'; API diz 'documentação que não está sync com implementação é pior que não existir'."
			}]
			rationale: "Jacobson et al. 2021: docs como interface primária. Procida 2023: Diátaxis framework. Redocly/Mintlify 2023+: try-it-in-docs. Na Mesh, o integrador não usa a Mesh — usa a API da Mesh. A documentação é a primeira impressão e a ferramenta diária. Docs ruins = integração ruim = adoção lenta."
		},
		{
			id:         "api-sandbox-testing"
			name:       "Sandbox e Testing: Integrador Testa Sem Risco"
			nature:     "operational"
			role:       "method"
			reviewCadence: "quarterly"
			definition: "Jacobson et al. (2021): sandbox é ambiente de teste que replica o comportamento da API de produção com dados fictícios — integrador pode testar sem risco financeiro ou operacional. Twilio/Stripe (2015+): sandbox com 'magic values' — inputs específicos que disparam cenários (ex: valor 42.00 simula aprovação, 66.66 simula rejeição de scoring). Permite que integrador teste happy path e error paths sem depender de estado real. Conceito contemporâneo de 'contract testing in sandbox' (Pact/PactFlow 2023+): sandbox que também valida que o client está usando a API corretamente — se client envia payload inválido, sandbox retorna erro detalhado com guidance. 'Shift-left testing' para integradores. Postman/Insomnia (2023+): collections de API pré-configuradas que integrador importa e executa — reduz time-to-first-call. Conceito de 'progressive environments' (sandbox → staging → production): integrador promove sua integração por ambientes com controles crescentes."
			meshManifestation: "Na Mesh, sandbox precisa simular: (1) fluxo completo de antecipação — solicitação → scoring → decisão → liquidação (simulada) → registro (simulado) → webhook de cada transição. (2) cenários de erro — scoring insuficiente, documento inválido, limite de concentração excedido, banco indisponível (503), timeout de scoring. (3) webhooks — sandbox envia webhooks para URL do integrador com dados de teste. Integrador valida que seu sistema processa webhooks corretamente. (4) dados de teste — CNPJs fictícios, valores fictícios, scores determinísticos baseados em magic values. Nunca dados reais em sandbox."
			meshImplication: "Implementar sandbox em 3 camadas: (1) sandbox automático — ambiente que replica API de produção com dados fictícios. Mesma interface, mesmos endpoints, mesmos error codes. Diferenças: dados são fictícios, liquidação é simulada (não move dinheiro real), scoring retorna valores determinísticos baseados em input. Magic values: CNPJ terminando em 001 → score alto (aprovação). Terminando em 002 → score baixo (rejeição). Terminando em 003 → timeout de scoring (503). Valor R$999.99 → limite de concentração excedido. (2) webhook testing — sandbox tem mecanismo de webhook delivery para URL do integrador. Integrador registra URL, sandbox envia eventos de teste. Dashboard mostra: evento enviado, response do integrador, tempo de resposta. (3) API collections — Postman collection pré-configurada com todos os endpoints, exemplos de request, e variáveis de ambiente (sandbox URL, API key de teste). Integrador importa e executa em minutos. Métrica: % de integradores que completam first successful call em sandbox em <24h. Se <50%: sandbox ou docs precisam de melhoria. Progressive environments: sandbox (teste livre) → staging (dados de teste mas fluxo completo com dependências reais simuladas) → production (dados reais, dinheiro real). Promoção requer: integrador demonstra que fluxo funciona em sandbox com todos os cenários testados."
			dependsOn: ["api-documentation-as-interface", "api-error-design", "api-async-patterns"]
			rationale: "Jacobson et al. 2021: sandbox como ambiente de teste. Stripe/Twilio: magic values. PactFlow 2023+: contract testing in sandbox. Na Mesh, integrador que não pode testar sem risco não integra — ou integra mal e descobre bugs em produção com dinheiro real."
		},
		{
			id:         "api-pagination-filtering"
			name:       "Paginação, Filtragem e Projeção: Controle do Consumidor sobre o Volume de Dados"
			nature:     "theoretical"
			role:       "property"
			definition: "Amundsen (2020): APIs que retornam coleções precisam de mecanismos para o consumidor controlar volume — paginação (quantos itens), filtragem (quais itens), e projeção (quais campos). Dois modelos de paginação: (1) offset-based (?offset=20&limit=10) — simples, random access, mas instável se dados mudam entre páginas (inserção muda offsets). (2) cursor-based (?cursor=abc123&limit=10) — estável (cursor aponta para posição fixa no dataset), sem random access, melhor para dados que mudam frequentemente. Conceito contemporâneo de 'relay-style cursor pagination' (Facebook/Relay 2016+, adotado por Stripe, Shopify, GitHub GraphQL): cursor é opaco (client não decodifica), response inclui has_next_page e end_cursor, paginação é forward-only ou bidirectional. Para APIs financeiras com dados que mudam (novas operações): cursor-based é superior porque garante que client vê toda operação exatamente uma vez. Filtragem: query parameters para campos comuns (?status=approved&min_value=10000). Projeção: ?fields=id,status,value — retorna apenas campos solicitados (reduz payload, melhora performance)."
			meshManifestation: "Na Mesh, collections que precisam de paginação: (1) operações de antecipação — construtora com 500+ operações precisa filtrar por status, período, fornecedor, valor. Sem filtragem: client baixa 500 operações e filtra localmente — ineficiente. (2) fornecedores qualificados — construtora com 200 fornecedores precisa paginar e filtrar por status de qualificação, segmento, score. (3) eventos de webhook — integrador consulta histórico de eventos enviados, filtrado por tipo e período. (4) dados de carteira para FIDC — gestor precisa de projeção: apenas campos de lastro, não todos os campos da operação."
			meshImplication: "Paginação cursor-based como default: (1) response inclui: data (array de itens), pagination.next_cursor (cursor para próxima página), pagination.has_more (boolean). (2) cursor é opaco — client não decodifica, apenas passa no próximo request. Cursor encode: posição no dataset (ex: base64 de timestamp + id). (3) limite de page size: default 20, max 100. Client pode pedir ?limit=50. (4) filtragem: query parameters para campos de alta cardinalidade e uso frequente. /operations?status=approved&created_after=2026-01-01&supplier_id=abc. Não usar: filter DSL complexo (ex: OData) — overkill para maioria dos cases e curva de aprendizado alta. (5) projeção: ?fields=id,status,value,supplier_id — retorna apenas campos solicitados. Útil para mobile clients e dashboards que precisam de subsets. (6) sort: ?sort=created_at:desc. Default: ordem natural (created_at desc para operações). (7) para dados financeiros: cursor-based garante que client que pagina vê toda operação exatamente uma vez mesmo que novas operações sejam criadas durante a paginação — offset-based não garante isso. Anti-pattern: retornar todos os resultados sem paginação quando collection pode crescer. 5.000 operações em um JSON = timeout e OOM no client."
			dependsOn: ["api-resource-modeling"]
			rationale: "Amundsen 2020: controle do consumidor sobre volume. Relay-style 2016+: cursor-based pagination. Na Mesh com operações financeiras que crescem continuamente, cursor-based pagination garante que integrador vê toda operação exatamente uma vez — offset-based com dados mutantes gera operações perdidas ou duplicadas."
		},
		{
			id:         "api-paradigm-choice"
			name:       "Escolha de Paradigma: REST, GraphQL, gRPC e Event-Driven — Cada Um para Seu Contexto"
			nature:     "theoretical"
			role:       "framework"
			definition: "Quatro paradigmas com trade-offs diferentes: (1) REST — resource-oriented, HTTP-based, stateless. Ubíquo, fácil de entender, tooling maduro. Limitação: over-fetching (campos desnecessários) e under-fetching (múltiplos requests para montar uma view). (2) GraphQL (Facebook 2015+): client define exatamente os campos que quer. Elimina over/under-fetching. Complexidade: caching difícil, query cost unpredictable, schema evolution mais restritiva. (3) gRPC (Google 2015+): binary protocol sobre HTTP/2, schema-first via Protobuf, streaming bidirecional. Performance superior. Limitação: não browser-native, tooling menos acessível para integradores não-técnicos. (4) event-driven (webhooks, SSE): server push de eventos. Eficiente para notificações. Não substitui request/reply. Conceito contemporâneo de 'multi-protocol API' (2023+): oferecer REST como interface primária (acessibilidade), gRPC para integrações de alta performance (machine-to-machine), e webhooks para eventos — cada consumidor usa o paradigma adequado ao seu contexto. Não é necessário escolher um único paradigma."
			meshManifestation: "Na Mesh, consumidores têm necessidades diferentes: (1) fornecedor com sistema simples — REST é adequado. Poucas requests, payload simples, curl/Postman para testar. GraphQL seria overengineering. (2) construtora com ERP integrado — REST para CRUD, webhooks para eventos. Se construtora precisa de view customizada (operações + fornecedores + scores num único request): GraphQL poderia ajudar. Mas REST com ?expand=supplier,score resolve 80% dos cases. (3) sistema interno entre bounded contexts — gRPC para comunicação high-frequency low-latency entre scoring e ECL. (4) gestor FIDC — REST com projeção (?fields=) para relatórios de carteira. Webhooks para alertas de risco."
			meshImplication: "Estratégia multi-protocol proporcional ao estágio: (1) MVP: REST-only para API pública. Webhooks para eventos. REST é suficiente para 95% dos integradores e tem menor custo de implementação + documentação + suporte. (2) escala: avaliar gRPC para comunicação interna entre BCs se latência for bottleneck (conecta com dsd-backpressure-flow-control). Manter REST para API pública — mudar paradigma público é breaking change para todos os integradores. (3) futuro: se feedback de integradores indica over/under-fetching como problema recorrente (ex: construtora precisa de 5 GETs para montar dashboard): avaliar GraphQL para subset de use cases — não substituir REST, adicionar como opção. BFF (Backend for Frontend) como alternativa: endpoint REST customizado para workflow específico da construtora. Anti-pattern: começar com GraphQL como API pública para startup B2B — curva de aprendizado para integradores, caching difícil, query cost unpredictable, e a maioria dos integradores de ERP espera REST."
			dependsOn: ["api-design-first", "api-resource-modeling"]
			crossDependsOn: [{
				lensId:    "lens-organizational-resource-allocation"
				conceptId: "ora-satisficing"
				context:   "ORA define satisficing — quando 'suficiente' supera 'ótimo' dado custo de busca. REST como paradigma público é satisficing: não é ótimo para todo caso de uso (over-fetching), mas é suficiente para 95% e tem custo marginal muito inferior a multi-protocol. Investir em GraphQL pré-revenue é otimizar prematuramente. ORA diz 'REST satisfice para API pública no estágio atual'; API paradigm choice implementa."
			}]
			rationale: "REST como universal, GraphQL para flexibilidade, gRPC para performance, webhooks para eventos. Na Mesh pré-revenue, REST + webhooks é o sweet spot — menor custo de implementação, documentação e suporte, com opção de adicionar paradigmas quando demanda real justificar."
		},
		{
			id:         "api-metrics-as-product-signal"
			name:       "Métricas de API como Sinal de Produto: O Uso da API Revela o que Importa"
			nature:     "operational"
			role:       "method"
			reviewCadence: "monthly"
			definition: "Jacobson et al. (2021): métricas de API são product metrics — quais endpoints são mais usados revela quais features importam. Quais endpoints nunca são usados revela features que falharam. Error rates por endpoint revelam onde a experiência está ruim. Conceito contemporâneo de 'API analytics as product intelligence' (Moesif 2023+, Apigee 2024): analytics de API vão além de monitoring — segmentar uso por integrador, por workflow, por hora do dia. Identificar patterns: integrador que começa usando 2 endpoints e depois cresce para 8 está se aprofundando (bom sinal). Integrador que para de usar após 1 semana churned (sinal de problema). 'API-first product management' (2023+): decisões de roadmap baseadas em API usage data — feature mais solicitada nem sempre é feature mais usada. Uso real > pesquisa de opinião."
			meshManifestation: "Na Mesh, API metrics revelam: (1) quais construtoras estão ativamente usando (requests/dia) vs registradas mas inativas. (2) quais features são realmente usadas — se endpoint de consulta de score nunca é chamado: construtoras não se importam com transparência de scoring (ou não sabem que existe). (3) error rates — se POST /operations retorna 422 em 30% das requests: payload de solicitação é confuso ou documentação é insuficiente. (4) time-to-first-call por integrador — integrador que demora 3 semanas para primeira call tem problema de onboarding. (5) webhook delivery success rate — se <95%: integradores têm endpoint instável ou Mesh tem bug de delivery."
			meshImplication: "Métricas de API em 4 categorias: (1) adoção — integradores ativos (≥1 request/semana), time-to-first-call, endpoints usados por integrador (depth of adoption). (2) saúde — error rate por endpoint, latência P50/P95/P99, rate limit hits, webhook delivery success rate. (3) produto — endpoints mais usados (ranking), endpoints não-usados (candidatos a deprecation), error codes mais frequentes (onde UX/docs precisa melhorar). (4) negócio — operações criadas via API (vs manual/dashboard), volume financeiro via API, integradores que expandem uso (upsell signal). Dashboard: atualizado daily. Revisão mensal: quais endpoints cresceram em uso? Quais caíram? Error rates melhoraram ou pioraram? Algum integrador churned? Time-to-first-call está diminuindo? Para roadmap: feature request de integrador + API usage data = priorização informada. Se integrador pede feature mas nunca usa features existentes similares: investigar antes de construir (demand signal vs noise)."
			dependsOn: ["api-design-first", "api-rate-limiting-fairness"]
			crossDependsOn: [{
				lensId:    "lens-observability-operational-intelligence"
				conceptId: "ooi-sli-slo-error-budget"
				context:   "OOI define SLIs/SLOs para serviços internos. API metrics define SLIs/SLOs para a API pública — que é o serviço mais importante para integradores. SLI de API: latência P99 de cada endpoint, availability, error rate. SLO: 99.5% de requests com latência <500ms, error rate <1%. Error budget governa velocidade de evolução de API — se budget esgotado, congelar mudanças e investir em estabilidade."
			}]
			rationale: "Jacobson et al. 2021: API metrics como product metrics. Moesif/Apigee 2023+/2024: API analytics como product intelligence. Na Mesh, a API é o produto para integradores — métricas de API são as métricas de produto mais puras. Uso real > opinião declarada."
		},
		{
			id:         "api-security-for-integrators"
			name:       "Segurança de API para Integradores: Proteger Sem Complicar"
			nature:     "operational"
			role:       "property"
			reviewCadence: "quarterly"
			definition: "OWASP API Security Top 10 (2023): top 10 riscos de segurança de APIs — Broken Object Level Authorization (BOLA), Broken Authentication, Broken Object Property Level Authorization, Unrestricted Resource Consumption, Broken Function Level Authorization, Server Side Request Forgery, Security Misconfiguration, Lack of Protection from Automated Threats, Improper Asset Management, Unsafe Consumption of APIs. Madden (2020, API Security in Action): segurança de API em camadas — autenticação (quem é), autorização (o que pode), rate limiting (quanto pode), input validation (o que envia), output filtering (o que recebe). Conceito contemporâneo de 'API security posture management' (Salt Security 2024, Noname 2023): monitoramento contínuo de postura de segurança de APIs — discovery de APIs não-documentadas (shadow APIs), detection de vulnerabilidades em runtime, e conformidade com best practices. Diferente de WAF: ASPM entende a lógica da API, não apenas padrões de HTTP."
			meshManifestation: "Na Mesh como intermediário financeiro, riscos de API incluem: (1) BOLA — fornecedor A acessa operação do fornecedor B via /operations/{id} com ID adivinhado. Se autorização é apenas 'API key válida' sem verificação de ownership: data breach. (2) broken auth — API key comprometida permite acesso a todos os dados do integrador. (3) unrestricted resource consumption — integrador mal-implementado faz loop de requests que degrada API. (4) improper asset management — versão antiga de API (v1) com vulnerabilidade conhecida ainda acessível. (5) unsafe consumption — Mesh consome API de banco parceiro que retorna payload malicioso — se não validado, propaga."
			meshImplication: "Segurança de API em 6 camadas: (1) autenticação — API key por integrador como mínimo. OAuth 2.0 com client credentials para integradores maiores. API keys: rotação a cada 90 dias, revogável imediatamente. (2) autorização object-level — TODA request verifica que o integrador tem acesso àquele recurso específico. Fornecedor A acessando /operations/{id}: verificar que operation pertence a fornecedor A. Não confiar em 'integrador autenticado = acesso a tudo'. BOLA é o risco #1 de OWASP API 2023 — e o mais comum. (3) rate limiting (api-rate-limiting-fairness) — proteção contra abuse. (4) input validation — toda request validada contra schema OpenAPI antes de processar. Campo inesperado: rejeitar (strict mode) ou ignorar (tolerant mode — escolher e documentar). Valores fora de range: rejeitar com erro claro. (5) output filtering — resposta nunca inclui campos internos (internal_id, database_key, stack_trace). Projeção por role: fornecedor não vê score detalhado do comprador, apenas resultado (aprovado/rejeitado). (6) logging de segurança — toda request logada com: API key, IP, endpoint, response status, timestamp. Anomaly detection: 100 requests de CNPJ X em 1 minuto (normal: 5) → alerta. Acessos a recursos de outro integrador (BOLA attempt) → alerta imediato. Anti-pattern: autenticação sem autorização object-level — 'API key válida' não significa 'acesso a tudo'. Cada resource tem ownership verificado em cada request."
			dependsOn: ["api-rate-limiting-fairness", "api-design-first"]
			crossDependsOn: [
				{
					lensId:    "lens-security-trust-infrastructure"
					conceptId: "sti-zero-trust-architecture"
					context:   "STI define zero trust para componentes internos (agentes, serviços). API security estende zero trust para consumidores externos — nunca confiar que integrador autenticado tem acesso ao recurso solicitado; verificar em cada request. STI é zero trust interno; API é zero trust externo. Ambos usam o mesmo princípio (verify always) em boundaries diferentes."
				},
				{
					lensId:    "lens-security-trust-infrastructure"
					conceptId: "sti-data-classification"
					context:   "STI classifica dados por sensibilidade. API output filtering implementa essa classificação na interface — dados Confidencial-Regulatório (score detalhado, dados financeiros de outro integrador) nunca aparecem em API response para quem não tem classificação de acesso. STI define o nível; API implementa o filtro."
				},
			]
			rationale: "OWASP API Security 2023: top 10 riscos. Madden 2020: API security em camadas. Salt Security 2024: API security posture management. Na Mesh como intermediário financeiro, BOLA (acesso indevido a dados de outro integrador) é o risco mais provável e mais impactante — verificação de ownership em cada request é o controle mais importante."
		},
		{
			id:            "api-design-review"
			name:          "Revisão de API: Inventário Periódico de Interface, Uso e Saúde"
			nature:        "operational"
			role:          "method"
			reviewCadence: "quarterly"
			definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) design consistency — novos endpoints seguem conventions? Naming, error format, paginação consistentes? (2) versioning — alguma versão precisa de deprecation? Breaking changes pendentes? Sunset timeline? (3) error analysis — error codes mais frequentes? Algum error code indica problema de design (integrador consistentemente erra)? (4) async patterns — webhook delivery rate? DLQ size? Integradores com webhooks falhando? (5) rate limits — integradores legítimos atingindo limit? Tiers adequados? (6) documentation — sync com implementação? Coverage (endpoints sem docs)? time-to-first-call trend? (7) sandbox — sandbox funcional? Cenários cobrem todos os error paths? (8) security — BOLA tests passando? API keys rotacionadas? Shadow APIs detectadas? (9) metrics — endpoints mais/menos usados? Integradores ativos/inativos? Adoption depth trend? (10) paradigm — REST suficiente? Feedback de integradores indica necessidade de GraphQL/gRPC?"
			meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (error rates, rate limit hits, webhook delivery, metrics dashboard). Trimestral: macro-revisão com inventário completo."
			meshImplication: "Mensal (30min): error rates por endpoint — algum >5%? Rate limit hits — integrador legítimo atingindo? Webhook delivery — success rate <95%? API metrics — integradores ativos, depth of adoption, churn. Time-to-first-call — diminuindo? Trimestral (2h): design consistency — novos endpoints seguem conventions? Review de naming, error format, paginação. Versioning — v1 precisa de deprecation? v2 planejado? Migration guide escrito? Error analysis — error codes top-10. Para cada: é problema do integrador (docs melhorar) ou problema de design (API melhorar)? Documentation — coverage 100%? Sync com implementação? Sandbox testado com cenários atuais? Security — run OWASP API Security tests. BOLA check em todos os endpoints de resource-specific. API keys — todas rotacionadas nos últimos 90 dias? Shadow APIs — endpoints não-documentados expostos? Metrics — ranking de endpoints por uso. Endpoints não-usados: candidatos a deprecation ou a investigação (integrador não sabe que existem?). Se revisão não identifica pelo menos uma melhoria: ou API é perfeita (improvável) ou revisão é superficial."
			dependsOn: ["api-design-first", "api-versioning-evolution", "api-error-design", "api-async-patterns", "api-rate-limiting-fairness", "api-documentation-as-interface", "api-sandbox-testing", "api-metrics-as-product-signal", "api-security-for-integrators", "api-pagination-filtering", "api-paradigm-choice"]
			rationale: "Sem revisão periódica, API evolui de forma inconsistente — novos endpoints divergem de conventions, erros não são analisados, integradores silenciosamente desistem. O inventário periódico mantém a API como produto saudável."
		},
	]

	reasoningProtocol: [
		{
			question:  "Esta API está sendo projetada pela perspectiva do consumidor (design-first) ou pela conveniência da implementação (code-first)?"
			reveals:   "Se a interface serve o integrador ou reflete a estrutura interna. API que expõe internal_id e ecl_status_code é code-first."
			rationale: "Sturgeon 2016: design antes de código. Lauret 2019: perspectiva do consumidor. API code-first gera interface que só faz sentido para quem implementou."
		},
		{
			question:  "O resource model público está separado do domain model interno? Mudança interna propagaria para integradores?"
			reveals:   "Se existe ACL entre domínio e API — ou se renomear campo interno quebra integradores."
			rationale: "Higginbotham 2021: API domain ≠ internal domain. Evans 2003: ACL. Separação é o que permite evolução interna sem breaking change."
		},
		{
			question:  "Esta mudança de API é additive, deprecation ou breaking? Se breaking: qual o sunset timeline e migration guide?"
			reveals:   "Se versionamento é disciplinado — ou se integradores descobrem breaking changes quando integração falha."
			rationale: "Amundsen 2020: evolução sem quebrar. Stripe: changelog público. Breaking change sem sunset = destruição de confiança do integrador."
		},
		{
			question:  "Os erros retornados respondem: o que aconteceu, por que, e como resolver? Ou são HTTP 500 genéricos?"
			reveals:   "Se erros são acionáveis pelo integrador — ou se todo erro gera ticket de support."
			rationale: "Lauret 2019: erros resolvíveis. RFC 9457: structured problem details. Erro claro elimina 80% do support."
		},
		{
			question:  "Operações assíncronas (antecipação, qualificação) comunicam estado via webhook? Webhooks são confiáveis (retry, idempotência, signature)?"
			reveals:   "Se integradores são notificados de mudanças de estado em tempo real — ou se precisam pollar indefinidamente."
			rationale: "Svix/Hookdeck 2023+: webhook reliability. Na Mesh, operações financeiras de horas/dias requerem notification, não polling."
		},
		{
			question:  "Rate limiting está implementado com headers informativos? Integradores legítimos estão atingindo limit?"
			reveals:   "Se rate limiting é proteção transparente — ou se é barreira opaca que frustra integradores."
			rationale: "IETF 2024: rate limit headers. Rate limit sem headers = integrador descobre o limit quando 429."
		},
		{
			question:  "A documentação está sincronizada com a implementação? Integrador consegue fazer first successful call em <1h usando apenas a documentação?"
			reveals:   "Se docs são produto mantido — ou se são artefato escrito uma vez e esquecido."
			rationale: "Jacobson et al. 2021: docs como interface primária. Docs desatualizados são piores que docs ausentes — geram falsa confiança."
		},
		{
			question:  "O sandbox replica todos os cenários relevantes (happy path + error paths + async events)? Integrador pode testar sem risco?"
			reveals:   "Se integrador pode validar sua implementação antes de produção — ou se o primeiro teste é com dinheiro real."
			rationale: "Stripe/Twilio: sandbox com magic values. Na Mesh financeira, primeiro teste com dinheiro real = risco inaceitável."
		},
		{
			question:  "Toda request verifica que o integrador tem acesso ao recurso específico (object-level authorization), não apenas autenticação?"
			reveals:   "Se BOLA (OWASP #1) está mitigada — ou se integrador autenticado pode acessar dados de outro integrador."
			rationale: "OWASP API Security 2023: BOLA é risco #1. Autenticação sem autorização object-level = data breach esperando acontecer."
		},
		{
			question:  "As métricas de API estão revelando padrões de uso que informam decisões de produto? Endpoints não-usados estão sendo investigados?"
			reveals:   "Se a API é tratada como produto com analytics — ou se é interface técnica sem feedback loop."
			rationale: "Moesif 2023+: API analytics como product intelligence. Uso real > opinião declarada. Endpoint não-usado é feature que falhou ou docs que falharam."
		},
		{
			question:  "REST é suficiente para o estágio atual? Há feedback real de integradores indicando necessidade de GraphQL ou gRPC?"
			reveals:   "Se a escolha de paradigma é baseada em demanda real — ou em preferência técnica sem evidência."
			rationale: "ORA satisficing: REST satisfice para 95% dos cases. Multi-protocol quando demanda real justificar, não antes."
		},
	]

	meshExamples: [
		{
			id:       "ex-api-resource-model-anticipation"
			scenario: "Mesh precisa projetar API pública para o fluxo de antecipação de recebíveis. Internamente, o bounded context ECL tem entity 'EconomicCommitmentLifecycle' com 7 states, 30+ campos, e relações com 3 outros BCs."
			analysis: "Design-first pela perspectiva do fornecedor: fornecedor não sabe o que é ECL, não precisa dos 7 states internos, e não precisa de 30 campos. Job do fornecedor: 'solicitar antecipação, acompanhar status, receber dinheiro.' Resource model público deve refletir esse job, não a estrutura interna. ACL entre ECL e API: mapper que traduz 7 states internos para 4 estados visíveis (submitted, approved, paid, completed). 30 campos internos para 12 campos públicos relevantes. Relações com outros BCs: expostas como links ou embedding seletivo, não como foreign keys internas."
			recommendation: "Resource model público: (1) POST /operations — solicitar antecipação. Body: {supplier_id, buyer_id, invoice_number, value, due_date, documents: [file_ids]}. Response: {id, status: 'submitted', created_at, estimated_decision_at}. (2) GET /operations/{id} — consultar status. Response: {id, status, value, created_at, decided_at, settled_at, rejection_reason?, supplier: {id, name}, buyer: {id, name}}. (3) GET /operations — listar operações. Paginação cursor-based. Filtros: ?status=approved&created_after=2026-01-01. (4) Webhooks: operation.submitted, operation.approved, operation.rejected, operation.settled, operation.completed. Cada webhook inclui operation_id + status + relevant_timestamps. (5) ACL mapper: interno SCORED → não exposto (fornecedor não precisa saber). Interno VALIDATED → mapeado para 'submitted' (ainda em análise do ponto de vista do fornecedor). Interno REGISTERED → mapeado para 'completed' (registro é concern da Mesh, não do fornecedor). OpenAPI schema versionado no mesh-spec. Mock server gerado para sandbox. Documentação gerada. Integrador testa antes de implementação."
			principlesApplied: ["ax-01", "ax-04", "dp-01"]
			assumptions: [
				"4 estados públicos são suficientes — fornecedor pode querer saber 'em análise de documentação' vs 'em análise de scoring'",
				"12 campos públicos cobrem necessidade do fornecedor — validar com integradores reais",
				"fornecedor não precisa saber sobre registro — se regulação exige comprovante de registro, pode ser necessário adicionar",
				"cursor-based paginação é familiar para integradores — incluir exemplo na documentação",
			]
			rationale: "Higginbotham 2021: API domain ≠ internal domain. Lauret 2019: perspectiva do consumidor. Fornecedor não é engenheiro da Mesh — a API deve falar a linguagem do fornecedor, não do backend."
		},
		{
			id:       "ex-webhook-reliability"
			scenario: "Integrador de construtora grande relata que 'algumas vezes não recebe webhook de operação aprovada.' Investigation revela: Mesh envia webhook, endpoint do integrador retorna 502 Bad Gateway intermitentemente. Após 3 retries, webhook vai para DLQ. Integrador não monitora DLQ e não sabe que perdeu eventos."
			analysis: "Falha de webhook reliability em múltiplas camadas: (1) endpoint do integrador instável — fora do controle da Mesh, mas impacta experiência. (2) retry policy com max 3 retries em 15min — insuficiente se instabilidade dura >15min. (3) DLQ existe mas integrador não tem visibilidade. (4) integrador não implementou polling como fallback. Resultado: operação aprovada, construtora não sabe, fornecedor não recebe notificação downstream. Impacto: delay em liquidação porque construtora precisa aprovar downstream e não sabe que operação foi aprovada."
			recommendation: "(1) Expandir retry policy: 8 retries com exponential backoff (1s, 5s, 30s, 5min, 30min, 2h, 6h, 12h). Cobre ~21h de indisponibilidade. (2) DLQ dashboard: integrador pode ver eventos falhados, detalhes de erro, e botão de reenviar. Self-service. (3) DLQ notification: quando evento vai para DLQ, enviar email para contato técnico do integrador: 'webhook de operation.approved falhou após 8 retries. Acesse dashboard para reenviar ou configure fallback polling.' (4) Polling fallback documentado: guide 'Como implementar polling como fallback de webhooks' — GET /operations?status=approved&updated_after=<last_check>. Integrador que implementa polling como fallback nunca perde evento. (5) Health check endpoint: integrador registra webhook URL + Mesh faz health check periódico (HEAD request). Se health check falha por >1h: notificar integrador. (6) Webhook testing in sandbox: cenário de teste onde webhook falha e integrador pode praticar retry/DLQ handling. (7) SLO de webhook: 99.5% dos webhooks entregues com sucesso em <5 minutos da mudança de estado. Se SLO violado: investigar."
			principlesApplied: ["ax-05", "dp-01", "dp-05"]
			assumptions: [
				"integrador implementará polling como fallback — pode não implementar sem incentivo",
				"8 retries em 21h é suficiente — se integrador fica down por >21h, é problema do integrador",
				"email notification de DLQ será lido — pode precisar de multiple channels (email + dashboard + Slack)",
				"SLO de 99.5% em <5min é achievable — depende de estabilidade de endpoints de integradores",
			]
			rationale: "Svix 2023+: webhook reliability patterns. Stripe: idempotent delivery + retry. Na Mesh, webhook perdido de operation.approved = delay financeiro real. Reliability não é 'enviar uma vez e esperar o melhor' — é retry robusto + DLQ visível + fallback documentado + health check."
		},
		{
			id:       "ex-versioning-breaking-change"
			scenario: "Mesh precisa adicionar campo obrigatório 'modalidade_cessao' (definitiva/coobrigação) ao POST /operations porque regulação exige. Integradores existentes não enviam esse campo — adicioná-lo como obrigatório quebra todas as integrações."
			analysis: "Breaking change regulatória: campo novo obrigatório em endpoint existente. Se adicionado como obrigatório em v1: toda integração existente falha com 422 (campo ausente). Se adicionado como opcional com default: regulação pode não aceitar default implícito. Se nova versão (v2): integradores precisam de tempo para migrar. Trade-off: compliance regulatória vs estabilidade de integração. Timing: regulação tem deadline. Integradores têm release cycle de 3-6 meses."
			recommendation: "Migração em 3 fases: (1) Fase 1 (imediata) — em v1: adicionar campo 'modalidade_cessao' como opcional com default 'coobrigação' (modalidade mais comum). Response inclui campo em todas as operações. Warning header: 'Deprecation: campo modalidade_cessao será obrigatório a partir de v2. Veja migration guide.' Integradores que já sabem a modalidade podem começar a enviar. (2) Fase 2 (T+3 meses) — lançar v2: campo obrigatório (sem default). v1 continua funcionando com default. Sunset de v1: T+12 meses. Comunicar: changelog, email direto a integradores, webhook (api.deprecation event). Migration guide: 'adicione campo modalidade_cessao ao body de POST /operations. Valores: definitiva, coobrigação.' (3) Fase 3 (T+12 meses) — sunset de v1. v1 retorna 410 Gone com link para v2 docs. Integradores que não migraram: quebra com aviso de 12 meses + 3 lembretes. Regra: compliance regulatória não pode ser adiada, mas migração de integrador pode ser faseada com defaults e sunset generoso. Anti-pattern: adicionar campo obrigatório sem aviso e quebrar integradores na próxima deploy."
			principlesApplied: ["ax-01", "ax-03", "ax-05"]
			assumptions: [
				"default 'coobrigação' é aceitável pelo regulador como transitório — verificar",
				"12 meses de sunset é suficiente — integradores financeiros podem precisar de mais",
				"3 fases são gerenciáveis — pode precisar de mais comunicação intermediária",
				"regulação permite período de transição com default — se não: fase 1 não é possível, ir direto para v2",
			]
			rationale: "Amundsen 2020: evolução sem quebrar. Sturgeon 2016: breaking change definition. Na Mesh B2B financeira, breaking change não-comunicada pode causar falha em pipeline de pagamento do integrador — migração em fases com sunset generoso é o pattern que respeita tanto regulação quanto integradores."
		},
		{
			id:       "ex-bola-prevention"
			scenario: "Pentester descobre que endpoint GET /operations/{id} retorna dados da operação para qualquer API key válida — fornecedor A pode consultar operações do fornecedor B adivinhando IDs (que são UUIDs sequenciais). 200 operações com dados financeiros potencialmente expostas."
			analysis: "BOLA (Broken Object Level Authorization) — OWASP API Security #1, 2023. Autenticação funciona (API key válida), autorização object-level ausente (não verifica que operation pertence ao integrador autenticado). UUIDs sequenciais facilitam enumeration (UUID v4 random seria mais difícil mas não impossível — security by obscurity não é defesa). Impacto: data breach de dados financeiros protegidos por sigilo bancário. Blast radius: todas as operações acessíveis via API — potencialmente toda a base."
			recommendation: "(1) Imediato — adicionar ownership check em TODOS os endpoints de resource-specific: GET /operations/{id} → verificar que operation.supplier_id == authenticated_api_key.supplier_id OU operation.buyer_id == authenticated_api_key.buyer_id. Se não: 404 Not Found (não 403 — 403 revela que recurso existe). (2) Audit — verificar TODOS os endpoints: GET /suppliers/{id}, GET /documents/{id}, GET /operations/{id}/documents. Cada um deve ter ownership check. Gerar lista de endpoints e marcar: has_ownership_check: true/false. Se false: fix imediato. (3) UUIDs — migrar de UUIDs sequenciais para UUID v4 (random). Não elimina BOLA (que requer ownership check) mas dificulta enumeration. (4) Automated testing — adicionar test de BOLA no CI: para cada endpoint resource-specific, testar que API key do integrador A não acessa recurso do integrador B. Se test falha: build falha. (5) Logging — logar toda tentativa de acesso a recurso de outro integrador (access denied após ownership check). Se frequência > 0: investigar — pode ser bug do integrador ou tentativa maliciosa. (6) Post-mortem — documentar incidente, root cause (ownership check ausente), fix, e teste automatizado. Se pentester encontrou antes de atacante: custo foi reputacional (pentest report) e não financeiro (breach real)."
			principlesApplied: ["ax-05", "ax-06", "dp-01"]
			assumptions: [
				"200 operações é o blast radius real — pode ser mais se API existe há mais tempo",
				"nenhum acesso malicioso ocorreu — verificar logs de acesso para patterns de enumeration",
				"ownership check em todos os endpoints é implementável em <1 semana — depende de arquitetura",
				"UUID v4 é suficiente como mitigation de enumeration — para alto risco, considerar token-based resource IDs",
			]
			rationale: "OWASP API Security 2023: BOLA é #1 por frequência e impacto. Madden 2020: authorization object-level em cada request. Na Mesh com dados financeiros sob sigilo bancário, BOLA é potencialmente o pior incidente de segurança — e o mais prevenível. Ownership check é 1 linha de código por endpoint; data breach é meses de remediação."
		},
	]

	principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-06", "dp-01", "dp-05"]

	relatedLenses: [
		{
			lensId:   "lens-distributed-systems-design"
			relation: "complementsWith"
			context:  "DSD projeta a arquitetura interna do sistema distribuído. API projeta a interface externa. DSD (dsd-consistency-at-boundary) define ACL entre BCs internos; API (api-resource-modeling) define ACL entre domínio interno e consumidores externos. DSD (dsd-idempotency) garante idempotência interna; API (api-error-design) comunica idempotência ao integrador. DSD (dsd-event-ordering-causality) garante ordering interno; API (api-async-patterns) garante ordering de webhooks. DSD é arquitetura; API é interface."
		},
		{
			lensId:   "lens-security-trust-infrastructure"
			relation: "complementsWith"
			context:  "STI define segurança sistêmica (zero trust, data protection, threat modeling). API (api-security-for-integrators) implementa segurança na interface pública — BOLA prevention, rate limiting, input validation, output filtering. STI é o framework; API é a implementação na boundary mais exposta. STI (sti-data-classification) define que dados financeiros são Confidencial-Regulatório; API implementa que esses dados nunca aparecem em response para quem não deve ver."
		},
		{
			lensId:   "lens-observability-operational-intelligence"
			relation: "complementsWith"
			context:  "OOI monitora sistema em produção. API (api-metrics-as-product-signal) usa métricas de API como product intelligence. OOI SLIs/SLOs se aplicam à API (latência, availability, error rate). OOI (ooi-integration-contract-testing) verifica que API em produção cumpre schema OpenAPI. OOI detecta degradação; API metrics revelam impacto no integrador."
		},
		{
			lensId:   "lens-stakeholder-communication"
			relation: "complementsWith"
			context:  "SC modela comunicação com stakeholders. Integradores são stakeholders técnicos. API (api-versioning-evolution) é expectation management codificado: sunset period, changelog, migration guides. SC (sc-expectation-management) diz 'nunca surpreender negativamente'; API implementa com deprecated headers, sunset dates, e proactive communication de breaking changes."
		},
		{
			lensId:   "lens-knowledge-management"
			relation: "complementsWith"
			context:  "KM define knowledge as code e documentação como ativo. API (api-documentation-as-interface) é documentação como produto para consumidores externos. KM governa conhecimento interno (mesh-spec); API governa conhecimento para integradores (API reference, guides, concepts). Ambos usam docs-as-code (versionado em Git, buildado em CI). API documentation é o 'mesh-spec dos integradores'."
		},
		{
			lensId:   "lens-organizational-resource-allocation"
			relation: "complementsWith"
			context:  "ORA aloca recursos entre atividades. API design compete com features internas. ORA (ora-satisficing) governa: REST satisfice para API pública no bootstrap vs investir em GraphQL. ORA (ora-cost-of-delay) prioriza: se integrador está esperando endpoint para ir live, CoD é urgente. API metrics informam ORA: endpoint não-usado = feature de baixo CoD para manutenção."
		},
		{
			lensId:   "lens-mechanism-design"
			relation: "complementsWith"
			context:  "MD desenha mecanismos (scoring, matching, pricing). API é a superfície pela qual integradores interagem com esses mecanismos. MD diz 'scoring considera estas features'; API expõe POST /operations com os campos que alimentam scoring. A API deve comunicar o suficiente para o integrador usar o mecanismo efetivamente, sem expor a lógica interna que constitui IP."
		},
	]

	limitations: [
		{
			description: "API design-first requer investimento upfront em design e documentação antes de implementar. Em sprint de bootstrap com recursos limitados, design-first pode ser percebido como overhead."
			alternative: "Mínimo viável de design-first: OpenAPI schema para endpoints core antes de implementar. Docs geradas automaticamente. Para endpoints internos ou low-priority: code-first aceitável com refactoring posterior. Design-first para API pública; code-first aceitável para API interna entre BCs."
			rationale: "ORA satisficing: design-first para API pública (custo de refactoring alto) é investimento proporcional. Para API interna (refactoring barato): code-first satisfice."
		},
		{
			description: "Webhook reliability depende do endpoint do integrador — se endpoint está instável, Mesh não pode entregar evento. Integradores em early-stage frequentemente têm infraestrutura frágil."
			alternative: "Polling como fallback obrigatório documentado. DLQ com dashboard self-service. Health check proativo. O integrador pode ter infra frágil — a Mesh deve ser resiliente ao integrador frágil, não assumir integrador perfeito."
			rationale: "Svix 2023: webhook reliability é shared responsibility. Na Mesh, o integrador mais frágil define o floor de reliability — projetar para o floor, não para o ideal."
		},
		{
			description: "Rate limiting como tier de produto requer pricing strategy definida — o que está incluído em cada tier, qual o preço, e como comunicar."
			alternative: "Pré-revenue: rate limit único generoso para todos. Quando pricing for definido: introduzir tiers. Não over-engineer pricing de API antes de ter integradores pagantes. Rate limit como proteção (always), rate limit como produto (when pricing exists)."
			rationale: "API rate limit como produto depende de pricing strategy (conecta com pricing-and-monetization-architecture). Sequenciar: proteção primeiro, monetização quando existir base."
		},
		{
			description: "OWASP API Security Top 10 evolui — novos riscos aparecem, mitigações mudam. A lens lista riscos de 2023 que podem ser parcialmente obsoletos."
			alternative: "Revisão anual dos riscos OWASP. Tratar a lista como baseline, não como checklist exaustiva. Complementar com pentest periódico que descobre riscos não-listados."
			rationale: "OWASP atualiza periodicamente. Na Mesh, BOLA (#1) e Broken Authentication (#2) são tão fundamentais que não se tornarão obsoletos — mas novos riscos podem aparecer com evolução de AI APIs."
		},
		{
			description: "Framework assume que integradores são desenvolvedores que leem documentação e implementam em código. Alguns integradores (fornecedores pequenos) podem precisar de no-code/low-code integration que a API pura não serve."
			alternative: "Para integradores não-técnicos: portal web como alternativa à API. Para integradores semi-técnicos: Zapier/Make integration ou widget embeddable. API é para integradores técnicos — não é a única interface."
			rationale: "API é produto para segmento técnico. Outros segmentos precisam de outras interfaces. Multi-sided platform UX (lens futura) cobre experiência por segmento."
		},
	]

	rationale: "Toda plataforma B2B que cresce além de uso manual expõe APIs como interface primária para integradores. Na Mesh como intermediário financeiro AI-native, a API é o produto — construtoras, fornecedores e gestores FIDC se conectam programaticamente. Esta lens operacionaliza: design-first com OpenAPI como contrato (Sturgeon 2016, Lauret 2019, Jacobson et al. 2021), resource modeling separado do domain model interno com ACL (Fielding 2000, Amundsen 2020, Higginbotham 2021), versionamento com additive-only default e sunset protocol (Amundsen 2020, Postman 2023, SmartBear 2024), error design com RFC 9457 e error taxonomy estável (Lauret 2019, RFC 9457 2023, Stripe/Twilio), patterns assíncronos com webhook-first reliability (Kleppmann 2017, Svix 2023+, Hookdeck 2024), rate limiting como proteção e produto com adaptive limits (Jacobson et al. 2021, Cloudflare 2023+, IETF 2024), documentação como interface primária com Diátaxis framework (Procida 2023, Redocly/Mintlify 2023+), sandbox com magic values e progressive environments (Stripe/Twilio, PactFlow 2023+), paginação cursor-based para dados financeiros mutantes (Relay 2016+), escolha de paradigma REST-first com multi-protocol proporcional ao estágio (satisficing de ORA), métricas de API como product intelligence (Moesif 2023+, Apigee 2024), e segurança de API com OWASP API Top 10 e BOLA prevention (OWASP 2023, Madden 2020, Salt Security 2024). Universal, agnóstica a estágio, aplicável a qualquer plataforma B2B que expõe APIs para integradores."

}
