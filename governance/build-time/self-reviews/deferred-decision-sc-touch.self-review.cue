package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

deferredDecisionScTouch: build_time.#SelfReviewReport & {
	reportId: "srr-deferred-decision-sc-touch"

	artifactPath:       "architecture/structural-checks/deferred-decision.cue"
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
		summary:   "Retroativo per adr-068 decision item 3. Cobre touch da SC architecture/structural-checks/deferred-decision.cue durante branch claude/resume-mesh-work-jv2MC. Modificação em adr-062 commit 0e9618e (bootstrap operational) ao introduzir o tipo deferred-decision como first-class. SC declara required-block + reference-exists + filesystem-path-exists para def-XXX instances. Mudança constitutiva codifica gates determinísticos do tipo; SC conformante a #StructuralCheck schema."
	}]

	findings: {}

	summary: "Retroativo per adr-068: touch de structural-checks/deferred-decision.cue cobrindo modificação em adr-062 (bootstrap operational, sc-dd kinds)."

	singleRoundRationale: "Retroativo cobre touch específica já validada por adr-062 self-review existente. Round único suficiente."
}
