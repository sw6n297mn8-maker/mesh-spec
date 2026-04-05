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
		}]
	}
}
