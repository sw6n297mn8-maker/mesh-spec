package work_events

streams: {
	"WI-041": {
		taskId: "WI-041"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-041"
			taskVersion: 1
			commandId:   "WI-041-propose-adversarial-vectors"
			timestamp:   "2026-04-05T23:45:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-041"
			taskVersion: 1
			commandId:   "WI-041-approve-adversarial-vectors"
			timestamp:   "2026-04-06T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-041"
			taskVersion:    1
			commandId:      "WI-041-claim-adversarial-vectors"
			timestamp:      "2026-04-06T00:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T08:01:00Z"
		}, {
			eventType:            "task-completed"
			taskId:               "WI-041"
			taskVersion:          1
			commandId:            "WI-041-complete-adversarial-vectors"
			timestamp:            "2026-04-06T00:30:00Z"
			actor:                "spec-writer"
			validationRunId:      "WI-041-validation-20260405"
			artifactSnapshotHash: "cmt:1fb34258ae13b462a3d927ef44d1e85750398345,ctr:4da818c543d6877f0358e7be7d85e06cabd63c70"
			gatesPassed: ["cue-vet", "red-team-3-rounds", "semantic-validation-cmt-5-checks-0-fail", "semantic-validation-ctr-5-checks-0-fail", "founder-approved"]
		}]
	}
}
