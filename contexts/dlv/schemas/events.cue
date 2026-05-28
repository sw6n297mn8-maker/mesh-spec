package dlv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas para os 7 eventos do BC DLV.
//
// Per WI-130, espelha o pattern do CMT (opaque refs cross-BC + envelope
// CloudEvents-like subset). source mesh://contexts/dlv; types
// mesh.dlv.<event-name>.v1.
//
// Envelope CONSOLIDADO em architecture/shared-schemas/envelope.cue per
// def-022 (resolved em 2026-05-28 — este arquivo, criado por WI-130, foi
// o 2º consumidor real que disparou o trigger). Aqui só alias local —
// VER COMENTÁRIO NO ALIAS abaixo sobre proibição de override local.
//
// Money NÃO foi consolidado (DLV não usa); aguarda 2º consumidor real
// via def-025.
//
// DLV usa integer para timestamps de DOMÍNIO (decidedAt, finalityAt,
// recordedAt, etc.) — diferente do CMT (RFC3339 strings). O envelope.time
// continua RFC3339 (consistência cross-BC no momento de publicação,
// garantida pelo shape compartilhado); só os data.* internos usam integer
// per design do DLV. UNIDADE (ms vs s) NÃO é declarada no domain-model —
// assumindo ms por padrão de mercado; quando o domain-model formalizar,
// este mirror precisa revisita.
//
// TODO/domain-gap (NÃO É SÓ ESTILO — É GAP DE FIDELIDADE):
// Os value-objects do DLV são wrappers {value} no domain-model sem TYPE
// declarado para o campo `value`. Achatei aqui pra string opaca onde a
// semântica é string-like, e pra int em EventLogOffset onde é claramente
// offset numérico. CONSUMER NÃO DEVE assumir "qualquer string" — várias
// têm semântica conhecida que o domain-model precisa formalizar:
//   • EvidenceRef, IntegrityProofRef → provavelmente URIs (DSSE-anchored
//     per canvas DLV "cadeia de evidência DSSE-anchored via IDC").
//   • ReasonCode, RetryPath, DecisionOutcome, VerificationState →
//     provavelmente enums (codes / state machines).
//   • CriteriaVersion → provavelmente semver ou string versionada com
//     ordering.
// Mirror revisita quando domain-model declarar os types reais. Refs
// cross-BC (CommitmentRef → owned by CMT) são opaque por design.

// ── Alias para shared_schemas ──
//
// ATENÇÃO: este alias é apenas renomeio local — NÃO é ponto de extensão.
// Adicionar overrides locais aqui (e.g., `#Envelope:
// shared_schemas.#Envelope & { customField: ... }`) produz drift silencioso
// vs outros BCs e quebra a consolidação cross-BC. Qualquer divergência
// local deve virar tension-entry + revisita cross-BC antes — ver disciplina
// de fronteira em architecture/shared-schemas/envelope.cue.
//
// DLV NÃO aliasa #RFC3339Timestamp porque os timestamps de DOMÍNIO são
// integer (epoch ms); envelope.time é RFC3339 mas vem direto do shape
// compartilhado, sem uso adicional local.

#Envelope: shared_schemas.#Envelope

// ── Opaque refs cross-BC ──
#CommitmentRef: string & !=""  // owned by CMT (equivalente ao vo-commitment-id lá)

// ── Value-objects locais do DLV (ver TODO/domain-gap no header) ──
#EvidenceRef:       string & !=""
#IntegrityProofRef: string & !=""
#CriteriaVersion:   string & !=""
#ReasonCode:        string & !=""
#RetryPath:         string & !=""
#DecisionOutcome:   string & !=""
#VerificationState: string & !=""
#EventLogOffset:    int & >=0  // offset numérico (não string) — único VO com semântica numérica clara

#ExceptionEntry: {
	reason:      string & !=""
	timestamp:   int & >=0   // epoch ms (assumido; ver header)
	triggeredBy: string & !=""
	resolvedAt?: int & >=0
	resolution?: string & !=""
}

// ──────── Events ────────
//
// Cada evento estende #Envelope com `type` literal e `data` concretamente
// tipado. Timestamps de DOMÍNIO em integer (per DLV design); envelope.time
// continua RFC3339 string.

// evt-delivery-verified
#DeliveryVerified: #Envelope & {
	type: "mesh.dlv.delivery-verified.v1"
	data: {
		commitmentRef:     #CommitmentRef
		evidenceRef:       #EvidenceRef
		criteriaVersion:   #CriteriaVersion
		decidedAt:         int & >=0
		finalityAt:        int & >=0
		decidedBy:         string & !=""
		integrityProofRef: #IntegrityProofRef
		// TODO/domain-gap: domain-model não marca optional, mas semanticamente só
		// existe quando há supersessão. Marcado optional aqui; formalização cabe
		// ao domain-model.
		supersededByRef?: #EvidenceRef
		eventLogOffset:   #EventLogOffset
	}
}

// evt-delivery-rejected
#DeliveryRejected: #Envelope & {
	type: "mesh.dlv.delivery-rejected.v1"
	data: {
		commitmentRef:     #CommitmentRef
		evidenceRef:       #EvidenceRef
		criteriaVersion:   #CriteriaVersion
		reasonCode:        #ReasonCode
		retryPath:         #RetryPath
		decidedAt:         int & >=0
		finalityAt:        int & >=0
		decidedBy:         string & !=""
		integrityProofRef: #IntegrityProofRef
		// TODO/domain-gap: idem DeliveryVerified.
		supersededByRef?: #EvidenceRef
		eventLogOffset:   #EventLogOffset
	}
}

// evt-evidence-recorded
#EvidenceRecorded: #Envelope & {
	type: "mesh.dlv.evidence-recorded.v1"
	data: {
		commitmentRef:     #CommitmentRef
		evidenceRef:       #EvidenceRef
		integrityProofRef: #IntegrityProofRef
		recordedAt:        int & >=0
		eventLogOffset:    #EventLogOffset
	}
}

// evt-exception-entered
#ExceptionEntered: #Envelope & {
	type: "mesh.dlv.exception-entered.v1"
	data: {
		commitmentRef:  #CommitmentRef
		evidenceRef:    #EvidenceRef
		exceptionEntry: #ExceptionEntry
		eventLogOffset: #EventLogOffset
	}
}

// evt-exception-extended
#ExceptionExtended: #Envelope & {
	type: "mesh.dlv.exception-extended.v1"
	data: {
		commitmentRef:  #CommitmentRef
		evidenceRef:    #EvidenceRef
		exceptionEntry: #ExceptionEntry
		newDeadline:    int & >=0
		eventLogOffset: #EventLogOffset
	}
}

// evt-exception-resolved
#ExceptionResolved: #Envelope & {
	type: "mesh.dlv.exception-resolved.v1"
	data: {
		commitmentRef:  #CommitmentRef
		evidenceRef:    #EvidenceRef
		resolution:     #DecisionOutcome
		resolvedAt:     int & >=0
		resolutionType: string & !=""
		eventLogOffset: #EventLogOffset
	}
}

// evt-supersession-applied
#SupersessionApplied: #Envelope & {
	type: "mesh.dlv.supersession-applied.v1"
	data: {
		commitmentRef:          #CommitmentRef
		supersededEvidenceRef:  #EvidenceRef
		supersedingEvidenceRef: #EvidenceRef
		lineageSource:          string & !=""
		eventLogOffset:         #EventLogOffset
	}
}
