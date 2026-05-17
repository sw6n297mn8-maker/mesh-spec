package work_events

streams: {
	"WI-082": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-082"
			taskVersion: 1
			commandId:   "WI-082-propose-ctr-structural-check-authoring"
			timestamp:   "2026-05-12T06:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-082"
			taskVersion: 1
			commandId:   "WI-082-approve-ctr-structural-check-authoring"
			timestamp:   "2026-05-12T06:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-082"
			taskVersion:    1
			commandId:      "WI-082-claim-20260512"
			timestamp:      "2026-05-12T06:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T14:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-082"
			taskVersion: 1
			commandId:   "WI-082-complete-ctr-structural-check-authoring"
			timestamp:   "2026-05-12T08:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-082-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
