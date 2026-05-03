package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def007: build_time.#SelfReviewReport & {
	reportId: "srr-def-007"

	artifactPath:       "architecture/deferred-decisions/def-007-policy-data-consistency.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

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
		summary:   "def-007 captura 3º dos 5 deferrals PLR (adr-065): data consistency over EC projections. Auto trigger: recurrence filename pattern '^domain/policies/pol-' threshold=3 (3+ policies → consistency question vira concrete, especialmente quando dependam de projeções compartilhadas). Manual-review fallback. Trade-off: framework prematuro impõe garantia inadequada para cases não-materializados."
	}]

	findings: {}

	summary: "def-007: deferimento de data consistency framework. Filename recurrence threshold=3 + manual-review."

	singleRoundRationale: "Trigger calibration pre-write; threshold respeita schema; round único suficiente."
}
