package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

metaCoverageGoldenExampleExemption: build_time.#SelfReviewReport & {
	reportId: "srr-meta-coverage-golden-example-exemption"

	artifactPath:       "architecture/structural-checks/meta-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-08"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review da extensao de sc-meta-02.exemptTypes += golden-example (categoria "harness"). Adicionar
			golden-example a #ArtifactType o torna tipo governado; sc-meta-02 (enforcement reject) exige um
			structural-check OU uma isencao registrada. adr-145 item 6 escolheu NAO criar structural-check de
			ref-integrity de golden-example: seria REDUNDANTE com o harness de codegen-validation (WI-137) que
			EXERCITA os refs ao gerar codigo -- escolha, NAO inexpressibilidade (distinto de adr-144 def-051/052,
			que eram inexpressiveis pelo kind). A isencao carrega esse rationale (review+harness-trusted ate WI-137
			materializar; reabre se o harness nao entregar). Append nao-destrutivo. structural-runner: o
			sc-meta-02 do golden-example foi resolvido (34 -> 33 violacoes, 0-bloqueante).
			"""
	}]

	findings: {}

	summary: """
		sc-meta-02.exemptTypes += golden-example (categoria harness) — materializa a escolha de adr-145 item 6
		(sem structural-check de ref-integrity; redundante com o harness WI-137, nao inexpressibilidade).
		Self-review LIMPO; structural-runner 0-bloqueante (sc-meta-02 do golden-example resolvido). NOTA: o gate
		nao exigia SRR fresco (3 SRRs de meta-coverage por path); per-change por disciplina (paridade adr-144).
		"""

	singleRoundRationale: """
		1 round: a isencao codifica uma decisao ja tomada e aprovada (adr-145 item 6: redundancia-com-harness, nao
		inexpressibilidade); append nao-destrutivo que zera o sc-meta-02 do golden-example (structural-runner
		0-bloqueante). Nada a iterar.
		"""
}
