package work_events

streams: {
	"WI-009": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-009"
			taskVersion: 1
			commandId:   "WI-009-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-009"
			taskVersion: 1
			commandId:   "WI-009-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-009"
			taskVersion: 1
			commandId:   "WI-009-complete-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}]
	}
}
