package work_events

// wi-152.cue — Lifecycle event-sourced de WI-152 (mapa de cotações
// consultável no ssc: 2 events internal de cotação + prj-quotation-map/
// qry-quotation-map com equalização TCO derivada + term-mapa-de-cotacoes +
// refs dos passos 6-7 da ds-buyer-procurement-journey).
//
// NÃO é backfill: WI-152 foi proposto e aprovado como task-spec na fatia
// def-078+WI-151+WI-152 (PR #206, conteúdo literal do arquiteto com OK do
// founder, 2026-07-12), claimado e completado na execução da fatia própria
// (2026-07-13, Tempo 1 read-only + Tempo 2 batch com decisão B do founder).
// commandIds SEM sufixo "-backfill" (execução live). Timestamps na
// granularidade da sessão — mesma honestidade declarada em
// work-events/_constraints.cue. artifactSnapshotHash = git blob hash de
// contexts/ssc/domain-model.cue (core da read-surface) no conteúdo
// materializado. gatesPassed reflete o verificável nesta sessão (cue vet +
// runner estrutural + check-self-review); CI completo roda pós-push.
//
// O stream do wi-151 segue AUSENTE (lacuna conhecida das fatias #206/#207);
// o backfill dele é higiene de outra fatia — este arquivo cobre
// exclusivamente o WI-152 (decisão do founder no Tempo 2).
streams: "WI-152": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-152"
	taskVersion: 1
	commandId:   "WI-152-propose-quotation-map-read-surface"
	timestamp:   "2026-07-12T14:00:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-152"
	taskVersion: 1
	commandId:   "WI-152-approve-quotation-map-read-surface"
	timestamp:   "2026-07-12T14:00:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-152"
	taskVersion:    1
	commandId:      "WI-152-claim-quotation-map-read-surface"
	timestamp:      "2026-07-13T02:30:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-13T10:30:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-152"
	taskVersion: 1
	commandId:   "WI-152-complete-quotation-map-read-surface"
	timestamp:   "2026-07-13T02:30:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-152-completion-20260713"
		artifactSnapshotHash: "accc73e1b36e76a71e4baf9e0b5e02c24b6ebfad"
		gatesPassed: ["cue-vet", "structural-runner", "check-self-review"]
	}
}]
