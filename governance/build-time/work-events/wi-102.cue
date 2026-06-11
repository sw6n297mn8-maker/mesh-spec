package work_events

// wi-102.cue — Backfill retroativo do lifecycle de WI-102.
//
// WI-102 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Outputs: adr-140 + def-040 + def-049 (todos no disco). snapshotHash = blob do
// adr-140 no commit de conclusao (b436d26, PR #111).
streams: "WI-102": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-102"
	taskVersion: 1
	commandId:   "WI-102-propose-adr-140-codegen-contracts-backfill"
	timestamp:   "2026-06-04T19:05:20Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-102"
		taskVersion: 1
		commandId:   "WI-102-approve-adr-140-codegen-contracts-backfill"
		timestamp:   "2026-06-04T19:05:20Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-102"
		taskVersion:    1
		commandId:      "WI-102-claim-adr-140-codegen-contracts-backfill"
		timestamp:      "2026-06-04T19:05:20Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-05T03:05:20Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-102"
		taskVersion: 1
		commandId:   "WI-102-complete-adr-140-codegen-contracts-backfill"
		timestamp:   "2026-06-04T19:05:20Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-102-completion-backfill-20260611"
			artifactSnapshotHash: "a6ea0f68622a7498162992e542bd86b1e83e284b"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
