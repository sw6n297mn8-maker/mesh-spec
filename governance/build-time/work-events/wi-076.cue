package work_events

streams: {
	"WI-076": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-076"
			taskVersion: 1
			commandId:   "WI-076-propose-pg-structural-check-domain-invariant-extension"
			timestamp:   "2026-05-11T21:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-076"
			taskVersion: 1
			commandId:   "WI-076-approve-pg-structural-check-domain-invariant-extension"
			timestamp:   "2026-05-11T21:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-076"
			taskVersion:    1
			commandId:      "WI-076-claim-20260511"
			timestamp:      "2026-05-11T21:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T05:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-076"
			taskVersion: 1
			commandId:   "WI-076-complete-pg-structural-check-domain-invariant-extension"
			timestamp:   "2026-05-11T22:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-076-completion-20260511"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
