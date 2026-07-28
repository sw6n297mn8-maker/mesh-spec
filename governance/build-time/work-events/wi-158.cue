package work_events

// wi-158.cue — Lifecycle event-sourced de WI-158 (ADR de identidade e
// ator; resolve def-024, decide def-080). Proposto pelo spec-writer na
// sessão 2026-07-28 do arco jornada→produção; aprovado pelo founder na
// mesma sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
streams: "WI-158": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-158"
	taskVersion: 1
	commandId:   "WI-158-propose-identity-actor-adr"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-158"
	taskVersion: 1
	commandId:   "WI-158-approve-identity-actor-adr"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}]
