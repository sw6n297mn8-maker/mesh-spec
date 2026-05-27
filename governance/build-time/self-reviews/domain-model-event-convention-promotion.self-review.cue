package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainModelEventConventionPromotion: build_time.#SelfReviewReport & {
	reportId: "srr-domain-model-event-convention-promotion"

	artifactPath:       "architecture/structural-checks/domain-model-event-convention.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Delta (adr-108): sc-ev-01 promovido de enforcement "warn" para "reject"
			após a normalização dos 22 event-names. Aprovado pelo founder.

			Conformancia: enforcement "reject" é valor válido do enum; id/kind/rule/
			errorMessage/rationale intactos (rationale e comentário atualizados para
			refletir a promoção). cue vet 0.

			Efeito verificado: com os 22 normalizados, sc-ev-01 reporta zero violações;
			runner default → 0 bloqueantes, exit 0. Teste adversarial confirma dentes:
			name não-canônico ("Delivery Borked") → sc-ev-01 reject FAIL, exit 1.
			Catraca adr-097: promovido por estar comprovadamente verde.
			"""
	}]

	findings: {}

	summary: """
		sc-ev-01 promovido a reject (adr-108) após a normalização dos 22 event-names
		→ zero violações. Convenção de event-name agora bloqueia no CI. Conforma
		#StructuralCheck; sem findings fail/warn.
		"""

	singleRoundRationale: "Uma rodada: promoção warn→reject executando decisão aprovada (adr-108), com zero violações e teste adversarial (exit 1) verificados. Sem espaço de red-team."
}
