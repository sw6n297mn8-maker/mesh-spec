package work_events

streams: {
	"WI-001": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-001"
			taskVersion: 1
			commandId:   "WI-001-propose-backfill"
			timestamp:   "2026-03-18T18:36:06Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-001"
			taskVersion: 1
			commandId:   "WI-001-approve-backfill"
			timestamp:   "2026-03-18T18:36:06Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-001"
			taskVersion:    1
			commandId:      "WI-001-claim-backfill"
			timestamp:      "2026-03-18T18:36:06Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-19T02:36:06Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-001"
			taskVersion: 1
			commandId:   "WI-001-complete-backfill"
			timestamp:   "2026-03-18T18:36:06Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-001"
				artifactSnapshotHash: "d58f9e8c710fdf4e85511ae1c2b879c39bdc943c"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
