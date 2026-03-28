package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensFinancialIntermediation: build_time.#SelfReviewReport & {
	reportId: "srr-lens-financial-intermediation"

	artifactPath:       "architecture/lenses/lens-financial-intermediation.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou lente parcial (trigger + 4 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em FIDC, SCD, recebíveis, subordinação, covenants, capital próprio, warehouse, correspondente bancário, IOF, IRRF, cessão, securitização, construção civil (uq-02), dependsOn internos consistentes — fi-intermediation-role → fi-regulatory-vehicle → fi-funding-structure → fi-fidc-structure (uq-03), sem contradição com design-principles (uq-04), terminologia consistente — funding, liquidez, intermediação, subordinação, elegibilidade, covenants, maturidade, transformação de risco, monitoramento delegado, veículo regulatório, FIDC, SCD (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 13 condições testáveis, 5 excludeWhen."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente financial-intermediation parcial com trigger (13 condições,
		41 keywords, 5 excludeWhen) e 4 conceitos cobrindo papel do
		intermediário financeiro, veículo regulatório, estrutura de funding
		por estágio e estrutura do FIDC. Fail estrutural (uq-08) por
		campos obrigatórios ausentes — artefato parcial aguardando
		conteúdo do founder.
		"""
}
