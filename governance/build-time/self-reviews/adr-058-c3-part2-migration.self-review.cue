package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr058C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-058-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-058-add-failure-handling-to-agent-governance-envelope.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 2 self-review reports (adr-058.self-review.cue + agent-governance-schema-failurehandling.self-review.cue) reclassificados de affectedArtifacts (existing-altered) para plannedOutputs (new-created — created pelo commit de adr-058). 6 paths governance/agent permanecem em affectedArtifacts (schema, PG-B, 4 envelopes — todos existing-altered). Editorial migration. ADR-058 também tem srr-adr-058 (commit 4f40448) — este é report adicional para a touch da migração."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 2 paths (self-review reports do adr-058) movidos para plannedOutputs; 6 paths governance/envelope permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Classification verificada via git history. ADR original tem srr-adr-058 separado para autoria inicial. cue vet ./... EXIT=0."
}
