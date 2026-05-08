package work_events

streams: {
	"WI-070": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-070"
			taskVersion: 1
			commandId:   "WI-070-propose-economic-foundation"
			timestamp:   "2026-05-07T20:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-070"
			taskVersion: 1
			commandId:   "WI-070-approve-economic-foundation"
			timestamp:   "2026-05-07T20:00:30Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-070"
			taskVersion:    1
			commandId:      "WI-070-claim-economic-foundation"
			timestamp:      "2026-05-07T20:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-15T20:01:00Z"
		}]
	}
}
