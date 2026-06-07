package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// manifest-conformance.cue — Familia de structural-checks de well-formedness do
// PortManifest (adr-144 item 5, familia manifest-conformance; c-puro). 3 checks
// kind local-field-reference-integrity (intra-arquivo): toda operation, contract-
// test e adapter/stub referencia um Port que o BC de fato declara consumir
// (portsConsumed). Spec-side puro -- NENHUMA referencia a interface Kotlin,
// mesh-runtime ou def-050 (a conformance interface<->manifest e cross-repo, fora
// destes checks). Dormant-safe: 0 instancias de PortManifest -> 0 violacoes
// (nasce verde-vacuo ate WI-140 materializar manifests). enforcement default
// "warn" (born-warn per #StructuralCheck schema).

structuralChecks: "sc-pmc-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-pmc-01"
	title:        "PortManifest.operations[].port subconjunto de portsConsumed"
	artifactType: "port-manifest"
	description:  "Cada operations[].port pertence a portsConsumed. Operation sobre Port que o BC nao declara consumir e contrato fantasma -- manifest internamente incoerente. Intra-arquivo (local-field-reference-integrity); nao toca a interface Kotlin (def-050)."
	kind:         "local-field-reference-integrity"
	rule: {
		referencePath: "operations[].port"
		namespacePath: "portsConsumed[]"
	}
	errorMessage: "PortManifest: operations[].port referencia um Port ausente de portsConsumed. Adicione o Port a portsConsumed ou remova a operation. (well-formedness spec-side; materializa tq-pm-01.)"
	rationale:    "Materializa tq-pm-01 do #PortManifest como gate deterministico (adr-144 item 5, familia manifest-conformance). A coerencia operation<->portsConsumed e verificavel intra-arquivo, sem a interface runtime (c-puro). Born-green: zero PortManifest no disco hoje."
}

structuralChecks: "sc-pmc-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-pmc-02"
	title:        "PortManifest.contractTestsRequired[].port subconjunto de portsConsumed"
	artifactType: "port-manifest"
	description:  "Cada contractTestsRequired[].port pertence a portsConsumed. Obrigacao de contract-test sobre Port nao-consumido e incoerente. Intra-arquivo (local-field-reference-integrity); nao toca a interface Kotlin (def-050)."
	kind:         "local-field-reference-integrity"
	rule: {
		referencePath: "contractTestsRequired[].port"
		namespacePath: "portsConsumed[]"
	}
	errorMessage: "PortManifest: contractTestsRequired[].port referencia um Port ausente de portsConsumed. Alinhe a portsConsumed ou remova a obrigacao de teste. (well-formedness spec-side; materializa tq-pm-02.)"
	rationale:    "Materializa parte de tq-pm-02 do #PortManifest (obrigacoes de teste so para Ports consumidos) como gate deterministico, familia manifest-conformance (adr-144 item 5). Born-green: zero PortManifest no disco hoje."
}

structuralChecks: "sc-pmc-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-pmc-03"
	title:        "PortManifest.adaptersForGoldenExample[].port subconjunto de portsConsumed"
	artifactType: "port-manifest"
	description:  "Cada adaptersForGoldenExample[].port pertence a portsConsumed. Stub/adapter de golden-example sobre Port nao-consumido e incoerente. Intra-arquivo (local-field-reference-integrity); nao toca a interface Kotlin (def-050)."
	kind:         "local-field-reference-integrity"
	rule: {
		referencePath: "adaptersForGoldenExample[].port"
		namespacePath: "portsConsumed[]"
	}
	errorMessage: "PortManifest: adaptersForGoldenExample[].port referencia um Port ausente de portsConsumed. Alinhe a portsConsumed ou remova o stub/adapter. (well-formedness spec-side; materializa tq-pm-02.)"
	rationale:    "Materializa parte de tq-pm-02 do #PortManifest (stubs/adapters de golden-example so para Ports consumidos) como gate deterministico, familia manifest-conformance (adr-144 item 5). Born-green: zero PortManifest no disco hoje."
}
