package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteriaWorkGovernanceExtension: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria-work-governance-extension"

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
		summary:   "Edição em quality-criteria.cue per adr-064: (1) #ArtifactType estendido com 'work-governance' (preserva fechamento do enum, sem ordenação significativa); (2) abbreviation block estendido com 'wg (work-governance)'. Convention: 2-char abbrev consistente com pattern existente (cv, te, sm, etc.). Não altera shape, semântica ou regex de #QualityCriterion. 3rd extension de #ArtifactType (precedentes adr-047 api-specs, adr-061 adopted-artifacts + readme-config). cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: #ArtifactType +1 valor (work-governance); abbreviation block +1 entrada (wg). Pattern paralelo adr-047 + adr-061."

	singleRoundRationale: "Edição mecânica de extensão de enum + comment block, decisão registrada em adr-064. Convention de abbrev 'wg' segue precedentes existentes. cue vet passa. Round único suficiente."
}
