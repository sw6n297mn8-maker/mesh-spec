package work_events

// wi-161.cue — Lifecycle event-sourced de WI-161 (modelagem da
// negociação no ssc, passo 8 da story). Proposto pelo spec-writer na
// sessão 2026-07-28 do arco jornada→produção; aprovado pelo founder na
// mesma sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
streams: "WI-161": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-161"
	taskVersion: 1
	commandId:   "WI-161-propose-negotiation-modeling"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-161"
	taskVersion: 1
	commandId:   "WI-161-approve-negotiation-modeling"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}]
