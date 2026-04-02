package work_events

streams: {
	"WI-020": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-020"
			taskVersion: 1
			commandId:   "WI-020-propose"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-020"
			taskVersion: 1
			commandId:   "WI-020-approve"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "founder"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-020"
			taskVersion: 1
			commandId:   "WI-020-complete"
			timestamp:   "2026-04-01T00:00:00Z"
			actor:       "spec-writer"
			summary:     "Schema #DomainModel criado (domain-model.cue), ADR-035, quality-criteria.cue atualizado. 16 quality criteria, union discriminada #DomainEvent, #SourceContextRef."
		}]
	}
}
