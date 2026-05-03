package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr050C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-050-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-050-adopt-readme-config-from-portfolio.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 4 paths reclassificados para plannedOutputs (new-created): adopted-artifacts.cue, readme-config.cue (schema), readme/output.cue, readme/config.cue. governance/repo-structure.cue permanece em affectedArtifacts (existing-altered). Manual override aplicado a adopted-artifacts.cue + readme/config.cue (timestamps 2026-04-29 são restructure noise — paths foram criados pela adoção em adr-050, não pela restructure subsequente). Verified via context semantic do ADR (estabelece adoção de readme-config from portfolio). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 4 paths novos (adoption pattern) movidos para plannedOutputs; 1 path repo-structure permanece em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Manual override para timestamps restructure noise documentado. cue vet ./... EXIT=0."
}
