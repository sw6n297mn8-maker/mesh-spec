package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def003: build_time.#SelfReviewReport & {
	reportId: "srr-def-003"

	artifactPath:       "architecture/deferred-decisions/def-003-add-regex-pattern-match-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 1: instância inicial com pattern 'regex-pattern-match.{0,30}kind' (kind name match). Calibration analysis revelou false-positive risk paralelo a def-002: pattern sem framing matches qualquer arquivo que mencione kind name. Post-commit, def-003 + adr-063 self-references somariam 2 matches. tq-defg-02 finding warn: calibration too-loose."
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 2 (calibration fix): pattern atualizado para framing-aware '(missing|needs|requires|would benefit).{0,30}regex-pattern-match'. Post-fix verificado pré-commit: 0 matches em todo repo. WI-069 first dispatch surfaced novo false-positive paralelo a def-002: '.{0,30}' matches string literal do próprio pattern em CUE. tq-defg-02 warn persiste."
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 3 (calibration fix WI-069 paralelo a def-002): pattern atualizado para '(missing|needs|requires|would benefit) [a-z ]{0,30}regex-pattern-match' — restringe in-between a [a-z ]+. Post-fix verificado via runner: count=0 (def-003 não tem prose example com framing demand, diferente de def-002). threshold=2 captura 2+ demand externo genuíno. Calibration validated end-to-end via runner."
	}]

	findings: {}

	summary: "def-003: deferimento formal de regex-pattern-match kind. Calibração paralela a def-002 (3 rounds: simples → framing-aware → letras-only)."

	singleRoundRationale: "N/A — 3 rounds paralelos a def-002. Cada round documentou uma classe distinta de false-positive descoberta via runner test."
}
