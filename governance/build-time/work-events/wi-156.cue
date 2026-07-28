package work_events

// wi-156.cue — Lifecycle event-sourced de WI-156 (fatia de spec da
// triagem). Proposto pelo spec-writer na sessão 2026-07-28 do arco
// jornada→produção; aprovado pelo founder na mesma sessão (aprovação
// explícita em mensagem própria, precedendo esta escrita). Timestamps
// na granularidade da sessão.
//
// Claimado e completado na execução da própria fatia (2026-07-28,
// molde WI-155). Verificação inline do founder na aprovação:
// narrative CONFIRMADA obrigatória (string possivelmente vazia, sem
// '?') no data do #PurchaseRequisitionTriaged (schemas/events.cue
// L107) — espelho mantido exatamente como proposto. gatesPassed
// reflete o verificável nesta sessão; structural-runner fechou em
// 30 warns / 0 bloqueantes — o baseline pré-existente, nenhuma
// violação nova da fatia. artifactSnapshotHash = git blob hash de
// contexts/p2p/api.yaml (o peso da fatia) no conteúdo materializado.
streams: "WI-156": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-156"
	taskVersion: 1
	commandId:   "WI-156-propose-triage-surface-slice"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-156"
	taskVersion: 1
	commandId:   "WI-156-approve-triage-surface-slice"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-156"
	taskVersion:    1
	commandId:      "WI-156-claim-triage-surface-slice"
	timestamp:      "2026-07-28T17:20:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-29T01:20:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-156"
	taskVersion: 1
	commandId:   "WI-156-complete-triage-surface-slice"
	timestamp:   "2026-07-28T17:35:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-156-completion-20260728"
		artifactSnapshotHash: "598e40766d09e17559c6997fa249f90a411565ac"
		gatesPassed: ["cue-vet", "yaml-parse", "structural-runner", "check-self-review"]
	}
}]
