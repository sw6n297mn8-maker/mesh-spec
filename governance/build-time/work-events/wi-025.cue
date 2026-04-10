package work_events

streams: {
	"WI-025": {
		taskId: "WI-025"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-025"
			taskVersion: 1
			commandId:   "WI-025-propose-domain-model-cmt"
			timestamp:   "2026-04-05T20:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-025"
			taskVersion: 1
			commandId:   "WI-025-approve-domain-model-cmt"
			timestamp:   "2026-04-05T20:05:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-025"
			taskVersion:    1
			commandId:      "WI-025-claim-domain-model-cmt"
			timestamp:      "2026-04-05T20:06:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T04:06:00Z"
		}, {
			eventType:            "task-completed"
			taskId:               "WI-025"
			taskVersion:          1
			commandId:            "WI-025-complete-domain-model-cmt"
			timestamp:            "2026-04-05T23:30:00Z"
			actor:                "spec-writer"
			validationRunId:      "WI-025-validation-20260405"
			artifactSnapshotHash: "cmt:be7414c"
			gatesPassed: ["cue-vet", "self-review-4-rounds-stable-at-2", "founder-approved"]
		}]
	}
}
