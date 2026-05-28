package cmt

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas para os 11 eventos do BC CMT.
//
// Envelope CloudEvents-like subset consolidado em architecture/shared-schemas/
// envelope.cue per def-022 (resolved em 2026-05-28 quando WI-130/DLV
// materializou o 2º consumidor real). Aqui só aliases locais — VER COMENTÁRIO
// NO ALIAS abaixo sobre proibição de override local.
//
// Money consolidado em architecture/shared-schemas/money.cue per def-025
// (resolved em 2026-05-28 quando WI-131 materializou o 2º consumidor real
// com SHAPE DIVERGENTE — INV declarou decimal-string audit-grade vs CMT
// inline int centavos). Resolução escolheu lado INV; CMT migrou. Aqui só
// alias local — VER COMENTÁRIO NO ALIAS abaixo. amount agora é decimal-
// string não-negativo; producers anteriormente emitindo int centavos (100
// para 1,00) devem emitir string decimal ("1.00"). Phase 0 sem consumers
// reais; migration é lossless.
//
// Refs cross-BC (RiskLevel, ParticipantId, ContractTermsId, PurchaseOrderRef,
// DisputeRef, DisputeResolution) são opaque por design — não importamos
// semântica de REW/NPM/CTR/P2P/DRC para CMT (princípio do slice).
//
// TODO/domain-gap: CommitmentScope é referenciado em domain-model.cue
// (commands + events) mas ainda não tem shape canônico declarado; shape inline
// local até formalização no domain-model.

// ── Aliases para shared_schemas ──
//
// ATENÇÃO: estes aliases são apenas renomeio local — NÃO são pontos de
// extensão. Adicionar overrides locais aqui (e.g., `#Envelope:
// shared_schemas.#Envelope & { customField: ... }`) produz drift silencioso
// vs outros BCs e quebra a consolidação cross-BC. Qualquer divergência local
// deve virar tension-entry + revisita cross-BC antes — ver disciplina de
// fronteira em architecture/shared-schemas/envelope.cue.

#Envelope:         shared_schemas.#Envelope
#RFC3339Timestamp: shared_schemas.#RFC3339Timestamp
#Money:            shared_schemas.#Money

// ── CommitmentScope (inline; ver TODO/domain-gap no topo) ──

#CommitmentScope: {
	description: string & !=""
	value:       #Money
	end:         string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
}

// ── Opaque refs cross-BC (owners listados) ──

#ParticipantId:     string & !=""  // owned by NPM
#ContractTermsId:   string & !=""  // owned by CTR
#PurchaseOrderRef:  string & !=""  // owned by P2P
#RiskLevel:         string & !=""  // owned by REW
#DisputeRef:        string & !=""  // owned by DRC
#DisputeResolution: string & !=""  // owned by DRC

// ── Value-objects locais do CMT (espelham domain-model.cue) ──

#CommitmentId: string & !=""

#CommitmentParties: {
	proposer:     #ParticipantId
	counterparty: #ParticipantId
}

#ContractTermsRef: {
	contractTermsId: #ContractTermsId
	validatedAt:     #RFC3339Timestamp
}

#CommitmentState: "proposed" | "accepted" | "at-risk" | "suspended" | "cancelled"

#StateChangeReason: {
	causeType:     string & !=""
	originContext: string & !=""
	description:   string & !=""
}

// ──────── Events ────────
//
// Cada evento estende #Envelope com `type` literal e `data` concretamente
// tipado. A publicação
// cross-BC é governada por contracts/strategic/context-map.cue, não por
// presença/ausência do payload aqui.

// evt-commitment-proposed
#CommitmentProposed: #Envelope & {
	type: "mesh.cmt.commitment-proposed.v1"
	data: {
		commitmentId:     #CommitmentId
		parties:          #CommitmentParties
		contractTermsRef: #ContractTermsRef
		scope:            #CommitmentScope
	}
}

// evt-commitment-accepted
#CommitmentAccepted: #Envelope & {
	type: "mesh.cmt.commitment-accepted.v1"
	data: {
		commitmentId:     #CommitmentId
		parties:          #CommitmentParties
		contractTermsRef: #ContractTermsRef
		scope:            #CommitmentScope
		acceptedAt:       #RFC3339Timestamp
	}
}

// evt-commitment-state-changed
#CommitmentStateChanged: #Envelope & {
	type: "mesh.cmt.commitment-state-changed.v1"
	data: {
		commitmentId:  #CommitmentId
		previousState: #CommitmentState
		newState:      #CommitmentState
		reason:        #StateChangeReason
	}
}

// evt-counterparty-risk-signaled
#CounterpartyRiskSignaled: #Envelope & {
	type: "mesh.cmt.counterparty-risk-signaled.v1"
	data: {
		commitmentId: #CommitmentId
		riskLevel:    #RiskLevel
	}
}

// evt-dispute-resolved-received
#DisputeResolvedReceived: #Envelope & {
	type: "mesh.cmt.dispute-resolved-received.v1"
	data: {
		commitmentId: #CommitmentId
		resolution:   #DisputeResolution
	}
}

// evt-suspension-ordered-received
#SuspensionOrderedReceived: #Envelope & {
	type: "mesh.cmt.suspension-ordered-received.v1"
	data: {
		commitmentId: #CommitmentId
		disputeRef:   #DisputeRef
	}
}

// evt-counterparty-risk-cleared
#CounterpartyRiskCleared: #Envelope & {
	type: "mesh.cmt.counterparty-risk-cleared.v1"
	data: {
		commitmentId: #CommitmentId
	}
}

// evt-purchase-order-received
#PurchaseOrderReceived: #Envelope & {
	type: "mesh.cmt.purchase-order-received.v1"
	data: {
		purchaseOrderRef: #PurchaseOrderRef
		buyer:            #ParticipantId
		supplier:         #ParticipantId
	}
}

// evt-contract-terms-activated-received
#ContractTermsActivatedReceived: #Envelope & {
	type: "mesh.cmt.contract-terms-activated-received.v1"
	data: {
		contractTermsId: #ContractTermsId
		effectiveFrom:   #RFC3339Timestamp
	}
}

// evt-contract-terms-superseded-received
#ContractTermsSupersededReceived: #Envelope & {
	type: "mesh.cmt.contract-terms-superseded-received.v1"
	data: {
		contractTermsId: #ContractTermsId
		supersededBy:    #ContractTermsId
	}
}

// evt-contract-terms-cancelled-received
#ContractTermsCancelledReceived: #Envelope & {
	type: "mesh.cmt.contract-terms-cancelled-received.v1"
	data: {
		contractTermsId: #ContractTermsId
		reasonType:      string & !=""
		cancelledAt:     #RFC3339Timestamp
	}
}
