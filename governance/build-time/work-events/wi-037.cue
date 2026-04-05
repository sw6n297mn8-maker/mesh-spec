package work_events

streams: {
	"WI-037": {
		taskId: "WI-037"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-037"
			taskVersion: 1
			commandId:   "WI-037-propose-subdomain-expansion"
			timestamp:   "2026-04-04T14:01:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-037"
			taskVersion: 1
			commandId:   "WI-037-approve-subdomain-expansion"
			timestamp:   "2026-04-04T15:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-037"
			taskVersion:    1
			commandId:      "WI-037-claim-subdomain-expansion"
			timestamp:      "2026-04-04T15:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T15:01:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-037"
			taskVersion: 1
			commandId:   "WI-037-complete-subdomain-expansion"
			timestamp:   "2026-04-05T18:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "vr-wi037-subdomain-expansion"
				artifactSnapshotHash: "3b8ecad474ca86acf1ad6f1260a5c0aef266aa8f"
				gatesPassed: [
					"cue-vet",
					"self-review-5-rounds-stable",
					"founder-approved",
				]
			}
		}]
	}
}
