package work_events

streams: {
	"WI-011": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-011"
			taskVersion:    1
			commandId:      "WI-011-claim-20260323"
			timestamp:      "2026-03-23T00:00:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-23T04:00:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-011"
			taskVersion: 1
			commandId:   "WI-011-complete-20260323"
			timestamp:   "2026-03-23T00:00:01Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "WI-011-validation-20260323"
				artifactSnapshotHash: "e28afa6e300b0c9370d896fce4b701ac855b3660"
				gatesPassed:          ["cue-vet", "self-review", "adr-coevolution"]
			}
		}]
	}
}
