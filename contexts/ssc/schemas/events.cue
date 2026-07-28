package ssc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas dos 9 eventos do agg-sourcing-process
// (kit de superfície WI-159, molde adr-178: FCE→p2p→ssc).
//
// COBERTURA COMPLETA DO AGGREGATE (único do BC): 6 published (3 spine de
// decisão + 3 lifecycle de RFQ) + 2 internal de cotação (WI-152; a
// confidencialidade competitiva veta evento PÚBLICO, não o fato) + 1 ACL
// -received (npm). Espelha o pattern FCE/CMT/p2p: #Envelope consolidado
// (shared-schemas, def-022), opaque refs cross-BC, eventos como
// #Envelope & {type, data}. source mesh://contexts/ssc; types próprios
// mesh.ssc.<event-name>.v1.
//
// TIMESTAMPS: #RFC3339Timestamp (shared) nos data.* de domínio. DECIMAL:
// #DecimalString (Ion-4) em preços/volumes/scores — nunca float.
//
// TRANSPARÊNCIA P14 (molde da nota 'outcome' do p2p): os domain-types
// FitnessRuleContent (shape deliberadamente em oq-ssc-8),
// AllocationSplitDetails, CriterionList, WeightsByCriterion e
// ScoresByCriterion NÃO têm shape fechado no domain-model — os espelhos
// abaixo os representam ABERTOS (struct aberto / listas e mapas de
// primitivos) e NÃO inventam estrutura que o domínio não declara. Selar
// é backlog do domain-model (oq-ssc-8), não deste espelho.

// ── Aliases para shared_schemas ──
//
// ATENÇÃO: aliases são renomeio local — NÃO são ponto de extensão
// (disciplina de architecture/shared-schemas/envelope.cue).

#Envelope:         shared_schemas.#Envelope
#DecimalString:    shared_schemas.#DecimalString
#RFC3339Timestamp: shared_schemas.#RFC3339Timestamp

// ── Opaque refs cross-BC ──
#SupplierRef: string & !="" // owned by npm (participante qualificado; ssc consome ref, npm mantém identidade)

// ── Value-objects locais do SSC ──
#RfqId:              string & !="" // vo-rfq-id (root identity do agg-sourcing-process; existe desde a abertura)
#QuotationId:        string & !="" // vo-quotation-id (root identity de ent-quotation nested)
#CategoryRef:        string & !="" // vo-category-ref (taxonomia de compra configurada externamente)
#SourcingDecisionId: string & !="" // vo-sourcing-decision-id (populated apenas quando RFQ concluída com decisão)

// Tipo declarado upfront (vo-decision-type) — FECHADO com fidelidade: o
// domain-model fecha via constraint, então o schema fecha junto (P14).
#DecisionType: "one-shot" | "preferred-designation" | "strategic-award"

// Política de allocation (vo-allocation-policy). type FECHADO (constraint do
// VO); splitDetails ABERTO (domain-type AllocationSplitDetails sem shape
// declarado — prosa do VO descreve por tipo; o espelho não inventa).
#AllocationPolicy: {
	type: "single" | "split-by-percentage" | "split-by-criteria"
	splitDetails: {...}
}

// Escopo da RFQ (vo-rfq-scope).
#RfqScope: {
	categoryRef:     #CategoryRef
	description:     string & !=""
	estimatedVolume: #DecimalString
	deadline:        #RFC3339Timestamp
	location:        string & !=""
}

// Janela de validade (vo-validity-period) — preferred designation expira
// passivamente após validUntil.
#ValidityPeriod: {
	validFrom:  #RFC3339Timestamp
	validUntil: #RFC3339Timestamp
}

// Input indicativo para CTR (vo-expected-contract-scope) — não vinculante.
#ExpectedContractScope: {
	committedVolume:      #DecimalString
	contractTermDuration: string & !=""
	indicativeConditions: string & !=""
}

// Snapshot imutável de fitness rules (vo-fitness-rule-snapshot). content
// ABERTO (FitnessRuleContent — shape em oq-ssc-8, decisão deliberada).
#FitnessRuleSnapshot: {
	versionId: string & !=""
	content: {...}
	appliedAt: #RFC3339Timestamp
}

// Avaliação per-supplier (vo-evaluated-supplier). scoresPerCriterion é mapa
// critério→score (ScoresByCriterion sem shape fechado — mapa de decimal).
#EvaluatedSupplier: {
	supplierRef: #SupplierRef
	scoresPerCriterion: [string]: #DecimalString
	finalRank: int
	notes:     string
}

// Justificativa estruturada de escolha vs alternativa (vo-tradeoff).
#Tradeoff: {
	preferredSupplier:   #SupplierRef
	alternativeSupplier: #SupplierRef
	criterion:           string & !=""
	rationale:           string & !=""
}

// Rationale estruturado da decisão (vo-decision-rationale). criteria/weights
// espelham CriterionList/WeightsByCriterion abertos (lista de nomes + mapa
// critério→peso — o domínio não fecha a taxonomia de critérios).
#DecisionRationale: {
	criteria: [...string]
	weights: [string]: #DecimalString
	evaluatedSuppliers: [...#EvaluatedSupplier]
	tradeoffs: [...#Tradeoff]
}

// ════════════════════════════════════════════════════════════════════
// EVENTOS DO SOURCING PROCESS (9) — 6 published (3 spine de decisão +
// 3 lifecycle de RFQ) + 2 internal de cotação + 1 ACL -received
// ════════════════════════════════════════════════════════════════════

// evt-rfq-opened — a PORTA do sourcing (passo 5 da ds-buyer-procurement-
// journey): RFQ aberta com tipo declarado upfront; é o evento que o POST
// da superfície devolve como confirmação (molde CMT/FCE/p2p).
#RFQOpened: #Envelope & {
	type: "mesh.ssc.rfq-opened.v1"
	data: {
		rfqId:             #RfqId
		categoryRef:       #CategoryRef
		scope:             #RfqScope
		decisionType:      #DecisionType
		openedAt:          #RFC3339Timestamp
		quotationDeadline: #RFC3339Timestamp
		invitedSuppliers: [...#SupplierRef]
	}
}

// evt-rfq-concluded — conclusão pareada com a abertura (decisão emitida).
#RFQConcluded: #Envelope & {
	type: "mesh.ssc.rfq-concluded.v1"
	data: {
		rfqId:              #RfqId
		sourcingDecisionId: #SourcingDecisionId
		concludedAt:        #RFC3339Timestamp
	}
}

// evt-rfq-cancelled — cancelamento antes de decisão (supervisedDecision).
#RFQCancelled: #Envelope & {
	type: "mesh.ssc.rfq-cancelled.v1"
	data: {
		rfqId:       #RfqId
		cancelledAt: #RFC3339Timestamp
		cancelledBy: string & !=""
		reason:      string & !="" // justificativa documentada — obrigatória per evento
	}
}

// evt-sourcing-decision-made — decisão one-shot emitida (hard binding p2p).
#SourcingDecisionMade: #Envelope & {
	type: "mesh.ssc.sourcing-decision-made.v1"
	data: {
		sourcingDecisionId: #SourcingDecisionId
		rfqId:              #RfqId
		categoryRef:        #CategoryRef
		selectedSuppliers: [...#SupplierRef]
		allocationPolicy:    #AllocationPolicy
		decisionRationale:   #DecisionRationale
		fitnessRuleSnapshot: #FitnessRuleSnapshot
		decidedAt:           #RFC3339Timestamp
		decidedBy:           string & !=""
	}
}

// evt-preferred-supplier-designated — designação preferred com validade.
#PreferredSupplierDesignated: #Envelope & {
	type: "mesh.ssc.preferred-supplier-designated.v1"
	data: {
		sourcingDecisionId: #SourcingDecisionId
		rfqId:              #RfqId
		categoryRef:        #CategoryRef
		preferredSuppliers: [...#SupplierRef]
		allocationPolicy:    #AllocationPolicy
		decisionRationale:   #DecisionRationale
		fitnessRuleSnapshot: #FitnessRuleSnapshot
		validityPeriod:      #ValidityPeriod
		designatedAt:        #RFC3339Timestamp
		designatedBy:        string & !=""
	}
}

// evt-strategic-award-completed — gatilho de formalização contratual (CTR).
#StrategicAwardCompleted: #Envelope & {
	type: "mesh.ssc.strategic-award-completed.v1"
	data: {
		sourcingDecisionId: #SourcingDecisionId
		rfqId:              #RfqId
		categoryRef:        #CategoryRef
		awardedSuppliers: [...#SupplierRef]
		allocationPolicy:      #AllocationPolicy
		decisionRationale:     #DecisionRationale
		fitnessRuleSnapshot:   #FitnessRuleSnapshot
		expectedContractScope: #ExpectedContractScope
		awardedAt:             #RFC3339Timestamp
		awardedBy:             string & !=""
	}
}

// evt-quotation-submitted — fato INTERNO do processo competitivo (WI-152;
// alimenta o mapa de cotações; nunca propaga cross-BC).
#QuotationSubmitted: #Envelope & {
	type: "mesh.ssc.quotation-submitted.v1"
	data: {
		rfqId:            #RfqId
		supplierRef:      #SupplierRef
		unitPrice:        #DecimalString
		currency:         string & !=""
		declaredCapacity: #DecimalString
		termsNotes:       string
		submittedAt:      #RFC3339Timestamp
	}
}

// evt-quotation-withdrawn — par do submitted (mapa marca withdrawn).
#QuotationWithdrawn: #Envelope & {
	type: "mesh.ssc.quotation-withdrawn.v1"
	data: {
		rfqId:       #RfqId
		supplierRef: #SupplierRef
		withdrawnAt: #RFC3339Timestamp
	}
}

// evt-network-participant-status-changed-received — tradução ACL de sinal
// npm (sufixo -received per convenção CMT/BDG). newEligibility ABERTO no
// espelho: a prosa do evento enumera os valores mas o domínio não fecha
// via constraint (nota P14 — o espelho não inventa enum).
#NetworkParticipantStatusChangedReceived: #Envelope & {
	type: "mesh.ssc.network-participant-status-changed-received.v1"
	data: {
		supplierRef:    #SupplierRef
		newEligibility: string & !=""
		changedAt:      #RFC3339Timestamp
	}
}
