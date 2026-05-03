package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr043C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-043-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-043-vertical-applicability-governance-surface.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 'architecture/shared-types/vertical-applicability.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created — verified via git: first-add 2026-04-07T17:37:06 == adr commit). 3 paths schema (subdomain.cue, canvas.cue, lens.cue) permanecem em affectedArtifacts (existing-altered, modificados pela decisão para suportar vertical applicability). Editorial migration sem mudança semântica do set."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 1 path (vertical-applicability shared-type) movido para plannedOutputs; 3 paths schema permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Classification verificada via git history. cue vet ./... EXIT=0."
}
