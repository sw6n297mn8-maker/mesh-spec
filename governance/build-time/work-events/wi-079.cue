package work_events

streams: {
	"WI-079": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-079"
			taskVersion: 1
			commandId:   "WI-079-propose-cmt-structural-check-authoring"
			timestamp:   "2026-05-12T00:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-079"
			taskVersion: 1
			commandId:   "WI-079-approve-cmt-structural-check-authoring"
			timestamp:   "2026-05-12T00:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-079"
			taskVersion:    1
			commandId:      "WI-079-claim-20260512"
			timestamp:      "2026-05-12T00:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T08:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-079"
			taskVersion: 1
			commandId:   "WI-079-complete-cmt-structural-check-authoring"
			timestamp:   "2026-05-12T02:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-079-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
