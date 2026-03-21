package work_events

streams: {
	"WI-002": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-002"
			taskVersion: 1
			commandId:   "WI-002-propose-backfill"
			timestamp:   "2026-03-07T19:37:14Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-002"
			taskVersion: 1
			commandId:   "WI-002-approve-backfill"
			timestamp:   "2026-03-07T19:37:14Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-002"
			taskVersion:    1
			commandId:      "WI-002-claim-backfill"
			timestamp:      "2026-03-07T19:37:14Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-08T19:37:14Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-002"
			taskVersion: 1
			commandId:   "WI-002-complete-backfill"
			timestamp:   "2026-03-07T19:37:14Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-002"
				artifactSnapshotHash: "a4d732d5caea7e5508f9672e3ec3ce02bea6f8fd"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
