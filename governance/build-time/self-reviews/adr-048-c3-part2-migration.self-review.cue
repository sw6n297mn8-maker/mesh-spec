package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr048C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-048-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-048-api-spec-convention-conditional-presence.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 'architecture/conventions/api-spec-convention.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created — verified via git: first-add 2026-04-09T10:19:47 == adr commit). affectedArtifacts ficou vazio (era 1 path único new-created); requer schema relax (mesmo commit). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 1 path (api-spec-convention) movido para plannedOutputs; affectedArtifacts vazio (relax do schema coordenado no mesmo commit)."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Classification verificada via git history. Schema relax coordenado. cue vet ./... EXIT=0."
}
