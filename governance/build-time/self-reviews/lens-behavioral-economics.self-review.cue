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
		summary:   "Round 1 avaliou lente parcial (trigger apenas, sem concepts). uq-08 fail: campos obrigatórios concepts, reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass sobre conteúdo presente: rationale do trigger explica WHY (uq-01), ancorado em construção civil brasileira, fornecedores de baixa sofisticação, DMU complexa de compradores institucionais, redes informais de reputação (uq-02), sem referências cruzadas neste batch (uq-03 pass), sem contradição com design-principles (uq-04), terminologia consistente (uq-06), zero placeholders (uq-07). tq-ln-01 pass: 10 condições testáveis, 5 excludeWhen com redirecionamento explícito."
	}]

	findings: {
		fail: [{
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios do schema #AnalyticalLens ausentes: concepts, reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — founder enviará conteúdo restante."
		}]
	}

	summary: """
		Lente behavioral-economics parcial com trigger (10 condições, 36
		keywords, 5 excludeWhen) apenas. Sem concepts ainda. Fail estrutural
		(uq-08) por campos obrigatórios ausentes — artefato parcial por decisão
		do founder. Aguardando concepts, reasoningProtocol, meshExamples,
		principleIds, relatedLenses, limitations e rationale.
		"""
}
