package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr054C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-054-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-054-declarative-authoring-policy.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "C3 Part 2 migration per adr-059: 'governance/build-time/authoring-policy.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created — verified via git: first-add 2026-05-01 vs adr-054 commit 2026-04-30; arquivo criado pela materialização da decisão em commit subsequente). 2 paths permanecem em affectedArtifacts: quality-gate.cue + readme/config.cue (existing-altered). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 1 path (authoring-policy.cue) movido para plannedOutputs; 2 paths existentes permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Classification verificada via git history. cue vet ./... EXIT=0."
}
