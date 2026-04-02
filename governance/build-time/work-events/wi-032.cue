package work_events

streams: {
	"WI-032": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-032"
			taskVersion: 1
			commandId:   "WI-032-propose"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-032"
			taskVersion: 1
			commandId:   "WI-032-approve"
			timestamp:   "2026-04-02T11:00:00Z"
			actor:       "founder"
		}]
	}
}
