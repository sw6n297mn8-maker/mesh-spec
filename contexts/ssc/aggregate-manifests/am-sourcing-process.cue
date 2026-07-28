package ssc

// am-sourcing-process.cue -- AggregateManifest do agg-sourcing-process
// (fatia WI-159: kit de superfície do ssc, molde adr-178).
//
// Instancia de #AggregateManifest (adr-144). Per adr-141 item 5: declara a
// SUPERFICIE do aggregate. Quinta instancia do tipo (precedentes:
// am-commitment, am-verification, am-payment, am-purchase-requisition).
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/ssc/domain-model.cue agg-sourcing-process (handlesCommands/
// emitsEvents/protectsInvariants) -- diff programatico no checkpoint
// (zero-drift). COBERTURA COMPLETA: o ssc tem 1 aggregate central; o
// manifest nasce inteiro (diferente da fatia parcial do p2p).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-sourcing-process"
	name:         "SourcingProcess"
	aggregateRef: "agg-sourcing-process"

	// 8 commands verbatim de agg-sourcing-process.handlesCommands.
	commandsAccepted: [
		"cmd-open-rfq",
		"cmd-submit-quotation",
		"cmd-withdraw-quotation",
		"cmd-make-one-shot-sourcing-decision",
		"cmd-designate-preferred-supplier",
		"cmd-complete-strategic-award",
		"cmd-cancel-rfq",
		"cmd-revalidate-rfq-pool",
	]

	// 9 events verbatim de agg-sourcing-process.emitsEvents.
	eventsEmitted: [
		"evt-sourcing-decision-made",
		"evt-preferred-supplier-designated",
		"evt-strategic-award-completed",
		"evt-rfq-opened",
		"evt-rfq-concluded",
		"evt-rfq-cancelled",
		"evt-quotation-submitted",
		"evt-quotation-withdrawn",
		"evt-network-participant-status-changed-received",
	]

	// 7 invariants verbatim de agg-sourcing-process.protectsInvariants.
	invariants: [
		"inv-decision-from-structured-signals",
		"inv-decision-type-declared-upfront",
		"inv-qualification-as-precondition",
		"inv-decision-rationale-required",
		"inv-rfq-public-lifecycle-events",
		"inv-competitive-pool-or-supervised-exception",
		"inv-fitness-rules-versioned-config",
	]

	// Coerente com pm-ssc: EventLogPort (persistencia OCC + replay do
	// agg-sourcing-process; uso-forte). A consulta a NPM
	// (QueryParticipantStatus, pool + decision time) é interação sync de
	// canvas query-dependency (adr-055), não Port -- fora deste manifest.
	portsRequired: ["EventLogPort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do SourcingProcess derivado deste manifest (adr-141 item 5): estados do lifecycle (open, concluded, cancelled -- disjuncao fechada), handlers dos 8 commands, emissao dos 9 events declarados, guards das 7 invariants. Criacao via initialState=open (cmd-open-rfq e nascimento-com-evento; #Lifecycle nao tem create transition -- mesmo padrao do submit p2p)."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract. Com esta fatia o discovery do gerador (rtd-013) passa a pegar o SSC (schemas + manifests presentes) -- o degrau runtime da fatia da cotacao (WI-159), pre-requisito do mapa (WI-160)."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-sourcing-process (per-aggregate, adr-141 item 5): 8 commands, 9 events e 7 invariants verbatim do domain-model do SSC (extracao com diff verificado no checkpoint). portsRequired coerente com pm-ssc (EventLogPort uso-forte; consulta NPM e canvas query-dependency per adr-055, nao Port). Quinta instancia do tipo; ativa sc-mri-02 para o SSC. Cobertura COMPLETA do BC (1 aggregate central) -- sem fatia parcial a expandir."
}
