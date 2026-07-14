package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscCanvasAdr177P2pConsumer: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-canvas-adr-177-p2p-consumer"

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
			Round 1 — coevolução de canvas da fatia adr-177 (emenda do
			founder sobre o W1 do reviewer isolado): a surface
			QueryQuotationMap nomeia P2P como consumidor do gate na
			DESCRIPTION — a forma do precedente QuerySourcingDecision, que
			nomeia P2P/CTR no mesmo campo; o shape query-surface (type/
			query/returnType/description) NÃO tem campo estruturado de
			consumer e NENHUM campo foi inventado (a limitação de shape foi
			reportada ao founder antes da escrita, per instrução da
			emenda). A cláusula de confidencialidade competitiva foi
			PRESERVADA e precisada: consumo P2P é sistema-a-sistema no 2º
			braço do portão (resolução da cotação vencedora por
			sourcingDecisionRef), nunca superfície de fornecedor; os
			events de cotação seguem internal. Zero building block novo no
			ssc (restrição da fatia respeitada — mudança é prosa de
			surface). cue vet EXIT=0; runner 31/0 bloqueantes; sc-cm-06/07
			inalterados (canvas não é aresta do grafo — a relação
			ssc-to-p2p já declarava o consumo no context-map).
			"""
	}]

	findings: {}

	summary: """
		Surface QueryQuotationMap do canvas ssc nomeia P2P como consumidor
		do gate de procedência (adr-177) na description — forma do
		precedente QuerySourcingDecision, sem campo inventado, com a
		confidencialidade competitiva preservada e precisada. VEREDITO:
		stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: edição de 1 description seguindo forma
		existente no próprio arquivo, cravada pela decisão do founder na
		emenda W1; a evidência determinística (cue vet + runner inalterado)
		é reproduzível nesta execução.
		"""
}
