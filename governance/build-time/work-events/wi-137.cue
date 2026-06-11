package work_events

// wi-137.cue — Backfill retroativo do lifecycle de WI-137.
//
// WI-137 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Nota de escopo (wave-plan): completed = LADO-SPEC (ge + #Assertion + harness
// + evidence-pending; commit 6caa446). A execucao viva (run-001, gate CONTINUAR,
// 17/17) e downstream e vive em codegen-validation-evidence (#126) — nao altera
// este evento. snapshotHash = blob de bd-mutual-acceptance.cue.
streams: "WI-137": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-137"
	taskVersion: 1
	commandId:   "WI-137-propose-golden-example-cmt-backfill"
	timestamp:   "2026-06-09T13:57:55Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-137"
		taskVersion: 1
		commandId:   "WI-137-approve-golden-example-cmt-backfill"
		timestamp:   "2026-06-09T13:57:55Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-137"
		taskVersion:    1
		commandId:      "WI-137-claim-golden-example-cmt-backfill"
		timestamp:      "2026-06-09T13:57:55Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-09T21:57:55Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-137"
		taskVersion: 1
		commandId:   "WI-137-complete-golden-example-cmt-backfill"
		timestamp:   "2026-06-09T13:57:55Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-137-completion-backfill-20260611"
			artifactSnapshotHash: "e472d61a461062b52b8dea711f2b1655eaa502e2"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
