package work_events

streams: {
	"WI-008": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-008"
			taskVersion: 1
			commandId:   "WI-008-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-008"
			taskVersion: 1
			commandId:   "WI-008-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}]
	}
}
