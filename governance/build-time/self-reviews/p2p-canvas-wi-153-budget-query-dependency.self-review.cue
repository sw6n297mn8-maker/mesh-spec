package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pCanvasWi153BudgetQueryDependency: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-canvas-wi-153-budget-query-dependency"

	artifactPath:       "contexts/p2p/canvas.cue"
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
			Round 1 — espelho estrutural no canvas p2p (WI-153): +query-
			dependency bdg/QueryBudgetApprovalStatus (o PORTÃO adr-174 —
			confirmação sync da reserva na aprovação da requisição, chave por
			requisição) entre as dependencies ssc e ctr; rationale da
			communication 2 → 3 query-dependencies. A entry nasce AGORA e não
			no WI-151 por decisão registrada (não cristalizar contrato sobre
			surface keyed por CommitmentId — a chave errada que o WI-153
			corrigiu); cross-checked com a relação bdg-to-p2p criada no
			context-map na mesma fatia (adr-055 decisão 5, shape npm↔idc).
			Única edição no arquivo — resto do canvas intocado. cue vet
			EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Query-dependency p2p→bdg materializada — o acoplamento do portão sai
		da prosa e ganha entry estrutural, cross-checked com o context-map.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: coevolução satélite da fatia WI-153
		executando decisões pré-cravadas do founder (D1-D6) sob comando
		estruturado batch; a revisão substantiva do desenho correu no Tempo 1
		(read-only) e a verificação determinística corre nos gates da
		validação integral do checkpoint.
		"""
}
