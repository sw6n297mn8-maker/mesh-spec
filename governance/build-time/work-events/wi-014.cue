package work_events

streams: {
	"WI-014": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-014"
			taskVersion: 1
			commandId:   "WI-014-propose-backfill"
			timestamp:   "2026-03-18T13:19:53Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-014"
			taskVersion: 1
			commandId:   "WI-014-approve-backfill"
			timestamp:   "2026-03-18T13:19:53Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-014"
			taskVersion:    1
			commandId:      "WI-014-claim-backfill"
			timestamp:      "2026-03-18T13:19:53Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-18T21:19:53Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-014"
			taskVersion: 1
			commandId:   "WI-014-complete-backfill"
			timestamp:   "2026-03-18T13:19:53Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-014"
				artifactSnapshotHash: "49aeecf609d6371e9020130f097435682cdca8c2"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
