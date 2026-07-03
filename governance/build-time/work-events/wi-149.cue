package work_events

// wi-149.cue — Lifecycle event-sourced de WI-149 (async-api.yaml do FCE:
// superfície assíncrona publicada — 2 channels publish-only no molde
// CMT/DLV/INV, sob def-023; degrau async do oq-fce-1 item c, gatilho
// browser-live disparado per decisão do founder na sessão 2026-07-03).
//
// NÃO é backfill: WI-149 foi proposto (pre-flight read-only S1 + self-review
// 2 rounds com painel adversarial de 5 verificadores), aprovado (decisão do
// arquiteto no chat: adendo mesh-old confirmando o PR do S1), claimado e
// completado na mesma sessão (2026-07-03). commandIds SEM sufixo "-backfill"
// (execução live). Timestamps na granularidade da sessão — mesma honestidade
// declarada em work-events/_constraints.cue. artifactSnapshotHash = git blob
// hash de contexts/fce/async-api.yaml (output canônico) no conteúdo
// committado. gatesPassed reflete o verificável nesta sessão (cue vet +
// self-review round 1-2 estável); structural-checks rodam pós-commit
// (sc-cv-03 do FCE passa a satisfeito).
streams: "WI-149": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-149"
	taskVersion: 1
	commandId:   "WI-149-propose-fce-async-api"
	timestamp:   "2026-07-03T20:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-149"
	taskVersion: 1
	commandId:   "WI-149-approve-fce-async-api"
	timestamp:   "2026-07-03T20:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-149"
	taskVersion:    1
	commandId:      "WI-149-claim-fce-async-api"
	timestamp:      "2026-07-03T20:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-04T04:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-149"
	taskVersion: 1
	commandId:   "WI-149-complete-fce-async-api"
	timestamp:   "2026-07-03T20:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-149-completion-20260703"
		artifactSnapshotHash: "1f2a1e685cc1bcd0dd923e6d95354f72682c4a9a"
		gatesPassed: ["cue-vet", "self-review"]
	}
}]
