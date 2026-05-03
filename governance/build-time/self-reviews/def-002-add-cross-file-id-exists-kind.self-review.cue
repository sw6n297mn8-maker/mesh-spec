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

	roundsExecuted: 3
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
		warnCount: 1
		infoCount: 0
		summary:   "Round 2 (calibration fix): pattern atualizado para framing-aware '(missing|needs|requires|would benefit).{0,30}cross-file-id' — captura prose DE DEMANDA, não declarativo. Post-fix verificado pré-commit: 0 matches em todo repo. WI-069 first dispatch surfaced novo false-positive: '.{0,30}' matches a STRING LITERAL do próprio pattern declarado em CUE (que contém ')' '.' '{' '}' caracteres). tq-defg-02 warn persiste."
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 3 (calibration fix WI-069): pattern atualizado para framing-aware com [a-z ]{0,30} no in-between (apenas letras minúsculas + espaços). Restringe match a strings que NÃO contêm caracteres regex literais (')' '[' '{' etc). Iteração subsequente revelou self-reference recursivo via documentação interna (placeholder example phrasing matched). Fix final: substituir exemplos prose por placeholder literal '<kind-name>' que NÃO casa com pattern (contém '<' não-letra). Calibration validated end-to-end via runner: 0 matches em todo o repo após placeholder substitution."
	}]

	findings: {}

	summary: "def-002: deferimento formal de cross-file-id-exists kind. Calibração refinada após 3 rounds: round 1 simples por kind name; round 2 framing-aware com '.{0,30}'; round 3 (WI-069 first dispatch surfaced) restringe in-between a [a-z ]{0,30} para evitar self-match em string literais regex."

	singleRoundRationale: "N/A — 3 rounds executados conforme protocolo. Cada round documentou uma classe distinta de false-positive descoberta via runner test."
}
