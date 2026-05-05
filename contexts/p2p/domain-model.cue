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
	// AGGREGATES (stub — completado em Parte 3)
	// =============================================

	aggregates: [{
		code:        "agg-purchase-order"
		name:        "PurchaseOrder"
		description: "Stub minimal — completado em Parte 3 (aggregate + lifecycle + fields)."
		rootIdentity: {
			field: "purchaseOrderId"
			type: {
				kind: "primitive"
				type: "string"
			}
		}
		handlesCommands: ["cmd-emit-purchase-order"]
		emitsEvents: [
			"evt-purchase-order-emitted",
			"evt-purchase-order-cancelled",
			"evt-sourcing-decision-made-received",
			"evt-preferred-supplier-designated-received",
			"evt-strategic-award-completed-received",
		]
		protectsInvariants: ["inv-purchase-order-requires-valid-authority"]
		rationale:          "Stub para satisfazer #DomainModel.aggregates min-1. rootIdentity primitive temporário (substituído por vo-purchase-order-id em Parte 3 quando VOs forem catalogados). emitsEvents lista completa pré-populada porque events catalog está fechado nesta Parte e satisfação tq-dm-02 exige cada event com aggregate de origem; outras refs (commands, invariants, VOs, lifecycle, fields) completadas nas Partes 2-3. Os 3 events ACL (-received) são emitted/recorded in local event stream, not originated by aggregate decision (per Patch 2 founder) — paralelo a CMT/BDG/IDC/SSC pattern: aggregate registra fato no event stream local; ACL adapter produz semanticamente o evento traduzido."
	}]

	rationale: "Domain model P2P scaffold (Parte 1 de 5): events catalog completo (5 events: 2 published de PO lifecycle + 3 internal ACL de SSC); stubs mínimos de command/invariant/aggregate satisfazem schema min-1 e serão substituídos nas Partes 2-3. Outer rationale completo finalizado em Parte 4."
}
