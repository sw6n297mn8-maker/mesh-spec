package work_events

streams: {
	"WI-004": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-004"
			taskVersion: 1
			commandId:   "WI-004-propose-backfill"
			timestamp:   "2026-03-17T14:19:49Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-004"
			taskVersion: 1
			commandId:   "WI-004-approve-backfill"
			timestamp:   "2026-03-17T14:19:49Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-004"
			taskVersion:    1
			commandId:      "WI-004-claim-backfill"
			timestamp:      "2026-03-17T14:19:49Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-17T18:19:49Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-004"
			taskVersion: 1
			commandId:   "WI-004-complete-backfill"
			timestamp:   "2026-03-17T14:19:49Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-004"
				artifactSnapshotHash: "7fac4e973a7570839aaef81928b7d36626f542ab"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
