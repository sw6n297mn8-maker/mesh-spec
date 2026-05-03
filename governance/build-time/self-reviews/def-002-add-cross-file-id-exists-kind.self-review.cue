package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def002: build_time.#SelfReviewReport & {
	reportId: "srr-def-002"

	artifactPath:       "architecture/deferred-decisions/def-002-add-cross-file-id-exists-kind.cue"
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
		warnCount: 1
		infoCount: 0
		summary:   "Round 1: instância inicial com pattern 'cross-file.{0,5}id' (kind name match). Calibration test via runner detectou false-positive risk: pattern matches 2+ files existentes que mencionam 'cross-file' + 'id' sem ser demanda nova (structural-check.cue comment + domain-model.cue) + post-commit adicionaria self-references (def-002 + adr-063). tq-defg-02 finding warn: calibration too-loose."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 (calibration fix): pattern atualizado para framing-aware '(missing|needs|requires|would benefit).{0,30}cross-file-id' — captura prose DE DEMANDA, não declarativo. Post-fix verificado: 0 matches em todo repo, threshold=2 absorve 2+ menções externas de demanda. triggerCalibrationRationale atualizado documentando lição aprendida (registration vs demand confusion). Calibration validated end-to-end via runner."
	}]

	findings: {}

	summary: "def-002: deferimento formal de cross-file-id-exists kind. Calibração refinada após detecção de self-reference issue (round 1 → round 2). Pattern framing-aware verificado: 0 false positives no estado atual."

	singleRoundRationale: "N/A — 2 rounds executados conforme protocolo (round 1 detectou calibration issue via runner test; round 2 fixed)."
}
