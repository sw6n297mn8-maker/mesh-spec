package work_events

streams: {
	"WI-033": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-033"
			taskVersion: 1
			commandId:   "WI-033-propose"
			timestamp:   "2026-04-02T17:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-033"
			taskVersion: 1
			commandId:   "WI-033-approve"
			timestamp:   "2026-04-02T17:01:00Z"
			actor:       "founder"
		}, // ── Backfill 2026-06-11 (claimed+completed; append-only, eventos acima intactos) ──
			// Outputs verificados no disco (architecture/artifact-schemas/shared-types.cue e demais do wave-plan). O historico
			// git atual foi truncado em c64e470 (2026-05-28): o commit real de execucao nao e
			// recuperavel; timestamps derivam do commit mais antigo do historico atual que JA
			// CONTEM os outputs (per _constraints.cue: backfill usa o verificavel; data real de
			// execucao anterior nao capturada). gatesPassed = minimo verificavel (cue-vet).
			{
				eventType:      "task-claimed"
				taskId:         "WI-033"
				taskVersion:    1
				commandId:      "WI-033-claim-shared-types-backfill"
				timestamp:      "2026-05-28T18:34:30Z"
				actor:          "spec-writer"
				claimExpiresAt: "2026-05-29T02:34:30Z"
			}, {
				eventType:   "task-completed"
				taskId:      "WI-033"
				taskVersion: 1
				commandId:   "WI-033-complete-shared-types-backfill"
				timestamp:   "2026-05-28T18:34:30Z"
				actor:       "spec-writer"
				completionValidation: {
					validationRunId:      "WI-033-completion-backfill-20260611"
					artifactSnapshotHash: "c0bf85e1cc440954f9134075587b7e0cf973617c"
					gatesPassed: ["cue-vet"]
				}
			}]
	}
}
