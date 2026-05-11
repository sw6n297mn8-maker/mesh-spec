package work_events

streams: {
	"WI-078": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-078"
			taskVersion: 1
			commandId:   "WI-078-propose-rew-domain-model-discap-retroactive-patch"
			timestamp:   "2026-05-11T23:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-078"
			taskVersion: 1
			commandId:   "WI-078-approve-rew-domain-model-discap-retroactive-patch"
			timestamp:   "2026-05-11T23:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-078"
			taskVersion:    1
			commandId:      "WI-078-claim-20260511"
			timestamp:      "2026-05-11T23:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T07:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-078"
			taskVersion: 1
			commandId:   "WI-078-complete-rew-domain-model-discap-retroactive-patch"
			timestamp:   "2026-05-12T00:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-078-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
