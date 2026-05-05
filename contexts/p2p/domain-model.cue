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
	// COMMANDS (stub — completados em Parte 2)
	// =============================================

	commands: [{
		code:        "cmd-emit-purchase-order"
		name:        "EmitPurchaseOrder"
		description: "Stub minimal — completado em Parte 2 (commands catalog)."
		rationale:   "Stub para satisfazer #DomainModel.commands min-1. Completado em Parte 2."
	}]

	// =============================================
	// INVARIANTS (stub — completados em Parte 2)
	// =============================================

	invariants: [{
		code:      "inv-purchase-order-requires-valid-authority"
		name:      "Pedido de Compra Exige Authority Válida"
		rule:      "Stub minimal — regra completa em Parte 2."
		rationale: "Stub para satisfazer #DomainModel.invariants min-1. Completado em Parte 2."
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
