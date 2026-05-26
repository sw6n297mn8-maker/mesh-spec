package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckLocalFieldReferenceIntegrityKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-local-field-reference-integrity-kind"

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
			Delta (adr-100): kind local-field-reference-integrity adicionado ao
			#StructuralCheck via uniao discriminada, com entrada paralela em
			#StructuralCheckKind e #StructuralCheckRule, e a rule shape
			#LocalFieldReferenceIntegrityRule {referencePath, namespacePath}. Aprovado
			pelo founder antes da escrita (incluindo o nome com prefixo "local-").

			Conformancia: segue o padrao de extensao por kind ja consolidado
			(adr-049/063/064/080/090/099). Rule shape e dado estruturado puro (2 campos
			string non-empty) — tq-sc-02. _schema.location intocado. Aditivo: os kinds
			e checks existentes nao sao afetados (uniao apenas cresce). O nome "local-"
			documenta no proprio kind que e intra-arquivo, sem competir com o futuro
			cross-file-id-exists (def-002).

			Verificacao empirica: cue vet ./... EXIT 0 (schema + as 4 instancias em
			context-map.cue conformam); runner --self-test PASS; o evaluator
			ev_local_field_reference_integrity (com _resolve_multi) despacha por kind
			sem erro — sc-cm-01..04 verdes sobre os dados reais.
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck o kind local-field-reference-integrity e a rule
		shape #LocalFieldReferenceIntegrityRule (referencePath/namespacePath) per
		adr-100. Extensao aditiva no padrao das anteriores; sem findings fail/warn.
		cue vet 0 + runner self-test PASS; o kind despacha para o evaluator novo sem
		regressao.
		"""

	singleRoundRationale: """
		Uma rodada basta: o delta e um kind aditivo no padrao consolidado de extensao
		do #StructuralCheck, com shape derivado de adr-100 (aprovado antes da escrita)
		e verificado por cue vet + self-test + execucao real (4 checks verdes). Sem
		espaco de decisao aberto a red-team adicional.
		"""
}
