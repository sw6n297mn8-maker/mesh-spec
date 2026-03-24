package work_events

streams: {
	"WI-012": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-012"
			taskVersion: 1
			commandId:   "WI-012-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-012"
			taskVersion: 1
			commandId:   "WI-012-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-012"
			taskVersion:    1
			commandId:      "WI-012-claim-20260323"
			timestamp:      "2026-03-23T00:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-23T04:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-012"
			taskVersion: 1
			commandId:   "WI-012-complete-20260323"
			timestamp:   "2026-03-23T00:00:01Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-012-validation-20260323"
				artifactSnapshotHash: "d8c5a531cb8170fca74466bb57c94b43c69193b0"
				gatesPassed:          ["cue-vet", "self-review", "adr-coevolution"]
			}
		}]
	}
}
