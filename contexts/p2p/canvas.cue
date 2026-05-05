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
	// CAPABILITIES (4)
	// =============================================

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description:   "Auditoria contínua e regulatory-grade de POs emitidos: cada PO carrega authorityRef + authorityType + supplier + scope + amount imutáveis pós-emit; rationale completo (qual SSC decision/preferred/strategic embasou a authority) anexado; trail satisfaz Lei 12.846 procurement audit (5 anos retention)."
			rationale:     "PO sem audit trail de authority é decoração — Lei 12.846 exige justificabilidade do processo competitivo. Capability matches cap-04 do domain-definition (audit contínuo); P2P-specific aspect: authorityRef preserva ligação com decisão SSC + (Phase 1+) contract CTR."
		}, {
			capabilityRef: "cc-03"
			description:   "Operação 24/7 via gate determinístico de authority: emit PO requer apenas QuerySourcingDecision sync (cache projection local) + (strategic Phase 1+) QueryContractStatus sync; sem janelas de aprovação humana no caminho normal. Gate é função numérica (authority válida sim/não), não julgamento."
			rationale:     "Capability matches cc-03 do domain-definition (24/7 disponibilidade); P2P-specific aspect: authority gate é deterministic (sim/não), não exige reasoning. Maverick exception é supervisedDecision separado."
		}, {
			description: "PO lifecycle público mínimo via 2 events pareados (PurchaseOrderEmitted + PurchaseOrderCancelled) consumed por CMT como sinal canônico de demanda formalizada/retirada; preserva confidencialidade competitiva (cotações + comparações vivem em SSC, não em P2P)."
			rationale:   "Sem capability própria de domain-definition — emerge da análise dos businessDecisions: lifecycle público mínimo (2 events) é decisão estrutural, não capability transversal. Complemento aos 3 events SSC (RFQOpened/Concluded/Cancelled) que cobrem fase decision; P2P events cobrem fase execution."
		}, {
			description: "Authority validation determinística pré-emit consultando cache local (prj-active-purchase-authorities derivada de 3 SSC events ACL) + sync fallback (QuerySourcingDecision); maverick (PO sem authority) bloqueado no gate, escalado como supervisedDecision approve-po-without-sourcing-authority."
			rationale:   "Sem capability própria de domain-definition — capability core do P2P. Sustenta bd-procurement-requires-sourcing-authority (RECTOR) operacionalmente: gate determinístico (não inferência) garante que demanda sem authority canônica não vira PO autonomamente."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// COMMUNICATION
	// =============================================

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "ssc"
			event:         "SourcingDecisionMade"
			reaction:      "P2P consume via ACL e atualiza prj-active-purchase-authorities com authority type=one-shot-decision (hard binding direta). Cache permite emit subsequente sem sync query a SSC."
			description:   "One-shot decision implica PO único para escopo específico; binding hard significa P2P emite SOMENTE para selectedSuppliers da decisão. Override = supervisedDecision."
		}, {
			type:          "event-consumer"
			sourceContext: "ssc"
			event:         "PreferredSupplierDesignated"
			reaction:      "P2P consume via ACL e atualiza prj-active-purchase-authorities com authority type=preferred-designation (soft binding) + validityPeriod. POs subsequentes da categoria emitem para preferredSuppliers até validUntil expirar OU override sustentado disparar drift signal."
			description:   "Soft binding: agente emite para preferred SEM consultar SSC novamente (cache), mas pode override com audit trail (autonomous-with-audit). Múltiplos POs por designação ao longo do validityPeriod."
		}, {
			type:          "event-consumer"
			sourceContext: "ssc"
			event:         "StrategicAwardCompleted"
			reaction:      "Phase 0: P2P consume via ACL e atualiza prj-active-purchase-authorities com authority type=strategic-award (advisory binding, CTR contract ainda não materializado). Phase 1+: pós-ContractActivated CTR (forward-ref oq-p2p-1), authority bumped para hard (CTR contract overrides SSC strategic-award)."
			description:   "Advisory Phase 0 porque contrato CTR ainda não existe — P2P pode emitir POs sob strategic-award mas authorityType reflete advisory. Hard binding ativa apenas pós-CTR ContractActivated. Per oq-ssc-5: cache stale pós-CTR cancel é openQuestion compartilhada."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractActivated"
			reaction:      "PHASE 1+ FORWARD-REF — NÃO operacional Phase 0. Quando materializar (oq-p2p-1): P2P consume via ACL e atualiza prj-active-purchase-authorities elevando authority type de strategic-award (advisory) para strategic-award-with-active-contract (hard). Pós-ContractActivated, P2P emit POs sob hard binding contratual."
			description:   "PHASE 1+ FORWARD-REF: ctr-to-p2p relation NÃO existe no context-map atual; será adicionada quando CTR contract activation event materializar (Phase 1+ horizon per oq-p2p-1). Antes desse marco, P2P opera sob advisory binding apenas para strategic-award POs — entry declarada aqui como known future consumer para evitar refactor estrutural posterior, NÃO como dependency operacional Phase 0."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Originadora (sh-01: requisitante OU comprador) submete demanda de compra estruturada com supplierRef candidato + categoryRef + scope + amount."
			command:         "EmitPurchaseOrder"
			resultingEvents: ["PurchaseOrderEmitted"]
			description:     "Sync command: agente valida authority via cache + sync fallback; outcome immediate (emit OR escalation). Authority gate determinístico."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Originadora solicita cancelamento de PO previamente emitida pré-CMT formalization (e.g., demand cancelled, scope mismatch detected, supplier withdrawal)."
			command:         "CancelPurchaseOrder"
			resultingEvents: ["PurchaseOrderCancelled"]
			description:     "Sync command supervised. Cancel apenas pré-CMT formalization Phase 0 (per bd-cancellation-pre-formalization-only). Pós-CMT cancellation é cross-BC oq-p2p-2."
		}, {
			type:        "query-surface"
			query:       "QueryActivePurchaseOrders"
			returnType:  "ActivePurchaseOrders"
			description: "Retorna POs ativas por categoryRef OR supplierRef OR requesterRef — lista com authority + status + emittedAt + cancellation status. Consumida por controllers (reporting), supervisores (visibility), e CMT (cross-check pré-formalização)."
		}, {
			type:        "query-surface"
			query:       "QueryPurchaseOrderById"
			returnType:  "PurchaseOrder"
			description: "Retorna PurchaseOrder completa por purchaseOrderId — payload incluindo authorityRef + authorityType + supplier + scope + amount + audit metadata. Consumida por CMT (formalization input), CTR (cross-check para strategic award), DRC futuro (dispute context)."
		}]
		outbound: [{
			type:        "event-publisher"
			trigger:     "Authority validada + EmitPurchaseOrder approved → PO emitido + PurchaseOrderEmitted publicado para CMT (hard binding ACL — CMT formaliza compromisso a partir do PO)."
			event:       "PurchaseOrderEmitted"
			consumers: ["cmt"]
			description: "Hard binding para CMT: PurchaseOrderEmitted é trigger canônico de commitment lifecycle. CMT consume via ACL (per p2p-to-cmt context-map). Phase 0 NIM consumer pendente (PO data como signal NIM Phase 1+ — paralelo a oq-ssc-2)."
		}, {
			type:        "event-publisher"
			trigger:     "Cancel approved (supervisedDecision pré-CMT formalization) → PO status=cancelled + PurchaseOrderCancelled publicado para CMT como sinal de retirada (withdrawal/negative signal): CMT pode ter consumido PurchaseOrderEmitted mas ainda não formalizado commitment; ao receber Cancelled, CMT cancela path de formalização sem produzir CommitmentAccepted."
			event:       "PurchaseOrderCancelled"
			consumers: ["cmt"]
			description: "Withdrawal/negative signal a CMT antes de commitment formalization: P2P sinaliza que PO foi retirada — CMT cancela path de formalização correspondente sem produzir CommitmentAccepted. Caso CMT já tenha formalizado commitment (race condition pós-PurchaseOrderEmitted antes de PurchaseOrderCancelled chegar), pós-CMT cancellation requer cross-BC coordination separada (oq-p2p-2 deferred). Phase 0 cobre apenas pre-CMT formalization withdrawal."
		}, {
			type:          "query-dependency"
			targetContext: "ssc"
			query:         "QuerySourcingDecision"
			purpose:       "Sync fallback quando cache local (prj-active-purchase-authorities) miss para dado authorityRef proposto. Phase 0 caminho secundário: cache hit é caminho normal."
			description:   "Cache derivado de 3 SSC events ACL é fast path; sync query é fallback quando authorityRef não está no cache (e.g., evento ainda não consumido). Latência tolerada porque autoridade gate é precondition, não loop crítico."
		}, {
			type:          "query-dependency"
			targetContext: "ctr"
			query:         "QueryContractStatus"
			purpose:       "PHASE 1+ FORWARD-REF — NÃO operacional Phase 0. Quando materializar (oq-p2p-1): pós-StrategicAwardCompleted, P2P consulta CTR para verificar se ContractActivated foi emitido (authority bumped advisory→hard). Phase 0: query NÃO usado (CTR contract status query ainda não existe); P2P opera sob advisory binding apenas."
			description:   "PHASE 1+ FORWARD-REF: query NÃO existe no shape público de CTR atual — será materializado quando CTR contract activation flow estiver formalizado. Entry declarada aqui como known future dependency para evitar refactor estrutural posterior, NÃO como dependency operacional Phase 0. Antes da materialização, P2P trata todo strategic-award como advisory; pós-materialização, query desambigua advisory vs hard."
		}]
		rationale: """
			Inbound: 4 event-consumers (3 SSC events ACL operacionais
			Phase 0 com authority discriminator + 1 CTR ContractActivated
			declarado como PHASE 1+ FORWARD-REF, NÃO operacional Phase 0
			— ctr-to-p2p relation no context-map materializa apenas
			Phase 1+ pós-oq-p2p-1), 2 command-handlers sync
			(EmitPurchaseOrder com gate determinístico +
			CancelPurchaseOrder supervised), 2 query-surfaces
			(QueryActivePurchaseOrders por categoria/supplier/requester
			+ QueryPurchaseOrderById para CMT/CTR cross-check).
			Outbound: 2 event-publishers (PurchaseOrderEmitted hard
			binding CMT + PurchaseOrderCancelled como withdrawal/
			negative signal pre-CMT) + 2 query-dependencies
			(QuerySourcingDecision SSC operacional Phase 0 como
			fallback ao cache + QueryContractStatus CTR PHASE 1+
			FORWARD-REF para authority bump advisory→hard, NÃO
			operacional Phase 0). PO confidentiality preservada via
			separation: cotações + comparações vivem em SSC; P2P
			emite PO supplier-specific (cross-supplier invisibility é
			design constraint do agente — supplier API materializa
			Phase 1+ per oq-p2p-4). Counterparty original supplier
			confidential via NTF transversal não declarada como
			outbound individual (paralelo a SSC RFQ events).
			"""
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
