package work_events

streams: {
	"WI-011": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-011"
			taskVersion:    1
			commandId:      "WI-011-claim-20260325"
			timestamp:      "2026-03-25T00:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-25T04:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-complete-20260325"
			timestamp:   "2026-03-25T00:00:01Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-011-validation-20260325"
				artifactSnapshotHash: "c9eb86e914e0ea93fe9e70e93f358f1c759766e8"
				gatesPassed:          ["cue-vet", "self-review", "adr-coevolution"]
			}
		}]
	}
}
