package p2p

// am-purchase-requisition.cue -- AggregateManifest do agg-purchase-requisition
// (fatia adr-178: kit de superfície do início da jornada).
//
// Instancia de #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue,
// adr-144). Per adr-141 item 5: declara a SUPERFICIE do aggregate; "o aggregate
// base gerado deriva do AggregateManifest". Quarta instancia do tipo no disco
// (precedentes de forma: am-commitment, am-verification, am-payment).
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/p2p/domain-model.cue agg-purchase-requisition (handlesCommands/
// emitsEvents/protectsInvariants) -- existencia por construcao; diff
// programatico verificado no checkpoint (zero-drift).
//
// FATIA PARCIAL (precedente FCE/WI-140): cobre APENAS o agg-purchase-
// requisition (o recorte do início da jornada, adr-178). O agg-purchase-order
// fica FORA -- manifest proprio quando a fatia da superficie do PO abrir.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-purchase-requisition"
	name:         "PurchaseRequisition"
	aggregateRef: "agg-purchase-requisition"

	// 5 commands verbatim de agg-purchase-requisition.handlesCommands.
	commandsAccepted: [
		"cmd-submit-purchase-requisition",
		"cmd-triage-requisition",
		"cmd-approve-purchase",
		"cmd-convert-requisition",
		"cmd-cancel-purchase-requisition",
	]

	// 6 events verbatim de agg-purchase-requisition.emitsEvents.
	eventsEmitted: [
		"evt-purchase-requisition-submitted",
		"evt-purchase-requisition-triaged",
		"evt-purchase-approved",
		"evt-purchase-approval-rejected",
		"evt-purchase-requisition-converted",
		"evt-purchase-requisition-cancelled",
	]

	// 3 invariants verbatim de agg-purchase-requisition.protectsInvariants
	// (completude na triagem WI-151 + os DOIS braços do portão de aprovação:
	// cobertura bdg adr-174 + procedência de preço ssc adr-177).
	invariants: [
		"inv-requisition-completeness",
		"inv-approval-requires-coverage-reservation",
		"inv-approval-amount-matches-winning-quotation",
	]

	// Coerente com pm-p2p: EventLogPort (persistencia OCC + replay do
	// agg-purchase-requisition; uso-forte). Os braços cross-BC do portão
	// (QueryBudgetApprovalStatus/bdg, QueryQuotationMap/ssc) são interações
	// sync de canvas query-surface (adr-055), não Ports -- fora deste manifest.
	portsRequired: ["EventLogPort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton da PurchaseRequisition derivado deste manifest (adr-141 item 5): estados do lifecycle (submitted, triaged, approved, converted, rejected, cancelled -- #PurchaseRequisitionState reusado dos schemas, disjuncao fechada), handlers dos 5 commands, emissao dos 6 events declarados, guards das 3 invariants (incl. os dois braços do portão duplo)."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest). Com esta fatia o discovery do gerador (rtd-013) passa a pegar o P2P (schemas + manifests presentes) -- o degrau runtime do arco de telas do início da jornada (adr-178)."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-purchase-requisition (per-aggregate, adr-141 item 5): 5 commands, 6 events e 3 invariants verbatim do domain-model do P2P (extracao com diff verificado no checkpoint). portsRequired coerente com pm-p2p (EventLogPort uso-forte; interações sync do portão duplo são canvas query-surfaces per adr-055, não Ports). Quarta instancia do tipo (precedentes am-commitment, am-verification, am-payment); ativa sc-mri-02 para o P2P (aggregateRef verificado em aggregates[].code). Fatia parcial per adr-178 (recorte do início da jornada) -- o agg-purchase-order ganha manifest proprio na fatia da superficie do PO."
}
