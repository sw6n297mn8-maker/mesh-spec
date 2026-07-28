package work_events

// wi-156.cue — Lifecycle event-sourced de WI-156 (fatia de spec da
// triagem). Proposto pelo spec-writer na sessão 2026-07-28 do arco
// jornada→produção; aprovado pelo founder na mesma sessão (aprovação
// explícita em mensagem própria, precedendo esta escrita). Timestamps
// na granularidade da sessão.
streams: "WI-156": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-156"
	taskVersion: 1
	commandId:   "WI-156-propose-triage-surface-slice"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-156"
	taskVersion: 1
	commandId:   "WI-156-approve-triage-surface-slice"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}]
