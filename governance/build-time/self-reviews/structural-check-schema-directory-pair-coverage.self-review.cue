package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckSchemaDirectoryPairCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-schema-directory-pair-coverage"

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
		summary:   "Edição em structural-check.cue per adr-064: (1) #StructuralCheck união discriminada estendida com 'directory-pair-coverage' kind; (2) #StructuralCheckKind enum 6 → 7 valores; (3) #StructuralCheckRule união estendida; (4) #DirectoryPairCoverageRule rule shape declarado com 3 fields (sourceGlob + targetGlob + bidirectional default false). Comments do header atualizados: '6 kinds atualmente' → '7 kinds atualmente'; lista de extensions inclui adr-064 + directory-pair-coverage motivation (bug WI-033). 4th extension pattern (adr-049, adr-056, adr-063, adr-064). Backward compat: instâncias existentes permanecem válidas. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: #StructuralCheck +1 kind (directory-pair-coverage). 4th extension pattern. Backward compat preservada."

	singleRoundRationale: "Edição mecânica de schema extension, decisão registrada em adr-064. Pattern 4th application (precedentes adr-049/056/063). cue vet passa. Round único suficiente."
}
