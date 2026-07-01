package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do def-073 — deferimento dormente (materialização do grafo causal no envelope) criado por
// adr-165. Revisado no mesmo subagente ISOLADO que revisou o conjunto adr-165 (dimensões 3+4).
// 1 round, stable, 0 fail.

def073: build_time.#SelfReviewReport & {
	reportId: "srr-def-073-causal-graph-envelope-materialization"

	artifactPath:       "architecture/deferred-decisions/def-073-causal-graph-envelope-materialization.cue"
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
			Review isolated-subagent (dimensões 3+4 do conjunto adr-165) do def-073, deferimento dormente
			criado por adr-165 rastreando a materialização do grafo causal no envelope de evento.
			Verificado: status open (proíbe resolvedBy — respeitado); triggers == [manual-review,
			temporal(180)]; manual-review.reason >=40 runes ancorado na IRREVERSIBILIDADE (revisitar ANTES
			da entrada de dado real retido / Phase 1+, porque o não-capturado não se reconstrói); tq-def-03
			satisfeito (temporal). LOCUS CORRETO: o grafo causal é envelope-locus (producer-set) — NÃO
			obrigação-de-adapter (erro-de-categoria evitado, confirmado contra P3 + CanonEvent marker vazio
			+ adr-141 sem causal). SEM OVERLAP com def-041/def-072. costOfDeferral medium/cross-artifact
			coerente (irreversibilidade não morde no sintético, morde no dado retido). tq-def-01/02/04 PASS.
			cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-073 — deferimento dormente criado por adr-165: rastreia a materialização do grafo causal
		(P3, envelope-locus) no contrato de evento — não descarregável como obrigação-de-adapter. Gatilho
		ancorado na irreversibilidade (antes de dado real retido / Phase 1+) + temporal 180d. Review
		isolado (dimensões 3+4 do conjunto adr-165): 0 fail / 0 warn, stable em 1 round; cue vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: def dormente revisado por subagente ISOLADO junto ao conjunto adr-165 com PASS direto. O
		eixo de risco — o erro-de-categoria de tratar o grafo causal como obrigação-de-adapter, ou gatilho
		frouxo ("algum dia") — foi verificado ausente: o locus é envelope/produtor (o adapter não fabrica
		causalidade) e o gatilho é ancorado na irreversibilidade (antes da retenção real). Sem delta a re-rodar.
		"""
}
