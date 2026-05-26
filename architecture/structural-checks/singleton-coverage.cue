package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// singleton-coverage.cue — Trava de regressão para singletons declarados.
// Per adr-090: gêmeo de sc-pg-01 (production-guide-coverage). Nasce verde
// listando apenas singletons já existentes; cresce por change-on-touch.
// agent-governance global entra na whitelist no commit que cria o global
// (architecture/agent-governance.cue), per adr-037 (governança em dois níveis).

structuralChecks: "sc-sg-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-sg-01"
	title:        "Singletons declarados existentes têm instância presente"
	artifactType: "artifact-schema"
	description:  "Para cada nome em requiredSingletons, o schema homônimo declara _schema.location.cardinality == singleton com canonicalPathRegex literal-âncora, e o arquivo nesse path existe. Trava de regressão contra deleção acidental de singletons."
	kind:         "singleton-coverage"
	rule: {
		// Nasce verde: somente singletons que JÁ existem (shape exige ≥1).
		// agent-governance adicionado no mesmo commit que cria o global
		// (architecture/agent-governance.cue), per adr-037. Conjunto extensível
		// por change-on-touch.
		requiredSingletons: [
			"agent-governance",
			"context-map",
			"domain-definition",
			"repo-structure",
			"stakeholder-map",
		]
	}
	errorMessage: "Singleton '{nome}': o schema homônimo declara cardinality singleton, mas o arquivo no seu canonicalPathRegex literal não existe. Se foi deletado, restaure; se a cobertura foi descontinuada, remova o nome de requiredSingletons no mesmo commit."
	rationale:    "Gêmeo de sc-pg-01 per adr-090. Nasce verde com singletons existentes — proteção contra remoção acidental, não débito retroativo. Presença pura; resolução de referência cross-file permanece deferida (def-002)."
}
