package work_events

streams: {
	"WI-024": {
		taskId: "WI-024"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-024"
			taskVersion: 1
			commandId:   "WI-024-propose-agent-spec-cmt"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-024"
			taskVersion: 1
			commandId:   "WI-024-approve-agent-spec-cmt"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-024"
			taskVersion:    1
			commandId:      "WI-024-claim-agent-spec-cmt"
			timestamp:      "2026-04-05T23:45:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T07:45:00Z"
		}, {
			eventType:            "task-completed"
			taskId:               "WI-024"
			taskVersion:          1
			commandId:            "WI-024-complete-agent-spec-cmt"
			timestamp:            "2026-04-06T01:30:00Z"
			actor:                "spec-writer"
			validationRunId:      "WI-024-validation-20260406"
			artifactSnapshotHash: "cmt:ff5c252"
			gatesPassed: ["cue-vet", "self-review-stable", "founder-approved"]
		}]
	}
}
