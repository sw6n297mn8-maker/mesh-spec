package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr041C3Part2Migration: build_time.#SelfReviewReport & {
	reportId: "srr-adr-041-c3-part2-migration"

	artifactPath:       "architecture/adrs/adr-041-structural-check-v1-schema-shape.cue"
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
		summary:   "C3 Part 2 migration per adr-059: 'architecture/artifact-schemas/structural-check.cue' reclassificado de affectedArtifacts (existing-altered) para plannedOutputs (new-created). Path foi criado pelo commit de adr-041 (verified via git log --diff-filter=A: first-add 2026-04-07T14:14:34 == adr commit). affectedArtifacts ficou vazio (era 1 path único new-created); requer schema relax (adr.cue affectedArtifacts → optional non-empty list per adr-059 follow-up no mesmo commit). Editorial migration sem mudança semântica do conjunto de paths."
	}]

	findings: {}

	summary: """
		Migração C3 Part 2 (per adr-059 plannedOutputs setup +
		affectedArtifacts relax) de adr-041: 1 path new-created
		movido para plannedOutputs; affectedArtifacts vazio.
		"""

	singleRoundRationale: """
		Migração mecânica per founder-approved C3 Part 2 plan.
		Classification verificada via git history (path criado pelo
		commit do ADR). Single round porque mudança é estruturalmente
		editorial (paths reclassificados sem alteração de set);
		schema relax coordenado no mesmo commit garante validade.
		cue vet ./... EXIT=0.
		"""
}
