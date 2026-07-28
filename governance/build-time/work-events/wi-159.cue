package work_events

// wi-159.cue — Lifecycle event-sourced de WI-159 (kit de superfície do
// ssc + api de abertura de RFQ). Proposto pelo spec-writer na sessão
// 2026-07-28 do arco jornada→produção; aprovado pelo founder na mesma
// sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
//
// Claimado e completado na execução da própria fatia (2026-07-28,
// molde WI-155/156). Verificação inline do founder na aprovação:
// cmd-open-rfq CONFIRMADO com requestedBy E requestedAt como fields
// declarados do command (8 fields verbatim; requestedAt sustenta o
// audit requestedAt < openedAt de inv-decision-type-declared-upfront)
// — o request do api.yaml mantém os 8 campos exatamente como proposto.
// gatesPassed reflete o verificável nesta sessão; structural-runner
// fechou em 29 warns / 0 bloqueantes (30→29: warn de sync-surface do
// ssc quitado pelo api.yaml; os 18 conceitos do manifest aceitos como
// pendência RECONHECIDA na worklist — gate sc-fct-01 reject sem
// acusação). verbatim-diff: am 8/9/7 contra o bloco canônico do
// agg-sourcing-process + pm↔am coerente. artifactSnapshotHash = git
// blob hash de contexts/ssc/api.yaml no conteúdo materializado.
//
// PÓS-CI (mesma fatia, correções mecânicas): (a) structure-index
// regenerado (drift gate adr-152 — 4 arquivos novos do ssc); (b) grafia
// dos type defs alinhada ao consumidor canônico no PRIMEIRO acrônimo
// dos schemas: VOs pela derivação do code (RfqId/RfqScope), events pelo
// name do domain-model (RFQOpened/RFQConcluded/RFQCancelled) — a
// bifurcação de lookup do gerador (VO-por-code vs event-por-name) fica
// ANOTADA para harmonização runtime-local futura. codegen-pipeline
// re-rodado: exit 0 CONTINUAR, 86/100 (14 não-passando = estado
// conhecido pré-existente, zero regressão; o Kotlin do ssc compila).
streams: "WI-159": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-159"
	taskVersion: 1
	commandId:   "WI-159-propose-ssc-surface-kit"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-159"
	taskVersion: 1
	commandId:   "WI-159-approve-ssc-surface-kit"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-159"
	taskVersion:    1
	commandId:      "WI-159-claim-ssc-surface-kit"
	timestamp:      "2026-07-28T18:47:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-29T02:47:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-159"
	taskVersion: 1
	commandId:   "WI-159-complete-ssc-surface-kit"
	timestamp:   "2026-07-28T18:53:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-159-completion-20260728"
		artifactSnapshotHash: "39f5f8abc2adbda4205584a32842da94b1e19ae1"
		gatesPassed: ["cue-vet", "yaml-parse", "verbatim-diff", "structural-runner", "check-self-review", "codegen-pipeline"]
	}
}]
