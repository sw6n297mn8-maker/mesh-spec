package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pCanvasAdr177QuotationMapDependency: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-canvas-adr-177-quotation-map-dependency"

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
			Round 1 — coevolução de canvas da fatia adr-177 (emenda do
			founder sobre o W1 do reviewer isolado: fechar na fatia, não
			declarar janela): +1 query-dependency QueryQuotationMap →
			ssc, shape IDÊNTICO às 3 entries existentes (type/
			targetContext/query/purpose/description) e conteúdo espelhando
			o braço bdg do portão (QueryBudgetApprovalStatus, entry
			adjacente — o paralelo estrutural que o portão DUPLO exige);
			description cross-checked com strategic/context-map.cue
			(ssc-to-p2p hybrid) e com o accessVia da invariante
			inv-approval-amount-matches-winning-quotation (as três faces
			do acoplamento apontam a mesma query). Rationale do
			communication atualizado 3→4 query-dependencies com a nova
			entry na enumeração (prosa classe-2 não deixada). A surface
			QueryQuotationMap EXISTE no canvas do ssc (anti-dangling
			verificado no Tempo 2 da fatia). cue vet EXIT=0; runner 31/0
			bloqueantes (nenhum sc-cv-* novo).
			"""
	}]

	findings: {}

	summary: """
		Canvas p2p coevoluído com a 4ª query-dependency (QueryQuotationMap →
		ssc, 2º braço do portão adr-177), shape idêntico às existentes e
		espelho do braço bdg; enumeração do rationale corrigida 3→4. As três
		faces do acoplamento (domain-model accessVia, context-map queries,
		canvas query-dependency) fecham juntas na fatia. VEREDITO: stable,
		0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: 1 entry declarativa de shape existente +
		1 correção de enumeração, com desenho cravado pela decisão do
		founder na emenda W1 e anti-dangling pré-verificado; a evidência
		determinística (cue vet + runner sem violação nova) é reproduzível
		nesta execução.
		"""
}
