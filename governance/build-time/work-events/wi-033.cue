package work_events

streams: {
	"WI-033": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-033"
			taskVersion: 1
			commandId:   "WI-033-propose"
			timestamp:   "2026-04-02T17:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-033"
			taskVersion: 1
			commandId:   "WI-033-approve"
			timestamp:   "2026-04-02T17:01:00Z"
			actor:       "founder"
		}]
	}
}
