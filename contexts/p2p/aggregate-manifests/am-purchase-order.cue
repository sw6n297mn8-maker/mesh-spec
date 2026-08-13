package p2p

// am-purchase-order.cue -- AggregateManifest do agg-purchase-order
// (fatia da superficie do PO, missao M1/adr-193: o fecho da
// ds-buyer-procurement-journey -- emissao sob authority validada).
//
// Instancia de #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue,
// adr-144). Per adr-141 item 5: declara a SUPERFICIE do aggregate; "o aggregate
// base gerado deriva do AggregateManifest". Quinta instancia do tipo no disco
// (precedentes de forma: am-commitment, am-verification, am-payment,
// am-purchase-requisition).
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/p2p/domain-model.cue agg-purchase-order (handlesCommands/
// emitsEvents/protectsInvariants) -- existencia por construcao; diff
// programatico verificado no checkpoint (zero-drift).
//
// Com este manifest a fatia parcial do adr-178 completa a cobertura do BC:
// os dois aggregates do P2P tem manifest (a nota "manifest proprio quando a
// fatia da superficie do PO abrir" do am-purchase-requisition realizou-se).
//
// NOME DO CAMPO: primeiro BC com DOIS manifests no mesmo package — o campo
// top-level ganha nome unico por arquivo (aggregateManifestPurchaseOrder),
// convencao das familias multi-instancia do repo (adrs, defs), porque dois
// campos `aggregateManifest` no mesmo package instance colidem em cue vet.
// Consumidores por-arquivo (structural-check-runner load_artifact; codegen
// LoadSkeletonModel) desembrulham o unico campo top-level do arquivo.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifestPurchaseOrder: artifact_schemas.#AggregateManifest & {
	id:           "am-purchase-order"
	name:         "PurchaseOrder"
	aggregateRef: "agg-purchase-order"

	// 2 commands verbatim de agg-purchase-order.handlesCommands.
	commandsAccepted: [
		"cmd-emit-purchase-order",
		"cmd-cancel-purchase-order",
	]

	// 5 events verbatim de agg-purchase-order.emitsEvents: 2 published do
	// lifecycle do PO + 3 ACL internal -received de SSC (registrados no
	// event stream local; a traducao semantica e do ACL adapter -- per
	// Patch 2 founder, convencao mantida do domain-model).
	eventsEmitted: [
		"evt-purchase-order-emitted",
		"evt-purchase-order-cancelled",
		"evt-sourcing-decision-made-received",
		"evt-preferred-supplier-designated-received",
		"evt-strategic-award-completed-received",
	]

	// 6 invariants verbatim de agg-purchase-order.protectsInvariants
	// (o gate duplo da emissao: authority valida adr-177 + requisicao
	// approved adr-174; anti-mini-NIM; allocation em agregado; cancel
	// pre-formalization; lifecycle public events).
	invariants: [
		"inv-purchase-order-requires-valid-authority",
		"inv-emission-requires-approved-requisition",
		"inv-allocation-convergence-aggregate-level",
		"inv-cancellation-pre-formalization-only",
		"inv-no-supplier-revalidation-by-p2p",
		"inv-purchase-order-lifecycle-public-events",
	]

	// Coerente com pm-p2p: EventLogPort (persistencia OCC + replay do
	// agg-purchase-order; uso-forte). Os bracos cross-BC do gate de emissao
	// (prj-active-purchase-authorities + fallback sync QuerySourcingDecision/
	// ssc) e o lookup intra-BC da requisicao aprovada
	// (prj-pending-requisitions) sao interacoes de query-surface/projection
	// (adr-055/adr-120), nao Ports -- fora deste manifest.
	portsRequired: ["EventLogPort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do PurchaseOrder derivado deste manifest (adr-141 item 5): estados do lifecycle (requested, emitted, cancelled -- #PurchaseOrderState reusado dos schemas, disjuncao fechada), handlers dos 2 commands, emissao dos 5 events declarados, guards dos invariants das transicoes (o gate duplo da emissao + cancel pre-formalization)."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest). Com esta fatia o discovery do gerador (rtd-013) emite a superficie do PO -- o degrau runtime do fecho da ds-buyer-procurement-journey (missao M1)."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-purchase-order (per-aggregate, adr-141 item 5): 2 commands, 5 events e 6 invariants verbatim do domain-model do P2P (extracao com diff verificado no checkpoint). portsRequired coerente com pm-p2p (EventLogPort uso-forte; interacoes cross-BC do gate de emissao sao query-surfaces per adr-055, nao Ports). Quinta instancia do tipo; completa a cobertura de manifests do P2P iniciada pela fatia parcial do adr-178 -- semantica do PO ja decidida no domain-model, este manifest apenas abre a superficie de codegen (classe instanciacao) para o fecho da jornada (missao M1)."
}
