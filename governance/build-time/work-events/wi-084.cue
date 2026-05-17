package work_events

streams: {
	"WI-084": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-084"
			taskVersion: 1
			commandId:   "WI-084-propose-bdg-structural-check-authoring"
			timestamp:   "2026-05-12T10:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-084"
			taskVersion: 1
			commandId:   "WI-084-approve-bdg-structural-check-authoring"
			timestamp:   "2026-05-12T10:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-084"
			taskVersion:    1
			commandId:      "WI-084-claim-20260512"
			timestamp:      "2026-05-12T10:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T18:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-084"
			taskVersion: 1
			commandId:   "WI-084-complete-bdg-structural-check-authoring"
			timestamp:   "2026-05-12T12:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-084-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
