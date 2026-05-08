package work_events

streams: {
	"WI-071": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-071"
			taskVersion: 1
			commandId:   "WI-071-propose-rebuild-projections-script"
			timestamp:   "2026-05-08T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-071"
			taskVersion: 1
			commandId:   "WI-071-approve-rebuild-projections-script"
			timestamp:   "2026-05-08T18:00:30Z"
			actor:       "founder"
		}]
	}
}
