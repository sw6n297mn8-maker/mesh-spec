package work_events

// wi-134.cue — Backfill retroativo do lifecycle de WI-134.
//
// WI-134 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Output: governance/build-time/codegen-contract.cue (commit 60d82f3; V1
// proposed a epoca, promovido a accepted em run-001/#126 — fato posterior,
// fora deste evento).
streams: "WI-134": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-134"
	taskVersion: 1
	commandId:   "WI-134-propose-codegen-contract-backfill"
	timestamp:   "2026-06-08T17:32:28Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-134"
		taskVersion: 1
		commandId:   "WI-134-approve-codegen-contract-backfill"
		timestamp:   "2026-06-08T17:32:28Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-134"
		taskVersion:    1
		commandId:      "WI-134-claim-codegen-contract-backfill"
		timestamp:      "2026-06-08T17:32:28Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-09T01:32:28Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-134"
		taskVersion: 1
		commandId:   "WI-134-complete-codegen-contract-backfill"
		timestamp:   "2026-06-08T17:32:28Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-134-completion-backfill-20260611"
			artifactSnapshotHash: "776e005d415023bd31567c81c814798f2a199a86"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
