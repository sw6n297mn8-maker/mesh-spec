package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr018: build_time.#SelfReviewReport & {
	reportId: "srr-adr-018"

	artifactPath:       "architecture/adrs/adr-018-self-review-hardening.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	generatedAt:     "2026-03-20"

	roundsExecuted: 4
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Draft validado contra uq-01 a uq-08 e tq-adr-01 a tq-adr-03. Todos passam."
	}, {
		round:     2
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "uq-05: consequences afirmava 'todos os tipos em #ArtifactType' — canvas não tem schema. Corrigido para 'tipos com schema existente'. Fail resolvido."
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Verificação pós-correção de consequences. Sem findings novos."
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Estabilidade confirmada. Zero fails, zero regressões."
	}]

	findings: {}

	summary: """
		ADR registra decisão de hardening do self-review: severity
		invariant, tq-srr-04, meta-schema, e maxRounds 3→4. Round 2
		corrigiu afirmação imprecisa em consequences (canvas gap).
		Estabilizado em round 3.
		"""
}
