package work_events

streams: {
	"WI-026": {
		taskId: "WI-026"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-026"
			taskVersion: 1
			commandId:   "WI-026-propose-canonical-path"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-026"
			taskVersion: 1
			commandId:   "WI-026-approve-canonical-path"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-026"
			taskVersion:    1
			commandId:      "WI-026-claim-canonical-path"
			timestamp:      "2026-04-06T02:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T10:00:00Z"
		}, {
			eventType:            "task-completed"
			taskId:               "WI-026"
			taskVersion:          1
			commandId:            "WI-026-complete-canonical-path"
			timestamp:            "2026-04-06T02:30:00Z"
			actor:                "spec-writer"
			validationRunId:      "WI-026-validation-20260406"
			artifactSnapshotHash: "context-map:ddb0ae7"
			gatesPassed: ["cue-vet", "self-review-stable", "founder-approved"]
		}]
	}
}
