package work_events

// wi-161.cue — Lifecycle event-sourced de WI-161 (modelagem da
// negociação no ssc, passo 8 da story). Proposto pelo spec-writer na
// sessão 2026-07-28 do arco jornada→produção; aprovado pelo founder na
// mesma sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
//
// Claimado e completado na execução da própria fatia (2026-07-28, molde
// WI-156/159/160). Aprovação da escrita com as 3 calibrações
// confirmadas como recomendadas: (1) cmd-decline-counter-terms MANTIDO;
// (2) vo-payment-terms com termScheduleDays lista NÃO-VAZIA e
// ESTRITAMENTE CRESCENTE (invariante de handler); (3)
// cmd-submit-quotation estendido com paymentTerms/deliverySchedule
// opcionais. Adição do founder ao checkpoint honrada: fields por EVENTO
// (os 3 novos) reportados verbatim — a fidelidade command→event não tem
// gate mecânico e entrou no reporte por isso (extração programática via
// cue export). Classificação: instanciação (sem ADR novo, precedente
// WI-152; sem número novo de família — G2 vazio, G1 verificado).
// Authoring manual declarado (precedente WI-151/152/adr-177 para
// updates; dispatch é para criação de instância). verbatim-diff do am
// contra o bloco canônico do agg: commands/events/invariants OK
// (11/12/8). Runner estrutural: 29 warns pré-existentes / 0 bloqueantes
// (sc-ds-04/05/07/08 mordem as refs novas do passo 8 e ficam verdes no
// mesmo commit; sc-ag-01/02 verdes com a coevolução do agent-spec;
// sc-fct-01 sem acusação — 6 conceitos novos como pendências
// reconhecidas na worklist, mesmo regime WI-159). Superfície (GET do
// mapa com rodadas; espelhos em schemas/events.cue) fica para fatia
// própria — declarado no perímetro da proposta. artifactSnapshotHash =
// git blob hash de contexts/ssc/domain-model.cue materializado.
streams: "WI-161": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-161"
	taskVersion: 1
	commandId:   "WI-161-propose-negotiation-modeling"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-161"
	taskVersion: 1
	commandId:   "WI-161-approve-negotiation-modeling"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-161"
	taskVersion:    1
	commandId:      "WI-161-claim-negotiation-modeling"
	timestamp:      "2026-07-28T23:20:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-29T07:20:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-161"
	taskVersion: 1
	commandId:   "WI-161-complete-negotiation-modeling"
	timestamp:   "2026-07-28T23:45:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-161-completion-20260728"
		artifactSnapshotHash: "f9a11c6fc9dffebfd2dc7753f812a16df2e1fab1"
		gatesPassed: ["cue-vet", "verbatim-diff", "command-event-fidelity-report", "structural-runner", "freshness-gate", "check-self-review"]
	}
}]
