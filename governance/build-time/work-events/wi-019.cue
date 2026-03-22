package work_events

streams: {
	"WI-019": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-019"
			taskVersion: 1
			commandId:   "WI-019-propose-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-019"
			taskVersion: 1
			commandId:   "WI-019-approve-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-019"
			taskVersion:    1
			commandId:      "WI-019-claim-20260322"
			timestamp:      "2026-03-22T14:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-22T22:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-019"
			taskVersion: 1
			commandId:   "WI-019-complete-20260322"
			timestamp:   "2026-03-22T14:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-019-validation-20260322"
				artifactSnapshotHash: "9c77aeb8dd3a8039686ce39ead4276bc90133faa"
				gatesPassed:          ["cue-vet", "self-review", "adr-coevolution"]
			}
		}]
	}
}
