package work_events

streams: {
	"WI-022": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-022"
			taskVersion: 1
			commandId:   "WI-022-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-022"
			taskVersion: 1
			commandId:   "WI-022-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-022"
			taskVersion: 1
			commandId:   "WI-022-complete"
			timestamp:   "2026-04-02T12:00:00Z"
			actor:       "spec-writer"
		}]
	}
}
