package p2p

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Procure-to-Pay.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// P2P é o segundo BC do macrofluxo Mesh (SSC → {P2P, CTR} → CMT →
// BDG → DLV → INV → FCE). Executa a porção 'Procure' do nome
// canônico Procure-to-Pay: emite Purchase Orders sob autoridade de
// sourcing pré-existente. NÃO cobre pagamento (FCE) nem faturamento
// (INV) — Phase 0 escopo deliberadamente restrito a PO emission +
// hand-off para CMT (formalização de compromisso). O nome
// 'Procure-to-Pay' reflete escopo conceitual completo do BC; Phase 0
// entrega apenas a primeira porção ('Procure') sob ground rules
// claras de boundary.
//
// Frase canônica do trio: SSC decide sourcing. P2P emite pedido sob
// authority. CMT formaliza compromisso. (CTR formaliza contrato em
// caminho strategic-award; CTR active overrides SSC strategic-award
// como authority hard quando pós-Phase 1+.)
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). 5 ciclos de red team aplicados pre-write + 2 founder
// ajustes (Adj 1 escopo Phase 0 explícito; Adj 2 strategic-award
// authority transition precisa: Phase 0 advisory → Phase 1+ hard).
//
// Materializado em 4 commits incrementais:
//   1.1 — skeleton: identity + classification + roles (este commit)
//   1.2 — capabilities + communication
//   1.3 — businessDecisions + stakeholders + costsEliminated + incentiveAnalysis
//   1.4 — ownership.governanceScope + assumptions + openQuestions + verificationMetrics + rationale outer
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.

canvas: artifact_schemas.#Canvas & {
	code: "p2p"
	name: "Procure-to-Pay"

	purpose: """
		Emitir Purchase Orders sob autoridade de sourcing pré-existente,
		fazendo hand-off da demanda formalizada para CMT (compromisso
		econômico). P2P é gateway do macrofluxo entre decisão de
		sourcing (SSC) e formalização de compromisso (CMT) — sem PO
		canônico vinculado a authority válida, demanda flui fora da
		rede e o registro do POR QUÊ a compra foi feita fica perdido.
		Phase 0 cobre apenas a porção 'Procure' do nome canônico
		Procure-to-Pay: emissão de PO + cancelamento pré-formalização.
		NÃO cobre faturamento (INV), pagamento (FCE) nem reconciliação
		— estes são BCs distintos downstream do macrofluxo.
		P2P NÃO decide sourcing — consome decisões SSC; NÃO formaliza
		contrato — consome (Phase 1+) ContractActivated CTR; NÃO
		revalida qualificação NPM — confia na decisão SSC pós-validação.
		Anti-mini-NIM: P2P não computa fitness, performance, allocation
		— apenas APLICA decisão upstream em emit determinístico.
		"""

	ubiquitousLanguageRef: "contexts/p2p/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque procurement é domínio com padrões
			estabelecidos (purchase order, three-way match, supplier
			coordination) — não é proprietário da Mesh. O valor
			proprietário está na captura estruturada de PO authority
			(authorityRef + authorityType) que conecta sourcing decision
			(SSC) a commitment formalization (CMT) com audit trail
			completo, não no processo de PO em si.
			Operational-enabler (mesmo bucket que SSC) porque P2P
			habilita progressão estruturada do macrofluxo entre decisão
			SSC e formalização CMT — distinto de revenue-generator
			(produtos financeiros) e compliance-enforcer (regulatórios
			explícitos). P2P EXECUTA decisões upstream em pedidos
			concretos com gate determinístico de authority — isto é
			uma forma de enabling: sem PO canônico, demanda flui fora
			da rede e perde captura. Product (Wardley) porque PO +
			procurement workflow são padrões amplamente cobertos por
			soluções de mercado (e-procurement, ERP P2P modules); a
			Mesh adapta integrando ao macrofluxo com authority
			validation + audit Lei 12.846 procurement.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			PO emission + sourcing authority validation operam sobre
			primitivas universais (purchase order, supplier reference,
			authority reference, allocation policy) que não dependem
			da vertical de aplicação. P2P nasce aplicado à construção
			civil (vertical inicial Mesh), mas seus mecanismos —
			authority gate determinístico, lifecycle público
			emitted/cancelled, audit trail regulatory-grade — são
			reutilizáveis em qualquer cadeia produtiva B2B com
			vocabulário adaptado.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["execution"]
		rationale: """
			Gateway como primário: P2P é gate de progressão do
			macrofluxo entre SSC (decisão) e CMT (compromisso) — sem
			PO canônico vinculado a authority, CMT não recebe sinal
			estruturado de demanda formalizada (per
			bd-procurement-requires-sourcing-authority herdado de SSC).
			Execution como secundário: P2P EXECUTA decisões SSC em
			emissões concretas de PO, distinto de SSC analysis
			(secondary) que ANALISA fitness signals para decidir.
			P2P NÃO é decision (SSC) nem coordination (CMT) — esta
			separação será articulada em
			bd-purchase-order-as-execution-not-decision em commit 1.3.
			"""
	}

	// =============================================
	// CAPABILITIES — placeholder; conteúdo em commit 1.2
	// =============================================

	capabilities: {
		operational: [{
			description: "Placeholder — capabilities operacionais (4 entries) entram em commit 1.2."
			rationale:   "Skeleton commit 1.1 estabelece shape; conteúdo substantivo (cap-01 sourcing-authority validation + cap-02 PO lifecycle + cap-03 audit Lei 12.846 + cap-04 24/7 via authority gate) entra em commit 1.2."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 1.2
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa (8 inbound: 3 SSC events + 1 CTR event Phase 1+ + 2 commands + 2 query-surfaces; 4 outbound: 2 published events + 2 query-dependencies) entra em commit 1.2."
	}

	// =============================================
	// STAKEHOLDERS — placeholder; conteúdo em commit 1.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 1.3."
		impactDescription: "Placeholder — completado em commit 1.3."
		rationale:         "Skeleton stakeholder; 3 stakeholders substantivos (sh-01 originadora absorvendo requisitantes/compradores, sh-02 fornecedor, sh-05 operador agente) em commit 1.3."
	}]

	// =============================================
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 1.3
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Placeholder — preenchido em commit 1.3."
			desiredBehavior:           "Placeholder."
			correctOperationIncentive: "Placeholder."
			manipulationVector:        "Placeholder."
			manipulationCost:          "Placeholder."
			vsBenefit:                 "Placeholder."
			designResponse:            "Placeholder."
			rationale:                 "Skeleton; 3 participants com manipulation vectors substantivos (sh-01 maverick PO emission; sh-02 price drift pós-PO; sh-05 bias em multi-supplier allocation) em commit 1.3."
		}]
		rationale: "Placeholder — incentive analysis completo (3 vetores adversariais) entra em commit 1.3."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.4
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/p2p/agents/p2p-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 1.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-057). governanceScope completo (autonomousDecisions + supervisedDecisions + escalationCriteria) entra em commit 1.4."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.4
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + 6 businessDecisions + 5 anti-mini-NIM defense layers + 4 lenses + Phase 0 caveats incluindo escopo Procure-to-Pay restrito a Procure + strategic-award authority transition Phase 0 advisory → Phase 1+ hard) entra em commit 1.4."
}
