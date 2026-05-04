package ssc

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Strategic Sourcing & Category.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// SSC é o início do macrofluxo canônico Mesh: SSC → {P2P, CTR} → CMT
// → BDG → DLV → INV → FCE. Decide qual fornecedor atende qual
// categoria de demanda, sob regras determinísticas aplicadas a sinais
// estruturados — não inferindo performance nem inventando qualificação.
//
// Frase canônica: SSC decide sourcing. CTR formaliza contrato. P2P
// executa compra.
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). Q1-Q10 + 5 ciclos de red team por questão + cascade
// de criação de PG lens + lens-incentive-alignment para Q10.
//
// Materializado em 4 commits incrementais:
//   2.1 — skeleton: identity + classification + roles (este commit)
//   2.2 — capabilities + communication
//   2.3 — businessDecisions + stakeholders + costsEliminated + incentiveAnalysis
//   2.4 — ownership.governanceScope + assumptions + openQuestions + verificationMetrics + rationale outer
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.

canvas: artifact_schemas.#Canvas & {
	code: "ssc"
	name: "Strategic Sourcing & Category"

	purpose: """
		Decidir qual fornecedor atende qual categoria de demanda no
		ecossistema das organizações participantes, aplicando regras
		determinísticas a sinais estruturados (elegibilidade NPM,
		contexto RFQ, respostas de fornecedores, e — pós-formalização
		cross-BC — performance NIM e compromissos CTR). SSC é o início
		do macrofluxo Mesh: sem decisão de sourcing canônica, escolha
		de fornecedor acontece fora da rede e o dado mais valioso
		(como e por que um fornecedor foi escolhido) fica perdido.
		SSC NÃO interpreta sinais — aplica regras versionadas; NÃO
		formaliza contrato — apenas designa fornecedor; NÃO executa
		compra — produz decisão consumida por P2P (execução) e CTR
		(formalização contratual, quando aplicável).
		"""

	ubiquitousLanguageRef: "contexts/ssc/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque strategic sourcing é domínio com padrões
			estabelecidos (category management, RFQ, TCO equalization)
			— não é proprietário da Mesh. O valor proprietário está
			na captura estruturada da decisão de sourcing como dado
			canônico que alimenta NIM (rede) + CTR (formalização) +
			P2P (execução) — não no processo de sourcing em si.
			Operational-enabler porque SSC habilita compra estruturada
			downstream sem ser o BC que executa ou formaliza. Product
			(Wardley) porque RFQ + category management são padrões
			amplamente compreendidos e endereçados por soluções de
			mercado (e-procurement, sourcing platforms); a Mesh adapta
			o padrão integrando-o ao macrofluxo como decisão capturada
			com decisionRationale rico.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Sourcing estratégico opera sobre primitivas universais
			(categoria, RFQ, fornecedor qualificado, decision rationale)
			que não dependem da vertical de aplicação. SSC nasce
			aplicado à construção civil (vertical inicial Mesh), mas
			seus mecanismos — gate de qualificação NPM, equalização via
			fitness rules em config externa governada, decision events
			com decisionRationale estruturado — são reutilizáveis em
			qualquer cadeia produtiva B2B com vocabulário adaptado.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["analysis"]
		rationale: """
			Gateway como primário: SSC é gate de progressão do
			macrofluxo — sem decisão de sourcing canônica vigente, P2P
			não emite pedido (per bd-procurement-requires-sourcing-
			authority). Analysis como secundário: SSC analisa fitness
			signals estruturados aplicando regras determinísticas para
			produzir decisão. SSC NÃO é execution (P2P) nem
			specification (CTR) — articulado em
			bd-sourcing-decides-not-formalizes-not-executes.
			"""
	}

	// =============================================
	// CAPABILITIES
	// =============================================

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de decisões de sourcing: cada RFQ
				aberta, decisão emitida (SourcingDecisionMade /
				PreferredSupplierDesignated / StrategicAwardCompleted)
				e cancelamento é fato imutável no Event Log com
				decisionRationale estruturado (criteria + weights +
				evaluatedSuppliers + tradeoffs). Auditoria interna,
				controllers e regulador anti-corrupção podem
				reconstituir processo de seleção competitiva em
				qualquer data.
				"""
			rationale: "Trail de RFQ é evidência de processo competitivo formal — sustenta compliance anti-corrupção (Lei 12.846) sem modelar regulador como stakeholder Phase 0."
		}, {
			capabilityRef: "cc-03"
			description: """
				Decisão de sourcing 24/7 via gate determinístico:
				agente aplica fitness rules sobre fitnessSignals
				estruturados sem intervenção humana rotineira. Humano
				(category manager via sh-01) atua por exceção
				(ambiguidade de signal, override de regra, cancelamento
				de RFQ, escopo estratégico de strategic award).
				"""
			rationale: "cc-03 (operação 24/7) aplica via determinismo: regras versionadas + signals estruturados + escalation por exceção = throughput operacional sem latência humana rotineira."
		}, {
			description: """
				Captura estruturada de decisionRationale como dado
				canônico: cada decisão emitida carrega criteria
				aplicados, weights vigentes, fornecedores avaliados e
				tradeoffs articulados. Sustenta consumo NIM futuro
				(performance/reputation learning loop) sem virar mini-
				NIM Phase 0 — SSC ESTRUTURA o dado, não COMPUTA
				inferência.
				"""
			rationale: "Captura estruturada é o moat de inteligência da Mesh per subdomain: 'dado mais valioso para NIM é como e por que fornecedor foi escolhido'. Sem estruturação, dado vira narrativa sem grounding analítico."
		}, {
			description: """
				Modelo canônico de decisão de sourcing exposto via query
				síncrona: P2P consulta decisão vigente para categoria;
				CTR consulta strategic award para formalização contratual;
				controllers consultam histórico para reconciliação spend.
				"""
			rationale: "Múltiplos consumidores precisam referenciar mesma fonte de decisão de sourcing. SoT exposta via query elimina drift entre cópias."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION
	// =============================================

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Category manager (sh-01) decide processar demanda one-shot — necessidade pontual sem contrato-quadro nem designação preferred vigente."
			command:         "MakeOneShotSourcingDecision"
			resultingEvents: ["SourcingDecisionMade"]
			description:     "Decisão atômica vinculante para P2P emitir pedido específico. Tipo declarado upfront (per bd-decision-type-is-declared-upfront)."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Category manager decide designar fornecedor preferido para categoria recurring sem contrato-quadro formal."
			command:         "DesignatePreferredSupplier"
			resultingEvents: ["PreferredSupplierDesignated"]
			description:     "Designação recurring com validUntil. P2P consume como cache de policy aplicável a múltiplos pedidos da categoria."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Category manager conclui RFQ formal com volume comprometido — gatilho para formalização contratual em CTR."
			command:         "CompleteStrategicAward"
			resultingEvents: ["StrategicAwardCompleted"]
			description:     "Award que precede formalização contratual. CTR é consumidor primário e obrigatório; conteúdo é input indicativo (não vinculante) — consequence de bd-sourcing-decides-not-formalizes-not-executes."
		}, {
			type:          "event-consumer"
			sourceContext: "npm"
			event:         "NetworkParticipantStatusChanged"
			reaction:      "SSC alerta category manager quando fornecedor relevante para RFQ ativa OU preferred designation vigente é rebaixado. Não bloqueia automaticamente — sinaliza necessidade de re-validation no próximo decision time."
			description:   "Async alerta operacional. Decisão autoritativa em decision points usa QueryParticipantStatus (sync), não cache de events."
		}, {
			type:        "query-surface"
			query:       "QuerySourcingDecision"
			returnType:  "SourcingDecision"
			description: "Retorna decisão de sourcing vigente para um CommitmentScope (categoria + escopo). Consumido por P2P para validar autoridade de procurement (per bd-procurement-requires-sourcing-authority) e por CTR para validar strategic award pré-formalização contratual."
		}, {
			type:        "query-surface"
			query:       "QueryActiveSourcingDecisions"
			returnType:  "ActiveSourcingDecisions"
			description: "Retorna decisões ativas (one-shot pendentes de P2P + preferred vigentes + strategic awards aguardando contrato CTR) por categoria. Consumido por controllers para reporting + by P2P como cache de policies aplicáveis."
		}]
		outbound: [{
			type:        "event-publisher"
			trigger:     "Decisão one-shot emitida — fornecedor X selecionado para escopo Y específico."
			event:       "SourcingDecisionMade"
			consumers: ["p2p"]
			description: "Hard binding para P2P (override = supervised). Phase 0 NIM consumer pendente per oq-ssc-2."
		}, {
			type:        "event-publisher"
			trigger:     "Designação preferred ativada — fornecedor X designado para categoria recurring até validUntil."
			event:       "PreferredSupplierDesignated"
			consumers: ["p2p"]
			description: "Soft binding para P2P (override = autonomous-with-audit). validUntil expira a preferência sem desfazer pedidos já criados — afeta apenas decisões P2P futuras. Phase 0 NIM consumer pendente per oq-ssc-2."
		}, {
			type:        "event-publisher"
			trigger:     "Strategic award concluído pós-RFQ formal — gatilho para formalização contratual."
			event:       "StrategicAwardCompleted"
			consumers: ["ctr", "p2p"]
			description: "CTR consumer primário e obrigatório (formaliza contrato sob input indicativo). P2P consumer secundário advisory/cache enquanto CTR materializa contrato — pós-materialização, contrato CTR é SoT vinculante. Phase 0 NIM consumer pendente per oq-ssc-2."
		}, {
			type:          "query-dependency"
			targetContext: "npm"
			query:         "QueryParticipantStatus"
			purpose:       "Decisão autoritativa em RFQ open + decision time. Eligibilidade NPM é precondição absoluta (bd-qualification-as-absolute-precondition); rebaixados são excluídos automaticamente."
			description:   "Sync query consultada em 2 momentos críticos. Cache via NetworkParticipantStatusChanged events serve para alertas, NÃO para decision authority."
		}]
		rationale: """
			Inbound: 3 command-handlers (1 por tipo de decisão per
			bd-decision-type-is-declared-upfront), 1 event-consumer
			(NPM status alerts), 2 query-surfaces (P2P/CTR/controllers).
			Outbound: 3 event-publishers (decision events com
			consumers reais P2P/CTR), 1 query-dependency (NPM
			eligibility). RFQ lifecycle events (RFQOpened, RFQConcluded,
			RFQCancelled) são emitidos para subscription transversal de
			NTF (notificações operacionais a fornecedores) e OBS
			(observabilidade) per bd-rfq-lifecycle-public-minimal —
			não modelados como event-publishers individuais aqui per
			knownLimitation do context-map (transversais consumem sem
			relação individual). Cancel-rfq é supervisedDecision; demais
			lifecycle transitions são autonomousDecisions. Context-map
			amendments aplicados em commits 1a (ssc-to-p2p +
			StrategicAwardCompleted) + 1b (ssc-to-ctr swap to
			StrategicAwardCompleted) + 1c (ssc-to-ctr description
			refinement).
			"""
	}

	// =============================================
	// BUSINESS DECISIONS
	// =============================================

	businessDecisions: [{
		id: "bd-deterministic-decision-from-structured-signals"
		decision: """
			SSC decide aplicando regras determinísticas e versionadas
			sobre sinais estruturados (NPM elegibilidade + RFQ context
			+ RFQ responses + NIM/CTR signals quando disponíveis). SSC
			não avalia nem inventa qualificação, performance ou
			reputação — consome o que outros BCs produzem e estrutura
			o que vem da RFQ.
			"""
		rationale: """
			P10 (gates determinísticos validam, agentes recomendam).
			SSC sem regras explícitas viraria julgamento subjetivo do
			agente — viola integridade do gate. Fitness sustentado em
			signals externos elimina ambiguidade sobre fronteira de
			responsabilidade entre SSC e BCs adjacentes.
			Anti-mini-NIM: SSC APLICA, não INTERPRETA.
			"""
		consequences: """
			Regras de fitness vivem em configuração externa governada
			com versionamento (oq-ssc-8); suficiência de signals é
			boolean Phase 0 (todos obrigatórios presentes ou escala);
			ausência ou ambiguidade de signal → escalation, não
			decisão heurística. Signals opcionais Phase 0 (NIM/CTR)
			entram como camada additional pós-formalização cross-BC
			(oq-ssc-1, oq-ssc-2, oq-ssc-7).
			"""
	}, {
		id: "bd-sourcing-decides-not-formalizes-not-executes"
		decision: """
			SSC decide sourcing. CTR formaliza contrato. P2P executa
			compra. SSC produz SourcingDecisionMade (one-shot, hard
			binding em P2P), PreferredSupplierDesignated (recurring,
			soft binding), StrategicAwardCompleted (input indicativo
			para CTR formalizar contrato; advisory para P2P até CTR
			materializar). StrategicAward é consumido por CTR como
			obrigatório, mas conteúdo é input indicativo — CTR pode
			divergir do expectedContractScope com aprovação supervisada.
			"""
		rationale: """
			Separação cross-BC evita acumulação de responsabilidades
			em SSC. Decisão de fornecedor (estratégica) é distinta de
			formalização contratual (jurídica) e execução de compra
			(operacional). Sem essa separação, SSC absorve cláusulas
			contratuais e lógica de pedido — drift para BC Deus de
			procurement.
			"""
		consequences: """
			Janela [StrategicAward, ContractActivation]: pedido P2P
			válido via expectedContractScope no payload do award.
			CTR cancelamento pós-award gera cache stale em P2P
			(oq-ssc-5 deferred Phase 0). Tipo da decisão não é output
			emergente — é input estratégico declarado upfront pelo
			category manager (bd-decision-type-is-declared-upfront).
			"""
	}, {
		id: "bd-decision-type-is-declared-upfront"
		decision: """
			Tipo de decisão (one-shot / preferred / strategic) é
			declarado pelo category manager pré-RFQ via command tipado
			(MakeOneShotSourcingDecision / DesignatePreferredSupplier
			/ CompleteStrategicAward). Tipo emitido no event
			(SourcingDecisionMade / PreferredSupplierDesignated /
			StrategicAwardCompleted) deve corresponder ao tipo
			declarado upfront — sem classificação retroativa por SSC.
			"""
		rationale: """
			Invariant testável SSC: tipo é input estratégico do
			category manager, não output emergente do agente.
			Classificação retroativa pelo SSC seria julgamento
			estratégico — viola escopo descritivo (SSC aplica regras,
			não decide tipo de processo).
			"""
		consequences: """
			Audit trail testa: requestedAt < rfqOpenedAt AND
			requestedDecisionType == emittedEventType.
			Mapeamento canônico: one-shot → SourcingDecisionMade,
			preferred-designation → PreferredSupplierDesignated,
			strategic-award → StrategicAwardCompleted. Inconsistência
			temporal ou de tipo bloqueia emissão; agente escala
			(insufficient-context).
			"""
	}, {
		id: "bd-procurement-requires-sourcing-authority"
		decision: """
			P2P NÃO emite pedido sem autoridade de sourcing vigente:
			SourcingDecisionMade specific OR PreferredSupplierDesignated
			válido (validUntil futuro) OR contrato CTR vigente, OR
			exceção supervisionada com justificativa documentada.
			"""
		rationale: """
			Invariant operacional em P2P (não em SSC) que sustenta o
			valor estratégico de SSC: sem este invariant, SSC vira
			advisor ignorável e perde poder. Exceção supervisionada
			evita estrangulamento operacional quando SSC ainda não
			cobriu uma categoria.
			"""
		consequences: """
			P2P recebendo demanda sem autoridade vigente: escala via
			fluxo request-sourcing-decision (oq-ssc-4 deferred Phase 0
			— escalation manual). Override de one-shot SSC requer
			supervised approval; override de preferred é
			autonomous-with-audit (drift detection sustained → feedback
			loop P2P→SSC, oq-ssc-3).
			"""
	}, {
		id: "bd-qualification-as-absolute-precondition"
		decision: """
			Qualificação NPM (eligible-for-sourcing em
			QueryParticipantStatus) é precondição absoluta para entrada
			em RFQ. SSC valida em 2 momentos críticos: RFQ open
			(qualificação inicial do pool) e decision time (re-
			validation antes de emitir decisão). Fornecedor rebaixado
			entre os dois pontos é excluído automaticamente da decisão.
			"""
		rationale: """
			SSC não revalida compliance (KYC/AML é responsabilidade
			NPM). Qualificação é gate hard binário, não gradiente.
			Re-validation at decision protege contra janela de risco
			entre RFQ open e decision (NPM pode rebaixar fornecedor
			durante RFQ ativa).
			"""
		consequences: """
			RFQ não inclui fornecedores provisionally-qualified,
			pending-qualification, suspended ou revoked. Re-validation
			que reduz pool a < 2 fornecedores → escalation
			insufficient-qualified-pool; decisão não emitida
			automaticamente. Events NetworkParticipantStatusChanged
			consumidos como alertas operacionais; QueryParticipantStatus
			é fonte autoritativa para decisões.
			"""
	}, {
		id: "bd-rfq-lifecycle-public-minimal"
		decision: """
			RFQ tem lifecycle público mínimo Phase 0: 3 events
			(RFQOpened, RFQConcluded, RFQCancelled) sustentam
			notificação operacional a fornecedores convidados (NTF) e
			observabilidade (OBS). Avaliação interna de cotações
			(QuotationSubmitted, QuotationWithdrawn,
			RFQEvaluationStarted) permanece intra-SSC.
			"""
		rationale: """
			Fornecedores convidados precisam visibilidade operacional
			(notificação de abertura, conclusão, cancelamento) sob
			pena de perda de oportunidade. Avaliação interna não é
			visibilidade pública — preserva confidencialidade
			competitiva entre fornecedores e protege processo de
			equalização contra interferência externa.
			"""
		consequences: """
			NTF/OBS consomem events RFQ via subscription transversal
			(sem relação individual no context-map per regra de
			omissão). Single-round RFQ apenas Phase 0; multi-round
			BAFO é openQuestion oq-ssc-9. Cancelamento de RFQ é
			supervisedDecision (custo reputacional para fornecedores
			convidados); abertura e conclusão são autonomousDecisions
			(determinísticas).
			"""
	}, {
		id: "bd-category-manager-as-sh-01-internal-function"
		decision: """
			Category managers são função interna da originadora (sh-01);
			supervisedDecisions de SSC são aprovadas por category
			manager designado pela originadora. Phase 0 recipient =
			founder per ADR-037 pre-PMF; pós-PMF evolui para 'category
			manager designado'.
			"""
		rationale: """
			Category manager é cargo interno da originadora (sh-01),
			não stakeholder distinto. Modelar como sh-XX próprio
			fragmentaria o stakeholder map sem benefício analítico.
			Recipient pré-PMF = founder mantém simplicidade governance
			até evolução natural.
			"""
		consequences: """
			Stakeholder map permanece com 5 sh-XX existentes; sh-01
			absorve category managers como função interna.
			SupervisedDecisions roteadas a 'founder' Phase 0; envelope
			governance evolui recipient pós-PMF sem mudança no canvas.
			"""
	}]

	// =============================================
	// STAKEHOLDERS
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Originadora de demanda; absorve category managers como função interna que aprova supervisedDecisions e declara tipo de decisão pré-RFQ. Consome decisão SSC para gerar pedidos P2P + contratos CTR conforme tipo."
		impactDescription: "Decisão SSC determina qual fornecedor atende demanda interna de procurement; afeta TCO realizado, prazo de entrega, qualidade de execução. Category managers ganham accountability estruturada via decisionRationale + audit trail; perdem opacidade que permitia favoritismo informal."
		rationale:         "Construtora é o nó central da cadeia produtiva — cada decisão SSC consome capacidade de fornecimento e materializa custo. Category manager dentro da originadora é quem efetivamente decide tipo (one-shot/preferred/strategic) e aprova override de regras."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Respondente ativo em RFQ; submete propostas, aceita designation/award, pode optar por não cotar. Objeto da decisão SSC — quem é selecionado vs quem não é. Pode tentar manipulation vector (low-balling, capacity overstate)."
		impactDescription: "Acesso ao mercado de procurement da Mesh depende de qualificação NPM (precondição absoluta) + decisão SSC. Oportunidade de negócio condicionada à seleção; dado SSC alimenta NIM (pós-bootstrap) construindo reputation history que facilita futuras seleções OR encurta acesso se manipulation detectada."
		rationale:         "Fornecedor é parte ativa, não passiva. Sem fornecedor cotando, RFQ falha; sem qualificação NPM, fornecedor não entra. Vetor adversarial específico (low-balling) é riscos estrutural Phase 0 e precisa designResponse explícito."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador SSC; aplica regras determinísticas sobre fitnessSignals via fitness rules em config externa governada. Opera RFQ lifecycle (open / conclude / cancel via supervisedDecision). Detecta padrões de manipulation via incentive-divergence-detection. NÃO interpreta signals nem infere reputation."
		impactDescription: "Imparcialidade do gate é credibilidade do BC. Manipulação algorítmica detectável via Event Log + drift detection metrics. Agente sem fitnessSignals suficiente não decide — escala. Promotion para autonomy maior depende de track record (calibração via envelope governance)."
		rationale:         "Agente IA opera o gate; sem boundaries explícitas, decisões viram zona cinza com poder assimétrico do agente sobre macrofluxo. P10 + lens-incentive-alignment exigem que SSC aplique regras versionadas, não interprete."
	}]

	// =============================================
	// COSTS ELIMINATED
	// =============================================

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			SSC elimina custo de processo manual de sourcing ao
			substituir fluxos informais (cotação por email, comparação
			em planilhas, decisão por reunião) por RFQ estruturada,
			aplicação determinística de regras sobre fitnessSignals e
			decisão auditável. A aplicabilidade de ce-02 aqui é por
			analogia estrutural: assim como no crédito a Mesh elimina
			custo de verificação documental manual, em SSC elimina
			custo de formalização e validação manual de processos de
			seleção competitiva. ce-04 (avaliação de risco com dados
			incompletos) será incorporado quando sinais de NIM
			estiverem disponíveis (oq-ssc-1 resolvido), permitindo que
			decisões de sourcing incorporem inteligência de rede
			(performance, confiabilidade, risco) além de sinais locais
			de RFQ.
			"""
		rationale: "ce-02 aplica diretamente a SSC: sourcing é etapa de compliance estruturado (anti-corrupção) que envolve documentação, validação e registro — exatamente o tipo de custo que mech-agent-gate elimina por automação determinística."
	}]

	// =============================================
	// INCENTIVE ANALYSIS
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Originadora — category manager declara tipo de decisão e configura fitness rules vigentes."
			desiredBehavior:           "Declarar tipo de decisão de boa-fé pré-RFQ; configurar fitness rules que reflitam critérios objetivos da categoria; aprovar overrides supervisionados apenas em casos genuínos."
			correctOperationIncentive: "Decisão estruturada com decisionRationale rico cria accountability; override frequente sustentado dispara drift detection (regression trigger no envelope SSC); responsabilidade jurídica (dp-10) recai sobre operador da plataforma + originadora em casos de fraude orçamentária. Velocidade operacional + audit trail limpo = KPI alinhado."
			manipulationVector:        "Manipular pesos de fitness rules via configuração para favorecer fornecedor preferido (aumenta peso de critério onde fornecedor X é forte; reduz peso onde X é fraco). OR aprovar overrides sistemáticos do agente para empurrar decisões manualmente. OR declarar tipo strategic-award para forçar formalização CTR contornando RFQ aberto."
			manipulationCost:          "Versionamento de fitness rules em config externa governada (bd-deterministic-decision-from-structured-signals consequence) com audit trail de mudanças; alteração drástica de pesos cross-RFQ é detectável via OBS metric (drift de peso por categoria); override sustentado dispara feedback loop P2P→SSC (oq-ssc-3) + regression trigger no envelope. Responsabilidade jurídica (dp-10) em casos de fraude orçamentária ou conluio cross-stakeholder."
			vsBenefit:                 "Benefício de manipulation = retenção de fornecedor preferido OR rapidez de aprovação. Custo: detection via OBS drift metrics + audit trail imutável + responsabilidade jurídica. Asymmetric cost design preserva utilidade para casos legítimos (pesos adaptáveis, override em exceção genuína) enquanto torna manipulation sistemática mais cara que operação correta."
			designResponse:            "Fitness rules como config externa governada com versionamento (per bd-deterministic-decision-from-structured-signals); audit trail de mudanças de configuração + decisões emitidas; OBS drift detection cross-categoria; supervisedDecision para override de fitness rules; feedback loop P2P→SSC (oq-ssc-3 deferred) detecta override-rate sustentado em decisões P2P como sinal de drift de fitness rules."
			rationale:                 "Originadora tem dois caminhos de manipulation (rules + overrides). Design response endurece ambos via versionamento + audit + drift detection — preservando flexibilidade legítima (rules ajustáveis com governance, overrides em exceção)."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "Fornecedor — submete cotação RFQ + aceita/rejeita designation/award."
			desiredBehavior:           "Cotar com preço e capacidade declarada que reflitam custos reais e capacidade operacional efetiva. Aceitar designation/award apenas se puder entregar conforme termos."
			correctOperationIncentive: "Cotação verdadeira ganha proporcionalmente ao fitness (qualidade técnica + preço + capacidade); reputation NIM (pós-bootstrap) recompensa entregas conforme award; manipulation detection (low-ball + delivery anomaly) reduz acesso futuro."
			manipulationVector:        "Low-ball cotação RFQ (preço artificialmente baixo + capacidade declarada acima do realista) para ganhar award + renegociar pós-decision OR entregar qualidade inferior. OR coalizão silenciosa entre fornecedores para repartir mercado em RFQs sub-threshold (collusion)."
			manipulationCost:          "Phase 0 sem NIM: detection limitada a comparação RFQ history (mediana de preço por categoria + variância) — out-of-range dispara escalation 'suspicious-input' em vez de aprovação automática. Pós-NIM bootstrap (oq-ssc-1): reputation decay automático via performanceScore + reliabilityScore. Coalizão tem detection cross-RFQ via Fracionamento pattern (act-detect-fragmentation-pattern do agent SSC pós-bootstrap)."
			vsBenefit:                 "Benefício de low-ball = ganhar contrato + renegociar OR entregar inferior. Custo Phase 0: escalation + revisão humana + responsabilidade contratual sob condições documentadas via decisionRationale; custo pós-NIM: reputation decay sustentado limita acesso a RFQs futuras. Asymmetric cost design assume detection signal robusto (RFQ history estruturado por SSC, não por fornecedor)."
			designResponse:            "Phase 0: fitness rules incluem comparação contra RFQ history (mediana + variância máxima); cotação fora de threshold dispara escalation 'suspicious-input' (move decisão para human gate quando structural defense é incompleta). Signal robustness shift: estruturar RFQ history como signal SSC-mantido. Detection backup via Fracionamento pattern. Pós-NIM bootstrap: incorporar performanceScore + reliabilityScore como signals adicionais — manipulation cost aumenta com reputation decay automático."
			rationale:                 "Fornecedor low-balling é vetor primário em RFQ pré-NIM. Design response combina structural defense (RFQ history como signal robusto) + escalation by exception (Phase 0 honestamente reconhece detection latente) + path de hardening pós-NIM."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Operador da plataforma — agente SSC aplica fitness rules sobre fitnessSignals."
			desiredBehavior:           "Aplicar regras determinísticas versionadas sobre signals estruturados sem interpretar signals. Escalar quando signals são insuficientes ou ambíguos. NÃO inferir performance/reputation/risk — consumir o que outros BCs produzem."
			correctOperationIncentive: "Operação imparcial via determinismo + signals externos = credibilidade do gate. Manipulation algorítmica detectável via Event Log + drift detection metrics no envelope. Promotion para autonomy maior depende de track record."
			manipulationVector:        "Viés algorítmico — modelo de avaliação SSC pode ter viés implícito (treinamento enviesado favorece padrões específicos). OR coalizão sh-01-sh-05 (category manager corrupto + agente desalinhado configurando rules para favorecer fornecedor específico). OR drift de aplicação de regra (agente começa a interpretar onde devia apenas aplicar — virando mini-NIM informalmente)."
			manipulationCost:          "Anti-mini-NIM design: SSC NÃO computa inferência (per bd-deterministic-decision-from-structured-signals); regras vivem em config externa governada (não no agent code); audit trail registra criteria + weights + evaluatedSuppliers + tradeoffs. Drift detection via OBS metrics no envelope SSC (cross-category fitness drift, override-rate sustentado, decision-rationale variance). lens-incentive-alignment + lens-game-theory-applied + lens-information-economics aplicadas em design review limitam zona cinza."
			vsBenefit:                 "Benefício de viés/coalizão = retenção de fornecedor preferido OR aceleração de processo. Custo: Event Log torna padrão detectável; gates determinísticos bloqueiam aplicação de regra fora do escopo; supervisedDecisions concentram pontos de julgamento em humano; responsabilidade jurídica (dp-10) sobre operador. Risco residual: viés sutil dentro do envelope autônomo — gap cross-BC compartilhado com outros BCs operados por agente."
			designResponse:            "P10 framing (gates determinísticos validam, agentes recomendam dentro de envelope). Fitness rules como config externa governada com versionamento. OBS drift detection cross-categoria. supervisedDecisions concentram pontos de decisão julgativa em humano (cancel-rfq, override de regra, ajuste de configuração). lens-incentive-alignment como guardrail cognitivo durante design review. Anti-mini-NIM em capability rationale."
			rationale:                 "Operador tem poder assimétrico sobre interpretação de signals e configuração de regras. Design response combina determinismo + governance externa + drift detection + lens-driven design review. Risco residual reconhecido honestamente — alignment proativo é gap cross-BC."
		}]
		rationale: """
			Análise cobre 3 vetores adversariais primários: (a) sh-01
			manipula pesos/regras de fitness; (b) sh-02 low-ball
			cotação OR collusion; (c) sh-05 viés algorítmico OR
			coalizão com sh-01. Vetores individuais com custos
			estruturalmente maiores que benefícios via design response
			(versionamento + audit + OBS drift detection + supervised
			gates + structural priority sobre detection). Vetores de
			coalizão (sh-01 + sh-05) ficam em risco residual cross-BC
			explicitamente reconhecido. Stakeholders sh-03, sh-04 não
			modelados Phase 0 (sh-03 não consume direto; sh-04 Bacen
			não regula sourcing operacional B2B). SSC preserva trail
			auditável de RFQ como evidência de processo competitivo,
			consumível sob demanda via STR/OBS, sem modelar regulador
			anticorrupção como stakeholder Phase 0.
			"""
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 2.4
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/ssc/agents/ssc-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "evaluate-fitness-signals"
				description: "Aplicar fitness rules versionadas sobre fitnessSignals estruturados — comparação determinística sem julgamento subjetivo. Output: decision recommendation OR escalation."
				rationale:   "Aplicação de regras determinísticas sobre signals estruturados é função, não julgamento. Pertence ao agente desde que regras + signals estejam disponíveis."
			}, {
				id:          "revalidate-qualification-pre-decision"
				description: "Re-consultar QueryParticipantStatus antes de emitir decisão; remover fornecedores rebaixados entre RFQ open e decision time."
				rationale:   "Re-validação é busca determinística sobre fonte autoritativa (NPM). Pertence ao agente; resultado pode disparar escalation se pool reduz a < 2."
			}, {
				id:          "evaluate-signal-sufficiency"
				description: "Verificar completude estrutural do fitnessSignals — todos signals required Phase 0 presentes e não-nulos. Decisão boolean: emitir vs escalar."
				rationale:   "Verificação estrutural de presença é deterministica. Sem signals suficientes, agente NÃO interpreta — escala (per bd-deterministic-decision-from-structured-signals)."
			}, {
				id:          "open-rfq"
				description: "Abrir RFQ a partir de demanda recebida + categoria + pool qualificado. Disparar RFQOpened para fornecedores convidados via NTF transversal."
				rationale:   "Abertura é função sobre input estruturado (demanda + pool qualificado pré-validado por NPM). Sem julgamento envolvido."
			}, {
				id:          "conclude-rfq-on-decision"
				description: "Concluir RFQ quando decisão é emitida. Disparar RFQConcluded para fornecedores via NTF transversal (vencedores + não-vencedores)."
				rationale:   "Conclusão é evento causal — decisão emitida ⇒ RFQ concluída. Sem julgamento."
			}, {
				id:          "publish-decision-events"
				description: "Publicar SourcingDecisionMade / PreferredSupplierDesignated / StrategicAwardCompleted após decisão registrada com decisionRationale rico (criteria + weights + evaluatedSuppliers + tradeoffs)."
				rationale:   "Publicação de fatos é append-only. Downstream (P2P, CTR) decide como reagir. decisionRationale rico sustenta NIM consumer futuro (oq-ssc-2)."
			}]
			supervisedDecisions: [{
				id:          "override-fitness-rule"
				description: "Aprovar override pontual de fitness rule para uma decisão específica — exceção a regra vigente com justificativa documentada."
				rationale:   "Override é decisão julgativa que viola escopo aplicador do agente. Pertence a category manager designado (sh-01)."
			}, {
				id:          "cancel-rfq"
				description: "Cancelar RFQ aberto antes de decisão — operação anula compromisso com fornecedores convidados."
				rationale:   "Cancelamento tem custo reputacional para fornecedores convidados; não é operação rotineira. Exige aprovação humana com justificativa."
			}, {
				id:          "approve-decision-with-insufficient-pool"
				description: "Aprovar decisão de sourcing quando re-validation reduz pool a 1 fornecedor — viola precondição de competitividade típica."
				rationale:   "Decisão com pool < 2 quebra premissa de seleção competitiva. Pode ser aceitável em casos genuínos (item proprietário, fornecedor único qualificado) mas exige aprovação humana."
			}, {
				id:          "configure-fitness-rules"
				description: "Configurar ou atualizar fitness rules vigentes para uma categoria — pesos, critérios, thresholds."
				rationale:   "Configuração de regras é decisão estratégica (qual critério importa para esta categoria) — não pertence ao escopo aplicador do agente. Versionada e auditada."
			}]
			escalationCriteria: [{
				id:        "insufficient-fitness-signal"
				condition: "fitnessSignals required Phase 0 incompleto OR contém valores inconsistentes (ex.: NPM eligibility=true mas qualificationScope expirado)."
				action:    "Escalar para category manager (sh-01) com listagem de signals faltantes/inconsistentes. Decisão NÃO emitida automaticamente."
				rationale: "Anti-mini-NIM: SSC não interpreta signal incompleto — reconhece insuficiência e escala. Phase 0 boolean sufficiency."
			}, {
				id:        "conflicting-fitness-signals"
				condition: "fitnessSignals contém signals contraditórios sem path determinístico de resolução (ex.: NPM eligibility=true mas existingCommitments indica fornecedor at-capacity)."
				action:    "Escalar para category manager com signals conflitantes destacados. Decisão NÃO emitida automaticamente."
				rationale: "Conflito não resolvível por regra é decisão julgativa — fora do escopo do agente."
			}, {
				id:        "insufficient-qualified-pool"
				condition: "Re-validation NPM no decision time reduz pool a < 2 fornecedores qualificados."
				action:    "Escalar para category manager. Decisão pode ser aprovada como supervisedDecision approve-decision-with-insufficient-pool com justificativa documentada."
				rationale: "Pool < 2 quebra premissa de competitividade — exige decisão humana sobre aceitabilidade do caso."
			}, {
				id:        "rfq-no-quotations-received"
				condition: "Janela de cotação fecha sem propostas válidas (zero respostas OR todas inválidas estruturalmente)."
				action:    "Escalar para category manager. Pode justificar reabertura com scope ajustado, cancelamento, OR aprovação supervised de exceção."
				rationale: "RFQ sem cotações é falha do mecanismo OR scope inviável — exige decisão humana."
			}, {
				id:        "fragmentation-pattern-detected"
				condition: "act-detect-fragmentation-pattern (agent-spec SSC) emite anomaly report indicando padrão coordenado: múltiplas RFQs sub-threshold do mesmo proponente OR mesmo fornecedor cross-categoria em janela curta."
				action:    "Escalar para founder/category manager com anomaly report. Pausar autonomia para proponente OR fornecedor afetado até decisão."
				rationale: "Threshold gaming é vetor adversarial conhecido (Q9 + lens-incentive-alignment). Detection é mecanismo SECUNDÁRIO; defesa primária estrutural depende de dados acumulados (Phase 0 limitação reconhecida)."
			}]
		}
		rationale: """
			ssc-primary-agent como operador, referenciado por path
			canônico (forward reference — agent-spec será autorado em
			Phase 4 do bootstrap WI-060). 6 autonomousDecisions
			(aplicação de regras + verificações estruturais +
			abertura/conclusão RFQ + publicação de fatos), 4
			supervisedDecisions (overrides + cancelamento + pool
			insuficiente + configuração de regras), 5 escalationCriteria
			cobrindo signals insuficientes/conflitantes + pool
			inadequado + RFQ sem cotações + manipulation pattern
			detectado. Boundaries refletem anti-mini-NIM principle:
			agente APLICA regras determinísticas; humano (sh-01) DECIDE
			julgamentos (overrides, configuração, exceções). Match com
			bd-deterministic-decision-from-structured-signals (RECTOR)
			+ bd-procurement-requires-sourcing-authority (P2P
			enforcement) + bd-rfq-lifecycle-public-minimal (cancel-rfq
			supervised).
			"""
	}

	// =============================================
	// ASSUMPTIONS
	// =============================================

	assumptions: [{
		id:                 "as-ssc-1"
		assumption:         "Pool de fornecedores qualificados em NPM é ≥ threshold mínimo viável (≥2 por categoria operada) para sustentar competitividade Phase 0."
		invalidationSignal: "Taxa de RFQs com escalation 'insufficient-qualified-pool' acima de threshold operacional (e.g., > 15% das RFQs abertas) sustentado em janela trimestral."
		rationale:          "bd-qualification-as-absolute-precondition pressupõe pool qualificado existente. Se invalidada, gate de qualificação regride para gate semi-manual ou aceitação de pool < 2 como norma — quebra premissa competitiva."
	}, {
		id:                 "as-ssc-2"
		assumption:         "RFQ history (mediana de preço + variância por categoria) é signal estruturável e mantido pelo SSC — não input do fornecedor manipulável."
		invalidationSignal: "Detecção de manipulation cross-RFQ via Fracionamento pattern OR drift sustentado de preço médio por categoria sem causa operacional identificável."
		rationale:          "Anti-low-balling design (incentive analysis sh-02 designResponse) depende de RFQ history como signal robusto. Se SSC não consegue manter history estruturada — virando input direto de fornecedor — defesa primária falha; detection latente vira única linha."
	}, {
		id:                 "as-ssc-3"
		assumption:         "Category managers operam sob KPIs governados pela originadora (sh-01 governance interna) — accountability via Event Log + decisionRationale + audit trail é suficiente para alinhamento Phase 0."
		invalidationSignal: "Override-rate de fitness rules sustentado acima de threshold OR padrão sistemático de overrides correlacionados com fornecedores específicos detectado via OBS drift metrics."
		rationale:          "bd-category-manager-as-sh-01-internal-function pressupõe accountability interna alinhada. Se invalidada, recipient Phase 0 (founder) absorve carga de validação caso a caso, ou recipient pós-PMF (category manager designado) precisa redesenho de governance interna."
	}]

	// =============================================
	// OPEN QUESTIONS
	// =============================================

	openQuestions: [{
		id:        "oq-ssc-1"
		question:  "Quais signals NIM expõe via published language para SSC consumir em fitnessSignals.performanceScore (reliability, category fitness, risk flags)? Como formalizar nim-to-ssc no context-map?"
		impact:    "Sem essa relação, fitnessSignals.performanceScore permanece null Phase 0; SSC opera com decisões 'first-order' (NPM + RFQ apenas) sem profundidade analítica que subdomain afirma como valor proprietário ('dado mais valioso para NIM'). Moat de inteligência da Mesh fica incompleto."
		deadline:  "2026-07-15"
		rationale: "Resolver durante NIM canvas bootstrap (WI-045). NIM canvas declara outbound events/queries com shape; context-map adiciona relação nim-to-ssc; SSC domain-model importa types. Phase 0 fitnessSignals layered: requiredPhase0 (NPM + RFQ) + optionalPhase0 (NIM/CTR)."
	}, {
		id:        "oq-ssc-2"
		question:  "NIM consome quais events SSC para aprender padrões de decisão? Reuso dos 3 events existentes (SourcingDecisionMade, PreferredSupplierDesignated, StrategicAwardCompleted — cada um já carrega decisionRationale rico) OR event dedicated novo? Como formalizar ssc-to-nim no context-map?"
		impact:    "Sem essa relação, NIM perde input estratégico afirmado pelo subdomain SSC ('dado mais valioso para NIM'). Moat de inteligência da Mesh é incompleto. Quando oq-ssc-1 + oq-ssc-2 fecharem juntos, declarar feedbackLoop no context-map (intelligence learning loop)."
		deadline:  "2026-07-15"
		rationale: "Resolver durante NIM canvas bootstrap (WI-045). Recomendação Phase 0: reuso dos 3 events existentes via NIM como consumer adicional aos events já declarados. Sem evento dedicated — payload decisionRationale rico já sustenta consumo NIM."
	}, {
		id:        "oq-ssc-3"
		question:  "Feedback loop P2P→SSC: como P2P sinaliza drift de preferred designation (override-rate sustained) para SSC redesignar? Novo event (PreferredOverrideRateAlert) OR mecanismo via OBS metrics?"
		impact:    "Sem feedback loop, drift de preferred designation (designation desalinhada com realidade operacional) não chega de volta ao SSC para redesignação — preferred fica stale até validUntil expirar OR override sustentado vira norma silenciosa."
		deadline:  "2026-09-30"
		rationale: "Phase 0 não modela. Pós-NIM bootstrap pode capturar este sinal indiretamente via NIM signals; pré-NIM, mecanismo via OBS metrics + manual review. Decisão estrutural depende de evidência empírica de override-rate em operação real."
	}, {
		id:        "oq-ssc-4"
		question:  "Quando P2P recebe demanda de procurement sem decisão SSC vigente nem contrato CTR vigente, qual é o fluxo request-sourcing-decision? Novo event/query SSC↔P2P para iniciar sourcing por demanda? OR escalation manual?"
		impact:    "Sem mecanismo formal, P2P fica em vazio estratégico ao receber demanda sem cobertura SSC — viola bd-procurement-requires-sourcing-authority OR força exceção supervisionada como caminho default."
		deadline:  "2026-09-30"
		rationale: "Phase 0: escalation manual. Pós-evidência empírica sobre frequência (se demanda sem cobertura SSC for raro, escalation suficiente; se sistemático, mecanismo formal justificável)."
	}, {
		id:        "oq-ssc-5"
		question:  "Cache invalidation cross-BC quando contrato CTR é cancelado/superseded pós-StrategicAward: como P2P descarta strategic award cache? Opções: (i) ctr-to-p2p relation; (ii) SSC re-publica StrategicAwardSuperseded; (iii) P2P sync query CTR pre-emissão."
		impact:    "Sem mecanismo, P2P consome strategic award cache indefinidamente após CTR cancelar contrato — drift de longo prazo, pedidos emitidos sob award invalidado."
		deadline:  "2026-09-30"
		rationale: "Phase 0 não modela; trade-off documentado. Janela de cache stale aceita Phase 0 — P2P assume strategic award válido até contrato CTR materializar; pós-materialização, contrato é SoT vinculante. Escolha entre (i)/(ii)/(iii) depende de pattern observado em operação."
	}, {
		id:        "oq-ssc-6"
		question:  "Definir shape completo de QualificationStatus exposto por NPM via QueryParticipantStatus: granularidade, escopo por categoria, validade temporal, flags de restrição, expiration date."
		impact:    "fitnessSignals.qualificationScope precisa shape concreto para SSC aplicar fitness rules sobre qualificação. Shape vago vira agente interpretando — viola anti-mini-NIM."
		deadline:  "2026-07-15"
		rationale: "Alinhar com NPM canvas no domain-model SSC. NPM define ontologia; SSC consome shape estabelecido por NPM."
	}, {
		id:        "oq-ssc-7"
		question:  "Formalizar ctr-to-ssc no context-map: SSC consumir existingCommitments (compromissos contratuais já em CTR para uma categoria) como signal opcional Phase 0 em fitnessSignals.existingCommitments?"
		impact:    "Sem essa relação, fitnessSignals.existingCommitments fica null — SSC não tem visibilidade de compromissos contratuais existentes que afetam capacidade real do fornecedor. Decisão SSC empobrecida em casos onde fornecedor já está saturado contratualmente."
		deadline:  "2026-09-30"
		rationale: "Alinhamento com CTR no domain-model SSC. Decisão depende de evidência empírica sobre frequência de relevância — se SSC raramente precisa visibilidade de compromissos contratuais existentes, relação é over-modeling."
	}, {
		id:        "oq-ssc-8"
		question:  "Configuração externa de fitness rules: shape, owner, lifecycle de versionamento. Onde vivem fitness rules versionadas? Como configurar pesos/critérios por categoria? Quem governa mudanças?"
		impact:    "bd-deterministic-decision-from-structured-signals depende de fitness rules em config externa governada. Sem shape definido, configuração vira ad-hoc — drift silencioso, audit trail fragmentado."
		deadline:  "2026-09-30"
		rationale: "Decisão estrutural sobre infraestrutura de configuração. Phase 0 pode operar com config simples (e.g., YAML em repo); Phase posterior exige shape formal + governance versionada + drift detection automática."
	}, {
		id:        "oq-ssc-9"
		question:  "Multi-round RFQ (BAFO best-and-final-offer): suporte estrutural a múltiplos rounds com lifecycle de cotações por round. Necessário Phase 0 OR evolução pós-feedback de mercado?"
		impact:    "Single-round RFQ é Phase 0; multi-round é pattern recorrente em B2B sofisticado (negociação iterativa entre rounds inicial e final). Sem suporte, casos multi-round são forçados a single-round subótimo OR escalation sistemática."
		deadline:  "2026-12-31"
		rationale: "Decisão estrutural baseada em evidência de mercado real. Construção civil brasileira (vertical inicial Mesh) tipicamente opera single-round; expansão para outros verticais OR sofisticação pode justificar multi-round."
	}]

	// =============================================
	// VERIFICATION METRICS
	// =============================================

	verificationMetrics: [{
		id:        "ssc-decision-cycle-time"
		metric:    "p95 do tempo entre RFQOpened e RFQConcluded (decisão emitida) por categoria, segregado por tipo de decisão (one-shot / preferred-designation / strategic-award)."
		target:    "< 7 dias úteis para 95% das RFQs one-shot; < 30 dias úteis para preferred-designation; < 90 dias para strategic-award (categoria + complexidade RFQ contracted)."
		rationale: "Latência alta por tipo indica problema distinto: one-shot lento sugere fitness rules ambíguas OR pool inadequado; preferred lento sugere category manager indecisão; strategic lento é inerente (RFQ formal + negociação)."
	}, {
		id:        "ssc-escalation-rate"
		metric:    "Percentual de RFQs/decisões que disparam algum escalationCriterion (insufficient-fitness-signal, conflicting-fitness-signals, insufficient-qualified-pool, rfq-no-quotations-received, fragmentation-pattern-detected) sobre total."
		target:    "< 15% das RFQs abertas sustentado em janela trimestral."
		rationale: "Taxa alta indica fitness signals frágeis OR pool insuficiente OR signals ambíguos — invalidação de as-ssc-1 OR as-ssc-2. Taxa muito baixa (< 5%) pode indicar escalation thresholds frouxos demais."
	}, {
		id:        "ssc-supervised-override-rate"
		metric:    "Percentual de decisões SSC que envolvem supervisedDecision (override-fitness-rule, approve-decision-with-insufficient-pool, configure-fitness-rules ad-hoc) sobre total."
		target:    "< 10% das decisões totais sustentado em janela trimestral."
		rationale: "Taxa alta indica fitness rules desalinhadas com realidade operacional OR category manager interferindo sistematicamente — invalidação de as-ssc-3. Disparo de regression trigger no envelope SSC."
	}]

	// =============================================
	// RATIONALE OUTER
	// =============================================

	rationale: """
		SSC é início do macrofluxo canônico Mesh: SSC → {P2P, CTR} →
		CMT → BDG → DLV → INV → FCE. Decide qual fornecedor atende
		qual categoria de demanda, aplicando regras determinísticas a
		sinais estruturados — não interpretando, não inferindo. Frase
		canônica: SSC decide sourcing. CTR formaliza contrato. P2P
		executa compra.

		Supporting + operational-enabler + product (Wardley) reflete
		domínio com padrões estabelecidos integrado ao macrofluxo Mesh
		como decisão estruturada com decisionRationale rico que
		alimenta NIM (rede). Vertical-agnostic — primitivas universais
		B2B. Gateway primary + analysis secondary captura papel de
		gate de progressão + análise de fitness signals. 4 capabilities
		operacionais (cc-04 auditoria contínua + cc-03 24/7 + captura
		estruturada de decisionRationale + modelo canônico via query).

		7 businessDecisions ortogonais por classe de comportamento:
		(1) bd-deterministic-decision-from-structured-signals (RECTOR
		— lógica de decisão); (2) bd-sourcing-decides-not-formalizes-
		not-executes (FRONTEIRA cross-BC com CTR/P2P); (3)
		bd-decision-type-is-declared-upfront (INVARIANT comportamento
		SSC — testável via audit trail timing + correspondence); (4)
		bd-procurement-requires-sourcing-authority (INVARIANT
		comportamento P2P); (5) bd-qualification-as-absolute-
		precondition (GATE NPM); (6) bd-rfq-lifecycle-public-minimal
		(VISIBILIDADE); (7) bd-category-manager-as-sh-01-internal-
		function (GOVERNANCE humana). Cada com forma testável
		distinta.

		3 stakeholders Phase 0 (sh-01 + sh-02 + sh-05) — sh-03 e
		sh-04 não modelados (justificativas explícitas). 3 vetores
		adversariais com cost > benefit por design (versionamento +
		audit + drift detection + supervised gates). Coalizão sh-01-
		sh-05 reconhecida como risco residual cross-BC. Trail
		auditável de RFQ via STR/OBS sustenta compliance anti-
		corrupção sem modelar regulador como stakeholder.

		Governance: 6 autonomousDecisions (aplicação de regras +
		verificações estruturais + RFQ lifecycle + publicação de
		fatos), 4 supervisedDecisions (overrides + cancelamento +
		pool < 2 + configuração de rules), 5 escalationCriteria
		(signals insuficientes/conflitantes + pool inadequado + RFQ
		sem cotações + manipulation pattern). Boundaries refletem
		anti-mini-NIM: agente APLICA regras; humano DECIDE
		julgamentos.

		costsEliminated: ce-02 (compliance documental por analogia
		estrutural) Phase 0; ce-04 (avaliação de risco com dados
		incompletos) será incorporado pós-NIM bootstrap (oq-ssc-1
		resolvido).

		Lenses analíticas (4):
		- lens-organizational-resource-allocation (primária):
		  alocação de oportunidade de fornecimento entre fornecedores
		  qualificados sob critérios estruturados. Aplicação direta:
		  fitness rules + decision events estruturam allocation
		  auditável.
		- lens-information-economics (secundária): assimetria
		  informacional comprador↔fornecedor + equalização TCO +
		  detection de signaling adversarial (low-balling). Aplicação:
		  signal-robustness audit (cotação como signal frágil; RFQ
		  history como signal robusto SSC-mantido).
		- lens-incentive-alignment (secundária): vetores adversariais
		  + defesa via gates determinísticos + supervisedDecisions.
		  Aplicação: 3 vetores em incentiveAnalysis com manipulation
		  cost > benefit por design; signal robustness shift como
		  defesa primária; detection backup como segunda linha.
		- lens-event-driven-architecture-patterns (terciária): 3
		  events de decisão + 3 events RFQ lifecycle + OHS+ACL com
		  P2P/CTR + subscription transversal NTF/OBS.
		lens-mechanism-design aparece como influência indireta
		(RFQ é mechanism mas SSC aplica, não desenha — regras vivem
		em config externa governada per oq-ssc-8).

		3 assumptions (pool qualificado viável + RFQ history
		estruturável + accountability category manager) com
		invalidationSignals concretos. 9 openQuestions cobrindo:
		formalização cross-BC com NIM (oq-ssc-1, oq-ssc-2, oq-ssc-7)
		+ feedback loops e cache invalidation (oq-ssc-3, oq-ssc-4,
		oq-ssc-5) + shape de signals e configuração (oq-ssc-6,
		oq-ssc-8) + multi-round RFQ (oq-ssc-9). 3 verificationMetrics
		(decision cycle time + escalation rate + supervised override
		rate) com targets concretos.

		Anti-mini-NIM como invariant transversal: SSC NÃO interpreta
		signals, NÃO infere performance, NÃO computa reputation —
		consome o que outros BCs (NPM, NIM, CTR) produzem e estrutura
		o que vem da RFQ. Captura estruturada de decisionRationale é
		moat de inteligência (alimenta NIM); aplicação determinística
		de regras versionadas é credibilidade do gate. Phase 0
		operável sem NIM/CTR signals (camada minimum suficiente);
		evolução Phase posterior incorpora signals adicionais como
		enriquecimento analítico, sem alterar responsabilidade do BC.
		"""
}
