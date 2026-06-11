package work_events

streams: {
	"WI-062": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-062"
			taskVersion: 1
			commandId:   "WI-062-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-062"
			taskVersion: 1
			commandId:   "WI-062-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}, // ── Backfill 2026-06-11 (claimed+completed; append-only, eventos acima intactos) ──
			// Outputs verificados no disco (contexts/bkr/canvas.cue e demais do wave-plan). O historico
			// git atual foi truncado em c64e470 (2026-05-28): o commit real de execucao nao e
			// recuperavel; timestamps derivam do commit mais antigo do historico atual que JA
			// CONTEM os outputs (per _constraints.cue: backfill usa o verificavel; data real de
			// execucao anterior nao capturada). gatesPassed = minimo verificavel (cue-vet).
			{
				eventType:      "task-claimed"
				taskId:         "WI-062"
				taskVersion:    1
				commandId:      "WI-062-claim-bc-bootstrap-bkr-backfill"
				timestamp:      "2026-05-28T18:34:30Z"
				actor:          "spec-writer"
				claimExpiresAt: "2026-05-29T02:34:30Z"
			}, {
				eventType:   "task-completed"
				taskId:      "WI-062"
				taskVersion: 1
				commandId:   "WI-062-complete-bc-bootstrap-bkr-backfill"
				timestamp:   "2026-05-28T18:34:30Z"
				actor:       "spec-writer"
				completionValidation: {
					validationRunId:      "WI-062-completion-backfill-20260611"
					artifactSnapshotHash: "0d78d0e1c900c4b2f3fbdb397f8db37c4e2c04a0"
					gatesPassed: ["cue-vet"]
				}
			}]
	}
}
