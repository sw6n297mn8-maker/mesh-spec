package work_events

streams: {
	"WI-081": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-081"
			taskVersion: 1
			commandId:   "WI-081-propose-ssc-structural-check-authoring"
			timestamp:   "2026-05-12T04:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-081"
			taskVersion: 1
			commandId:   "WI-081-approve-ssc-structural-check-authoring"
			timestamp:   "2026-05-12T04:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-081"
			taskVersion:    1
			commandId:      "WI-081-claim-20260512"
			timestamp:      "2026-05-12T04:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T12:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-081"
			taskVersion: 1
			commandId:   "WI-081-complete-ssc-structural-check-authoring"
			timestamp:   "2026-05-12T06:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-081-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
