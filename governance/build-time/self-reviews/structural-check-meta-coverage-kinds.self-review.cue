package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckMetaCoverageKinds: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-meta-coverage-kinds"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Delta (adr-099): 2 kinds novos no #StructuralCheck via uniao discriminada
			(evaluator-coverage→#EvaluatorCoverageRule; structural-check-coverage→
			#StructuralCheckCoverageRule), com adicao paralela em #StructuralCheckKind
			e #StructuralCheckRule. Aprovado pelo founder antes da escrita.

			Conformancia: segue o padrao de extensao ja usado por adr-049/063/064/080/090
			(novo kind = nova branch na uniao + entrada no enum + entrada na uniao de
			rules + rule shape). #EvaluatorCoverageRule {checkSchemaPath com default};
			#StructuralCheckCoverageRule {exemptTypes: lista de {type, rationale}}. Ambas
			as rule shapes sao dado estruturado puro (tq-sc-02). _schema.location do
			#StructuralCheck intocado. Aditivo: os 10 kinds e checks existentes nao sao
			afetados (uniao apenas cresce).

			Verificacao empirica: cue vet ./... EXIT 0 (schema + as 2 instancias em
			meta-coverage.cue conformam); runner --self-test PASS; os 2 evaluators
			(ev_evaluator_coverage, ev_sc_coverage) despacham por kind sem erro
			(sc-meta-01 verde, sc-meta-02 lista ~30 tipos).
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck os kinds evaluator-coverage (M1) e
		structural-check-coverage (M2) com suas rule shapes, per adr-099. Extensao
		aditiva no padrao das anteriores; sem findings fail/warn. cue vet 0 + runner
		self-test PASS; os kinds despacham para os evaluators novos sem regressao.
		"""

	singleRoundRationale: """
		Uma rodada basta: o delta sao 2 kinds aditivos no padrao ja consolidado de
		extensao do #StructuralCheck (adr-049/063/064/080/090), com shapes derivados
		diretamente de adr-099 (aprovado antes da escrita) e verificados por cue vet +
		self-test. Sem espaco de decisao aberto a red-team adicional.
		"""
}
