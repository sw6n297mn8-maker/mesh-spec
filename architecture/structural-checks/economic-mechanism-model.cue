package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// economic-mechanism-model.cue — Integridade referencial cross-file dos
// mecanismos econômicos (adr-111, kind cross-file-id-exists). Cada mecanismo
// declara enforces (imperativos) e protectsAgainst (riscos) que vivem no
// economic-assumption-model (mesh-economic-assumptions.cue). Trava a regressão
// de mecanismo apontando para imperativo/risco fantasma. Born-warn.

structuralChecks: {
	"sc-em-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-em-01"
		title:        "mechanism.enforces referencia imperativo (imp-*) existente"
		artifactType: "economic-mechanism-model"
		description:  "Todo valor em mechanisms[].enforces existe como id em mesh-economic-assumptions.cue systemImplications[].id (imp-*). cue vet valida o formato, não a existência cross-file do imperativo referenciado."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "mechanisms[].enforces[]"
			targetGlob:    "strategic/economic-model/mesh-economic-assumptions.cue"
			targetIdPath:  "systemImplications[].id"
		}
		errorMessage: "economic-mechanism: enforces aponta para imperativo '{ref}' inexistente em systemImplications (mesh-economic-assumptions.cue). Corrija o id ou defina o imperativo."
		rationale:    "adr-111: um mecanismo que diz cumprir um imperativo fantasma quebra a rastreabilidade negócio→mecanismo. imp-* é a linguagem do economic-assumption-model; o ref deve resolver."
		enforcement: "warn"
	}
	"sc-em-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-em-02"
		title:        "mechanism.protectsAgainst referencia risco (ri-*) existente"
		artifactType: "economic-mechanism-model"
		description:  "Todo valor em mechanisms[].protectsAgainst existe como id em mesh-economic-assumptions.cue realityInvariants[].id (ri-*)."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "mechanisms[].protectsAgainst[]"
			targetGlob:    "strategic/economic-model/mesh-economic-assumptions.cue"
			targetIdPath:  "realityInvariants[].id"
		}
		errorMessage: "economic-mechanism: protectsAgainst aponta para risco '{ref}' inexistente em realityInvariants (mesh-economic-assumptions.cue). Corrija o id ou defina o risco."
		rationale:    "adr-111: um mecanismo que diz proteger contra um risco fantasma quebra a rastreabilidade; ri-* vive no economic-assumption-model e o ref deve resolver."
		enforcement: "warn"
	}
}
