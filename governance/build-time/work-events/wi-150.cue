package work_events

// wi-150.cue — Lifecycle event-sourced de WI-150 (gate de frescura de
// materialização per adr-168: G1 tip + G2 renumeração + G3 eco; script +
// fixtures + step CI + regra no contrato do agente).
//
// NÃO é backfill: WI-150 foi proposto (pre-flight curto S1-freshness +
// proposta D aprovada pelo arquiteto com forma corrigida — branch nova + PR
// separado, aberto após o merge do #200), claimado e completado na mesma
// sessão (2026-07-03). commandIds SEM sufixo "-backfill" (execução live).
// Timestamps na granularidade da sessão — mesma honestidade declarada em
// work-events/_constraints.cue. artifactSnapshotHash = git blob hash de
// scripts/ci/materialization-freshness.sh (core do gate) no conteúdo
// committado. gatesPassed reflete o verificável nesta sessão (cue vet +
// suite de 27 testes do runner incluindo as 7 fixtures novas do gate);
// structural-checks + check-self-review rodam pós-commit.
//
// A fatia nasce conforme a regra que institui: branch criada do tip pós-#200
// (G1) e o número WI-150 re-derivado pelo próprio gate na escrita (G2 == 150).
streams: "WI-150": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-150"
	taskVersion: 1
	commandId:   "WI-150-propose-materialization-freshness-gate"
	timestamp:   "2026-07-03T21:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-150"
	taskVersion: 1
	commandId:   "WI-150-approve-materialization-freshness-gate"
	timestamp:   "2026-07-03T21:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-150"
	taskVersion:    1
	commandId:      "WI-150-claim-materialization-freshness-gate"
	timestamp:      "2026-07-03T21:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-04T05:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-150"
	taskVersion: 1
	commandId:   "WI-150-complete-materialization-freshness-gate"
	timestamp:   "2026-07-03T21:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-150-completion-20260703"
		artifactSnapshotHash: "2731ea31b22ed14db169f17fe16bae65d8e0f8e2"
		gatesPassed: ["cue-vet", "runner-tests"]
	}
}]
