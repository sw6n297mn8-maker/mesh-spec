package cmt

// am-commitment.cue -- AggregateManifest do agg-commitment (fatia cirurgica de WI-140).
//
// Instancia de #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue,
// adr-144). Per adr-141 item 5: AggregateManifest declara a SUPERFICIE do aggregate
// (commands aceitos, events emitidos, invariants, Ports requeridos, generated artifacts);
// "o aggregate base gerado deriva do AggregateManifest". E o input declarado do stage
// aggregate-skeleton do codegen-contract (governance/build-time/codegen-contract.cue,
// transform: from AggregateManifest).
//
// Precedente de forma: pm-cmt (contexts/cmt/port-manifest.cue, WI-135). Distincao
// DELIBERADA: pm-cmt e per-BC e declara a FATIA (Ports da fatia core-first); este
// manifest e per-AGGREGATE e declara a superficie COMPLETA do agg-commitment --
// o ge-cmt (golden-example) RECORTA dela a transicao proposed->accepted.
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/cmt/domain-model.cue agg-commitment (handlesCommands/emitsEvents/
// protectsInvariants) -- existencia por construcao (gapPolicy do PG: id
// inexistente e contrato fantasma; def-052 e o gate deferido da existencia).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-commitment"
	name:         "Commitment"
	aggregateRef: "agg-commitment"

	// 8 commands verbatim de agg-commitment.handlesCommands.
	commandsAccepted: [
		"cmd-propose-commitment",
		"cmd-confirm-commitment-acceptance",
		"cmd-flag-at-risk",
		"cmd-clear-risk-flag",
		"cmd-suspend-commitment",
		"cmd-reactivate-commitment",
		"cmd-cancel-commitment",
		"cmd-handle-dispute-resolution",
	]

	// 11 events verbatim de agg-commitment.emitsEvents (incluindo os sinais
	// ACL *-received/*-signaled -- fidelidade ao domain-model, sem filtrar).
	eventsEmitted: [
		"evt-commitment-proposed",
		"evt-commitment-accepted",
		"evt-commitment-state-changed",
		"evt-counterparty-risk-signaled",
		"evt-dispute-resolved-received",
		"evt-suspension-ordered-received",
		"evt-counterparty-risk-cleared",
		"evt-purchase-order-received",
		"evt-contract-terms-activated-received",
		"evt-contract-terms-superseded-received",
		"evt-contract-terms-cancelled-received",
	]

	// 9 invariants verbatim de agg-commitment.protectsInvariants.
	invariants: [
		"inv-mutual-bilateral-acceptance",
		"inv-terms-reference-valid",
		"inv-commitment-id-uniqueness",
		"inv-proposer-counterparty-distinct",
		"inv-suspension-requires-supervision",
		"inv-cancellation-irreversible",
		"inv-reactivation-requires-supervision",
		"inv-cancelled-is-terminal",
		"inv-dispute-modify-terms-revalidates-ctr",
	]

	// Coerente com pm-cmt (fatia core-first, adr-138): o lifecycle do commitment
	// persiste e le evidencia via event log; demais Ports fora da dependencia atual.
	portsRequired: ["EventLogPort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do Commitment derivado deste manifest (adr-141 item 5: 'o aggregate base gerado deriva do AggregateManifest'): estados do lifecycle, handlers dos commands aceitos, emissao dos events declarados, guards dos invariants."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest); o ge-cmt declara este kind em codegenTarget.kinds e o recorta na transicao proposed->accepted."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-commitment (per-aggregate, adr-141 item 5): 8 commands, 11 events e 9 invariants verbatim do domain-model do CMT; o ge-cmt (golden-example) RECORTA desta superficie a transicao proposed->accepted -- a distincao com pm-cmt (per-BC, que declara a FATIA de Ports core-first) e deliberada. Input real do stage aggregate-skeleton do codegen-contract (o stage declara from AggregateManifest; esta e a primeira instancia do tipo no disco). Ativa sc-mri-02 (sai do verde-vacuo: aggregateRef verificado em aggregates[].code). Fatia cirurgica de WI-140 -- NAO conclui o WI (manifests dos demais BCs/aggregates pendentes de autoria)."
}
