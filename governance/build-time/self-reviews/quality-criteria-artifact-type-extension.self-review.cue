package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteriaArtifactTypeExtension: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria-artifact-type-extension"

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
		summary:   "Edição mecânica em quality-criteria.cue per adr-061: (1) #ArtifactType estendido com 'adopted-artifacts' | 'readme-config' (preserva fechamento do enum, sem ordenação significativa); (2) abreviation block (linhas 47-55) estendido com 'aa (adopted-artifacts), rc (readme-config)' — abreviações já em uso em _qualityCriteria dos schemas correspondentes (tq-aa-01..07, tq-rc-01..05) agora canonicamente registradas. Não altera shape, semântica ou regex de #QualityCriterion (range [a-z]{2,3} já admite 'aa' e 'rc'). Edition is structural (extends enum) covered by ADR. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: #ArtifactType +2 valores; abbreviation block +2 entradas (aa, rc). Pattern adr-047."

	singleRoundRationale: "Edição mecânica de extensão de enum + comment block, decisão registrada em adr-061. Mudança não introduz ambiguidade (abreviações 'aa' e 'rc' já em uso real, apenas registro canônico ausente). cue vet passa. Round único suficiente."
}
