package fce

// am-payment.cue -- AggregateManifest do agg-payment (WI-140 fatia FCE).
//
// Instancia de #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue,
// adr-144). Per adr-141 item 5: declara a SUPERFICIE do aggregate; "o aggregate
// base gerado deriva do AggregateManifest". Terceira instancia do tipo no disco
// (precedentes de forma: am-commitment, am-verification).
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/fce/domain-model.cue agg-payment (handlesCommands/emitsEvents/
// protectsInvariants) -- existencia por construcao; diff programatico
// verificado no checkpoint (zero-drift invariantes<->manifest).
//
// NOTA DE FATIA: fatia FCE do WI-140 (claim WI-140-claim-fatia-fce) -- NAO
// conclui o WI (manifests dos demais BCs/aggregates pendentes). eventsEmitted
// tem 3 (NAO inclui evt-payment-obligation-defaulted: evento de CATALOGO sem
// emissor na fatia -- o fluxo de default esta fora, T2 do domain-model).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-payment"
	name:         "Payment"
	aggregateRef: "agg-payment"

	// 4 commands verbatim de agg-payment.handlesCommands.
	commandsAccepted: [
		"cmd-materialize-payment",
		"cmd-authorize-payment",
		"cmd-dispatch-payment-instruction",
		"cmd-settle-payment",
	]

	// 3 events verbatim de agg-payment.emitsEvents (Defaulted fora — catalogo).
	eventsEmitted: [
		"evt-payment-authorized",
		"evt-payment-instruction-dispatched",
		"evt-payment-settled",
	]

	// 5 invariants verbatim de agg-payment.protectsInvariants (subconjunto
	// declarado das 11 do Payment — header do domain-model).
	invariants: [
		"inv-money-moves-only-on-proof",
		"inv-guard-deterministic",
		"inv-at-most-once-dispatch",
		"inv-no-partial-settlement",
		"inv-settled-fact-canonical",
	]

	// Coerente com pm-fce: EventLogPort (persistencia OCC + replay do
	// agg-payment; uso-forte) + EvidencePort (verify-only — condicao (c) do
	// PrePaymentGuard; justificativa no pm-fce).
	portsRequired: ["EventLogPort", "EvidencePort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do Payment derivado deste manifest (adr-141 item 5): estados do lifecycle (guarded, authorized, dispatched, settled — #PaymentState reusado dos schemas, disjuncao fechada), handlers dos 4 commands, emissao dos 3 events declarados, guards das 5 invariants."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest). Com esta fatia o discovery do gerador passa a pegar o FCE (schemas + manifests presentes, rtd-013); a compilacao do modulo fce-generated e downstream do proximo pacote-runtime (build.gradle.kts hand + baseline FF-CG-03)."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-payment (per-aggregate, adr-141 item 5): 4 commands, 3 events e 5 invariants verbatim do domain-model do FCE (extracao com diff verificado; eventsEmitted exclui o evento de catalogo evt-payment-obligation-defaulted, sem emissor na fatia). portsRequired coerente com pm-fce (EventLogPort uso-forte + EvidencePort verify-only para a condicao (c) do PrePaymentGuard). Terceira instancia do tipo; ativa sc-mri-02 para o FCE (aggregateRef verificado em aggregates[].code). Fatia FCE de WI-140 (claim registrado no stream) -- NAO conclui o WI."
}
