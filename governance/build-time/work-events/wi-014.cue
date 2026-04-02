package work_events

// WI-014: task-completed e task-claimed removidos — backfill original
// registrou conclusão mas o artefato (context-map-runner.cue) nunca
// foi commitado. Diretório governance/build-time/runners/ não existe.
// Status real: approved, aguardando execução.
streams: {
	"WI-014": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-014"
			taskVersion: 1
			commandId:   "WI-014-propose-backfill"
			timestamp:   "2026-03-18T13:19:53Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-014"
			taskVersion: 1
			commandId:   "WI-014-approve-backfill"
			timestamp:   "2026-03-18T13:19:53Z"
			actor:       "founder"
		}]
	}
}
