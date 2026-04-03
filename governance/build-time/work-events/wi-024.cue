package work_events

streams: {
	"WI-024": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-024"
			taskVersion: 1
			commandId:   "WI-024-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-024"
			taskVersion: 1
			commandId:   "WI-024-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}]
	}
}
