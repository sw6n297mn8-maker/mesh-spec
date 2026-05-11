package work_events

streams: {
	"WI-085": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-085"
			taskVersion: 1
			commandId:   "WI-085-propose-rename-bdg-commitment-uniqueness-invariant-global"
			timestamp:   "2026-05-12T12:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-085"
			taskVersion: 1
			commandId:   "WI-085-approve-rename-bdg-commitment-uniqueness-invariant-global"
			timestamp:   "2026-05-12T12:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-085"
			taskVersion:    1
			commandId:      "WI-085-claim-20260512"
			timestamp:      "2026-05-12T12:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T20:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-085"
			taskVersion: 1
			commandId:   "WI-085-complete-rename-bdg-commitment-uniqueness-invariant-global"
			timestamp:   "2026-05-12T13:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-085-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
