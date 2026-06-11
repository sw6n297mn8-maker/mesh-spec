package work_events

// wi-135.cue — Backfill retroativo do lifecycle de WI-135.
//
// WI-135 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Output: contexts/cmt/port-manifest.cue (pm-cmt; commit 48dc24c).
streams: "WI-135": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-135"
	taskVersion: 1
	commandId:   "WI-135-propose-pm-cmt-eventlogport-backfill"
	timestamp:   "2026-06-08T18:50:57Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-135"
		taskVersion: 1
		commandId:   "WI-135-approve-pm-cmt-eventlogport-backfill"
		timestamp:   "2026-06-08T18:50:57Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-135"
		taskVersion:    1
		commandId:      "WI-135-claim-pm-cmt-eventlogport-backfill"
		timestamp:      "2026-06-08T18:50:57Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-09T02:50:57Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-135"
		taskVersion: 1
		commandId:   "WI-135-complete-pm-cmt-eventlogport-backfill"
		timestamp:   "2026-06-08T18:50:57Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-135-completion-backfill-20260611"
			artifactSnapshotHash: "9a9afe55d7aea7c7610e26e1437250034caf3802"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
