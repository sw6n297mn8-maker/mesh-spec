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
	// BUSINESS DECISIONS (6)
	// =============================================

	businessDecisions: [{
		id: "bd-procurement-requires-sourcing-authority"
		decision: """
			Toda PurchaseOrder emitida AUTONOMAMENTE por P2P EXIGE
			authority válida pré-existente: one-shot-decision
			(SourcingDecisionMade vigente) OR preferred-designation
			(PreferredSupplierDesignated com validUntil futuro) OR
			strategic-award (StrategicAwardCompleted vigente; Phase 0
			advisory; Phase 1+ pós-ContractActivated CTR vira hard).
			PO sem authority canônica é maverick — bloqueado no gate
			determinístico, escalado como supervisedDecision approve-po-
			without-sourcing-authority com justificativa documentada.
			"""
		consequences: """
			Spend não-controlado (maverick) eliminado por construção
			no caminho autônomo; emergências/exceções têm path
			supervisado explícito (não silencioso). Gate determinístico
			é precondition de cap-03 (24/7) — sem authority, sem PO
			autônomo, sem fluxo. Authority transition strategic-award
			Phase 0→Phase 1+ é monotônica (advisory→hard nunca
			regresso) per oq-p2p-1.
			"""
		rationale: """
			RECTOR herdado de SSC bd-procurement-requires-sourcing-
			authority: P2P é o BC que materializa essa decisão —
			gateway entre sourcing (SSC) e commitment (CMT). Sem este
			gate, P2P emit POs sem captura do POR QUÊ — viola moat de
			inteligência (decisão fica fora da rede). Maverick path
			supervised preserva flexibilidade real (emergency, ad-hoc,
			fixed-price low-value) sem regredir RECTOR.
			"""
	}, {
		id: "bd-purchase-order-as-single-concept-with-authority-ref"
		decision: """
			PurchaseOrder é conceito único da P2P, não 3 tipos paralelos.
			Discriminador é authorityRef (apontando para 1 de 3 sources)
			+ authorityType (one-shot-decision | preferred-designation |
			strategic-award) que determinam binding regime + override
			semantics. Strategic-award authorityType refina-se em
			Phase 1+ pós-ContractActivated CTR (advisory→hard).
			"""
		consequences: """
			Schema #PurchaseOrder uniforme (1 aggregate em domain-model);
			lifecycle público uniforme (2 events pareados Emit/Cancel);
			binding regime derivado de authorityType (hard/soft/advisory).
			Diferenciação não-redundante com SSC's 3 decision types
			(SSC discrimina decisão; P2P discrimina origem da
			authority). Authority transition Phase 0→Phase 1+
			documentada via oq-p2p-1 sem mutar PO existentes (events
			imutáveis).
			"""
		rationale: """
			Modelar 3 PO types paralelos a SSC seria acoplamento
			desnecessário — P2P emite single PO concept. Discriminador
			authorityRef desacopla P2P da estrutura interna SSC e
			permite evolução independente (e.g., novos authority types
			Phase 1+ sem cascade refactor em P2P). Per 5 ciclos red
			team: framing inicial '3 PO types' substituído por 'single
			PO + authorityRef'.
			"""
	}, {
		id: "bd-allocation-policy-respected-in-aggregate"
		decision: """
			P2P respeita SSC allocationPolicy em AGREGADO (cross-PO),
			não per-PO individual. Para multi-supplier authority com
			split-by-percentage (e.g., 60/40 entre 2 suppliers), P2P
			distribui POs ao longo da janela de validade tal que volume
			emitido converge para a percentagem declarada — não força
			cada PO a ter exatamente 60/40 internamente.
			"""
		consequences: """
			P2P precisa projeção de volume emitido por authorityRef +
			supplier (prj-allocation-tracking) para enforce convergência.
			Drift de allocation (real vs SSC policy) é signal back para
			SSC (sig-allocation-drift, OBS metrics — oq-p2p-7). Single-
			supplier authority (allocation type=single) trivializa essa
			decisão. Bias agente em allocation routing (sh-05 vetor) é
			medido por desvio sistemático da policy declarada.
			"""
		rationale: """
			Per Q1 do canvas SSC: multi-supplier first-class via lista
			selectedSuppliers + allocationPolicy. P2P respeita a policy
			aggregate-level porque cada PO individual atende uma
			demanda específica (não pode ser fracionado per-PO sem
			escopo absurdo). Aggregate-level enforcement é teste real
			da policy via observação de comportamento ao longo do
			tempo.
			"""
	}, {
		id: "bd-cancellation-pre-formalization-only"
		decision: """
			PurchaseOrderCancelled Phase 0 cobre APENAS cancelamento
			pré-CMT formalization (CMT ainda não publicou
			CommitmentAccepted derivado do PO). Pós-CMT cancellation
			é cross-BC coordination (CMT cancellation flow) — NÃO
			modelado em P2P Phase 0.
			"""
		consequences: """
			Lifecycle público de PO Phase 0: requested → emitted |
			cancelled (3 states; cancelled é pré-CMT terminal).
			Pós-CMT cancellation per oq-p2p-2 — Phase 1+ via cross-BC
			coordination flow ainda não formalizado. Janela de
			cancellation Phase 0 é estreita (entre PurchaseOrderEmitted
			e CommitmentAccepted) — caso comum porque CMT consume
			rapidamente.
			"""
		rationale: """
			Modelar pós-CMT cancellation Phase 0 exigiria coordenação
			cross-BC com CMT (CMT cancellation flow + downstream
			implications BDG/DLV/INV/FCE). Phase 0 deliberate: limitar
			a janela onde P2P aggregate é authoritative (pré-
			formalização). Cross-BC cancellation flow é trabalho
			estrutural separado (oq-p2p-2 deferred).
			"""
	}, {
		id: "bd-no-supplier-revalidation-by-p2p"
		decision: """
			P2P NÃO revalida NPM eligibility de supplier antes de
			emitir PO. P2P confia na decisão SSC (que validou
			qualification em decision time + re-validation pre-decision
			via QueryParticipantStatus). Se supplier foi rebaixado
			pós-SSC decision, isso é problema de SSC (revalidate
			authority + re-issue OR escalate); P2P emite per
			authorityRef vigente e cadeia handles.
			"""
		consequences: """
			P2P NÃO consulta NPM (operationalScope sem QueryParticipant
			Status). P2P consume signal que SSC já validou. Janela de
			risco entre SSC decision e P2P emit é mitigada por SSC
			pol-revalidate-on-status-changed (NPM event ACL) +
			cmd-revalidate-rfq-pool. Anti-mini-NIM enforced: P2P NÃO
			computa eligibility, NÃO infere qualification — apenas
			executa per authority válida.
			"""
		rationale: """
			Anti-mini-NIM RECTOR: P2P revalidando NPM seria duplicar
			SSC's responsibility e introduzir possible drift entre
			SSC view e P2P view de eligibility. NPM é single-owner
			de qualification (dp-04); SSC é single-owner de
			'qualification em sourcing context'; P2P consume decisão
			SSC pós-validação. Cadeia de responsabilidade clara.
			"""
	}, {
		id: "bd-purchase-order-lifecycle-public-minimal"
		decision: """
			Toda PurchaseOrder que percorre fluxo normal (requested →
			emitted) DEVE emitir PurchaseOrderEmitted. Toda PurchaseOrder
			cancelada pré-CMT DEVE emitir PurchaseOrderCancelled como
			withdrawal/negative signal a CMT. Não há saída do lifecycle
			sem evento público correspondente.
			"""
		consequences: """
			CMT consume PurchaseOrderEmitted como trigger canônico de
			commitment lifecycle; PurchaseOrderCancelled como sinal
			de retirada antes de formalização. NTF transversal notifica
			supplier via PO events (paralelo a SSC RFQ events). OBS
			observabilidade rastreia emit/cancel rates. Avaliação
			interna (authority validation, allocation tracking)
			permanece intra-P2P — confidencialidade competitiva
			preservada (cotações + scoring ficam em SSC; P2P externaliza
			apenas fact 'PO emitted to supplier X under authority Y').
			"""
		rationale: """
			Paralelo a bd-rfq-lifecycle-public-minimal de SSC. Lifecycle
			público mínimo (2 events) é precondition de macrofluxo:
			CMT precisa de signal canônico para formalizar; supplier
			precisa de notification; observability precisa de trail.
			Privacy de pricing/scope preservada porque events carregam
			refs (não payload completo de cotação histórica).
			"""
	}]

	// =============================================
	// STAKEHOLDERS (3)
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Originadora absorvendo requisitantes (declaram demanda) e compradores (validam authority + submetem EmitPurchaseOrder ao agente). Em pre-PMF, sh-01 é founder ou função interna designada; pós-PMF, requisitantes podem ser distribuídos por área operacional + compradores centralizados. Phase 0 modela como entidade única (originadora) sem diferenciar requisitante/comprador internamente."
		impactDescription: "Originadora ganha (a) gate determinístico de authority — POs sem sourcing authority bloqueados no caminho autônomo (audit defensible); (b) lifecycle público mínimo — POs emitidas têm trail completo (Lei 12.846 procurement audit); (c) allocation policy respeitada em agregado — multi-supplier diversification preservada per SSC decisão upstream."
		rationale:         "Modelo paralelo a SSC: sh-01 absorve roles operacionais (requisitantes técnicos + compradores) sob entidade única originadora. Diferenciação requisitante/comprador é Phase 1+ quando volume + complexity justify (deferred fora do escopo Phase 0)."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Fornecedor respondente: recebe PurchaseOrderEmitted via NTF transversal; pode aceitar ou rejeitar via canal próprio (supplier API Phase 1+); pré-aceite, supplier não tem visibilidade de outros POs concorrentes intra-categoria. Phase 0 modela apenas notification (NTF); aceite/rejeição materializa Phase 1+ via supplier API (oq-p2p-4)."
		impactDescription: "Fornecedor ganha (a) PO trail audit-defensible vinculando demanda a authority (anti-renegotiation pressure post-emit per immutability); (b) confidencialidade cross-supplier (não vê outros POs intra-categoria); (c) override-rate sustentado disparando feedback signal a SSC (supplier confidence quanto sustained relevance). Risco: PO emitida implica entrega/aceite no horizonte; cancelamento Phase 0 é supervisedDecision pré-CMT (não cross-BC)."
		rationale:         "Fornecedor é segundo stakeholder essencial do procurement workflow. Phase 0 supplier API NOT modeled (oq-p2p-4); supplier interaction reduzida a notification + confidentiality enforcement. Pós-Phase 0, supplier pode acknowledge/reject formalmente via API."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador agente (agt-p2p-primary): valida authority via cache + sync fallback; emit PO sob authority válida; cancel PO supervised pré-CMT; detecta drift de allocation policy (sig-allocation-drift cross-PO); detecta padrões maverick (POs sub-threshold). Anti-mini-NIM enforced: NÃO interpreta supplier performance, NÃO computa allocation, NÃO revalida NPM eligibility — APLICA decisões upstream."
		impactDescription: "Operador agente ganha (a) gate determinístico claro — autoridade válida sim/não (não julgamento); (b) escalation routing definido — maverick attempts viram supervisedDecision approve-po-without-sourcing-authority; (c) audit trail regulatory-grade reduz blast radius operacional. Risco: drift agente em allocation routing (bias) é vetor adversarial sh-05 — design response via deterministic allocation routing per SSC policy."
		rationale:         "Operador agente como stakeholder reflete dp-08 (incentive alignment): agente é participante operacional com incentivos próprios; design tem que prever drift potencial. Anti-mini-NIM enforcement protege boundaries (P2P não vira mini-SSC ou mini-NPM)."
	}]

	// =============================================
	// COSTS ELIMINATED
	// =============================================

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			P2P elimina custo de transação 'spend não-controlado' via
			bd-procurement-requires-sourcing-authority RECTOR: emit PO
			autônomo apenas sob authority pré-validada SSC. Maverick
			(PO sem authority) bloqueado no gate; emergências
			supervised path. Trail authority + supplier + scope
			imutável Phase 0 satisfaz Lei 12.846 procurement audit
			(5 anos).
			"""
		rationale: """
			Phase 0 single-ref por analogia estrutural a SSC (que
			também declarou ce-02 single-ref Phase 0). ce-04 deferred
			pós-NIM bootstrap quando feedback loop NIM↔P2P para drift
			detection materializa (oq-p2p-3 + oq-ssc-1/2).
			"""
	}]

	// =============================================
	// INCENTIVE ANALYSIS (3 participants — paralelo a SSC)
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Originadora — requisitante OU comprador submetendo demanda ao agente para emit PO."
			desiredBehavior:           "Submeter demandas com authorityRef válido derivado de SSC decision pre-existente; usar maverick path (supervisedDecision) apenas em emergências/exceções genuínas."
			correctOperationIncentive: "Trail audit-defensible (Lei 12.846); gate determinístico evita ambiguidade de approval; escalation path supervised quando authority falta (não silencioso)."
			manipulationVector:        "Emit POs sem authority canônica via maverick approval (supervisedDecision) sustained — bypass do RECTOR via abuse do escape hatch supervised. OR emit POs sub-threshold em janela curta para evitar SSC decision (fragmentation pattern)."
			manipulationCost:          "Audit trail captura authorityRef ausente (maverick) ou pattern de POs sub-threshold (fragmentation detection cross-PO via prj-purchase-history-by-category, paralelo a SSC prj-rfq-history). Founder review supervised approvals; OBS drift metrics rastreiam maverick rate sustained."
			vsBenefit:                 "Benefício de bypass = velocidade (evita SSC ciclo) ou alinhamento com supplier preferido fora do escopo SSC. Custo: Event Log + audit Lei 12.846 torna maverick rate observable; supervisedDecisions concentram pontos de julgamento em humano (founder Phase 0); responsabilidade jurídica (dp-10) sobre operador. Risco residual: maverick approvals sustained se founder aprovar sem escrutínio (controle pre-PMF)."
			designResponse:            "P10 framing (gate determinístico + supervised exception). Maverick rate como verificationMetric. Fragmentation detection cross-PO Phase 0 (oq-p2p-6). Anti-mini-NIM em capability rationale. lens-incentive-alignment como guardrail cognitivo."
			rationale:                 "Originadora tem dois caminhos de manipulation (maverick supervised abuse + fragmentation). Design response endurece ambos via observability (rate sustained) + estrutural (fragmentation detection cross-PO)."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "Fornecedor respondente recebendo PurchaseOrderEmitted; via canal próprio (Phase 1+) acknowledge/reject."
			desiredBehavior:           "Receber PO + executar conforme scope/amount/terms imutáveis pós-emit; reportar capacidade real para SSC RFQ via canal supplier (não pressionar P2P para renegotiation pós-PO)."
			correctOperationIncentive: "PO immutable pós-emit = previsibilidade contratual; supplier override-rate sustained dispara SSC drift signal (preferred designation revisita). Confidentialidade cross-supplier (não vê POs concorrentes intra-categoria) preserva estratégia comercial."
			manipulationVector:        "Pressionar comprador (sh-01) ou agente para renegotiation pós-PO (price drift sustained) explorando dependência operacional. OR coordenar com outros suppliers para inflar cotações em SSC (collusion upstream que P2P só observa via override patterns)."
			manipulationCost:          "PO immutable pós-emit (P2P aggregate); cancel apenas supervisedDecision Phase 0 com justificativa documentada. supplier-override-rate sustained = drift signal a SSC (manual review pré-PMF; Phase 1+ NIM consume). Collusion upstream é SSC concern (não P2P)."
			vsBenefit:                 "Benefício de pressure = melhor margin no PO específico. Custo: visibility de override pattern + audit trail; preferred designation pode ser perdida se override-rate sustained. Risco residual: P2P single PO com renegotiation success se agente cede sem audit (mitigated por immutable PO post-emit)."
			designResponse:            "PO immutability post-emit by design (P2P aggregate lifecycle). Override-rate signal Phase 0 via OBS metrics; Phase 1+ feedback loop formalizado SSC (oq-ssc-3 + oq-p2p-3). Confidentialidade cross-supplier via supplier API design Phase 1+."
			rationale:                 "Fornecedor tem dois caminhos adversariais (price drift sustained intra-PO + collusion upstream em SSC). Design response endurece intra-PO via immutability + supplier-override-rate signal; collusion upstream é SSC concern."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Operador agente — valida authority + emit PO + detect drift/maverick patterns."
			desiredBehavior:           "Validar authority deterministically; emit PO sob authority válida; cancelar PO supervised quando solicitado; detectar drift/maverick patterns; escalation routing per category. Anti-mini-NIM: NÃO interpretar performance, NÃO computar allocation, NÃO revalidar NPM."
			correctOperationIncentive: "Gate determinístico = sem ambiguidade de decisão (não julgamento); supervisedDecision para casos fora do envelope; audit trail regulatory-grade reduz blast radius operacional + responsabilidade jurídica (dp-10)."
			manipulationVector:        "Bias em multi-supplier allocation routing — desvio sistemático da SSC allocationPolicy declarada favorecendo certos suppliers (e.g., sempre routing para supplier A em authority A/B 60/40 ao invés de aggregate convergence). OR emitir POs sem revalidation de cache stale (e.g., authority expirada). OR coalizão sh-01-sh-05: agente emite POs maverick em volume alinhado com sh-01 desejos."
			manipulationCost:          "sig-allocation-bias detection (P2P prj-allocation-tracking compara emit vs policy); fragmentation detection cross-PO; OBS drift metrics rastreiam authority cache freshness. Coalizão sh-01-sh-05 detectada via correlation founder-approval-rate + maverick-rate sustained (founder review)."
			vsBenefit:                 "Benefício de bias = simplificação operacional (favorecer supplier conhecido). Custo: detection observable + audit trail + responsabilidade jurídica. Risco residual: viés sutil dentro do envelope autônomo (mitigated por deterministic allocation routing per SSC policy + sig-allocation-bias)."
			designResponse:            "Anti-mini-NIM em capability rationale (P2P aplica decisão, não decide). Deterministic allocation routing per SSC allocationPolicy (não probabilistic). sig-allocation-bias OBS Phase 0; integration NIM Phase 1+. lens-incentive-alignment guardrail cognitivo durante design review."
			rationale:                 "Operador agente tem três vetores adversariais (allocation bias + cache stale exploitation + coalizão sh-01). Design response endurece via deterministic routing + observability + anti-mini-NIM enforcement em capability rationale. Risco residual reconhecido (gap cross-BC compartilhado com SSC)."
		}]
		rationale: """
			3 participants cobrindo originadora (sh-01: maverick +
			fragmentation), fornecedor (sh-02: price drift + collusion
			upstream), operador agente (sh-05: bias allocation + cache
			exploit + coalizão). Design response cross-cutting:
			P10 framing + audit observability + supervisedDecisions
			concentram pontos de julgamento em humano + responsabilidade
			jurídica (dp-10) + lens-incentive-alignment como guardrail.
			Anti-mini-NIM enforced em capability rationale (P2P aplica,
			não decide).
			"""
	}

	// =============================================
	// OWNERSHIP + GOVERNANCE SCOPE
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/p2p/agents/p2p-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "validate-sourcing-authority"
				description: "Validar authorityRef proposto contra prj-active-purchase-authorities (cache local) com sync fallback a QuerySourcingDecision SSC. Outcome: authority válida (caminho autônomo) OR insufficient/stale (escalation insufficient-context)."
				rationale:   "Validação determinística sobre signal estruturado (authorityRef + cache + ttl) é função, não julgamento. Pertence ao agente desde que cache + query disponíveis."
			}, {
				id:          "match-authority-to-supplier"
				description: "Verificar que supplierRef proposto está em selectedSuppliers/preferredSuppliers/awardedSuppliers do authority vigente. Outcome: match (continua) OR mismatch (escalation conflicting-signals: supplier fora da decisão)."
				rationale:   "Verificação estrutural de pertinência é deterministic. Sem match, agente NÃO substitui supplier autonomamente — escala (per anti-mini-NIM)."
			}, {
				id:          "emit-po-on-valid-authority"
				description: "Emit PurchaseOrder + publish PurchaseOrderEmitted quando authority + supplier match. Aggregate lifecycle requested → emitted (terminal hand-off para CMT)."
				rationale:   "Emit é função sobre input estruturado (authority válida + supplier match + scope/amount). Sem julgamento envolvido."
			}, {
				id:          "publish-po-lifecycle-events"
				description: "Publicar PurchaseOrderEmitted (hard binding CMT) ou PurchaseOrderCancelled (withdrawal/negative signal pré-CMT) após state transition. NTF transversal notifica supplier."
				rationale:   "Publicação de fatos é append-only. Downstream (CMT) decide como reagir."
			}, {
				id:          "enforce-allocation-policy"
				description: "Para multi-supplier authority com split allocationPolicy, distribuir POs ao longo da janela de validade tal que volume emitido converge para policy declarada. Detecta desvio via prj-allocation-tracking."
				rationale:   "Aplicação de regra determinística sobre histórico observável é função. Bias detection (sig-allocation-bias) é signal, não decision."
			}]
			supervisedDecisions: [{
				id:          "approve-po-without-sourcing-authority"
				description: "Aprovar emit de PO em maverick path (sem authority canônica) — emergência, fixed-price low-value, regulatory exception. Justificativa documentada obrigatória."
				rationale:   "Maverick é exceção real ao RECTOR; gate humano necessário porque julgamento sobre 'esta exceção é genuína' viola escopo aplicador do agente."
			}, {
				id:          "cancel-emitted-po"
				description: "Cancelar PO emitida pré-CMT formalization. Custo reputacional (supplier notificado de cancellation); demanda real foi sinalizada e revertida."
				rationale:   "Cancelamento tem custo reputacional para supplier; não é operação rotineira. Exige aprovação humana com justificativa."
			}, {
				id:          "override-allocation-policy"
				description: "Aprovar emit de PO que viola allocationPolicy declarada (e.g., emergência para supplier não-preferred). Raro Phase 0."
				rationale:   "Override de allocation é decisão estratégica (qual supplier prioritize fora da policy) — não pertence ao escopo aplicador do agente."
			}]
			escalationCriteria: [{
				id:        "insufficient-authority"
				condition: "authorityRef proposto não está em prj-active-purchase-authorities (cache miss) E QuerySourcingDecision sync retorna not-found OR cache+query retornam authority expirada (validUntil < now)."
				action:    "Escalar para originadora (sh-01) com listagem de authorities ativas para a categoria. PO NÃO emitida automaticamente. Caminho permitido: maverick supervised approval com justificativa OR retornar para SSC para nova decisão."
				rationale: "Anti-mini-NIM: P2P não infere authority — reconhece ausência e escala. Originadora decide se vai por maverick OU rebooting via SSC."
			}, {
				id:        "conflicting-authority"
				condition: "supplierRef proposto NÃO está em authority.selectedSuppliers (one-shot) / preferredSuppliers (preferred) / awardedSuppliers (strategic). OR authorityRef tem múltiplos supplier candidates conflicting (rare edge case)."
				action:    "Escalar para originadora com authority + suppliers candidatos. Decisão NÃO emitida automaticamente."
				rationale: "Mismatch supplier vs authority é decisão julgativa (corrigir supplier OR revisitar authority) — fora do escopo do agente."
			}, {
				id:        "suspicious-pattern"
				condition: "act-detect-fragmentation-pattern (agent-spec P2P) emite anomaly report indicando padrão coordenado: múltiplos POs sub-threshold mesmo proponente OR mesmo supplier cross-categoria em janela curta."
				action:    "Escalar para founder/originadora com anomaly report. Pausar autonomia para proponente OR supplier afetado até decisão (block scope = ator afetado, não global)."
				rationale: "Maverick fragmentation é vetor adversarial sh-01 (paralelo a SSC fragmentation). Detection é mecanismo SECUNDÁRIO Phase 0; defesa primária estrutural via cross-BC coordination pendente."
			}, {
				id:        "authority-exhausted"
				condition: "preferred designation expirada (validUntil ≤ now) sem renovação SSC pendente; OR strategic-award authority sem supplier ativo (todos rebaixados em NPM upstream — P2P apenas observa via SSC events ACL, não revalida NPM diretamente per bd-no-supplier-revalidation-by-p2p)."
				action:    "Escalar para originadora. Pode justificar reboot via SSC (nova decisão) OR maverick supervised approval com justificativa de urgência."
				rationale: "Authority expirada/exausta = ausência de fonte canônica. P2P não fala 'pool' (pool de fornecedores qualificados é responsabilidade SSC, não P2P) — fala authority. Renomeação intencional reforça bd-no-supplier-revalidation-by-p2p: P2P observa authority válida vs ausente, não revalida pool composition."
			}, {
				id:        "regulatory-fiscal-ambiguity"
				condition: "PO envolve estrutura fiscal/regulatória zona cinza — fornecedor sob sanção during PO lifetime, cross-border supply com regulatório específico, fiscal anomaly em scope/amount."
				action:    "Escalar para founder com parecer especializado required. PO bloqueada até decisão."
				rationale: "Integridade legal é constraint inviolável (nível 1 per CLAUDE.md). Zona cinza exige julgamento humano especializado — compliance officer ou category manager designado."
			}]
		}
		rationale: """
			agt-p2p-primary como operador, referenciado por path
			canônico (forward reference — agent-spec será autorado em
			Phase 4 do bootstrap WI-057). 5 autonomousDecisions
			(validation + match + emit + publish + allocation
			enforcement), 3 supervisedDecisions (maverick approval +
			cancel emitted + override allocation), 5 escalationCriteria
			cobrindo authority issues + supplier mismatch + fragmentation
			pattern + authority exhaustion (NÃO 'pool exhaustion' — P2P
			não possui supplier pool; apenas authority válida vs ausente,
			reforçando bd-no-supplier-revalidation-by-p2p) + regulatory
			ambiguity. Boundaries refletem anti-mini-NIM principle:
			agente APLICA decisão SSC determinísticamente; humano
			(sh-01 OR founder pre-PMF) DECIDE julgamentos (maverick
			approvals, cancellations, allocation overrides, regulatory
			edge cases). Match com bd-procurement-requires-sourcing-
			authority (RECTOR) + bd-no-supplier-revalidation-by-p2p
			(anti-mini-NIM) + bd-cancellation-pre-formalization-only
			(Phase 0 boundary).
			"""
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.4
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + 6 businessDecisions + 5 anti-mini-NIM defense layers + 4 lenses + Phase 0 caveats incluindo escopo Procure-to-Pay restrito a Procure + strategic-award authority transition Phase 0 advisory → Phase 1+ hard) entra em commit 1.4."
}
