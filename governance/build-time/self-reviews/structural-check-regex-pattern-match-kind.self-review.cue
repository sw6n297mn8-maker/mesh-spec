package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckRegexPatternMatchKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-regex-pattern-match-kind"

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
			Delta (adr-107): kind regex-pattern-match adicionado ao #StructuralCheck
			via uniao discriminada, com entrada paralela em #StructuralCheckKind e
			#StructuralCheckRule, e a rule shape #RegexPatternMatchRule {valuePath,
			pattern}. Aprovado pelo founder.

			Conformancia: segue o padrao de extensao por kind consolidado
			(adr-049/.../105). Rule shape e dado estruturado puro (2 campos string) —
			tq-sc-02. _schema.location intocado. Aditivo. valuePath usa a mesma
			travessia _resolve_multi dos kinds adr-100/102/105.

			Verificacao empirica: cue vet ./... EXIT 0 (schema + a instancia sc-ev-01);
			runner --self-test PASS; o evaluator ev_regex_pattern_match despacha por
			kind sem erro — sc-ev-01 dispara 22 findings em warn.
			"""
	}]

	findings: {}

	summary: """
		Adiciona ao #StructuralCheck o kind regex-pattern-match e a rule shape
		#RegexPatternMatchRule (valuePath/pattern) per adr-107 (resolve def-003).
		Extensao aditiva; sem findings fail/warn. cue vet 0 + runner self-test PASS.
		"""

	singleRoundRationale: "Uma rodada: kind aditivo no padrao consolidado, shape derivado de adr-107 (aprovado antes da escrita) e verificado por cue vet + self-test + execucao. Sem espaço de red-team."
}
