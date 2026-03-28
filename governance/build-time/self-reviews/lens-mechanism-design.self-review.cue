package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensMechanismDesign: build_time.#SelfReviewReport & {
	reportId: "srr-lens-mechanism-design"

	artifactPath:       "architecture/lenses/lens-mechanism-design.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: "Correção mecânica: adição de nome de variável CUE (mechanismDesign:) para evitar conflito de unificação com outras lenses no mesmo package. Sem alteração semântica."

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Correção mecânica de sintaxe CUE. Adição de nome de variável top-level para conformar com padrão usado em todas as outras lenses do package. Sem alteração de conteúdo."
	}]

	findings: {}

	summary: """
		Correção mecânica: declaração anônima no top-level causava conflito
		de unificação CUE com lens-real-options.cue. Adicionado nome de
		variável mechanismDesign: seguindo padrão das demais lenses.
		"""
}
