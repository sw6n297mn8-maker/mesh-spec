package work_events

streams: {
	"WI-007": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-007"
			taskVersion: 1
			commandId:   "WI-007-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-007"
			taskVersion: 1
			commandId:   "WI-007-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-007"
			taskVersion:    1
			commandId:      "WI-007-claim-20260324"
			timestamp:      "2026-03-24T00:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-24T04:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-007"
			taskVersion: 1
			commandId:   "WI-007-complete-20260324"
			timestamp:   "2026-03-24T00:00:01Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-007-validation-20260324"
				artifactSnapshotHash: "866544ed744d7c0455749858e5684143bd821c92"
				gatesPassed:          ["cue-vet", "self-review"]
			}
		}]
	}
}
