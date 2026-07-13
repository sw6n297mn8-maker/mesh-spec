package work_events

// wi-154.cue — Lifecycle event-sourced de WI-154 (higiene A do gate
// agente↔modelo per adr-175: coevolução dos agent-specs de bdg/ssc/p2p —
// cobertura dos 21 itens, exclusão dos 3 padrão-C, correção da prosa
// falsa do bdg pós-two-phase — levando o sc-ag-02 desses 3 BCs a zero).
//
// NÃO é backfill: WI-154 foi proposto e aprovado como task-spec na fatia
// do gate (PR #210, plannedOutput do adr-175, 2026-07-13), claimado e
// completado na execução da fatia própria (2026-07-13, Tempo 1 read-only
// com classificação dos 24 itens + Tempo 2 batch com decisões cravadas).
// commandIds SEM sufixo "-backfill" (execução live). Timestamps na
// granularidade da sessão — mesma honestidade declarada em
// work-events/_constraints.cue. artifactSnapshotHash = git blob hash de
// contexts/p2p/agents/p2p-primary-agent.cue (a maior massa da higiene)
// no conteúdo materializado. gatesPassed reflete o verificável nesta
// sessão (cue vet + runner estrutural com sc-ag-02 dos 3 BCs a zero +
// check-self-review); CI completo roda pós-push.
//
// O stream do wi-151 segue AUSENTE (lacuna conhecida das fatias
// #206/#207); o backfill dele é higiene de event-sourcing SEPARADA
// (decisão do founder na fatia do gate) — este arquivo cobre
// exclusivamente o WI-154.
streams: "WI-154": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-154"
	taskVersion: 1
	commandId:   "WI-154-propose-agent-spec-hygiene-a"
	timestamp:   "2026-07-13T15:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-154"
	taskVersion: 1
	commandId:   "WI-154-approve-agent-spec-hygiene-a"
	timestamp:   "2026-07-13T15:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-154"
	taskVersion:    1
	commandId:      "WI-154-claim-agent-spec-hygiene-a"
	timestamp:      "2026-07-13T18:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-14T02:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-154"
	taskVersion: 1
	commandId:   "WI-154-complete-agent-spec-hygiene-a"
	timestamp:   "2026-07-13T18:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-154-completion-20260713"
		artifactSnapshotHash: "e93b324552862c84edf04d53895d24301fedcbc2"
		gatesPassed: ["cue-vet", "structural-runner", "check-self-review"]
	}
}]
