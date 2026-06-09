package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

productionGuideScGoldenExampleCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-production-guide-sc-golden-example-coverage"

	artifactPath:       "architecture/structural-checks/production-guide.cue"
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
			Self-review da extensao de sc-pg-01.coveredSchemas += "golden-example" (12a entrada), no MESMO commit
			que cria architecture/production-guides/golden-example.cue (cascade ordering adr-054 / a propria regra
			do sc-pg-01 exige o nome em coveredSchemas no mesmo commit do PG). Com o PG presente, sc-pg-01 nasce
			VERDE para golden-example (cobertura satisfeita, nao debito retroativo). Append nao-destrutivo; nenhuma
			entrada existente alterada. cue vet pass; structural-runner 0-bloqueante.
			"""
	}]

	findings: {}

	summary: """
		sc-pg-01.coveredSchemas += golden-example, com o PG presente no mesmo commit (cascade ordering). Self-review
		LIMPO; sc-pg-01 verde para golden-example. NOTA: o gate nao exigia SRR fresco (2 SRRs de production-guide/sc
		por path); per-change por disciplina (paridade adr-144).
		"""

	singleRoundRationale: """
		1 round: append de 1 entrada a coveredSchemas com o PG correspondente presente no mesmo commit (cobertura
		verde imediata, nao debito). Nao-destrutivo; cue vet + structural-runner pass. Nada a iterar.
		"""
}
