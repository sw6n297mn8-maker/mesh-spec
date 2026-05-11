package work_events

streams: {
	"WI-080": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-080"
			taskVersion: 1
			commandId:   "WI-080-propose-dlv-structural-check-authoring"
			timestamp:   "2026-05-12T02:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-080"
			taskVersion: 1
			commandId:   "WI-080-approve-dlv-structural-check-authoring"
			timestamp:   "2026-05-12T02:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-080"
			taskVersion:    1
			commandId:      "WI-080-claim-20260512"
			timestamp:      "2026-05-12T02:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T10:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-080"
			taskVersion: 1
			commandId:   "WI-080-complete-dlv-structural-check-authoring"
			timestamp:   "2026-05-12T04:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-080-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
