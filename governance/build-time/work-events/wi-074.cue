package work_events

streams: {
	"WI-074": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-074"
			taskVersion: 1
			commandId:   "WI-074-propose-rew-phase-5-governance-envelope"
			timestamp:   "2026-05-11T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-074"
			taskVersion: 1
			commandId:   "WI-074-approve-rew-phase-5-governance-envelope"
			timestamp:   "2026-05-11T18:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-074"
			taskVersion:    1
			commandId:      "WI-074-claim-20260511"
			timestamp:      "2026-05-11T18:02:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T02:02:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-074"
			taskVersion: 1
			commandId:   "WI-074-complete-rew-phase-5-governance-envelope"
			timestamp:   "2026-05-11T19:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-074-completion-20260511"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
