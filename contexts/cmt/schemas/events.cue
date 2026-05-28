package cmt


// schemas/events.cue — Payload schemas para os 11 eventos do BC CMT.
//
// Per WI-129 + def-022: envelope (CloudEvents-like subset, NÃO conformidade
// formal a CloudEvents 1.0) e tipo Money são inline e locais ao CMT;
// consolidação em architecture/shared-schemas/ é deferida pro 2º BC do slice
// (DLV) — trigger em def-022.
//
// Refs cross-BC (RiskLevel, ParticipantId, ContractTermsId, PurchaseOrderRef,
// DisputeRef, DisputeResolution) são opaque por design — não importamos
// semântica de REW/NPM/CTR/P2P/DRC para CMT (princípio do slice).
//
// TODO/domain-gap: CommitmentScope é referenciado em domain-model.cue
// (commands + events) mas ainda não tem shape canônico declarado; shape inline
// local até formalização no domain-model.

// ── Envelope (CloudEvents-like subset, inline per def-022) ──
//
// Sem campo `data` na base — cada evento adiciona `data` concretamente
// tipado, impedindo envelope sem payload tipado. `...` permite a extensão
// por evento sem afrouxar o shape dos campos declarados.

#Envelope: {
	id:          string & !=""
	source:      string & =~"^mesh://contexts/[a-z][a-z0-9-]*$"
	type:        string & !=""
	specversion: "1.0"
	time:        string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"
	dataschema?: string
	...
}

// ── Money (inline per def-022) ──
//
// amount em centavos (int) para precisão exata; currency ISO 4217.

#Money: {
	amount:   int & >=0
	currency: string & =~"^[A-Z]{3}$"
}

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
	validatedAt:     string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"
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
// tipado. visibility (internal/external) anotado por comentário; a publicação
// cross-BC é governada por contracts/strategic/context-map.cue, não por
// presença/ausência do payload aqui.

// evt-commitment-proposed — visibility: internal
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
		acceptedAt:       string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"
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
		effectiveFrom:   string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"
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
		cancelledAt:     string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"
	}
}
