package work_events

streams: {
	"WI-017": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-017"
			taskVersion: 1
			commandId:   "WI-017-propose-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-017"
			taskVersion: 1
			commandId:   "WI-017-approve-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-017"
			taskVersion:    1
			commandId:      "WI-017-claim-20260322"
			timestamp:      "2026-03-22T13:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-22T21:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-017"
			taskVersion: 1
			commandId:   "WI-017-complete-20260322"
			timestamp:   "2026-03-22T13:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-017-validation-20260322"
				artifactSnapshotHash: "3c7cbf10090518371d14f3289022bd131c71b3ef"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
