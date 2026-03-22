package work_events

// WI-010: admitida (proposed+approved) apesar de ter 1/2 outputs
// commitados (validate-domain-definition.cue existe;
// validate-canvas.cue pendente). Execution state = unclaimed,
// aguardando claim para completar o restante.
streams: {
	"WI-010": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-010"
			taskVersion: 1
			commandId:   "WI-010-propose-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-010"
			taskVersion: 1
			commandId:   "WI-010-approve-backfill"
			timestamp:   "2026-03-21T00:00:00Z"
			actor:       "founder"
		}]
	}
}
