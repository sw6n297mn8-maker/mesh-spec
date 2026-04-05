package work_events

streams: {
	"WI-034": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-034"
			taskVersion: 1
			commandId:   "WI-034-propose"
			timestamp:   "2026-04-02T21:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-034"
			taskVersion: 1
			commandId:   "WI-034-approve"
			timestamp:   "2026-04-02T21:10:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-cancelled"
			taskId:      "WI-034"
			taskVersion: 1
			commandId:   "WI-034-cancel-superseded"
			timestamp:   "2026-04-06T00:01:00Z"
			actor:       "spec-writer"
			reason:      "Superseded by WI-041 which covers CMT + CTR with expanded vector taxonomy (4 vectors vs 2)."
		}]
	}
}
