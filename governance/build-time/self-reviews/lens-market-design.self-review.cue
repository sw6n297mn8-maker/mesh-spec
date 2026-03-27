package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensMarketDesign: build_time.#SelfReviewReport & {
	reportId: "srr-lens-market-design"

	artifactPath:       "architecture/lenses/lens-market-design.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Artefato parcial por decisão do founder: contém id, name, purpose, status (active), trigger (13 condições, 30 keywords, 5 exclusões) e concepts (14 conceitos cobrindo arquitetura de market making, restrições de participação, espessura, safety, papel dual, congestion, alocação sob escassez, regime de precificação, obvious strategy-proofness, matching, timing e clearing, modos de falha, sequenciamento e saúde dos mercados). Campos obrigatórios ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. uq-08 fail por incompletude. Demais critérios sobre conteúdo presente: uq-01 pass (rationale explica por que). uq-02 pass (fortemente ancorado na Mesh — antecipação, funding, FIDC, fornecedores, compradores, construtoras, outside options bancárias). uq-03 pass (dependsOn internos consistentes). uq-04 pass. uq-06 pass (terminologia consistente — thickness, congestion, clearing, matching, outside option, spread). uq-07 pass. tq-ln-01 pass (13 condições testáveis, 5 excludeWhen)."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Artefato não conforma com #AnalyticalLens: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale estão ausentes. Artefato parcial por decisão explícita do founder."
		}]
	}

	summary: """
		Lente parcial de market design com status active, trigger completo
		(13 condições, 30 keywords, 5 exclusões) e 14 conceitos cobrindo
		market making administrado, participação, thickness, safety, papel
		dual, congestion, alocação, pricing, strategy-proofness, matching,
		timing, modos de falha, sequenciamento e saúde dos mercados. Founder
		fornecerá campos restantes em mensagens subsequentes.
		"""
}
