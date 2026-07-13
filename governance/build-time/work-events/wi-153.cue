package work_events

// wi-153.cue — Lifecycle event-sourced de WI-153 (re-papel bdg-side do
// two-phase Reservation/Confirmation per adr-174: policy de aprovação-tardia
// → efetivação; evento de reserva CoverageReserved; fase reserved→confirmed;
// chave por requisição; espelho estrutural bdg-to-p2p).
//
// NÃO é backfill: WI-153 foi proposto e aprovado como task-spec-only na
// fatia WI-151 (PR #207, plannedOutput do adr-174 — registro no mesmo commit
// da materialização p2p, 2026-07-12), claimado e completado na execução da
// fatia própria (2026-07-13, Tempo 1 read-only + Tempo 2 batch). commandIds
// SEM sufixo "-backfill" (execução live). Timestamps na granularidade da
// sessão — mesma honestidade declarada em work-events/_constraints.cue.
// artifactSnapshotHash = git blob hash de contexts/bdg/domain-model.cue
// (core do re-papel) no conteúdo materializado. gatesPassed reflete o
// verificável nesta sessão (cue vet + runner estrutural + check-self-review);
// CI completo roda pós-push.
//
// Streams de wi-151/wi-152 NÃO entram aqui (D5 founder): a lacuna deles é
// higiene de outra fatia — este arquivo cobre exclusivamente o WI-153.
streams: "WI-153": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-153"
	taskVersion: 1
	commandId:   "WI-153-propose-bdg-two-phase-rerole"
	timestamp:   "2026-07-12T22:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-153"
	taskVersion: 1
	commandId:   "WI-153-approve-bdg-two-phase-rerole"
	timestamp:   "2026-07-12T22:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-153"
	taskVersion:    1
	commandId:      "WI-153-claim-bdg-two-phase-rerole"
	timestamp:      "2026-07-13T00:00:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-13T08:00:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-153"
	taskVersion: 1
	commandId:   "WI-153-complete-bdg-two-phase-rerole"
	timestamp:   "2026-07-13T00:00:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-153-completion-20260713"
		artifactSnapshotHash: "c1ef4177e6600a8b620886458dbcf39ab416a678"
		gatesPassed: ["cue-vet", "structural-runner", "check-self-review"]
	}
}]
