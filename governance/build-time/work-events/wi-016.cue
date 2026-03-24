package work_events

streams: {
	"WI-016": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-016"
			taskVersion: 1
			commandId:   "WI-016-propose-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-016"
			taskVersion: 1
			commandId:   "WI-016-approve-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-016"
			taskVersion:    1
			commandId:      "WI-016-claim-20260322"
			timestamp:      "2026-03-22T12:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-22T16:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-016"
			taskVersion: 1
			commandId:   "WI-016-complete-20260322"
			timestamp:   "2026-03-22T12:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-016-validation-20260322"
				artifactSnapshotHash: "3872cc12e17da3c8ad15c21b1baceee185989ada"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
