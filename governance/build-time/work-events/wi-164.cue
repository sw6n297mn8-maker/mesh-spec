package work_events

// wi-164.cue — Lifecycle event-sourced de WI-164 (tipo da recusa da
// contraparte no causeType do cmt). Proposto pelo spec-writer na sessão
// 2026-09-18, terceira fatia do arco na branch claude/quirky-cray-3tkf9a.
//
// Decisão do founder registrada: UM valor novo, não a passada geral do
// enum. Motivos — evidência de sobrecarga do operational é de um caso só,
// e o adr-199 reescrito espera esta peça. A suspeita entra declarada, sem
// ação, para que o segundo caso mal tipado encontre o primeiro anotado.
//
// A checagem antes da autoria encolheu o escopo: o enum fechado vive só no
// constraints do vo-state-change-reason; schemas/events.cue, api.yaml e
// async-api.yaml declaram causeType como string livre. O manifest espelha
// commands/events/invariants, não VOs — fora da fatia.
//
// Número WI-164 sob a mesma condição já confirmada pelo arquiteto para
// esta branch (G2 deriva de origin/main, que não enxerga 162 nem 163).
//
// Classificação: instanciação (sem ADR novo, precedente WI-161).
// Authoring manual declarado (task-spec fora do rollout de
// authoring-policy; cai em defaultMode manual).
//
// task-approved NÃO consta ainda, por construção: o PG do task-spec exige
// approval do founder em mensagem separada, nunca proposto + aprovado na
// mesma turn do agente (guard contra auto-approval, P10).
streams: "WI-164": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-164"
	taskVersion: 1
	commandId:   "WI-164-propose-counterparty-refusal-cause-type"
	timestamp:   "2026-09-18T22:30:00Z"
	actor:       "spec-writer"
}]
