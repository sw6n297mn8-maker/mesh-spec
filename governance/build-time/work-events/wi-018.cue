package work_events

streams: {
	"WI-018": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-018"
			taskVersion: 1
			commandId:   "WI-018-propose-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-018"
			taskVersion: 1
			commandId:   "WI-018-approve-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-018"
			taskVersion:    1
			commandId:      "WI-018-claim-20260322"
			timestamp:      "2026-03-22T13:30:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-22T21:30:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-018"
			taskVersion: 1
			commandId:   "WI-018-complete-20260322"
			timestamp:   "2026-03-22T13:30:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-018-validation-20260322"
				artifactSnapshotHash: "pending-commit"
				gatesPassed:          ["cue-vet", "self-review", "adr-coevolution"]
			}
		}]
	}
}
