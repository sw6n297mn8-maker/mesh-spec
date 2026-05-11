package work_events

streams: {
	"WI-075": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-075"
			taskVersion: 1
			commandId:   "WI-075-propose-adr-086-domain-invariant-authoring-protocol"
			timestamp:   "2026-05-11T20:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-075"
			taskVersion: 1
			commandId:   "WI-075-approve-adr-086-domain-invariant-authoring-protocol"
			timestamp:   "2026-05-11T20:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-075"
			taskVersion:    1
			commandId:      "WI-075-claim-20260511"
			timestamp:      "2026-05-11T20:02:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-05-12T04:02:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-075"
			taskVersion: 1
			commandId:   "WI-075-complete-adr-086-domain-invariant-authoring-protocol"
			timestamp:   "2026-05-11T21:00:00Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-075-completion-20260511"
				artifactSnapshotHash: "PENDING-COMMIT-HASH"
				gatesPassed:          ["cue-vet", "self-review-enforcement"]
			}
		}]
	}
}
