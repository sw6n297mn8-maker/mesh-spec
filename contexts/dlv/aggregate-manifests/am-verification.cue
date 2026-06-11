package dlv

// am-verification.cue -- AggregateManifest do agg-verification (WI-140 fatia-2).
//
// Instancia de #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue,
// adr-144). Per adr-141 item 5: declara a SUPERFICIE do aggregate (commands aceitos,
// events emitidos, invariants, Ports requeridos, generated artifacts); "o aggregate
// base gerado deriva do AggregateManifest". Segunda instancia do tipo no disco
// (precedente de forma: am-commitment).
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/dlv/domain-model.cue agg-verification (handlesCommands/emitsEvents/
// protectsInvariants) -- existencia por construcao (gapPolicy do PG: id
// inexistente e contrato fantasma; def-052 e o gate deferido da existencia).
// Extracao programatica via cue export (diff verificado no checkpoint).
//
// NOTA DE FATIA: a geracao do aggregate-skeleton do DLV ocorre no pacote-runtime
// da fatia-2, APOS a generalizacao da toolchain (hoje ancorada no CMT) -- este
// manifest e o input declarado; a execucao do stage e downstream.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-verification"
	name:         "Verification"
	aggregateRef: "agg-verification"

	// 3 commands verbatim de agg-verification.handlesCommands (2 user-invoked
	// + 1 timer-driven internal).
	commandsAccepted: [
		"cmd-record-evidence",
		"cmd-evaluate-verification",
		"cmd-transition-exception-state",
	]

	// 7 events verbatim de agg-verification.emitsEvents.
	eventsEmitted: [
		"evt-evidence-recorded",
		"evt-delivery-verified",
		"evt-delivery-rejected",
		"evt-exception-entered",
		"evt-exception-extended",
		"evt-exception-resolved",
		"evt-supersession-applied",
	]

	// 14 invariants verbatim de agg-verification.protectsInvariants.
	invariants: [
		"inv-identity-uniqueness",
		"inv-criteria-version-as-attribute",
		"inv-identity-immutable-across-state",
		"inv-binary-outcome",
		"inv-rejected-requires-rationale",
		"inv-retry-path-deterministic",
		"inv-verified-requires-evidence-or-override",
		"inv-post-finality-no-autonomous-emit",
		"inv-finality-at-computed",
		"inv-exception-cumulative-cap",
		"inv-at-most-one-active-exception",
		"inv-exception-timer-mandatory",
		"inv-supersession-ordering",
		"inv-replay-determinism",
	]

	// Coerente com pm-dlv: EventLogPort (persistencia OCC + replay; uso-forte)
	// + EvidencePort (deep check BD9, opcional Phase 0 com fail-safe fallback,
	// ressalva explicita no pm-dlv).
	portsRequired: ["EventLogPort", "EvidencePort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do Verification derivado deste manifest (adr-141 item 5: 'o aggregate base gerado deriva do AggregateManifest'): estados do lifecycle (evaluating, exception-pending, verified, rejected), handlers dos 3 commands, emissao dos 7 events declarados, guards dos 14 invariants."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest). A geracao para o DLV e downstream do pacote-runtime da fatia-2 (generalizacao da toolchain, hoje ancorada no CMT) -- o manifest declara o input; o stage executa la."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-verification (per-aggregate, adr-141 item 5): 3 commands, 7 events e 14 invariants verbatim do domain-model do DLV (extracao programatica; diff verificado). portsRequired coerente com pm-dlv (EventLogPort uso-forte + EvidencePort deep check BD9 com ressalva opcional-Phase-0). Segunda instancia do tipo (precedente am-commitment); ativa sc-mri-02 para o DLV (aggregateRef verificado em aggregates[].code). Fatia-2 de WI-140 (claim registrado no stream wi-140) -- NAO conclui o WI: manifests dos demais BCs/aggregates pendentes; fatia-1 (am-commitment) foi executada pre-registro do motor, nota no stream."
}
