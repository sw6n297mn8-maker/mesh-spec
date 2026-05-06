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
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-042"
			taskVersion:    1
			commandId:      "WI-042-claim-20260506"
			timestamp:      "2026-05-06T13:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-07T13:00:00Z"
		}]
	}
}
