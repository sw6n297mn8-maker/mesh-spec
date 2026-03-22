package work_events

streams: {
	"WI-015": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-015"
			taskVersion: 1
			commandId:   "WI-015-propose-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-015"
			taskVersion: 1
			commandId:   "WI-015-approve-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "founder"
		}]
	}
}
