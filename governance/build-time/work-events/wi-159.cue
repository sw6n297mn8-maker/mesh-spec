package work_events

// wi-159.cue — Lifecycle event-sourced de WI-159 (kit de superfície do
// ssc + api de abertura de RFQ). Proposto pelo spec-writer na sessão
// 2026-07-28 do arco jornada→produção; aprovado pelo founder na mesma
// sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
streams: "WI-159": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-159"
	taskVersion: 1
	commandId:   "WI-159-propose-ssc-surface-kit"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-159"
	taskVersion: 1
	commandId:   "WI-159-approve-ssc-surface-kit"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}]
