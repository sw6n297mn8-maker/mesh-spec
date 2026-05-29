package work_events

// wi-130.cue — Backfill retroativo do lifecycle de WI-130 (superfícies de
// interação do BC DLV: events.cue + api.yaml + async-api.yaml).
//
// WI-130 foi admitido como task-spec no commit do PR #68 (2026-05-28) mas
// nunca teve stream de work-events nem nó no work-graph. Execução em 2 etapas:
// events.cue (PR #75) + api.yaml/async-api.yaml (PR #80, fecha os 3 outputs).
// Backfill reconstrói os eventos per a convenção em work-events/_constraints.cue:
// - proposed/approved/claimed derivados do commit de admissão (#68,
//   2026-05-28T12:44:54Z); sem dados granulares da proposta original.
// - completed = merge do último output (PR #80, fecha o WI).
// - commandIds com sufixo "-backfill".
// - artifactSnapshotHash = git blob hash de contexts/dlv/schemas/events.cue
//   no commit de conclusão.
// - gatesPassed reflete o verificável retroativamente (todos passaram em CI).
streams: "WI-130": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-130"
	taskVersion: 1
	commandId:   "WI-130-propose-dlv-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T12:44:54Z"
	actor:       "founder"
}, {
	eventType:   "task-approved"
	taskId:      "WI-130"
	taskVersion: 1
	commandId:   "WI-130-approve-dlv-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T12:44:54Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-130"
	taskVersion:    1
	commandId:      "WI-130-claim-20260528-backfill"
	timestamp:      "2026-05-28T12:44:54Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-05-28T20:44:54Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-130"
	taskVersion: 1
	commandId:   "WI-130-complete-dlv-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T19:58:50Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-130-completion-backfill-20260528"
		artifactSnapshotHash: "b984aac0a6b6f11d5abc702602022634c14ed3d4"
		gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
	}
}]
