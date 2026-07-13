package work_events

// wi-155.cue — Lifecycle event-sourced de WI-155 (higiene B do gate
// agente↔modelo per adr-175: coevolução dos agent-specs de cmt e rew —
// 6 coberturas + 31 exclusões conscientes no rew em 3 classes com
// frase-marca literal + 1 por-id — ZERANDO o baseline global do
// sc-ag-02, pré-condição da catraca warn→reject).
//
// NÃO é backfill: WI-155 foi proposto e aprovado como task-spec na fatia
// do gate (PR #210, plannedOutput do adr-175, 2026-07-13), claimado e
// completado na execução da fatia própria (2026-07-13, Tempo 1 read-only
// com inventário COMPLETO dos 35 do rew e frase-marca de cada exclusão +
// Tempo 2 batch com decisões cravadas: classe A única, 2 ambíguos →
// exclusão, zero action nova). commandIds SEM sufixo "-backfill"
// (execução live). Timestamps na granularidade da sessão — mesma
// honestidade declarada em work-events/_constraints.cue.
// artifactSnapshotHash = git blob hash de
// contexts/rew/agents/rew-primary-agent.cue (o peso da fatia) no
// conteúdo materializado. gatesPassed reflete o verificável nesta
// sessão (cue vet + runner estrutural com sc-ag-02 GLOBAL a zero +
// sc-ag-01 sem dangling nos 31 refs de exclusão + check-self-review);
// CI completo roda pós-push.
//
// O stream do wi-151 segue AUSENTE (lacuna conhecida das fatias
// #206/#207); o backfill dele é higiene de event-sourcing SEPARADA —
// este arquivo cobre exclusivamente o WI-155.
streams: "WI-155": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-155"
	taskVersion: 1
	commandId:   "WI-155-propose-agent-spec-hygiene-b"
	timestamp:   "2026-07-13T15:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-155"
	taskVersion: 1
	commandId:   "WI-155-approve-agent-spec-hygiene-b"
	timestamp:   "2026-07-13T15:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-155"
	taskVersion:    1
	commandId:      "WI-155-claim-agent-spec-hygiene-b"
	timestamp:      "2026-07-13T19:30:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-14T03:30:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-155"
	taskVersion: 1
	commandId:   "WI-155-complete-agent-spec-hygiene-b"
	timestamp:   "2026-07-13T19:30:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-155-completion-20260713"
		artifactSnapshotHash: "af64b546654faab0251c355b10ded9c50da5ac19"
		gatesPassed: ["cue-vet", "structural-runner", "check-self-review"]
	}
}]
