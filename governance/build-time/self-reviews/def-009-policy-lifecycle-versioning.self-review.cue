package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def009: build_time.#SelfReviewReport & {
	reportId: "srr-def-009"

	artifactPath:       "architecture/deferred-decisions/def-009-policy-lifecycle-versioning.cue"
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
		summary:   "def-009 captura 5º dos 5 deferrals PLR (adr-065 + founder ajuste 5): lifecycle/versioning semantics (rollout, compatibility, deprecation, upgrade). Initial trigger: recurrence pattern 'version:\\\\s+[2-9]' file-content threshold=1. Trade-off articulado: lifecycle sofisticado vs simple version: int."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 (calibration fix): (1) threshold=1 violou schema (recurrence requer >=2); bumped para 2 inicialmente. (2) Runner test detectou false fire — pattern matched lens-platform-evolution prose + wi-027 task-spec version=2 (2 baseline non-policy matches). Bumped threshold para 3 absorvendo baseline + exigindo 1 actual policy version increment. Limitation reconhecida: trigger não path-filterable em recurrence kind atual; bumping conservador é workaround. Calibration validated end-to-end via runner: 0 false fires."
	}]

	findings: {}

	summary: "def-009: deferimento de policy lifecycle/versioning. Threshold=3 (absorve 2 baseline non-policy matches) + manual-review."

	singleRoundRationale: "N/A — 2 rounds executados (round 1 schema constraint + false positive baseline; round 2 fixed via threshold bump)."
}
