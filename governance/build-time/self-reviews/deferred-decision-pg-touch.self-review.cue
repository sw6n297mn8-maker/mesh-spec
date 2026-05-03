package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

deferredDecisionPgTouch: build_time.#SelfReviewReport & {
	reportId: "srr-deferred-decision-pg-touch"

	artifactPath:       "architecture/production-guides/deferred-decision.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

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
		summary:   "Retroativo per adr-067 decision item 3. Cobre touches da PG architecture/production-guides/deferred-decision.cue durante branch claude/resume-mesh-work-jv2MC. PG criada em adr-062 (commit 4f6abfc) introduzindo deferred-decision como tipo first-class; modificada em adr-066 (commit 9ce54d7) ajustando guidance pós-introdução de def-XXX instances; modificada em WI-069 retrospective (commit 7ebcf02) consolidando learnings. Modificações aditivas/refinements sem alteração de invariantes core do protocolo. PG continua conformante a #ProductionGuide schema."
	}]

	findings: {}

	summary: "Retroativo per adr-067: touches de production-guides/deferred-decision.cue cobrindo criação (adr-062) + refinements (adr-066, WI-069)."

	singleRoundRationale: "Retroativo cobre série de touches já materializadas e validadas por SRRs upstream existentes (adr-062, adr-066). Round único suficiente."
}
