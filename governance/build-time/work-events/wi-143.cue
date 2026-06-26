package work_events

// wi-143.cue — Lifecycle event-sourced de WI-143 (superfície de leitura do
// FCE: contexts/fce/api.yaml query-only + reconciliação do enum da
// query-surface do canvas com o lifecycle materializado, adr-155).
//
// NÃO é backfill: WI-143 foi proposto, aprovado, claimado e completado na
// mesma sessão (2026-06-26), com o recorte aprovado pelo founder no chat.
// commandIds SEM sufixo "-backfill" (execução live, não reconstruída do git).
// Timestamps na granularidade da sessão (2026-06-26) — wall-clock fino não
// capturado; mesma honestidade declarada em work-events/_constraints.cue.
// artifactSnapshotHash = git blob hash de contexts/fce/api.yaml (output
// canônico criado) no conteúdo committado. gatesPassed reflete o
// verificável nesta sessão (cue vet + self-review round 1 estável); o
// structural-check roda pós-commit (gate determinístico do founder).
streams: "WI-143": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-143"
	taskVersion: 1
	commandId:   "WI-143-propose-fce-read-surface"
	timestamp:   "2026-06-26T12:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-143"
	taskVersion: 1
	commandId:   "WI-143-approve-fce-read-surface"
	timestamp:   "2026-06-26T12:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-143"
	taskVersion:    1
	commandId:      "WI-143-claim-fce-read-surface"
	timestamp:      "2026-06-26T12:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-06-26T20:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-143"
	taskVersion: 1
	commandId:   "WI-143-complete-fce-read-surface"
	timestamp:   "2026-06-26T12:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-143-completion-20260626"
		artifactSnapshotHash: "0332741c8d01b2ceb24acf2868c1182cb8415249"
		gatesPassed: ["cue-vet", "self-review"]
	}
}]
