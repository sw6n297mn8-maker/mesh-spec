package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def006: build_time.#SelfReviewReport & {
	reportId: "srr-def-006"

	artifactPath:       "architecture/deferred-decisions/def-006-policy-cross-bc-sync.cue"
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
		summary:   "def-006 captura 2º dos 5 deferrals PLR (adr-065): cross-BC sync entre BCs avaliando mesma policy. Auto trigger: recurrence mesmo pattern de def-005 com threshold=2 (2ª cross-bc instance é sinal de que sync vira concreto). Manual-review fallback. Trade-off: sync engine sem 2 cases é over-specification."
	}]

	findings: {}

	summary: "def-006: deferimento de cross-BC sync. Threshold=2 (mesmo pattern de def-005) + manual-review."

	singleRoundRationale: "Trigger calibration foi pre-write substantive; threshold respeita schema constraint sem ajuste necessário; round único suficiente."
}
