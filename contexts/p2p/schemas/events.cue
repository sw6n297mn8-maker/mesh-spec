package p2p

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas dos eventos do domain-model P2P:
// os 6 da REQUISIÇÃO (recorte adr-178: o início da jornada) e, desde a
// fatia da superfície do PO (missão M1, adr-193), os 5 do agg-purchase-
// order (emitted/cancelled + 3 ACL -received) — a fatia que o header
// anterior deferia ("entram quando a fatia do PO abrir a superfície
// correspondente") abriu com o fecho da ds-buyer-procurement-journey.
// Espelha o pattern FCE/DLV/CMT: #Envelope consolidado
// (shared-schemas, def-022), opaque refs cross-BC, eventos como
// #Envelope & {type, data}. source mesh://contexts/p2p; types próprios
// mesh.p2p.<event-name>.v1.
//
// TIMESTAMPS: #RFC3339Timestamp (shared) nos data.* de domínio — alinhado
// FCE/CMT. MONEY: #Money consolidado (shared-schemas, def-025) no amount do
// PurchaseApproved. DECIMAL: quantity/estimatedVolume como #DecimalString
// (Ion-4; espelho da regra rtd-013 decimal→string).

// ── Aliases para shared_schemas ──
//
// ATENÇÃO: aliases são renomeio local — NÃO são ponto de extensão.
// Overrides locais produzem drift silencioso cross-BC (disciplina de
// architecture/shared-schemas/envelope.cue).

#Envelope:         shared_schemas.#Envelope
#Money:            shared_schemas.#Money
#DecimalString:    shared_schemas.#DecimalString
#RFC3339Timestamp: shared_schemas.#RFC3339Timestamp

// ── Opaque refs cross-BC ──
#CostCenterRef:          string & !="" // owned by bdg (agg-cost-center; língua bdg — p2p referencia, bdg mantém)
#BudgetStageRef:         string & !="" // etapa do cronograma/orçamento — fato-de-origem como campo (WI-151); conceito first-class bdg-side pendente
#CoverageReservationRef: string & !="" // owned by bdg (reserva do Gate de Cobertura, adr-174; two-phase §2.0.8)
#SourcingDecisionRef:    string & !="" // owned by ssc (vo-sourcing-decision-id; o elo requisição↔cotação, adr-177)

// ── Value-objects locais do P2P ──
#RequisitionId:   string & !="" // vo-requisition-id (root identity do agg-purchase-requisition)
#PurchaseOrderId: string & !="" // vo-purchase-order-id (root identity do agg-purchase-order)
#CategoryRef:     string & !="" // vo-category-ref (taxonomia configurada externamente)

// ── Value-objects da fatia do PO (superfície do agg-purchase-order) ──
#SupplierRef:  string & !="" // vo-supplier-ref: owned by npm — p2p consome ref sem revalidar (inv-no-supplier-revalidation-by-p2p)
#AuthorityRef: string & !="" // vo-authority-ref: sourcingDecisionId SSC-mantido — p2p APLICA authority, não emite (anti-mini-NIM)

// vo-authority-type — FECHADO com fidelidade: o VO fecha via constraint
// ("value deve ser um dos: one-shot-decision, preferred-designation,
// strategic-award"), então o schema fecha junto (P14; mesmo padrão do
// #CancellationReason.reasonCode).
#AuthorityType: "one-shot-decision" | "preferred-designation" | "strategic-award"

// Estado do PurchaseOrder — disjunção FECHADA: o gerador REUSA este enum
// (schemas-preference, rtd-013) e valida contra lifecycle.states do
// am-purchase-order (ordem espelha agg-purchase-order.lifecycle.states).
// requested é 'emit attempt recorded' (Patch 1 founder) — persiste mesmo
// quando a validação falha.
#PurchaseOrderState: "requested" | "emitted" | "cancelled"

// Tradução ACL local de vo-allocation-policy (ssc) — língua local do P2P
// para os fatos -received (sufixo ACL). type FECHADO (constraint do VO
// upstream); splitDetails ABERTO (AllocationSplitDetails sem shape
// declarado — o espelho não inventa, P14).
#AllocationPolicy: {
	type: "single" | "split-by-percentage" | "split-by-criteria"
	splitDetails: {...}
}

// Escopo da demanda (vo-purchase-scope): descrição, volume estimado, prazo,
// location. estimatedVolume é ESTIMATIVA da submissão — NUNCA base de
// reconciliação de valor (adr-177: a fórmula do 2º braço usa quantity FIRME
// declarada na aprovação, não este campo).
#PurchaseScope: {
	description:     string & !=""
	estimatedVolume: #DecimalString
	deadline:        #RFC3339Timestamp
	location:        string & !=""
}

// Justificativa estruturada de cancelamento (vo-cancellation-reason).
// reasonCode FECHADO com fidelidade: o domain-model fecha via constraint
// ("reasonCode deve ser um dos: ..."), então o schema fecha junto (P14).
#CancellationReason: {
	reasonCode: "demand-cancelled" | "scope-mismatch" | "supplier-withdrawal" | "failed-validation-cleanup" | "admin-override" | "queue-overflow" | "other"
	narrative:  string & !="" // obrigatória per vo
}

// Estado da PurchaseRequisition — disjunção FECHADA: o gerador REUSA este
// enum (schemas-preference, rtd-013) e valida contra lifecycle.states do
// am-purchase-requisition (idênticos por construção; ordem espelha
// agg-purchase-requisition.lifecycle.states do domain-model). 6 estados:
// submitted → triaged → approved → converted | rejected | cancelled.
#PurchaseRequisitionState: "submitted" | "triaged" | "approved" | "converted" | "rejected" | "cancelled"

// ════════════════════════════════════════════════════════════════════
// EVENTOS DA REQUISIÇÃO (6) — todos internal (a requisição vive intra-P2P
// até virar pedido; evt-purchase-order-emitted é o sinal published, fora
// deste recorte)
// ════════════════════════════════════════════════════════════════════

// evt-purchase-requisition-submitted — a PORTA da jornada (WI-151/adr-174):
// requisitante declara demanda técnica; requisição nasce em submitted
// aguardando triagem. É o evento que o POST da 1ª tela de origem devolve
// como confirmação (adr-178).
#PurchaseRequisitionSubmitted: #Envelope & {
	type: "mesh.p2p.purchase-requisition-submitted.v1"
	data: {
		requisitionId:  #RequisitionId
		requestedBy:    string & !="" // term-requisitante
		costCenterRef:  #CostCenterRef
		budgetStageRef: #BudgetStageRef
		categoryRef:    #CategoryRef
		scope:          #PurchaseScope
		submittedAt:    #RFC3339Timestamp
	}
}

// evt-purchase-requisition-triaged — triagem FORMAL com outcome (WI-151):
// routed-to-sourcing e rejected transicionam; returned NÃO (requisição
// permanece submitted para correção).
#PurchaseRequisitionTriaged: #Envelope & {
	type: "mesh.p2p.purchase-requisition-triaged.v1"
	data: {
		requisitionId: #RequisitionId
		// Transparência P14 (mesmo padrão da nota 'decision' do contrato FCE):
		// outcome é type:"string" ABERTO no domain-model (a description enumera
		// routed-to-sourcing | returned | rejected mas não há constraint) — o
		// schema NÃO fecha o que o domínio não fecha; selar é backlog P14 do
		// domain-model, não deste espelho.
		outcome:   string & !=""
		triagedBy: string & !="" // term-comprador
		narrative: string // vazia quando routed-to-sourcing; obrigatória em returned/rejected (invariante de handler, não shape)
		triagedAt: #RFC3339Timestamp
	}
}

// evt-purchase-approved — o PORTÃO DUPLO fechou (adr-174 cobertura bdg +
// adr-177 procedência ssc): de-acordo do gestor com reserva confirmada e
// valor verificado contra a cotação vencedora.
#PurchaseApproved: #Envelope & {
	type: "mesh.p2p.purchase-approved.v1"
	data: {
		requisitionId:          #RequisitionId
		approvedBy:             string & !="" // gestor por Alçada — língua bdg
		amount:                 #Money
		sourcingDecisionRef:    #SourcingDecisionRef // o elo formal (adr-177) viaja no fato
		quantity:               #DecimalString       // quantidade FIRME — base de unitPrice × quantity == amount
		coverageReservationRef: #CoverageReservationRef
		approvedAt:             #RFC3339Timestamp
	}
}

// evt-purchase-approval-rejected — não-de-acordo do gestor (decisão humana;
// distinta de falha de gate, que NÃO transiciona nem emite evento).
#PurchaseApprovalRejected: #Envelope & {
	type: "mesh.p2p.purchase-approval-rejected.v1"
	data: {
		requisitionId: #RequisitionId
		rejectedBy:    string & !=""
		narrative:     string & !="" // justificativa obrigatória
		rejectedAt:    #RFC3339Timestamp
	}
}

// evt-purchase-requisition-converted — fecho do ciclo requisição → pedido
// (pol-purchase-order-converts-requisition → cmd-convert-requisition).
#PurchaseRequisitionConverted: #Envelope & {
	type: "mesh.p2p.purchase-requisition-converted.v1"
	data: {
		requisitionId:   #RequisitionId
		purchaseOrderId: #PurchaseOrderId
		convertedAt:     #RFC3339Timestamp
	}
}

// evt-purchase-requisition-cancelled — saída limpa pré-conversão; cancel de
// approved implica liberar a reserva no bdg (release per two-phase adr-174).
#PurchaseRequisitionCancelled: #Envelope & {
	type: "mesh.p2p.purchase-requisition-cancelled.v1"
	data: {
		requisitionId: #RequisitionId
		cancelledBy:   string & !=""
		reason:        #CancellationReason
		cancelledAt:   #RFC3339Timestamp
	}
}

// ════════════════════════════════════════════════════════════════════
// EVENTOS DO PURCHASE ORDER (2 published + 3 ACL internal) — a fatia da
// superfície do agg-purchase-order (missão M1). Payloads espelham
// verbatim os fields do catálogo de events do domain-model.
// ════════════════════════════════════════════════════════════════════

// evt-purchase-order-emitted — o desfecho do recorte da jornada: pedido
// emitido sob authority validada (published; CMT consome como trigger
// canônico de commitment). authorityRef + authorityType + supplier +
// requisitionRef imutáveis pós-emit.
#PurchaseOrderEmitted: #Envelope & {
	type: "mesh.p2p.purchase-order-emitted.v1"
	data: {
		purchaseOrderId: #PurchaseOrderId
		authorityRef:    #AuthorityRef
		authorityType:   #AuthorityType
		supplier:        #SupplierRef
		categoryRef:     #CategoryRef
		scope:           #PurchaseScope
		amount:          #Money
		emittedAt:       #RFC3339Timestamp
		emittedBy:       string & !=""
		requestedBy:     string & !=""
		requisitionRef:  #RequisitionId
	}
}

// evt-purchase-order-cancelled — withdrawal/negative signal a CMT
// pré-formalization (published). supplier optional: populated apenas
// quando o cancel ocorre de emitted (attempt em requested nunca teve
// supplier vinculado).
#PurchaseOrderCancelled: #Envelope & {
	type: "mesh.p2p.purchase-order-cancelled.v1"
	data: {
		purchaseOrderId: #PurchaseOrderId
		supplier?:       #SupplierRef
		cancelledAt:     #RFC3339Timestamp
		cancelledBy:     string & !=""
		reason:          #CancellationReason
	}
}

// evt-sourcing-decision-made-received — tradução ACL de SourcingDecisionMade
// (ssc, hard binding one-shot). Alimenta prj-active-purchase-authorities.
// Eventos ACL -received não carregam actor (adr-182, critério tríplice).
#SourcingDecisionMadeReceived: #Envelope & {
	type: "mesh.p2p.sourcing-decision-made-received.v1"
	data: {
		sourcingDecisionId: string & !=""
		categoryRef:        #CategoryRef
		selectedSuppliers: [...#SupplierRef]
		allocationPolicy: #AllocationPolicy
		receivedAt:       #RFC3339Timestamp
	}
}

// evt-preferred-supplier-designated-received — tradução ACL de
// PreferredSupplierDesignated (ssc, soft binding com validade).
#PreferredSupplierDesignatedReceived: #Envelope & {
	type: "mesh.p2p.preferred-supplier-designated-received.v1"
	data: {
		sourcingDecisionId: string & !=""
		categoryRef:        #CategoryRef
		preferredSuppliers: [...#SupplierRef]
		allocationPolicy: #AllocationPolicy
		validUntil: #RFC3339Timestamp
		receivedAt: #RFC3339Timestamp
	}
}

// evt-strategic-award-completed-received — tradução ACL de
// StrategicAwardCompleted (ssc, advisory Phase 0; hard pós-CTR
// ContractActivated Phase 1+, oq-p2p-1).
#StrategicAwardCompletedReceived: #Envelope & {
	type: "mesh.p2p.strategic-award-completed-received.v1"
	data: {
		sourcingDecisionId: string & !=""
		categoryRef:        #CategoryRef
		awardedSuppliers: [...#SupplierRef]
		allocationPolicy: #AllocationPolicy
		receivedAt: #RFC3339Timestamp
	}
}
