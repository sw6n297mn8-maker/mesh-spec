package work_events

// wi-133.cue — Backfill retroativo do lifecycle de WI-133.
//
// WI-133 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Output: architecture/shared-schemas/assertion-schema.cue (commit f93f1a9).
streams: "WI-133": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-133"
	taskVersion: 1
	commandId:   "WI-133-propose-assertion-schema-backfill"
	timestamp:   "2026-06-07T21:44:14Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-133"
		taskVersion: 1
		commandId:   "WI-133-approve-assertion-schema-backfill"
		timestamp:   "2026-06-07T21:44:14Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-133"
		taskVersion:    1
		commandId:      "WI-133-claim-assertion-schema-backfill"
		timestamp:      "2026-06-07T21:44:14Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-08T05:44:14Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-133"
		taskVersion: 1
		commandId:   "WI-133-complete-assertion-schema-backfill"
		timestamp:   "2026-06-07T21:44:14Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-133-completion-backfill-20260611"
			artifactSnapshotHash: "e29a3b56eed91a05eb3d3b52e24b6bac70bb3ae5"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
