package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

goldenExamplePg: build_time.#SelfReviewReport & {
	reportId: "srr-golden-example-pg"

	artifactPath:       "architecture/production-guides/golden-example.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
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
			Re-review isolated-subagent do PG de #GoldenExample. tq-pg-01: workOrder e permutacao exata das 5
			sections (identity-and-slice/assertions/codegen-target/gates/template-role-and-rationale). tq-pg-02:
			cada section.target = #GoldenExample. tq-pg-03..06: doneCriteria avaliaveis, gapPolicy substantiva
			(nao inventar refs, nao modelar evidencia, gates como condicao), ultimo passo de finalValidation =
			founder, process acionavel. tq-geg-01/02: forca refs reais + proibe modelar evidencia. O vocabulario de
			codegenTarget.kinds e IDENTICO ao #CodegenKind do schema (Zero Duplicacao P0) e atribui as 2 fontes
			(output.artifacts do codegen-contract adr-140 + assertion-tests adr-138 item 2); zero residuo antigo.
			uq-* pass. Veredito do subagente: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		PG de #GoldenExample bijetivo (workOrder<->5 sections), declaracao-pura; re-review isolated-subagent
		APROVADO. Vocabulario de codegenTarget identico ao schema (Zero Duplicacao P0) com atribuicao precisa das
		2 fontes. Sem findings fail/warn. cue vet 0.
		"""

	singleRoundRationale: """
		1 round: o re-review isolado confirmou a bijecao workOrder<->sections, target #GoldenExample, e o
		vocabulario de codegenTarget identico ao schema com fontes separadas (output.artifacts do codegen-contract
		+ assertion-tests). Sem fail; nada a iterar.
		"""
}
