package work_events

streams: {
	"WI-042": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-042"
			taskVersion: 1
			commandId:   "WI-042-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-042"
			taskVersion: 1
			commandId:   "WI-042-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}]
	}
}
