package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// service-contract.cue — Structural check do service-contract (adr-106, redução
// do bucket cross-file do M2). boundedContextRef referencia o BC dono do
// contrato; deve existir como context declarado no context-map. Born-warn.

structuralChecks: "sc-sv-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-sv-01"
	title:        "service-contract.boundedContextRef referencia context declarado"
	artifactType: "service-contract"
	description:  "boundedContextRef existe em strategic/context-map.cue contexts[].context. Ref cross-file por id — cue vet valida o formato, não a existência semântica do BC no mapa global."
	kind:         "cross-file-id-exists"
	rule: {
		referencePath: "boundedContextRef"
		targetGlob:    "strategic/context-map.cue"
		targetIdPath:  "contexts[].context"
	}
	errorMessage: "service-contract: boundedContextRef não corresponde a nenhum context declarado em context-map.contexts[].context. Declare o BC no context-map ou corrija o ref."
	rationale:    "adr-106: um service-contract pertence a um BC; se o BC dono não está declarado no mapa global, o contrato é órfão de topologia. Born-green (ctr declarado)."
	enforcement: "reject"
}
