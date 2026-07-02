package work_events

// wi-145.cue — Lifecycle event-sourced de WI-145 (enriquecimento do
// PaymentGuardEscalated com o contexto de triagem: commitmentRef +
// invoiceId + amount — o produtor do alarme rico da QueryEscalatedPayments
// do WI-144).
//
// NÃO é backfill: WI-145 foi proposto (pre-flight read-only do T2a),
// aprovado (decisões do arquiteto no chat, com emenda amount → #DecimalString
// puro), claimado e completado na mesma sessão (2026-07-02). commandIds SEM
// sufixo "-backfill" (execução live). Timestamps na granularidade da sessão —
// mesma honestidade declarada em work-events/_constraints.cue.
// artifactSnapshotHash = git blob hash de contexts/fce/schemas/events.cue
// (output canônico enriquecido) no conteúdo committado. gatesPassed reflete
// o verificável nesta sessão (cue vet + self-review round 1 estável);
// structural-checks rodam pós-commit.
streams: "WI-145": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-145"
	taskVersion: 1
	commandId:   "WI-145-propose-fce-escalated-context"
	timestamp:   "2026-07-02T18:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-145"
	taskVersion: 1
	commandId:   "WI-145-approve-fce-escalated-context"
	timestamp:   "2026-07-02T18:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-145"
	taskVersion:    1
	commandId:      "WI-145-claim-fce-escalated-context"
	timestamp:      "2026-07-02T18:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-03T02:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-145"
	taskVersion: 1
	commandId:   "WI-145-complete-fce-escalated-context"
	timestamp:   "2026-07-02T18:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-145-completion-20260702"
		artifactSnapshotHash: "525d235bd40475725235cc302f82c3f206d81c58"
		gatesPassed: ["cue-vet", "self-review"]
	}
}]
