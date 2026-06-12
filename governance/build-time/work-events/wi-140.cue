package work_events

// wi-140.cue -- Stream de WI-140 (trabalho VIVO; nao e backfill).
//
// Admissao e claim de 2026-06-11, timestamps reais desta data, commandIds SEM
// sufixo -backfill. O claim cobre a FATIA-2 (DLV: pm-dlv + am-verification,
// caminho N5(a) do adr-141); o WI permanece in-progress -- manifests dos
// demais BCs/aggregates pendentes.
//
// NOTA DE PRE-REGISTRO: a fatia-1 (contexts/cmt/aggregate-manifests/
// am-commitment.cue, commit ec0aadf / PR #124, 2026-06-10) foi executada via
// fluxo direto founder<->agente ANTES deste stream existir -- declarada no
// rationale do proprio artefato ("fatia cirurgica de WI-140 -- NAO conclui o
// WI"). Este stream nasce com a fatia-2; a fatia-1 fica registrada por esta
// nota (nao ha evento retroativo: o trabalho ja esta auditavel via PR #124).
streams: "WI-140": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-140"
	taskVersion: 1
	commandId:   "WI-140-propose-manifest-instances"
	timestamp:   "2026-06-11T19:09:28Z"
	actor:       "founder"
}, {
	eventType:   "task-approved"
	taskId:      "WI-140"
	taskVersion: 1
	commandId:   "WI-140-approve-manifest-instances"
	timestamp:   "2026-06-11T19:09:28Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-140"
	taskVersion:    1
	commandId:      "WI-140-claim-fatia2-dlv"
	timestamp:      "2026-06-11T19:09:28Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-06-12T03:09:28Z"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-140"
	taskVersion:    1
	commandId:      "WI-140-claim-fatia-fce"
	timestamp:      "2026-06-12T17:12:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-06-13T01:12:00Z"
}]
