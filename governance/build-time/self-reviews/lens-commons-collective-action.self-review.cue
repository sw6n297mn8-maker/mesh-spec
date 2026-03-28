package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensCommonsCollectiveAction: build_time.#SelfReviewReport & {
	reportId: "srr-lens-commons-collective-action"

	artifactPath:       "architecture/lenses/lens-commons-collective-action.cue"
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
		summary:   "Round 1 avaliou artefato parcial (trigger + 16 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes. Demais critérios pass sobre conteúdo presente. tq-ln-01 pass (11 condições testáveis, 5 excludeWhen). 16 conceitos com dependsOn e crossDependsOn consistentes. Conceitos cobrem lifecycle, tipologia, heterogeneidade, coordenação, dados, free-riding, tragédia, seleção adversa, Ostrom, monitoramento, enclosure, funding pool, excludabilidade, reputação, incentivos e saúde operacional."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Campos obrigatórios ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — aguardando conteúdo restante do founder."
		}]
	}

	summary: """
		Lente de commons e ação coletiva parcial com 16 conceitos, trigger
		(11 condições, 30 keywords, 5 excludeWhen). Round 1 identifica fail
		por campos obrigatórios ausentes (artefato parcial). Aguardando
		reasoningProtocol, meshExamples, principleIds, relatedLenses,
		limitations e rationale do founder.
		"""
}
