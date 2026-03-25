package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lens: build_time.#SelfReviewReport & {
	reportId: "srr-lens"

	artifactPath:       "architecture/artifact-schemas/lens.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Mudança mecânica: expansão de enum reviewCadence em #LensConcept de 3 para 5 variantes (adição de \"monthly\" e \"event-driven\"). Sem alteração estrutural, sem novos campos, sem mudança de tipos. uq-01 a uq-08 avaliados — todos passam. tq-as-01 a tq-as-03 avaliados — todos passam. Nenhum finding."
	}]

	findings: {}

	singleRoundRationale: "Mudança é estritamente mecânica — adição de 2 variantes a disjunção existente. Não altera estrutura do schema, não introduz novos campos, não afeta constraints. Complexidade insuficiente para gerar findings em rounds adicionais."

	summary: """
		Expansão de enum reviewCadence em #LensConcept para acomodar
		cadências usadas pelas 37 lentes analíticas: "monthly" (conceitos
		operacionais de alta volatilidade) e "event-driven" (conceitos
		cuja revisão é disparada por evento externo, não por calendário).
		Mudança mecânica, zero findings em 1 round.
		"""
}
