package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensPlatformDynamics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-platform-dynamics"

	artifactPath:       "architecture/lenses/lens-platform-dynamics.cue"
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
		summary:   "Round 1 avaliou lente parcial (trigger + 5 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em construção civil, fornecedores, compradores, investidores, crédito, recebíveis, São Paulo, Recife, FIDC, qualificação manual (uq-02), sem crossDependsOn externo (uq-03 pass), sem contradição com design-principles (uq-04), terminologia consistente — friction threshold, chicken-and-egg, multi-sided, cross-side, same-side, multi-homing, bypass, anchor tenant, single-player mode (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 15 condições testáveis, 7 excludeWhen."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente platform-dynamics parcial com trigger (15 condições, 37 keywords,
		7 excludeWhen) e 5 conceitos cobrindo friction threshold, lifecycle,
		efeitos de rede cross/same-side, efeitos locais e estrutura multi-sided.
		Fail estrutural (uq-08) por campos obrigatórios ausentes — artefato
		parcial por decisão do founder.
		"""
}
