package work_events

streams: {
	"WI-029": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-029"
			taskVersion: 1
			commandId:   "WI-029-propose"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-029"
			taskVersion: 1
			commandId:   "WI-029-approve"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-029"
			taskVersion: 1
			commandId:   "WI-029-complete"
			timestamp:   "2026-04-02T14:00:00Z"
			actor:       "spec-writer"
		}]
	}
}
