package ssc

// port-manifest.cue -- PortManifest do SSC (fatia WI-159: kit de superfície
// da cotação, molde adr-178).
//
// Instancia de #PortManifest (adr-144). Quinta instancia do tipo
// (precedentes: pm-cmt, pm-dlv, pm-fce, pm-p2p). EventLogPort per adr-141
// item 4 (PortManifest = SoT exclusiva da superficie de Port).
//
// A consulta a NPM (QueryParticipantStatus -- pool de qualificados na
// abertura + decision time) e interação sync de canvas query-dependency
// (adr-055) -- NÃO travessia de Port; fora por construção. EvidencePort
// FORA: o sourcing não custodia evidência.
//
// CANON: operations usam a grafia JA CANONICA do runtime -- EventLogPort
// per rtd-004 (mesh-runtime docs/decisions.md).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-ssc"
	boundedContextRef: "ssc"

	// EventLogPort: uso-forte (persistencia/replay do agg-sourcing-process).
	portsConsumed: ["EventLogPort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // grafia canonica (rtd-004)
		output:                                               "AppendResult"
		rationale:                                            "SSC appenda os 9 eventos do sourcing process (spine de decisão + lifecycle de RFQ + fatos internos de cotação + ACL-received) com optimistic concurrency -- a janela competitiva (cotações submetidas/retiradas durante open) e a conclusão exigem OCC read-then-write no stream da RFQ."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // grafia canonica (rtd-004)
		output:                             "EventStream"
		rationale:                          "SSC le o stream para (a) rehydration do agg-sourcing-process (RFQ + cotações nested); (b) as projections do BC (decisões ativas, decisão por id, histórico por categoria, mapa de cotações); (c) versao corrente para o ExpectedVersion do append (OCC read-then-write)."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) -- mesmo reference adapter de pm-cmt/pm-dlv/pm-fce/pm-p2p, ja materializado no mesh-runtime (eventlog-inmemory)."
		rationale:   "adr-141 item 6: reference adapter universal por Port; reuso declarado, zero codigo novo."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: kit por-Port JA EXISTENTE no mesh-runtime (gerado dos manifests; pm-ssc adiciona o 5o consumidor ao Port sem mudar a superficie -- dedupe por assinatura identica aos precedentes)."
	}]

	referenceAdapterRequired: true // o adapter ja existe no mesh-runtime; flag explicita por legibilidade (precedente pm-cmt..pm-p2p).

	rationale: "SSC consome EventLogPort (uso-forte: persistencia OCC + replay do agg-sourcing-process -- a janela competitiva de cotações e a conclusão exigem read-then-write). Quinta instancia de #PortManifest; com ela o discovery do gerador (rtd-013) passa a pegar o SSC -- o degrau runtime da fatia da cotação (WI-159). Consulta NPM e canvas query-dependency per adr-055, não Port -- fora por construção; EvidencePort fora (sourcing não custodia evidência). Adapter e suite Tier-1: REUSO declarado (dedupe por assinatura identica). Ativa sc-pmc-01/02/03 e sc-mri-01 para o quinto BC."
}
