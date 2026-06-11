package work_events

// wi-139.cue — Backfill retroativo do lifecycle de WI-139.
//
// WI-139 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// Satisfeito POR CONSTRUCAO: o PG do golden-example nasceu (40fba2f, junto de
// WI-136) ja com template-role (P3c), exemplar ge-cmt e criterio de
// generalizacao codificado (divergencia estrutural > 0 sem ADR = sinal N3),
// e foi provado em uso no run-001. dependsOn WI-137 nao foi respeitado na
// execucao original — backfill reflete realidade (_constraints.cue).
// snapshotHash = blob do production-guide no commit 40fba2f.
streams: "WI-139": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-139"
	taskVersion: 1
	commandId:   "WI-139-propose-template-generalization-backfill"
	timestamp:   "2026-06-09T12:40:55Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-139"
		taskVersion: 1
		commandId:   "WI-139-approve-template-generalization-backfill"
		timestamp:   "2026-06-09T12:40:55Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-139"
		taskVersion:    1
		commandId:      "WI-139-claim-template-generalization-backfill"
		timestamp:      "2026-06-09T12:40:55Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-09T20:40:55Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-139"
		taskVersion: 1
		commandId:   "WI-139-complete-template-generalization-backfill"
		timestamp:   "2026-06-09T12:40:55Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-139-completion-backfill-20260611"
			artifactSnapshotHash: "2b05c0b638e6285c88ac93d3882d278600c9eb5d"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
