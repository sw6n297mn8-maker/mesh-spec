package work_events

streams: {
	"WI-073": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-073"
			taskVersion: 1
			commandId:   "WI-073-propose-rew-phase-4-primary-agent"
			timestamp:   "2026-05-11T16:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-073"
			taskVersion: 1
			commandId:   "WI-073-approve-rew-phase-4-primary-agent"
			timestamp:   "2026-05-11T16:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-073"
			taskVersion:    1
			commandId:      "WI-073-claim-20260511"
			timestamp:      "2026-05-11T16:02:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T00:02:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-073"
			taskVersion: 1
			commandId:   "WI-073-complete-rew-phase-4-primary-agent"
			timestamp:   "2026-05-11T17:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-073-completion-20260511"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
