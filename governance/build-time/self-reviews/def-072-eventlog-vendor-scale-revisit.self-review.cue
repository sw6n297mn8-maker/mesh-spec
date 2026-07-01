package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do def-072 — deferimento dormente (troca-de-vendor-por-escala) criado por adr-165.
// Revisado no mesmo subagente ISOLADO que revisou o conjunto adr-165 (dimensão 4).
// 1 round, stable, 0 fail.

def072: build_time.#SelfReviewReport & {
	reportId: "srr-def-072-eventlog-vendor-scale-revisit"

	artifactPath:       "architecture/deferred-decisions/def-072-eventlog-vendor-scale-revisit.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-01"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Review isolated-subagent (dimensão 4 do conjunto adr-165) do def-072, deferimento dormente
			criado por adr-165 rastreando a troca-de-vendor-por-escala. Verificado: status open (proíbe
			resolvedBy — respeitado); triggers == [manual-review, temporal(180)]; manual-review.reason
			>=40 runes nomeando o evento real (throughput de escrita colidindo com o contador global único
			do Postgres) que vive no runtime/produção sem sensor honesto no mesh-spec; tq-def-03 satisfeito
			(temporal non-manual-review). SEM OVERLAP: def-072 (troca-por-escala) é pergunta distinta de
			def-041 (qual-1º-vendor, resolved) e def-073 (grafo causal, envelope-locus). deferralRationale/
			description/costOfDeferral com MinRunes satisfeitos e coerentes (low/cross-artifact — a troca é
			cega via Port + gate de durabilidade). tq-def-01/02/04 PASS; anti-catch-all OK. cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-072 — deferimento dormente criado por adr-165: rastreia a troca de vendor do EventLogPort
		(Postgres→FDB) quando a escala horizontal de escrita colidir com o contador global. Gatilho
		manual-review (métrica de runtime sem sensor honesto no mesh-spec) + temporal 180d backstop.
		Review isolado (dimensão 4 do conjunto adr-165): 0 fail / 0 warn, stable em 1 round; cue vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: def dormente de calibração estreita, revisado por subagente ISOLADO junto ao conjunto
		adr-165 com PASS direto. O eixo de risco — overlap com def-041 ou gatilho desonesto (file-exists
		artificial onde a métrica é de runtime) — foi verificado ausente: def-072 é a pergunta
		troca-por-escala (distinta de qual-1º-vendor), e o manual-review nomeia a métrica real com
		temporal 180d de backstop (adr-162). Sem delta a re-rodar.
		"""
}
