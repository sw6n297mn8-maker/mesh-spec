package work_events

// wi-144.cue — Lifecycle event-sourced de WI-144 (query de escalados do FCE:
// QueryEscalatedPayments no canvas + extensão do api.yaml — o degrau de
// leitura do oq-fce-1 para a tela de override do frontend-runtime).
//
// NÃO é backfill: WI-144 foi proposto (mapa read-only), aprovado (forma
// cravada pelo founder no chat), claimado e completado na mesma sessão
// (2026-07-02). commandIds SEM sufixo "-backfill" (execução live).
// Timestamps na granularidade da sessão — mesma honestidade declarada em
// work-events/_constraints.cue. artifactSnapshotHash = git blob hash de
// contexts/fce/api.yaml (output canônico ampliado) no conteúdo committado.
// gatesPassed reflete o verificável nesta sessão (cue vet + self-review
// round 1 estável); structural-checks rodam pós-commit.
streams: "WI-144": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-144"
	taskVersion: 1
	commandId:   "WI-144-propose-fce-escalated-query"
	timestamp:   "2026-07-02T14:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-144"
	taskVersion: 1
	commandId:   "WI-144-approve-fce-escalated-query"
	timestamp:   "2026-07-02T14:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-144"
	taskVersion:    1
	commandId:      "WI-144-claim-fce-escalated-query"
	timestamp:      "2026-07-02T14:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-02T22:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-144"
	taskVersion: 1
	commandId:   "WI-144-complete-fce-escalated-query"
	timestamp:   "2026-07-02T14:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-144-completion-20260702"
		artifactSnapshotHash: "e5a66ae2a6226bafab780714a889e0d84f56322a"
		gatesPassed: ["cue-vet", "self-review"]
	}
}]
