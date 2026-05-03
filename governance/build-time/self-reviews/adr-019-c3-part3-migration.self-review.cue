package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr019C3Part3Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-019-c3-part3-migration"

	artifactPath:       "architecture/adrs/adr-019-validation-prompts-auto-hook.cue"
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
		summary:   "C3 Part 3 migration per adr-059: 5 paths reclassificados de affectedArtifacts (existing-altered) para plannedOutputs (new-created): 5 paths (incluindo architecture/artifact-schemas/validation-prompt.cue, architecture/validation-prompts/validate-adr.cue, ...). affectedArtifacts vazio. Verified via git archaeology (commit hash + timestamp comparison vs ADR commit). Editorial migration."
	}]

	findings: {}

	summary: "Migração C3 Part 3: 5 paths movidos para plannedOutputs; 0 permanecem em affectedArtifacts."

	singleRoundRationale: "Migração mecânica per founder-approved C3 Part 3 plan (adr-001..adr-040, follow-up de Part 2 commit 115f12f). Classificação rigorosa via timestamp-by-commit: new-created = path criado no MESMO commit do ADR ou postdated planejado; existing-altered = path criado em commit ANTERIOR. Sem manual overrides em Part 3 (nenhum caso de restructure noise nas ADRs antigas). cue vet ./... EXIT=0."
}
