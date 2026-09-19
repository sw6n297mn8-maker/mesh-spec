package work_events

// wi-163.cue — Lifecycle event-sourced de WI-163 (elo pedido↔compromisso
// no cmt + reversão registrada da D1 no bdg). Proposto pelo spec-writer na
// sessão 2026-09-18, no mesmo arco do WI-162 e na mesma branch.
//
// Achado de origem: revisão isolada do adr-200 e verificação subsequente
// no disco expuseram que o rationale do ACL do bdg afirma um campo que o
// agg-commitment não declara. Cardinalidade verificada ANTES da autoria
// (referência simples, não lista) por ordem do founder — a checagem
// rendeu escopo que a proposta original não tinha: o ref precisa viajar
// também no evento de CRIAÇÃO, sob pena de o campo não sobreviver ao
// replay do agregado.
//
// Número WI-163 mantido contra o STOP do G2 por confirmação do arquiteto:
// o gate deriva de origin/main e não enxerga o WI-162, que vive nesta
// mesma branch com PR aberto (#263). Renumerar criaria a colisão que o
// gate existe para evitar.
//
// Classificação: instanciação (sem ADR novo, precedente WI-161).
// Authoring manual declarado (task-spec fora do rollout de
// authoring-policy; cai em defaultMode manual).
//
// task-approved NÃO consta ainda, por construção: o PG do task-spec exige
// approval do founder em mensagem separada, nunca proposto + aprovado na
// mesma turn do agente (guard contra auto-approval, P10).
streams: "WI-163": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-163"
	taskVersion: 1
	commandId:   "WI-163-propose-commitment-purchase-order-link"
	timestamp:   "2026-09-18T19:30:00Z"
	actor:       "spec-writer"
}]
