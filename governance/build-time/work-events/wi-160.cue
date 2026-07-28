package work_events

// wi-160.cue — Lifecycle event-sourced de WI-160 (mapa de cotações — 3ª
// família do codegen de frontend + promoção do contrato a schema).
// Proposto pelo spec-writer na sessão 2026-07-28 do arco
// jornada→produção; aprovado pelo founder na mesma sessão (aprovação
// explícita em mensagem própria, precedendo esta escrita). Timestamps
// na granularidade da sessão.
//
// Claimado e completado na execução da própria fatia (2026-07-28, molde
// WI-156/159). Aprovação da escrita com 4 pontos do founder, todos
// honrados: (1) amendments dos Gates 2/3 do adr-180 confirmados
// (embedding; #ReadSurface união query/canvas; +2 affectedArtifacts;
// SETE stages); (2) confirmation.returnsEvents como lista ≥1 (fidelidade
// ao oneOf do resolve FCE); (3) os 5 would-have-asked do authoring
// aceitos como propostos; (4) sc-fcc-05 cobrindo activeBoundaries[] —
// resolvido como CHECK PRÓPRIO sc-fcc-06 (o shape do kind
// cross-file-id-exists tem referencePath singular; escolha reportada no
// checkpoint). Notas de execução reportadas no checkpoint: sc-fcc-01/02
// nascem com o kind mais próximo (regex-pattern-match) e a lacuna do
// runner (predicado condicional por item) nomeada; sc-fcc-03/04 nascem
// LATENTES (ev_item_scoped itera apenas listas; families é struct-keyed)
// com a lacuna nomeada; sc-fcc-05/06 exercitados com refs reais e dentes
// provados por bite-probe. PG via dispatch real disp-010 (entry
// append-only no subagent-execution-log; 2º pipeline completo). 4º SRR
// (sc-fcc) exigido pelo gate check-self-review na escrita — adicionado.
// gatesPassed reflete o verificável nesta sessão; structural-runner
// fechou em 29 warns pré-existentes / 0 bloqueantes (sc-fcc-01..06
// verdes na instância única — catraca verificada no ato); codegen
// inputs intocados pela fatia (schemas/domain-models/manifests sem
// mudança — pipeline do WI-159 permanece o estado válido).
// artifactSnapshotHash = git blob hash de
// governance/build-time/frontend-codegen-contract.cue (v3
// materializada).
streams: "WI-160": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-160"
	taskVersion: 1
	commandId:   "WI-160-propose-quotation-map-third-family"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-160"
	taskVersion: 1
	commandId:   "WI-160-approve-quotation-map-third-family"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-160"
	taskVersion:    1
	commandId:      "WI-160-claim-quotation-map-third-family"
	timestamp:      "2026-07-28T21:55:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-29T05:55:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-160"
	taskVersion: 1
	commandId:   "WI-160-complete-quotation-map-third-family"
	timestamp:   "2026-07-28T22:15:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-160-completion-20260728"
		artifactSnapshotHash: "9a3785d9fc5fe02028cce1a9f52141768e3066fd"
		gatesPassed: ["cue-vet", "yaml-parse", "adversarial-shape-probes", "structural-runner", "freshness-gate", "check-self-review"]
	}
}]
