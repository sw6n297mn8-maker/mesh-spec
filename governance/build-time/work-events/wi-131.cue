package work_events

// wi-131.cue — Backfill retroativo do lifecycle de WI-131 (superfícies de
// interação do BC INV: events.cue + async-api.yaml; sem api.yaml pois
// canvas declara hasSyncSurface=false).
//
// WI-131 foi admitido como task-spec no commit do PR #68 (2026-05-28) mas
// nunca teve stream de work-events nem nó no work-graph. Execução: PR #77.
// Backfill reconstrói os eventos per a convenção em work-events/_constraints.cue:
// - proposed/approved/claimed derivados do commit de admissão (#68,
//   2026-05-28T12:44:54Z); sem dados granulares da proposta original.
// - completed = merge do PR #77.
// - commandIds com sufixo "-backfill".
// - artifactSnapshotHash = git blob hash de contexts/inv/schemas/events.cue
//   no commit de conclusão.
// - gatesPassed reflete o verificável retroativamente (todos passaram em CI).
streams: "WI-131": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-131"
	taskVersion: 1
	commandId:   "WI-131-propose-inv-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T12:44:54Z"
	actor:       "founder"
}, {
	eventType:   "task-approved"
	taskId:      "WI-131"
	taskVersion: 1
	commandId:   "WI-131-approve-inv-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T12:44:54Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-131"
	taskVersion:    1
	commandId:      "WI-131-claim-20260528-backfill"
	timestamp:      "2026-05-28T12:44:54Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-05-28T20:44:54Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-131"
	taskVersion: 1
	commandId:   "WI-131-complete-inv-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T18:56:05Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-131-completion-backfill-20260528"
		artifactSnapshotHash: "73e52d92001e731740566b6b52cba1fafb6c305a"
		gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
	}
}]
