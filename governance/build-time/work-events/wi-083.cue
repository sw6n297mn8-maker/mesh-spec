package work_events

streams: {
	"WI-083": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-083"
			taskVersion: 1
			commandId:   "WI-083-propose-p2p-structural-check-authoring"
			timestamp:   "2026-05-12T08:30:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-083"
			taskVersion: 1
			commandId:   "WI-083-approve-p2p-structural-check-authoring"
			timestamp:   "2026-05-12T08:31:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-083"
			taskVersion:    1
			commandId:      "WI-083-claim-20260512"
			timestamp:      "2026-05-12T08:32:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T16:32:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-083"
			taskVersion: 1
			commandId:   "WI-083-complete-p2p-structural-check-authoring"
			timestamp:   "2026-05-12T10:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-083-completion-20260512"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
