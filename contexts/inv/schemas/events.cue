package inv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas para os eventos do BC INV (Invoicing).
//
// 3 events PUBLISHED (InvoiceIssued, ReceivableMaterialized, InvoiceCancelled)
// + 2 events RECEIVED (DeliveryVerifiedReceived, CommitmentAcceptedReceived) —
// estes últimos são TYPED VIEWS LOCAIS pós-ACL, source mesh://contexts/inv,
// types mesh.inv.<event-name>-received.v1 (espelha o pattern estabelecido em
// WI-129 para CMT). NÃO clonam o contrato upstream — filtram severamente per
// canvas.communication.inbound (anti-payload-bloat).
//
// source mesh://contexts/inv; types mesh.inv.<event-name>.v1.
//
// Envelope CONSOLIDADO em architecture/shared-schemas/envelope.cue per
// def-022 (resolved). VER COMENTÁRIO NO ALIAS abaixo sobre proibição de
// override local. INV alinha com CMT em timestamps RFC3339 (audit fiscal
// é regulatorialmente sensível — cancellation window SEFAZ ≤24h pós-emit
// exige RFC3339 timezone-aware, integer epoch perderia legibilidade em
// audit). DLV usa integer epoch para timestamps de DOMÍNIO de delivery
// telemetry; INV NÃO segue DLV nesse ponto.
//
// ── MONEY: DIVERGÊNCIA INTENCIONAL vs CMT (evidência empírica para def-025) ──
//
// Domain-model do INV declara amount como `decimal`. Representação concreta
// JSON-safe: string com regex (preserva precisão arbitrary; JSON Numbers
// perdem precisão >2^53). CMT escolheu int em centavos (escala global).
// INV escolhe decimal-string (audit-grade, jurisdiction-aware minor-units).
//
// Esta divergência é DELIBERADA, não acidente. def-022 consolidou apenas
// envelope; def-025 (criado em 2026-05-28) deferiu Money até 2º consumidor
// real. INV é esse 2º consumidor. AGORA def-025 ganha sinal mais rico para
// resolver: não é só "2 BCs usam Money", é "2 BCs usam Money com SHAPES
// INCOMPATÍVEIS por razões legítimas". Antes de qualquer shared Money em
// architecture/shared-schemas/money.cue, def-025 precisa comparar:
//   - CMT: amount: int & >=0 (centavos)
//   - INV: amount: #DecimalString & =~"^[0-9]+(\\.[0-9]+)?$" (decimal não-negativo)
// e decidir representação canônica (provavelmente decimal-string vence por
// jurisdiction-awareness; CMT migraria com lossless conversion centavos
// → decimal). Mas a decisão é arquitetural, não inferível só da divergência.
//
// ── TIMESTAMPS SEMÂNTICOS (TODO/domain-gap — não é contrato canônico ainda) ──
//
// Domain-model INV lista apenas `eventTimestamp` (técnico) em todos events,
// mas a regra normativa de cancellation window usa `Invoice.issuedAt`
// (semântico, da entity). Event payload precisa carregar semantic timestamp
// para replay event-sourced e audit fiscal. Adicionados aqui como MIRROR
// OPERACIONAL para replay/audit:
//   - InvoiceIssued.data.issuedAt    — quando invoice canonicamente nasceu
//   - ReceivableMaterialized.data.materializedAt — quando receivable surgiu
//   - InvoiceCancelled.data.cancelledAt — quando cancelamento foi efetivado
// NÃO É CONTRATO CANÔNICO AINDA — domain-model precisa formalizar. Não abro
// tension-entry porque o gap é local ao INV; abrir só se afetar invariantes,
// async-api/api.yaml, ou outro BC. envelope.time continua técnico (quando
// envelope foi publicado); semantic timestamps na data são domain-meaningful.
//
// ── DIVERGÊNCIAS CANVAS vs DOMAIN-MODEL (sigo domain-model per task-spec) ──
//
// Canvas menciona dueDate e taxBreakdown em payloads InvoiceIssued/
// ReceivableMaterialized; domain-model NÃO declara esses fields. Per
// semanticPrerequisites do WI-131, domain-model é fonte canônica — sigo
// domain-model. Tension-entry NÃO aberta (canvas wording vs domain-model
// formal é decisão do founder); apenas documento aqui. Idem para
// CommitmentAcceptedReceived: canvas menciona dueDate/parties/taxRegimeRef;
// CMT contract real (CommitmentAccepted.data) tem commitmentId, parties,
// contractTermsRef, scope, acceptedAt — NÃO tem taxRegimeRef nem dueDate
// como field próprio (scope.end é date YYYY-MM-DD, próximo a dueDate
// semanticamente). NÃO invento fields fantasma; filtro per o que CMT
// realmente publica.
//
// ── STATUS=APPROVED É CRITÉRIO DE CANAL, NÃO FIELD ──
//
// DeliveryVerified (DLV) NÃO tem field `status` — o evento POR SI SÓ é o
// outcome approved; DeliveryRejected é evento separado. Canvas wording
// "INV consome APENAS DeliveryVerified com status=approved" significa
// SELECIONAR ENTRE EVENTOS (consumir mesh.dlv.delivery-verified.v1; ignorar
// mesh.dlv.delivery-rejected.v1). DeliveryVerifiedReceived NÃO carrega
// status field — seria phantom.
//
// Refs cross-BC opaque por design — INV não importa semântica de DLV/CMT.

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

// ── DecimalString + Money (inline per def-025; ver header sobre divergência vs CMT) ──
//
// #DecimalString: arbitrary-precision decimal serializado como string JSON-safe.
// Não-negativo por construção do regex (sem `-?`). Amounts negativos, se
// existirem em outro contexto (credit note, adjustment, compensation), são
// modelados como eventos próprios, NÃO como Money negativo silencioso.

#DecimalString: string & =~"^[0-9]+(\\.[0-9]+)?$"

#Money: {
	amount:   #DecimalString
	currency: string & =~"^[A-Z]{3}$"
}

// ── Opaque refs cross-BC (owners listados) ──

#CommitmentRef:    string & !=""  // owned by CMT
#EvidenceRef:      string & !=""  // owned by DLV
#CriteriaVersion:  string & !=""  // owned by DLV
#ParticipantId:    string & !=""  // owned by NPM (não consumido por INV neste WI; reservado)

// ── Value-objects locais do INV (espelham domain-model.cue) ──

#InvoiceId:              string & !=""
#ReceivableId:           string & !=""
#RegimeVersion:          string & !=""
#FiscalDocRef:           string & !=""
#FiscalCancellationRef:  string & !=""
#ReasonCode:             string & !=""  // string (não enum); taxonomia em policy/regime/adapter, não domain core

// ── CommitmentScope (espelho mínimo do shape CMT para CommitmentAcceptedReceived) ──
//
// Espelha contexts/cmt/schemas/events.cue#CommitmentScope. NÃO importa de CMT
// para evitar acoplamento ao package cmt; manter alinhamento via revisita
// manual quando CMT mudar (gap consciente — alternativa seria promover
// CommitmentScope para shared-schemas, decisão fora do escopo deste WI).

#CommitmentScope: {
	description: string & !=""
	value:       #Money
	end:         string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
}

// ──────── Events (PUBLISHED) ────────
//
// Cada evento estende #Envelope com `type` literal e `data` concretamente
// tipado. A publicação cross-BC é governada por
// strategic/context-map.cue, não por presença/ausência do payload aqui.

// evt-invoice-issued
#InvoiceIssued: #Envelope & {
	type: "mesh.inv.invoice-issued.v1"
	data: {
		invoiceId:     #InvoiceId
		commitmentRef: #CommitmentRef
		evidenceRef:   #EvidenceRef
		amount:        #Money
		regimeVersion: #RegimeVersion
		fiscalDocRef:  #FiscalDocRef
		// Semantic timestamp — ver header TODO/domain-gap (não é contrato
		// canônico ainda; mirror operacional para replay/audit fiscal).
		issuedAt: #RFC3339Timestamp
	}
}

// evt-receivable-materialized
#ReceivableMaterialized: #Envelope & {
	type: "mesh.inv.receivable-materialized.v1"
	data: {
		receivableId:  #ReceivableId
		invoiceId:     #InvoiceId
		commitmentRef: #CommitmentRef
		amount:        #Money
		// Semantic timestamp — ver header TODO/domain-gap.
		materializedAt: #RFC3339Timestamp
	}
}

// evt-invoice-cancelled
#InvoiceCancelled: #Envelope & {
	type: "mesh.inv.invoice-cancelled.v1"
	data: {
		invoiceId:             #InvoiceId
		fiscalCancellationRef: #FiscalCancellationRef
		reasonCode:            #ReasonCode
		// Semantic timestamp — ver header TODO/domain-gap.
		cancelledAt: #RFC3339Timestamp
	}
}

// ──────── Events (RECEIVED — typed views locais pós-ACL) ────────
//
// Per WI-129 pattern (CMT). source mesh://contexts/inv (INV é quem está
// projetando essa view localmente); types mesh.inv.<event-name>-received.v1.
// Filtros severos per canvas.communication.inbound do INV.

// evt-delivery-verified-received
//
// Canvas: INV preserva (commitmentRef, evidenceRef, criteriaVersion) do
// DLV.DeliveryVerified original; descarta decidedAt, finalityAt, decidedBy,
// integrityProofRef, supersededByRef, eventLogOffset (DLV-internal
// telemetry/integrity — BD10 anti-mini-NIM). Trigger de consumo é canal-
// level: INV subscribe mesh.dlv.delivery-verified.v1; ignora
// mesh.dlv.delivery-rejected.v1 e supersession events.
#DeliveryVerifiedReceived: #Envelope & {
	type: "mesh.inv.delivery-verified-received.v1"
	data: {
		commitmentRef:   #CommitmentRef
		evidenceRef:     #EvidenceRef
		criteriaVersion: #CriteriaVersion
	}
}

// evt-commitment-accepted-received
//
// Canvas: INV usa terms canônicos pós-aceite bilateral (amount/currency
// para cômputo Money; identifier commitmentRef). Preservados: commitmentRef
// (= commitmentId no CMT), scope (description + value Money + end date),
// acceptedAt. Filtrados: parties (NPM concern, não usado por domain INV
// per domain-model), contractTermsRef (CTR concern — gap entre domain-model
// e canvas; sigo domain-model). dueDate/taxRegimeRef que canvas menciona
// NÃO existem em CMT.CommitmentAccepted original — não inventados aqui.
#CommitmentAcceptedReceived: #Envelope & {
	type: "mesh.inv.commitment-accepted-received.v1"
	data: {
		commitmentRef: #CommitmentRef
		scope:         #CommitmentScope
		acceptedAt:    #RFC3339Timestamp
	}
}
