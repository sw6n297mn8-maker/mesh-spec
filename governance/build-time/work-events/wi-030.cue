package work_events

streams: {
	"WI-030": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-030"
			taskVersion: 1
			commandId:   "WI-030-propose"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-030"
			taskVersion: 1
			commandId:   "WI-030-approve"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "founder"
		}]
	}
}
