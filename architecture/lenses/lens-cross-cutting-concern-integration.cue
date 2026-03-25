package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

crossCuttingConcernIntegration: artifact_schemas.#AnalyticalLens & {
id:     "lens-cross-cutting-concern-integration"
name:   "Integração de Concerns Transversais"

purpose: "Orientar decisões sobre como integrar concerns que atravessam múltiplos bounded contexts — logging, auth, i18n, error handling como infraestrutura coerente."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como garantir que concerns que atravessam múltiplos bounded contexts são tratados consistentemente",
		"a decisão envolve como evitar duplicação de lógica de observabilidade, segurança, compliance ou logging entre BCs",
		"a decisão envolve como projetar infraestrutura compartilhada sem criar coupling indesejado entre domínios",
		"a decisão envolve como patterns de error handling, retry, circuit breaker são aplicados uniformemente",
		"a decisão envolve como garantir que cada BC aplica policies de segurança, rate limiting e autenticação consistentemente",
		"a decisão envolve como projetar middleware, interceptors ou sidecar patterns para concerns transversais",
		"a decisão envolve como feature flags, configuration management e secrets são gerenciados across BCs",
		"a decisão envolve como garantir consistência de telemetria (tracing, metrics, logging) entre serviços",
		"a decisão envolve como evitar que concerns transversais se tornem single point of failure",
		"a decisão envolve como balancear padronização (consistência) com autonomia de cada BC (independência)",
	]
	keywords: [
		"cross-cutting", "transversal", "horizontal", "concern",
		"middleware", "interceptor", "sidecar", "proxy",
		"observability", "tracing", "metrics", "logging",
		"security", "authentication", "authorization", "policy",
		"error handling", "retry", "circuit breaker", "resilience",
		"feature flag", "configuration", "secrets", "config management",
		"rate limiting", "throttling", "quota",
		"idempotency", "correlation", "trace context",
		"shared library", "platform team", "internal platform",
		"consistency", "padronização", "uniformidade",
		"coupling", "independence", "autonomy",
		"aspect-oriented", "AOP", "decorator", "wrapper",
	]
	excludeWhen: [
		"a decisão é sobre observabilidade especificamente — usar observability-operational-intelligence",
		"a decisão é sobre segurança especificamente — usar security-trust-infrastructure",
		"a decisão é sobre compliance especificamente — usar regulatory-compliance-as-architecture",
		"a decisão é sobre event-driven architecture especificamente — usar event-driven-architecture-patterns",
		"a decisão é sobre design de API especificamente — usar api-design-as-product",
	]
	rationale: "Todo sistema com múltiplos bounded contexts enfrenta o mesmo desafio: concerns que não pertencem a nenhum domínio específico mas que todo domínio precisa — observabilidade, segurança, compliance, error handling, configuration, resilience. Sem estratégia explícita, cada BC implementa esses concerns de forma ad hoc: logging inconsistente, error handling diferente, security policies divergentes. Na Mesh AI-native com BCs (ECL, NGR, Scoring, Compliance) operados por agentes, concerns transversais são o tecido conectivo que garante que o sistema inteiro opera com qualidade uniforme — mesmo que cada BC seja desenvolvido independentemente. OOI cobre observabilidade; STI cobre segurança; RC cobre compliance; EDA cobre eventos. Esta lens cobre como todos esses concerns são integrados consistentemente across BCs sem duplicação, sem coupling indesejado, e sem single points of failure."
}

concepts: [
	{
		id:         "cc-cross-cutting-taxonomy"
		name:       "Taxonomia de Concerns Transversais: O Que Atravessa Todos os Bounded Contexts"
		nature:     "theoretical"
		role:       "framework"
		definition: "Kiczales et al. (1997, 'Aspect-Oriented Programming'): cross-cutting concerns são funcionalidades que afetam múltiplos módulos mas não se enquadram na decomposição principal do sistema. Em domain-driven design: bounded contexts são decomposição por domínio; cross-cutting concerns são ortogonais a essa decomposição. Taxonomia: (1) observabilidade — tracing, metrics, structured logging, alerting. Todo BC emite telemetria. (2) segurança — autenticação, autorização, encryption, input validation. Todo BC aplica policies. (3) resilência — retry, circuit breaker, timeout, fallback, bulkhead. Todo BC lida com falhas. (4) compliance — audit trail, data classification, retention, access logging. Todo BC registra ações. (5) configuration — feature flags, environment config, secrets management. Todo BC lê configuração. (6) communication patterns — correlation ID propagation, error response format, pagination. Todo BC comunica consistentemente. Conceito contemporâneo de 'internal developer platform' (IDP, 2022+, Humanitec, Backstage): plataforma que fornece cross-cutting concerns como serviço para BCs — developer/agente não implementa logging, security, ou retry: plataforma fornece. Conceito de 'platform engineering' (Gartner 2023+): disciplina de construir plataforma interna que abstrai infraestrutura e cross-cutting concerns, permitindo que equipes (ou agentes) foquem em lógica de domínio."
		meshManifestation: "Na Mesh, cross-cutting concerns por categoria: (1) observabilidade — OpenTelemetry (traces, metrics, logs) propagado em todo BC. Trace context (W3C) em toda request e evento. Metrics de latência, error rate, throughput por endpoint e por BC. Structured logging com correlation_id, agent_id, operation_id. (2) segurança — autenticação de API (Bearer token), autorização por role (fornecedor só acessa seus dados), input validation (schema-based), rate limiting por API key. (3) resilência — retry com exponential backoff para chamadas inter-BC, circuit breaker para dependências externas (bureau, registradora), timeout configurável por operação, graceful degradation (se scoring está down: queue, não rejeitar). (4) compliance — audit trail via event sourcing (rc-audit-trail-architecture), LGPD logging (acesso a dados pessoais), data classification enforcement. (5) configuration — feature flags (scoring model v2 vs v3 por %), environment config (sandbox vs production), secrets (API keys de integrações). (6) communication — RFC 9457 error responses em toda API, cursor-based pagination em todo endpoint de lista, correlation_id em todo header."
		meshImplication: "Para cada concern transversal: (1) definir standard — como este concern é implementado na Mesh. Documentar no mesh-spec. Standard é obrigatório para todo BC. (2) fornecer implementação — não apenas standard: fornecer library/middleware/template que implementa. BC consome, não reimplementa. (3) enforcement — verificar em CI/CD que standard é seguido. Lint rules para structured logging (campo correlation_id presente?), security headers, error format. Se violação: build falha. (4) ownership — cada concern tem owner (pode ser o mesmo para todos em solo founder, mas explícito). Owner mantém: standard documentado, implementação atualizada, enforcement rules. (5) lista completa de concerns para Mesh v1: (a) observability: OpenTelemetry SDK + W3C trace context. (b) security: auth middleware + rate limiter + input validator. (c) resilience: retry library + circuit breaker + timeout config. (d) compliance: event sourcing + access logger. (e) config: feature flag service + secrets manager + env config. (f) communication: error middleware (RFC 9457) + pagination helper + correlation middleware. Cada item com: standard doc, implementation, enforcement. Anti-pattern: cada BC implementa logging diferente, error handling diferente, e security diferente — sistema inconsistente, debugging impossível, e security gaps."
		rationale: "Kiczales et al. 1997: aspect-oriented. IDP 2022+: platform as service for concerns. Platform engineering Gartner 2023+. Na Mesh, 5 BCs com concerns implementados inconsistentemente = sistema onde debugging de request cross-BC é impossível (trace context não propaga), security tem gaps (1 BC não valida input), e compliance tem holes (1 BC não loga acesso)."
	},
	{
		id:         "cc-implementation-patterns"
		name:       "Patterns de Implementação: Como Aplicar Concerns Sem Poluir Lógica de Domínio"
		nature:     "theoretical"
		role:       "method"
		definition: "Cross-cutting concerns devem ser aplicados sem que lógica de domínio dependa deles explicitamente. Patterns: (1) middleware/interceptor — camada que processa request antes e depois de chegar ao handler. Logging, auth, rate limiting, correlation ID injection. Pros: transparente para handler. Cons: order of middleware matters. (2) decorator/wrapper — envolve função de domínio com concern adicional. retry(score_buyer(data)). Pros: explícito, testável. Cons: nesting profundo se muitos concerns. (3) sidecar/proxy — processo separado que intercepta tráfego (Envoy, Linkerd, Dapr). Pros: zero código no BC, language-agnostic. Cons: complexidade operacional, latência adicionada. (4) shared library — library importada por todo BC que fornece implementação padronizada. Pros: consistência garantida pelo import, updates via versioning. Cons: coupling via library version, coordenação de updates. (5) platform service — serviço centralizado que BCs consomem (config service, secret manager, feature flag service). Pros: single source of truth. Cons: single point of failure se não resiliente. Conceito contemporâneo de 'thin platform, thick standards' (2023+): em vez de plataforma interna complexa, fornecer: thin libraries + thick documentation + enforcement in CI. Adequado para startups e equipes pequenas — sem overhead de plataforma, com consistência de standards."
		meshManifestation: "Na Mesh, patterns por concern: (1) observability — middleware: request interceptor que inicia span, propaga trace context, loga structured log com correlation_id. Shared library: OpenTelemetry SDK configurado para Mesh (exporter, resource attributes, sampling). Cada BC importa library e usa middleware. Zero código de observabilidade na lógica de domínio. (2) security — middleware: auth interceptor que verifica token, extrai role, aplica authorization. Rate limiter como middleware. Input validation via schema (CUE/JSON Schema) como middleware. (3) resilience — decorator/wrapper: retry_with_backoff(call_bureau(cnpj)). Circuit breaker como wrapper. Timeout como config no client HTTP. (4) compliance — event sourcing como arquitetura (não concern adicionado — é a arquitetura fundamental). Access logger como middleware. (5) config — platform service: feature flag service (LaunchDarkly, Unleash, ou simples config file). Secrets: vault ou env vars encriptados. (6) communication — middleware: error formatter (catch exceptions, format RFC 9457). Pagination helper como shared function."
		meshImplication: "Para Mesh (solo founder, AI agents como developers): (1) thin platform, thick standards — não construir plataforma interna complexa. Fornecer: shared library com middleware pre-configurado + standards documentados no mesh-spec + CI enforcement. (2) shared library como core: 'mesh-platform-lib' com: (a) middleware stack: auth → rate_limit → correlation_id → trace_start → validate_input → [handler] → error_format → trace_end → log. (b) resilience: retry(fn, config), circuit_breaker(fn, config), timeout(fn, duration). (c) config: get_feature_flag(name), get_secret(name), get_config(key). (d) compliance: log_access(who, what, when, why). (3) cada BC importa mesh-platform-lib e usa middleware stack. Lógica de domínio não sabe que observabilidade, security, e resilience existem — middleware faz. (4) enforcement em CI: linter que verifica: todo endpoint usa middleware stack? Structured logging tem campos obrigatórios? Error responses são RFC 9457? Se não: build falha. (5) versioning: mesh-platform-lib é versionada (semver). BC pinned a versão. Update: PR que bumps version + verifica compatibilidade. (6) para AI agents como developers: mesh-platform-lib + standards docs são context que agente lê antes de implementar BC. CLAUDE.md referencia: 'todo novo endpoint deve usar middleware stack de mesh-platform-lib.' Agente que implementa BC sem middleware: CI falha. Anti-pattern: cada agente implementa logging, retry, e error handling de forma ad hoc porque não sabe que mesh-platform-lib existe — inconsistência e duplicação garantidas."
		dependsOn: ["cc-cross-cutting-taxonomy"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-context-propagation"
			context:   "DSD define context propagation (W3C Trace Context, OpenTelemetry). CC implementation patterns operacionaliza: middleware que propaga trace context automaticamente em toda request e evento. DSD é o standard; CC é o mecanismo (middleware) que garante que todo BC propaga sem código explícito."
		}]
		rationale: "Kiczales 1997: separação de concerns. Thin platform thick standards 2023+: adequado para startups. Na Mesh com agentes como developers, mesh-platform-lib + CI enforcement é o que garante que todo BC implementa concerns consistentemente — agente não precisa lembrar de adicionar logging; middleware faz."
	},
	{
		id:         "cc-consistency-vs-autonomy"
		name:       "Consistência vs Autonomia: Quanto Padronizar Sem Sufocar Cada BC"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Tensão fundamental: padronização garante consistência (debugging cross-BC, security uniforme, compliance completa). Autonomia permite evolução independente (BC pode mudar sem coordenar, agente pode escolher melhor approach). Conceito de 'golden path' (Spotify 2020+, Backstage): plataforma oferece caminho padrão (golden path) que cobre 90% dos casos. BCs podem desviar para 10% especiais com justificativa. Golden path: rápido, testado, suportado. Desvio: possível mas owner assume custo de manutenção. Conceito contemporâneo de 'mandate vs recommend' (2023+): para cada standard, decidir: (1) mandate — obrigatório, enforced por CI, zero exceção (security headers, auth, audit logging). (2) recommend — sugerido, monitorado mas não enforced (specific retry config, logging level). (3) optional — disponível mas não esperado (advanced tracing features, custom metrics). Conceito de 'Paved Road' (Netflix 2021+): infraestrutura oferece caminho pavimentado que é mais fácil que alternativa. Developer usa porque é mais fácil, não porque é obrigado. Adoção por conveniência > adoção por mandato."
		meshManifestation: "Na Mesh, mandate vs recommend vs optional: (1) mandated (enforced by CI, zero exception) — auth middleware em todo endpoint público. Correlation ID em todo header de request e evento. Structured logging com campos: timestamp, level, correlation_id, agent_id, message. Error format RFC 9457. Event sourcing para BCs definidos (ECL, Scoring). Input validation via schema. LGPD access logging para dados pessoais. (2) recommended (monitored, exceptions documented) — retry config: 3 retries, exponential backoff, 1s/5s/30s (pode ajustar por endpoint com rationale). Circuit breaker threshold: 50% error rate em 10s window (pode ajustar). Logging level: INFO em produção, DEBUG em development. Feature flag naming convention: snake_case, prefixed by BC. (3) optional (available, no expectation) — custom metrics beyond standard set. Advanced tracing (custom spans for domain logic). Performance profiling hooks."
		meshImplication: "Framework de decisão: (1) para cada standard: categorizar como mandate/recommend/optional usando critério: (a) se inconsistência causa: security vulnerability → mandate. Debug impossibility → mandate. Compliance gap → mandate. Suboptimal performance → recommend. Aesthetic preference → optional. (2) mandate: mínimo necessário. Resist temptation to mandate everything — cada mandato é coordination cost. Only mandate what is truly non-negotiable. (3) golden path documentation: no mesh-spec, seção 'Platform Standards' com: mandated standards (list + rationale + enforcement), recommended standards (list + rationale + how to deviate), optional standards (list + how to adopt). (4) for AI agents: CLAUDE.md references golden path. Agent reads golden path before implementing. CI enforces mandates. Agent que propõe desvio de recommend: justifica em PR description. (5) measure adoption: % of BCs that follow each recommend standard. If <50% follow a recommendation: either promote to mandate (if important) or demote to optional (if not useful). Recommend that nobody follows is noise. (6) evolve standards: quarterly review. New mandate needed? Existing mandate too restrictive? Recommend that should be mandate (or optional)? Standards evolve with system maturity. Anti-pattern: mandate everything — every config value, every logging field, every retry parameter. Result: BCs can't adapt to specific needs, agents spend time fighting standards instead of building domain logic."
		dependsOn: ["cc-cross-cutting-taxonomy", "cc-implementation-patterns"]
		crossDependsOn: [{
			lensId:    "lens-ai-agent-governance"
			conceptId: "aag-governance-as-code"
			context:   "AAG codifica governance policies para agentes. CC standards são governance de infraestrutura para BCs — mandates enforced by CI, recommends monitored. AAG governa o que agentes podem fazer; CC governa como BCs são implementados. Ambos são governance-as-code: machine-readable, enforceable, auditable."
		}]
		rationale: "Golden path Spotify 2020+. Mandate vs recommend 2023+. Paved Road Netflix 2021+. Na Mesh, mandate o mínimo (security, observability, compliance), recommend o útil (retry config, logging level), e leave optional o restante. Agentes que seguem golden path produzem BCs consistentes com mínimo esforço."
	},
	{
		id:         "cc-error-handling-strategy"
		name:       "Estratégia Unificada de Error Handling: Erros Tratados Consistentemente em Todo o Sistema"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Error handling é o cross-cutting concern mais impactante em experiência e debugging. Inconsistência: BC A retorna {error: 'bad request'}, BC B retorna {code: 400, message: 'invalid'}, BC C retorna HTML de erro. Impossível para consumer (frontend, integrador, agente) tratar erros uniformemente. Conceito de 'error taxonomy' (2022+): classificar erros em tipos com handling definido: (1) validation errors — input inválido. Response: 400 com detalhes de quais campos falharam. Ação do consumer: corrigir input. (2) business rule errors — input válido mas regra de negócio impede (score abaixo de threshold, concentração excedida). Response: 422 com regra violada. Ação: ajustar operação ou escalar. (3) authorization errors — não tem permissão. Response: 403. Ação: obter permissão. (4) not found — recurso não existe. Response: 404. Ação: verificar ID. (5) transient errors — sistema temporariamente indisponível. Response: 503 com Retry-After. Ação: retry. (6) internal errors — bug ou falha inesperada. Response: 500 com request_id para suporte. Ação: reportar. RFC 9457 (2023, 'Problem Details for HTTP APIs'): formato padronizado: {type, title, status, detail, instance}. Conceito contemporâneo de 'error messages that teach' (2023+): error response não apenas diz o que está errado — diz como corrigir. 'Campo buyer_cnpj é obrigatório. Formato: XX.XXX.XXX/XXXX-XX. Exemplo: 11.222.333/0001-44.' Developer/agente que lê a mensagem pode corrigir sem consultar documentação."
		meshManifestation: "Na Mesh, error handling unificado: (1) error format — RFC 9457 para toda API: {type: 'https://mesh.com/errors/validation-error', title: 'Validation Error', status: 400, detail: 'Campo buyer_cnpj é obrigatório.', instance: '/operations/12345', errors: [{field: 'buyer_cnpj', message: 'Required. Format: XX.XXX.XXX/XXXX-XX', code: 'required'}]}. (2) error taxonomy — validation (400), business_rule (422), auth (401/403), not_found (404), rate_limit (429), transient (503), internal (500). Cada tipo com: HTTP status, error code estável (para programmatic handling), human-readable message, e docs link. (3) error propagation — quando BC A chama BC B e B retorna erro: A não propaga erro raw de B para consumer. A wraps: 'Scoring service returned error: [summary]. Request ID: [id].' Consumer vê erro de A (contexto), não de B (detalhe interno). (4) error logging — todo erro é logged com: correlation_id, request_id, error_type, error_detail, stack_trace (para 500s), timestamp, agent_id. Debugging: buscar por correlation_id mostra trace completo cross-BC."
		meshImplication: "Error handling como mandated standard: (1) RFC 9457 middleware — em mesh-platform-lib: middleware que catch exceptions e formata como RFC 9457. BC handler throws domain exception (ScoreThresholdNotMet, DocumentExpired). Middleware converte para RFC 9457 response com type, title, status, detail. BC não formata erro — middleware formata. (2) error taxonomy registry — no mesh-spec: tabela de error types com: code (stable), HTTP status, description, consumer action, docs link. Referência para integradores e agentes. (3) error messages que ensinam — para cada error type: message template com: o que está errado + formato esperado + exemplo + link para docs. Mandated para validation errors (mais frequentes). Recommended para business rule errors. (4) error propagation rules — mandated: (a) nunca expor stack trace em produção (security). (b) nunca propagar error detail de BC interno para consumer externo (information leakage). (c) sempre incluir request_id em 500 errors (suporte pode buscar). (d) sempre incluir Retry-After em 503/429 (consumer sabe quando retry). (5) error monitoring — SLI: error rate por endpoint, por error type. Se 500 error rate >1%: alerta. Se 400 error rate sobe 50%: possível breaking change ou bug de integrador. (6) para AI agents: error taxonomy é parte do context que agente lê. Agente que implementa endpoint: deve usar error types corretos. CI lint: 'endpoint retorna 400 mas não usa error type de validation' → warning. Anti-pattern: catch-all que retorna 500 para todo erro — developer/agente não sabe se é bug (retry não ajuda) ou input inválido (corrigir ajuda)."
		dependsOn: ["cc-cross-cutting-taxonomy", "cc-implementation-patterns"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-error-design"
			context:   "API define error design com RFC 9457, error taxonomy estável, e error messages educativas. CC operacionaliza: middleware que converte domain exceptions em RFC 9457, error taxonomy registry no mesh-spec, e CI enforcement de error format. API é o design; CC é a implementação cross-BC que garante consistency."
		}]
		rationale: "RFC 9457 2023: problem details standard. Error taxonomy 2022+. Error messages that teach 2023+. Na Mesh, error handling inconsistente entre BCs é o bug mais impactante para integradores (cada BC retorna formato diferente) e para debugging (correlação manual entre erros de BCs diferentes)."
	},
	{
		id:         "cc-resilience-patterns"
		name:       "Patterns de Resiliência: Como Todo BC Lida com Falhas de Forma Uniforme"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Nygard (2018, Release It!, 2nd ed.): sistemas em produção falham — a questão não é se, mas quando e como o sistema responde. Resilience patterns: (1) retry with backoff — falha transiente: retry após delay crescente. Config: max_retries, initial_delay, backoff_factor, max_delay. (2) circuit breaker — se dependência está falhando consistentemente: parar de chamar (open circuit). Config: failure_threshold, recovery_timeout, half_open_requests. (3) timeout — não esperar infinitamente. Config: connect_timeout, read_timeout. (4) bulkhead — isolar falha de dependência A de afetar dependência B (thread pools, connection pools separados). (5) fallback — se operação primária falha: oferecer alternativa degradada. (6) idempotency — operação pode ser executada múltiplas vezes com mesmo resultado (dsd-idempotency). Conceito contemporâneo de 'resilience as library' (resilience4j 2019+, Polly 2020+, Temporal 2020+ para durable execution): resilience patterns como library configurável — developer/agente aplica com 1 linha, não reimplementa. Conceito de 'resilience testing' (Chaos Engineering, Netflix 2011+, Gremlin 2018+, Antithesis 2023+): testar que resilience funciona injetando falhas — timeout artificial, error injection, dependency kill."
		meshManifestation: "Na Mesh, resilience por dependência: (1) bureau de crédito (API externa) — retry: 3x com backoff (1s, 5s, 30s). Circuit breaker: se 50% fail em 30s → open por 60s. Timeout: 10s. Fallback: se bureau down → usar último score cached (se <7 dias) ou escalar para human. (2) registradora (API externa) — retry: 3x com backoff. Circuit breaker: se 30% fail → open. Timeout: 30s (registradora pode ser lenta). Fallback: queue operação para retry posterior (registro não é blocking para aprovação). (3) banco (liquidação) — retry: 5x com backoff (1s, 5s, 30s, 5min, 30min). Timeout: 60s. Fallback: notificar human + alerta. Sem circuit breaker (cada liquidação é única). (4) inter-BC (scoring → feature store) — retry: 2x, 1s. Timeout: 5s. Fallback: se feature store down → scoring com features cached (se <1h) ou reject com 'scoring temporarily unavailable.' (5) LLM (compliance validation) — retry: 1x. Timeout: 30s. Fallback: escalar para human review. Circuit breaker: se 30% fail → open."
		meshImplication: "Resilience como shared library: (1) mesh-platform-lib resilience module: retry(fn, {max_retries, initial_delay, backoff_factor, max_delay}). circuit_breaker(fn, {failure_threshold, recovery_timeout}). timeout(fn, duration). Configurável por dependência. (2) resilience config per dependency — no mesh-spec ou config store: cada dependência externa tem config de resilience documentada. 'bureau: {retry: 3, backoff: [1s, 5s, 30s], circuit_breaker: {threshold: 50%, window: 30s, recovery: 60s}, timeout: 10s, fallback: cached_score_if_fresh}.' (3) default config — se BC não especifica: default razoável (retry 3x, timeout 30s, no circuit breaker). BC que precisa de config custom: override com rationale. (4) resilience testing — mensal: simular falha de cada dependência externa. Bureau down por 5min: sistema degrada gracefully? Registradora timeout: operações são queued? LLM down: compliance escala para human? Se não: fix resilience config. (5) monitoring — circuit breaker state como métrica: open/closed/half-open por dependência. Se circuit breaker abre frequentemente: dependência é unreliable → investir em fallback ou alternativa. (6) for AI agents: quando agente implementa integração com dependência externa: checklist — 'retry configurado? Timeout definido? Fallback para quando dependency está down? Circuit breaker se aplicável?' CI: integração sem timeout configurado → warning. Anti-pattern: BC que chama bureau com timeout infinito e sem retry — 1 request lento trava thread, 100 requests lentos travam o serviço inteiro."
		dependsOn: ["cc-cross-cutting-taxonomy", "cc-implementation-patterns"]
		crossDependsOn: [{
			lensId:    "lens-distributed-systems-design"
			conceptId: "dsd-failure-modes"
			context:   "DSD modela failure modes em sistemas distribuídos (8 fallacies, network partitions, Byzantine failures). CC resilience patterns implementa a resposta a esses failure modes uniformemente across BCs. DSD é a teoria de falhas; CC é a implementação de resilience que responde a essas falhas. DSD diz 'rede não é confiável'; CC diz 'retry + timeout + circuit breaker em toda chamada de rede'."
		}]
		rationale: "Nygard 2018: Release It. resilience4j/Polly 2019+/2020+. Chaos Engineering Netflix 2011+. Na Mesh, cada BC que chama dependência externa sem resilience é BC que pode travar quando dependência falha — e falhas são inevitáveis."
	},
	{
		id:         "cc-configuration-management"
		name:       "Gestão de Configuração: Feature Flags, Secrets e Environment Config Across BCs"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Configuration management: como o sistema lê e aplica configuração que varia por environment (dev/staging/prod), por feature (flag on/off), e por BC (custom settings). Conceito de 'configuration as code' (2020+): configuração versionada no repositório, deployada via CI/CD, auditável por diff. Conceito contemporâneo de 'feature flags for safe deployment' (2022+, LaunchDarkly, Unleash, Flipt): feature flags permitem deploy de código sem ativar feature — feature é ativada via config, não via deploy. Rollback: desativar flag, não rollback de código. Gradual rollout: flag para 10% → 50% → 100%. Kill switch: flag para 0% se problema detectado. Conceito de 'secrets management' (2022+, HashiCorp Vault, AWS Secrets Manager, Doppler): secrets (API keys, database passwords, encryption keys) nunca em código. Secrets em vault acessível via API. Rotation automática. Audit de acesso."
		meshManifestation: "Na Mesh, configuration por tipo: (1) environment config — database URL, API base URLs, log level, feature thresholds. Diferente por environment (dev/staging/prod). Source: env vars ou config file por environment. (2) feature flags — scoring_model_v3_enabled: true/false (ou percentage). new_webhook_format_enabled: true/false. sandbox_time_simulation: true (sandbox only). Source: config file ou feature flag service. (3) business config — score_threshold: 60. max_operation_value: 100000. required_documents: ['cnd_federal', 'cnd_estadual', 'contrato_social']. Source: mesh-spec config ou config store. (4) secrets — bureau_api_key, registradora_api_key, fidc_bank_credentials, llm_api_key. Source: vault ou encrypted env vars. Nunca em código, nunca em config file plain text."
		meshImplication: "Configuration management unificado: (1) hierarchy of config — secrets (vault) > feature flags (flag service) > business config (config store) > environment config (env vars). Mais específico overrides mais genérico. (2) mesh-platform-lib config module — get_config(key, default) que resolve da hierarchy: busca em vault → flag service → config store → env var → default. BC não precisa saber onde config vive — library resolve. (3) feature flags para safe deployment — todo novo feature: deploy com flag off. Ativar para 10% (canary). Se ok: 50% → 100%. Se problema: flag off (kill switch). Mandated para features que afetam operações financeiras (scoring model, pricing engine, compliance rules). Recommended para features de UX. Optional para features internas. (4) secrets management — proporcional ao estágio. Pré-revenue: encrypted env vars (suficiente para solo founder com poucos secrets). Tração: vault (HashiCorp Vault, Doppler). Rotation: manual inicialmente, automática quando secrets >20. Audit: quem acessou qual secret quando. Mandated: secrets nunca em código, nunca em plain text config, nunca em logs. (5) business config as code — thresholds, required documents, policies: versionados no mesh-spec. Mudança: PR com review + ADR. Deploy: config update sem código deploy. Agente que muda threshold: PR com rationale → review → merge → auto-applied. (6) monitoring — config drift: config em produção diverge de config no repositório? Se sim: sync issue, investigar. Feature flag audit: quais flags estão on? Alguma flag temporária que deveria ter sido removida? Quarterly cleanup de flags. Anti-pattern: secrets como variáveis de ambiente plain text em docker-compose.yml commitado no Git — breach waiting to happen."
		dependsOn: ["cc-cross-cutting-taxonomy", "cc-implementation-patterns"]
		crossDependsOn: [{
			lensId:    "lens-knowledge-management"
			conceptId: "km-knowledge-as-code"
			context:   "KM define knowledge as code — versionado, testável. CC configuration management é config as code: business thresholds, feature flags, policies — todos versionados no mesh-spec, modificáveis via PR, auditáveis por diff. KM é o princípio; CC é a aplicação para configuration. Mudança de score_threshold de 60 para 65 é PR no mesh-spec com ADR, não chat message para alguém 'mudar o valor'."
		}]
		rationale: "Configuration as code 2020+. Feature flags 2022+. Secrets management 2022+. Na Mesh com agentes como developers, configuration management centralizado garante que: agente A não usa score_threshold=60 enquanto agente B usa 65 porque leu config diferente."
	},
	{
		id:         "cc-observability-integration"
		name:       "Integração de Observabilidade: Telemetria Consistente que Habilita Debugging Cross-BC"
		nature:     "operational"
		role:       "property"
		reviewCadence: "quarterly"
		definition: "Observabilidade é cross-cutting concern mais visível — quando sistema tem problema, é a observabilidade que permite diagnosticar. Mas observabilidade inconsistente entre BCs é pior que nenhuma: traces que quebram entre BCs, métricas com nomes diferentes para mesmo conceito, logs sem correlation_id. Conceito de '3 pillars unified' (2022+, OpenTelemetry): traces, metrics, e logs unified sob mesmo SDK e same correlation (trace_id liga trace + metric + log do mesmo request). Conceito contemporâneo de 'observability as shared concern' (2023+): observabilidade não é responsabilidade de cada BC individualmente — é concern da plataforma. Plataforma fornece: SDK configurado, middleware que instrumenta, e backend que armazena/visualiza. BC não precisa pensar em observabilidade — middleware faz."
		meshManifestation: "Na Mesh, observabilidade cross-BC: (1) traces — request de fornecedor submete operação: trace começa no API gateway → span: validate_documents (BC compliance) → span: calculate_score (BC scoring) → span: decide_approval (BC ECL) → span: initiate_settlement (BC settlement). Trace_id propaga em todos os spans. Se decisão leva 8s: trace mostra que scoring levou 6s → diagnóstico: scoring é bottleneck. (2) metrics — métricas padronizadas por BC: request_duration_ms (histogram), request_count (counter), error_count (counter, by type), active_operations (gauge). Naming convention: mesh_{bc}_{metric}_{unit}. Exemplo: mesh_scoring_request_duration_ms, mesh_ecl_active_operations. (3) logs — structured JSON: {timestamp, level, correlation_id, trace_id, span_id, agent_id, bc, message, ...context}. Searchable por qualquer campo. Correlation_id liga: log + trace + metric + evento."
		meshImplication: "Observability como mandated standard: (1) OpenTelemetry SDK em mesh-platform-lib — configurado para Mesh: exporter (Jaeger/Grafana Tempo para traces, Prometheus para metrics, Loki para logs — ou equivalentes managed). Resource attributes: service.name, service.version, deployment.environment. Sampling: 100% em sandbox, 10% em produção (ajustável). (2) middleware que instrumenta automaticamente — request interceptor: (a) extrai ou gera trace_id. (b) inicia span com: endpoint, method, params (sanitized). (c) propaga trace context para chamadas downstream (inter-BC, external). (d) loga: structured log com trace_id + correlation_id. (e) registra metrics: duration, status. BC handler não sabe que está sendo instrumentado. (3) naming convention mandated — metrics: mesh_{bc}_{what}_{unit}. Logs: campos obrigatórios (timestamp, level, correlation_id, trace_id, bc, message). Spans: {bc}.{operation} (scoring.calculate_score). (4) dashboards per BC + cross-BC — per BC: request rate, error rate, latency P50/P95/P99. Cross-BC: trace duration breakdown (quanto de cada BC contribuiu para latência total). Alertas: error rate >1%, latency P99 >SLO, circuit breaker opened. (5) para AI agents: observabilidade é transparente — agente implementa domain logic, middleware instrumenta. Agente não precisa adicionar logging ou tracing manualmente. Se agente quer log adicional (domain-specific): usar structured log com campos extras (operation_id, score, decision). Anti-pattern: BC A usa Jaeger, BC B usa Zipkin, BC C não usa tracing — debugging cross-BC impossível."
		dependsOn: ["cc-cross-cutting-taxonomy", "cc-implementation-patterns"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-operational-topology"
			context:   "OOI define operational topology — mapa de dependências entre componentes. CC observability integration implementa: trace context propagation que permite reconstruir topology em runtime. OOI diz 'conhecer dependências é pré-requisito de observabilidade'; CC diz 'middleware propaga trace context que permite OOI reconstruir topology automaticamente de traces reais'."
		}]
		rationale: "OpenTelemetry 3 pillars 2022+. Observability as shared concern 2023+. Na Mesh, request de antecipação que cruza 4 BCs: sem trace context propagation, debugging é correlação manual de logs de 4 sistemas. Com: 1 trace_id mostra timeline completa em <10 segundos."
	},
	{
		id:            "cc-cross-cutting-review"
		name:          "Revisão de Concerns Transversais: Inventário Periódico de Consistência e Saúde"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) taxonomy — novos concerns identificados? Concerns existentes ainda relevantes? (2) implementation — mesh-platform-lib atualizada? BCs usando versão current? (3) consistency vs autonomy — mandates sendo seguidos? Recommends com adoção razoável? Standards outdated? (4) error handling — error taxonomy complete? RFC 9457 enforced? Error messages educational? (5) resilience — configs adequate per dependency? Circuit breaker states? Chaos testing realizado? (6) configuration — secrets secure? Feature flags cleaned up? Config drift? (7) observability — traces cross-BC functional? Metrics naming consistent? Dashboards úteis?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (CI enforcement stats, circuit breaker states, observability health)."
		meshImplication: "Mensal (30min): CI enforcement — % de builds que passam em lint de standards. Se declining: standards estão sendo ignorados ou são too strict. Circuit breaker — algum aberto frequentemente? Dependency unreliable? Observability — traces cross-BC funcional? Testar: submeter operação em sandbox, verificar trace end-to-end. Trimestral (2h): mesh-platform-lib — version current em todos os BCs? Updates pendentes? Changelog reviewed. Error handling — sample 20 error responses de produção. RFC 9457 compliance? Messages educativas? Error taxonomy — tipos novos necessários? Standards review — mandates still valid? Any mandate que should be relaxed? Any recommend que should be mandate? Resilience — chaos test: desligar 1 dependency por vez, verificar graceful degradation. Configuration — secrets rotated? Feature flags: temporárias removidas? Config drift entre repo e produção? Se revisão não identifica pelo menos uma melhoria: ou cross-cutting é perfeito (improvável) ou revisão é superficial."
		dependsOn: ["cc-cross-cutting-taxonomy", "cc-implementation-patterns", "cc-consistency-vs-autonomy", "cc-error-handling-strategy", "cc-resilience-patterns", "cc-configuration-management", "cc-observability-integration"]
		rationale: "Cross-cutting concerns degradam silenciosamente — library desatualiza, standards driftam, configs ficam stale. Revisão periódica mantém o tecido conectivo do sistema saudável."
	},
]

reasoningProtocol: [
	{
		question:  "Cada cross-cutting concern está implementado consistentemente em todo BC? Ou cada BC faz de forma ad hoc?"
		reveals:   "Se sistema opera com qualidade uniforme — ou se BCs são ilhas com logging, security e error handling diferentes."
		rationale: "Kiczales 1997: cross-cutting concerns. Na Mesh, observabilidade inconsistente entre BCs = debugging cross-BC impossível."
	},
	{
		question:  "Existe shared library que fornece concerns como middleware? Ou cada BC reimplementa?"
		reveals:   "Se concerns são DRY (don't repeat yourself) — ou se 5 BCs têm 5 implementações de retry."
		rationale: "Thin platform thick standards 2023+. Library compartilhada elimina duplicação e garante consistência."
	},
	{
		question:  "Standards são categorizados como mandate/recommend/optional? CI enforces mandates?"
		reveals:   "Se padronização é calibrada — ou se tudo é mandatório (suffocating) ou nada é (inconsistente)."
		rationale: "Mandate vs recommend 2023+. Mandate o mínimo necessário; recommend o útil; leave rest optional."
	},
	{
		question:  "Error handling segue taxonomy unificada com RFC 9457? Messages ensinam como corrigir?"
		reveals:   "Se integradores e agentes podem tratar erros programaticamente — ou se cada BC retorna formato diferente."
		rationale: "RFC 9457 2023. Na Mesh, integrador que recebe 5 formatos de erro de 5 BCs: experiência impossível."
	},
	{
		question:  "Cada dependência externa tem config de resilience (retry, timeout, circuit breaker, fallback)?"
		reveals:   "Se sistema degrada gracefully quando dependência falha — ou se 1 API down trava tudo."
		rationale: "Nygard 2018: Release It. Dependência sem timeout = request que espera infinitamente."
	},
	{
		question:  "Secrets estão em vault? Feature flags são cleaned up? Config drift entre repo e produção?"
		reveals:   "Se configuração é gerenciada — ou se secrets estão em código, flags temporárias acumulam, e produção diverge do repo."
		rationale: "Secrets in code = breach. Stale flags = confusion. Config drift = mystery behavior."
	},
	{
		question:  "Traces propagam cross-BC? 1 trace_id mostra request completo de API gateway até dependência externa?"
		reveals:   "Se debugging cross-BC é possível em <1 minuto — ou se requer correlação manual de logs de múltiplos sistemas."
		rationale: "OpenTelemetry 2022+. Trace que quebra entre BCs = debugging impossível para o segmento sem trace."
	},
]

meshExamples: [
	{
		id:       "ex-middleware-stack-design"
		scenario: "Mesh precisa definir middleware stack para mesh-platform-lib que todo BC deve usar. Cada endpoint deve ter: auth, rate limiting, correlation ID, tracing, input validation, error formatting."
		analysis: "6 concerns em todo endpoint. Se cada BC implementa separadamente: 5 BCs × 6 concerns = 30 implementações, cada potencialmente diferente. Se middleware stack em library: 1 implementação, usado por 5 BCs. Ordem importa: auth deve ser primeiro (rejeitar request não-autenticada antes de processar qualquer coisa), error formatting deve ser último (catch everything)."
		recommendation: "Middleware stack (order matters): (1) correlation_id_middleware — extrai X-Correlation-ID do header ou gera UUID. Injeta em request context. Todos os logs e traces downstream usam. (2) trace_middleware — inicia span OpenTelemetry. Propaga trace context. (3) auth_middleware — verifica Bearer token. Extrai role (supplier, builder, fidc, admin). Se inválido: 401 imediatamente (não processa mais nada). (4) rate_limit_middleware — verifica rate limit por API key. Se excedido: 429 com Retry-After. (5) input_validation_middleware — valida request body contra schema (CUE/JSON Schema). Se inválido: 400 com detalhes RFC 9457 (quais campos, qual formato esperado). (6) [BC handler] — lógica de domínio. Não sabe que middleware existe. (7) error_format_middleware — catch exceptions do handler. Converte para RFC 9457. Domain exception (ScoreThresholdNotMet) → 422. Validation exception → 400. Unknown exception → 500 com request_id. Loga erro com correlation_id + trace_id. Uso pelo BC: app.use(mesh_middleware_stack()); app.post('/operations', handler). Handler é clean domain logic. Concerns são transparentes. CI enforcement: lint rule — 'todo endpoint registrado deve usar mesh_middleware_stack.' Se endpoint bypass middleware: build falha."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"6 middleware layers não adicionam latência significativa — benchmark (target: <5ms total)",
			"ordem proposta é correta — auth antes de validation pode rejeitar request mal-formatada antes de autenticar (trade-off: rejitar antes = menos compute, mas 401 é mais prioritário que 400)",
			"schema validation por middleware é viável para todas as requests — pode ser too strict para endpoints com body flexível",
			"CI lint pode detectar bypass de middleware — depende de framework e pattern de registro de routes",
		]
		rationale: "Middleware stack como shared infrastructure. Na Mesh, 1 implementação em mesh-platform-lib > 5 implementações por BC. Order: auth first (security), error format last (catch-all). BC handler é domain logic pura."
	},
	{
		id:       "ex-resilience-bureau-down"
		scenario: "Bureau de crédito (API externa) está retornando timeout para 80% das requests nos últimos 5 minutos. Scoring depende de bureau para feature score_externo. Operações de antecipação estão travando."
		analysis: "Sem resilience: cada request de scoring espera timeout do bureau (10s) → scoring leva 10s → decisão leva 10s → fornecedor espera 10s → experiência degradada. Se 100 requests acumulam: thread pool exhaust → todo o scoring fica down → todas as operações param. Com resilience: circuit breaker detecta 80% failure → abre circuito → requests nem tentam chamar bureau → fallback ativa."
		recommendation: "(1) Circuit breaker em ação: (a) threshold: 50% failure em 30s window → open. Bureau em 80% failure → circuit breaker abriu após 15s. (b) open state: requests para bureau são short-circuited (não tentam chamar). Response imediato: 'circuit open.' (c) fallback ativado: scoring usa score_externo cached do último cálculo (se <7 dias). Se cache expired: scoring sem feature score_externo (modelo degrada mas funciona — AUROC cai ~0.03 sem bureau). Se modelo sem bureau produz score >70: aprovar. Se 55-70: escalar para human (confidence reduzida sem bureau). Se <55: rejeitar. (2) Monitoring: alerta disparado: 'circuit breaker for bureau opened at [time]. Fallback: cached score.' Dashboard: circuit state (open), fallback usage (%), requests affected. (3) Recovery: circuit breaker em half-open após 60s. Tenta 3 requests para bureau. Se sucesso: close circuit → operação normal. Se falha: re-open → maintain fallback. (4) Communication: (a) para fornecedor: 'operação processada com análise parcial — resultado em <30s.' Não: 'bureau está down.' (b) para monitoramento interno: 'bureau down since [time]. Fallback active. X operations processed with cached score.' (5) Post-incident: when bureau recovers: verify cached scores → re-score operações que usaram cache se score mudou significativamente (>5 points). Se mudança de score altera decisão: review. (6) Root cause: bureau SLA <99.9%? Negotiate better SLA or add secondary bureau as redundancy."
		principlesApplied: ["ax-03", "ax-05", "dp-01"]
		assumptions: [
			"cached score de <7 dias é aceitável como fallback — pode ser stale se comprador deteriorou rapidamente",
			"modelo sem feature score_externo ainda é útil (AUROC −0.03) — verificar feature importance",
			"60s de recovery timeout é adequado — bureau pode levar mais para estabilizar",
			"re-scoring pós-recovery é operacionalmente viável — depende de volume",
		]
		rationale: "Nygard 2018: circuit breaker + fallback. Na Mesh, bureau down sem resilience = todas as operações param. Com circuit breaker + fallback (cached score + degraded model): 95% das operações continuam processando com latência normal, 5% escalam. Degradation graceful, não failure total."
	},
	{
		id:       "ex-config-drift-detection"
		scenario: "Agente de scoring usa score_threshold = 60 (config no mesh-spec). Mas em produção, variável de ambiente SCORE_THRESHOLD=55 foi setada há 2 meses por outro agente para 'teste' e nunca revertida. Operações com score 55-59 estão sendo aprovadas quando não deveriam."
		analysis: "Config drift: valor em produção (55) diverge de valor canônico no mesh-spec (60). Operações aprovadas com score 55-59 têm risco mais alto que threshold deveria permitir. Causa: agente fez mudança temporária via env var sem PR no mesh-spec. Env var override de config canônica sem registro = shadow config. Consequência: inadimplência pode subir (scores 55-59 têm PD maior), FIDC pode ser impactado, compliance gap (policy diz 60, produção aplica 55)."
		recommendation: "(1) Detecção imediata: implementar config drift check — CI/CD ou cron que compara config em produção (env vars, running config) com config canônica (mesh-spec). Se diverge: alerta imediato. 'SCORE_THRESHOLD in production (55) differs from mesh-spec (60). Last changed: 2 months ago. Changed by: agent-X.' (2) Correção: reverter SCORE_THRESHOLD para 60 em produção. Identificar operações aprovadas com score 55-59 nos últimos 2 meses. Quantificar: quantas operações? Qual volume? Qual inadimplência observada vs esperada? Se inadimplência é significativamente maior: provisionar expected loss adicional. Notificar FIDC se material. (3) Prevention: (a) config hierarchy: mesh-spec config (canônica) > env var override. Override por env var: apenas para emergência, com TTL (auto-revert em 24h se não confirmado via PR). (b) PR required para config change: toda mudança de threshold é PR no mesh-spec com ADR. Mudança sem PR: alerta + auto-revert. (c) CI check: deploy verifica que env vars de configuração não override mesh-spec values sem flag explícita (EMERGENCY_OVERRIDE=true com expiry). (4) ADR: 'Config drift detectado: SCORE_THRESHOLD=55 em produção vs 60 no mesh-spec. Causa: agente mudou env var para teste sem reverter. Impacto: [N] operações com score 55-59 aprovadas. Ação: revertido + drift check implementado. Policy: toda mudança de threshold via PR.'"
		principlesApplied: ["ax-05", "ax-06", "dp-01"]
		assumptions: [
			"drift check pode comparar env vars com mesh-spec automaticamente — requer tooling ou script",
			"operações com score 55-59 têm inadimplência significativamente maior — verificar com dados",
			"auto-revert de override em 24h é aceitável — pode ser too aggressive para emergências legítimas",
			"PR required para config change é enforceable com AI agents — CLAUDE.md deve mandatar",
		]
		rationale: "Configuration as code + drift detection. Na Mesh com AI agents como operators, config drift é risco real — agente muda config para teste e esquece de reverter. Drift check automático + PR required + auto-revert são as defesas que previnem shadow config."
	},
	{
		id:       "ex-observability-cross-bc-debug"
		scenario: "Fornecedor reporta: 'submeti operação há 5 minutos e status ainda é processing.' SLO de decisão: <30s. Algo está travado."
		analysis: "Request está stuck em algum BC do pipeline: validate_documents → calculate_score → decide_approval → initiate_settlement. Sem trace context propagation: debuggar requer buscar logs de 4 BCs por timestamp e correlation, cross-referencing manualmente. Com: 1 trace_id mostra exatamente onde request está stuck."
		recommendation: "(1) Debug com trace: buscar trace por operation_id ou correlation_id do fornecedor. Trace mostra: (a) validate_documents: completed in 2s ✓. (b) calculate_score: started at T+2s, still running at T+300s. Stuck. (c) decide_approval: not started (waiting for scoring). (d) initiate_settlement: not started. Diagnóstico: scoring está stuck. (2) Drill into scoring span: (a) scoring chamou feature store: completed in 500ms ✓. (b) scoring chamou bureau: started at T+2.5s, timeout at T+12.5s ✗. Retry 1 at T+13.5s, timeout at T+23.5s ✗. Retry 2 at T+28.5s, timeout at T+38.5s ✗. (c) scoring fallback: not triggered (bug — fallback deveria ativar após 3 retries). Diagnóstico: bureau em timeout, retry esgotou, mas fallback não ativou. Bug no fallback handler. (3) Fix: (a) imediato: manual override — marcar operação para re-processing com fallback forçado. Fornecedor recebe decisão em <5 minutos total. (b) bug fix: fallback handler tem bug (exception não-caught que impede fallback). Fix + test + deploy. (c) alerting: 'scoring duration >30s' deveria ter disparado alerta em T+30s. Verificar: alerta configurado? Se não: adicionar. (4) Tempo de debug: com trace: 5 minutos (buscar trace → identificar span stuck → drill into sub-spans → diagnóstico). Sem trace: 30-60 minutos (buscar logs de 4 BCs, correlacionar manualmente, testar hipóteses). (5) Communication para fornecedor: 'identificamos delay na análise — processando agora. Status atualizado em <5 minutos.' Não: silêncio por 5 minutos enquanto debugga."
		principlesApplied: ["ax-01", "ax-03", "dp-01"]
		assumptions: [
			"trace está disponível e completo — se tracing não propagou para scoring: diagnóstico parcial",
			"5 minutos para debug com trace é realista — depende de familiaridade com tooling",
			"manual override de operação é possível — requer API administrativa",
			"bug no fallback handler é causa isolada — pode ser sintoma de problema maior",
		]
		rationale: "OpenTelemetry cross-BC tracing. Na Mesh, operação stuck sem trace = 30min de debugging manual. Com trace: 5min para diagnóstico preciso. Investimento em observabilidade cross-BC se paga na primeira vez que request trava em produção."
	},
]

principleIds: ["ax-01", "ax-03", "ax-05", "ax-06", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI define observabilidade como disciplina (SLIs, SLOs, incident management). CC define como observabilidade é implementada consistentemente across BCs (middleware, naming convention, trace propagation). OOI é o what e why; CC é o how uniformly. OOI diz 'defina SLI de latência'; CC diz 'middleware mede latência identicamente em todo BC com naming mesh_{bc}_request_duration_ms'."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI define security policies (encryption, access control, threat modeling). CC implementa security uniformemente across BCs (auth middleware, input validation, rate limiting). STI é a policy; CC é o enforcement cross-BC via middleware."
	},
	{
		lensId:   "lens-distributed-systems-design"
		relation: "complementsWith"
		context:  "DSD define patterns de sistemas distribuídos (failure modes, context propagation, idempotency). CC implementa resilience patterns e context propagation como middleware shared across BCs. DSD é a teoria; CC é a implementação uniforme."
	},
	{
		lensId:   "lens-api-design-as-product"
		relation: "complementsWith"
		context:  "API define design de API (error format, pagination, versioning). CC garante que design é aplicado consistentemente em toda API de todo BC via middleware e CI enforcement. API é o design; CC é a consistência de aplicação."
	},
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA define event sourcing e event broker patterns. CC define como trace context e correlation ID são propagados em eventos (trace_id em todo event header). EDA é a arquitetura de eventos; CC é o cross-cutting que garante observabilidade e correlation nos eventos."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes (autonomy, escalation). CC governa como agentes implementam BCs (standards, middleware, config). AAG é governance de behavior; CC é governance de implementation. Agente que implementa BC sem middleware: CC enforcement (CI) detecta."
	},
	{
		lensId:   "lens-regulatory-compliance-as-architecture"
		relation: "complementsWith"
		context:  "RC define compliance como requisito (audit trail, LGPD logging). CC implementa compliance cross-BC (access logger middleware, event sourcing como audit trail, LGPD compliance checks). RC é o requisito; CC é a implementação uniforme."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM define knowledge as code e documentation standards. CC standards são knowledge as code no mesh-spec: mandated standards, error taxonomy, resilience configs, naming conventions. KM é o princípio; CC é a aplicação para cross-cutting infrastructure."
	},
]

limitations: [
	{
		description: "Shared library (mesh-platform-lib) cria coupling — todos os BCs dependem da mesma library. Bug na library afeta todos os BCs simultaneamente. Update de library requer coordenar todos os BCs."
		alternative: "Versionamento semver strict. BCs pinned a version. Update: 1 BC first (canary), then others. Rollback: revert to previous version. Bug na library é blast radius total — investir em testing proporcional (library é o código mais testado do sistema)."
		rationale: "Coupling via library é trade-off aceito — alternativa (cada BC implementa tudo) tem coupling zero mas inconsistência total. Library testada > 5 implementações ad hoc."
	},
	{
		description: "Mandated standards podem ser too restrictive para cenários que o designer não antecipou. BC com necessidade legítima de desvio: mandate impede."
		alternative: "Escape hatch documentado: BC pode request waiver de mandate com: rationale, impact assessment, alternative implementation, e approval. Waiver registrado como ADR. Se >3 waivers para mesmo mandate: mandate precisa de revisão."
		rationale: "Mandate sem escape hatch é dogma. Mandate com escape hatch documentado é standard com flexibilidade controlada."
	},
	{
		description: "CI enforcement assume que lint rules podem detectar violações. Nem toda violação é detectável por lint — retry config inadequado, fallback incompleto, error message não-educativa."
		alternative: "CI enforcement para o que é automatizável (format, naming, mandatory fields). Code review para o que requer julgamento (resilience config adequacy, error message quality). Combine: automated + human/agent review."
		rationale: "CI pega formatting. Review pega semântica. Ambos necessários."
	},
	{
		description: "Middleware stack com 6+ layers pode adicionar latência significativa — cada layer processa request, potencialmente com I/O (auth verifica token, rate limit consulta counter)."
		alternative: "Benchmark middleware stack. Target: <5ms total overhead. Se >10ms: optimize (cache auth tokens, in-memory rate limiting). Latência de middleware é custo fixo por request — acceptable se <5% of total request time."
		rationale: "6 middleware layers × 1ms each = 6ms overhead. Para request que leva 100ms: 6% overhead. Aceitável. Para request de 10ms: 60% overhead. Optimize."
	},
	{
		description: "Framework assume múltiplos BCs. Para Mesh pré-revenue com 1-2 BCs: overhead de cross-cutting framework pode ser excessive."
		alternative: "Proporcional ao estágio: 1-2 BCs — middleware stack simples em 1 shared module. 3-5 BCs — mesh-platform-lib formalized. 5+ BCs — full IDP. Não investir em platform engineering antes de ter plataforma."
		rationale: "Cross-cutting framework para 1 BC é over-engineering. Para 5 BCs é necessidade. Invest when needed."
	},
]

rationale: "Todo sistema com múltiplos bounded contexts precisa de cross-cutting concerns implementados consistentemente — sem isso, cada BC é ilha com observabilidade, security e error handling diferentes. Na Mesh AI-native com BCs operados por agentes, cross-cutting concerns são o tecido conectivo que garante qualidade uniforme. Esta lens operacionaliza: taxonomia de concerns transversais com observabilidade, segurança, resiliência, compliance, configuração e comunicação (Kiczales et al. 1997, IDP 2022+, platform engineering Gartner 2023+), patterns de implementação com middleware, shared library e thin platform (Kiczales 1997, thin platform thick standards 2023+), equilíbrio consistência vs autonomia com mandate/recommend/optional e golden path (Spotify golden path 2020+, mandate vs recommend 2023+, Netflix Paved Road 2021+), estratégia unificada de error handling com RFC 9457 e error taxonomy (RFC 9457 2023, error taxonomy 2022+, error messages that teach 2023+), patterns de resiliência com retry, circuit breaker e chaos testing (Nygard 2018, resilience4j 2019+, Chaos Engineering Netflix 2011+, Antithesis 2023+), gestão de configuração com feature flags, secrets e drift detection (configuration as code 2020+, feature flags 2022+, secrets management 2022+), e integração de observabilidade com OpenTelemetry e trace propagation cross-BC (OpenTelemetry 3 pillars 2022+, observability as shared concern 2023+). Universal, agnóstica a estágio, aplicável a qualquer sistema com múltiplos componentes que precisam de qualidade uniforme."

}
