package work_events

// wi-148.cue — Lifecycle event-sourced de WI-148 (Regras A+B no
// check-self-review per adr-167: invariante global de staleness das
// bootstrap exceptions + fim do SKIP; resolução do def-012 e
// aposentadoria do ddp-001).
//
// NÃO é backfill: WI-148 foi proposto (pre-flight da fatia def-012 +
// adendo do arquiteto ampliando para as duas regras), aprovado
// integralmente pelo founder (decisões no chat 2026-07-03: escopo B =
// TODAS as entries; A transient-only; ddp-001 aposentado; sequenciamento
// PR-A antes; prova viva orgânica sem fabricar), claimado e completado
// na mesma sessão. commandIds SEM sufixo "-backfill" (execução live).
// Timestamps na granularidade da sessão — mesma honestidade declarada em
// work-events/_constraints.cue. artifactSnapshotHash = git blob hash de
// scripts/ci/check-self-review.sh (o enforcement novo) no conteúdo
// committado. gatesPassed reflete o verificável nesta sessão (cue vet +
// suites do runner e das Regras A+B); structural-checks rodam pós-commit.
streams: "WI-148": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-148"
	taskVersion: 1
	commandId:   "WI-148-propose-self-review-rules-a-b"
	timestamp:   "2026-07-03T18:30:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-148"
	taskVersion: 1
	commandId:   "WI-148-approve-self-review-rules-a-b"
	timestamp:   "2026-07-03T18:30:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-148"
	taskVersion:    1
	commandId:      "WI-148-claim-self-review-rules-a-b"
	timestamp:      "2026-07-03T18:30:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-04T02:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-148"
	taskVersion: 1
	commandId:   "WI-148-complete-self-review-rules-a-b"
	timestamp:   "2026-07-03T18:30:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-148-completion-20260703"
		artifactSnapshotHash: "deb74e1c189340881d5bfc0c95bc9383bd8ed9c0"
		gatesPassed: ["cue-vet", "runner-tests", "self-review-rules-tests"]
	}
}]
