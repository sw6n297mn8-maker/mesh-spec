package work_events

streams: {
	"WI-011": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}]
	}
}
