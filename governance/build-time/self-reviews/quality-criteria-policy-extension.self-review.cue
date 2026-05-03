package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteriaPolicyExtension: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria-policy-extension"

	artifactPath:       "architecture/artifact-schemas/quality-criteria.cue"
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
		summary:   "Edição em quality-criteria.cue per adr-065: (1) #ArtifactType += 'policy' (preserva fechamento, sem ordenação significativa); (2) abbreviation block += 'pol (policy)'. Convention: 3-char abbrev (precedente def 3 chars). 4th extension de #ArtifactType nesta sessão (após adr-061 +adopted-artifacts/readme-config, adr-062 +deferred-decision, adr-064 +work-governance). Pattern paralelo. Não altera shape de #QualityCriterion. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: #ArtifactType +1 valor (policy); abbreviation block +1 entrada (pol). 4th extension nesta sessão."

	singleRoundRationale: "Edição mecânica de extensão de enum + comment block, decisão registrada em adr-065. Round único suficiente."
}
