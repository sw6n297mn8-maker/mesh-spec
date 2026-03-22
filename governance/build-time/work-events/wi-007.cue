package work_events

streams: {
	"WI-007": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-007"
			taskVersion: 1
			commandId:   "WI-007-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-007"
			taskVersion: 1
			commandId:   "WI-007-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}]
	}
}
