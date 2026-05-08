package work_events

streams: {
	"WI-046": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-046"
			taskVersion: 1
			commandId:   "WI-046-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-046"
			taskVersion: 1
			commandId:   "WI-046-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-046"
			taskVersion:    1
			commandId:      "WI-046-claim-20260508"
			timestamp:      "2026-05-08T19:35:19Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-09T03:35:19Z"
		}]
	}
}
