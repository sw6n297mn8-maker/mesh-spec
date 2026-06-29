package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do def-049 — re-deferimento pós-triagem (adr-162): trigger file-exists esgotado
// substituído por manual-review (evento real no runtime) + temporal 180d backstop.
// Revisado em subagente ISOLADO (batch das 9 re-adiações). 1 round, stable, 0 fail.

def049: build_time.#SelfReviewReport & {
	reportId: "srr-def-049-assertion-to-test-mechanism"

	artifactPath:       "architecture/deferred-decisions/def-049-assertion-to-test-mechanism.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-28"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-review isolated-subagent (batch das 9 re-adiações, triagem adr-162) do def-049 após
			re-deferimento. O trigger original adjacent-need file-exists em codegen-contract.cue
			(proxy-prematuro) foi substituído por manual-review + temporal 180d. Verificado: status
			open; triggers == [manual-review, temporal(180)]; manual-review.reason >=40 runes nomeando
			o evento real (volume de contract-tests hand-encoded que justifique automatizar a
			transformação assertion→test), fenômeno de runtime que vive no mesh-runtime (testes em
			contexts/*/src/test, marcador *AssertionTest/*CompositionTest) sem sensor honesto no runner
			de mesh-spec — e o volume-threshold do runner só conta 10 artifactTypes hardcoded, sem
			"assertion-test"; tq-def-03 satisfeito (temporal). date refrescada para 2026-06-28 (idade 0
			— não re-dispara) com a data ORIGINAL (2026-06-04) preservada no triggerCalibrationRationale.
			deferralRationale/description/costOfDeferral inalterados e íntegros (severity medium/cross-
			artifact mantida). tq-def-01/02/04 PASS; anti-catch-all OK. cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-049 RE-ADIADO na triagem do backlog disparado (adr-162): o trigger file-exists esgotado
		(proxy-prematuro em codegen-contract.cue) deu lugar a manual-review (volume de testes hand-
		encoded que justifique automatizar — fenômeno de runtime no mesh-runtime; o volume-threshold do
		runner nem conta "assertion-test") + temporal 180d backstop; status segue open; date refrescada
		com proveniência preservada. Re-review isolado (batch): 0 fail / 0 warn, stable em 1 round; cue
		vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: a re-adiação é troca de calibração de gatilho de escopo estreito e uniforme entre os 9
		defs, revisada por subagente ISOLADO em batch (viés de auto-ratificação reduzido) com PASS
		direto. O eixo de risco — gatilho desonesto (volume-threshold não consegue contar os testes
		hand-encoded, que vivem no mesh-runtime e fora da whitelist do runner) — foi verificado ausente:
		o manual-review nomeia o evento real (volume que justifique automatizar) e o temporal 180d é o
		backstop gateável (adr-162). Shape, reason>=40, temporal presente e proveniência da data
		verificados; sem delta a re-rodar.
		"""
}
