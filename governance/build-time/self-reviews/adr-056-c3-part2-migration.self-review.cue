package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr056C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-056-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-056-add-production-guide-coverage-kind.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 'architecture/structural-checks/production-guide.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created — verified via git: first-add 2026-05-01T20:10:11 == adr-056 commit, sc-pg-01 instance criada pela decisão). 'architecture/artifact-schemas/structural-check.cue' permanece em affectedArtifacts (existing-altered, schema estendido com novo kind). Editorial migration. ADR-056 também tem srr-adr-056 (commit aac42a4) — este é report adicional para a touch da migração."
	}]

	findings: {}

	summary: "Migração C3 Part 2: 1 path (sc-pg-01 instance) movido para plannedOutputs; 1 path schema permanece em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 2 plan. Classification verificada via git history. ADR original tem srr-adr-056 separado para autoria inicial. cue vet ./... EXIT=0."
}
