package work_events

streams: {
	"WI-028": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-028"
			taskVersion: 1
			commandId:   "WI-028-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-028"
			taskVersion: 1
			commandId:   "WI-028-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-028"
			taskVersion: 1
			commandId:   "WI-028-complete"
			timestamp:   "2026-04-02T00:00:00Z"
			actor:       "spec-writer"
		}]
	}
}
