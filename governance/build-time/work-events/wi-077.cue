package work_events

streams: {
	"WI-077": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-077"
			taskVersion: 1
			commandId:   "WI-077-propose-inv-domain-model-discap-retroactive-patch"
			timestamp:   "2026-05-11T22:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-077"
			taskVersion: 1
			commandId:   "WI-077-approve-inv-domain-model-discap-retroactive-patch"
			timestamp:   "2026-05-11T22:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-077"
			taskVersion:    1
			commandId:      "WI-077-claim-20260511"
			timestamp:      "2026-05-11T22:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T06:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-077"
			taskVersion: 1
			commandId:   "WI-077-complete-inv-domain-model-discap-retroactive-patch"
			timestamp:   "2026-05-11T23:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-077-completion-20260511"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
