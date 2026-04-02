package work_events

streams: {
	"WI-021": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-021"
			taskVersion: 1
			commandId:   "WI-021-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-021"
			taskVersion: 1
			commandId:   "WI-021-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-021"
			taskVersion: 1
			commandId:   "WI-021-complete-backfill"
			timestamp:   "2026-04-02T00:00:00Z"
			actor:       "spec-writer"
		}]
	}
}
