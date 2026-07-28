package work_events

// wi-160.cue — Lifecycle event-sourced de WI-160 (mapa de cotações — 3ª
// família do codegen de frontend + promoção do contrato a schema).
// Proposto pelo spec-writer na sessão 2026-07-28 do arco
// jornada→produção; aprovado pelo founder na mesma sessão (aprovação
// explícita em mensagem própria, precedendo esta escrita). Timestamps
// na granularidade da sessão.
streams: "WI-160": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-160"
	taskVersion: 1
	commandId:   "WI-160-propose-quotation-map-third-family"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-160"
	taskVersion: 1
	commandId:   "WI-160-approve-quotation-map-third-family"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}]
