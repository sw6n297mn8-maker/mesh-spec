package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// manifest-ref-integrity.cue — Familia de structural-checks de integridade
// referencial cross-file dos manifests (adr-144 item 5, familia manifest-ref-
// integrity). 2 checks kind cross-file-id-exists: a ref estrutural de cada
// manifest aponta para uma entidade que existe. PLAIN (existencia na uniao
// global dos arquivos-alvo) por escolha explicita do item 5; o aperto para
// instance-scoped (same-BC, kind instance-scoped-cross-file-id-exists per
// adr-113) e rastreado em def-052 (escopo ampliado: a decisao plain-vs-instance-
// scoped cobre TODOS os cross-file checks de manifest). Dormant-safe: 0
// instancias -> 0 violacoes. enforcement default "warn" (born-warn).

structuralChecks: "sc-mri-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-mri-01"
	title:        "PortManifest.boundedContextRef aponta BC existente"
	artifactType: "port-manifest"
	description:  "boundedContextRef existe em strategic/context-map.cue contexts[].context. Espelha sc-sv-01 (service-contract), padrao provado de ref por id cross-file (cue vet valida o formato, nao a existencia semantica do BC no mapa global)."
	kind:         "cross-file-id-exists"
	rule: {
		referencePath: "boundedContextRef"
		targetGlob:    "strategic/context-map.cue"
		targetIdPath:  "contexts[].context"
	}
	errorMessage: "PortManifest: boundedContextRef nao corresponde a nenhum context declarado em context-map.contexts[].context. Declare o BC no context-map ou corrija o ref."
	rationale:    "adr-144 item 5 (familia manifest-ref-integrity): um PortManifest pertence a um BC; BC inexistente torna o manifest orfao de topologia. Plain (existencia global) por escolha do item 5 -- mesmo padrao de sc-sv-01; o aperto same-BC (instance-scoped) e rastreado em def-052. Born-green: zero PortManifest no disco hoje."
}

structuralChecks: "sc-mri-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-mri-02"
	title:        "AggregateManifest.aggregateRef aponta aggregate existente"
	artifactType: "aggregate-manifest"
	description:  "aggregateRef existe em contexts/*/domain-model.cue aggregates[].code (campo .code, nao .id). Ref por id cross-file (cue vet valida o formato, nao a existencia)."
	kind:         "cross-file-id-exists"
	rule: {
		referencePath: "aggregateRef"
		targetGlob:    "contexts/*/domain-model.cue"
		targetIdPath:  "aggregates[].code"
	}
	errorMessage: "AggregateManifest: aggregateRef nao corresponde a nenhum aggregate declarado em domain-model.aggregates[].code. Declare o aggregate no domain-model do BC ou corrija o ref."
	rationale:    "adr-144 item 5 (familia manifest-ref-integrity): um AggregateManifest descreve um aggregate; aggregateRef inexistente e contrato fantasma. targetIdPath e aggregates[].code (confirmado R2: o domain-model declara aggregates por .code, nao .id). Plain (existencia na uniao global de domain-models) por escolha do item 5; aperto same-BC (instance-scoped) rastreado em def-052. Born-green: zero AggregateManifest no disco hoje."
}
