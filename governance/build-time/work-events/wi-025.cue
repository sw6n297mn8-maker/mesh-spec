package work_events

streams: {
	"WI-025": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-025"
			taskVersion: 1
			commandId:   "WI-025-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-025"
			taskVersion: 1
			commandId:   "WI-025-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}]
	}
}
