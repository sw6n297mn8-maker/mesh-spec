package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscCanvasWi152QuotationMapSurface: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-canvas-wi-152-quotation-map-surface"

	artifactPath:       "contexts/ssc/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — coevolução do canvas ssc (WI-152): +query-surface
			QueryQuotationMap no inbound (returnType QuotationMap; consumers
			comprador/supervisor/auditoria — INTRA-organização, não outro BC:
			sem query-dependency em canvas alheio, sem relação nova no
			context-map, sem risco sc-cm-07); rationale da communication
			coevoluído (2 → 3 query-surfaces, com a declaração explícita de
			que os events internal de cotação NÃO propagam cross-BC — sem
			entry outbound, confidencialidade competitiva). Os commands de
			fornecedor (submit/withdraw) seguem fora do inbound do canvas
			como já estavam (carve-out tq-dm-12 preexistente — nenhum handler
			novo). cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Canvas ssc coevoluído: QueryQuotationMap como 3ª query-surface
		(consumo intra-org), events internal sem propagação declarada —
		outbound intocado. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: materialização da fatia WI-152 executando a
		decisão B do founder pré-cravada no Tempo 2 (o Tempo 1 read-only
		serviu de section-gate do desenho, com o terreno verificado contra o
		disco); a verificação determinística corre nos gates da validação
		integral do checkpoint (sc-ds em REJECT, tq-dm, runner).
		"""
}
