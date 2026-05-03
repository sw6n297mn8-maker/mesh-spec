package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def008: build_time.#SelfReviewReport & {
	reportId: "srr-def-008"

	artifactPath:       "architecture/deferred-decisions/def-008-policy-distributed-evaluation.cue"
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
		summary:   "def-008 captura 4º dos 5 deferrals PLR (adr-065): distributed evaluation locality. Auto trigger: recurrence filename pattern '^domain/policies/pol-' threshold=2 (2+ policies → evaluation locality question começa real, especialmente com cross-references). Manual-review fallback. Trade-off: shared evaluator vs duplicação requer 2+ consumers reais."
	}]

	findings: {}

	summary: "def-008: deferimento de distributed evaluation. Filename recurrence threshold=2 + manual-review."

	singleRoundRationale: "Trigger calibration pre-write; threshold respeita schema; round único suficiente."
}
