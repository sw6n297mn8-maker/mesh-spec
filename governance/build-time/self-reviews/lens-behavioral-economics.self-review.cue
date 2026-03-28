package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensBehavioralEconomics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-behavioral-economics"

	artifactPath:       "architecture/lenses/lens-behavioral-economics.cue"
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
		summary:   "Round 1 avaliou lente parcial (trigger + 17 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em construção civil, fornecedores pequenos, DMU de comprador institucional, CFO, procurement, ERP, banco, IA, score, antecipação (uq-02), crossDependsOn referencia cr-cure-roll-rate, cr-operational-transmission e cr-expected-loss em lens-credit-risk que existe (uq-03), sem contradição com design-principles (uq-04), terminologia consistente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 10 condições testáveis, 5 excludeWhen. 17 conceitos (16 theoretical + 1 operational semi-annual) com dependsOn consistentes internamente."
	}]

	findings: {
		fail: [{
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente behavioral-economics parcial com trigger (10 condições, 36
		keywords, 5 excludeWhen) e 17 conceitos cobrindo bounded rationality,
		loss aversion, status quo/inércia/endowment, sunk cost, overconfidence,
		present bias, reference point adaptation, anchoring/framing, mental
		accounting, social proof organizacional, regret aversion na DMU,
		confiança multidimensional, automation/algorithm bias, fairness e
		reciprocidade, friction/defaults/choice architecture, availability bias
		e mapa comportamental operacional. Fail estrutural (uq-08) por campos
		obrigatórios ausentes. Aguardando reasoningProtocol, meshExamples,
		principleIds, relatedLenses, limitations e rationale.
		"""
}
