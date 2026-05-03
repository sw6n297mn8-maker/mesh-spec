package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr030C3Part3Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-030-c3-part3-migration"

	artifactPath:       "architecture/adrs/adr-030-shared-strategic-classification.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
		summary:   "C3 Part 3 migration per adr-059: 1 path reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created): architecture/shared-types/strategic-classification.cue. 2 paths permanecem em affectedArtifacts (architecture/artifact-schemas/canvas.cue, architecture/artifact-schemas/subdomain.cue). Verified via git archaeology (commit hash + timestamp comparison vs ADR commit). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 3: 1 path movido para plannedOutputs; 2 permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 3 plan (adr-001..adr-040, follow-up de Part 2 commit 115f12f). Classificação rigorosa via timestamp-by-commit: new-created = path criado no MESMO commit do ADR ou postdated planejado; existing-altered = path criado em commit ANTERIOR. Sem manual overrides em Part 3 (nenhum caso de restructure noise nas ADRs antigas). cue vet ./... EXIT=0."
}
