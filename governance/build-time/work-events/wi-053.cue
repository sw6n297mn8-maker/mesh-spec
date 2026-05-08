package work_events

streams: {
	"WI-053": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-053"
			taskVersion: 1
			commandId:   "WI-053-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-053"
			taskVersion: 1
			commandId:   "WI-053-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-053"
			taskVersion:    1
			commandId:      "WI-053-claim-20260506"
			timestamp:      "2026-05-06T19:30:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-07T19:30:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-053"
			taskVersion: 1
			commandId:   "WI-053-complete-bc-bootstrap"
			timestamp:   "2026-05-08T17:04:10Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-053-completion-20260508"
				artifactSnapshotHash: "4c4b5be"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
