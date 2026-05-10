package work_events

streams: {
	"WI-072": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-072"
			taskVersion: 1
			commandId:   "WI-072-propose-rew-phase-3-5a-expansion"
			timestamp:   "2026-05-09T16:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-072"
			taskVersion: 1
			commandId:   "WI-072-approve-rew-phase-3-5a-expansion"
			timestamp:   "2026-05-09T16:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-072"
			taskVersion:    1
			commandId:      "WI-072-claim-20260509"
			timestamp:      "2026-05-09T16:02:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-10T00:02:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-072"
			taskVersion: 1
			commandId:   "WI-072-complete-rew-phase-3-5a-expansion"
			timestamp:   "2026-05-09T17:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-072-completion-20260509"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
