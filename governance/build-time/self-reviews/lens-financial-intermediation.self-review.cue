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
		summary:   "Round 1 avaliou lente parcial (trigger + 15 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em FIDC, SCD, recebíveis, subordinação, covenants, capital próprio, warehouse, correspondente bancário, IOF, IRRF, cessão, securitização, construção civil, true sale, commingling, servicer, maturity mismatch, run risk, ramp-up, monitoramento delegado, spread mínimo, alocação de capital, fragilidade de funding (uq-02), dependsOn internos consistentes — cadeia coerente de 15 concepts com dependências cruzadas válidas (uq-03), sem contradição com design-principles (uq-04), terminologia consistente — funding, liquidez, intermediação, subordinação, elegibilidade, covenants, maturidade, transformação de risco, monitoramento delegado, veículo regulatório, FIDC, SCD, true sale, bankruptcy remoteness, commingling, servicer, run risk, maturity mismatch, spread mínimo viável, first-loss, warehouse (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 13 condições testáveis, 5 excludeWhen. tq-ln-02 pass: 15 conceitos (>=5), roles válidos (13 framework + 2 method)."
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
		41 keywords, 5 excludeWhen) e 15 conceitos cobrindo papel do
		intermediário, veículo regulatório, funding por estágio, FIDC,
		true sale e commingling, servicer risk, maturity transformation,
		liquidez, run risk, ramp-up e reinvestimento, monitoramento
		delegado, custo de capital, alocação de capital, fragilidade de
		funding e funding map operacional. Fail estrutural (uq-08) por
		campos obrigatórios ausentes — artefato parcial aguardando
		conteúdo do founder.
		"""
}
