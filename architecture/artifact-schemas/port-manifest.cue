package artifact_schemas

import "list"

// port-manifest.cue — Schema para PortManifest (governanca de manifests, adr-144).
//
// PortManifest e a SoT spec-side da superficie de Port consumida por um BC
// (adr-141 item 5; O1-split materializado em adr-144). Per-BC: cada BC que
// consome >=1 Port canonico tem um PortManifest (true-coverage, deferida a def-051).
//
// c-puro (adr-144): a conformance interface-Kotlin <-> PortManifest vive em
// mesh-runtime (def-050) -- fora deste schema. O lado spec governa
// well-formedness do manifest (operations ligadas a Ports consumidos,
// nao-vacuidade) e ref-integrity (manifest-ref-integrity); a true-coverage e deferida a def-051.
//
// Campos derivam literalmente de adr-141 item 5 ("PortManifest declara: Ports
// consumidos, operations necessarias, adapters/stubs exigidos para o
// golden-example, contract-tests obrigatorios, requisito de reference adapter").

// Os 5 Ports canonicos do runtime kernel (adr-141 item 2 / P7). Localizacao
// canonica unica do enum (P0); #AggregateManifest referencia o mesmo #PortRef.
#PortRef: "EventLogPort" | "LedgerPort" | "WorkflowPort" | "DeliveryPort" | "EvidencePort"

#PortManifest: {
	// Identificador do manifest: pm-<slug> (tipicamente o code do BC consumidor).
	id: string & =~"^pm-[a-z0-9-]+$"

	// BC consumidor (per-BC). Identidade explicita para manifest-ref-integrity (C5)
	// parear via cross-file-id-exists; path-based puro daria falso-negativo se o BC
	// fosse renomeado. Espelha service-contract.cue.
	boundedContextRef: #BoundedContextRef

	// "Ports consumidos" (item 5) -- subconjunto dos 5 Ports. Constraint NATIVA
	// via #PortRef + UniqueItems; >=1 porque o manifest existe pelo consumo.
	portsConsumed: [#PortRef, ...#PortRef] & list.UniqueItems

	// "operations necessarias" (item 5) -- superficie bem-formada por Port.
	operations: [...#PortOperation]

	// "adapters/stubs exigidos para o golden-example" (item 5) -- o que o
	// golden-example precisa para subir atras dos Ports (adr-141 item 6).
	adaptersForGoldenExample: [...#AdapterStubRequirement]

	// "contract-tests obrigatorios" (item 5) -- Tier 1 (gerado) / Tier 2
	// (comportamental) por Port (adr-141 item 6).
	contractTestsRequired: [...#ContractTestRequirement]

	// "requisito de reference adapter" (item 5) -- obrigacao declarada in-spec
	// (adr-141 item 6); a implementacao do adapter vive em mesh-runtime.
	referenceAdapterRequired: bool | *true

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/port-manifest\\.cue$"
			fileNameRegex:      "^port-manifest\\.cue$"
			description:        "PortManifest: superficie spec-side de Port consumida por um BC (per-BC), SoT da qual a interface Kotlin e projecao verificada (verificacao em mesh-runtime, def-050)."
			rationale:          "Vive na raiz do BC (contexts/{bc}/) junto a service-contract/canvas/domain-model porque e per-BC; a true-coverage (BC->manifest pela path) e deferida a def-051."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-pm-01"
			description: "Operations referenciam Port declarado em portsConsumed"
			test:        "Cada operations[].port pertence a portsConsumed. Operation sobre Port que o BC nao declara consumir e contrato fantasma -- manifest internamente incoerente."
			severity:    "fail"
			rationale:   "Well-formedness spec-side (adr-144 c-puro): a coerencia operation<->portsConsumed e verificavel sem a interface runtime."
		}, {
			id:          "tq-pm-02"
			description: "contract-tests e adapters/stubs referenciam Port consumido"
			test:        "Cada contractTestsRequired[].port e cada adaptersForGoldenExample[].port pertence a portsConsumed. Obrigacao de teste/stub sobre Port nao-consumido e incoerente."
			severity:    "fail"
			rationale:   "Well-formedness spec-side: obrigacoes de teste/adapter so fazem sentido para Ports que o BC consome."
		}]
		rationale: "Criterios cobrem well-formedness spec-side do PortManifest (adr-144 c-puro): coerencia interna operation/test/adapter <-> portsConsumed. A conformance interface-Kotlin <-> manifest e cross-repo (def-050), fora destes criterios."
	}
}

// Operation de Port: nome + tipos-canon in/out. inputs/output sao nomes de
// value class (canon, mesh-runtime) referenciados como string -- nao unificacao
// CUE (o canon nao e CUE-referenciavel global; adr-144 c-puro). PortResult<T>
// envelopa a saida no runtime (adr-141 item 2) -- nao modelado aqui.
#PortOperation: {
	port: #PortRef
	name: string & =~"^[a-z][a-zA-Z0-9]*$"
	inputs: [...string & !=""]
	output:    string & !=""
	rationale: string & !=""
}

// Stub/adapter exigido para o golden-example subir atras de um Port.
#AdapterStubRequirement: {
	port:        #PortRef
	description: string & !=""
	rationale:   string & !=""
}

// Contract-test obrigatorio por Port. tier 1 = gerado (derivado do manifest +
// taxonomia de erro); tier 2 = hand-authored comportamental (adr-141 item 6).
#ContractTestRequirement: {
	port:        #PortRef
	tier:        1 | 2
	description: string & !=""
	rationale:   string & !=""
}
