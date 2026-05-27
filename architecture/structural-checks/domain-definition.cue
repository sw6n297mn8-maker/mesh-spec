package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-definition.cue — Structural checks do singleton domain-definition
// (adr-106, redução do bucket cross-file do M2). Os refs cross-file do
// domain-definition são PATHS (designPrinciplesRef, stakeholderMapRef), logo
// cobertos por filesystem-path-exists (kind existente, adr-063). Born-warn.

structuralChecks: {
	"sc-dd-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-dd-01"
		title:        "domain-definition.designPrinciplesRef aponta para arquivo existente"
		artifactType: "domain-definition"
		description:  "O path em designPrinciplesRef corresponde a arquivo real no filesystem. Ref cross-file por path — cue vet valida o formato string, não a existência."
		kind:         "filesystem-path-exists"
		rule: {
			sourcePath: "designPrinciplesRef"
			isList:     false
		}
		errorMessage: "domain-definition: designPrinciplesRef aponta para path inexistente. Corrija o path ou crie o arquivo de princípios referenciado."
		rationale:    "adr-106: o domain-definition ancora a tese do domínio nos princípios; um ref quebrado desconecta a âncora. Born-green (architecture/design-principles.cue existe)."
		enforcement: "reject"
	}
	"sc-dd-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-dd-02"
		title:        "domain-definition.stakeholderMapRef aponta para arquivo existente"
		artifactType: "domain-definition"
		description:  "O path em stakeholderMapRef corresponde a arquivo real no filesystem. Ref cross-file por path."
		kind:         "filesystem-path-exists"
		rule: {
			sourcePath: "stakeholderMapRef"
			isList:     false
		}
		errorMessage: "domain-definition: stakeholderMapRef aponta para path inexistente. Corrija o path ou crie o stakeholder-map referenciado."
		rationale:    "adr-106: domain-definition referencia o stakeholder-map por path; ref quebrado é drift cross-file. Born-green (domain/stakeholder-map.cue existe)."
		enforcement: "reject"
	}
}
