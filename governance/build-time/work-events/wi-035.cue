package work_events

streams: {
	"WI-035": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-035"
			taskVersion: 1
			commandId:   "WI-035-propose"
			timestamp:   "2026-04-02T21:01:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-035"
			taskVersion: 1
			commandId:   "WI-035-approve"
			timestamp:   "2026-04-02T21:10:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-claimed"
			taskId:      "WI-035"
			taskVersion: 1
			commandId:   "WI-035-claim"
			timestamp:   "2026-04-06T22:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-035"
			taskVersion: 1
			commandId:   "WI-035-complete"
			timestamp:   "2026-04-06T22:10:00Z"
			actor:       "spec-writer"
		}]
	}
}
