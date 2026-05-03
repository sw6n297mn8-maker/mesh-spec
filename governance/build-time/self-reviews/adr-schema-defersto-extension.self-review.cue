package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adrSchemaDefersToExtension: build_time.#SelfReviewReport & {
	reportId: "srr-adr-schema-defersto-extension"

	artifactPath:       "architecture/artifact-schemas/adr.cue"
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
		summary:   "Edição em adr.cue per adr-062: adicionado field optional 'defersTo: [...string & =~\"^def-[0-9]{3}$\"]' entre derivedArtifacts e principlesApplied. Cada id deve resolver para arquivo def-XXX em architecture/deferred-decisions/. Forward-looking: ADRs pré-adr-062 grandfathered (sem defersTo); ADRs pós-adr-062 SHOULD usar quando deferimento codificável existe. Optional preserva backward compat — adr-001..adr-061 permanecem válidos sem migration retroativa. Comment expandido articulando regime de adoption + grandfather strategy. Edition is structural (extends schema) covered by ADR. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema extension: adr.cue +1 field optional (defersTo). Forward-looking adoption — pré-adr-062 ADRs grandfathered; backfill é separate WI futuro."

	singleRoundRationale: "Edição mecânica de extensão de schema com optional field, decisão registrada em adr-062. Backward compat preservada (optional + grandfather). cue vet passa. Round único suficiente."
}
