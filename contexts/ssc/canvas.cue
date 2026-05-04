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
	// STAKEHOLDERS — placeholder; conteúdo em commit 2.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 2.3."
		impactDescription: "Placeholder — completado em commit 2.3."
		rationale:         "Skeleton stakeholder; 3 stakeholders substantivos (sh-01, sh-02, sh-05) em commit 2.3."
	}]

	// =============================================
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 2.3
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Placeholder — preenchido em commit 2.3."
			desiredBehavior:           "Placeholder."
			correctOperationIncentive: "Placeholder."
			manipulationVector:        "Placeholder."
			manipulationCost:          "Placeholder."
			vsBenefit:                 "Placeholder."
			designResponse:            "Placeholder."
			rationale:                 "Skeleton; 3 participants com manipulation vectors substantivos em commit 2.3."
		}]
		rationale: "Placeholder — incentive analysis completo (3 vetores adversariais) entra em commit 2.3."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 2.4
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/ssc/agents/ssc-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 2.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-060). governanceScope completo (6 autonomousDecisions + 4 supervisedDecisions + 5 escalationCriteria) entra em commit 2.4."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 2.4
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + 7 businessDecisions + 4 lenses + Phase 0 caveats + anti-mini-NIM principle) entra em commit 2.4."
}
