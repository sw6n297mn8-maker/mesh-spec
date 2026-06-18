package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas dos 9 eventos do domain-model FCE
// (+ contrato-de-consumo #EligibilityConsumption, fora do events[]).
//
// FATIA FCE DO WI-140 (claim WI-140-claim-fatia-fce — NÃO conclui o WI;
// precedente: fatia-2 DLV). Espelha o pattern DLV/CMT: #Envelope
// consolidado (shared-schemas, def-022), opaque refs cross-BC, eventos
// como #Envelope & {type, data}. source mesh://contexts/fce; types
// próprios mesh.fce.<event-name>.v1.
//
// TIMESTAMPS: FCE usa #RFC3339Timestamp (shared) nos data.* de domínio
// (settledAt, validUntil) — alinhado ao CMT, não ao integer do DLV.
//
// MONEY: #Money consolidado (shared-schemas, def-025 resolved); usado em
// amount (espelho INV).
//
// EVENTOS CONSUMIDOS (3) — papéis distintos, declarados por evento:
// • #InvoiceIssued: ESPELHO VERBATIM do canônico do INV
//   (contexts/inv/schemas/events.cue:126, mesh.inv.invoice-issued.v1,
//   7 campos). NÃO DIVERGIR — qualquer mudança no INV exige revisita
//   deste espelho. O domain-model do FCE declara consumo PARCIAL (5 dos
//   7 campos — decisão α do founder: espelho-7 no schema, consumo-5 no
//   domain-model). 1ª instância de espelho cross-BC: mecanismo de
//   consolidação é def-057 (deferred-decision deste pacote).
// • #EligibilityConsumption: CONTRATO-DE-CONSUMO da faceta eligibility de
//   RiskEvaluationEmitted (produtor REW; def-057 opção d). Projeção do
//   subconjunto que o guard lê — não é evento (o REW emite o fato unificado).
// • #SettlementFinalized: FIXTURE-CONTRACT (BKR sem schemas) — shape mínimo
//   do que o settle consome (bkr:482). Forward-ref adr-149: aplicar o
//   contrato-de-consumo quando BKR materializar SettlementFinalized.

// ── Aliases para shared_schemas ──
//
// ATENÇÃO: aliases são renomeio local — NÃO são ponto de extensão.
// Overrides locais produzem drift silencioso cross-BC; divergência local
// exige tension-entry + revisita (disciplina de
// architecture/shared-schemas/envelope.cue).

#Envelope:         shared_schemas.#Envelope
#Money:            shared_schemas.#Money
#RFC3339Timestamp: shared_schemas.#RFC3339Timestamp

// ── Opaque refs cross-BC ──
#CommitmentRef: string & !="" // owned by CMT (vo-commitment-id lá; vo-commitment-ref aqui)
#InvoiceId:     string & !="" // owned by INV
#EvidenceRef:   string & !="" // owned by INV/DLV chain (espelho)
#RegimeVersion: string & !="" // owned by INV (espelho)
#FiscalDocRef:  string & !="" // owned by INV (espelho)

// ── Value-objects locais do FCE ──
#PaymentId:       string & !=""
#InstructionId:   string & !="" // novo por tentativa de dispatch (InstructionRejected é terminal)
#RailReferenceId: string & !="" // referência do rail, devolvida pelo BKR na reconciliação
#SupervisorId:    string & !="" // identidade do supervisor humano que resolve a escalada (adr-155)

// Estado do Payment — disjunção FECHADA: o gerador REUSA este enum
// (schemas-preference, rtd-013) e valida contra lifecycle.states do
// am-payment (idênticos por construção; ordem espelha agg-payment.lifecycle.
// states do domain-model). 6 estados da fatia: 4 do caminho autônomo
// (guarded → authorized → dispatched → settled) + 2 do override humano do
// adr-155 (escalated, refused). T2 do domain-model:
// failed/indeterminate/cancelled entram com os fluxos de exceção.
#PaymentState: "guarded" | "escalated" | "authorized" | "dispatched" | "settled" | "refused"

// Prova de Autorização (glossário term-prova-de-autorizacao; as-fce-3):
// artefato verificável que acompanha toda PaymentInstruction.
#AuthorizationProof: {
	signature:  string & !=""
	nonce:      string & !="" // uso único por instrução
	validUntil: #RFC3339Timestamp
	claimChain: string & !=""
}

// Condições do guard sobrepostas no override (adr-155; glossário/domain-model
// vo-overridden-guard-conditions). SEM flag de integridade-criptográfica POR
// CONSTRUÇÃO: breach (evidência ausente/forjada) nunca é overridável — vai a
// freeze (p11-invariant-breach-detected), não a este VO. Reforça
// inv-breach-bypasses-escalation. "Ao menos uma flag true" é invariante de
// domínio (handler), não shape — alinhado ao padrão do arquivo (constraints
// de domínio ficam em prose, não em CUE; cf. nonce uso-único de #AuthorizationProof).
#OverriddenGuardConditions: {
	invoiceStaleOverridden:      bool
	eligibilityStaleOverridden:  bool
	evidenceFreshnessOverridden: bool
}

// ════════════════════════════════════════════════════════════════════
// EVENTOS CONSUMIDOS (3)
// ════════════════════════════════════════════════════════════════════

// evt-invoice-issued — ESPELHO VERBATIM do INV (ver header). Canônico:
// contexts/inv/schemas/events.cue:126. NÃO DIVERGIR (def-057).
#InvoiceIssued: #Envelope & {
	type: "mesh.inv.invoice-issued.v1"
	data: {
		invoiceId:     #InvoiceId
		commitmentRef: #CommitmentRef
		evidenceRef:   #EvidenceRef
		amount:        #Money
		regimeVersion: #RegimeVersion
		fiscalDocRef:  #FiscalDocRef
		issuedAt:      #RFC3339Timestamp
	}
}

// CONTRATO-DE-CONSUMO (def-057 opção d, adr-149) — NÃO é evento: o REW NÃO
// emite mesh.rew.eligibility-emitted.v1. FCE consome as facetas ELIGIBILITY
// + CONTEXT de RiskEvaluationEmitted (produtor REW, contexts/rew/schemas/
// events.cue — mesh.rew.risk-evaluation-emitted.v1): decision ← eligibility
// (#EligibilityDecision); entityRef + policyVersion ← context
// (#ApplicableContext). Projeção do subconjunto que o PrePaymentGuard condição
// (b) lê; score/confidence NÃO consumidos (sem re-declarar o fato inteiro).
// _consumesEvent/_projectsFacets são hidden fields (gerador ignora — campos
// _-prefixed). decision usa grafia UNDERSCORE (igual ao produtor) inline.
#EligibilityConsumption: {
	_consumesEvent:  "mesh.rew.risk-evaluation-emitted.v1"
	_projectsFacets: ["eligibility", "context"]
	entityRef:     string & !=""
	decision:      "eligible" | "conditionally_eligible" | "ineligible"
	policyVersion: string & !=""
}

// evt-settlement-finalized — FIXTURE-CONTRACT (BKR sem schemas; shape
// mínimo do que o settle consome; forward-ref adr-149: contrato-de-consumo
// quando BKR materializar).
#SettlementFinalized: #Envelope & {
	type: "mesh.bkr.settlement-finalized.v1"
	data: {
		instructionId:   #InstructionId
		railReferenceId: #RailReferenceId
	}
}

// ════════════════════════════════════════════════════════════════════
// EVENTOS PRÓPRIOS DO FCE (7)
// ════════════════════════════════════════════════════════════════════

// evt-payment-authorized — guard aprovou as 3 condições; decisão
// econômica tomada + proof emitida (interno ao BC).
#PaymentAuthorized: #Envelope & {
	type: "mesh.fce.payment-authorized.v1"
	data: {
		paymentId: #PaymentId
		proof:     #AuthorizationProof
	}
}

// evt-payment-instruction-dispatched — instrução emitida ao BKR sob
// proof (interno ao BC).
#PaymentInstructionDispatched: #Envelope & {
	type: "mesh.fce.payment-instruction-dispatched.v1"
	data: {
		paymentId:     #PaymentId
		instructionId: #InstructionId
	}
}

// evt-payment-settled — fato canônico de "dinheiro moveu" (published;
// consumers REW/SCF/ATO/TCM; bd-settlement-fact-canonical).
#PaymentSettled: #Envelope & {
	type: "mesh.fce.payment-settled.v1"
	data: {
		paymentId:       #PaymentId
		commitmentRef:   #CommitmentRef
		railReferenceId: #RailReferenceId
		settledAt:       #RFC3339Timestamp
	}
}

// evt-payment-obligation-defaulted — published para REW (catálogo: o
// FLUXO de default está fora da fatia, T2 — nenhuma transição o emite
// ainda; declarado para integridade do context-map, sc-cm-06).
#PaymentObligationDefaulted: #Envelope & {
	type: "mesh.fce.payment-obligation-defaulted.v1"
	data: {
		paymentId:     #PaymentId
		commitmentRef: #CommitmentRef
	}
}

// evt-payment-guard-escalated — guard não-limpo (stale/incompleto/ambíguo-
// mas-PRESENTE) → Payment escala para julgamento humano (interno ao BC;
// adr-155). NÃO é breach: evidência ausente/forjada vai a freeze, não escala.
#PaymentGuardEscalated: #Envelope & {
	type: "mesh.fce.payment-guard-escalated.v1"
	data: {
		paymentId:           #PaymentId
		escalatedConditions: #OverriddenGuardConditions
	}
}

// evt-payment-guard-overridden — supervisor APROVOU o override (interno ao
// BC; adr-155). Carrega a atribuição nominal (quem / por quê / o que foi
// sobreposto) + a proof para o audit trail. Distinto de evt-payment-authorized
// (autônomo): separa override humano de gate-pass autônomo (fronteira P10).
#PaymentGuardOverridden: #Envelope & {
	type: "mesh.fce.payment-guard-overridden.v1"
	data: {
		paymentId:            #PaymentId
		supervisorId:         #SupervisorId
		reason:               string & !=""
		overriddenConditions: #OverriddenGuardConditions
		proof:                #AuthorizationProof
	}
}

// evt-payment-guard-override-refused — supervisor NEGOU o override → terminal
// refused (interno ao BC; adr-155). O destino da obrigação (default,
// reissuance, encerramento) é decisão supervisionada fora desta fatia (T2).
#PaymentGuardOverrideRefused: #Envelope & {
	type: "mesh.fce.payment-guard-override-refused.v1"
	data: {
		paymentId:    #PaymentId
		supervisorId: #SupervisorId
		reason:       string & !=""
	}
}
