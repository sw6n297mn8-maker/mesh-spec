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
		summary:   "Round 1 avaliou lente parcial (trigger + 11 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass: rationales explicam WHY (uq-01), meshManifestation ancorado em construção civil, supply chain, scoring, FIDC, fusão banco↔supply chain, NF eletrônica, registradora, ERP (uq-02), crossDependsOn referencia lenses e concepts existentes ou planejados (uq-03), sem contradição com design-principles (uq-04), terminologia consistente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 12 condições testáveis, 5 excludeWhen com redirecionamento. 11 conceitos (10 theoretical + 1 operational) com dependsOn consistentes internamente."
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
		keywords, 5 excludeWhen) e 11 conceitos cobrindo assimetria informacional,
		problema dos lemons, sinalização, screening, valor da informação,
		externalidade informacional, cascata e herding, disclosure e transparência,
		inferência vs observação, hierarquia de verificabilidade, degradação de
		pool e vantagem informacional da Mesh (1 operacional com reviewCadence
		quarterly). Fail estrutural (uq-08) por campos obrigatórios ausentes —
		artefato parcial por decisão do founder. Aguardando reasoningProtocol,
		meshExamples, principleIds, relatedLenses, limitations e rationale.
		"""
}
