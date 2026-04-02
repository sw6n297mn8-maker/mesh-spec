package work_events

streams: {
	"WI-031": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-031"
			taskVersion: 1
			commandId:   "WI-031-propose"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-031"
			taskVersion: 1
			commandId:   "WI-031-approve"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "founder"
		}]
	}
}
