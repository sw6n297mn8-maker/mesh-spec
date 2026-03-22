package work_events

streams: {
	"WI-015": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-015"
			taskVersion: 1
			commandId:   "WI-015-propose-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-015"
			taskVersion: 1
			commandId:   "WI-015-approve-20260321"
			timestamp:   "2026-03-21T12:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-015"
			taskVersion:    1
			commandId:      "WI-015-claim-20260322"
			timestamp:      "2026-03-22T11:29:22Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-03-22T19:29:22Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-015"
			taskVersion: 1
			commandId:   "WI-015-complete-20260322"
			timestamp:   "2026-03-22T11:29:23Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "regularize-WI-015"
				artifactSnapshotHash: "41fcb669f745524c38005f0fac454bd86e52ab14"
				gatesPassed:          ["cue-vet"]
			}
		}]
	}
}
