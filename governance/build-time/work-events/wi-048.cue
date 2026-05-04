package work_events

streams: {
	"WI-048": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-048"
			taskVersion: 1
			commandId:   "WI-048-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-048"
			taskVersion: 1
			commandId:   "WI-048-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-048"
			taskVersion:    1
			commandId:      "WI-048-claim-20260504"
			timestamp:      "2026-05-04T00:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-05T00:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-048"
			taskVersion: 1
			commandId:   "WI-048-complete-20260504"
			timestamp:   "2026-05-04T00:00:01Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-048-validation-20260504"
				artifactSnapshotHash: "91951f703f35c6dea11a16b921c92b8e3167e3cd"
				gatesPassed:          ["cue-vet", "self-review"]
			}
		}]
	}
}
