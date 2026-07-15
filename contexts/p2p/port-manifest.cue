package p2p

// port-manifest.cue -- PortManifest do P2P (fatia adr-178: kit de superfície
// do início da jornada).
//
// Instancia de #PortManifest (architecture/artifact-schemas/port-manifest.cue,
// adr-144). Quarta instancia do tipo (precedentes: pm-cmt, pm-dlv, pm-fce).
// EventLogPort modelado per adr-141 item 4 (PortManifest = SoT exclusiva da
// superficie de Port; interface Kotlin e projecao verificada em mesh-runtime,
// def-050).
//
// RECORTE (adr-178): o manifest nasce com o consumo do agg-purchase-
// requisition (persistencia OCC + replay). Os braços cross-BC do portão de
// aprovação (QueryBudgetApprovalStatus/bdg, QueryQuotationMap/ssc, adr-055)
// e o fallback QuerySourcingDecision da emissão são interações sync de
// canvas query-surface -- NÃO travessia de Port; ficam fora por construção.
// EvidencePort FORA desta fatia: a requisição não custodia evidência.
// Quando a fatia da superficie do agg-purchase-order abrir, este manifest
// expande (mesmo arquivo, per-BC).
//
// CANON: operations usam a grafia JA CANONICA do runtime -- EventLogPort
// per rtd-004 (mesh-runtime docs/decisions.md).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-p2p"
	boundedContextRef: "p2p"

	// EventLogPort: uso-forte (persistencia/replay do agg-purchase-requisition).
	portsConsumed: ["EventLogPort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // grafia canonica (rtd-004)
		output:                                               "AppendResult"
		rationale:                                            "P2P appenda os 6 eventos da requisição (Submitted/Triaged/Approved/ApprovalRejected/Converted/Cancelled) com optimistic concurrency -- os pares colidentes de triagem e aprovação (selectors per adr-160) e os guards do portão duplo (adr-174/adr-177) dependem de OCC read-then-write no stream da requisição."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // grafia canonica (rtd-004)
		output:                             "EventStream"
		rationale:                          "P2P le o stream para (a) rehydration do agg-purchase-requisition; (b) a projeção prj-pending-requisitions (a fila de triagem/aprovação que o GET da superfície serve, adr-178); (c) versao corrente para o ExpectedVersion do append (OCC read-then-write)."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) -- mesmo reference adapter de pm-cmt/pm-dlv/pm-fce, ja materializado no mesh-runtime (eventlog-inmemory)."
		rationale:   "adr-141 item 6: reference adapter universal por Port; reuso declarado, zero codigo novo."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: kit por-Port JA EXISTENTE no mesh-runtime (gerado dos manifests; pm-p2p adiciona o 4o consumidor ao Port sem mudar a superficie -- dedupe por assinatura identica a pm-cmt/pm-dlv/pm-fce)."
	}]

	referenceAdapterRequired: true // o adapter ja existe no mesh-runtime; flag explicita por legibilidade (precedente pm-cmt/pm-dlv/pm-fce).

	rationale: "P2P consome EventLogPort (uso-forte: persistencia OCC + replay do agg-purchase-requisition -- selectors colidentes adr-160 e guards do portão duplo adr-174/adr-177 exigem read-then-write). Quarta instancia de #PortManifest (precedentes pm-cmt, pm-dlv, pm-fce); com ela o discovery do gerador (rtd-013) passa a pegar o P2P -- o degrau runtime do arco de telas (adr-178). Interações sync cross-BC do portão (bdg/ssc) são canvas query-surfaces per adr-055, não Ports -- fora por construção; EvidencePort fora (requisição não custodia evidência). Adapter e suite Tier-1: REUSO declarado do ja materializado (dedupe por assinatura identica). Ativa sc-pmc-01/02/03 e sc-mri-01 para o quarto BC. Fatia parcial per adr-178 -- expande quando a superficie do agg-purchase-order abrir."
}
