package work_events

streams: {
	"WI-071": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-071"
			taskVersion: 1
			commandId:   "WI-071-propose-rebuild-projections-script"
			timestamp:   "2026-05-08T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-071"
			taskVersion: 1
			commandId:   "WI-071-approve-rebuild-projections-script"
			timestamp:   "2026-05-08T18:00:30Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-071"
			taskVersion:    1
			commandId:      "WI-071-claim-rebuild-projections-script"
			timestamp:      "2026-05-08T19:00:51Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-09T03:00:51Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-071"
			taskVersion: 1
			commandId:   "WI-071-complete-rebuild-projections-script"
			timestamp:   "2026-05-08T19:05:02Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-071-completion-20260508"
				artifactSnapshotHash: "58e56e2-plus-wi071-deliverables"
				gatesPassed:          ["cue-vet", "self-review-enforcement", "script-output-validates"]
			}
		}]
	}
}
