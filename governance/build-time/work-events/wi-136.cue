package work_events

// wi-136.cue — Backfill retroativo do lifecycle de WI-136.
//
// WI-136 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Outputs: schema #GoldenExample + production-guide (adr-145; commit 40fba2f).
// snapshotHash = blob do schema.
streams: "WI-136": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-136"
	taskVersion: 1
	commandId:   "WI-136-propose-golden-example-type-backfill"
	timestamp:   "2026-06-09T12:40:55Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-136"
		taskVersion: 1
		commandId:   "WI-136-approve-golden-example-type-backfill"
		timestamp:   "2026-06-09T12:40:55Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-136"
		taskVersion:    1
		commandId:      "WI-136-claim-golden-example-type-backfill"
		timestamp:      "2026-06-09T12:40:55Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-09T20:40:55Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-136"
		taskVersion: 1
		commandId:   "WI-136-complete-golden-example-type-backfill"
		timestamp:   "2026-06-09T12:40:55Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-136-completion-backfill-20260611"
			artifactSnapshotHash: "1ef2627e3e98a9bb36d00aad7fb35d41357090b0"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
