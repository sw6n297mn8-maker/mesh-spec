package work_events

streams: {
	"WI-057": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-057"
			taskVersion: 1
			commandId:   "WI-057-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-057"
			taskVersion: 1
			commandId:   "WI-057-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-057"
			taskVersion:    1
			commandId:      "WI-057-claim-20260505"
			timestamp:      "2026-05-05T17:30:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-06T17:30:00Z"
		}]
	}
}
