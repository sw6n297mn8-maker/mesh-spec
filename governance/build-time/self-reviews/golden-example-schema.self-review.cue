package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

goldenExampleSchema: build_time.#SelfReviewReport & {
	reportId: "srr-golden-example-schema"

	artifactPath:       "architecture/artifact-schemas/golden-example.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

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
			Re-review isolated-subagent do schema #GoldenExample (declaracao-pura do experimento spec->codigo de
			um BC). tq-as-01: _schema.location completo (canonicalPathRegex contexts/{bc}/golden-examples/,
			cardinality collection). tq-as-02: tq-ge-01/02/03 acionaveis (declaracao-pura zero-evidencia;
			specSlice/assertionRefs reais review+harness-trusted; gates completos como CONDICAO). tq-as-03:
			rationale do conjunto explica a cobertura. #CodegenKind reconciliado 1:1 ao output.artifacts do
			codegen-contract (adr-140, fonte canonica P0) + assertion-tests (adr-138 item 2); zero residuo de
			vocabulario antigo (adapter-stub / port-contract sing.). uq-* pass; zero campo de evidencia (a
			evidencia de run vive em codegen-validation-evidence, WI-137). Veredito do subagente: APROVADO.
			"""
	}]

	findings: {}

	summary: """
		Schema #GoldenExample declaracao-pura; re-review isolated-subagent APROVADO (tq-as-01/02/03 + uq-*).
		#CodegenKind alinhado ao vocabulario canonico do codegen-contract (P0); zero campo de evidencia
		(separacao declaracao/evidencia, evidencia em WI-137). Sem findings fail/warn. cue vet 0; structural-runner
		33/0-bloqueante (sc-meta-02 do golden-example coberto por exemptType harness).
		"""

	singleRoundRationale: """
		1 round: o re-review isolado confirmou #CodegenKind = output.artifacts do codegen-contract + assertion-tests
		(1:1, zero residuo antigo) e a declaracao-pura (zero campo de evidencia), com tq-as-*/uq-* sem fail. A
		ref-integrity fica review+harness-trusted por escolha (adr-145 N1); nada a iterar no shape.
		"""
}
