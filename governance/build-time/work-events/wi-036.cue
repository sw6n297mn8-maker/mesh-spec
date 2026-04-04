package work_events

streams: {
	"WI-036": {
		taskId: "WI-036"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-036"
			taskVersion: 1
			commandId:   "WI-036-propose-ontology-correction"
			timestamp:   "2026-04-04T14:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-036"
			taskVersion: 1
			commandId:   "WI-036-approve-ontology-correction"
			timestamp:   "2026-04-04T15:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-036"
			taskVersion:    1
			commandId:      "WI-036-claim-ontology-correction"
			timestamp:      "2026-04-04T15:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-04T23:01:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-036"
			taskVersion: 1
			commandId:   "WI-036-complete-ontology-correction"
			timestamp:   "2026-04-04T16:30:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "vr-wi036-domain-definition"
				artifactSnapshotHash: "73adf124c0137c19503802a5aea4037214e93713"
				gatesPassed: [
					"cue-vet",
					"self-review-3-rounds-stable",
					"founder-approved",
				]
			}
		}]
	}
}
