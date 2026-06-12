package work_events

streams: {
	"WI-138": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-138"
			taskVersion: 1
			commandId:   "WI-138-propose-terminal-validation"
			timestamp:   "2026-06-12T19:12:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-138"
			taskVersion: 1
			commandId:   "WI-138-approve-terminal-validation"
			timestamp:   "2026-06-12T19:12:30Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-138"
			taskVersion:    1
			commandId:      "WI-138-claim-terminal-validation"
			timestamp:      "2026-06-12T19:13:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-06-13T03:13:00Z"
		}, {
			// Claim INTEGRAL — output único (prepayment-guard-terminal.cue),
			// entregue inteiro no mesmo commit (decisão founder: completed
			// atômico com o output via squash-merge). DECISÃO DE PATH
			// registrada: wave-plan previa terminal-validations/; execução
			// decidiu reuso de #GoldenExample marcado → local do tipo
			// reusado (golden-examples/), per rationale do task-spec.
			eventType:   "task-completed"
			taskId:      "WI-138"
			taskVersion: 1
			commandId:   "WI-138-complete-terminal-validation"
			timestamp:   "2026-06-12T19:30:00Z"
			actor:       "spec-writer"
		}]
	}
}
