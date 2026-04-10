package work_events

streams: {
	"WI-038": {
		taskId: "WI-038"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-038"
			taskVersion: 1
			commandId:   "WI-038-propose-context-map-v2"
			timestamp:   "2026-04-04T14:02:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-038"
			taskVersion: 1
			commandId:   "WI-038-approve-context-map-v2"
			timestamp:   "2026-04-05T19:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-038"
			taskVersion:    1
			commandId:      "WI-038-claim-context-map-v2"
			timestamp:      "2026-04-05T19:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T03:01:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-038"
			taskVersion: 1
			commandId:   "WI-038-complete-context-map-v2"
			timestamp:   "2026-04-05T22:30:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-038-validation-20260405"
				artifactSnapshotHash: "a008411057221b5f1c54765573e1ac572c8c10f4"
				gatesPassed: [
					"cue-vet",
					"consistency-validation-25-contexts-46-relationships",
					"red-team-3-rounds",
					"founder-approved",
				]
			}
		}]
	}
}
