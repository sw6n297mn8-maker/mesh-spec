package ssc

// domain-model.cue — Domain Model do BC Strategic Sourcing & Category.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Materializado via authoring manual section-by-section per
// manualAuthoringProtocol (adr-057). Cascade ordering per adr-053/
// adr-054 dec 13: PG existe; canvas SSC + glossary SSC estabelecidos
// (Phases 1+2 do WI-060).
//
// 1 aggregate central: agg-sourcing-process (consistency boundary do
// processo RFQ + decisão emitida atomicamente). rootIdentity = rfqId
// (RFQ existe desde t=0, mesmo se cancelada antes de decisão).
// 1 entity nested: ent-quotation (cotação submetida com lifecycle
// submitted → withdrawn).
//
// 8 commands cobrindo lifecycle real de RFQ: open → receive (multiple
// quotation submissions/withdrawals) → conclude (3 tipos) | cancel.
// Mais 1 command interno (revalidate) triggered por policy.
//
// Behavior-first ordering aplicado: events identificados primeiro do
// canvas (3 published spine + 3 published RFQ lifecycle + 1 internal
// ACL); commands derivados de canvas inbound + intenção interna +
// lifecycle granular per refactor pós-founder review; invariants
// protegidos derivados dos 7 businessDecisions; value-objects
// emergentes dos payloads + glossary terms.
//
// Multi-supplier first-class: events carregam selectedSuppliers/
// preferredSuppliers/awardedSuppliers como SupplierRefList (single-
// supplier é caso típico mas estrutura é lista) + vo-allocation-policy
// para split semantics. Materializa decisão Q1 do canvas SSC.
//
// Lenses aplicadas:
// - lens-organizational-resource-allocation (primária): aggregate
//   modela alocação de oportunidade (RFQ é mecanismo competitivo;
//   decisão é alocação canônica)
// - lens-incentive-alignment (secundária): invariants e fitness
//   rules como config externa governada protegem contra manipulação
// - lens-event-driven-architecture-patterns (secundária): 6 events
//   published + 1 internal ACL; 3 projections como read models
// - lens-information-economics (terciária): decisionRationale rico
//   captura asymmetry resolution para downstream consumers
//
// Glossary alignment: 19 terms canônicos do glossary (Phase 2)
// reconciliados com events/commands/aggregates/value-objects/entities.
//
// Convenção List (paralelo a IDC domain-model): campos com kind
// "domain-type" cujo type termina em "List" denotam coleção do tipo
// correspondente removido o sufixo (ex.: SupplierRefList = coleção
// de SupplierRef; QuotationRefList = coleção de QuotationRef;
// EvaluatedSupplierList = coleção de EvaluatedSupplier; TradeoffList
// = coleção de Tradeoff; CriterionList = coleção de strings-criterion).
// Workaround para #DomainField não suportar kind "array" hoje. Quando
// schema ganhar array kind, migrar em commit dedicado.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code:              "ssc"
	name:              "Strategic Sourcing & Category Domain Model"
	boundedContextRef: "ssc"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-sourcing-decision-made"
		name:        "SourcingDecisionMade"
		visibility:  "published"
		description: "Decisão de Sourcing one-shot emitida — fornecedor(es) selecionado(s) para escopo específico. Hard binding para P2P emitir pedido. Carrega decisionRationale rico + allocationPolicy (single-supplier ou split multi-supplier)."
		rationale:   "Event publisher canvas.communication.outbound[]. P2P consume com binding hard (override = supervised). Pós-NIM bootstrap (oq-ssc-2), NIM consume como input para intelligence learning loop sem evento dedicado. Multi-supplier first-class: selectedSuppliers é lista (single-supplier é variação de payload, não event type — per Q1 ciclo 5)."
		fields: [{
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "selectedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef (≥1; tipicamente 1; multi-supplier suportado)."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
			description:    "Política de allocation (single ou split)."
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
		}, {
			kind: "primitive"
			name: "decidedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "decidedBy"
			type: "string"
		}]
	}, {
		code:        "evt-preferred-supplier-designated"
		name:        "PreferredSupplierDesignated"
		visibility:  "published"
		description: "Designação de Fornecedor(es) Preferido(s) ativada para categoria com prazo de validade. Soft binding em P2P. Multi-supplier: preferredSuppliers é lista."
		rationale:   "Event publisher canvas outbound. P2P consume como cache de policy. Expiração por validUntil é passiva (sem evt-preferred-expired Phase 0). Multi-supplier first-class per Q1."
		fields: [{
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "preferredSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef preferidos para a categoria."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
		}, {
			kind:           "value-object-ref"
			name:           "validityPeriod"
			valueObjectRef: "vo-validity-period"
		}, {
			kind: "primitive"
			name: "designatedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "designatedBy"
			type: "string"
		}]
	}, {
		code:        "evt-strategic-award-completed"
		name:        "StrategicAwardCompleted"
		visibility:  "published"
		description: "Strategic Award concluído pós-RFQ formal — gatilho para formalização contratual em CTR. CTR consumer obrigatório; P2P advisory. Multi-supplier: awardedSuppliers é lista."
		rationale:   "Event publisher canvas outbound. CTR consume como input governado (não vinculante); P2P consume como advisory cache. Cache stale pós-cancelamento CTR é openQuestion oq-ssc-5."
		fields: [{
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:        "domain-type"
			name:        "awardedSuppliers"
			type:        "SupplierRefList"
			description: "Lista de SupplierRef premiados para formalização contratual."
		}, {
			kind:           "value-object-ref"
			name:           "allocationPolicy"
			valueObjectRef: "vo-allocation-policy"
		}, {
			kind:           "value-object-ref"
			name:           "decisionRationale"
			valueObjectRef: "vo-decision-rationale"
		}, {
			kind:           "value-object-ref"
			name:           "fitnessRuleSnapshot"
			valueObjectRef: "vo-fitness-rule-snapshot"
		}, {
			kind:           "value-object-ref"
			name:           "expectedContractScope"
			valueObjectRef: "vo-expected-contract-scope"
		}, {
			kind: "primitive"
			name: "awardedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "awardedBy"
			type: "string"
		}]
	}, {
		code:        "evt-rfq-opened"
		name:        "RFQOpened"
		visibility:  "published"
		description: "RFQ aberta — fornecedores qualificados convidados são notificados (NTF/OBS subscription transversal). Carrega categoria, escopo, janela e pool, e tipo declarado upfront."
		rationale:   "Trio canônico de RFQ lifecycle per bd-rfq-lifecycle-public-minimal. decisionType declarado upfront sustenta inv-decision-type-declared-upfront."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "categoryRef"
			valueObjectRef: "vo-category-ref"
		}, {
			kind:           "value-object-ref"
			name:           "scope"
			valueObjectRef: "vo-rfq-scope"
		}, {
			kind:           "value-object-ref"
			name:           "decisionType"
			valueObjectRef: "vo-decision-type"
			description:    "Tipo declarado upfront (one-shot/preferred/strategic)."
		}, {
			kind: "primitive"
			name: "openedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "quotationDeadline"
			type: "datetime"
		}, {
			kind:        "domain-type"
			name:        "invitedSuppliers"
			type:        "SupplierRefList"
			description: "Refs a NPM participants qualificados (snapshot pool no momento da abertura)."
		}]
	}, {
		code:        "evt-rfq-concluded"
		name:        "RFQConcluded"
		visibility:  "published"
		description: "RFQ concluída — decisão emitida (vencedores + não-vencedores notificados via NTF transversal)."
		rationale:   "Conclusão pareada com abertura. Decisão autônoma do agente. Conclusão é evento causal de decisão emitida — sem julgamento envolvido."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind:           "value-object-ref"
			name:           "sourcingDecisionId"
			valueObjectRef: "vo-sourcing-decision-id"
		}, {
			kind: "primitive"
			name: "concludedAt"
			type: "datetime"
		}]
	}, {
		code:        "evt-rfq-cancelled"
		name:        "RFQCancelled"
		visibility:  "published"
		description: "RFQ cancelada antes de decisão — anula compromisso com fornecedores convidados. supervisedDecision (cancel-rfq)."
		rationale:   "Cancelamento é supervisedDecision per bd-rfq-lifecycle-public-minimal. Notifica fornecedores convidados via NTF transversal com justificativa."
		fields: [{
			kind:           "value-object-ref"
			name:           "rfqId"
			valueObjectRef: "vo-rfq-id"
		}, {
			kind: "primitive"
			name: "cancelledAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "cancelledBy"
			type: "string"
		}, {
			kind:        "primitive"
			name:        "reason"
			type:        "string"
			description: "Justificativa documentada — obrigatória."
		}]
	}, {
		code:          "evt-network-participant-status-changed-received"
		name:          "NetworkParticipantStatusChangedReceived"
		visibility:    "internal"
		sourceContext: "npm"
		description:   "Tradução ACL de NetworkParticipantStatusChanged (NPM). Trigger para revalidação de fornecedores em RFQs ativas."
		rationale:     "Event interno traduzido de sinal externo de NPM (npm-to-ssc, hybrid). Domain model permanece puro — linguagem local. Trigger para pol-revalidate-on-status-changed. Sufixo -received segue convenção ACL estabelecida em CMT/BDG."
		fields: [{
			kind:           "value-object-ref"
			name:           "supplierRef"
			valueObjectRef: "vo-supplier-ref"
		}, {
			kind:        "primitive"
			name:        "newEligibility"
			type:        "string"
			description: "eligible-for-sourcing | provisionally-qualified | suspended | revoked."
		}, {
			kind: "primitive"
			name: "changedAt"
			type: "datetime"
		}]
	}]

	// =============================================
	// COMMANDS (stub — completados em Parte 2)
	// =============================================

	commands: [{
		code:        "cmd-open-rfq"
		name:        "OpenRFQ"
		description: "Stub minimal — completado em Parte 2 (commands catalog)."
		rationale:   "Stub para satisfazer #DomainModel.commands min-1. Completado em Parte 2."
	}]

	// =============================================
	// INVARIANTS (stub — completados em Parte 2)
	// =============================================

	invariants: [{
		code:      "inv-decision-from-structured-signals"
		name:      "Decisão Determinística sobre Signals Estruturados"
		rule:      "Stub minimal — regra completa em Parte 2."
		rationale: "Stub para satisfazer #DomainModel.invariants min-1. Completado em Parte 2."
	}]

	// =============================================
	// AGGREGATES (stub — completado em Parte 3)
	// =============================================

	aggregates: [{
		code:        "agg-sourcing-process"
		name:        "SourcingProcess"
		description: "Stub minimal — completado em Parte 3 (aggregate + entity + lifecycle)."
		rootIdentity: {
			field: "rfqId"
			type: {
				kind: "primitive"
				type: "string"
			}
		}
		handlesCommands: ["cmd-open-rfq"]
		emitsEvents: [
			"evt-sourcing-decision-made",
			"evt-preferred-supplier-designated",
			"evt-strategic-award-completed",
			"evt-rfq-opened",
			"evt-rfq-concluded",
			"evt-rfq-cancelled",
			"evt-network-participant-status-changed-received",
		]
		protectsInvariants: ["inv-decision-from-structured-signals"]
		rationale:          "Stub para satisfazer #DomainModel.aggregates min-1. rootIdentity primitive temporário (substituído por vo-rfq-id em Parte 3 quando VOs forem catalogados). emitsEvents lista completa pré-populada porque events catalog está fechado nesta Parte e satisfação tq-dm-02 exige cada event com aggregate de origem; outras refs (commands, invariants, VOs, entities, lifecycle, fields) completadas nas Partes 2-3."
	}]

	rationale: "Domain model SSC scaffold (Parte 1 de 5): events catalog completo (7 events: 3 spine de decisão + 3 lifecycle de RFQ + 1 internal ACL de NPM); stubs mínimos de command/invariant/aggregate satisfazem schema min-1 e serão substituídos nas Partes 2-3. Outer rationale completo finalizado em Parte 4."
}
