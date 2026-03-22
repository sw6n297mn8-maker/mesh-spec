package work_events

streams: {
	"WI-006": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-006"
			taskVersion: 1
			commandId:   "WI-006-propose-backfill"
			timestamp:   "2026-03-08T18:56:09Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-006"
			taskVersion: 1
			commandId:   "WI-006-approve-backfill"
			timestamp:   "2026-03-08T18:56:09Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-006"
			taskVersion:    1
			commandId:      "WI-006-claim-backfill"
			timestamp:      "2026-03-08T18:56:09Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-09T18:56:09Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-006"
			taskVersion: 1
			commandId:   "WI-006-complete-backfill"
			timestamp:   "2026-03-08T18:56:09Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-006"
				artifactSnapshotHash: "64d12e1602a4a182c95eb9dc8ffeb6a802ab521a"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
