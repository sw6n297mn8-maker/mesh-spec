package work_events

streams: {
	"WI-039": {
		taskId: "WI-039"
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-039"
			taskVersion: 1
			commandId:   "WI-039-propose-canvas-revision"
			timestamp:   "2026-04-04T14:03:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-039"
			taskVersion: 1
			commandId:   "WI-039-approve-canvas-revision"
			timestamp:   "2026-04-05T23:00:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-039"
			taskVersion:    1
			commandId:      "WI-039-claim-canvas-revision"
			timestamp:      "2026-04-05T23:01:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-04-06T07:01:00Z"
		}, {
			eventType:            "task-completed"
			taskId:               "WI-039"
			taskVersion:          1
			commandId:            "WI-039-complete-canvas-revision"
			timestamp:            "2026-04-05T23:30:00Z"
			actor:                "spec-writer"
			validationRunId:      "WI-039-validation-20260405"
			artifactSnapshotHash: "cmt:5becab81636a92ae3e38a25764af61063c145ca0,ctr:31f3148c71d1af3dab9fb5ef120d0b04ff11f0ef"
			gatesPassed: ["cue-vet", "semantic-validation-cmt-5-checks-0-fail", "semantic-validation-ctr-5-checks-0-fail", "founder-approved"]
		}]
	}
}
