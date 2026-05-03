package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr053C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-053-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-053-adopt-production-guide-with-universal-coverage-rule-and-phased-rollout.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 2 paths reclassificados para plannedOutputs (new-created): production-guide.cue (schema) + production-guide.cue (meta-PG). 2 paths permanecem em affectedArtifacts: adopted-artifacts.cue + readme/config.cue (existing-altered — manual override; ambos pré-existentes a adr-053, modificados para registrar adoção do production-guide pattern). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 2 paths (production-guide schema + meta) movidos para plannedOutputs; 2 paths existentes permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Manual override para timestamps 2026-04-29 (restructure noise; paths existiam antes). cue vet ./... EXIT=0."
}
