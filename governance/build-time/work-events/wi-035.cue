package work_events

streams: {
	"WI-035": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-035"
			taskVersion: 1
			commandId:   "WI-035-propose"
			timestamp:   "2026-04-02T21:01:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-035"
			taskVersion: 1
			commandId:   "WI-035-approve"
			timestamp:   "2026-04-02T21:10:00Z"
			actor:       "founder"
		}]
	}
}
