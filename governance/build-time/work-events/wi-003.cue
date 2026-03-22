package work_events

streams: {
	"WI-003": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-003"
			taskVersion: 1
			commandId:   "WI-003-propose-backfill"
			timestamp:   "2026-03-15T09:58:30Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-003"
			taskVersion: 1
			commandId:   "WI-003-approve-backfill"
			timestamp:   "2026-03-15T09:58:30Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-003"
			taskVersion:    1
			commandId:      "WI-003-claim-backfill"
			timestamp:      "2026-03-15T09:58:30Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-16T09:58:30Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-003"
			taskVersion: 1
			commandId:   "WI-003-complete-backfill"
			timestamp:   "2026-03-15T09:58:30Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "backfill-WI-003"
				artifactSnapshotHash: "caa05e5880df9a2b62d30dd534443d5edfb5ef13"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
