package cmt

// port-manifest.cue -- PortManifest do CMT (WI-135 / W006-port-contract).
//
// Instancia de #PortManifest (architecture/artifact-schemas/port-manifest.cue,
// adr-144). EventLogPort (P7) modelado como PortManifest per adr-141 item 4
// (PortManifest = SoT exclusiva da superficie de Port; a interface Kotlin e
// projecao verificada em mesh-runtime, def-050). E o no minimo CMT-PortManifest
// do golden-example bilateral -- a aresta WI-137<-WI-135 exige real-options
// (golden-example depende so da fatia CMT, nao do fan-out WI-140).
//
// adapter-stub SPEC-SIDE = DECLARACAO (campo adaptersForGoldenExample); o codigo
// do adapter vive no mesh-runtime (codegen-contract committedHere:false; adr-141
// item 6). Nenhum codigo de adapter neste arquivo.
//
// CANON-PENDING: os nomes de value-class das operations (StreamId, EventBatch,
// ExpectedVersion, AppendResult, EventStream, FromVersion) sao provisorios -- o
// canon do mesh-runtime ainda nao foi materializado. Grafia a confirmar; grep
// "CANON-PENDING" lista todos os nomes a reconciliar quando o canon existir.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-cmt"
	boundedContextRef: "cmt"

	// Golden-example sobe atras do EventLogPort; cross-BC excluido (adr-138 dec 2).
	portsConsumed: ["EventLogPort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // CANON-PENDING: StreamId/EventBatch/ExpectedVersion -- grafia a confirmar contra canon mesh-runtime
		output:                                               "AppendResult" // CANON-PENDING: AppendResult -- grafia a confirmar contra canon mesh-runtime
		rationale:                                            "CMT appenda CommitmentProposed + CommitmentAccepted (aceite bilateral) ao event log com optimistic concurrency (ExpectedVersion). Value-class names CANON-PENDING."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // CANON-PENDING: StreamId/FromVersion -- grafia a confirmar contra canon mesh-runtime
		output:                             "EventStream" // CANON-PENDING: EventStream -- grafia a confirmar contra canon mesh-runtime
		rationale:                          "CMT le o stream do compromisso para verificar evidencia bilateral -- o runtimeGap de inv-mutual-bilateral-acceptance exige query ao event log. Value-class names CANON-PENDING."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) para o golden-example subir sem vendor. DECLARACAO spec-side; o codigo vive no mesh-runtime."
		rationale:   "adr-141 item 6: o reference adapter in-memory e o stub do golden-example e o oracle dos contract-tests; implementacao em mesh-runtime (fora deste repo)."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: Tier-1 derivado das obrigacoes do manifest + taxonomia de erro; converge com assertion-tests no mecanismo de def-049."
	}, {
		port:        "EventLogPort"
		tier:        2
		description: "Tier-2 (comportamental): optimistic concurrency do EventLogPort -- append com ExpectedVersion conflitante rejeita; append-only/single-writer por stream."
		rationale:   "adr-141 item 6: OCC e invariante comportamental que o schema nao captura -- hand-authored, fora do Tier-1 gerado."
	}]

	referenceAdapterRequired: true // explicito: golden-example e o template do fan-out; legibilidade > default implicito.

	rationale: "EventLogPort (P7) modelado como PortManifest (adr-141 item 4: PortManifest = SoT exclusiva da superficie de Port). No minimo CMT-PortManifest do golden-example bilateral (WI-135; aresta WI-137<-WI-135 preservada, real-options). adapter-stub spec-side e DECLARACAO (codigo em mesh-runtime; codegen-contract committedHere:false). Value-class names das operations CANON-PENDING (grafia a confirmar contra canon mesh-runtime). Ativa 4 structural-checks verde: sc-pmc-01/02/03 (todo .port=EventLogPort em portsConsumed) + sc-mri-01 (boundedContextRef cmt em context-map)."
}
