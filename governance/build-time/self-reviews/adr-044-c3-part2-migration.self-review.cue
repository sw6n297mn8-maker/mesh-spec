package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr044C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-044-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-044-close-adr-043-phase-1-backfill.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 'architecture/tension-log/ten-009-decision-class-enum-lacks-governance-value.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created — verified via git: first-add 2026-04-07T22:40:09 == adr commit). 13 paths permanecem em affectedArtifacts (adr-043 file, lenses, subdomains, canvas, ten-007, ten-008 — todos pré-existentes). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 1 path (ten-009) movido para plannedOutputs; 13 paths existentes permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Classification verificada via git history. cue vet ./... EXIT=0."
}
