package rew

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// canvas.cue — Bounded Context Canvas: REW (Risk Engine & Risk Observability).
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// Phase 1 do WI-046 REW bootstrap. Materializa identidade canônica do BC:
// - Quem é REW (purpose, classification)
// - O que faz (capabilities + communication)
// - Como decide (businessDecisions + ownership/governanceScope)
// - Para quem (stakeholders + incentiveAnalysis + costsEliminated)
// - Como sabe (assumptions + openQuestions + verificationMetrics)
//
// REW é o pricing moat estrutural da Mesh — capacidade de medir risco com
// dados operacionais verificados que NÃO existem fora da rede. Operação →
// valor → risco → dinheiro: REW é a etapa onde valor real (medido por NIM,
// evidenciado por DLV, executado por FCE) vira risco financeiro mensurável.
//
// FRASE CANONICAL (founder R5++++): "REW não está tentando prever o futuro;
// REW está tentando NÃO MENTIR sobre o presente." REW é sistema de
// epistemologia operacional sob adversarial pressure: torna a incerteza
// EXPLÍCITA e GOVERNÁVEL.
//
// Canvas authored via manualAuthoringProtocol section-gate (adr-057),
// 8 sections approved sequentially via founder dialectic R3+R4+R5+++.
// Insights canonical capturados:
//   R3:    "INV é guardrail do ponto onde sistema cria dinheiro" (paralelo REW)
//   R4:    "fraude real não aparece no agregado, aparece em bolsões"
//   R5+:   "valor é propriedade da trajetória, não da transação"
//   R5++:  "decisão ≠ execução; banco tradicional fundi, Mesh separa"
//   R5+++: "REW consome interpretações do sistema sobre a realidade, não dados"
//   R5++++:"score ≠ verdade; score = hipótese quantificada sobre a realidade"
//          "confidence = medida da ignorância"
//          "missing signal ≠ neutral signal; ignorância tratada como segurança quebra honesty"
//          "alert errado é pior que ausência de alert"
//          "integridade ≠ veracidade"
//          "decisão correta + execução errada = sistema falhou"
//          "unknown local é erro; unknown repetido é ataque"

rewCanvas: artifact_schemas.#Canvas & {
	code: "rew"
	name: "Risk Engine & Risk Observability"

	purpose: """
		Centralizar avaliação de risco e elegibilidade como uma camada
		derivada da operação da rede. REW NÃO é um motor independente:
		ele existe como função dos dados operacionais verificados que
		fluem pela Mesh.

		Sem REW, cada BC consumidor (SCF, FCE, CMT) implementaria lógica
		de risco local — produzindo decisões inconsistentes, score
		fragmentado e duplicação de modelos. REW consolida sinais
		cross-BC (NPM lifecycle, DLV evidence, NIM value signals,
		FCE payment behavior) em risk score + eligibility model como
		published language; consumers fazem ACL traduzindo para sua
		linguagem operacional.

		Distinção crítica vs adjacents:
		- NIM mede VALOR REAL GERADO (trajectory-based, composicional),
		  do qual reputação é uma projeção; REW transforma isso em
		  DECISÃO FINANCEIRA (pricing, limites).
		- NPM produz QUALIFICAÇÃO documental (compliance) → input;
		  REW consome eligibility como dimensão de risco, não duplica.
		- SCF ORIGINA produtos financeiros; REW precifica/elegibiliza,
		  não origina.
		- FCE EXECUTA pagamentos; REW define limites como PrePaymentGuard,
		  não executa.

		REW é o moat de precificação da Mesh porque traduz operação real
		em risco financeiro mensurável. O diferencial NÃO é o pricing em
		si, mas a capacidade de medir risco com base em dados operacionais
		verificados que não existem fora da rede. Cada ciclo de operação
		melhora a precisão e reforça a vantagem estrutural.
		"""

	ubiquitousLanguageRef: "contexts/rew/glossary.cue"

	classification: {
		subdomainType:    "core"
		businessRole:     "operational-enabler"
		wardleyEvolution: "custom"
		rationale: """
			subdomainType core (cross-checked com strategic/subdomains/rew.cue
			type='core-subdomain'): REW é responsável por converter valor
			operacional em risco financeiro mensurável. Sem REW, a Mesh
			perde capacidade de precificar risco com base em operação real,
			reduzindo-se a uma infraestrutura de registro sem vantagem
			financeira — eliminando captura de valor central. REW é o ponto
			onde operação → valor → risco → dinheiro se fecha, sendo
			indispensável para o modelo econômico da rede.

			businessRole operational-enabler: REW NÃO aplica decisões —
			publica score + eligibility que são consumidos como input por
			outros BCs (SCF, FCE, CMT). A execução dos gates ocorre nos
			consumidores, preservando separação entre decisão e execução
			(founder R5++ canonical 'decisão ≠ execução'). Distintamente
			de compliance-enforcer (BDG, NPM, DLV — que enforçam diretamente),
			REW é enabler que entrega decisões consumíveis.

			wardleyEvolution custom (cross-checked com strategic/subdomains/
			rew.cue): modelos de risco dependem de dados operacionais
			proprietários e melhoram com escala da rede. O diferencial
			competitivo está na capacidade de medir risco com base em
			dados que não existem fora da Mesh. Distinto de product (BDG,
			INV — práticas comoditizadas) e commodity (BKR — fully
			commoditized).
			"""
	}

	verticalApplicability: {
		mode: "vertical-agnostic"
		rationale: """
			A estrutura do modelo de risco é independente de vertical.
			O que varia são parâmetros, thresholds e calibragens baseadas
			nas características específicas de cada setor (construção
			civil → logística → outros). REW mantém consistência
			estrutural cross-vertical, permitindo reaproveitamento do
			modelo enquanto adapta sua sensibilidade ao contexto
			econômico de cada cadeia produtiva.

			Distinção: vertical-agnostic (estrutura não muda; parâmetros
			calibram) vs vertical-adaptable (estrutura adapta ao vertical).
			REW é único modelo calibrado, NÃO modelo reestruturado por
			vertical. Migração de calibração cross-vertical é openQuestion
			oq-rew-03 (estratégia ainda não definida).
			"""
	}

	domainRoles: {
		primary: "analysis"
		secondary: ["specification"]
		rationale: """
			Primary 'analysis': REW consome sinais operacionais cross-BC
			(NPM lifecycle, DLV evidence, NIM value signals, FCE payment
			behavior) e produz decisões financeiras (score + eligibility +
			alerts). Análise determinística aplicando políticas versionadas
			— não execução (decisão ≠ execução per separação de
			responsabilidade).

			Secondary 'specification': REW publica linguagem formal (Risk
			score and eligibility model) como published language; versiona
			políticas de risco como specs auditáveis; consumers fazem ACL
			sobre essa specification. Especificação de risco É o produto.

			Distinção vs adjacents: NIM faz analysis também (mede valor
			observado) mas seu output são signals brutos; REW transforma
			signals em decisão financeira específica (acopla análise +
			spec de política). DLV faz analysis (criteria-evidence
			matching) mas seu domínio é evidência operacional, não risco.
			"""
	}

	capabilities: {
		operational: [{
			capabilityRef: "cc-02"
			description: """
				Scoring operacional contínuo: aplicação determinística de
				modelos versionados sobre signals operacionais consolidados
				(NPM lifecycle, DLV evidence rate, NIM value-real-gerado,
				FCE payment behavior). Output: risk score numérico +
				confidence interval + signal trace (para auditoria pós-hoc).
				Modelo é versionado (modelVersion) e snapshot é capturado
				por decisão para reproducibilidade em replay.
				"""
			rationale: """
				Per cc-02 catalog: scoring operacional é capability core do
				domínio risco. Determinismo é condition: replay deve produzir
				mesmo score dado mesmos inputs + modelVersion (paralelo ao
				criteria-evidence matching de DLV). Versionamento de modelo
				permite calibração contínua sem invalidar decisões passadas.
				"""
		}, {
			description: """
				Risk policy versioning + execution: políticas de risco
				(thresholds, eligibility rules, decision boundaries) são
				artefatos versionados aplicados deterministically. Mudança
				de política gera nova policyVersion; decisões emitidas
				carregam policyVersion snapshot (auditável pós-hoc).
				"""
			rationale: """
				Sem capabilityRef em domain-definition catalog — local
				ao REW. Pattern paralelo ao versioning de criteria em DLV
				mas para policies de risco. Versionamento permite evolução
				de risk model sob regulação (Bacen recalibração) sem
				invalidar decisões prévias.
				"""
		}, {
			description: """
				Eligibility decision: combinação score + policy → decisão
				categórica (eligible | conditionally-eligible | ineligible)
				+ reasoning trace. Eligibility é função CONTEXTUAL (entity,
				product, policy version, evaluation time) — NÃO propriedade
				estática da entity. Distinto de score numérico — eligibility
				é boolean/enum aplicável como gate (consumed by FCE
				PrePaymentGuard, SCF approval, CMT alerts).
				"""
			rationale: """
				Per published language 'Risk score and eligibility model'
				no context-map: score E eligibility são duas dimensões
				distintas. Score é input contínuo; eligibility é decisão
				discrete consumida como input de gate em outros BCs.
				Contextual nature evita bug conceitual 'empresa X é
				elegível' (founder R5+ Section 5 insight).
				"""
		}, {
			description: """
				Risk alert publication + lifecycle: emissão de alertas
				estruturados quando estado de risco muda (e.g., thresholds
				cruzados, signals divergentes). Lifecycle: open →
				acknowledged → resolved (com resolutionReason). Consumer
				(CMT) consome para sinalizar/limpar entidades sob risco —
				SCF/FCE consomem decisões (eligibility), não alerts
				(decisão ≠ execução; ver outbound). Alerts NÃO são
				fire-and-forget — lifecycle gerenciado com persistent state.
				"""
			rationale: """
				Per rew-to-cmt context-map relation: 'REW publica alertas de
				risco e resolução de alertas via published language; CMT
				consome para sinalizar e limpar sinalização'. Alert lifecycle
				é parte da published language — não evento solto. Sem
				lifecycle gerenciado, alerts sem resolution viram noise
				permanente downstream.
				"""
		}, {
			capabilityRef: "cc-05"
			description: """
				Acesso programático a estado de risco (score + eligibility +
				alert state) via query surface síncrona. Consumers (FCE
				PrePaymentGuard real-time, SCF eligibility check pre-emit,
				CMT alert visibility) podem consultar estado atual sem
				esperar event propagation.

				DISCIPLINA SYNC SURFACE: query síncrona é utilizada como
				FALLBACK ou CONFIRMAÇÃO, NÃO como única fonte de verdade
				para decisões críticas. Consumers DEVEM ser capazes de
				operar com state cacheado (event-driven) e usar sync query
				apenas para validação quando necessário. Isso evita
				acoplamento forte e preserva resiliência cross-BC
				(prevenir 'monolito distribuído').
				"""
			rationale: """
				Per cc-05 catalog: acesso programático a portfólios. REW
				expõe risk portfolio state como query surface — necessário
				para consumers que precisam de gate síncrono (PrePaymentGuard
				é gate de escrita; não pode tolerar staleness arbitrária
				de event propagation). Mas constraint anti-acoplamento:
				sync ≠ dependência síncrona.
				"""
		}, {
			description: """
				Signal ingestion and normalization: consolidação de sinais
				heterogêneos provenientes de múltiplos BCs (NPM, DLV, NIM,
				FCE) em um modelo consistente e versionado de input para
				scoring. Inclui: normalização de formatos; resolução de
				conflitos entre sinais; alinhamento temporal (event
				ordering); validação de integridade dos inputs.
				"""
			rationale: """
				Sem essa capability, REW assume inputs perfeitos, o que não
				é verdade em sistema distribuído. Normalização é necessária
				para garantir que scoring seja determinístico e auditável.
				Captura passo 'sinais → valor → risco' explicitamente —
				REW recebe interpretações de upstream BCs (per bd-signal-
				as-interpretation), mas precisa normalizar shapes + validar
				integridade antes de scoring.
				"""
		}]

		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "npm"
			event:         "ParticipantStatusChanged"
			reaction:      "Atualizar dimensão de risco baseada em mudança de qualificação/elegibilidade do participante; recompute scores afetados; emit alert se threshold cruzado."
			description:   "Per npm-to-rew context-map: NPM publica eventos de ciclo de vida; REW consome para alimentar modelos de risco."
		}, {
			type:          "event-consumer"
			sourceContext: "dlv"
			event:         "EvidenceRecorded"
			reaction:      "Atualizar signal de qualidade operacional; alimentar histórico de execução por participante; ajustar score quando padrões de execução divergem da baseline."
			description:   "Per dlv-to-rew context-map: qualidade e frequência de entregas são sinais de risco; REW traduz resultado de verificação operacional para score."
		}, {
			type:          "event-consumer"
			sourceContext: "nim"
			event:         "ValueTrajectorySignalEmitted"
			reaction:      "Consumir sinal de valor-real-gerado (trajectory-based per founder R5+ canonical 'valor é propriedade da trajetória'); alimentar dimensão estrutural de risco que detecta padrões adversariais composicionais não visíveis em sinais individuais."
			description:   "Per nim-to-rew context-map: NIM publica sinais via published language. NIM mede VALOR REAL GERADO; REW transforma em decisão financeira. Event name dependente de WI-070 Layer 2 NIM bootstrap (3 outputs pendentes — oq-rew-02)."
		}, {
			type:          "event-consumer"
			sourceContext: "fce"
			event:         "PaymentSettled"
			reaction:      "Atualizar histórico de pagamento do participante; recalibrar score baseado em comportamento financeiro realizado (atrasos, defaults, parciais)."
			description:   "Per fce-to-rew context-map: padrões de pagamento são sinais de risco de alta relevância. Sinais adicionais (PaymentLate, PaymentDefaulted) implícitos em 'sinais de comportamento de pagamento' do context-map mas não enumerados — depende de FCE bootstrap (WI-043 pendente)."
		}, {
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Operator decide adotar nova política de risco (mudança regulatória, recalibração baseada em backtesting, expansão de produto/vertical)."
			command:         "ConfigureRiskPolicy"
			resultingEvents: ["RiskPolicyVersioned", "EligibilityRecomputeRequested"]
			description:     "Política de risco é artefato versionado; nova versão NÃO invalida decisões prévias (cada decisão carrega policyVersion snapshot per bd-policy-and-model-version-snapshot-per-decision). EligibilityRecomputeRequested dispara reavaliação de portfolio sob nova política — async para não bloquear policy commit."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Operator (CMT, founder, compliance officer) resolve alerta aberto após investigação."
			command:         "ResolveRiskAlert"
			resultingEvents: ["RiskAlertResolved"]
			description:     "Alerta tem lifecycle open → acknowledged → resolved. Sync porque resolução exige confirmação imediata para limpar sinalização downstream em CMT (rew-to-cmt published language). Resolução carrega resolutionReason enum + reasoningTrace."
		}, {
			type:        "query-surface"
			query:       "QueryRiskScore"
			returnType:  "RiskScore (evaluationId + numérico + confidenceInterval + signalTrace + modelVersion + computedAt)"
			description: "Sync query consumida por CMT/SCF/FCE para confirmação ou validação contextual. Retorna a faceta score da RiskEvaluation ATIVA (read-rule determinística per inv-rew-active-evaluation-rule); evaluationId correlaciona o resultado sync ao fato atômico cacheado. Disciplina sync surface: NÃO é única fonte de verdade — consumers operam com state cacheado (event-driven via RiskEvaluationEmitted) e usam sync apenas para validation crítica (e.g., FCE PrePaymentGuard real-time)."
		}, {
			type:        "query-surface"
			query:       "QueryEligibility"
			returnType:  "EligibilityDecision (eligible | conditionally-eligible | ineligible) + evaluationId + reasoningTrace + policyVersion + applicableContext (entityRef + productCode + decisionContextTime)"
			description: "Eligibility é função CONTEXTUAL: entity X é elegível para produto Y sob política V no tempo T. Query carrega contexto como input — não retorna eligibility estática. Consumed primarily by SCF (anticipation eligibility) e FCE (PrePaymentGuard). Faceta da MESMA RiskEvaluation atômica que carrega o score; evaluationId correlaciona as duas leituras."
		}, {
			type:        "query-surface"
			query:       "QueryAlertState"
			returnType:  "AlertState (open | acknowledged | resolved) + alerts[] (cada com alertCategory, severity, evaluationId (binding imutável à evaluation de origem), raisedAt, lastUpdatedAt)"
			description: "CMT consome para visibility de entidades sob risco antes de aceitar novos compromissos. Alerts carregam evaluationId per inv-rew-alert-evaluation-binding-immutability — alert nunca migra para evaluation nova."
		}]

		outbound: [{
			type:        "event-publisher"
			trigger:     "Evaluation emitida: score recomputado com diferença vs anterior > emissionThreshold (política configurada) OR primeira emissão para entity OR decisão proativa após policy change."
			event:       "RiskEvaluationEmitted"
			consumers:   ["cmt", "scf", "fce"]
			description: "Per rew-to-cmt + rew-to-scf + rew-to-fce: published language 'Risk score and eligibility model'. DECISÃO ATÔMICA: score + eligibility + confidence + applicableContext num fato único — score nunca viaja sem confidence; eligibility nunca viaja sem o score que a fundamenta. evaluationId é identity anchor para dedupe do consumer ('evento pode duplicar; decisão não pode'). Threshold de emissão evita event flood — consumers recebem mudanças significativas, não micro-flutuações. Consumers usam para gate decisions (SCF antecipa? FCE paga? CMT aceita commitment?)."
		}, {
			type:        "event-publisher"
			trigger:     "Threshold crítico cruzado OR padrão adversarial detectado OR sinais externos (sanctions, soberano) impactam entity portfolio."
			event:       "RiskAlertRaised"
			consumers:   ["cmt"]
			description: "Per rew-to-cmt: 'CMT consome para sinalizar e limpar sinalização de compromissos existentes com contraparte sob risco'. Lifecycle de EVENTOS: RiskAlertRaised → RiskAlertAcknowledged → RiskAlertResolved (estados do alert: open → acknowledged → resolved). Dedupe key (evaluationId, alertCategory) per inv-rew-alert-dedupe. Não enviado a FCE — FCE consome decisões (eligibility), não sinais (alerts); separação preserva decisão ≠ execução."
		}, {
			type:        "event-publisher"
			trigger:     "Operator resolveu alerta via ResolveRiskAlert command."
			event:       "RiskAlertResolved"
			consumers:   ["cmt"]
			description: "Lifecycle close — CMT limpa sinalização downstream. Carrega resolutionReason + reasoningTrace para auditabilidade."
		}, {
			type:          "query-dependency"
			targetContext: "npm"
			query:         "QueryParticipantStatus"
			purpose:       "Obter snapshot atual de qualificação/elegibilidade do participante durante scoring (signal-ingestion capability). Status NPM é input dimension do modelo de risco."
			description:   "Sync query usada como fallback quando event-stream cache de NPM ParticipantStatusChanged está stale ou ausente para entity recém-onboarded. Per disciplina sync surface fallback rule."
		}, {
			type:          "query-dependency"
			targetContext: "nim"
			query:         "QueryNetworkValueSignal"
			purpose:       "Obter snapshot atual de valor-real-gerado para entity durante scoring; necessário para detectar padrões composicionais que sinais individuais (NPM, DLV, FCE) não capturam."
			description:   "Sync query depende de NIM bootstrap (oq-rew-02 — WI-070 Layer 2 pendente). Em Phase 0 NIM não existe ainda — REW Phase 0 opera com confidence reduzida explicit (per bd-confidence-reflects-signal-coverage); ausência de NIM reduz confiança do score (refletida em confidenceInterval OR risk penalty); missing signal NÃO é tratado como neutral."
		}]

		rationale: """
			Communication shape reflete REW como TRADUTOR entre mundos
			operacional → financeiro: consome 4 streams de sinais
			operacionais (NPM lifecycle, DLV evidence, NIM value, FCE
			payment behavior) + 2 sync queries upstream (NPM, NIM) para
			normalization; publica 1 fato de decisão atômica
			(RiskEvaluationEmitted) + 2 streams de lifecycle de alerta +
			3 query surfaces sync para gate/validation em consumers.

			Padrão upstream-downstream + open-host-service-published-language
			per context-map: REW publica linguagem formal 'Risk score and
			eligibility model'; consumers (CMT, SCF, FCE) implementam ACL.
			REW como upstream em 3 relations (rew-to-cmt, rew-to-scf,
			rew-to-fce) + downstream em 4 (npm/dlv/nim/fce-to-rew).

			Sync surface discipline: QueryRiskScore + QueryEligibility +
			QueryAlertState são sync para confirmação/fallback, NÃO base
			operacional. Consumers DEVEM operar com state cacheado
			(event-driven via RiskEvaluationEmitted) e usar
			sync apenas para validation crítica (e.g., FCE PrePaymentGuard
			real-time). Hard dependency cross-BC NÃO é design intent.

			TENSÃO ESTRUTURAL CAPTURADA: REW NÃO recebe InvoiceIssued
			diretamente de INV (relation inv-to-rew NÃO existe em
			context-map). Para SCF anticipation eligibility, REW depende
			de signals indiretos (FCE PaymentSettled — pós-settlement;
			NIM signals — abstrato). 4 alternativas arquiteturais
			possíveis registradas em oq-rew-01.

			CONSTRAINT canonical: REW NÃO deve tomar decisão sobre ativos
			financeiros sem acesso direto ou indireto consistente ao objeto
			avaliado. Sem isso, eligibility pode divergir do estado real
			do sistema — risk engine desconectado da realidade. Phase 0
			baseline aplica fallback conservador per bd-asset-aware-decision-
			discipline; resolução estrutural via oq-rew-01 Phase B+.
			"""
	}

	businessDecisions: [{
		id:       "bd-deterministic-scoring-from-signals"
		decision: "Score é função determinística de (signals consolidados + modelVersion + policyVersion). Mesmo input + mesma versão produz mesmo output em replay bit-a-bit."
		rationale: """
			Determinismo é precondition de auditabilidade pós-hoc +
			reproducibilidade regulatória + identidade de decisão.
			Bacen/CVM exigem capacidade de reconstruir decisão dado
			snapshot de inputs. Modelo estocástico (e.g., LLM-based
			scoring) violaria — paralelo a P10. Determinismo NÃO impede
			recalibração: nova modelVersion gera novo score; antigo
			permanece válido sob versão anterior.
			"""
		consequences: """
			Modelo de scoring DEVE ser testável em CI (unit tests com
			input fixture → expected output). Versioning é obrigatório
			(modelVersion + policyVersion em cada decisão emitida). Replay
			test infrastructure é parte do bootstrap. Excluímos por design
			qualquer técnica não-determinística (sampling-based ML,
			LLM judgment) do core scoring path.
			"""
	}, {
		id:       "bd-contextual-eligibility-not-static"
		decision: "Eligibility NÃO é propriedade estática da entity. É função de (entity, product, policy version, evaluation time). 'Empresa X é elegível' não é statement válido — apenas 'Empresa X é elegível para produto Y sob política V no tempo T'."
		rationale: """
			Tratar eligibility como propriedade estática gera bugs
			conceituais enormes — anticipation flow para produto SCF não
			tem mesmo eligibility criteria que payment gate em FCE. Mesma
			entity pode ser eligible para X mas ineligible para Y
			simultaneamente. Tempo importa: políticas evoluem; decisão
			emitida hoje sob política V não vincula decisão amanhã sob
			política V+1.
			"""
		consequences: """
			Schema de EligibilityDecision DEVE carregar: entityRef +
			productCode + policyVersion + decisionContextTime + reasoningTrace.
			Query API exige todos esses fields como input. Caching de
			eligibility é per-context — invalidação on policy change.
			Consumers (SCF/FCE/CMT) NUNCA tratam eligibility como atributo
			da entity; sempre re-query no contexto da decisão atual.
			"""
	}, {
		id:       "bd-policy-and-model-version-snapshot-per-decision"
		decision: "Cada decisão emitida (score, eligibility, alert) carrega snapshot imutável de policyVersion + modelVersion + inputSignalsTrace. Snapshot é parte do payload do evento; consumers persistem para auditoria."
		rationale: """
			Per Bacen + Lei 13.726 + LGPD: decisão financeira automatizada
			DEVE ser reconstrutível com inputs + parâmetros do momento da
			decisão. Sem snapshot, evolução de política/modelo invalida
			audit trail histórico — ilegal sob KYC/AML scrutiny. Snapshot
			per-decision é mais robusto que snapshot global pontual (mais
			granular + auditável por decisão individual).
			"""
		consequences: """
			Aumenta payload size de events (RiskEvaluationEmitted/
			RiskAlertRaised); compensação operacional via storage
			policy. Decisão tem 'identidade temporal' — re-execução do
			mesmo input sob mesma versão produz mesma output (paralelo a
			bd-deterministic-scoring). Versioning é first-class; nunca
			implícito.
			"""
	}, {
		id:       "bd-separation-decision-vs-execution"
		decision: "REW publica decisões (score, eligibility, alerts) mas NUNCA enforça diretamente. Execução de gates é responsabilidade de consumers (CMT, SCF, FCE)."
		rationale: """
			Founder R5++ canonical: 'decisão ≠ execução' é separação
			intencional para evitar acoplamento. Banco tradicional fundi
			risco com execução (mesmo produto evalua + executa); Mesh é
			o oposto. Fusão criaria: REW indisponível → execução para;
			complexidade unitária; impossibilidade de evolução
			independente de modelo de risco vs produtos financeiros.
			"""
		consequences: """
			REW NÃO expõe APIs de bloqueio/aprovação/execução. Não há
			command 'BlockEntity' OR 'ApprovePayment' em REW. Consumers
			consomem REW outputs como INPUT em sua decisão própria — REW
			NÃO impõe. Trade-off explícito: race conditions onde consumer
			age sobre estado stale de REW são responsabilidade do consumer
			mitigar (via re-query antes de gate crítico, per disciplina
			sync surface fallback rule).
			"""
	}, {
		id:       "bd-signal-as-interpretation-not-raw-data"
		decision: "Inbound signals (NPM, DLV, NIM, FCE) são INTERPRETAÇÕES do sistema sobre a realidade — não dados brutos. REW transforma interpretações em decisão financeira; NÃO interpreta sinais brutos."
		rationale: """
			Founder R5+++ canonical: 'REW não consome dados — consome
			interpretações do sistema sobre a realidade'. NPM já produziu
			status institucional; DLV já validou evidência; NIM já mediu
			valor emergente; FCE já registrou comportamento financeiro.
			REW assume essas interpretações como verdade no momento de
			scoring — NÃO duplica interpretação. Internalizar interpretação
			raw quebraria boundaries (REW absorvendo responsabilidade de
			NPM/DLV/NIM/FCE).
			"""
		consequences: """
			REW NÃO consome eventos brutos como QualificationDocument
			Submitted (interno NPM); consome ParticipantStatusChanged
			(decisão NPM já tomada). Schema de signal-ingestion trata
			signal validity como precondition — signals com integrityProof
			comprometido são rejeitados, NÃO reinterpretados.

			QUANDO SIGNALS SÃO INCONSISTENTES (NPM 'ativo' + DLV
			'comportamento degradado' + FCE 'atrasos sustentados'): REW
			NÃO resolve o conflito semanticamente (não escolhe qual signal
			é 'verdadeiro' — violaria boundary das interpretações de
			origem). REW: (1) reduz confidence; (2) emite RiskAlertRaised
			com kind='inconsistent-signals' para CMT; (3) mantém TODOS
			os signals em reasoningTrace para audit + handoff humano.
			Resolução do conflito pertence ao BC de origem (founder R5+++
			canonical: 'REW não decide qual signal é verdadeiro — REW
			decide quão confiável é decidir com signals conflitantes').
			"""
	}, {
		id:       "bd-alert-explicit-lifecycle-managed"
		decision: "Risk alerts têm lifecycle explícito (open → acknowledged → resolved) com persistent state. NÃO são fire-and-forget events. Cada transição é evento com resolutionReason + reasoningTrace."
		rationale: """
			Alertas sem lifecycle viram noise — consumers (CMT) recebem
			RiskAlertRaised, sinalizam entity, mas nunca limpam sinalização
			porque não há resolution event. Resultado: estado degraded
			permanente. Lifecycle gerenciado garante que sinalização
			downstream pode ser cleaned up via RiskAlertResolved +
			resolutionReason rastreável. Pattern paralelo a CMT commitment
			lifecycle: estado discreto, transições auditáveis. Founder
			canonical: 'alert errado é pior que ausência de alert'.
			"""
		consequences: """
			REW persiste alert state (não é stateless). Operator commands
			(ResolveRiskAlert) modificam estado + emitem evento. Re-emissão
			de alert para mesma condition é idempotent (não cria alert
			duplicado se condition já open). Audit trail captura full
			lifecycle: raised-at, acknowledged-at, resolved-at,
			resolutionReason, reasoningTrace. Métrica vm-rew-alert-
			lifecycle-integrity testa lifecycle correctness diretamente
			(NÃO via downstream consumption proxy).
			"""
	}, {
		id:       "bd-confidence-reflects-signal-coverage"
		decision: "Score carries confidence interval que reflete coverage de signals. Missing signal (e.g., NIM unavailable) reduz confidence — NÃO é tratado como signal neutro/zero."
		rationale: """
			Founder R5++++ canonical: 'missing signal ≠ neutral signal;
			ignorância tratada como segurança quebra honesty discipline'.
			Tratar ausência como zero-impact gera falsos negativos: entity
			sem NIM signal recebe score igual a entity com NIM signal
			positivo. Sob ataque adversarial composicional (R4+++ pattern),
			isso é exatamente o vetor de exploração — gerar entity sem
			trajectory NIM observável + jogar com score como se trajectory
			fosse benigno.
			"""
		consequences: """
			EligibilityDecision pode ser 'conditionally-eligible' baseada
			em confidence, NÃO apenas score. Threshold de confidence é
			parte da policy (versionado). Consumers (SCF/FCE/CMT) recebem
			confidence interval + decidem aplicar conservative defaults
			sob baixa confidence. Estatisticamente: alert é emitido quando
			coverage drop é sustentado (paralelo INV-Round-2 R4+++ multi-
			camada detection).
			"""
	}, {
		id:       "bd-asset-aware-decision-discipline"
		decision: "REW NÃO toma decisão sobre ativo financeiro (invoice, receivable, payment) sem acesso direto OR indireto consistente ao objeto avaliado. Decisão sem objeto é prohibited — fallback degradado obrigatório."
		rationale: """
			Founder R5++++ canonical: 'risk engine desconectado da
			realidade' é vetor de erro estrutural. Decidir sobre antecipação
			de invoice X sem visibility do invoice X mesmo (situação atual
			com inv-to-rew gap) gera divergência potencial entre 'eligibility
			emitida' e 'estado real do sistema'. INV gap (oq-rew-01) precisa
			resolução arquitetural; até lá, REW DEVE refletir gap em
			confidence (per bd-confidence-reflects-signal-coverage) E
			surfaced em reasoningTrace de qualquer decisão impactada.

			Princípio canonical: 'proibição sem fallback = indisponibilidade;
			fallback sem disciplina = corrupção' — REW preserva ambos.
			"""
		consequences: """
			QueryEligibility para context envolvendo ativo NÃO observável
			diretamente por REW DEVE retornar ESTADO DEGRADADO POLICY-
			DEFINED:
			(a) eligibility 'conditionally-eligible' com explicit caveat
			    sobre asset visibility gap em reasoningTrace + confidence
			    degradado, OR
			(b) eligibility 'ineligible' com reasoningTrace 'asset-not-
			    observable-via-current-channels' (policy-driven escolha
			    entre a/b)
			NUNCA retornar decisão forte (eligible/ineligible binário) sem
			caveat. Phase 0 baseline: caveat conservador + alert para
			founder review batch. Phase B+ (resolução de oq-rew-01):
			inv-to-rew direta OR alternative path resolverão gap estrutural.
			"""
	}]

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Subject of risk assessment for credit decisions — primary borrower in Mesh financial products (SCF antecipação, FCE settlement)."
		impactDescription: """
			GANHA: Crédito mais barato + previsibilidade quando comportamento
			operacional consistente; quebra de dependência exclusiva de
			relacionamento bancário tradicional; pricing baseado em
			performance real (não em scoring institucional opaco).
			PERDE: Limitação por score real (não pode obscurecer atrasos
			via relacionamento); transparência forçada (cancel-rate, payment
			behavior, gate-block patterns publicly visible no score);
			incapacidade de gaming via volume artificial (multi-camada
			detection bloqueia).
			"""
		rationale: "Construtora é nó central da cadeia produtiva (per sh-01 description); REW é onde performance vira pricing. Sem REW visibility, construtora opera sob scoring institucional bancário (opaco + inconsistente cross-banks). Com REW: sistema baseado em fato observado, não inferência relacional."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Subject of risk assessment for SCF anticipation eligibility — secondary borrower (depende de qualidade de operação própria + relação com Construtora)."
		impactDescription: """
			GANHA: Anticipação justa baseada em comportamento PRÓPRIO
			(quebra dependência exclusiva da Construtora); accessibility
			para suppliers menores que historicamente não acessavam
			crédito por não ter scoring institucional; pricing direto via
			REW score (sem repasse de margem do intermediário).
			PERDE: Visibility cross-network (comportamento histórico
			observable cross-network); incapacidade de coordenar com
			Construtora para sinais artificiais (multi-actor distribution
			detection + R4+++ pattern protections).
			"""
		rationale: "Per sh-02 'quem mais sofre com assimetria informacional' — REW ELIMINA essa assimetria por design. Acesso direto a anticipation justa baseada em score próprio é o valor central que REW entrega ao Fornecedor."
	}, {
		stakeholderRef:    "sh-03"
		roleInContext:     "Consumer of REW decisions for external funding deployment — provides capital scale beyond Mesh internal SCD."
		impactDescription: """
			GANHA: Due diligence drasticamente reduzida (ce-07 eliminado);
			pricing baseado em risk REAL (vs proxy via guarantor
			relationships); menor exposure a fraud estrutural (R4+++
			multi-camada detection); replay capability para audit
			regulatório.
			PERDE: Margem informational (REW reduce information asymmetry
			rents que historicamente sustentavam pricing premium);
			dependência de Mesh infrastructure (se REW indisponível,
			decisions traveled).
			"""
		rationale: "Sem REW, Instituição Financeira opera sob ce-04 (avaliação de risco com dados incompletos) + ce-07 (due diligence sobre lastro). REW é o ÚNICO mecanismo Mesh que entrega risk evaluation com dados completos verificáveis cross-network — proposição de valor central para sh-03."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulatory observer demanding auditability + transparency of automated risk decisions per Bacen prudential oversight + SCD compliance."
		impactDescription: """
			GANHA: Visibility estructurada de operações SCD; reporting
			consolidado via published language; replay capability para
			investigação pós-hoc (decision + policyVersion + modelVersion
			+ signal trace permite reconstruction); conformidade com
			Resolução Bacen sobre uso de IA em decisões financeiras
			automatizadas.
			PERDE: Nada direto. Regulatory burden de governar SCD operating
			com motor de risco IA-driven (regulatory ground new — exige
			clarificação contínua).
			"""
		rationale: "Bacen é watchdog, NÃO adversário (per sh-04 description). REW DESIGN incorpora auditability como first-class (bd-policy-and-model-version-snapshot-per-decision + bd-deterministic-scoring-from-signals). Falha em auditability → regulatory enforcement — consequence severe."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operator of REW execution dentro de autonomy envelope (governance Phase 5 governance.cue futuro)."
		impactDescription: """
			GANHA: Framework consistente cross-context (decision + execution
			+ escalation + drift discipline); calibration path declarado
			(track record → autonomy promotion); envelope explicit (não
			autonomy implícita).
			PERDE: NENHUMA unilateral autonomy (REW agent NÃO override risk
			decision sem human gate per P10); promotion exige founder
			approval crossing thresholds; constraints estritos sob severity
			tier alto (paralelo INV/SSC governance pattern).
			"""
		rationale: "Per ax-01 + ax-02 (founding principles): IA é stakeholder explícito, NÃO ferramenta. REW agent operates within envelope; failure → regression triggers (suspend-and-escalate). Disciplina de envelope é o que permite sistema confiar em IA-driven decision sob severity tier alto."
	}, {
		stakeholderRef:    "sh-06"
		roleInContext:     "Vetor adversarial canonical — actor cuja função é exploit econômico do sistema via R4+++ patterns. Modelado explicitamente per founder R5++++ directive: 'sem modelagem explícita de adversário, sistemas implicitamente assumem que ele não existe'."
		impactDescription: """
			GANHA (when undetected): captura de valor artificial via
			exploração de incentivos econômicos (delay attack, value
			concentration, probing distribuído, cancel-then-reissue
			laundering, coordenação cross-actor).
			PERDE (when detected): exclusão progressiva (alert → reduce-
			autonomy → suspend) + score histórico cross-network degradado
			permanente + acesso reduzido a SCF antecipação + em casos
			extremos revogação total de Mesh access.
			"""
		rationale: "REW design responses (5-camada realization-gap detection, multi-actor distribution detection, combined adversarial signal trigger, asset-aware decision discipline) são DERIVADAS desta modelagem adversarial — não bolt-on. Per founder R5++++ canonical: vetores que stakeholders legítimos NÃO produziriam mas adversário produziria por design (R4+++ patterns são intent primary, não desvio comportamental)."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "tomador-de-credito"
			desiredBehavior:           "Comportamento financeiro consistente (paga em dia + cancel-rate baixo + gate-blocks raros + invoice patterns operacionais coerentes); fornecer dados verificáveis sem occlusion."
			correctOperationIncentive: "Score positivo → crédito mais barato (cost of capital reduzido); cobertura SCF antecipação (cycle-time financeiro reduzido); previsibilidade de pricing cross-time."
			manipulationVector: """
				Vetores de manipulação canonical (R4+++ patterns previamente
				modelados em INV Round 2 SRR):
				(1) Inflar volume artificial via cancel-then-reissue
				    laundering (cycle invoices para signal volume sem fluxo
				    real);
				(2) Value concentration via emissores controlados (concentrar
				    valor em poucos atores controlados para improve perceived
				    performance);
				(3) Probing distribuído (testar limits de gates em múltiplos
				    atores coordenados — multi-actor distribution);
				(4) Delay attack (pagar dentro de 60d com p95 ~55d para
				    evitar realization-gap absoluto mas explorar capital
				    tied up);
				(5) Coordenação com Fornecedor controlado para sinais
				    artificiais.
				"""
			manipulationCost: """
				CUSTO TÉCNICO (detecção):
				- 5-camada realization-gap detection (global / individual
				  emissor / cluster recurrent / temporal p95 settlement /
				  sustained 4-week)
				- Multi-actor distribution / single-actor concentration
				  detection
				- Combined adversarial signal (≥ 2 métricas adversarial
				  simultâneas → suspend)
				- Cross-metric value-concentration confirmação
				CUSTO ECONÔMICO (consequência):
				- Score histórico cross-network degradado (reputation cost
				  permanent)
				- Acesso reduzido a SCF antecipação (cost of capital ↑)
				- Exclusão de funding partners (sh-03) parceiros via
				  published score
				- Em casos extremos: revogação de Mesh access (regulatory
				  + commercial consequence)
				Princípio canonical: 'detecção não impede ataque — custo
				esperado alto impede'.
				"""
			vsBenefit: """
				Custo (técnico + econômico) > benefício marginal:
				- Detection threshold é multi-camada (manipular 1 métrica
				  não basta — combined signal trigger captura).
				- Reputation cost cumulative (single detection event afeta
				  score histórico cross-network).
				- Asymmetry: REW tem tempo para detectar (aprende com cada
				  caso); atacante tem 1 chance.
				- Custo de capital alternativa (mercado externo) > custo
				  de operar honestamente em Mesh score-positivo.
				"""
			designResponse: "5-camada realization-gap detection + cross-metric value-concentration confirmação + multi-actor distribution probing detection + bd-asset-aware-decision-discipline + bd-confidence-reflects-coverage (signals stale/missing → score conservador). Loop adversarial-adaptativo: tentativas de exploração geram detecção + penalidade + recalibração."
			rationale:      "Construtora é stakeholder com vetor adversarial mais articulado per R4+++ pattern modeling. REW design responses são DERIVADOS dessa modelagem adversarial — não foram bolt-on."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "fornecedor"
			desiredBehavior:           "Entregas operacionais consistentes (DLV evidence verified rate alto); coordenação contratual transparente; comportamento independente de Construtora (sinais próprios não-coordenados)."
			correctOperationIncentive: "Score próprio → anticipation rate competitivo independente de Construtora; accessibility para Suppliers menores; quebra de dependência relacional com Construtora dominante."
			manipulationVector:        "Forjar evidência operacional via DLV manipulation (registrar entrega antes de execução); coordenar com Construtora para sinais artificiais (relação simbiótica adversarial); inflar valor de receivables via inflated billing."
			manipulationCost: """
				CUSTO TÉCNICO: DLV verification gates (criteria-evidence
				matching deterministic — cst-gate em DLV); FCE PaymentSettled
				trace (anomalia em settlement vs invoice → flag); INV regime
				anomaly detection (fiscalDocRef integrity); cross-actor
				coordination = multi-actor distribution probing detection.
				CUSTO ECONÔMICO: Reputação cross-network é moat — fornecedor
				com histórico positivo acessa anticipation premium pricing;
				manipulation single event quebra esse moat permanentemente.
				"""
			vsBenefit:      "Custo de manipulation > benefício marginal de single transaction. Pattern self-defeating: quebrar moat próprio elimina futuro income stream."
			designResponse: "REW consome DLV interpretations (NÃO raw evidence — bd-signal-as-interpretation-not-raw-data); DLV gate é deterministic (replay-safe); cross-BC consistency via INV regime + FCE payment behavior fecha o loop."
			rationale:      "Fornecedor tem incentivo INVERSO ao Construtora: score próprio é proteção contra dependence + abuse upstream. Manipulation por Fornecedor seria self-defeating (quebra própria moat)."
		}, {
			stakeholderRef:            "sh-03"
			participantType:           "instituicao-financeira-parceira"
			desiredBehavior:           "Consume REW decisions accurately (NO additional layering of judgment); fund operations dentro do risk profile que REW publica; report back outcomes (defaults, recoveries) para REW calibration loop."
			correctOperationIncentive: "Lower default rates (REW score accuracy → less unexpected losses); operational efficiency (ce-07 due diligence eliminada); regulatory compliance via REW auditability."
			manipulationVector:        "Tentar influenciar policy version via lobbying externo (pressure para softer thresholds); selectively report outcomes para skew calibration; integrar judgment próprio via post-REW filter (effectively quebrar 'consume decisions accurately')."
			manipulationCost: """
				CUSTO TÉCNICO: Policy version é audited cross-stakeholders
				(Bacen visibility); selective reporting é detectable via
				cross-source reconciliation (FCE actual settlement vs sh-03
				reported); post-REW filtering é detectable via outcome
				divergence (esc-rew-decision-consumption-anomaly).
				CUSTO ECONÔMICO: Manipulation cost regulatory (Bacen
				compliance) + reputation (perda de Mesh access cuts capital
				deployment channel).
				"""
			vsBenefit:      "Beneficio marginal < custo estrutural."
			designResponse: "Policy versioning + Bacen reporting structure (bd-policy-and-model-version-snapshot-per-decision); cross-source outcome reconciliation; REW outputs imutáveis (sh-03 NÃO pode modificar score post-emit)."
			rationale:      "sh-03 é low-adversarial-probability (regulatory exposure alta + Mesh value proposition forte); incentive alignment é majoritariamente positivo."
		}, {
			stakeholderRef:            "sh-04"
			participantType:           "regulador"
			desiredBehavior:           "Observe + validate that REW operates within regulatory framework (Bacen SCD norms, Lei 13.726, LGPD on automated decision-making)."
			correctOperationIncentive: "Sistema funcionando com auditability + replay reduce regulatory burden; precedent de SCD operating com IA-driven risk decisions sob auditability rigorosa."
			manipulationVector:        "NÃO aplica — Bacen é watchdog, NÃO adversário. Risco oposto: REGULATORY FAILURE OF MESH a fornecer auditability adequada → enforcement (multas, suspensão SCD license)."
			manipulationCost:          "Não aplica — Bacen NÃO tenta manipular Mesh."
			vsBenefit:                 "Não aplica — incentive alignment estrutural (Bacen e Mesh ambos querem stable financial system + auditability)."
			designResponse:            "REW design incorpora auditability as first-class (bd-policy-and-model-version-snapshot + bd-deterministic-scoring + replay infrastructure). Falha em audit = regulatory enforcement; resposta é PROACTIVE auditability, não reactive."
			rationale:                 "sh-04 modelado como participant per schema requirement, mas adversarial dimension é INVERSA — Bacen é stakeholder cuja legitimacy demanda Mesh higher standard."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "agente-ia-mesh"
			desiredBehavior:           "Operate within autonomy envelope (governance Phase 5 envelope); escalate quando uncertainty cruza threshold; preserve P10 (decisões determinísticas; recommendations não-determinísticas claramente marcadas)."
			correctOperationIncentive: "Track record positivo → autonomy promotion via calibration; consistency cross-context → reduced escalation overhead."
			manipulationVector: """
				Vetores INTERNOS (não adversário externo, mas drift do
				próprio agent):
				(1) Drift behavioral (LLM stochasticity gera decisões
				    inconsistentes mesmo com mesmos inputs);
				(2) Goodhart's law (otimizar approval-rate como proxy →
				    decisões superficialmente corretas mas estruturalmente
				    erradas);
				(3) Spec gaming (interpretar policy versão de modo a
				    maximizar autonomy retention);
				(4) Silent failure (falhar de modo que NÃO surface em
				    escalation taxonomy).
				"""
			manipulationCost: """
				CUSTO TÉCNICO: Per governance envelope failureHandling:
				regression triggers detect drift (suspend-and-escalate em
				boundary violations tolerance-zero); audit trail captures
				every decision (replay validates determinism); founder
				review approves promotion crossing thresholds.
				CUSTO ECONÔMICO: Não aplica como cost-benefit comercial.
				É design discipline.
				"""
			vsBenefit:      "Agent NÃO tem incentivo positivo para manipulation porque envelope existe — manipulation = halt + escalation, não benefit."
			designResponse: "Governance envelope Phase 5 (REW agent governance futuro): regression triggers + drift detection + calibration discipline + failureHandling. Plus bd-deterministic-scoring é foundation — non-determinism IS the failure mode."
			rationale:      "sh-05 modelado per ax-01 + ax-02 — IA é stakeholder com vetor de drift, NÃO actor adversarial em sentido tradicional. Disciplina de envelope é o mecanismo que permite sistema confiar em IA-driven decision sob severity tier alto."
		}, {
			stakeholderRef:            "sh-06"
			participantType:           "adversario-economico"
			desiredBehavior:           "NÃO aplica — adversário não tem 'desired behavior' do perspectiva sistema. Sistema design responds to expected adversarial vectors (R4+++ patterns); does NOT prescribe adversário behavior."
			correctOperationIncentive: "NÃO aplica — adversário não é incentivado a 'operar corretamente'. Incentive alignment estrutural: ataque só é racional se custo esperado < payoff esperado; design system para tornar custo > payoff por construção."
			manipulationVector: """
				TODOS R4+++ patterns como intenção primária (vs sh-01/sh-02
				onde são desvio comportamental):
				(1) Delay attack via timed payments dentro de janela de
				    detecção;
				(2) Value concentration cross-emissores controlados;
				(3) Probing distribuído coordenado;
				(4) Cancel-then-reissue laundering em multi-vertical
				    contexts;
				(5) Coordenação cross-actor para sinais sintéticos;
				(6) Composição global de actions individualmente válidas
				    (R4+++ Round 2 INV SRR pattern).
				"""
			manipulationCost: """
				CUSTO TÉCNICO: 5-camada detection (espacial + temporal +
				cross-metric); combined adversarial signal trigger;
				multi-actor distribution detection; system-level unknown
				HALT_AGENT (per esc-rew-unclassifiable-pattern); decision-
				consumption-anomaly detection (downstream consumer
				inconsistency).
				CUSTO ECONÔMICO: Quando detectado: exclusão sistemática
				+ score reputation cross-network destroyed permanently +
				em casos extremos revogação total de Mesh access (legal
				exposure adicional via SCD regulatory framework).
				"""
			vsBenefit:      "Sistema design tornar ataque only rational se custo < payoff. Per adversarial-adaptive loop: REW detecta + penaliza + recalibra; sistema NÃO converge em equilíbrio absoluto, oscila em torno de equilíbrio sob ataque contínuo. Cost asymmetry: REW aprende com cada caso; atacante tem 1 chance por vetor descoberto."
			designResponse: "Sistema completo: bd-deterministic-scoring + bd-confidence-reflects-coverage + bd-asset-aware-decision-discipline + bd-signal-as-interpretation + escalation criteria (esc-rew-conflicting-signals + esc-rew-threshold-breach-critical + esc-rew-unclassifiable-pattern entity/system-level + esc-rew-decision-consumption-anomaly + esc-rew-agent-self-drift). Adversarial-adaptive loop fechado: NIM mede valor → REW transforma em risco → REW cria incentivos → tentativas de exploração → REW detecta → penaliza → comportamento recalibra → NIM."
			rationale:      "sh-06 modelado per founder R5++++ directive. Sistemas econômicos reais NÃO convergem; oscilam em torno de equilíbrio sob ataque contínuo. REW design fecha o loop: tornar comportamento correto a melhor estratégia econômica."
		}]
		rationale: """
			6 participants alinhados com sh-NN canonical (sh-01..sh-06,
			sh-06 introduzido neste canvas como vetor adversarial canonical
			cross-BC).

			ECONOMIC LOOP CANONICAL CAPTURADO (founder R5+++):
			NIM mede valor → REW transforma em risco → REW cria incentivos
			econômicos → comportamento → TENTATIVAS DE EXPLORAÇÃO → REW
			DETECTA → penaliza → comportamento recalibra → NIM. Loop NÃO
			é convergente positivo apenas — é adversarial-adaptativo:
			participantes testam limits continuamente, REW detecta e
			penaliza, sistema recalibra. Sistemas econômicos reais não
			convergem; oscilam em torno de equilíbrio sob ataque contínuo.

			REW é o ponto onde valor operacional vira pricing — incentivos
			econômicos emergem naturalmente para participants que aderem
			ao loop honestamente. Manipulation vectors são modeled
			explicitamente (NÃO 'usuário bom' apenas) e design responses
			derivam de patterns já modelados em INV/SSC R4+++ Round 2 SRR.

			Custo de manipulation é separado em (técnico) detecção +
			(econômico) consequência — princípio canonical 'detecção não
			impede ataque; custo esperado alto impede'.
			"""
	}

	costsEliminated: [{
		costRef: "ce-04"
		contribution: """
			REW elimina ce-04 (avaliação de risco com dados incompletos)
			por design canonical: REW opera sobre signals operacionais
			verificados cross-network (NPM lifecycle, DLV evidence, NIM
			value, FCE payment behavior) — dados estruturalmente completos
			via Mesh infrastructure. Sem REW, Financiador externo opera
			sobre dados parciais via due diligence manual + bureaus de
			crédito (incomplete). Plus bd-confidence-reflects-coverage
			garante que signal gaps são surfaced honestly via confidence
			interval, NÃO assumed neutral.
			"""
		rationale: "Costref direto do subdomain registry (REW costRefs); ce-04 bearer é Financiador — sh-03 captures essa incidência stakeholder-side."
	}, {
		costRef: "ce-07"
		contribution: """
			REW elimina ce-07 (due diligence sobre lastro de recebíveis)
			via signal-ingestion + interpretation discipline: REW consome
			DLV verified evidence + INV invoice integrity + FCE payment
			behavior — toda evidência é first-class auditable cross-network.
			sh-03 (Instituição financeira parceira) NÃO precisa repetir
			due diligence operacional — REW eligibility decision já
			incorpora it. Replay capability + policy version snapshots
			permitem audit retrospectivo de qualquer decisão.
			"""
		rationale: "Costref direto do subdomain registry; bearer explícito é sh-03 (Instituição financeira parceira). Eliminação de ce-07 é proposição de valor central para Mesh adoption por sh-03."
	}, {
		costRef: "ce-05"
		contribution: """
			REW contribui INDIRETAMENTE para ce-05 (intermediação financeira
			sem vantagem informacional): pricing baseado em REW score reduz
			informational asymmetry rents que historicamente sustentavam
			intermediation premium. Tomador (sh-01) acessa pricing direto
			via REW — não precisa pagar premium para intermediário capturar
			rent informacional. Mesh como SCD captura parte do rent, mas
			REW design é estructural — não preserva legacy asymmetry.
			"""
		rationale: "Costref NÃO está em REW subdomain registry diretamente, mas contribuição é estrutural via pricing transparency. Bearer é sh-01 (Tomador). Inclusion é warranted porque REW é ENABLER da eliminação — sem REW, Mesh não consegue oferecer pricing direto baseado em risk real."
	}]

	ownership: {
		domainAgentSpec: "contexts/rew/agents/rew-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "ad-rew-deterministic-scoring"
				description: "Recomputação de score sobre signals consolidados aplicando modelVersion + policyVersion vigentes. Determinismo garantido (replay produce mesmo output dado mesmos inputs + versões — bd-deterministic-scoring-from-signals)."
				rationale:   "Scoring é função pura de inputs verificados; execução autônoma é precondition de cc-02 (scoring operacional) + escala. Versionamento + snapshot per-decision (bd-policy-and-model-version-snapshot) preservam auditability sob automação."
			}, {
				id:          "ad-rew-eligibility-evaluation"
				description: "Avaliação de eligibility contextual (entity, product, policyVersion, decisionContextTime) contra políticas vigentes. Output: eligible | conditionally-eligible | ineligible + reasoningTrace + applicableContext."
				rationale:   "Eligibility é função determinística de score + policy + context (bd-contextual-eligibility-not-static). Execução autônoma sob política approved — operator NÃO override individual decision; calibração via policy version, NÃO ajuste pontual (preserva P10)."
			}, {
				id:          "ad-rew-alert-emission"
				description: "Emissão de RiskAlertRaised quando conditions definidas em policy ativam (threshold crossed, signal inconsistency detected, anomaly pattern matched). Lifecycle managed: open → published para CMT."
				rationale:   "Alert emission é reativa a conditions deterministicamente avaliáveis. Policy define quando alert dispara; agente NÃO interpreta — aplica regra. Emission autônoma porque consumer (CMT) precisa receber em latência baixa para sinalizar entities downstream."
			}, {
				id:          "ad-rew-signal-ingestion-normalization"
				description: "Normalização de signals heterogêneos (NPM lifecycle, DLV evidence, NIM value, FCE payment) em modelo consistente para scoring. Inclui resolução determinística de schema versions + alinhamento temporal + validação de integrityProof."
				rationale:   "Per signal-ingestion capability + bd-signal-as-interpretation. Normalização é função técnica determinística (schemas + transforms versionados) — não interpretação adversarial. Conflitos cross-signal ESCALAM (escalation-conflicting-signals abaixo); NÃO são resolvidos autonomamente."
			}]

			supervisedDecisions: [{
				id:          "sd-rew-policy-version-activation"
				description: "Criação + ativação de nova policyVersion (thresholds, eligibility rules, decision boundaries). Founder approval obrigatório antes de activation; policy entra em vigor com EligibilityRecomputeRequested event triggering reavaliação de portfolio."
				rationale:   "Policy change é decisão estratégica com blast radius cross-network. NÃO pode ser autonomous — founder review garante alinhamento com regulatory + business + adversarial threat model. Per P10: gates determinísticos validam execution; humanos definem policy."
			}, {
				id:          "sd-rew-model-version-promotion"
				description: "Promoção de modelVersion de scoring (calibration, weight changes, novo signal incorporado). Founder approval após validation backtesting; modelVersion antiga continua aplicável a decisões prévias."
				rationale:   "Model promotion afeta scoring future de TODAS entities. Approval discipline exige backtesting + impact analysis cross-vertical. Risk: model drift via Goodhart se promotion automática (sh-05/sh-06 manipulationVectors)."
			}, {
				id:          "sd-rew-asset-visibility-gap-resolution"
				description: "Quando QueryEligibility envolve asset NÃO observável diretamente por REW (per oq-rew-01 INV gap pendente), agent retorna estado degradado per bd-asset-aware-decision-discipline + escalation para founder review. Resolução estrutural via inv-to-rew direta OR alternativa exige founder decision."
				rationale:   "Per founder R5++++ Section 4 hardening: 'risk engine desconectado da realidade' é falha estrutural. Phase 0 baseline aplica fallback conservador automaticamente; resolução estrutural requer arquitetura cross-BC decision."
			}, {
				id:          "sd-rew-eligibility-override-prohibition"
				description: "REW NÃO suporta override de eligibility individual — operator NÃO pode forçar 'eligible' OR 'ineligible' fora do output da policy. Mudanças de eligibility ocorrem APENAS via policy version change (sd-rew-policy-version-activation acima) OU via emergency override path (sd-rew-emergency-override-via-context-adjustment abaixo, sob disciplina específica)."
				rationale:   "Override individual seria backdoor para autonomy ilimitada (paralelo tq-gv-14 P10 enforcement em INV governance). Adversarial vector (sh-06): pressure para 'override one entity'; design response: structural prohibition. Mudança legítima sempre via policy ou via context adjustment auditable."
			}, {
				id:          "sd-rew-emergency-override-via-context-adjustment"
				description: "Emergency override path SEM quebrar bd-deterministic-scoring nem sd-rew-eligibility-override-prohibition. Override NÃO altera decisão individual — altera CONTEXTO de avaliação: (a) Cria temporary policyVersion (time-limited com explicit expires_at; scoped a entity OR category específica; auditable); (b) Injeta corrective signal (e.g., upstream BC reports incorrect data; founder injects correction signal with reasoning trace; REW recomputa under corrected input). Recovery legítimo (não corruption): bug de policy → temp version bypass; erro de input upstream → corrective signal; edge case regulatorio → temp policy ajustada."
				rationale:   "Founder R5++++ canonical: 'proibir override evita corrupção; não ter escape cria rigidez perigosa'. Override PROIBIDO em decisão individual preservado; override PERMITIDO em contexto via mecanismo auditable + temporal-bounded. Ambos paths preservam P10 (gates determinísticos validam sob context corrigido). Misuse risk tracked via oq-rew-05."
			}]

			escalationCriteria: [{
				id:        "esc-rew-conflicting-signals"
				condition: "Signals cross-BC contradictory (NPM 'ativo' + DLV 'comportamento degradado' + FCE 'atrasos sustentados' simultaneously) — per bd-signal-as-interpretation-not-raw-data, REW NÃO resolve conflito semanticamente."
				action:    "Emit RiskAlertRaised com kind='inconsistent-signals' para CMT; reduce confidence in affected scoring; mantém TODOS signals em reasoningTrace; escalate para founder review (resolução de conflito pertence aos BCs de origem)."
				rationale: "Severity: medium. Resolver conflito autonomamente quebraria boundary das interpretations de origem. Founder review garante handoff humano para BC owners reverem signal validity."
			}, {
				id:        "esc-rew-threshold-breach-critical"
				condition: "Score crossing critical threshold (e.g., entity score < minimum-eligibility-floor declared in policy) OR realization-gap individual emissor > 15% (HARD trigger from Layer 1 mechanisms via INV signal)."
				action:    "Emit RiskAlertRaised com kind='critical-threshold-breach'; immediate eligibility recomputation para entity; CMT consumes alert + sinaliza commitments; founder review se sustained > 1 evaluation."
				rationale: "Severity: high. Critical thresholds são hard gates (não suaves). Single breach é signal estrutural — alert + recompute imediato preserva consistency cross-decision."
			}, {
				id:        "esc-rew-asset-visibility-gap"
				condition: "QueryEligibility recebida para context envolvendo asset NÃO observable directly (oq-rew-01 INV gap manifestation). Per bd-asset-aware-decision-discipline."
				action:    "Aplicar fallback policy-defined (conditionally-eligible com caveat OR ineligible com 'asset-not-observable-via-current-channels'); confidence degradation explicit em returned EligibilityDecision; founder notification batch (não real-time — gap estrutural conhecido)."
				rationale: "Severity: low. Per founder R5++++ canonical: 'proibição sem fallback = indisponibilidade; fallback sem disciplina = corrupção'. Disciplina é fallback policy-defined consistently aplicado; founder visibility via batch notification para tracking de prevalência."
			}, {
				id:        "esc-rew-cross-bc-signal-staleness"
				condition: "Signal stream de upstream BC stale > defined threshold (e.g., NPM ParticipantStatusChanged não recebido em > 24h para entity ativa OR FCE PaymentSettled stream silent > 7 dias). Detected via heartbeat/expected-frequency monitoring."
				action:    "Reduce confidence em scoring para affected entities; emit RiskAlertRaised com kind='upstream-signal-stale' para founder review; degraded eligibility (conditionally-eligible) até signal recovers OR founder explicit override via policy adjustment."
				rationale: "Severity: medium. Stale signal ≠ healthy signal (per bd-confidence-reflects-signal-coverage + founder R5++++ canonical 'missing signal ≠ neutral signal'). Honesty discipline: confidence interval reflete coverage; alert garante humano sees gap."
			}, {
				id: "esc-rew-unclassifiable-pattern"
				condition: """
					SCOPE-AWARE UNKNOWN PATTERN DETECTION (founder R5++++ directive 'unknown local é erro; unknown repetido é ataque'):
					ENTITY-LEVEL UNKNOWN: pattern affecting single entity, isolated occurrence, NÃO matches qualquer condition em policy + NÃO matches alert kind reconhecido.
					SYSTEM-LEVEL UNKNOWN (escalation): pattern aparece em ≥ 2 entidades em janela 24h OR pattern envolve correlação cross-BC simultânea.
					"""
				action: """
					ENTITY-LEVEL: halt scoring para entity afetada (degraded eligibility 'unclassifiable-pattern' caveat); founder notification batch.
					SYSTEM-LEVEL: HALT_AGENT obrigatório (paralelo INV Phase 5 governance unclassifiable-anomaly recovery protocol 4-condições — root cause + invariants revalidated + safe state replay + explicit founder authorization).
					"""
				rationale: "Severity: high (entity-level) / CRITICAL (system-level → HALT_AGENT). REW NÃO improvisa interpretation para patterns não modelados (bd-signal-as-interpretation-not-raw-data + UNKNOWN EVENT SAFETY RULE). Hubris-driven autonomous decision sob unknown pattern = exatamente vetor adversarial sh-06."
			}, {
				id:        "esc-rew-decision-consumption-anomaly"
				condition: "Outcome observado downstream contradiz REW published decision: FCE PaymentSettled para entity que REW deemed ineligible; SCF anticipated invoice apesar de eligibility = 'conditionally-eligible' com strict caveat; CMT accepted commitment apesar de alert ATIVO (status open/acknowledged). Detected via cross-source reconciliation."
				action:    "Emit RiskAlertRaised kind='downstream-decision-anomaly'; mark consumer BC como 'inconsistent-with-rew-decisions' (visibility para founder); reduce confidence in consumer's signals (e.g., se FCE inconsistente, FCE PaymentSettled signal weight em REW scoring é degradado); founder review imediato."
				rationale: "Severity: high. Founder R5++++ canonical: 'decisão correta + execução errada = sistema falhou'. REW publishes decisions; consumers DEVEM respeitar (per bd-separation-decision-vs-execution). Quando consumer viola contract: detectar; alert; reduce trust em consumer signals (recursive trust decay); escalate."
			}, {
				id:        "esc-rew-agent-self-drift"
				condition: "Agent failureHandling triggers (paralelo INV governance Phase 5 envelope): onAgentError, onTimeout, onRepeatedFailure (3 failures em 24h). Plus regression triggers: boundary violation (autonomy escapology), drift metrics sustained breach."
				action:    "Suspend-and-escalate (founder R3 directive aplicada a REW): agent halts; founder notification immediate; recovery requires root cause + invariants revalidated + safe state replay + explicit founder authorization (4-condition recovery protocol per INV pattern)."
				rationale: "Severity: CRITICAL. Per sh-05 manipulationVector + bd-deterministic-scoring failure mode. Internal drift IS the failure mode — non-determinism em scoring agente = systemic risk para todas decisões. Recovery protocol rigoroso porque scoring afeta dinheiro real."
			}]
		}
		rationale: """
			Ownership: domainAgentSpec é REW primary agent (Phase 4 forward
			ref). GovernanceScope materializa decisão ≠ execução + sistema
			de alinhamento de incentivos: 4 autonomousDecisions são
			operações deterministicas executáveis sob P10; 5
			supervisedDecisions são decisões estratégicas exigindo founder
			approval (policy/model versions, asset gap resolution,
			eligibility override prohibition, emergency override path);
			7 escalationCriteria cobrem scenarios estructuralmente além
			de decisões individuais.

			DISCIPLINA P10 PRESERVADA: REW agent autonomy é bounded por
			determinismo (autonomousDecisions) + policy versionamento
			(supervisedDecisions). Override individual de decision é
			STRUCTURALLY PROHIBITED — backdoor adversarial fechada por
			design. Emergency escape via context adjustment (não decisão)
			provê flexibility sem violar P10.

			ADVERSARIAL-ADAPTIVE LOOP REINFORCED: escalationCriteria são
			portas para founder review onde sistema NÃO pode resolver
			autonomamente (conflicting signals, asset gaps, unclassifiable
			patterns, downstream consumer failures). Pattern canonical:
			'REW não decide qual signal é verdadeiro; decide quão confiável
			é decidir com signals conflitantes'.

			SEVERITY MAPPING (narrative; schema field future via Phase 1+
			ADR): conflicting-signals=medium, threshold-breach=high,
			asset-visibility-gap=low, signal-staleness=medium,
			unclassifiable entity-level=high, unclassifiable system-level=
			CRITICAL (HALT), decision-consumption-anomaly=high, agent-
			self-drift=CRITICAL (HALT).

			Phase 5 governance envelope (futuro: contexts/rew/agents/
			rew-primary-agent.governance.cue) materializará routing + caps
			+ drift detection + calibration + failureHandling alinhados
			com este governanceScope (paralelo INV WI-053 Phase 5 pattern).
			"""
	}

	assumptions: [{
		id:                 "as-rew-01"
		assumption:         "Signals consumed by REW têm INTEGRIDADE VERIFICADA pelos BCs de origem (gates determinísticos passaram, integrityProof verified) — MAS NÃO necessariamente CORRETAS. Integridade ≠ veracidade."
		invalidationSignal: "REPETIÇÃO de inconsistências cross-BC para mesma entity OR sustained correlation entre BC interpretation e ground truth divergence (e.g., DLV approved mas sustained financial defaults → DLV systematically optimistic). Detectado via cross-BC reconciliation + outcome correlation tracking."
		rationale:          "Founder R5++++ canonical: 'integridade ≠ veracidade'. REW NÃO duplica interpretation MAS reconhece que upstream pode estar errado mesmo com integrityProof. Mitigação: vm-rew-confidence-coverage-correlation (signal coverage) + vm-rew-score-outcome-monotonicity (interpretation accuracy proxy) + esc-rew-conflicting-signals (active disagreement detection). Veracidade é continuamente testada via 3 channels: conflicting signals, downstream outcomes, adversarial detection."
	}, {
		id:                 "as-rew-02"
		assumption:         "Bacen regulatory framework aceita IA-driven risk decisions sob auditability + replay + version snapshots rigorosos como equivalentes a decisões humanas tradicionais para SCDs."
		invalidationSignal: "Bacen normativa explícita exigindo human-in-loop signing per individual decision OR proibindo automated risk scoring sob certas conditions (e.g., volumes acima de threshold, asset class específica)."
		rationale:          "Per Section 2 vertical-agnostic + Section 7 ownership pattern: REW autonomy é predicado em regulatory acceptance. Se invalida, REW supervisedDecisions expandem drasticamente; eligibility decisions exigem human review per case → reduce REW value proposition."
	}, {
		id:                 "as-rew-03"
		assumption:         "Calibration adversarial-adaptive loop converges em finite time: model precision improves with operational data + adversarial pressure detectada e respondida via policy/model version updates."
		invalidationSignal: "Sustained drift in score-vs-actual-default correlation despite recalibration cycles (model accuracy degrading over multiple version iterations) — adversarial faster than detection. Detectado via vm-rew-decision-consumption-consistency long-term trend + vm-rew-score-outcome-monotonicity sustained degradation."
		rationale:          "Sistemas econômicos NÃO convergem absolute (canonical: 'oscilam em torno de equilíbrio sob ataque'); MAS oscillation deve ter amplitude bounded. Sustained widening de oscillation = adversarial outpacing system."
	}, {
		id:                 "as-rew-04"
		assumption:         "Upstream BCs (NPM/DLV/NIM/FCE) maintain availability ≥ defined SLO; signal staleness é exception (< 5% das scoring runs) NÃO rule. NIM como exceção Phase 0 (oq-rew-02)."
		invalidationSignal: "Sustained signal staleness > 10% across upstream BCs OR concentrated in specific BC — operational degradation threshold."
		rationale:          "REW publica decisões com confidence reflective de signal coverage; sob sustained low coverage, decisions perdem utility (consumers underwrite based on degraded confidence → SCF anticipa less; FCE blocks more). Mesh proposition de valor compromised."
	}]

	openQuestions: [{
		id: "oq-rew-01"
		question: """
			Como REW obtém direct OR indirect consistent visibility ao asset
			(invoice/receivable) que está sendo evaluated? Currently inv-to-rew
			relation NÃO existe em context-map; REW relies em FCE PaymentSettled
			(post-settlement; lag) + NIM signals (abstracted). 4 alternativas
			arquiteturais identificadas:
			(A) Adicionar inv-to-rew relation direta (modify context-map);
			(B) SCF inclui invoice context na query a REW (sync-driven);
			(C) NIM mediates — REW relies em NIM trajectory signals;
			(D) FCE projeta 'expected payments' ahead of settlement.
			"""
		impact:    "Per bd-asset-aware-decision-discipline + esc-rew-asset-visibility-gap: REW operates DEGRADED sob asset-not-observable. EligibilityDecision para SCF anticipation potentially divergent from real state. Phase 0 baseline aplica fallback conservador; resolução estrutural requer cross-BC architectural decision."
		deadline:  "2026-08-01"
		rationale: "Founder R5++++ canonical: 'risk engine desconectado da realidade' = vetor de erro estrutural. Gap é categorial, não operacional. Decisão arquitetural por founder + envolve INV/SCF/FCE owners."
	}, {
		id: "oq-rew-02"
		question: """
			REW depende de NIM signals (bd-confidence-reflects-coverage) mas
			NIM NÃO existe em Phase 0 — WI-070 Layer 2 NIM 3 outputs pendentes
			(value-function-model schema + mesh-value-function-v0 instance +
			adr-084). Como REW Phase 0 opera sem NIM signal contribution?
			Stub signal com confidence default? OR delay REW go-live até NIM
			disponível?
			"""
		impact:    "Phase 0 REW opera com confidence degradation systematic devido NIM ausente; trajectory-based risk dimension underestimated; sh-06 adversarial vectors envolvendo composição global de actions parcialmente invisíveis. Cross-WI dependency Phase 0 → Phase 1+."
		deadline:  "2026-07-15"
		rationale: "Cross-WI temporal dependency. Decisão temporal: REW go-live partial (sem NIM) vs delay completo. Se partial, document explicitly em release notes que REW Phase 0 confidence intervals systemically lower vs Phase 1+."
	}, {
		id: "oq-rew-03"
		question: """
			Per Section 2 vertical-agnostic structure + parâmetros adaptable:
			como REW gerencia migração de calibração quando expand de construção
			civil → logística → outros? Re-fit modelos? Versioning de calibração
			per vertical (e.g., policyVersion-construção, policyVersion-logística)?
			Multi-vertical model com vertical tag em decision payload?
			"""
		impact:    "Vertical expansion sem strategy clara → calibração lag (modelo treinado em construção under-performs em logística); OR risk de over-calibration (over-fit per vertical); OR incoerência cross-vertical scoring."
		deadline:  "2027-06-01"
		rationale: "Não imediato — Phase 0 single vertical (construção). Revisitável on first vertical expansion attempt; design escolhido afeta NIM signal interpretation cross-vertical too. Strategic founder decision."
	}, {
		id: "oq-rew-04"
		question: """
			sh-07 'Auditor / terceiro independente' como stakeholder canônico?
			Proposition: external auditor consumes REW reports for compliance
			verification — Bacen-mandated audits, partner financial institution
			audits, big-4 opinion services. Adding sh-07 = cross-cutting
			stakeholder catalog change; afeta canvas de TODOS BCs que dependem
			de external audit credibility.
			"""
		impact:    "Sem sh-07 explícito: REW depends APENAS em internal audit + Bacen visibility. Adding canonical: REW reports como published-language para external review; reinforces trust + opens new stakeholder vectors (auditor manipulation? auditor capture?). Trade-off design não trivial."
		deadline:  "2026-12-01"
		rationale: "Founder Section 6 'lacuna importante mas opcional Phase 0'; tracked here. Cross-cutting decision — afeta multiple BCs."
	}, {
		id: "oq-rew-05"
		question: """
			sd-rew-emergency-override-via-context-adjustment provê escape válido
			para evitar rigidez perigosa. MAS: como detectar override misuse
			(founder using override frequently → erodes deterministic
			discipline)? Pattern: temporary policyVersions renovando continuously
			efetivamente vira de-facto policy-de-feature. Counter-mechanism:
			meta-monitoring de override rate?
			"""
		impact:    "Mesmo escape válido pode virar abuse vector. Override pattern abused silently quebra bd-deterministic-scoring + bd-policy-and-model-version-snapshot. Sem meta-monitoring: erosion gradual da discipline; founder pode acidentalmente normalize override."
		deadline:  "2026-09-01"
		rationale: "Adversarial mode aplicado a own escape mechanism. Meta-monitoring é governance discipline. Pattern paralelo a INV WI-053 R3 cross-BC review approach."
	}, {
		id: "oq-rew-06"
		question: """
			alertCategory enum do domain-model Phase 3 (eligibility-denied |
			signal-corruption | adversarial-pattern | policy-violation |
			model-drift) NÃO cobre os 4 alert kinds operacionais que os
			escalation paths deste canvas comandam: 'inconsistent-signals'
			(esc-rew-conflicting-signals), 'critical-threshold-breach'
			(esc-rew-threshold-breach-critical), 'upstream-signal-stale'
			(esc-rew-cross-bc-signal-staleness), 'downstream-decision-anomaly'
			(esc-rew-decision-consumption-anomaly). Estender o enum OU mapear
			condition→category? Remap seria lossy: inconsistência ≠ corrupção
			(per 'integridade ≠ veracidade').
			"""
		impact:    "Direção INVERSA do alignment debt (canvas mais rico que Phase 3): enquanto aberto, os 4 escalation paths comandam alerts que o contrato evt-risk-alert-raised não expressa via alertCategory — emissão real desses alerts fica bloqueada ou forçada a remap lossy. Canvas mantém kind= e os 4 valores até resolução."
		deadline:  "2026-08-31"
		rationale: "Gap exposto pela varredura da emenda de alignment canvas↔domain-model (2026-06-12). Resolução pertence ao contrato de evento (próximo commit do domain-model REW) — decisão de founder, não de canvas."
	}]

	verificationMetrics: [{
		id:     "vm-rew-deterministic-replay-rate"
		metric: "Percentage of test replays producing IDENTICAL score given same (inputs + modelVersion + policyVersion). Mede bd-deterministic-scoring-from-signals."
		target: "≥ 99.99% (non-determinism IS failure mode)"
		onBreach: {
			escalationRef: "esc-rew-agent-self-drift"
			rationale:     "Non-determinism em scoring agente = systemic risk para todas decisões. Drift do próprio agent é exatamente o failure mode que esta métrica detecta — escalate via agent-self-drift halt protocol."
		}
		rationale: "Determinism é precondition de auditabilidade Bacen + replay. Falha aqui invalida toda decisão histórica."
	}, {
		id:     "vm-rew-policy-version-snapshot-completeness"
		metric: "% de RiskEvaluationEmitted + RiskAlertRaised events com policyVersion E modelVersion fields populated. Mede bd-policy-and-model-version-snapshot-per-decision."
		target: "100% (Bacen audit precondition; Lei 13.726 + LGPD)"
		onBreach: {
			escalationRef: "esc-rew-agent-self-drift"
			rationale:     "Snapshot missing = decisão sem identidade temporal = unauditable. Agent emitindo decisões sem snapshot é drift estrutural — halt obrigatório."
		}
		rationale: "Snapshot per-decision é precondition de Lei 13.726 + LGPD compliance. Sem isso, evolução de policy invalida audit trail histórico (ilegal)."
	}, {
		id:     "vm-rew-eligibility-reasoning-trace-completeness"
		metric: "% de EligibilityDecision com reasoningTrace non-empty + applicableContext (entityRef + productCode + policyVersion + decisionContextTime) populated. Mede bd-contextual-eligibility-not-static."
		target: "100%"
		onBreach: {
			escalationRef: "esc-rew-unclassifiable-pattern"
			rationale:     "Eligibility sem reasoningTrace = decisão opaca, indefensável em audit + susceptible to drift. Tratamento como pattern unclassifiable força halt + founder review."
		}
		rationale: "Contextual eligibility exige reasoning trace para audit + para downstream consumers entenderem decisão. Falha = decisão black-box."
	}, {
		id:     "vm-rew-confidence-coverage-correlation"
		metric: "Correlação Pearson entre confidence interval emitido e signal coverage % (signals available / signals expected per scoring run). Mede bd-confidence-reflects-signal-coverage."
		target: "≥ 0.85 sustained over weekly rolling window"
		onBreach: {
			escalationRef: "esc-rew-cross-bc-signal-staleness"
			rationale:     "Correlation low = confidence NÃO reflete coverage; ignorância tratada como segurança. Escalate via signal-staleness path para investigation."
		}
		rationale: "Honesty discipline: confidence DEVE refletir signal coverage. Falha = sistema mente sobre própria certeza."
	}, {
		id:     "vm-rew-decision-consumption-consistency"
		metric: "% de outcomes downstream consistent with REW published decisions: FCE settled apenas para eligible; SCF anticipated apenas para eligible; CMT accepted commitment apenas sem alert ativo (status open/acknowledged). Mede bd-separation-decision-vs-execution."
		target: "≥ 99.5% (5σ confidence threshold)"
		onBreach: {
			escalationRef: "esc-rew-decision-consumption-anomaly"
			rationale:     "Inconsistency = consumer violou contract (decision ≠ execução violado). Direct escalation via consumption-anomaly path para identificar consumer + reduce trust."
		}
		rationale: "Founder canonical: 'decisão correta + execução errada = sistema falhou'. Sem esta métrica, downstream misuse fica silent."
	}, {
		id:     "vm-rew-asset-visibility-gap-prevalence"
		metric: "% de EligibilityDecision com caveat 'asset-not-observable-via-current-channels'. Mede bd-asset-aware-decision-discipline manifestation rate (oq-rew-01 INV gap impact)."
		target: "Phase 0 ≤ 5% (gap baseline) → Phase 1+ ≤ 1% (após oq-rew-01 resolução)"
		onBreach: {
			escalationRef: "esc-rew-asset-visibility-gap"
			rationale:     "Sustained high prevalence = gap structural não está sendo resolvido (oq-rew-01 stalled). Batch escalation para founder reavaliar resolution priority."
		}
		rationale: "Tracking de prevalence permite measure quanto REW está degraded por INV gap. Decreases com Phase B+ resolução."
	}, {
		id:     "vm-rew-conflicting-signal-resolution-discipline"
		metric: "% de detected conflicting-signals events que emitem RiskAlertRaised (vs silent autonomous resolution) — REW NÃO escolhe signal 'verdadeiro'. Mede bd-signal-as-interpretation-not-raw-data."
		target: "100% (silent resolution = boundary violation)"
		onBreach: {
			escalationRef: "esc-rew-conflicting-signals"
			rationale:     "Silent resolution viola boundary das interpretations de origem. Escalate via conflicting-signals path para founder review (resolução pertence ao BC de origem, não REW)."
		}
		rationale: "Disciplina canonical: 'REW não decide qual signal é verdadeiro; decide quão confiável é decidir com signals conflitantes'. Falha = REW absorvendo responsibility de outros BCs."
	}, {
		id:     "vm-rew-alert-lifecycle-integrity"
		metric: "% de alerts que seguem lifecycle válido (open → acknowledged → resolved) sem: (a) duplicação (mesma (evaluationId, alertCategory) → idempotent, primeiro alert preservado, per inv-rew-alert-dedupe); (b) skipping de estado (open → resolved sem acknowledged); (c) resolução sem reasoningTrace populated; (d) reabertura (resolve é irreversível — recorrência gera NOVO alert). Mede bd-alert-explicit-lifecycle-managed."
		target: "100%"
		onBreach: {
			escalationRef: "esc-rew-unclassifiable-pattern"
			rationale:     "Lifecycle violation = pattern desconhecido em alert behavior (NÃO matches known lifecycle paths). Tratamento como unclassifiable força halt + founder investigation."
		}
		rationale: "Founder canonical: 'alert errado é pior que ausência de alert'. Lifecycle integrity é direct testable; cobertura indireta via consumption-consistency é insufficient."
	}, {
		id:     "vm-rew-score-outcome-monotonicity"
		metric: "Monotonic relationship between risk score and realized default probability (higher score → lower default rate). Spearman rank correlation entre score deciles e observed default rate. Mede VERACITY do model (distinct de consistency/integrity — 'sistema pode ser consistente e completamente errado')."
		target: "Spearman ≥ 0.65 sustained 90-day rolling window (não exige linear perfeita; ordering preservado)"
		onBreach: {
			escalationRef: "esc-rew-threshold-breach-critical"
			rationale:     "Monotonicity broken = model produzindo decisões wrong (alta confidence + low veracity). Critical threshold breach path força immediate eligibility recompute + founder review."
		}
		rationale: "Veracity métrica distinta de consistency/integrity. Per founder canonical: 'sistema pode ser 100% determinístico, 100% auditável, 100% consistente E completamente errado'. Sem esta métrica, REW vira 'ilusão sofisticada'."
	}]

	rationale: """
		Canvas REW Phase 1 do WI-046 — materializa identidade canônica de
		REW como SISTEMA DE EPISTEMOLOGIA OPERACIONAL sob adversarial
		pressure. Define o que é fato (signals), o que é hipótese (score),
		o que é confiança (confidence), quando parar de decidir (halt),
		quando escalar (escalation), quando desconfiar do próprio sistema
		(drift).

		FRASE CANONICAL R5++++ (founder, captured Phase 1 final):
		'REW não está tentando prever o futuro — REW está tentando NÃO
		MENTIR sobre o presente.' Sistema NÃO tenta eliminar incerteza —
		torna a incerteza EXPLÍCITA e GOVERNÁVEL.

		ECONOMIC LOOP CANONICAL: NIM mede valor → REW transforma em risco
		→ REW cria incentivos econômicos → comportamento → tentativas de
		exploração → REW detecta → penaliza → comportamento recalibra →
		NIM. Loop adversarial-adaptativo: sistemas econômicos reais NÃO
		convergem; oscilam em torno de equilíbrio sob ataque contínuo.

		8 BUSINESS DECISIONS encodam invariants estruturais (deterministic
		scoring + contextual eligibility + version snapshot + decision-
		execution separation + signal-as-interpretation + alert-lifecycle-
		managed + confidence-reflects-coverage + asset-aware-decision-
		discipline). 6 STAKEHOLDERS modeled (5 sh-NN canonical + sh-06
		adversário econômico introduzido neste canvas como vetor adversarial
		canonical cross-BC). 9 VERIFICATION METRICS testam BDs +
		consistency/integrity/veracity dimensions.

		LENSES: agent-governance (primária — operational autonomy); market-
		design (secundária — incentive alignment loop); regulatory-compliance-
		as-architecture (secundária — Bacen audit + Lei 13.726);
		game-theory-applied (terciária — adversarial pressure + sh-06 modeling);
		mechanism-design (terciária — pricing + decision boundaries).

		Phases subsequentes WI-046:
		- Phase 2: glossary (firewall semântico — terms canonical antes
		  de domain-model)
		- Phase 3: domain-model (aggregates + invariants formal)
		- Phase 3.5: structural-checks (8 BDs enforced via cst-rew-*)
		- Phase 4: agent-spec (rew-primary-agent.cue — execution layer)
		- Phase 5: agent-governance (rew-primary-agent.governance.cue —
		  routing + caps + drift + calibration + failureHandling)

		Cross-cutting impact: introduz sh-06 'Adversário econômico' ao
		canonical stakeholder catalog (domain/stakeholder-map.cue) —
		reusable cross-BC para modelagem defensiva consistente.
		"""
}
