package work_events

// wi-103.cue — Backfill retroativo do lifecycle de WI-103.
//
// WI-103 foi executado via fluxo direto founder<->agente (PRs), sem stream de
// work-events a epoca. Backfill per convencao work-events/_constraints.cue
// (precedente wi-131): timestamps de proposed/approved/claimed/completed
// derivados do commit que produziu o output (dados granulares nao existem);
// commandIds com sufixo "-backfill"; artifactSnapshotHash = git blob hash do
// output principal no commit de conclusao; gatesPassed = verificavel
// retroativamente (CI completo no PR de merge).
// PATH-DRIFT registrado (correcao de borda 1): os 5 deferred-decisions sairam
// materializados como def-041..045-*-vendor-of-record.cue, divergindo do path
// planejado no wave-plan (def-041-eventlogport-vendor.cue etc.). Outputs REAIS
// verificados no disco; correcao do plano (paths planejados) = Nivel 2.
// snapshotHash = blob do adr-141 no commit de conclusao (cc4c2bf).
streams: "WI-103": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-103"
	taskVersion: 1
	commandId:   "WI-103-propose-adr-141-runtime-kernel-backfill"
	timestamp:   "2026-06-05T16:09:38Z"
	actor:       "founder"
},
	{
		eventType:   "task-approved"
		taskId:      "WI-103"
		taskVersion: 1
		commandId:   "WI-103-approve-adr-141-runtime-kernel-backfill"
		timestamp:   "2026-06-05T16:09:38Z"
		actor:       "founder"
	},
	{
		eventType:      "task-claimed"
		taskId:         "WI-103"
		taskVersion:    1
		commandId:      "WI-103-claim-adr-141-runtime-kernel-backfill"
		timestamp:      "2026-06-05T16:09:38Z"
		actor:          "spec-writer"
		claimExpiresAt: "2026-06-06T00:09:38Z"
	},
	{
		eventType:   "task-completed"
		taskId:      "WI-103"
		taskVersion: 1
		commandId:   "WI-103-complete-adr-141-runtime-kernel-backfill"
		timestamp:   "2026-06-05T16:09:38Z"
		actor:       "spec-writer"
		completionValidation: {
			validationRunId:      "WI-103-completion-backfill-20260611"
			artifactSnapshotHash: "5529682dbe39a727e5e8641470791363953f17fc"
			gatesPassed: ["cue-vet", "self-review-enforcement", "structural-check"]
		}
	}]
