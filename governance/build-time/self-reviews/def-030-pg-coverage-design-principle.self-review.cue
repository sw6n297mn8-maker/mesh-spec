package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def030: build_time.#SelfReviewReport & {
	reportId: "srr-def-030"

	artifactPath:       "architecture/deferred-decisions/def-030-pg-coverage-design-principle.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			def-030 difere a decisão de adicionar design-principle à whitelist
			coveredSchemas do sc-pg-01 + criar o type-PG. Avaliado contra
			uq-01..09 + tq-def-01..04.

			tq-def-01 (trade-off): custo evitado (type-PG de baixo uso — novos
			princípios são raros, P13 é o primeiro desde a schematização) vs custo
			de continuar (gap cobertura-universal-declarada vs enforced,
			atualmente inócuo; gate sc-pg-01 não exige). Concreto.

			tq-def-02/03: manual-review (decisão estratégica) + adjacent-need
			file-contains (sc-pg-01 contém "design-principle"). tq-def-03
			satisfeito.

			tq-def-04: low/local coerente — autorar design-principle sem type-PG é
			o status quo (P0–P13); afeta só o tipo + a whitelist.

			Trigger adjacent-need verificado: production-guide.cue
			(structural-checks) NÃO contém "design-principle" hoje → não dispara.
			Fundamento factual do pre-flight (whitelist opt-in, adr-053/056)
			citado.

			cue vet ./... EXIT=0. status open.
			"""
	}]

	findings: {}

	summary: """
		def-030 (open) defere a cobertura de PG para design-principle; pre-flight
		mostrou design-principle fora da whitelist sc-pg-01 (opt-in) e P0–P13
		autorados sem type-PG. Triggers: manual-review + adjacent-need
		(file-contains design-principle no sc-pg-01) que não dispara agora. Custo
		low/local; sem fail/warn.
		"""

	singleRoundRationale: """
		DD de baixo custo, ancorada em fato verificado no pre-flight
		(design-principle ausente de coveredSchemas; status quo P0–P13). Trigger
		adjacent-need preciso e não-disparante. Round único suficiente.
		"""
}
