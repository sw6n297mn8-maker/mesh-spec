package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr052C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-052-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-052-adopt-repo-structure-from-portfolio.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 'architecture/artifact-schemas/repo-structure.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created — verified via git: first-add 2026-04-17T17:30:34 == adr commit). 2 paths permanecem em affectedArtifacts: governance/adopted-artifacts.cue (created by adr-050; modified by adr-052 — manual override do timestamp restructure noise) e governance/repo-structure.cue (existing-altered). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 1 path (repo-structure schema) movido para plannedOutputs; 2 paths existentes permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Manual override para adopted-artifacts.cue (criado em adr-050, modificado em adr-052). cue vet ./... EXIT=0."
}
