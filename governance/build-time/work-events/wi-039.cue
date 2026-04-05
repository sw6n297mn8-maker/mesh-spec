package work_events

streams: {
	"WI-039": {
		taskId: "WI-039"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-039"
			taskVersion: 1
			commandId:   "WI-039-propose-canvas-revision"
			timestamp:   "2026-04-04T14:03:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-039"
			taskVersion: 1
			commandId:   "WI-039-approve-canvas-revision"
			timestamp:   "2026-04-05T23:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-039"
			taskVersion:    1
			commandId:      "WI-039-claim-canvas-revision"
			timestamp:      "2026-04-05T23:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T07:01:00Z"
		}]
	}
}
