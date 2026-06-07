package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

aggregateManifestPg: build_time.#SelfReviewReport & {
	reportId: "srr-aggregate-manifest-pg"

	artifactPath:       "architecture/production-guides/aggregate-manifest.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 4
		summary: """
			Re-review isolado dedicado do PG de #AggregateManifest (sub-agente fresco): tq-pg-01..06 todos
			PASS, 0 fail / 0 warn. workOrder<->sections bijetivo (5 keys); cada section.target =
			#AggregateManifest; collectFromFounder cobre os 7 campos; tq-amg-01/02 + gapPolicy ancoram a
			disciplina anti-invencao-de-ids e a separacao existencia-no-domain-model (deferida a def-052)
			vs subset-do-canon runtime (cross-repo) em 6 lugares, sem contradicao -- verificado fiel contra
			def-052 e sc-mri-02 no disco; finalValidation termina em founder gate. 4 info (2 editorial:
			diacriticos ausentes (ASCII, cascade-wide) e anglicismo 'concept' (2x corrigido para 'conceito' neste arco); 2 obs opcionais: mencionar campo .code em
			aggregateRef; framing 'pos-C5' coerente com same-arc) -- todos abaixo de warn.
			"""
	}]

	findings: {}

	summary: """
		PG de #AggregateManifest (autoria de instancias per-aggregate). Re-review isolado dedicado LIMPO
		(0 fail / 0 warn): conforma a #ProductionGuide, cobre os 7 campos, e a triade do boundary
		(shape-agora / existencia-cross-file-deferida-a-def-052 / subset-do-canon-runtime-cross-repo) esta
		correta e consistente em 6 lugares. 4 info nao-bloqueantes (2 editorial, 2 obs opcionais).
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: o re-review isolado dedicado confirmou a bijecao e a separacao
		existencia/canon (o risco principal do tipo) fiel a def-052/adr-144 C1, 0 fail / 0 warn; cue vet
		valida o shape.
		"""
}
