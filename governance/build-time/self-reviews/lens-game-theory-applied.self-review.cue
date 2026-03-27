package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensGameTheoryApplied: build_time.#SelfReviewReport & {
	reportId: "srr-lens-game-theory-applied"

	artifactPath:       "architecture/lenses/lens-game-theory-applied.cue"
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
		summary:   "Artefato parcial por instrução do founder — contém trigger (12 conditions, 33 keywords) e 13 concepts com dependências internas válidas. Faltam seções obrigatórias do schema #AnalyticalLens: reasoningProtocol, meshExamples, principleIds, relatedLenses, limitations, rationale. uq-08 falha por incompletude estrutural. Demais critérios aplicáveis às seções presentes passam: rationales explicam WHY (uq-01), conceitos ancorados em mecanismos Mesh como adverse selection no bootstrap, multi-homing em construção civil, scoring e bypass (uq-02), concept IDs únicos e dependsOn resolvem internamente (uq-03), zero placeholders (uq-07)."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Artefato parcial: faltam reasoningProtocol, meshExamples, principleIds, relatedLenses, limitations e rationale. Founder instruiu escrita parcial com complemento posterior."
		}]
	}

	summary: """
		Lente parcial de Teoria dos Jogos Aplicada (lens-game-theory-applied).
		Contém trigger e 13 concepts. Seções obrigatórias pendentes serão
		fornecidas pelo founder. uq-08 fail por incompletude estrutural
		explícita e aceita.
		"""
}
