package work_events

// wi-157.cue — Lifecycle event-sourced de WI-157 (re-autoria do
// stakeholder-map, resolve def-076). Proposto pelo spec-writer na sessão
// 2026-07-28 do arco jornada→produção; aprovado pelo founder na mesma
// sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
streams: "WI-157": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-157"
	taskVersion: 1
	commandId:   "WI-157-propose-stakeholder-map-reauthoring"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-157"
	taskVersion: 1
	commandId:   "WI-157-approve-stakeholder-map-reauthoring"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}]
