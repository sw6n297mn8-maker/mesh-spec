package work_events

// wi-146.cue — Lifecycle event-sourced de WI-146 (command surface do
// resolve-guard-escalation: command-handler no inbound do canvas FCE + POST
// no api.yaml sob a postura def-024 — o degrau de ESCRITA do override,
// primeiro command supervisionado da Mesh na borda sync).
//
// NÃO é backfill: WI-146 foi proposto (pre-flight read-only do W1), aprovado
// (decisões do arquiteto no chat: oneOf dos 2 eventos, enum approve|deny,
// proof na response, amendment do def-024), claimado e completado na mesma
// sessão (2026-07-02). commandIds SEM sufixo "-backfill" (execução live).
// Timestamps na granularidade da sessão — mesma honestidade declarada em
// work-events/_constraints.cue. artifactSnapshotHash = git blob hash de
// contexts/fce/api.yaml (output canônico ampliado) no conteúdo committado.
// gatesPassed reflete o verificável nesta sessão (cue vet + self-review
// round 1 estável); structural-checks rodam pós-commit.
streams: "WI-146": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-146"
	taskVersion: 1
	commandId:   "WI-146-propose-fce-resolve-command"
	timestamp:   "2026-07-02T22:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-146"
	taskVersion: 1
	commandId:   "WI-146-approve-fce-resolve-command"
	timestamp:   "2026-07-02T22:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-146"
	taskVersion:    1
	commandId:      "WI-146-claim-fce-resolve-command"
	timestamp:      "2026-07-02T22:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-03T06:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-146"
	taskVersion: 1
	commandId:   "WI-146-complete-fce-resolve-command"
	timestamp:   "2026-07-02T22:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-146-completion-20260702"
		artifactSnapshotHash: "ec979cdf044ec1fab4a09b88ecefad0dce5ff600"
		gatesPassed: ["cue-vet", "self-review"]
	}
}]
