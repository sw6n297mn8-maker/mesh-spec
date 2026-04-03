package work_events

streams: {
	"WI-026": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-026"
			taskVersion: 1
			commandId:   "WI-026-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-026"
			taskVersion: 1
			commandId:   "WI-026-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}]
	}
}
