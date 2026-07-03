package work_events

// wi-147.cue — Lifecycle event-sourced de WI-147 (correção do runner de
// deferred-triggers per adr-166: contagem escopada + self-match morto por
// construção + kind structural-predicate/registry + gate multi-trigger +
// migração dos 21 triggers).
//
// NÃO é backfill: WI-147 foi proposto (pre-flight read-only da FASE B da
// janela dupla, 2026-07-03), aprovado integralmente pelo founder (decisões
// no chat: tabela de migração; amendments def-001 exaurido / def-016 prosa;
// item config.cue obrigatório; 2 commits; 4 condições — teste do cenário
// 6.3, ddp-004 validado na escrita, conferência linha-a-linha do c2, suite
// verde antes do push), claimado e completado na mesma sessão. commandIds
// SEM sufixo "-backfill" (execução live). Timestamps na granularidade da
// sessão — mesma honestidade declarada em work-events/_constraints.cue.
// artifactSnapshotHash = git blob hash de scripts/ci/evaluate_deferred_
// triggers.py (core novo do runner) no conteúdo committado. gatesPassed
// reflete o verificável nesta sessão (cue vet + suite de 16 testes do
// runner); structural-checks rodam pós-commit.
streams: "WI-147": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-147"
	taskVersion: 1
	commandId:   "WI-147-propose-dd-runner-correction"
	timestamp:   "2026-07-03T14:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-147"
	taskVersion: 1
	commandId:   "WI-147-approve-dd-runner-correction"
	timestamp:   "2026-07-03T14:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-147"
	taskVersion:    1
	commandId:      "WI-147-claim-dd-runner-correction"
	timestamp:      "2026-07-03T14:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-03T22:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-147"
	taskVersion: 1
	commandId:   "WI-147-complete-dd-runner-correction"
	timestamp:   "2026-07-03T14:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-147-completion-20260703"
		artifactSnapshotHash: "30546c9b52eaafcd8ae24e2e2f66aa5a898e0558"
		gatesPassed: ["cue-vet", "runner-tests"]
	}
}]
