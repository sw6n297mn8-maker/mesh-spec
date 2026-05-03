package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteriaDeferredDecisionExtension: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria-deferred-decision-extension"

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
		summary:   "Edição mecânica em quality-criteria.cue per adr-062: (1) #ArtifactType estendido com 'deferred-decision' (preserva fechamento, sem ordenação significativa); (2) abbreviation block estendido com 'def (deferred-decision), defg (deferred-decision-guide)'. Convention: 'def' para schema criteria (3 chars, regex-conformant); 'defg' para PG criteria (4 chars, segue precedente tq-adrg/PG-ADR — CUE bypass via hidden field documentado em adr-062 N5). Não altera shape, semântica ou regex de #QualityCriterion. Edition is structural (extends enum) covered by ADR. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: #ArtifactType +1 valor (deferred-decision); abbreviation block +2 entradas (def, defg). Pattern adr-047 + adr-061."

	singleRoundRationale: "Edição mecânica de extensão de enum + comment block, decisão registrada em adr-062. Convention de abbrev (def/defg) seguem precedentes existentes. cue vet passa. Round único suficiente."
}
