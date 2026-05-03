package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def005: build_time.#SelfReviewReport & {
	reportId: "srr-def-005"

	artifactPath:       "architecture/deferred-decisions/def-005-policy-cross-bc-execution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "def-005 captura 1º dos 5 deferrals PLR (adr-065): cross-BC execution mechanism. Initial trigger: recurrence pattern scope:\\\\s+\"cross-bc\" threshold=1. Pattern verified clean (NÃO self-matches schema enum). Trade-off articulado: aguardar 1ª cross-bc instance vs commitment prematuro a engine architecture."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 (calibration fix): threshold=1 violou schema constraint (recurrence requer >=2). Bumped para 2 + rationale articulado que 1ª cross-bc instance é manual-review-captured. Calibration validated end-to-end via runner: 0 false fires no estado atual."
	}]

	findings: {}

	summary: "def-005: deferimento de cross-BC execution mechanism. Auto trigger threshold=2 (recurrence) + manual-review fallback."

	singleRoundRationale: "N/A — 2 rounds (round 1 detected schema constraint via cue vet; round 2 bumped threshold)."
}
