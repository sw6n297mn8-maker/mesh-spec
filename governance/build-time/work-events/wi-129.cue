package work_events

// wi-129.cue — Backfill retroativo do lifecycle de WI-129 (superfícies de
// interação do BC CMT: events.cue + async-api.yaml + api.yaml).
//
// WI-129 foi admitido como task-spec no commit do PR #68 (2026-05-28) mas
// nunca teve stream de work-events nem nó no work-graph — execução (PRs
// #70/#72/#74) não deixou rastro no lifecycle event-sourced. Este backfill
// reconstrói os eventos a partir do git log per a convenção documentada em
// work-events/_constraints.cue:
// - proposed/approved/claimed derivados do commit de admissão (#68,
//   2026-05-28T12:44:54Z); não há dados granulares da proposta original.
// - completed = merge do último output (api.yaml, PR #74).
// - commandIds carregam sufixo "-backfill" para rastreabilidade.
// - artifactSnapshotHash = git blob hash de contexts/cmt/schemas/events.cue
//   no commit de conclusão (output canônico/source de schema).
// - gatesPassed reflete o verificável retroativamente (todos passaram em CI).
streams: "WI-129": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-129"
	taskVersion: 1
	commandId:   "WI-129-propose-cmt-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T12:44:54Z"
	actor:       "founder"
}, {
	eventType:   "task-approved"
	taskId:      "WI-129"
	taskVersion: 1
	commandId:   "WI-129-approve-cmt-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T12:44:54Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-129"
	taskVersion:    1
	commandId:      "WI-129-claim-20260528-backfill"
	timestamp:      "2026-05-28T12:44:54Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-05-28T20:44:54Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-129"
	taskVersion: 1
	commandId:   "WI-129-complete-cmt-interaction-surfaces-backfill"
	timestamp:   "2026-05-28T17:45:41Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-129-completion-backfill-20260528"
		artifactSnapshotHash: "f3a6218b2828b70c6accf254001a66a48dbc13b5"
		gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
	}
}]
