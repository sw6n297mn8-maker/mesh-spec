package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

productionGuideScTouch: build_time.#SelfReviewReport & {
	reportId: "srr-production-guide-sc-touch"

	artifactPath:       "architecture/structural-checks/production-guide.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

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
		summary:   "Retroativo per adr-068 decision item 3. Cobre touches da SC architecture/structural-checks/production-guide.cue durante branch claude/resume-mesh-work-jv2MC. Origem em adr-053 series (universal coverage de PGs); modificações: adr-062 commit 4f6abfc (introduzir deferred-decision PG na coveredSchemas), adr-063 commit 4cd3e2e (filesystem-path-exists kind addition para checks de PG paths), WI-069 commit 239972c (Phase 1 dispatch — calibration amendments). Mudanças aditivas/refinements; SC conformante a #StructuralCheck schema."
	}]

	findings: {}

	summary: "Retroativo per adr-068: touches de structural-checks/production-guide.cue cobrindo adr-062 + adr-063 + WI-069 dispatch."

	singleRoundRationale: "Retroativo cobre série de touches já validadas por SRRs upstream existentes. Round único suficiente."
}
