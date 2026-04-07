package lenses

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

distributedSystemsDesign: artifact_schemas.#AnalyticalLens & {
id:     "lens-distributed-systems-design"
name:   "Design de Sistemas Distribuídos"

purpose: "Orientar decisões sobre como projetar sistemas distribuídos que são resilientes, consistentes e operáveis — particionamento, replicação, consenso e failure modes."
status: "draft"

verticalApplicability: shared_types.#VerticalApplicability & {
	mode: "vertical-agnostic"
	rationale: """
		Núcleo teórico (CAP/PACELC, sagas, idempotência,
		modos de falha, causalidade de eventos, replicação,
		consenso) é canonicamente independente de cadeia
		produtiva — aplica-se a qualquer sistema com execução
		distribuída e estado consistente. Os 12 reasoning steps
		são formulados de forma agnóstica (consistency models,
		saga coordination, idempotency keys, topologia, failure
		modes, ordering) e o vocabulário operacional dos
		conceitos (bounded context, saga, compensação,
		idempotency key, replicação, hybrid clock) é universal
		na disciplina de sistemas distribuídos.

		Construção aparece exclusivamente em meshExamples
		(antecipação de recebíveis, scoring de comprador,
		registro em registradora) — substituí-los por exemplos
		de manufatura, logística ou energia não exige mudança
		no núcleo nem nos conceitos. Vertical-agnostic.
		"""
}

trigger: {
	conditions: [
		"a decisão envolve como distribuir estado, computação ou responsabilidade entre múltiplos componentes do sistema",
		"a decisão envolve trade-offs entre consistência, disponibilidade e tolerância a partição",
		"a decisão envolve como garantir consistência de dados financeiros em sistema com múltiplos serviços",
		"a decisão envolve coordenação de transações que cruzam fronteiras de serviço ou bounded context",
		"a decisão envolve padrões de comunicação entre serviços (síncrono vs assíncrono, request/reply vs event)",
		"a decisão envolve como lidar com falhas parciais — quando parte do sistema falha mas o resto precisa continuar",
		"a decisão envolve replicação de dados, particionamento ou sharding para escala ou resiliência",
		"a decisão envolve idempotência, deduplicação ou exactly-once semantics em operações financeiras",
		"a decisão envolve escolher entre monolith, microservices, ou topologia intermediária",
		"a decisão envolve como escalar o sistema horizontalmente mantendo guarantees de corretude",
		"a decisão envolve ordenação de eventos, causalidade ou resolução de conflitos em sistema distribuído",
		"a decisão envolve como projetar para latência, throughput e backpressure entre componentes",
	]
	keywords: [
		"consistência", "consistency", "eventual consistency", "strong consistency",
		"CAP", "PACELC", "disponibilidade", "partição", "partition tolerance",
		"transação distribuída", "saga", "compensação", "two-phase commit",
		"microserviço", "monolith", "modular monolith", "service mesh",
		"idempotência", "exactly-once", "at-least-once", "deduplicação",
		"replicação", "sharding", "particionamento", "leader-follower",
		"event sourcing", "CQRS", "command", "query", "projeção",
		"falha parcial", "timeout", "retry", "circuit breaker", "backpressure",
		"ordenação", "causalidade", "vector clock", "lamport timestamp",
		"latência", "throughput", "escalabilidade", "horizontal scaling",
		"consensus", "raft", "paxos", "linearizability", "serializability",
		"bounded context", "integration pattern", "anti-corruption layer",
	]
	excludeWhen: [
		"a decisão é sobre observabilidade e monitoramento de sistemas em produção — usar observability-operational-intelligence",
		"a decisão é sobre segurança, criptografia ou controle de acesso — usar security-trust-infrastructure",
		"a decisão é sobre design de APIs como produto para integradores — usar api-design-as-product",
		"a decisão é sobre event sourcing e event-driven patterns especificamente — usar event-driven-architecture-patterns",
		"a decisão é sobre alocação de recursos entre atividades de engenharia — usar organizational-resource-allocation",
		"a decisão é sobre modelagem de dados para analytics — usar data-modeling-for-analytical-power",
	]
	rationale: "Toda plataforma financeira que cresce além de um único processo enfrenta as propriedades fundamentais de sistemas distribuídos: falhas parciais são inevitáveis, consistência tem custo, e coordenação entre componentes é o problema mais difícil de engenharia. Na Mesh como intermediário financeiro AI-native, o sistema é inerentemente distribuído: agentes IA como workers, integrações com bancos e registradoras como dependências externas, pipelines de scoring e compliance como serviços independentes, e operações financeiras que exigem guarantees de corretude (dinheiro não pode duplicar nem desaparecer). Sem framework de raciocínio sobre distribuição, decisões arquiteturais são tomadas por conveniência local que gera incoerência global — o serviço A assume consistência forte enquanto o serviço B assume eventual, e a interação entre os dois produz bugs impossíveis de diagnosticar."
}

concepts: [
	{
		id:         "dsd-cap-pacelc"
		name:       "CAP e PACELC: O Trade-off Fundamental que Não Pode Ser Evitado"
		nature:     "theoretical"
		role:       "framework"
		definition: "Brewer (2000, CAP Theorem, formalizado por Gilbert/Lynch 2002): num sistema distribuído, é impossível garantir simultaneamente Consistency (todo read retorna o write mais recente), Availability (toda request recebe resposta) e Partition tolerance (sistema opera mesmo com falha de rede entre nós). Quando partição ocorre, o sistema deve escolher: CP (consistente mas indisponível) ou AP (disponível mas inconsistente). Abadi (2012, PACELC): extensão do CAP — mesmo quando não há partição (caso normal), existe trade-off entre Latency e Consistency. PACELC: se Partition → AC choice; Else → LC choice. Kleppmann (2017, Designing Data-Intensive Applications): CAP é frequentemente mal-interpretado — não é escolha global binária, é escolha por operação. Diferentes operações no mesmo sistema podem ter guarantees diferentes. Hellerstein/Alvaro (2020, 'Keeping CALM: When Distributed Consistency is Easy'): CALM theorem — programas monotônicos (que só acrescentam informação, nunca retraem) podem ser consistentes sem coordenação. Quando possível, projetar para monotonia elimina o trade-off."
		meshManifestation: "Na Mesh, diferentes operações têm necessidades radicalmente diferentes: (1) saldo da conta de liquidação — requer strong consistency (CP). Duas operações lendo saldo simultaneamente devem ver o mesmo valor. Inconsistência = risco de double-spend (antecipação aprovada duas vezes contra o mesmo saldo). Trade-off aceito: maior latência em reads de saldo. (2) status de compliance de fornecedor — eventual consistency é aceitável (AP). Se fornecedor atualizou CND há 5 segundos mas dashboard mostra status anterior: impacto zero. Trade-off aceito: stale read por segundos. (3) scoring — entre os dois. Score de comprador calculado com dados de 5 minutos atrás: aceitável. Score calculado com dados de 3 meses atrás: inaceitável (km-knowledge-decay-refresh). (4) registro em registradora — requer consistency no sentido de at-least-once delivery com idempotência: operação registrada exatamente uma vez, mesmo que request seja reenviada. Inconsistência = operação não-registrada (regulatório) ou registrada em duplicata (contábil)."
		meshImplication: "Para cada operação/fluxo: declarar explicitamente a guarantee necessária — strong consistency, eventual consistency, ou causal consistency. Não assumir que 'o banco de dados resolve'. Guia de decisão: (1) envolve dinheiro em trânsito (saldo, liquidação, transferência)? → strong consistency. Custo: latência e coordenação. (2) envolve estado informacional consultivo (score, status, dashboard)? → eventual consistency com SLA de convergência (ex: <5s). Custo: stale reads temporários. (3) envolve operação com efeito externo irreversível (registro em registradora, transferência bancária)? → at-least-once delivery com idempotência, não exactly-once (que não existe em sistemas distribuídos — ver dsd-idempotency). (4) CALM: sempre que possível, projetar operações como monotônicas (append-only, CRDTs) para eliminar necessidade de coordenação. Event log append-only é monotônico por design. Documentar: para cada bounded context, qual consistency model é adotado e por quê. Se dois BCs com consistency models diferentes interagem: a interface entre eles é onde bugs de consistency surgem — projetar com cuidado (anti-corruption layer)."
		rationale: "Brewer/Gilbert-Lynch 2000/2002: CAP theorem. Abadi 2012: PACELC — trade-off existe mesmo sem partição. Kleppmann 2017: escolha por operação, não global. Hellerstein/Alvaro 2020: CALM elimina trade-off para operações monotônicas. Na Mesh como intermediário financeiro, a escolha errada de consistency model para operações financeiras é bug que manifesta como dinheiro duplicado ou desaparecido — catastrófico."
	},
	{
		id:         "dsd-saga-coordination"
		name:       "Sagas e Coordenação Distribuída: Transações que Cruzam Fronteiras"
		nature:     "theoretical"
		role:       "method"
		definition: "Garcia-Molina/Salem (1987, 'Sagas'): saga é sequência de transações locais onde cada transação atualiza um serviço e publica evento/mensagem que dispara a próxima transação. Se uma transação falha: compensating transactions são executadas para desfazer efeito das transações anteriores. Alternativa a two-phase commit (2PC) que bloqueia recursos e escala mal. Richardson (2018, Microservices Patterns): dois estilos de saga — choreography (cada serviço reage a eventos sem coordenador central) e orchestration (coordenador central orquestra a sequência). Choreography: mais desacoplado, mais difícil de entender fluxo completo. Orchestration: fluxo visível, coordenador é single point of complexity. Kleppmann (2017): 2PC é blocking protocol — se coordenador falha durante prepare, participantes ficam travados. Sagas são non-blocking mas requerem compensação. Conceito contemporâneo de 'workflow engines as saga orchestrators' (Temporal 2020+, AWS Step Functions, Conductor): plataformas que codificam sagas como workflows durável com retry, compensation e observability built-in — eliminam a necessidade de implementar saga framework custom."
		meshManifestation: "Na Mesh, a operação de antecipação é saga natural que cruza múltiplos serviços: (1) fornecedor solicita antecipação → (2) agente valida documentação → (3) agente calcula score do comprador → (4) decisão (aprovação/rejeição) → (5) se aprovado: liquidação via banco → (6) registro em registradora → (7) notificação ao fornecedor. Cada step é transação local num bounded context diferente. Se step 6 falha (registradora indisponível): compensar steps 5 (reverter liquidação? ou manter e retry step 6?). Decisão de compensação não é trivial: reverter liquidação é custoso (dinheiro já na conta do fornecedor); retry de registro é preferível se registradora volta em horas. Se step 5 falha (banco rejeita): compensar step 4 (notificar rejeição ao fornecedor, atualizar status). Cada failure mode tem compensação diferente. Sem saga explícita: sistema fica em estado inconsistente (aprovado mas não liquidado, liquidado mas não registrado) e ninguém sabe."
		meshImplication: "Para cada fluxo que cruza >1 bounded context: modelar como saga explícita com: (1) sequência de steps ordenada. (2) para cada step: transação local + evento de sucesso + condição de falha. (3) para cada falha: compensating action ou retry strategy — não ambos. (4) timeout: máximo de espera por step antes de declarar falha. (5) observabilidade: saga ID que conecta todos os steps (correlation ID de OOI). Escolha de estilo: para antecipação (fluxo principal, precisa de visibilidade end-to-end, compensação complexa): orchestration com workflow engine (Temporal ou equivalente). Para fluxos secundários (notificações, atualização de dashboard, recálculo de métricas): choreography via eventos. Regra para compensação financeira: nunca compensar automaticamente operação que moveu dinheiro sem humano no loop. Se liquidação foi feita e registro falha: retry com circuit breaker. Se retry exaure: escalar para humano — não reverter liquidação automaticamente. Documentar: saga diagram para cada fluxo multi-BC com todos os failure modes e compensações. Se um failure mode não tem compensação definida: é gap que deve ser resolvido antes de produção."
		dependsOn: ["dsd-cap-pacelc"]
		crossDependsOn: [
			{
				lensId:    "lens-observability-operational-intelligence"
				conceptId: "ooi-graceful-degradation"
				context:   "OOI define degradação graciosa quando componentes falham. DSD define compensação de saga quando steps falham. Complementares: OOI diz 'sistema perde funcionalidade secundária, não integridade'; DSD diz 'quando step de saga falha, compensar ou retry conforme regra, não travar'. Circuit breaker de OOI é mecanismo que DSD usa para decidir entre retry e compensar."
			},
			{
				lensId:    "lens-ai-agent-governance"
				conceptId: "aag-escalation-protocol"
				context:   "AAG define quando agente escala ao humano. DSD define quando falha de saga escala ao humano — particularmente para compensação financeira. Se saga de antecipação está em estado inconsistente e compensação automática não é segura: escalar conforme AAG. DSD define o 'quando'; AAG define o 'como'."
			},
		]
		rationale: "Garcia-Molina/Salem 1987: sagas como alternativa a 2PC. Richardson 2018: choreography vs orchestration. Temporal 2020+: workflow engines. Na Mesh, antecipação é saga que move dinheiro — estado inconsistente é risco financeiro e regulatório. Saga explícita com compensação definida é a única forma de garantir que falha parcial não gera corrupção."
	},
	{
		id:         "dsd-idempotency"
		name:       "Idempotência e Exactly-Once Semantics: A Ilusão e a Solução Prática"
		nature:     "theoretical"
		role:       "property"
		definition: "Helland (2012, 'Idempotence Is Not a Medical Condition'): em sistemas distribuídos, messages podem ser duplicadas (rede reenvia, producer retries). Idempotência garante que processar a mesma message N vezes produz o mesmo resultado que processar 1 vez. Kleppmann (2017): exactly-once delivery não existe em rede unreliable — o que existe é at-least-once delivery com idempotent processing, que do ponto de vista do cliente é indistinguível de exactly-once. Mecanismo: idempotency key — cada operação carrega ID único. Receptor verifica se já processou aquele ID; se sim, retorna resultado anterior sem reprocessar. Gray (1981): distributed systems fail in partial, ambiguous ways — timeout não significa que request falhou (pode ter sido processada mas resposta se perdeu). Retry sem idempotência = operação duplicada. Conceito contemporâneo de 'deterministic simulation testing' (FoundationDB 2013+, TigerBeetle 2023+): testar sistemas distribuídos simulando toda combinação de falha de rede, reordenação e duplicação para verificar que idempotência funciona em todos os cenários — não apenas no happy path."
		meshManifestation: "Na Mesh, operações onde idempotência é crítica: (1) liquidação — transferência bancária de R$100k para fornecedor. Se request foi enviada ao banco e timeout ocorre: request foi processada? Se sim e reenviar: R$200k transferidos (dinheiro duplicado). Idempotency key: cada liquidação tem ID único; banco parceiro deve ignorar request com ID já processado. Se banco não suporta idempotency key nativa: implementar na camada da Mesh (verificar se liquidação com aquele ID já foi confirmada antes de reenviar). (2) registro em registradora — mesmo padrão. (3) scoring — menos crítico (idempotente por natureza: mesmo input → mesmo output), mas se scoring trigger side effect (atualizar status de fornecedor): idempotência do side effect importa. (4) notificação — idempotência de delivery: fornecedor receber 2 emails de 'antecipação aprovada' é incômodo mas não catastrófico. Fornecedor receber 2 créditos na conta é catastrófico."
		meshImplication: "Para toda operação com side effect externo (transferência, registro, atualização de estado): (1) atribuir idempotency key no momento da criação da operação — não no momento do envio. Formato: UUID v4 ou hash determinístico de (operação_id + step_id + versão). (2) persistir resultado antes de retornar — se processou com sucesso, gravar resultado com key. Em retry: retornar resultado gravado. (3) para integrações externas: verificar se parceiro suporta idempotency key. Se sim: usar. Se não: implementar checking layer (query status antes de reenviar). (4) testar: simular cenários de retry (timeout + reenvio) e verificar que operação não duplica. Para operações financeiras: teste obrigatório antes de produção. (5) distinguir: retry-safe (idempotent) vs retry-unsafe. Documentar no schema de cada operação. Se operação é retry-unsafe: não implementar retry automático — escalar para humano em caso de ambiguidade. Regra absoluta: operação que move dinheiro é idempotent ou não existe. Não há 'implementamos depois'."
		dependsOn: ["dsd-cap-pacelc"]
		crossDependsOn: [{
			lensId:    "lens-security-trust-infrastructure"
			conceptId: "sti-cryptographic-foundations"
			context:   "STI define assinatura digital para não-repúdio de operações. DSD define idempotency key para deduplicação. Complementares: assinatura prova que a operação é autêntica; idempotency key garante que a operação é processada exatamente uma vez. Para liquidação: assinada (STI) + idempotente (DSD) + registrada (audit trail de AAG)."
		}]
		rationale: "Helland 2012: idempotência é requisito, não opção. Kleppmann 2017: exactly-once é at-least-once + idempotência. Gray 1981: falhas parciais são ambíguas. TigerBeetle 2023+: simulation testing para financial systems. Na Mesh, duplicação de operação financeira é perda direta de dinheiro — idempotência é o controle que previne."
	},
	{
		id:         "dsd-topology-choice"
		name:       "Topologia de Serviços: Monolith, Microservices, e o Espectro Entre Eles"
		nature:     "theoretical"
		role:       "framework"
		definition: "Newman (2021, Building Microservices 2nd ed.): microservices são serviços independentemente deployáveis organizados em torno de business domains. Benefícios: deploy independente, scaling independente, autonomia de equipe. Custos: complexidade operacional, distributed transactions, observability harder. Richardson (2023, 'Monolith First'): começar com monolith e extrair serviços quando necessário — premature decomposition é mais caro que premature monolith. Conceito de 'modular monolith' (Khononov 2024, Learning Domain-Driven Design): monolith com fronteiras internas claras (módulos por bounded context) mas deploy único. Benefícios de monolith (simplicidade operacional) com benefícios de microservices (modularidade). Skelton/Pais (2019, Team Topologies): a topologia de serviços deve refletir a topologia de equipes (Conway's Law inverso) — equipe única → monolith ou modular monolith. Múltiplas equipes → microservices com ownership claro. Conceito contemporâneo de 'nanoservices anti-pattern' (2020+): decomposição excessiva gera overhead de comunicação, latência, e complexidade de deploy que supera benefícios — cada serviço deve encapsular domain logic suficiente para justificar existência independente."
		meshManifestation: "Na Mesh solo founder + agentes IA: equipe = 1 humano. Conway's Law: topologia deve ser gerenciável por 1 pessoa com agentes. Microservices com 15 serviços independentes para solo founder = overhead operacional que consome todo o constraint. Modular monolith: módulos por bounded context (ECL, NGR, Scoring, Compliance) com fronteiras claras (contratos de interface) mas deploy único. Benefícios: (1) complexidade operacional mínima (1 deploy, 1 database, 1 processo). (2) refactoring fácil (move code entre módulos, não entre serviços). (3) consistência local (transações ACID dentro do monolith). Custo: scaling é por aplicação inteira, não por módulo. Quando extrair: quando um módulo tem requirements de scaling ou deploy radicalmente diferentes dos demais — ex: scoring precisa de GPU e scale diferente de compliance. Na Mesh pré-revenue: essa necessidade não existe ainda."
		meshImplication: "Decisão de topologia baseada em estágio e team size: (1) solo founder / equipe <5: modular monolith. Bounded contexts como módulos com contratos de interface explícitos (CUE schemas para interfaces internas). Comunicação síncrona in-process. Database compartilhado com schema separation por módulo. (2) equipe 5-15: avaliar extração de módulos que divergem em scaling/deploy requirements. Extrair como serviço apenas quando: (a) deploy frequency é 3x+ diferente dos demais, OU (b) scaling requirement é 5x+ diferente, OU (c) failure isolation é crítica (falha de scoring não pode derrubar liquidação). (3) equipe >15: microservices com ownership claro por team. Anti-patterns: (a) nanoservices — serviço com <500 LOC que só faz proxy. (b) distributed monolith — microservices que não podem ser deployados independentemente (shared database, shared libraries com breaking changes). (c) premature decomposition — extrair microservice antes de entender o domínio (fronteiras erradas são 10x mais caras de corrigir em microservices que em monolith). Regra: projetar para modularidade (contratos internos, separation of concerns), deployar como monolith até que evidência justifique extração. O custo de extrair módulo bem-definido é linear; o custo de juntar microservices mal-decompostos é exponencial."
		dependsOn: ["dsd-cap-pacelc"]
		crossDependsOn: [{
			lensId:    "lens-organizational-resource-allocation"
			conceptId: "ora-throughput-constraint"
			context:   "ORA identifica que horas do founder são o constraint. DSD escolhe topologia que minimiza overhead operacional dado o constraint. Microservices para solo founder = constraint consumido por ops em vez de produto. Modular monolith = ops mínimo, constraint disponível para produto. Quando equipe cresce e constraint muda: topologia pode evoluir."
		}]
		rationale: "Newman 2021: microservices com trade-offs reais. Richardson 2023: monolith first. Khononov 2024: modular monolith. Skelton/Pais 2019: Conway's Law. Na Mesh solo founder, modular monolith é a topologia que maximiza output dado o constraint — e projetar para modularidade preserva a opção de extrair quando necessidade real surgir (conecta com RO)."
	},
	{
		id:         "dsd-consistency-at-boundary"
		name:       "Consistência na Fronteira: O Ponto Mais Perigoso do Sistema"
		nature:     "theoretical"
		role:       "property"
		definition: "Kleppmann (2017): os bugs mais difíceis em sistemas distribuídos ocorrem na fronteira entre componentes com consistency models diferentes. Componente A assume strong consistency; componente B assume eventual. A interação entre A e B pode produzir anomalias que nenhum dos dois detecta isoladamente. Evans (2003, Domain-Driven Design): Anti-Corruption Layer (ACL) — camada explícita na fronteira entre bounded contexts que traduz modelos e protege cada contexto da complexidade do outro. Vernon (2013, Implementing Domain-Driven Design): context mapping patterns — published language, open host service, conformist, anti-corruption layer. Cada pattern tem trade-off de coupling vs autonomia. Conceito contemporâneo de 'schema registry and contract evolution' (Confluent 2019+, Buf 2022+): contratos de interface versionados e validados por registry — breaking change é detectada antes de deploy, não em produção. Compatibilidade backward e forward como constraints de evolução."
		meshManifestation: "Na Mesh, fronteiras críticas: (1) ECL (strong consistency para saldo) ↔ Scoring (eventual consistency para features) — se scoring lê saldo desatualizado e aprova antecipação com base em saldo que já foi consumido: over-commitment. ACL entre ECL e Scoring deve garantir que leitura de saldo para decisão financeira é strongly consistent mesmo que o rest do scoring seja eventual. (2) Mesh ↔ Banco parceiro — Mesh e banco têm modelos de dados diferentes, consistency models diferentes, e failure modes diferentes. ACL: adapter que traduz modelo da Mesh para API do banco, com retry, idempotência, e reconciliação. (3) Mesh ↔ Registradora — mesmo padrão. (4) agente IA ↔ domínio — agente opera com representação simplificada do estado do sistema (o que está no context window). Se representação diverge do estado real (stale context): agente toma decisão com base em informação inconsistente. ACL implícita: o CLAUDE.md + mesh-spec são a camada que traduz o domínio para o agente — se a tradução é incorreta ou desatualizada, o agente está operando com 'informação inconsistente'."
		meshImplication: "Para cada fronteira entre bounded contexts ou integrações externas: (1) declarar consistency model de cada lado. (2) identificar anomalias possíveis na interação (stale read, duplicate write, lost update, phantom). (3) implementar ACL ou integration pattern que previne anomalias específicas. (4) para fronteiras com integrações externas: adapter layer que isola domínio do formato externo + contrato versionado (conecta com ooi-integration-contract-testing). (5) para fronteira agente ↔ domínio: garantir que dados críticos para decisão são fresh (km-knowledge-decay-refresh para premissas, ooi-data-quality-operational-risk para dados operacionais). (6) schema evolution: toda interface entre BCs tem schema versionado em CUE. Mudança de schema deve ser backward-compatible (consumidor antigo consegue ler formato novo). Se breaking change é necessária: migração coordenada com versioning (v1/v2 coexistem durante transição). Anti-pattern: 'shared database' como integração entre BCs — acopla modelos internos e torna toda mudança de schema uma breaking change global."
		dependsOn: ["dsd-cap-pacelc", "dsd-saga-coordination"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-integration-contract-testing"
			context:   "OOI define contract testing para integrações externas — verificar que API de terceiro cumpre contrato. DSD define contracts para fronteiras internas entre BCs e para a fronteira agente ↔ domínio. Ambos usam a mesma mecânica (schema versionado + validação) para boundaries diferentes. DSD define o contrato; OOI verifica continuamente."
		}]
		rationale: "Kleppmann 2017: fronteira é onde bugs de consistency surgem. Evans 2003: Anti-Corruption Layer. Vernon 2013: context mapping. Confluent/Buf 2019+/2022+: schema registry. Na Mesh, a fronteira ECL ↔ Scoring com consistency models diferentes é o ponto mais perigoso — ACL com consistency guarantee explícita é a defesa."
	},
	{
		id:         "dsd-failure-modes"
		name:       "Modos de Falha em Sistemas Distribuídos: O Que Pode Dar Errado, Vai Dar Errado"
		nature:     "theoretical"
		role:       "framework"
		definition: "Deutsch (1994, 'The Eight Fallacies of Distributed Computing'): 8 premissas falsas — rede é confiável, latência é zero, bandwidth é infinita, rede é segura, topologia não muda, há um administrador, custo de transporte é zero, rede é homogênea. Cada premissa falsa que o desenvolvedor assume gera modo de falha em produção. Bailis/Kingsbury (2014, 'The Network is Reliable'): catálogo de 12 failure modes reais — process pause, network partition, clock skew, message loss, message duplication, message reordering, partial failure. Gray/Reuter (1993): Heisenbugs — bugs que desaparecem quando se tenta observá-los, comuns em sistemas distribuídos porque dependem de timing e concorrência. Conceito contemporâneo de 'formal verification of distributed systems' (Hillel Wayne 2022, Practical TLA+; Amazon/Newcombe et al. 2015, 'How Amazon Web Services Uses Formal Methods'): usar TLA+, Alloy, ou model checking para verificar formalmente que protocolos distribuídos estão corretos antes de implementar — não depender apenas de testes. Amazon usa TLA+ para verificar protocolos de DynamoDB, S3 e outros sistemas críticos."
		meshManifestation: "Na Mesh, failure modes mais prováveis e impactantes: (1) network partition entre Mesh e banco parceiro — liquidação travada, fornecedor esperando. Mitigation: retry com backoff + fila persistente + notificação proativa (OOI graceful degradation). (2) process pause — agente de scoring demora 30s em vez de 5s porque LLM provider está lento. Downstream (liquidação) assume timeout e cancela? Ou espera? Mitigation: timeout + retry com idempotência. (3) clock skew — timestamps de eventos em serviços diferentes divergem. Se ordenação de eventos depende de timestamp: eventos podem parecer fora de ordem. Mitigation: usar ordering garantido pelo broker (Kafka offset) em vez de wall-clock time. (4) message duplication — banco confirma liquidação mas ack se perde; Mesh reenvia; banco processa novamente. Mitigation: idempotency key (dsd-idempotency). (5) partial failure — scoring responde mas compliance não. Saga precisa decidir: esperar, retry, ou compensar? Cada failure mode tem probabilidade e impacto diferentes — modelar no threat model de OOI."
		meshImplication: "Para cada integração e comunicação entre componentes: (1) assumir que todas as 8 fallacies são reais — projetar com defesa. (2) para cada operação: definir behavior em caso de timeout — retry? compensar? escalar? Nunca: assumir que timeout = falha (pode ter sido processado). (3) timeouts: definir para cada integração — banco parceiro (30s?), registradora (10s?), LLM provider (60s?). Timeout muito curto: false failure. Timeout muito longo: recurso bloqueado. (4) retry policy por integração: exponential backoff com jitter, máximo de retries, circuito breaker após N falhas. (5) ordering: se ordenação de eventos importa (operações financeiras): usar sequence numbers ou offsets do broker, não timestamps. (6) para operações financeiras: formal verification (TLA+ ou equivalente) dos protocolos de saga antes de produção — para um intermediário financeiro, 'provavelmente funciona' não é aceitável. No mínimo: property-based testing (Hypothesis, jqwik) que gera cenários de falha aleatórios e verifica invariantes (saldo nunca negativo, operação nunca duplicada, estado da saga é sempre válido)."
		dependsOn: ["dsd-cap-pacelc", "dsd-idempotency"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-chaos-engineering"
			context:   "OOI define chaos engineering para descobrir fraquezas. DSD define os failure modes que chaos engineering deve testar — cada modo de falha do catálogo (network partition, process pause, message loss, clock skew) é cenário de chaos experiment. DSD diz 'estes são os modos de falha possíveis'; OOI diz 'como injetar e observar cada um'."
		}]
		rationale: "Deutsch 1994: 8 fallacies. Bailis/Kingsbury 2014: network is unreliable, catálogo de failure modes. Amazon/Newcombe 2015: formal verification em produção. Na Mesh como intermediário financeiro, cada fallacy assumida como verdadeira gera modo de falha que manifesta como perda financeira, estado inconsistente, ou operação não-registrada."
	},
	{
		id:         "dsd-event-ordering-causality"
		name:       "Ordenação de Eventos e Causalidade: Quem Aconteceu Primeiro Importa"
		nature:     "theoretical"
		role:       "property"
		definition: "Lamport (1978, 'Time, Clocks, and the Ordering of Events in a Distributed System'): em sistemas distribuídos, não existe relógio global — a noção de 'o que aconteceu primeiro' é definida por relação causal (happened-before), não por timestamp. Lamport timestamps e vector clocks capturam causalidade parcial. Kleppmann (2017): three types of ordering — total order (todos concordam com a sequência), partial order (apenas causalmente relacionados são ordenados), e no ordering (eventos concorrentes). Evento A causou B: A deve vir antes de B. Eventos A e C são independentes: qualquer ordem é válida. Shapiro et al. (2011, 'A comprehensive study of CRDTs'): Conflict-Free Replicated Data Types — estruturas de dados que convergem sem coordenação porque merges são comutativas, associativas e idempotentes. Conceito contemporâneo de 'hybrid logical clocks' (Kulkarni et al. 2014): combina physical clock com logical clock para oferecer ordering com propriedades de ambos — causality capture + bounded clock skew."
		meshManifestation: "Na Mesh, ordering importa em: (1) operações financeiras — antecipação aprovada ANTES de liquidação ANTES de registro. Se eventos chegam fora de ordem: sistema registra operação que não foi liquidada, ou liquida operação que não foi aprovada. Causalidade: aprovação happened-before liquidação happened-before registro. (2) scoring — features de scoring devem refletir estado ANTES da decisão, não depois. Se faturamento é atualizado durante cálculo de score: qual valor o score usou? Snapshot consistency: score calculado com snapshot consistente de todos os inputs no mesmo ponto no tempo. (3) event log — se Mesh usa event sourcing: a ordem dos eventos no log é a source of truth. Eventos reordenados = state corruption. Se eventos vêm de múltiplos producers: ordering cross-producer requer mecanismo (partição por entity, sequencing)."
		meshImplication: "Para operações com dependência causal: (1) capturar causalidade explicitamente — evento de liquidação carrega referência ao evento de aprovação (happened-before link). Consumidor verifica: aprovação existe antes de processar liquidação. (2) ordering dentro de entity: particionar event log por entity (ex: partition key = comprador_id). Eventos do mesmo comprador são totalmente ordenados dentro da partição. Eventos de compradores diferentes não precisam de ordering global. (3) snapshot consistency para scoring: ler todos os inputs do score numa transação read-only com snapshot isolation — garantir que score é calculado com estado consistente, não com mix de dados de momentos diferentes. (4) CRDTs para estado que pode ser atualizado concorrentemente sem conflito — ex: contador de operações por fornecedor (G-Counter), status flags (LWW-Register com timestamp). Não usar CRDTs para estado que requer coordenação (saldo financeiro). (5) event log como source of truth: se event sourcing, eventos são append-only e imutáveis. Correção: novo evento compensatório, não edição de evento anterior. Isso é monotônico (CALM theorem) e simplifica replication."
		dependsOn: ["dsd-cap-pacelc", "dsd-failure-modes"]
		rationale: "Lamport 1978: causalidade, não timestamp. Shapiro et al. 2011: CRDTs para convergência sem coordenação. Kulkarni et al. 2014: hybrid logical clocks. Na Mesh com operações financeiras causalmente dependentes (aprovação → liquidação → registro), a ordenação correta é invariante do sistema — violação é corrupção de estado."
	},
	{
		id:         "dsd-scalability-patterns"
		name:       "Patterns de Escalabilidade: Como Crescer Sem Quebrar Invariantes"
		nature:     "theoretical"
		role:       "method"
		definition: "Abbott/Fisher (2015, The Art of Scalability — Scale Cube): 3 eixos de scaling — X (clonagem: múltiplas instâncias idênticas), Y (decomposição funcional: cada função como serviço), Z (particionamento de dados: sharding por customer/tenant). Cada eixo resolve problema diferente e tem custo diferente. Kleppmann (2017): partitioning (sharding) distribui dados entre nós para scaling de storage e throughput. Estratégias: range-based (fácil range queries, hotspot risk), hash-based (distribuição uniforme, range queries impossíveis), compound (hash + range). Rebalancing quando nós são adicionados/removidos. Conceito contemporâneo de 'cell-based architecture' (AWS 2023, Amazon Builder's Library): isolar grupos de tenants em 'cells' independentes. Falha de uma cell não afeta outras. Escala adicionando cells, não escalando componente único. Para intermediários financeiros: cell por cohort de clientes limita blast radius de falha e simplifica compliance (dados de clientes em cell específica para requisitos de data residency)."
		meshManifestation: "Na Mesh, escalabilidade tem necessidades diferentes por dimensão: (1) throughput de operações — pré-revenue: 100/mês. Escala: 10.000/mês. 100.000/mês. Cada 10x requer revisão de bottleneck. (2) storage de dados — event log cresce indefinidamente (append-only). Features de scoring acumulam com volume de operações. (3) compute de agentes — cada operação consome tokens de LLM. Scaling de compute é linear com volume (sem economia de escala para LLM inference). (4) integrações — banco parceiro tem rate limit. Registradora tem throughput máximo. Scaling da Mesh é limitado pelo scaling das dependências. Cell-based: no futuro, isolar construtoras grandes em cells dedicadas — falha na cell da construtora A não afeta construtora B. Dados segregados por cell simplificam compliance de sigilo bancário."
		meshImplication: "Scaling strategy por estágio: (1) pré-revenue (<1.000 ops/mês): monolith único, database único, sem sharding, sem replication. Simples. (2) tração (1.000-10.000 ops/mês): read replicas para queries analíticas (não competir com operações transacionais). Caching para dados consultivos (scores, status). Avaliar se banco parceiro suporta volume. (3) escala (10.000-100.000 ops/mês): sharding por construtora ou por região. Event log particionado. Cell architecture para tenants grandes. Multiple agent instances para scoring paralelo. (4) para cada estágio: identificar o bottleneck ANTES de atingí-lo (conecta com ooi-capacity-planning). Lead time de mudança arquitetural é meses — não semanas. Regra: projetar para modularidade no stage atual, não implementar scaling prematuramente. Modular monolith com interfaces limpas é extraível para microservices quando necessário. Database com schema separation por BC é particionável quando necessário. O custo de projetar para modularidade é marginal; o custo de re-arquitetar monolith sem modularidade é massivo."
		dependsOn: ["dsd-topology-choice", "dsd-cap-pacelc"]
		crossDependsOn: [{
			lensId:    "lens-observability-operational-intelligence"
			conceptId: "ooi-capacity-planning"
			context:   "OOI projeta quando o constraint de capacidade vai mudar. DSD provê os patterns de scaling que são ativados quando capacidade precisa crescer. OOI diz 'com volume projetado, banco parceiro vira bottleneck em 6 meses'; DSD diz 'para resolver: rate limiting com queue, ou segundo banco parceiro, ou cell-based isolation'."
		}]
		rationale: "Abbott/Fisher 2015: Scale Cube. Kleppmann 2017: partitioning strategies. AWS 2023: cell-based architecture. Na Mesh, scaling não é sobre performance — é sobre crescer sem quebrar invariantes financeiras (idempotência, consistência de saldo, ordering de eventos). Cada salto de 10x requer revisão arquitetural."
	},
	{
		id:         "dsd-data-replication"
		name:       "Replicação de Dados: Cópias para Resiliência, Latência e Escala"
		nature:     "theoretical"
		role:       "property"
		definition: "Kleppmann (2017): replicação serve três propósitos — high availability (se nó falha, réplica assume), latency reduction (réplica perto do consumidor), e read scaling (distribuir reads entre réplicas). Três modelos: (1) single-leader — um nó aceita writes, réplicas recebem stream. Consistente mas leader é SPOF. (2) multi-leader — múltiplos nós aceitam writes. Melhor availability, mas conflitos de write. (3) leaderless — qualquer nó aceita reads e writes. Maximum availability, eventual consistency, conflict resolution via quorum ou CRDTs. Ongaro/Ousterhout (2014, Raft): consensus algorithm para leader election e log replication — mais compreensível que Paxos. Usado em etcd, CockroachDB, TiKV. Conceito contemporâneo de 'global tables' (DynamoDB Global Tables, CockroachDB Multi-Region, Spanner): replicação multi-região com consistency tunable — para sistemas financeiros globais. TigerBeetle (2023): database projetado especificamente para financial transactions com strict serializability e deterministic replication."
		meshManifestation: "Na Mesh: (1) dados financeiros (saldo, operações) — single-leader com synchronous replication para standby. Consistency é prioridade absoluta. Se leader falha: failover automático para standby com zero data loss (RPO ≈ 0). PostgreSQL com streaming replication synchronous. (2) dados analíticos (scores históricos, métricas, dashboards) — asynchronous replication para read replica. Stale reads aceitáveis (segundos). Scaling de queries analíticas sem impactar operações transacionais. (3) event log — se Kafka: replicação por partition com replication factor ≥ 3. Leader per partition, ISR (In-Sync Replicas) para durability. Configuração de acks=all para operações financeiras (write confirmado apenas quando todas as ISR gravaram). (4) futuro multi-região: se Mesh expandir para múltiplas regiões, cell-based com replication intra-cell e eventual consistency entre cells para dados não-financeiros."
		meshImplication: "Replication strategy por tipo de dado: (1) dados financeiros transacionais: synchronous replication. acks=all. RPO = 0. Custo: latência de write (~2-5ms extra). Benefício: zero data loss garantido. (2) dados analíticos: asynchronous replication. Replication lag aceitável: <5s para dashboards, <1min para reports. Custo: stale reads. Benefício: read scaling + isolamento de workload. (3) event log: replication factor = 3 mínimo para dados financeiros. min.insync.replicas = 2 para tolerar falha de 1 broker sem data loss. (4) backup: replicação não substitui backup (conecta com sti-backup-disaster-recovery). Replicação protege contra falha de hardware; backup protege contra corrupção lógica (bug que corrompe dados é replicado para todas as réplicas). (5) testar failover: periodicamente, forçar failover de leader para standby e verificar que operação continua sem data loss e com latência aceitável (chaos engineering de OOI). Se failover não foi testado: é contingência teórica, não real."
		dependsOn: ["dsd-cap-pacelc", "dsd-consistency-at-boundary"]
		crossDependsOn: [{
			lensId:    "lens-security-trust-infrastructure"
			conceptId: "sti-backup-disaster-recovery"
			context:   "STI define RPO/RTO e backup strategy. DSD define replication strategy que implementa RPO ≈ 0 para dados financeiros. Replication é o mecanismo real-time que satisfaz RPO; backup é o mecanismo que protege contra corrupção lógica que replication propaga. DSD diz 'synchronous replication com acks=all'; STI diz 'e backup imutável em cold storage para proteção contra corrupção'."
		}]
		rationale: "Kleppmann 2017: três modelos de replicação. Ongaro/Ousterhout 2014: Raft. TigerBeetle 2023: database para financial transactions. Na Mesh, dados financeiros com RPO ≈ 0 requerem synchronous replication — asynchronous é aceitável apenas para dados consultivos. Failover não-testado é failover inexistente."
	},
	{
		id:         "dsd-backpressure-flow-control"
		name:       "Backpressure e Controle de Fluxo: Quando o Produtor é Mais Rápido que o Consumidor"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "Reactive Streams Specification (2014+, Lightbend/Netflix/Pivotal): backpressure é mecanismo pelo qual o consumidor sinaliza ao produtor que está sobrecarregado — produtor reduz taxa de envio. Sem backpressure: produtor enche buffers → buffers enchem memória → OOM → crash. Little's Law: L = λW (items in system = arrival rate × processing time). Se λ (arrival) > capacity: queue cresce indefinidamente. Kleppmann (2017): em sistemas distribuídos, backpressure pode propagar upstream — se serviço C está lento, serviço B enche, serviço A enche, cliente percebe latência. Conceito contemporâneo de 'adaptive concurrency limits' (Netflix Concurrency Limits library, 2018+; gRPC adaptive throttling): sistemas que ajustam automaticamente paralelismo e rate limits baseado em latência observada — não em configuração estática. O sistema 'aprende' sua capacidade em runtime."
		meshManifestation: "Na Mesh, cenários de backpressure: (1) bulk onboarding — construtora importa 500 fornecedores de uma vez. Pipeline de compliance não processa 500 simultaneamente. Sem backpressure: pipeline trava ou consome toda memória. Com: queue com rate limit, fornecedores processados em batches. (2) scoring em pico — 50 solicitações de antecipação em 1 hora (vs média de 10/dia). LLM provider tem rate limit. Sem backpressure: requests falham com 429. Com: queue com retry e backoff, fornecedores notificados de delay. (3) banco parceiro — banco tem throughput máximo de liquidações/hora. Se Mesh envia 100 e banco suporta 50: rejeições. Com backpressure: Mesh limita envio ao throughput do banco. (4) event consumers — se consumer de events está lento (scoring recalculating), producer (event log) continua acumulando. Consumer lag cresce. Se consumer nunca alcança: dados stale indefinidamente."
		meshImplication: "Para cada par produtor-consumidor no sistema: (1) identificar quem é mais rápido. Se produtor > consumidor: implementar backpressure. (2) mecanismo preferencial: bounded queue + rate limiter. Queue tem tamanho máximo. Se cheia: produtor recebe sinal (reject, throttle, ou block). (3) para integrações externas: respeitar rate limits documentados do parceiro. Implementar rate limiter client-side que não excede rate limit do parceiro — ser bom cidadão da API. (4) para agentes LLM: rate limit de tokens por minuto. Se pipeline demanda mais que rate limit: queue de requests com prioridade (scoring de operação urgente > recálculo de métricas). (5) monitoring: consumer lag como métrica core. Se lag > threshold (ex: >1000 events ou >5 minutos): alerta. Lag crescente sem estabilização: consumer precisa de scaling ou otimização. (6) adaptive: quando possível, usar concurrency limits adaptativos que ajustam baseado em latência observada — não configuração estática que fica obsoleta quando sistema muda."
		dependsOn: ["dsd-scalability-patterns", "dsd-failure-modes"]
		rationale: "Reactive Streams 2014+: backpressure specification. Little's Law: queue cresce se arrival > capacity. Netflix 2018+: adaptive concurrency limits. Na Mesh, backpressure mal gerenciada se manifesta como: requests falhando em pico, banco parceiro rejeitando liquidações, ou consumer lag crescente que gera dados stale — cada um é degradação de serviço prevenível."
	},
	{
		id:         "dsd-context-propagation"
		name:       "Propagação de Contexto Distribuído: Se Não Está no Design, Não Pode Ser Observado"
		nature:     "theoretical"
		role:       "property"
		definition: "Sigelman et al. (2010, 'Dapper, a Large-Scale Distributed Systems Tracing Infrastructure' — Google): tracing distribuído requer que contexto (trace ID, span ID, causality metadata) seja propagado entre componentes como parte do design da comunicação — não adicionado depois como instrumentação. Se o sistema não propaga contexto: nenhuma ferramenta de observabilidade pode reconstruir o fluxo. W3C Trace Context (2020, W3C Recommendation): standard para propagação de trace context via HTTP headers (traceparent, tracestate) — interoperável entre vendors e frameworks. OpenTelemetry (2019+, CNCF): framework unificado que define como propagar contexto (context propagation API), coletar dados (SDK), e exportar (OTLP protocol) — de facto standard para instrumentation. Conceito chave: context propagation é decisão de design de mensagem/evento, não de infraestrutura. Cada mensagem, evento, request e response deve carregar metadados suficientes para reconstruir o fluxo distribuído end-to-end. Mace et al. (2018, 'Universal Context Propagation for Distributed System Instrumentation'): propõe context propagation como camada universal — todo sistema distribuído deveria propagar contexto por default, não opt-in. Shkuro (2019, Mastering Distributed Tracing): três pilares de tracing — context propagation (design), data collection (instrumentation), e data analysis (observability). O primeiro é pré-condição dos outros dois."
		meshManifestation: "Na Mesh, context propagation é necessário em: (1) saga de antecipação — 7 steps em BCs diferentes. Sem correlation ID propagado entre steps: impossível reconstruir a história de uma operação específica que falhou no step 5. 'Qual scoring produziu esse resultado?' 'Qual documentação foi validada?' 'Quanto tempo cada step levou?' Sem contexto: responder requer inspeção manual de logs desconectados. (2) agentes IA — cada invocação de agente é span dentro de um trace maior. Se agente de scoring invoca agente de compliance que invoca API de bureau: sem context propagation, os três aparecem como operações isoladas em logs. Debug de 'por que compliance rejeitou fornecedor X na operação Y' requer conectar 3 sistemas — impossível sem trace ID compartilhado. (3) integrações externas — banco parceiro, registradora. Se Mesh envia request com trace ID no header e parceiro retorna trace ID na response: é possível correlacionar latência do parceiro com latência end-to-end. Se não: latência do parceiro é caixa preta. (4) eventos no event log — cada evento deve carregar: trace_id (operação end-to-end), span_id (step específico), causality_ref (evento que causou este), saga_id (se parte de saga), timestamp, e source_component. Sem isso: event log é sequência de fatos desconectados."
		meshImplication: "Projetar context propagation como contrato de design, não como add-on: (1) definir context schema — quais metadados toda mensagem/evento/request carrega. Mínimo: trace_id (UUID, identifica operação end-to-end), span_id (UUID, identifica step), parent_span_id (span que gerou este), saga_id (se aplicável), timestamp, source_component, causality_refs (IDs de eventos que causaram este). (2) adotar W3C Trace Context para comunicação HTTP — traceparent header propagado em toda request entre componentes e integrações. (3) para eventos no event log: incluir trace context como campos do evento (não metadata separada). Cada evento é self-contained para reconstrução. (4) para agentes IA: cada invocação de agente recebe trace_id e span_id como parte do contexto. Output do agente inclui span_id para correlação. Se agente invoca sub-agente ou API: propagar trace_id. (5) adotar OpenTelemetry SDK como base de instrumentação — propaga contexto automaticamente para HTTP, gRPC, e message queues suportadas. Custom propagation para canais não-suportados (ex: invocação de LLM via API). (6) testar propagação: para cada fluxo end-to-end, verificar que trace completo pode ser reconstruído a partir do trace_id — se algum step não tem o trace_id, propagation está quebrada. (7) regra: componente novo que se comunica com outro componente existente DEVE implementar context propagation antes de ir para produção — não é tech debt aceitável, porque sem propagação o componente é invisível para debugging. Anti-pattern: correlation ID definido apenas na camada de observabilidade (OOI) sem ser propagado no design das mensagens — quando observabilidade tenta reconstruir o fluxo, os links não existem. A observabilidade não pode observar o que o design não transmitiu."
		dependsOn: ["dsd-saga-coordination", "dsd-event-ordering-causality"]
		crossDependsOn: [
			{
				lensId:    "lens-observability-operational-intelligence"
				conceptId: "ooi-observability-vs-monitoring"
				context:   "OOI define observabilidade como capacidade de diagnosticar o desconhecido — logs, métricas, traces. DSD define context propagation como pré-condição para que traces existam. OOI consome os traces; DSD projeta a propagação que os gera. Sem DSD context propagation, OOI distributed tracing é impossível — não há dados para observar. DSD é upstream de OOI nesta dimensão: design antes de observação."
			},
			{
				lensId:    "lens-ai-agent-governance"
				conceptId: "aag-audit-trail"
				context:   "AAG define audit trail para reconstruir decisões de agentes. DSD define context propagation que conecta a decisão do agente ao fluxo end-to-end. Sem trace_id propagado: audit trail do agente existe isoladamente, mas não pode ser conectado à saga, à liquidação, ou ao registro. Para auditoria regulatória ('reconstrua a operação X completa'), ambos são necessários: AAG para o 'por que o agente decidiu' e DSD para o 'como essa decisão se conecta ao fluxo inteiro'."
			},
		]
		rationale: "Sigelman/Dapper 2010: tracing requer propagação no design. W3C Trace Context 2020: standard de propagação. OpenTelemetry 2019+: framework unificado. Shkuro 2019: context propagation é pré-condição de tracing. Mace et al. 2018: propagação universal. Na Mesh como intermediário financeiro com operações distribuídas entre agentes, BCs e integrações externas, context propagation é o que torna o sistema debugável e auditável — sem propagação projetada, falhas de consistency em produção são impossíveis de diagnosticar e o regulador não pode reconstruir a operação end-to-end."
	},
	{
		id:         "dsd-testing-distributed-systems"
		name:       "Testing de Sistemas Distribuídos: Verificar Corretude em Presença de Não-Determinismo"
		nature:     "theoretical"
		role:       "method"
		definition: "Kingsbury (2020+, Jepsen): framework de testing que verifica se databases distribuídos cumprem as guarantees que prometem — injeta falhas de rede, clock skew, process crashes e verifica invariantes. Jepsen encontrou bugs em CockroachDB, MongoDB, Elasticsearch, Kafka e dezenas de outros. A lição: 'distributed systems are broken until proven otherwise.' Newcombe et al. (2015, 'How Amazon Web Services Uses Formal Methods'): Amazon usa TLA+ para especificar e verificar protocolos de DynamoDB, S3, EBS — encontrou bugs sutis que não seriam detectados por testes tradicionais. Conceito contemporâneo de 'deterministic simulation testing' (FoundationDB, TigerBeetle 2023+): simular o sistema inteiro deterministicamente — cada falha de rede, timeout, reordering é controlável e reproduzível. Permite testar bilhões de cenários que testes manuais nunca cobririam. Antithesis (2023+): plataforma de autonomous testing que usa deterministic simulation para encontrar bugs em qualquer software — 'software that tests your software'. Property-based testing (Claessen/Hughes 2000, QuickCheck): gerar inputs aleatórios e verificar propriedades (invariantes) — se propriedade viola: bug encontrado com caso mínimo reproduzível."
		meshManifestation: "Na Mesh como intermediário financeiro, invariantes críticas que devem ser verificadas: (1) saldo nunca fica negativo. (2) operação de antecipação nunca é processada duas vezes. (3) toda operação aprovada é eventualmente liquidada ou cancelada — nunca fica em limbo. (4) toda operação liquidada é eventualmente registrada. (5) sequência aprovação → liquidação → registro é respeitada — nunca invertida. (6) soma de todas as antecipações ativas ≤ limite do FIDC. Cada invariante deve ser verificável por testes — não apenas por inspeção de código. Testes tradicionais (unit, integration) não cobrem combinações de falha (timeout + retry + concurrent request + partition) que são realidade em produção."
		meshImplication: "Estratégia de testing em 4 camadas: (1) property-based testing — para cada invariante, escrever property test que gera cenários aleatórios e verifica que invariante nunca é violada. Framework: Hypothesis (Python) ou jqwik (Kotlin/JVM). Ex: 'para qualquer sequência de N operações de antecipação com retries aleatórios e timeouts, saldo final ≥ 0.' Rodar 10.000+ cenários por invariante. (2) integration testing com fault injection — testar sagas end-to-end com falhas injetadas em cada step. Para cada step da saga: simular sucesso, timeout, falha, e resposta duplicada. Verificar que saga converge para estado válido em todos os cenários. (3) contract testing — para cada fronteira entre BCs e integrações: contract test que verifica schema e behavior (conecta com ooi-integration-contract-testing). (4) quando escala justificar: deterministic simulation (FoundationDB-style) ou Jepsen-like testing para verificar consistency guarantees do database e do sistema como um todo. No mínimo: Jepsen-style testing das guarantees do Postgres com a configuração de replication da Mesh (synchronous + failover). Regra: toda invariante financeira tem property test. Se property test passa com 10.000 cenários: confiança razoável. Se falha com 1 cenário: bug encontrado antes de produção."
		dependsOn: ["dsd-idempotency", "dsd-saga-coordination", "dsd-failure-modes", "dsd-consistency-at-boundary"]
		crossDependsOn: [{
			lensId:    "lens-security-trust-infrastructure"
			conceptId: "sti-secure-development-lifecycle"
			context:   "STI-SDL define gates de segurança no pipeline de deploy (SAST, DAST, secret scanning). DSD define gates de corretude — property-based tests e integration tests com fault injection como gates de deploy. Se property test de invariante financeira falha: deploy bloqueado, assim como SAST finding crítico bloqueia. Ambos são gates de CI/CD; o que verificam é diferente (segurança vs corretude)."
		}]
		rationale: "Kingsbury/Jepsen 2020+: distributed systems are broken until proven otherwise. Newcombe/Amazon 2015: formal methods em produção. FoundationDB/TigerBeetle 2023+: deterministic simulation. Na Mesh como intermediário financeiro, 'provavelmente funciona' não é suficiente para operações que movem dinheiro. Property-based testing é o mínimo; deterministic simulation é o ideal quando escala justificar."
	},
	{
		id:            "dsd-distributed-systems-review"
		name:          "Revisão de Arquitetura Distribuída: Inventário Periódico de Decisões e Invariantes"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico que consolida todos os conceitos da lens num snapshot acionável. Para cada período: (1) consistency models — cada BC tem consistency model declarado? Fronteiras entre BCs com models diferentes têm ACL? (2) sagas — cada fluxo multi-BC tem saga explícita com compensações definidas? Failure modes cobertos? (3) idempotência — toda operação com side effect externo é idempotente? Testada? (4) topologia — modular monolith ainda é adequado? Algum módulo precisa de extração? (5) failure modes — novos modos de falha apareceram? 8 fallacies estão cobertas para toda integração? (6) ordering — causalidade capturada? Event log ordering correto? (7) scaling — volume atual vs capacidade? Próximo bottleneck? (8) replication — RPO/failover testados? Consumer lag estável? (9) backpressure — pares produtor-consumidor todos com mecanismo de flow control? (10) context propagation — todo componente propaga trace context? Fluxo end-to-end reconstruível a partir de trace_id? Novo componente adicionado sem propagação? (11) testing — property tests para todas as invariantes financeiras? Passando?"
		meshManifestation: "Na Mesh: revisão trimestral formal. Mensal: micro-revisão (consumer lag, replication health, property test results, saga failures, trace completeness). Trimestral: macro-revisão com inventário completo de decisões arquiteturais."
		meshImplication: "Mensal (30min): consumer lag de todos os event consumers — algum crescendo? Replication lag — synchronous replication saudável? Property tests — todos passando? Algum novo invariante sem teste? Saga failures no período — alguma saga ficou em estado inconsistente? Trace completeness — selecionar 5 operações aleatórias e verificar que trace end-to-end é reconstruível. Se algum step não tem trace_id: context propagation quebrada. Se sim: investigar e corrigir. Trimestral (2h): consistency models — ainda adequados dado o estágio e volume? Alguma fronteira entre BCs com bugs de consistency? Sagas — novos fluxos multi-BC apareceram sem saga explícita? Topologia — modular monolith ainda é adequado? Volume justifica extração de algum módulo? Scaling — projeção de volume para 6 meses excede capacidade atual? Lead time de mudança arquitetural é compatível? Idempotência — toda operação financeira testada com retry+fault injection? Replication — failover testado no trimestre? Se não: testar agora. Context propagation — novo componente ou integração adicionado sem propagação? W3C Trace Context implementado em toda comunicação HTTP? Eventos no event log carregam trace context completo? Testing — cobertura de property tests para invariantes financeiras é completa? Novos invariantes apareceram com novas features? Se revisão não identifica pelo menos uma ação: ou a arquitetura está perfeita (improvável) ou a revisão é superficial."
		dependsOn: ["dsd-cap-pacelc", "dsd-saga-coordination", "dsd-idempotency", "dsd-topology-choice", "dsd-failure-modes", "dsd-event-ordering-causality", "dsd-scalability-patterns", "dsd-data-replication", "dsd-backpressure-flow-control", "dsd-context-propagation", "dsd-testing-distributed-systems"]
		rationale: "Sem revisão periódica, decisões arquiteturais fossilizam enquanto o sistema evolui — modularidade degrada, invariantes novos não são testados, sagas novas não são documentadas. O inventário periódico mantém a arquitetura distribuída alinhada com a realidade do sistema."
	},
]

reasoningProtocol: [
	{
		question:  "Esta operação requer strong consistency, eventual consistency, ou causal consistency? Qual é o custo de cada escolha?"
		reveals:   "Se o consistency model é explícito e adequado — ou se está implícito e possivelmente errado."
		rationale: "Brewer/CAP + Abadi/PACELC: o trade-off não pode ser evitado — pode ser escolhido conscientemente."
	},
	{
		question:  "Este fluxo cruza fronteiras de bounded context ou integração? Se sim: é modelado como saga com compensações definidas?"
		reveals:   "Se transações distribuídas têm coordenação explícita — ou se falha parcial deixa o sistema em estado inconsistente."
		rationale: "Garcia-Molina/Salem 1987: sagas para transações distribuídas. Sem saga explícita: falha parcial = limbo."
	},
	{
		question:  "Esta operação é idempotente? Se request for enviada duas vezes (timeout + retry), o resultado é o mesmo?"
		reveals:   "Se duplicação é prevenida por design — ou se retry pode causar operação duplicada."
		rationale: "Helland 2012: idempotência é requisito. Kleppmann 2017: exactly-once é ilusão; at-least-once + idempotência é realidade."
	},
	{
		question:  "A topologia de serviços é adequada ao tamanho da equipe e ao estágio? Estamos pagando o custo de microservices sem o benefício?"
		reveals:   "Se complexidade operacional é proporcional ao valor — ou se premature decomposition consome o constraint."
		rationale: "Newman 2021: microservices têm custo real. Skelton/Pais 2019: Conway's Law. Solo founder = modular monolith."
	},
	{
		question:  "Dois componentes com consistency models diferentes interagem? A fronteira entre eles tem ACL ou integration pattern que previne anomalias?"
		reveals:   "Se o ponto mais perigoso do sistema (fronteira de consistency) está protegido — ou se é gap esperando para manifestar como bug."
		rationale: "Kleppmann 2017: fronteira é onde bugs surgem. Evans 2003: ACL protege boundaries."
	},
	{
		question:  "Quais failure modes são possíveis nesta comunicação/integração? Para cada um: o que acontece? Timeout = falha ou ambiguidade?"
		reveals:   "Se modos de falha são antecipados e tratados — ou se são surpresas em produção."
		rationale: "Deutsch 1994: 8 fallacies. Bailis/Kingsbury 2014: catálogo de failures. Timeout é ambíguo por definição."
	},
	{
		question:  "A ordenação de eventos importa para esta operação? Causalidade está capturada? O mecanismo de ordering é confiável?"
		reveals:   "Se dependências causais entre eventos são respeitadas — ou se reordenação pode gerar estado corrompido."
		rationale: "Lamport 1978: causalidade define ordering. Na Mesh, aprovação→liquidação→registro é invariante causal."
	},
	{
		question:  "O que acontece quando o volume cresce 10x? Qual componente é o bottleneck? Qual o lead time para resolver?"
		reveals:   "Se scaling é antecipado e projetado — ou se o bottleneck será descoberto quando causar outage."
		rationale: "Abbott/Fisher 2015: Scale Cube. Projetar para modularidade agora; escalar quando evidência justificar."
	},
	{
		question:  "A replicação de dados financeiros é synchronous com RPO ≈ 0? Failover foi testado?"
		reveals:   "Se durability de dados financeiros é garantida — ou se é aspiração não-testada."
		rationale: "Kleppmann 2017: replication para HA. Failover não-testado = failover inexistente."
	},
	{
		question:  "Existe mecanismo de backpressure entre produtor e consumidor? Se produtor é mais rápido: o que acontece?"
		reveals:   "Se overflow é prevenido — ou se vai manifestar como OOM, requests falhando, ou consumer lag crescente."
		rationale: "Reactive Streams 2014+: backpressure. Little's Law: sem controle de fluxo, queue cresce sem limite."
	},
	{
		question:  "Toda mensagem, evento e request entre componentes carrega trace context (trace_id, span_id, causality refs)? Um fluxo end-to-end pode ser reconstruído a partir do trace_id?"
		reveals:   "Se context propagation está projetada no design — ou se debugging de problemas distribuídos será impossível porque os componentes não propagam contexto. Se observabilidade não consegue reconstruir o fluxo: propagação está quebrada ou ausente."
		rationale: "Sigelman/Dapper 2010: tracing requer propagação no design. W3C Trace Context 2020: standard. Shkuro 2019: propagação é pré-condição dos outros dois pilares (collection + analysis). Componente sem context propagation é componente invisível."
	},
	{
		question:  "As invariantes financeiras do sistema têm property-based tests? Os testes cobrem cenários de falha (retry, timeout, concurrent requests)?"
		reveals:   "Se corretude é verificada sistematicamente — ou se é 'provavelmente funciona' baseado em testes manuais."
		rationale: "Kingsbury/Jepsen: broken until proven otherwise. Property-based testing verifica invariantes sob cenários que humanos não pensariam."
	},
]

meshExamples: [
	{
		id:       "ex-anticipation-saga-design"
		scenario: "Mesh precisa projetar o fluxo de antecipação de recebíveis end-to-end como saga distribuída. Fluxo: solicitação → validação de documentos → scoring → decisão → liquidação → registro → notificação. Cada step em bounded context diferente."
		analysis: "7 steps, cada um em BC diferente, cada um com failure modes próprios. Steps com efeito externo irreversível: liquidação (banco) e registro (registradora). Steps internos: solicitação, validação, scoring, decisão, notificação — reversíveis. Orchestration vs choreography: fluxo é linear com compensação complexa → orchestration é preferível (visibilidade end-to-end, compensação centralizada). Workflow engine (Temporal) como orquestrador. Cada step é activity function com timeout, retry policy e compensation function. Sagas nested: se liquidação falha após 3 retries → não compensar automaticamente (dinheiro pode estar em trânsito) → escalar para humano."
		recommendation: "Modelar como orchestrated saga em Temporal: (1) activity: validate_documents → timeout 2min, retry 2x, compensação: nenhuma (stateless). (2) activity: calculate_score → timeout 60s, retry 3x, compensação: nenhuma (idempotente). (3) activity: make_decision → timeout 5s (se dentro de autonomia) ou async (se humano), compensação: nenhuma. (4) activity: execute_settlement → timeout 30s, retry com idempotency key, compensação: NOT automatic — se 3 retries falham, escalar para humano com contexto completo. (5) activity: register_operation → timeout 10s, retry com idempotency key indefinidamente (circuit breaker após 10 falhas → pause + alerta → retry quando circuit closes). Compensação: não — registro pode atrasar, não pode ser omitido. (6) activity: notify_supplier → timeout 5s, retry 2x, compensação: nenhuma (best effort). Observability: saga_id como correlation ID em todos os logs. Cada step logado com: início, fim, resultado, duração, retries. Dashboard: status de todas as sagas em flight. Invariantes: (a) toda saga termina (não fica em limbo indefinidamente), (b) toda liquidação tem registro (eventualmente), (c) nenhuma liquidação é duplicada (idempotency key)."
		principlesApplied: ["ax-01", "ax-04", "ax-05", "ax-06"]
		assumptions: [
			"Temporal é escolha adequada de workflow engine — avaliar alternativas (AWS Step Functions, Conductor)",
			"banco parceiro suporta idempotency key — se não, implementar checking layer (query status antes de retry)",
			"registradora tolera delay de horas sem penalidade regulatória — verificar",
			"7 steps é decomposição adequada — pode ser simplificável (merge validate + score se mesmo BC)",
		]
		rationale: "Garcia-Molina/Salem 1987: saga pattern. Richardson 2018: orchestration para fluxos com compensação complexa. Na Mesh, antecipação é a operação core que move dinheiro — projetá-la como saga explícita com compensações definidas é o que previne estados inconsistentes que, em intermediário financeiro, são risco existencial."
	},
	{
		id:       "ex-consistency-model-decision"
		scenario: "Mesh precisa decidir consistency model para 4 tipos de dados: saldo da conta de liquidação, score de compradores, status de compliance de fornecedores, e métricas de dashboard."
		analysis: "Cada tipo tem necessidades diferentes: (1) saldo: strong consistency obrigatória. Dois reads concorrentes devem ver o mesmo valor. Inconsistência = double-spend. (2) score: causal consistency suficiente. Score calculado com snapshot dos inputs no momento da solicitação. Stale por segundos: aceitável. Stale por horas: inaceitável. (3) compliance status: eventual consistency suficiente. Status atualizado é consultivo, não financeiro. Stale por minutos: aceitável. (4) dashboard: eventual consistency com lag tolerável de minutos. É informacional. Aplicar strong consistency a tudo: funciona mas latência desnecessária para dashboard e métricas. Aplicar eventual consistency a tudo: funciona para dashboards mas catastrófico para saldo."
		recommendation: "Consistência por tipo de dado (PACELC LC choice): (1) saldo de liquidação: serializable isolation no database. Reads de saldo para decisão de antecipação usam SELECT FOR UPDATE (lock) ou serializable snapshot. PostgreSQL com SERIALIZABLE isolation para transações de saldo. Trade-off: latência de write ~5-10ms extra. Aceitável. (2) score de comprador: snapshot isolation. Read de inputs com snapshot consistente. Score calculado é gravado como evento imutável. Stale score é aceitável por <5 minutos. Invalidação: se input muda significativamente, flag para recálculo. (3) compliance status: read-committed ou eventual. Atualizado via evento assíncrono. Dashboard pode mostrar status de 30s atrás sem impacto. (4) métricas de dashboard: eventual com lag <5min. Read replica assíncrona. Documentar: no mesh-spec, para cada bounded context, consistency model declarado com rationale. Na fronteira ECL (saldo, serializable) ↔ Scoring (snapshot): ACL garante que scoring lê saldo com consistency adequada quando decisão financeira depende de saldo — mesmo que o resto do scoring seja eventual."
		principlesApplied: ["ax-01", "ax-02", "ax-06"]
		assumptions: [
			"PostgreSQL SERIALIZABLE performance é adequada para volume esperado — testar com benchmark",
			"5 minutos de staleness para scores é aceitável — pode ser inaceitável se comprador está em stress financeiro rápido",
			"read replica lag <5min é achievable — depende de write volume e configuração",
			"SELECT FOR UPDATE para saldo não gera contention excessiva com volume baixo — revisitar em escala",
		]
		rationale: "Abadi 2012: PACELC — escolha por operação. Kleppmann 2017: consistency model per data type. Na Mesh, 4 tipos de dados com 4 consistency models — a chave é documentar e enforçar, não assumir que 'o Postgres resolve tudo' (que é verdade no monolith mas falha quando BCs se separam)."
	},
	{
		id:       "ex-idempotency-settlement"
		scenario: "Mesh envia request de liquidação de R$85k ao banco parceiro. Timeout após 25s. O dinheiro foi transferido ou não? Request deve ser reenviada?"
		analysis: "Ambiguidade clássica de distributed systems (Gray 1981): timeout não significa falha — significa 'não sei'. Três cenários: (a) banco nunca recebeu request → reenviar é correto. (b) banco recebeu, processou, mas response se perdeu → reenviar sem idempotência = R$170k transferidos. (c) banco recebeu, está processando lento → reenviar enquanto ainda processando = R$170k ou conflito. Sem idempotency key: qualquer retry é arriscado. Com idempotency key: banco verifica se settlement_id já foi processado. Se sim: retorna resultado anterior. Se não: processa. Resultado: operação processada exatamente 1 vez independente de retries."
		recommendation: "(1) Toda request de liquidação carrega idempotency_key = settlement_id (UUID gerado na criação da operação, não no envio). (2) Se banco parceiro suporta idempotency key nativa: incluir no header (ex: X-Idempotency-Key). Banco garante deduplicação. (3) Se banco não suporta: implementar checking layer — antes de reenviar após timeout: query status da operação no banco (GET /settlements/{settlement_id}). Se status = completed: não reenviar, usar resultado. Se status = not_found: reenviar. Se status = pending: esperar + retry query. (4) Retry policy: exponential backoff (5s, 10s, 20s, 40s). Max retries: 5. Após 5 retries sem resolução: circuit breaker + escalar para humano com contexto (saga step failed, settlement_id, valor, timestamp, retry history). (5) Logging: todo retry logado com: attempt_number, idempotency_key, request_hash, response (timeout/error/success). (6) Property test: simular 100 cenários de (request + timeout + retry) com mock do banco que aleatoriamente: aceita, rejeita, retorna timeout, duplica response. Verificar invariante: settlement processado exatamente 1 vez em todos os cenários. (7) Monitorar: taxa de retries como métrica. Se >5% das liquidações requerem retry: investigar — pode ser timeout muito curto, instabilidade do banco, ou network issue."
		principlesApplied: ["ax-03", "ax-05", "dp-01"]
		assumptions: [
			"banco parceiro suporta query de status por settlement_id — se não, idempotency nativa é obrigatória",
			"timeout de 25s é adequado — pode precisar de calibração baseada em latência observada do banco",
			"settlement_id como idempotency key é suficientemente único — UUID v4 tem probabilidade de colisão negligível",
			"exponential backoff com max 5 retries é política adequada — calibrar com SLA do banco",
		]
		rationale: "Gray 1981: timeout é ambíguo. Helland 2012: idempotência como solução. Na Mesh, R$85k duplicados é perda direta. Idempotency key + checking layer + property test é o padrão que torna retry seguro — sem isso, toda operação financeira com timeout é roleta."
	},
	{
		id:       "ex-modular-monolith-extraction"
		scenario: "Mesh opera há 12 meses como modular monolith. Volume cresceu para 5.000 operações/mês. Scoring pipeline (LLM-intensive) está consumindo 60% do CPU e causando latência em endpoints de consulta (dashboard, status). Founder avalia extrair scoring como microservice."
		analysis: "Sintoma: scoring compute-intensive afeta latência de queries consultivas. Causa: monolith compartilha resources — scoring e queries competem por CPU/memória. Avaliação dos critérios de extração de DSD: (a) deploy frequency diferente? Scoring é atualizado semanalmente (model update), queries são atualizadas diariamente → diferença moderada. (b) scaling requirement diferente? Scoring precisa de compute scaling (GPU/high-CPU) proporcional ao volume. Queries precisam de read scaling. Sim: requirements de scaling são fundamentalmente diferentes. (c) failure isolation crítica? Se scoring crashar, queries devem continuar → sim. Se queries crasham, scoring deve continuar → sim. Critérios (b) e (c) são satisfeitos → extração justificada."
		recommendation: "Extração em 4 fases: (1) Fase 1 — isolar interface: definir API contract explícito entre scoring module e o resto do monolith. CUE schema para request/response. Módulo interno se comunica via interface, não via chamada direta. Duração: 1 semana. Validação: monolith funciona com scoring acessado via interface interna. (2) Fase 2 — extrair como processo separado: scoring roda como processo independente com API HTTP/gRPC. Monolith chama scoring via network. Database: scoring tem read replica própria ou database separado para features. Duração: 2-3 semanas. Validação: latência de queries consultivas melhora. Scoring scaling independente. (3) Fase 3 — stabilizar: monitorar por 4 semanas. SLOs: scoring latency P99 <10s, query latency P99 <200ms (vs >2s antes). Consumer lag estável. Failure isolation testada: derrubar scoring, verificar que queries continuam. (4) Fase 4 — otimizar: scoring-specific scaling (auto-scaling por queue depth). Caching de features. Batch scoring para operações não-urgentes. Não extrair mais nada: se sintoma é resolvido, parar. Cada extração adicional aumenta complexidade operacional. Anti-pattern: 'já que extraímos scoring, vamos extrair compliance, notificações e relatórios também' — sem evidência de necessidade, é premature decomposition."
		principlesApplied: ["ax-01", "ax-02", "ax-04"]
		assumptions: [
			"60% CPU por scoring é medição correta — pode ser query mal-otimizada, não scoring",
			"extração resolve o problema — se bottleneck é database I/O e não CPU, extração não ajuda",
			"2-3 semanas para extração é realista — depende de qualidade das interfaces internas existentes",
			"scoring como serviço separado não introduz bugs de consistency — precisa de contract testing",
		]
		rationale: "Newman 2021: extrair quando evidência justifica. Khononov 2024: modular monolith como stepping stone. Na Mesh, extração de scoring é justificada por scaling + failure isolation — os dois critérios que mais importam. Mas a extração é cirúrgica: 1 módulo, não wholesale decomposition."
	},
]

principleIds: ["ax-01", "ax-02", "ax-03", "ax-04", "ax-05", "ax-06", "dp-01", "dp-05"]

relatedLenses: [
	{
		lensId:   "lens-observability-operational-intelligence"
		relation: "complementsWith"
		context:  "OOI monitora o sistema distribuído em operação — SLOs, anomalies, incidents, consumer lag, replication health. DSD projeta a arquitetura que OOI monitora. DSD define invariantes; OOI verifica em runtime. DSD define failure modes; OOI injeta (chaos engineering) e detecta (anomaly detection). OOI (ooi-integration-contract-testing) verifica contratos de interface que DSD define. OOI (ooi-capacity-planning) antecipa bottlenecks que DSD (dsd-scalability-patterns) resolve."
	},
	{
		lensId:   "lens-ai-agent-governance"
		relation: "complementsWith"
		context:  "AAG governa agentes como componentes do sistema. DSD trata agentes como workers num sistema distribuído — com failure modes (timeout, retry), concurrency (múltiplos agentes operando simultaneamente), e ordering (decisões de agentes têm dependências causais). AAG diz 'agente pode aprovar até R$50k'; DSD diz 'se agente timeout durante aprovação, saga compensation é X'."
	},
	{
		lensId:   "lens-security-trust-infrastructure"
		relation: "complementsWith"
		context:  "STI protege o sistema distribuído — criptografia em transit entre serviços, identity management de cada componente, backup/DR para dados replicados. DSD define a topologia e os fluxos de dados que STI protege. DSD (dsd-idempotency) + STI (sti-cryptographic-foundations): operação financeira é idempotente E assinada E auditada."
	},
	{
		lensId:   "lens-organizational-resource-allocation"
		relation: "complementsWith"
		context:  "ORA aloca recursos entre atividades. DSD informa: decisões arquiteturais tipo 2 (topologia, consistency model, replication strategy) requerem análise proporcional. DSD (dsd-topology-choice) respeita ORA (ora-throughput-constraint): solo founder = modular monolith, não microservices."
	},
	{
		lensId:   "lens-knowledge-management"
		relation: "complementsWith"
		context:  "KM preserva decisões arquiteturais como ADRs. DSD gera decisões que devem ser documentadas — consistency model por BC, topology choice, replication strategy, saga design. Cada decisão de DSD é candidata a ADR tipo 2 (arquitetural). KM (km-knowledge-decay-refresh) monitora se decisões de DSD ainda são válidas dado evolução do sistema."
	},
	{
		lensId:   "lens-real-options"
		relation: "complementsWith"
		context:  "RO modela timing de investimento sob incerteza. DSD provê a modularidade que preserva opções — modular monolith mantém opção de extrair microservice sem comprometer. RO diz 'não investir em extração até que evidência justifique'; DSD diz 'projetar para modularidade agora para que extração seja possível quando RO decidir exercer a opção'."
	},
	{
		lensId:   "lens-credit-risk"
		relation: "complementsWith"
		context:  "CR modela risco de crédito e scoring. DSD garante que scoring opera com consistency guarantees adequadas — snapshot isolation para features, idempotência para scoring triggers, ordering para events que alimentam scoring. CR é a qualidade do modelo; DSD é a corretude da infraestrutura que o modelo opera."
	},
]

limitations: [
	{
		description: "Framework assume que o sistema é/será distribuído. Pré-revenue com monolith e PostgreSQL single-node, muitos conceitos são prematuros — replicação, sharding, sagas, consensus."
		alternative: "Aplicar proporcionalmente ao estágio: pré-revenue: consistency models (sempre relevante), idempotência para operações financeiras (sempre relevante), modularidade interna (custo marginal). Scaling, replication, sagas: quando volume ou topology justificar. Projetar para: sim. Implementar: quando necessário."
		rationale: "ax-02: complexidade justificada por demanda real. Implementar replication para 100 operações/mês é over-engineering. Projetar idempotência para 100 operações/mês não é — porque o custo de não ter quando volume chega é retroativo e alto."
	},
	{
		description: "Formal verification (TLA+, Alloy) e deterministic simulation testing têm curva de aprendizado alta. Solo founder não-técnico não pode executar diretamente."
		alternative: "Property-based testing com Hypothesis/jqwik é acessível via agente IA (Claude Code pode escrever property tests). Formal verification como aspiração de escala, não requisito de bootstrap. Para operações financeiras: property-based testing é o mínimo; formal verification é o ideal quando justificável."
		rationale: "Newcombe 2015: Amazon usa TLA+ para sistemas críticos. Para Mesh pré-revenue: property-based testing cobre 80% do valor com 20% do custo. A opção de adotar formal verification fica aberta."
	},
	{
		description: "Sagas com compensação são complexas de projetar e testar. Cada novo failure mode exige nova compensação. O espaço de estados cresce combinatorialmente."
		alternative: "Minimizar o número de sagas: se fluxo pode ser executado numa única transação local (modular monolith), não modelar como saga. Sagas apenas para fluxos que genuinamente cruzam fronteiras de processo ou integração. Para cada saga: testar todos os failure modes com integration test automatizado — não confiar em inspeção manual."
		rationale: "Garcia-Molina/Salem 1987: sagas são solução para distributed transactions — se não há distribuição, não precisa de saga. Complexidade de saga é proporcional ao número de steps e failure modes."
	},
	{
		description: "Consistency models declarados por BC podem ser violados pela implementação. Declarar 'eventual consistency' mas usar shared database com joins cross-BC cria strong consistency implícita que quebra quando BCs se separam."
		alternative: "Enforçar boundaries: módulos em modular monolith comunicam via interfaces definidas, não via shared tables. Schema separation no database desde o início. Se um módulo precisa de dado de outro: interface explícita (API interna ou evento), não join."
		rationale: "Khononov 2024: modular monolith com boundaries reais. Shared database com joins cross-module é distributed monolith disfarçado — funciona até que não funciona (extração vira rewrite)."
	},
	{
		description: "Framework não cobre aspectos de distributed systems que dependem de escolha de tecnologia específica (Kafka vs RabbitMQ vs Pulsar, PostgreSQL vs CockroachDB vs TigerBeetle). Cobre patterns e trade-offs, não product selection."
		alternative: "Para escolha de tecnologia: avaliar contra os patterns e requirements definidos pela lens (consistency model necessário, throughput esperado, failure modes aceitáveis). Documentar como ADR com alternativas e rationale. A tecnologia deve satisfazer o pattern, não o contrário."
		rationale: "Tecnologias mudam; patterns são duráveis. A lens é sobre raciocínio correto sobre distribuição — a implementação depende do ecossistema e estágio."
	},
]

rationale: "Toda plataforma financeira que cresce além de um único processo enfrenta as propriedades fundamentais de sistemas distribuídos — falhas parciais, trade-offs de consistência, e coordenação como problema mais difícil. Na Mesh como intermediário financeiro AI-native, o sistema é inerentemente distribuído: agentes IA, integrações com bancos e registradoras, pipelines de scoring e compliance, e operações financeiras que exigem corretude absoluta. Esta lens operacionaliza: CAP/PACELC como trade-off por operação (Brewer 2000, Abadi 2012, Kleppmann 2017) com CALM theorem para operações monotônicas (Hellerstein/Alvaro 2020), sagas para transações distribuídas com orchestration via workflow engine (Garcia-Molina/Salem 1987, Richardson 2018, Temporal 2020+), idempotência como requisito absoluto para operações financeiras com deterministic simulation testing (Helland 2012, Gray 1981, TigerBeetle 2023+), topologia de serviços indexada ao tamanho da equipe com modular monolith como default (Newman 2021, Khononov 2024, Skelton/Pais 2019), consistência na fronteira com anti-corruption layers e schema evolution (Kleppmann 2017, Evans 2003, Confluent/Buf 2019+/2022+), modos de falha catalogados com 8 fallacies e formal verification (Deutsch 1994, Bailis/Kingsbury 2014, Amazon/Newcombe 2015), ordenação de eventos e causalidade com CRDTs e hybrid clocks (Lamport 1978, Shapiro et al. 2011, Kulkarni et al. 2014), patterns de escalabilidade com cell-based architecture (Abbott/Fisher 2015, AWS 2023), replicação com synchronous replication para dados financeiros (Kleppmann 2017, Ongaro/Ousterhout 2014, TigerBeetle 2023), backpressure e controle de fluxo com adaptive concurrency (Reactive Streams 2014+, Netflix 2018+), propagação de contexto distribuído como decisão de design com W3C Trace Context e OpenTelemetry (Sigelman/Dapper 2010, W3C 2020, OpenTelemetry 2019+, Shkuro 2019, Mace et al. 2018), e testing de sistemas distribuídos com property-based testing e Jepsen (Kingsbury 2020+, Newcombe 2015, Claessen/Hughes 2000, Antithesis 2023+). Universal, agnóstica a estágio, aplicável a qualquer organização que opera sistemas distribuídos com requisitos de corretude."

}
