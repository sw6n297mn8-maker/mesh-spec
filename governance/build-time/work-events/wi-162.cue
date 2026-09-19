package work_events

// wi-162.cue — Lifecycle event-sourced de WI-162 (materialização da
// proposta de decisão de sourcing como fato do ssc, per adr-196).
// Proposto pelo spec-writer na sessão 2026-09-18 do arco recibo→produção.
// Classificação: instanciação (sem ADR novo — a decisão é o adr-196,
// accepted em 2026-09-03; sem número novo de família além do WI).
// Authoring manual declarado (task-spec não está no rollout de
// authoring-policy; cai em defaultMode manual).
//
// task-approved NÃO consta ainda, por construção: o PG do task-spec
// exige approval do founder em mensagem separada, nunca proposto +
// aprovado no mesmo commit ou na mesma turn do agente (guard contra
// auto-approval, P10).
streams: "WI-162": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-162"
	taskVersion: 1
	commandId:   "WI-162-propose-sourcing-decision-proposal-materialization"
	timestamp:   "2026-09-18T00:00:00Z"
	actor:       "spec-writer"
}]
