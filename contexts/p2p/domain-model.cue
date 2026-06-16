package p2p

// domain-model.cue — Domain Model do BC Procure-to-Pay.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Materializado via authoring manual section-by-section per
// manualAuthoringProtocol (adr-057). Cascade ordering per adr-053/
// adr-054 dec 13: PG existe; canvas P2P + glossary P2P estabelecidos
// (Phases 1+2 do WI-057).
//
// 1 aggregate central: agg-purchase-order (consistency boundary do
// processo de emissão de PO sob authority pré-validada SSC). rootIdentity
// = purchaseOrderId (PO existe desde t=0 mesmo se attempt for recorded
// sem progredir para emitted — semântica "emit attempt recorded" per
// founder Patch 1; lifecycle requested → emitted | cancelled com cancel
// reachable de ambos requested e emitted).
//
// Behavior-first ordering aplicado: events identificados primeiro do
// canvas (2 published de PO lifecycle + 3 internal ACL de SSC);
// commands derivados de canvas inbound (EmitPurchaseOrder + Cancel
// PurchaseOrder); invariants protegidos derivados dos 6 businessDecisions;
// value-objects emergentes dos payloads + glossary terms.
//
// Multi-supplier first-class via authorityRef discriminator per Q1 do
// canvas: P2P emite PO supplier-specific (1 supplier por PO) sob
// authorityRef que aponta para SSC decision; multi-supplier semantics
// vive em allocationPolicy do upstream SSC decision (P2P respeita policy
// em agregado via prj-allocation-tracking, não por pedido individual).
// PurchaseOrder é conceito único, NÃO 3 tipos paralelos — discriminação
// é via authorityType (one-shot-decision | preferred-designation |
// strategic-award).
//
// Lenses aplicadas:
// - lens-organizational-resource-allocation (primária): aggregate
//   modela alocação de POs sob authority pré-validada (allocation
//   policy upstream SSC respeitada em agregado)
// - lens-incentive-alignment (secundária): invariants e gate
//   determinístico de authority protegem contra 3 vetores adversariais
//   (sh-01 fragmentation, sh-02 renegotiation, sh-05 allocation bias)
// - lens-event-driven-architecture-patterns (secundária): 2 events
//   published + 3 internal ACL; 4 projections como read models
// - lens-information-economics (terciária): authorityRef preserving
//   link to sourcing decision rationale rich, NIM intelligence
//   learning loop bridge Phase 1+
//
// Glossary alignment: 15 terms canônicos do glossary (Phase 2)
// reconciliados com events/commands/aggregates/value-objects.
//
// Convenção List (paralelo a SSC/IDC): campos com kind "domain-type"
// cujo type termina em "List" denotam coleção (ex.: SupplierRefList).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "p2p"
	name:              "Procure-to-Pay Domain Model"
	boundedContextRef: "p2p"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-purchase-order-emitted"
		name:        "PurchaseOrderEmitted"
		visibility:  "published"
		description: "Pedido de Compra emitido com authority validada — supplier-specific, hard binding operational signal para CMT formalizar commitment econômico bilateral. Carrega authorityRef + authorityType + supplier + scope + amount imutáveis."
		rationale:   "Event publisher canvas.communication.outbound[]. CMT consume como trigger canônico de commitment lifecycle (p2p-to-cmt context-map, ACL hard binding). Phase 0 NIM consumer pendente (PO data como signal NIM Phase 1+ — paralelo a oq-ssc-2). Materializa term-purchase-order-emitted do glossary. Hard binding é OPERATIONAL signal (caráter inevitável do trigger downstream), NÃO obrigação contratual estabelecida — contrato é responsabilidade CTR para strategic-award; CMT formaliza commitment econômico bilateral pós-PO emit per Patch 3 founder glossary. Confidencialidade competitiva preservada: NTF transversal notifica supplier-specific (não broadcast cross-supplier)."
		fields: [{
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind:           "value-object-ref"
			name:           "authorityRef"
			valueObjectRef: "vo-authority-ref"
		}, {
			kind:           "value-object-ref"
			name:           "authorityType"
			valueObjectRef: "vo-authority-type"
		}, {
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind: "primitive"
			name: "emittedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "emittedBy"
			type: "string"
		}, {
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Originadora — área/função que solicitou demanda (term-originadora-de-demanda)."
		}]
	}, {
		code:        "evt-purchase-order-cancelled"
		name:        "PurchaseOrderCancelled"
		visibility:  "published"
		description: "Pedido de Compra cancelado — withdrawal/negative signal a CMT pré-commitment formalization. CMT cancela path de formalização correspondente sem produzir CommitmentAccepted. Phase 0 cobre apenas pre-CMT cancellation (pós-CMT cancellation requer cross-BC coordination separada — oq-p2p-2 deferred)."
		rationale:   "Event publisher canvas outbound. CMT consume como sinal de retirada (não evento de cancelamento downstream-formalizado). Materializa term-purchase-order-cancelled do glossary. Phase 0 cobre 2 cenários: (a) cancelamento de PO emitida pré-CMT formalization (originadora retira demanda; supplier withdraw; scope mismatch detected); (b) cancelamento de attempt recorded (PO em estado requested cuja validation falhou e founder/admin cancela explicitamente para limpar audit trail). Per Patch 4 founder, lifecycle inclui requested→cancelled E emitted→cancelled."
		fields: [{
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
			description:    "Optional — populated apenas quando cancellation ocorre de state emitted (PO já tinha supplier vinculado); ausente quando cancel ocorre de state requested (attempt failed validation antes de supplier binding)."
		}, {
			kind: "primitive"
			name: "cancelledAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-cancellation-reason"
		}]
	}, {
		code:          "evt-sourcing-decision-made-received"
		name:          "SourcingDecisionMadeReceived"
		visibility:    "internal"
		sourceContext: "ssc"
		description:   "Tradução ACL de SourcingDecisionMade (SSC). Trigger para atualização de prj-active-purchase-authorities com authority type=one-shot-decision (hard binding direta)."
		rationale:     "Event interno traduzido de sinal externo de SSC (ssc-to-p2p, hybrid). Domain model permanece puro — linguagem local. Sufixo -received segue convenção ACL estabelecida em CMT/BDG/SSC. Materializa hard binding cache feed: P2P emit subsequente sob esta authority sem sync query a SSC. Override = supervisedDecision per canvas inbound."
		fields: [{
			kind: "primitive"
			name: "sourcingDecisionId"
			type: "string"
			description: "Reference a SSC vo-sourcing-decision-id (boundary cross-BC; P2P consume identidade SSC-mantida)."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "selectedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef selecionados pela decisão SSC (≥1; tipicamente 1; multi-supplier suportado per Q1 canvas SSC)."
		}, {
			kind:        "domain-type"
			name:        "allocationPolicy"
			type:        "AllocationPolicy"
			description: "Policy de allocation upstream SSC (single | split-by-percentage | split-by-criteria). P2P respeita em agregado via prj-allocation-tracking + inv-allocation-convergence-aggregate-level."
		}, {
			kind: "primitive"
			name: "receivedAt"
			type: "datetime"
		}]
	}, {
		code:          "evt-preferred-supplier-designated-received"
		name:          "PreferredSupplierDesignatedReceived"
		visibility:    "internal"
		sourceContext: "ssc"
		description:   "Tradução ACL de PreferredSupplierDesignated (SSC). Trigger para atualização de prj-active-purchase-authorities com authority type=preferred-designation (soft binding) + validityPeriod."
		rationale:     "Event interno traduzido de SSC. Soft binding: P2P emite POs subsequentes da categoria para preferredSuppliers até validUntil expirar OU override sustentado disparar drift signal. Múltiplos POs por designação ao longo do validityPeriod. Override = autonomous-with-audit per canvas inbound."
		fields: [{
			kind: "primitive"
			name: "sourcingDecisionId"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "preferredSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef preferidos para a categoria (≥1; tipicamente >=1)."
		}, {
			kind:        "domain-type"
			name:        "allocationPolicy"
			type:        "AllocationPolicy"
			description: "Policy de allocation para preferred designation."
		}, {
			kind: "primitive"
			name: "validUntil"
			type: "datetime"
			description: "Expiração passiva da designação (sem evento de expiry Phase 0)."
		}, {
			kind: "primitive"
			name: "receivedAt"
			type: "datetime"
		}]
	}, {
		code:          "evt-strategic-award-completed-received"
		name:          "StrategicAwardCompletedReceived"
		visibility:    "internal"
		sourceContext: "ssc"
		description:   "Tradução ACL de StrategicAwardCompleted (SSC). Phase 0: trigger para atualização de prj-active-purchase-authorities com authority type=strategic-award (advisory binding — CTR contract ainda não materializado). Phase 1+: pós-ContractActivated CTR (forward-ref oq-p2p-1), authority bumped para hard."
		rationale:     "Event interno traduzido de SSC. Advisory Phase 0 porque contrato CTR ainda não existe — P2P pode emitir POs sob strategic-award mas authorityType reflete advisory. Hard binding ativa apenas pós-CTR ContractActivated (PHASE 1+ FORWARD-REF). Per oq-ssc-5: cache stale pós-CTR cancel é openQuestion compartilhada."
		fields: [{
			kind: "primitive"
			name: "sourcingDecisionId"
			type: "string"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "awardedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef premiados para formalização contratual via CTR Phase 1+."
		}, {
			kind:        "domain-type"
			name:        "allocationPolicy"
			type:        "AllocationPolicy"
		}, {
			kind: "primitive"
			name: "receivedAt"
			type: "datetime"
		}]
	}]

	// =============================================
	// COMMANDS (intenções de mudança de estado)
	// =============================================

	commands: [{
		code:        "cmd-emit-purchase-order"
		name:        "EmitPurchaseOrder"
		description: "Solicitação para emitir Pedido de Compra para supplier específico sob authorityRef vigente. Sync. Resultado: agg-purchase-order criado em initialState=requested ('emit attempt recorded' per Patch 1 founder); se inv-purchase-order-requires-valid-authority validation passa, transição requested→emitted + evt-purchase-order-emitted publicado para CMT. Se validation falha, aggregate persiste em requested (audit trail de tentativa) — pode ser cancelado posteriormente via cmd-cancel-purchase-order para limpar."
		rationale:   "Entry point principal do BC. Aggregate creation: cmd-emit-purchase-order creates agg-purchase-order directly em initialState=requested e tenta transition para emitted via guard inv-purchase-order-requires-valid-authority — schema #Lifecycle não suporta create transition (from: ∅), criação implícita via initialState. Per Patch 1 founder, semântica de requested é 'emit attempt recorded', NÃO 'PO válida aguardando emissão' — validation success transita imediato para emitted no caminho síncrono; validation failure deixa aggregate em requested como audit trail (originadora pode then submeter cmd-cancel-purchase-order ou retentar com authorityRef diferente). Materializa term-authority-validation gate determinístico do glossary."
		fields: [{
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Originadora — área/função que solicita demanda."
		}, {
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind:        "primitive"
			name:        "claimedAuthorityRef"
			type:        "string"
			description: "AuthorityRef que originadora reivindica como cobertura — sourcingDecisionId apontando para SSC decision (one-shot/preferred/strategic). Validado pelo gate determinístico via prj-active-purchase-authorities + sync fallback QuerySourcingDecision."
		}, {
			kind:        "primitive"
			name:        "requestedAt"
			type:        "datetime"
			description: "Timestamp do request — sustenta audit trail de attempt mesmo se validation falhar."
		}]
	}, {
		code:        "cmd-cancel-purchase-order"
		name:        "CancelPurchaseOrder"
		description: "Cancelar Pedido de Compra. Sync supervised. Phase 0 cobre 2 cenários: (a) cancelamento de PO emitida pré-CMT formalization (originadora retira demanda; supplier withdraw; scope mismatch detected) — emitted→cancelled + evt-purchase-order-cancelled como withdrawal/negative signal a CMT; (b) cancelamento de attempt recorded em estado requested — requested→cancelled (limpa audit trail de attempt sem progressão para emit). supervisedDecision per bd-cancellation-pre-formalization-only; pós-CMT cancellation é cross-BC oq-p2p-2 deferred."
		rationale:   "Command de saída do lifecycle. Per Patch 4 founder, lifecycle tem 2 transitions de cancel: requested→cancelled (limpa attempt failed) E emitted→cancelled (withdrawal pre-CMT). Cancel apenas pré-CMT formalization Phase 0 (per bd-cancellation-pre-formalization-only). Materializa term-purchase-order-cancelled do glossary."
		fields: [{
			kind:           "value-object-ref"
			name:           "purchaseOrderId"
			valueObjectRef: "vo-purchase-order-id"
		}, {
			kind:           "value-object-ref"
			name:           "reason"
			valueObjectRef: "vo-cancellation-reason"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}]
	}]

	// =============================================
	// INVARIANTS (regras protegidas)
	// =============================================

	invariants: [{
		code:      "inv-purchase-order-requires-valid-authority"
		name:      "Pedido de Compra Exige Authority Válida"
		rule:      "Toda transição requested→emitted (PO progredindo de attempt recorded para PO emitida) EXIGE authorityRef vigente apontando para uma SSC decision válida no momento do emit. Authority válida significa: (a) one-shot-decision (SourcingDecisionMade vigente para o categoryRef + supplier ∈ selectedSuppliers) OR (b) preferred-designation (PreferredSupplierDesignated com validUntil > emittedAt + supplier ∈ preferredSuppliers + categoryRef match) OR (c) strategic-award (StrategicAwardCompleted vigente; Phase 0 advisory binding; supplier ∈ awardedSuppliers + categoryRef match; Phase 1+ requer ContractActivated CTR para hard binding per oq-p2p-1). Sem authority válida, transição NÃO ocorre — aggregate permanece em state requested (attempt recorded). Override = supervisedDecision approve-po-without-sourcing-authority (escalation para gate humano com justificativa documentada)."
		rationale: "Invariante RECTOR de P2P per bd-emission-requires-sourcing-authority. P10 (gates determinísticos validam, agentes recomendam). Anti-mini-NIM: sem este invariant, P2P viraria 'mini-SSC' decidindo sourcing fora de processo competitivo — viola moat de inteligência da Mesh + integridade de boundary. Materializa term-authority-validation + term-sourcing-authority do glossary. Cross-BC dependency declarada em dependsOnAggregateState per adr-055."
		dependsOnAggregateState: {
			boundedContextRef: "ssc"
			aggregateRef:      "agg-sourcing-process"
			accessVia: {
				kind:               "sync-query"
				canvasQuerySurface: "QuerySourcingDecision"
			}
			rationale: "SSC é single-owner de sourcing decisions (term-sourcing-authority do glossary). P2P consume authority via prj-active-purchase-authorities (cache local derivada de 3 ACL events) com sync fallback via canvas query-surface QuerySourcingDecision quando cache não tem entry para authorityRef reivindicado (cache miss; ACL event ainda não recebido). RECTOR invariant precisa de visibility de SSC state — sem isso, gate fica sem base de comparação para enforcement."
		}
	}, {
		code:      "inv-allocation-convergence-aggregate-level"
		name:      "Convergência de Allocation em Agregado (Monitoring Obligation)"
		rule:      "P2P MUST monitor and report sustained drift entre allocationPolicy upstream SSC e volume real emitido por authorityRef + supplier + categoryRef ao longo do validityPeriod (preferred) ou da janela ativa (one-shot/strategic). Drift sustentado (diferença significativa por janela operacional) dispara sig-allocation-drift como signal observável (OBS) para SSC reconsiderar fitness rules. Phase 0 enforcement é monitoring + reporting, NÃO bloqueio individual de PO — POs individuais não são gated por allocation; agregado é tracked via prj-allocation-tracking; drift é reportado, não impedido."
		rationale: "Invariante de monitoring obligation per bd-allocation-policy-respected-in-aggregate + Patch 3 founder ('volume converge' substituído por 'monitor and report sustained drift' porque enforcement strict é Phase 1+ requer domain-model mechanisms — Phase 0 invariant é observable property, não gate determinístico). Materializa term-allocation-convergence + term-allocation-bias do glossary. P2P observa convergência, NÃO decide allocation — anti-mini-NIM: agente NÃO computa fairness allocation (responsabilidade SSC fitness rules); apenas tracked + signal."
	}, {
		code:      "inv-cancellation-pre-formalization-only"
		name:      "Cancelamento Apenas Pré-CMT Formalization"
		rule:      "evt-purchase-order-cancelled é emitido APENAS quando: (a) state=requested cancela para limpar attempt failed validation (cmd-cancel-purchase-order de state requested), OR (b) state=emitted cancela ANTES de CMT receber e formalizar CommitmentAccepted (cmd-cancel-purchase-order de state emitted; race condition pós-emit antes de CMT formalization). Cancelamento pós-CMT formalization NÃO é coberto Phase 0 — exige cross-BC coordination cancel-cascade entre P2P + CMT (oq-p2p-2 deferred). Race condition (CMT já formalizou commitment quando PurchaseOrderCancelled chega) é assumed rara Phase 0 (typical CMT formalization latency); reconciliação cross-BC futura tratará."
		rationale: "Materializa bd-cancellation-pre-formalization-only + term-purchase-order-cancelled do glossary. Define boundary explícita do escopo de cancellation Phase 0 — protege contra creep para cross-BC coordination prematura (Phase 0 escopo Procure only; Pay = pós-CMT é fora deste BC). Race condition é openQuestion oq-p2p-2."
	}, {
		code:      "inv-no-supplier-revalidation-by-p2p"
		name:      "P2P NÃO Revalida Supplier Eligibility (Anti-mini-NIM)"
		rule:      "P2P NÃO consulta NPM (sem QueryParticipantStatus em P2P operationalScope). P2P NÃO revalida supplier eligibility no momento do emit — confia na validação SSC upstream (que validou no decision time via QueryParticipantStatus per inv-qualification-as-precondition SSC). Janela de risco entre SSC decision e P2P emit é mitigada por SSC re-validation no decision time + (Phase 1+) drift signal feedback loop a SSC. Se supplier rebaixado entre SSC decision e P2P emit, supervisor escala (revoke authority + re-issue OR escalate decisão); P2P emit per authority vigente — NÃO pause-gate na ausência de authority revoke explícita."
		rationale: "Invariante NEGATIVO de anti-mini-NIM per bd-no-supplier-revalidation-by-p2p (boundary clarification founder Patch 4 canvas). P2P NÃO possui supplier pool — apenas purchase authority; pool é responsabilidade SSC pré-validada upstream (NPM single-owner de qualification per dp-04). Sem este invariant, P2P duplicaria responsabilidade SSC + violaria anti-mini-NIM como invariant transversal da Mesh. Sem dependsOnAggregateState (constraint NEGATIVO — declara ausência de dependency, não presence). Materializa term-fornecedor-qualificado boundary + escalation criterion authority-exhausted (renomeado de pool-exhausted per Patch 4 canvas)."
	}, {
		code:      "inv-purchase-order-lifecycle-public-events"
		name:      "Lifecycle Público de PO via 2 Events"
		rule:      "Toda PurchaseOrder que percorre fluxo normal (requested → emitted) DEVE emitir PurchaseOrderEmitted. Toda PurchaseOrder cancelada (requested → cancelled OR emitted → cancelled) DEVE emitir PurchaseOrderCancelled. Não há saída do lifecycle sem evento público correspondente. State requested SEM transição para emitted nem para cancelled é attempt recorded persistente (válido per Patch 1 founder) — não é violação do invariant porque lifecycle não 'sai' do state."
		rationale: "Materializa bd-po-lifecycle-public-events + term-po-lifecycle do glossary. CMT consume PurchaseOrderEmitted como trigger canônico de commitment lifecycle; PurchaseOrderCancelled como sinal de retirada (withdrawal/negative signal). NTF transversal notifica supplier via PO events. OBS observabilidade rastreia emit/cancel rates. Avaliação interna (authority validation, allocation tracking) permanece intra-P2P — confidencialidade competitiva preservada."
	}]

	// =============================================
	// VALUE OBJECTS (catalog top-level)
	// =============================================

	valueObjects: [{
		code:        "vo-purchase-order-id"
		name:        "PurchaseOrderId"
		description: "Identidade canônica de um Pedido de Compra. Persistente, imutável, referenciada cross-context (CMT formalização; CTR cross-check para strategic award; DRC futuro para dispute context). Gerada na criação do aggregate em initialState=requested ('emit attempt recorded' per Patch 1 founder) — persiste mesmo se attempt falhar validation."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Root identity do aggregate. PO tem identidade própria desde criação em state requested — sustenta audit trail de attempt mesmo se nunca progredir para emitted. Garantia de identidade aggregate-wide independente de outcome (emitted vs cancelled)."
	}, {
		code:        "vo-authority-ref"
		name:        "AuthorityRef"
		description: "Referência a uma Autoridade de Sourcing emitida pelo SSC — sourcingDecisionId apontando para SSC vo-sourcing-decision-id. Boundary cross-BC: P2P consume identidade SSC-mantida; SSC mantém canonicidade. P2P NÃO emite authority (apenas APLICA) per anti-mini-NIM."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Materializa term-sourcing-authority do glossary. Boundary explícita com SSC. Sustenta inv-purchase-order-requires-valid-authority — gate determinístico de authority validation consulta authorityRef + authorityType contra prj-active-purchase-authorities + sync fallback QuerySourcingDecision."
	}, {
		code:        "vo-authority-type"
		name:        "AuthorityType"
		description: "Discriminator do tipo de authority — determina binding regime (hard/soft/advisory) + supplier visibility (1 supplier vs lista preferred vs awarded list)."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		constraints: [
			"value deve ser um dos: one-shot-decision, preferred-designation, strategic-award",
		]
		rationale: "Materializa term-authority-type do glossary. 3 valores canônicos Phase 0 (per Patch 1 founder glossary: 'canônicos', NÃO enum congelado pré-domain-model — formal freezing Phase 3 pós-#PurchaseAuthorityType domain-type). Discriminator que sustenta authority validation gate: one-shot=hard binding direta; preferred=soft binding com validityPeriod; strategic=advisory Phase 0 (hard pós-CTR ContractActivated Phase 1+ per oq-p2p-1)."
	}, {
		code:        "vo-supplier-ref"
		name:        "SupplierRef"
		description: "Referência a um participante NPM (Fornecedor). Boundary com NPM — P2P consume ref, NPM mantém identidade canônica e qualificação. P2P NÃO consulta NPM diretamente per inv-no-supplier-revalidation-by-p2p — confia em SSC validação upstream."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Boundary explícita com NPM (single-owner per dp-04). Paralelo a SSC vo-supplier-ref. P2P consume sem revalidar — anti-mini-NIM."
	}, {
		code:        "vo-category-ref"
		name:        "CategoryRef"
		description: "Referência a uma Categoria de Compra (taxonomia configurada externamente). Eixo de segmentação operacional — authority validation por categoria; allocation tracking por categoria; fragmentation pattern detection por categoria."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Materializa term-categoria-de-compra (paralelo a SSC). Configuração externa governada — P2P consome ref, não define taxonomia."
	}, {
		code:        "vo-money"
		name:        "Money"
		description: "Quantia monetária com currency code — amount + currency. Imutável."
		fields: [{
			kind: "primitive"
			name: "amount"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "currency"
			type: "string"
		}]
		constraints: [
			"amount deve ser >= 0",
			"currency deve ser ISO 4217 code (3 letters, ex.: BRL, USD)",
		]
		rationale: "Tipo canônico de domínio para amounts. Sustenta auditoria + reconciliação spend. Currency multi-moeda suportada (paralelo a CMT/BDG)."

		// adr-151 Forma B (Peça 3b): elo ao primitivo compartilhado canônico.
		// Money puro (amount+currency) — aponta #Money + term-money como lar
		// canônico (P0: ponteiro, não cópia; os fields locais permanecem).
		shared:             true
		canonicalSchemaRef: "#Money"
		canonicalTermRef:   "term-money"
	}, {
		code:        "vo-purchase-scope"
		name:        "PurchaseScope"
		description: "Descrição estruturada do escopo de um Pedido de Compra — descrição do item/serviço, volume estimado, prazo de entrega, location relevante. Alinhado nominalmente com SSC vo-rfq-scope para coerência cross-BC vocabulary (estimatedVolume + deadline + location)."
		fields: [{
			kind: "primitive"
			name: "description"
			type: "string"
		}, {
			kind: "primitive"
			name: "estimatedVolume"
			type: "decimal"
		}, {
			kind: "primitive"
			name: "deadline"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "location"
			type: "string"
		}]
		rationale: "Estruturação do escopo de PO é precondição de emit válido. estimatedVolume sustenta allocation tracking aggregate-level (prj-allocation-tracking computa volume agregado por authorityRef + supplier + category). Nomenclatura alinhada com SSC vo-rfq-scope (estimatedVolume + deadline) per cross-BC vocabulary consistency — drift prévio (requestedVolume + deliveryDeadline + unit) corrigido mecanicamente sem rationale defensável para divergência. Unit removido: não usado em invariants nem allocation tracking; sustentação prévia era especulativa. Quando unit emergir como conceito primário (e.g., per-categoryRef unit canonization), formalizar como VO próprio ou extension."
	}, {
		code:        "vo-cancellation-reason"
		name:        "CancellationReason"
		description: "Justificativa estruturada de cancelamento — texto livre + reasonCode discriminator. ReasonCode permite analytics + observability sobre padrões (taxa por categoria, etc)."
		fields: [{
			kind:        "primitive"
			name:        "reasonCode"
			type:        "string"
			description: "demand-cancelled | scope-mismatch | supplier-withdrawal | failed-validation-cleanup | admin-override | queue-overflow | other"
		}, {
			kind:        "primitive"
			name:        "narrative"
			type:        "string"
			description: "Justificativa documentada — obrigatória."
		}]
		constraints: [
			"reasonCode deve ser um dos: demand-cancelled, scope-mismatch, supplier-withdrawal, failed-validation-cleanup, admin-override, queue-overflow, other",
		]
		rationale: "Cancellation reasons são input crítico para drift signal + fragmentation pattern detection. ReasonCode failed-validation-cleanup distingue cancel de attempt recorded (state requested) de withdrawal pre-CMT (state emitted) per Patch 1 + Patch 4 founder. ReasonCode queue-overflow adicionado per adr-075 Caminho D' Phase 5: sustenta #OverflowPolicy.cancelReasonCode references quando bounded wait queue (route insufficient-context) atinge maxQueueDepth/maxQueueAge limits — auto-cancel-and-escalate fail-safe action limpa attempt + escala via existing escalation taxonomy, preservando invariants sob queue pressure (NÃO auto-approve sob pressure — classe de erro adversarial vetada por design)."
	}]

	// =============================================
	// AGGREGATES (consistency boundaries)
	// =============================================

	aggregates: [{
		code:        "agg-purchase-order"
		name:        "PurchaseOrder"
		description: "Aggregate central de P2P — consistency boundary do processo de emissão de Pedido de Compra sob authority pré-validada SSC. PurchaseOrder é conceito ÚNICO (NÃO 3 tipos paralelos) per Q1 canvas — discriminação via authorityType. 1 PO = 1 supplier (multi-supplier semantics vive em allocationPolicy upstream SSC; P2P respeita policy em agregado via prj-allocation-tracking). Lifecycle: requested → emitted | cancelled (terminal). Estado requested é 'emit attempt recorded' per Patch 1 founder — persiste mesmo se validation falhar (audit trail de attempt)."
		rootIdentity: {
			field: "purchaseOrderId"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-purchase-order-id"
			}
		}
		fields: [{
			kind:           "value-object-ref"
			name:           "supplier"
			valueObjectRef: "vo-supplier-ref"
			description:    "Optional — populated quando state=emitted (PO vinculada a supplier após validation success); ausente quando state=requested + authority validation falhou."
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-purchase-scope"
		}, {
			kind:           "value-object-ref"
			name:           "amount"
			valueObjectRef: "vo-money"
		}, {
			kind:           "value-object-ref"
			name:           "authorityRef"
			valueObjectRef: "vo-authority-ref"
			description:    "Reivindicada na criação (cmd-emit-purchase-order.claimedAuthorityRef). Validada via gate; permanece imutável pós-emit."
		}, {
			kind:           "value-object-ref"
			name:           "authorityType"
			valueObjectRef: "vo-authority-type"
			description:    "Resolved durante authority validation gate — determina binding regime + audit trail downstream."
		}, {
			kind:        "primitive"
			name:        "status"
			type:        "string"
			description: "requested | emitted | cancelled — discriminator do lifecycle."
		}, {
			kind:        "primitive"
			name:        "requestedAt"
			type:        "datetime"
			description: "Timestamp da criação do aggregate (cmd-emit-purchase-order recorded)."
		}, {
			kind:        "primitive"
			name:        "requestedBy"
			type:        "string"
			description: "Originadora — área/função que solicitou demanda."
		}, {
			kind:        "primitive"
			name:        "emittedAt"
			type:        "datetime"
			description: "Presente quando status=emitted."
		}, {
			kind:        "primitive"
			name:        "emittedBy"
			type:        "string"
			description: "Operador agente (agt-p2p-primary) ou supervisor — populated quando status=emitted."
		}, {
			kind:        "primitive"
			name:        "cancelledAt"
			type:        "datetime"
			description: "Presente quando status=cancelled."
		}, {
			kind:        "primitive"
			name:        "cancelledBy"
			type:        "string"
			description: "Presente quando status=cancelled."
		}, {
			kind:           "value-object-ref"
			name:           "cancellationReason"
			valueObjectRef: "vo-cancellation-reason"
			description:    "Presente quando status=cancelled."
		}]

		lifecycle: {
			initialState: "requested"
			states: ["requested", "emitted", "cancelled"]
			transitions: [{
				from:               "requested"
				to:                 "emitted"
				triggeredByCommand: "cmd-emit-purchase-order"
				emitsEvents: ["evt-purchase-order-emitted"]
				guards: [
					"inv-purchase-order-requires-valid-authority",
					"inv-no-supplier-revalidation-by-p2p",
				]
				description: "Authority validation passa (gate determinístico) — transição requested → emitted + evt-purchase-order-emitted publicado para CMT como hard binding operational signal."
			}, {
				from:               "requested"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-order"
				emitsEvents: ["evt-purchase-order-cancelled"]
				guards: ["inv-cancellation-pre-formalization-only"]
				description: "Cancelamento de attempt recorded (state requested cuja validation falhou e founder/admin decide limpar audit trail) — transição requested → cancelled + evt-purchase-order-cancelled publicado. Per Patch 4 founder, transition existe porque Patch 1 mantém attempt persistente — sem este path, requested seria dead-end."
			}, {
				from:               "emitted"
				to:                 "cancelled"
				triggeredByCommand: "cmd-cancel-purchase-order"
				emitsEvents: ["evt-purchase-order-cancelled"]
				guards: ["inv-cancellation-pre-formalization-only"]
				description: "Cancelamento de PO emitida pré-CMT formalization (originadora retira demanda; supplier withdraw; scope mismatch) — transição emitted → cancelled + evt-purchase-order-cancelled publicado como withdrawal/negative signal a CMT."
			}]
		}

		handlesCommands: [
			"cmd-emit-purchase-order",
			"cmd-cancel-purchase-order",
		]

		emitsEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
			"evt-sourcing-decision-made-received",
			"evt-preferred-supplier-designated-received",
			"evt-strategic-award-completed-received",
		]

		protectsInvariants: [
			"inv-purchase-order-requires-valid-authority",
			"inv-allocation-convergence-aggregate-level",
			"inv-cancellation-pre-formalization-only",
			"inv-no-supplier-revalidation-by-p2p",
			"inv-purchase-order-lifecycle-public-events",
		]

		usesValueObjects: [
			"vo-purchase-order-id",
			"vo-authority-ref",
			"vo-authority-type",
			"vo-supplier-ref",
			"vo-category-ref",
			"vo-money",
			"vo-purchase-scope",
			"vo-cancellation-reason",
		]

		rationale: """
			Single aggregate central com root identity = purchaseOrderId
			(PO existe desde criação em state=requested 'emit attempt
			recorded' per Patch 1 founder; supplier + emittedAt são
			optional fields populated apenas quando state=emitted).

			Justificativa estrutural (per tq-dmg-07): persiste registry
			de POs (incluindo attempts failed validation persistidos como
			state=requested para audit trail) + sustenta gate determinístico
			de authority + carrega authorityRef/authorityType imutáveis
			pós-emit + sustenta inv-purchase-order-lifecycle-public-events
			via 2 events pareados emit/cancel. Sem essa estrutura
			persistente, gate determinístico regrediria a stateless e
			audit trail Lei 12.846 (5 anos retention) ficaria sem fonte
			canônica.

			Lifecycle 3 states (requested → emitted | cancelled) com 3
			transitions cobrindo todos paths Phase 0:
			- requested → emitted (cmd-emit-purchase-order, guards
			  inv-purchase-order-requires-valid-authority + inv-no-
			  supplier-revalidation-by-p2p): caminho normal (validation
			  passa); emite PurchaseOrderEmitted hard binding operational
			  signal a CMT.
			- requested → cancelled (cmd-cancel-purchase-order, guard
			  inv-cancellation-pre-formalization-only): limpa attempt
			  failed validation persistente (per Patch 4 founder porque
			  Patch 1 mantém attempt persistente — sem este path,
			  requested seria dead-end).
			- emitted → cancelled (cmd-cancel-purchase-order, guard
			  inv-cancellation-pre-formalization-only): withdrawal
			  pre-CMT formalization (originadora retira demanda; supplier
			  withdraw; scope mismatch). Emite PurchaseOrderCancelled
			  como withdrawal/negative signal a CMT.

			Aggregate creation: cmd-emit-purchase-order creates
			agg-purchase-order directly em initialState=requested e
			TENTA transition requested → emitted via guards — schema
			#Lifecycle não suporta create transition (from: ∅), criação
			implícita via initialState. Per Patch 1 founder semântica,
			requested é 'emit attempt recorded' (não 'PO válida aguardando
			emissão'): validation success transita imediato para emitted;
			validation failure deixa aggregate persistente em requested
			como audit trail (originadora pode then submeter cmd-cancel-
			purchase-order ou retentar com authorityRef diferente em
			novo aggregate).

			emitsEvents incluem 5 events: 2 published de PO lifecycle
			(PurchaseOrderEmitted + PurchaseOrderCancelled) + 3 internal
			ACL de SSC (-received). Os 3 events ACL são emitted/recorded
			in local event stream, not originated by aggregate decision
			(per Patch 2 founder) — paralelo a CMT/BDG/IDC/SSC pattern:
			aggregate registra fato no event stream local; ACL adapter
			produz semanticamente o evento traduzido. Naming 'emitsEvents'
			fica semanticamente torto para os ACL events mas convenção
			estabelecida é mantida — distinção semântica é capturada via
			visibility=internal + sourceContext=ssc fields.

			Multi-supplier first-class via authorityRef discriminator
			per Q1 canvas: agg-purchase-order tem 1 supplier por instância
			(supplier field é singular); multi-supplier semantics vive
			em allocationPolicy do upstream SSC decision (P2P respeita
			em agregado via prj-allocation-tracking + inv-allocation-
			convergence-aggregate-level monitoring obligation).
			PurchaseOrder é conceito único — discriminação via
			authorityType (one-shot-decision | preferred-designation |
			strategic-award) NÃO via 3 schemas paralelos.

			Anti-mini-NIM via inv-no-supplier-revalidation-by-p2p (P2P
			NÃO consulta NPM; sem QueryParticipantStatus em
			operationalScope) + boundary clarification founder Patch 4
			canvas: P2P NÃO possui supplier pool — apenas purchase
			authority; pool é responsabilidade SSC pré-validada upstream
			via NPM single-owner per dp-04.
			"""
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-active-purchase-authorities"
		name:        "ActivePurchaseAuthoritiesProjection"
		description: "Read model interno que materializa authorities vigentes — derivado de 3 events ACL de SSC (SourcingDecisionMadeReceived + PreferredSupplierDesignatedReceived + StrategicAwardCompletedReceived). Cache local consumido pelo aggregate via authority validation gate (sem sync query a SSC no caminho normal). Materializa term-purchase-authority-cache implícita (não termo separado per glossary refactor)."
		consumesEvents: [
			"evt-sourcing-decision-made-received",
			"evt-preferred-supplier-designated-received",
			"evt-strategic-award-completed-received",
		]
		queryCapabilities: [{
			code:        "qry-active-purchase-authorities"
			description: "Retorna authority vigente por authorityRef ou (categoryRef + supplier) — payload incluindo authorityType + selectedSuppliers/preferredSuppliers/awardedSuppliers + allocationPolicy + validityPeriod (preferred) + categoryRef. Consumer interno (gate determinístico authority validation)."
			rationale:   "Lookup principal do gate determinístico per inv-purchase-order-requires-valid-authority. Cache miss dispara sync fallback QuerySourcingDecision a SSC (canvas query-dependency). Cache stale pós-CTR cancel é openQuestion oq-ssc-5/oq-p2p-2 compartilhada."
		}]
		rationale: "Sustenta gate determinístico de authority validation sem latência de sync query no caminho normal. Latência alvo: <5s para consumers síncronos (alinhado eda-projections SLO). Phase 0 evolução: ContractActivated CTR (PHASE 1+ FORWARD-REF per oq-p2p-1) entra como event consumer adicional para bumping authorityType de strategic-award (advisory) → strategic-award-with-active-contract (hard) quando relação ctr-to-p2p for formalizada operacionalmente."
	}, {
		code:        "prj-purchase-orders"
		name:        "PurchaseOrdersProjection"
		description: "Read model que materializa POs (todas, todos states) consumidos por canvas query-surfaces QueryActivePurchaseOrders + QueryPurchaseOrderById. Source-of-record canônico para controllers (reporting), supervisores (visibility), CMT (cross-check pré-formalização), CTR (cross-check para strategic award), DRC futuro (dispute context)."
		consumesEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
		]
		queryCapabilities: [{
			code:        "qry-active-purchase-orders"
			description: "Retorna ActivePurchaseOrders (state=emitted) por categoryRef OR supplierRef OR requesterRef — lista com authority + status + emittedAt + cancellation status. Filtros suportados: categoria, supplier, requester."
			rationale:   "Canvas query-surface QueryActivePurchaseOrders. Suporta lookup por dimension operacional (controller filtra por categoria; supervisor por requester; CMT por supplier para cross-check)."
		}, {
			code:        "qry-purchase-order-by-id"
			description: "Retorna PurchaseOrder completa por purchaseOrderId — payload incluindo authorityRef + authorityType + supplier + scope + amount + audit metadata + cancellation status + reason."
			rationale:   "Canvas query-surface QueryPurchaseOrderById. Suporta lookup pontual (CMT formalization input; CTR cross-check; audit reconstitution histórica). POs históricas (cancelled, formalized via CMT) permanecem queriable para auditoria."
		}]
		rationale: "Per canvas query-surfaces QueryActivePurchaseOrders + QueryPurchaseOrderById. POs em state=requested (attempts persistentes failed validation) NÃO entram em qry-active-purchase-orders (filtro state=emitted) — visibility de attempts é via projection separada se demanda emergir Phase 1+ (oq-p2p-attempts-visibility deferred futuro). Phase 0: attempts ficam apenas no aggregate event stream local; não expostos cross-context."
	}, {
		code:        "prj-allocation-tracking"
		name:        "AllocationTrackingProjection"
		description: "Read model interno que mantém volume agregado emitido por authorityRef + supplier + categoryRef ao longo de janela ativa (validityPeriod para preferred; janela operacional para one-shot/strategic). Source-of-record para inv-allocation-convergence-aggregate-level monitoring obligation + sig-allocation-drift signal."
		consumesEvents: [
			"evt-purchase-order-emitted",
		]
		queryCapabilities: [{
			code:        "qry-allocation-tracking-by-authority"
			description: "Retorna AllocationStatus por authorityRef — total volume emitido por supplier vs allocationPolicy declarada (split-by-percentage tracking). Drift sustentado dispara sig-allocation-drift signal a SSC (OBS observability)."
			rationale:   "Consumer interno do agente P2P (drift detection cross-PO) + signal feed a SSC fitness rules reconsideração. Phase 0 monitoring + reporting (não enforcement); Phase 1+ pode evoluir para hard gate se feedback loop estabilizar (oq-p2p-3 + oq-ssc-3 bridge)."
		}]
		rationale: "Sustenta inv-allocation-convergence-aggregate-level monitoring obligation per Patch 3 founder ('P2P MUST monitor and report sustained drift', NÃO 'volume converge' enforcement). Materializa term-allocation-convergence + term-allocation-bias do glossary. P2P observa convergência, NÃO decide allocation — anti-mini-NIM: agente NÃO computa fairness allocation (responsabilidade SSC fitness rules); apenas tracked + signal. Cancellations NÃO consumidas (Phase 0): cancelled POs já não foram entregues; volume real entregue é tracked downstream em CMT/DLV; Phase 0 P2P projection trackeia apenas emitted volumes como proxy operacional."
	}, {
		code:        "prj-purchase-history-by-category"
		name:        "PurchaseHistoryByCategoryProjection"
		description: "Read model interno que mantém histórico agregado de POs por categoria — frequência de cancelamentos, distribuição de suppliers, padrões de emit por requester. Sustenta term-fragmentation-pattern detection (POs sub-threshold artificialmente fragmentadas para evitar gates de aprovação SSC)."
		consumesEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
		]
		queryCapabilities: [{
			code:        "qry-purchase-history-by-category"
			description: "Retorna PurchaseHistoryAggregate por categoria — estatísticas históricas (volume médio por PO; frequência por requester; cancellation rate; supplier diversity). Consumer interno P2P para fragmentation pattern detection (sh-01 vetor adversarial)."
			rationale:   "Consumer interno do agente P2P — comparação contra padrões esperados detecta fragmentation (sub-threshold splitting). Sustenta sh-01 designResponse + escalation 'fragmentation-pattern-detected' do canvas."
		}]
		rationale: "Sustenta as-p2p-2 (PO history como signal robusto) + term-fragmentation-pattern detection. Cancellations consumidas para detectar padrões anômalos (categoria com taxa alta de cancellation pode indicar scope mal-definido OR maverick masking via cancel/re-emit). Phase 0 detection local; cross-BC coordination (oq-p2p-6) deferida Phase 1+ quando NIM aggregation suportar pattern correlation cross-context."
	}]

	rationale: """
		Domain model do BC Procure-to-Pay modela 1 aggregate central
		(agg-purchase-order) cobrindo todo escopo declarado em canvas
		Phase 0 (Procure execution NÃO Pay; pagamento é FCE; faturamento
		é INV per Adj 1 founder canvas). Root identity = purchaseOrderId
		(PO existe desde criação em state=requested 'emit attempt
		recorded' per Patch 1 founder; supplier + emittedAt populated
		apenas quando state=emitted).

		2 commands granulares cobrindo lifecycle: cmd-emit-purchase-order
		(entry com aggregate creation directly em initialState=requested
		e tentativa de transition para emitted via guard authority
		validation), cmd-cancel-purchase-order (cancel supervised pré-
		CMT formalization; 2 cenários — cleanup de attempt failed em
		state requested OR withdrawal de PO emitida pré-CMT).

		Multi-supplier first-class via authorityRef discriminator per
		Q1 canvas: agg-purchase-order tem 1 supplier por instância;
		multi-supplier semantics vive em allocationPolicy upstream SSC
		(P2P respeita em agregado via prj-allocation-tracking + inv-
		allocation-convergence-aggregate-level monitoring obligation).
		PurchaseOrder é conceito ÚNICO — discriminação via authorityType
		(one-shot-decision | preferred-designation | strategic-award)
		NÃO via 3 schemas paralelos.

		Behavior-first ordering aplicado: events emergem do canvas (2
		published de PO lifecycle + 3 internal ACL de SSC); commands
		derivam de canvas inbound (EmitPurchaseOrder + CancelPurchaseOrder);
		invariants protegidos derivados dos 6 businessDecisions do
		canvas (1 RECTOR + 5 operacionais incluindo 1 NEGATIVO);
		value-objects emergentes dos payloads + glossary terms (8 VOs
		incluindo identity + authority discriminator + scope + money +
		cancellation reason).

		Anti-mini-NIM como invariant transversal materializado em 5
		layers (paralelo a SSC):
		(a) inv-purchase-order-requires-valid-authority (RECTOR — gate
		    determinístico autoridade pré-validada);
		(b) inv-no-supplier-revalidation-by-p2p (NEGATIVO — P2P NÃO
		    possui supplier pool, apenas purchase authority per Patch
		    4 founder canvas; sem QueryParticipantStatus em
		    operationalScope);
		(c) inv-allocation-convergence-aggregate-level (monitoring
		    obligation Phase 0 — observable property + signal a SSC,
		    NÃO enforcement strict per Patch 3 founder);
		(d) capability rationale + sh-05 designResponse (allocation
		    bias via tracking aggregate-level);
		(e) escalation routing (insufficient/conflicting/expired/
		    exhausted authority — TODOS supervisedDecision escalation
		    para gate humano).

		Cross-BC state dependencies (tq-dm-17 + tq-dmg-09 per adr-055):
		1 invariant (inv-purchase-order-requires-valid-authority) declara
		dependsOnAggregateState first-class apontando para SSC agg-
		sourcing-process via canvas query-surface QuerySourcingDecision
		(kind=sync-query, cross-BC). Granularidade per-invariant per
		heuristic do PG. Aggregate state interno do agg-purchase-order
		+ projections são state intra-BC — sem cross-aggregate dependencies
		além do path SSC cross-BC.

		Lifecycle 3 states com 3 transitions per Patch 4 founder:
		- requested → emitted (validation passa)
		- requested → cancelled (cleanup de attempt failed validation
		  persistente — necessário porque Patch 1 mantém attempt
		  persistente; sem este path, requested seria dead-end)
		- emitted → cancelled (withdrawal pre-CMT)

		Aggregate creation: cmd-emit-purchase-order creates aggregate
		directly em initialState=requested e TENTA transition para
		emitted via guards — schema #Lifecycle não suporta create
		transition (from: ∅), criação implícita via initialState. Per
		Patch 1 founder semântica, requested é 'emit attempt recorded'
		(NÃO 'PO válida aguardando emissão'): validation success transita
		imediato para emitted; validation failure deixa aggregate
		persistente em requested como audit trail.

		emitsEvents incluem 5 events: 2 published de PO lifecycle
		(PurchaseOrderEmitted hard binding operational signal a CMT +
		PurchaseOrderCancelled withdrawal/negative signal pre-CMT) + 3
		internal ACL de SSC (-received). Per Patch 2 founder, os 3 ACL
		events são emitted/recorded in local event stream, not originated
		by aggregate decision — paralelo a CMT/BDG/IDC/SSC pattern:
		aggregate registra fato no event stream local; ACL adapter
		produz semanticamente o evento traduzido. Naming 'emitsEvents'
		fica semanticamente torto para os ACL events mas convenção
		estabelecida é mantida — distinção semântica capturada via
		visibility=internal + sourceContext=ssc fields.

		4 projections como read models:
		- prj-active-purchase-authorities (cache de 3 ACL events;
		  sustenta gate determinístico de authority validation sem
		  latência de sync query no caminho normal)
		- prj-purchase-orders (canvas query-surfaces QueryActive
		  PurchaseOrders + QueryPurchaseOrderById; source-of-record
		  para CMT/CTR/DRC cross-check)
		- prj-allocation-tracking (sustenta inv-allocation-convergence-
		  aggregate-level monitoring obligation; sig-allocation-drift
		  signal a SSC)
		- prj-purchase-history-by-category (term-fragmentation-pattern
		  detection — sh-01 vetor adversarial; cross-BC coordination
		  oq-p2p-6 Phase 1+ deferred)

		0 policies + 0 domain services Phase 0 — escopo Procure-only
		é simples (1 aggregate central; 2 commands; emit/cancel
		operations atômicas). Policy event→command poderia emergir
		Phase 1+ se ContractActivated CTR consumer materializar
		(automate authorityType bumping advisory→hard); Phase 0 é
		commit point de cache update (manual por agent).

		Lenses aplicadas:
		- lens-organizational-resource-allocation (primária): aggregate
		  modela alocação de POs sob authority pré-validada SSC;
		  allocationPolicy upstream respeitada em agregado via
		  prj-allocation-tracking + inv-allocation-convergence
		  monitoring; multi-supplier first-class preservado via
		  authorityRef discriminator.
		- lens-incentive-alignment (secundária): invariants e gate
		  determinístico de authority protegem contra 3 vetores
		  adversariais — sh-01 fragmentation (prj-purchase-history-
		  by-category detection) + sh-02 renegotiation (PO immutability
		  pós-emit) + sh-05 allocation bias (prj-allocation-tracking
		  + sig-allocation-drift signal). Anti-mini-NIM como invariant
		  transversal protege P2P de virar 'mini-SSC'.
		- lens-event-driven-architecture-patterns (secundária): 2
		  events published com semântica inequívoca (PO lifecycle); 3
		  internal ACL de SSC traduzidos via convenção -received; 4
		  projections como read models com SLO de latência <5s; sem
		  policies Phase 0 (escopo simples).
		- lens-information-economics (terciária): authorityRef
		  preserving link to sourcing decision rationale rich (SSC
		  decisionRationale acessível via QuerySourcingDecision);
		  PO data como signal NIM intelligence learning loop bridge
		  Phase 1+ (paralelo a oq-ssc-2). Phase 0: NIM consumer pendente.

		Phase 0 caveats:
		- PurchaseOrderCancelled cobre apenas pre-CMT formalization
		  withdrawal (pós-CMT cancellation requer cross-BC coordination
		  cancel-cascade entre P2P + CMT — oq-p2p-2 deferred).
		- CTR ContractActivated PHASE 1+ FORWARD-REF (oq-p2p-1) NÃO
		  incluído como event-consumer Phase 0; ctr-to-p2p relation
		  no context-map materializa apenas Phase 1+ pós oq-p2p-1.
		- Strategic-award authorityType Phase 0 advisory binding;
		  hard binding ativa apenas pós-CTR ContractActivated Phase
		  1+ per oq-p2p-1.
		- Supplier API (acceptance/rejection by supplier) Phase 1+
		  per oq-p2p-4; Phase 0 modela apenas notification (NTF
		  transversal) sem aceite/rejeição.
		- inv-allocation-convergence-aggregate-level Phase 0 é
		  monitoring obligation (observable + signal); enforcement
		  strict requer domain-model mechanisms Phase 1+ (oq-p2p-3
		  + oq-ssc-3 bridge).
		- prj-purchase-history-by-category fragmentation detection
		  é local Phase 0; cross-BC coordination cross-context
		  pattern correlation Phase 1+ via NIM aggregation (oq-p2p-6
		  deferred).
		- Attempts persistentes (state=requested failed validation)
		  visibility cross-context é via projection separada se
		  demanda emergir Phase 1+ (não exposta em prj-purchase-orders
		  Phase 0 por filtro state=emitted).

		Glossary alignment: 15 terms canônicos do glossary (Phase 2)
		reconciliados com events/commands/aggregates/value-objects.
		Mapeamentos chave: term-purchase-order → vo-purchase-order-id
		+ agg-purchase-order; term-sourcing-authority → vo-authority-
		ref + inv-purchase-order-requires-valid-authority; term-
		authority-type → vo-authority-type discriminator; term-
		authority-validation → gate determinístico via prj-active-
		purchase-authorities + sync fallback QuerySourcingDecision;
		term-allocation-convergence → inv-allocation-convergence-
		aggregate-level + prj-allocation-tracking; term-po-lifecycle
		→ agg-purchase-order lifecycle 3 states; term-purchase-order-
		emitted/cancelled → 2 events published; term-maverick → gate
		determinístico bloqueio + escalation supervisedDecision; term-
		fragmentation-pattern → prj-purchase-history-by-category +
		sh-01 designResponse; term-allocation-bias → inv-allocation-
		convergence + sig-allocation-drift + prj-allocation-tracking;
		term-renegotiation-pressure → PO immutability pós-emit
		(authorityRef + amount + scope + supplier imutáveis); term-
		originadora-de-demanda → cmd-emit-purchase-order.requestedBy
		+ aggregate.requestedBy; term-fornecedor-qualificado →
		boundary explícita via inv-no-supplier-revalidation-by-p2p
		(P2P NÃO revalida — confia em SSC validação upstream). Sem
		divergências terminológicas identificadas. Frase canônica
		preservada (SSC decide sourcing; P2P emite pedido sob
		authority; CMT formaliza compromisso) via separação clara
		de responsabilidades — agg-purchase-order não emite commands
		para SSC/CMT (apenas events que outros BCs consomem).
		"""
}
