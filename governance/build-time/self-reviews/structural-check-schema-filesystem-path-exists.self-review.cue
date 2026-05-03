package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckSchemaFilesystemPathExists: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-schema-filesystem-path-exists"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Edição em structural-check.cue per adr-063: (1) #StructuralCheck união discriminada estendida com 'filesystem-path-exists' kind; (2) #StructuralCheckKind enum estendido; (3) #StructuralCheckRule união estendida; (4) #FilesystemPathExistsRule rule shape declarado com 2 fields (sourcePath dot-path, isList bool default false). Comments do header atualizados: '5 kinds atualmente' → '6 kinds atualmente'; lista de extensions inclui adr-063 + filesystem-path-exists motivation. NÃO altera shapes existentes. Backward compat: instâncias existentes (sc-cv-01..03, sc-pg-01) permanecem válidas sem mudança. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: #StructuralCheck +1 kind (filesystem-path-exists). 3rd extension pattern (adr-049, adr-056, adr-063). Backward compat preservada."

	singleRoundRationale: "Edição mecânica de schema extension, decisão registrada em adr-063. Pattern 3rd application (precedentes adr-049/056). cue vet passa. Round único suficiente."
}
