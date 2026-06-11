package work_events

streams: {
	"WI-027": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-027"
			taskVersion: 1
			commandId:   "WI-027-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-027"
			taskVersion: 1
			commandId:   "WI-027-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, // ── Backfill 2026-06-11 (claimed+completed; append-only, eventos acima intactos) ──
			// Outputs verificados no disco (architecture/conventions/api-spec-convention.cue e demais do wave-plan). O historico
			// git atual foi truncado em c64e470 (2026-05-28): o commit real de execucao nao e
			// recuperavel; timestamps derivam do commit mais antigo do historico atual que JA
			// CONTEM os outputs (per _constraints.cue: backfill usa o verificavel; data real de
			// execucao anterior nao capturada). gatesPassed = minimo verificavel (cue-vet).
			{
				eventType:      "task-claimed"
				taskId:         "WI-027"
				taskVersion:    1
				commandId:      "WI-027-claim-api-spec-convention-backfill"
				timestamp:      "2026-05-28T18:34:30Z"
				actor:          "spec-writer"
				claimExpiresAt: "2026-05-29T02:34:30Z"
			}, {
				eventType:   "task-completed"
				taskId:      "WI-027"
				taskVersion: 1
				commandId:   "WI-027-complete-api-spec-convention-backfill"
				timestamp:   "2026-05-28T18:34:30Z"
				actor:       "spec-writer"
				completionValidation: {
					validationRunId:      "WI-027-completion-backfill-20260611"
					artifactSnapshotHash: "11bbce10e7de7b8f843822c32d5c7706d457214c"
					gatesPassed: ["cue-vet"]
				}
			}]
	}
}
