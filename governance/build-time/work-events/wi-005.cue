package work_events

streams: {
	"WI-005": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-005"
			taskVersion: 1
			commandId:   "WI-005-propose-backfill"
			timestamp:   "2026-03-15T17:22:40Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-005"
			taskVersion: 1
			commandId:   "WI-005-approve-backfill"
			timestamp:   "2026-03-15T17:22:40Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-005"
			taskVersion:    1
			commandId:      "WI-005-claim-backfill"
			timestamp:      "2026-03-15T17:22:40Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-16T17:22:40Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-005"
			taskVersion: 1
			commandId:   "WI-005-complete-backfill"
			timestamp:   "2026-03-15T17:22:40Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-005"
				artifactSnapshotHash: "2f12b682a50df02c9533c7850bf3517964bb5ce6"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
