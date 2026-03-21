package work_events

streams: {
	"WI-013": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-013"
			taskVersion: 1
			commandId:   "WI-013-propose-backfill"
			timestamp:   "2026-03-20T13:49:27Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-013"
			taskVersion: 1
			commandId:   "WI-013-approve-backfill"
			timestamp:   "2026-03-20T13:49:27Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-013"
			taskVersion:    1
			commandId:      "WI-013-claim-backfill"
			timestamp:      "2026-03-20T13:49:27Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-20T17:49:27Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-013"
			taskVersion: 1
			commandId:   "WI-013-complete-backfill"
			timestamp:   "2026-03-20T13:49:27Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-013"
				artifactSnapshotHash: "baf73a51d48d9c23798c2e998ce9100f8215bb39"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
