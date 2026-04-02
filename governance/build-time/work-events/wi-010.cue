package work_events

streams: {
	"WI-010": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-010"
			taskVersion: 1
			commandId:   "WI-010-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-010"
			taskVersion: 1
			commandId:   "WI-010-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-010"
			taskVersion: 1
			commandId:   "WI-010-complete"
			timestamp:   "2026-04-02T17:10:00Z"
			actor:       "spec-writer"
		}]
	}
}
