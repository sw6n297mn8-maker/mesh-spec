package work_events

streams: {
	"WI-023": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-023"
			taskVersion: 1
			commandId:   "WI-023-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-023"
			taskVersion: 1
			commandId:   "WI-023-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}]
	}
}
