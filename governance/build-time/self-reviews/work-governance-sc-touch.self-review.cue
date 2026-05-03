package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

workGovernanceScTouch: build_time.#SelfReviewReport & {
	reportId: "srr-work-governance-sc-touch"

	artifactPath:       "architecture/structural-checks/work-governance.cue"
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
		summary:   "Retroativo per adr-068 decision item 3. Cobre criação da SC architecture/structural-checks/work-governance.cue durante branch claude/resume-mesh-work-jv2MC. Criada em adr-064 commit 4f25682 (work-governance type + directory-pair-coverage kind + sc-wg-01 sistemic fix WI-033 bug). SC introduz directory-pair-coverage kind para validar cobertura entre WI task-specs e work-events. Mudança constitutiva codifica fix sistêmico; SC conformante a #StructuralCheck schema."
	}]

	findings: {}

	summary: "Retroativo per adr-068: criação de structural-checks/work-governance.cue em adr-064 (sc-wg-01 sistemic fix)."

	singleRoundRationale: "Retroativo cobre criação já validada por adr-064 self-review existente. Round único suficiente."
}
