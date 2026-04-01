package work_events

streams: {
	"WI-027": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-027"
			taskVersion: 1
			commandId:   "WI-027-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-027"
			taskVersion: 1
			commandId:   "WI-027-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}]
	}
}
