package npm

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas dos 7 eventos do agg-participant
// (fatia M7/adr-193: a superfície do npm que a ds-buyer-procurement-journey
// exige — o fornecedor qualificado que sustenta o pool do ssc; molde
// ssc/p2p, classe instanciação — precedente eea3c4d/PR #247).
//
// COBERTURA COMPLETA DO AGGREGATE (único do BC): 5 published (lifecycle +
// registro) + 1 internal (workflow de documentação) + 1 internal ACL
// -received (idc). Espelha o pattern FCE/CMT/p2p/ssc: #Envelope
// consolidado (shared-schemas, def-022), eventos como #Envelope & {type,
// data}. source mesh://contexts/npm; types próprios mesh.npm.<kebab>.v1.
//
// TIMESTAMPS: #RFC3339Timestamp (shared) nos data.* de domínio.
//
// TRANSPARÊNCIA P14 — DERIVAÇÃO DECLARADA: o domain-model do npm NÃO
// declara `fields` nos seus events (diferente de ssc/p2p). Os payloads
// abaixo são o MÍNIMO derivado dos fields do agg-participant que cada
// transição/fato toca — cada campo carrega comentário apontando o field
// do agregado (ou a prosa canônica do próprio event) que o sustenta.
// Nenhum campo novo é inventado: o que o domínio não declara fica fora
// (ex.: motivo de suspensão — o agregado não o armazena e a prosa do
// event não o exige). O domain-type CadastralData NÃO tem shape fechado
// no domain-model (prosa: razão social, CNPJ, endereço, contato) — o
// espelho o representa ABERTO e não inventa estrutura (molde da nota
// 'outcome' do p2p). Selar payloads no domain-model é backlog do npm,
// não deste espelho.

// ── Aliases para shared_schemas ──
//
// ATENÇÃO: aliases são renomeio local — NÃO são ponto de extensão
// (disciplina de architecture/shared-schemas/envelope.cue).

#Envelope:         shared_schemas.#Envelope
#RFC3339Timestamp: shared_schemas.#RFC3339Timestamp

// ── Value-objects locais do NPM ──
#ParticipantId: string & !="" // vo-participant-id (root identity do agg-participant; gerado por NPM no registro; chave de lookup cross-BC)

// Estado do participante (vo-participant-status.state) — FECHADO com
// fidelidade: o VO fecha via constraint declarada
// ("state ∈ {pending, qualified, suspended, terminated}"), então o
// schema fecha junto (P14; mesmo padrão do #DecisionType do ssc).
#ParticipantState: "pending" | "qualified" | "suspended" | "terminated"

// Dados cadastrais (domain-type CadastralData) — ABERTO: o domain-model
// não declara shape (prosa do field: "razão social, CNPJ, endereço,
// contato"); o espelho não inventa (P14). Selar é backlog do
// domain-model do npm, não deste espelho.
#CadastralData: {...}

// Resultado da qualificação (vo-qualification-result) — os 3 fields
// declarados pelo VO no domain-model; imutável após produção.
#QualificationResult: {
	approved:      bool              // vo-qualification-result.approved — resultado binário
	justification: string            // vo-qualification-result.justification — documentada pelo supervisor
	decidedAt:     #RFC3339Timestamp // vo-qualification-result.decidedAt
}

// ════════════════════════════════════════════════════════════════════
// EVENTOS DO PARTICIPANT (7) — 5 published (lifecycle + registro) +
// 1 internal workflow + 1 internal ACL -received (idc)
// ════════════════════════════════════════════════════════════════════

// evt-participant-registered — participante nasce em pending (published;
// NGR/REW/NIM consomem). Derivação: participantId ← rootIdentity;
// legalIdentifier ← field do agregado (chave de negócio,
// inv-single-active-identity; completude exigida por
// inv-registration-completeness); cadastralData ← field do agregado;
// registeredAt ← currentStatus.since (a entrada em pending no registro
// é a primeira "transição" carimbada pelo VO de status).
#ParticipantRegistered: #Envelope & {
	type: "mesh.npm.participant-registered.v1"
	data: {
		participantId:   #ParticipantId
		legalIdentifier: string & !="" // agg-participant.legalIdentifier (esquema+valor; br-cnpj no Brasil per adr-173)
		cadastralData:   #CadastralData
		registeredAt:    #RFC3339Timestamp
	}
}

// evt-participant-qualified — transição pending→qualified via
// cmd-approve-qualification (published; o evento cross-context mais
// importante do NPM — habilita sourcing/contratos downstream).
// Derivação: qualificationResult ← agg-participant.lastQualificationResult
// (o field que esta transição escreve); qualifiedAt ← currentStatus.since.
#ParticipantQualified: #Envelope & {
	type: "mesh.npm.participant-qualified.v1"
	data: {
		participantId:       #ParticipantId
		qualificationResult: #QualificationResult
		qualifiedAt:         #RFC3339Timestamp
	}
}

// evt-participant-suspended — transição qualified→suspended (published;
// SSC remove do sourcing pool). Derivação: a transição toca apenas
// currentStatus — o agregado NÃO armazena motivo de suspensão e a prosa
// do event não declara payload adicional; o espelho não inventa (P14).
// suspendedAt ← currentStatus.since.
#ParticipantSuspended: #Envelope & {
	type: "mesh.npm.participant-suspended.v1"
	data: {
		participantId: #ParticipantId
		suspendedAt:   #RFC3339Timestamp
	}
}

// evt-participant-terminated — transição {pending|qualified|suspended}→
// terminated (published; irreversível — inv-termination-irreversible).
// Derivação: justification ← prosa canônica do PRÓPRIO event ("evento
// documenta decisão definitiva com justificativa para trail auditável";
// dp-10 exige justificativa documentada para decisão irreversível) —
// único campo sustentado por prosa do event, não por field do agregado;
// terminatedAt ← currentStatus.since.
#ParticipantTerminated: #Envelope & {
	type: "mesh.npm.participant-terminated.v1"
	data: {
		participantId: #ParticipantId
		justification: string & !="" // obrigatória per prosa do event + dp-10 (decisão irreversível documentada)
		terminatedAt:  #RFC3339Timestamp
	}
}

// evt-participant-reactivated — transição suspended→qualified (published;
// SSC reincorpora no pool). Derivação: a transição toca apenas
// currentStatus; reactivatedAt ← currentStatus.since.
#ParticipantReactivated: #Envelope & {
	type: "mesh.npm.participant-reactivated.v1"
	data: {
		participantId: #ParticipantId
		reactivatedAt: #RFC3339Timestamp
	}
}

// evt-qualification-documents-received — fato INTERNO de workflow
// (documentação KYC/AML recebida; sinaliza prontidão para verificação;
// não cruza fronteira). Derivação: o agregado NÃO armazena os documentos
// (nenhum field) e nenhum shape de documentação é declarado no
// domain-model — o espelho carrega o MÍNIMO: identidade + timestamp do
// fato (padrão dos espelhos ssc/p2p); a documentação em si fica fora
// (P14 — não inventa).
#QualificationDocumentsReceived: #Envelope & {
	type: "mesh.npm.qualification-documents-received.v1"
	data: {
		participantId: #ParticipantId
		receivedAt:    #RFC3339Timestamp
	}
}

// evt-identity-verification-received — tradução ACL de
// IdentityVerificationCompleted (idc; sufixo -received per convenção
// CMT/BDG/ssc). Eventos ACL -received não carregam actor (adr-182,
// critério tríplice). Derivação: verified ← agg-participant.
// identityVerified (a flag que cmd-record-identity-verification
// atualiza, pré-condição de inv-approval-requires-identity-verification;
// em divergência, a query a IDC prevalece — integração dual).
#IdentityVerificationReceived: #Envelope & {
	type: "mesh.npm.identity-verification-received.v1"
	data: {
		participantId: #ParticipantId
		verified:      bool
		receivedAt:    #RFC3339Timestamp
	}
}
