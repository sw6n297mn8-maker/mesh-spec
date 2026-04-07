package work_events

streams: {
	"WI-065": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-065"
			taskVersion: 1
			commandId:   "WI-065-propose-claude-md-generator"
			timestamp:   "2026-04-07T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-065"
			taskVersion: 1
			commandId:   "WI-065-approve-claude-md-generator"
			timestamp:   "2026-04-07T12:01:00Z"
			actor:       "founder"
		}]
	}
}
