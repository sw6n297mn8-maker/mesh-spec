package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensInformationEconomics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-information-economics"

	artifactPath:       "architecture/lenses/lens-information-economics.cue"
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
		summary:   "Round 1 avaliou lente parcial (trigger + 3 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass sobre conteúdo presente: rationales explicam WHY (uq-01), meshManifestation ancorado em construção civil, supply chain, scoring, FIDC, fusão banco↔supply chain (uq-02), crossDependsOn referencia lens-market-design/md-participation-constraints que existe (uq-03), sem contradição com design-principles (uq-04), terminologia consistente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 12 condições testáveis, 5 excludeWhen com redirecionamento explícito. 3 conceitos com dependsOn consistentes internamente."
	}]

	findings: {
		fail: [{
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios do schema #AnalyticalLens ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente information-economics parcial com trigger (12 condições, 24
		keywords, 5 excludeWhen) e 3 conceitos teóricos cobrindo assimetria
		informacional, problema dos lemons e sinalização. Fail estrutural
		(uq-08) por campos obrigatórios ausentes — artefato parcial por decisão
		do founder. Aguardando reasoningProtocol, meshExamples, principleIds,
		relatedLenses, limitations e rationale.
		"""
}
