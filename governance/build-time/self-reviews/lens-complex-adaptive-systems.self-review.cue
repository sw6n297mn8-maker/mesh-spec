package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensComplexAdaptiveSystems: build_time.#SelfReviewReport & {
	reportId: "srr-lens-complex-adaptive-systems"

	artifactPath:       "architecture/lenses/lens-complex-adaptive-systems.cue"
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
		summary:   "Round 1 avaliou artefato parcial (trigger + concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes. Demais critérios pass sobre conteúdo presente. tq-ln-01 pass (12 condições testáveis, 5 excludeWhen). 13 conceitos presentes com dependsOn consistentes."
	}]

	findings: {
		"uq-08": {
			criterion: "uq-08"
			severity:  "fail"
			message:   "Campos obrigatórios ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. Artefato parcial — aguardando conteúdo restante do founder."
		}
	}

	summary: """
		Lente de complex adaptive systems parcial com 13 conceitos, trigger
		(12 condições, 18 grupos de keywords, 5 excludeWhen). Round 1 identifica
		fail por campos obrigatórios ausentes (artefato parcial). uq-08 pendente
		validação cue vet. Aguardando reasoningProtocol, meshExamples, principleIds,
		relatedLenses, limitations e rationale do founder.
		"""
}
