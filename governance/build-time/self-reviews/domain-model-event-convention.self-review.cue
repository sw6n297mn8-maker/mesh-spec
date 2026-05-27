package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainModelEventConvention: build_time.#SelfReviewReport & {
	reportId: "srr-domain-model-event-convention"

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
			sc-ev-01 (kind regex-pattern-match, adr-107), born-warn. Aprovado pelo
			founder. Conformancia #StructuralCheck: id sc-ev-01; artifactType
			"domain-model" ∈ #ArtifactType (roda contra todos os contexts/*/domain-model.cue);
			kind↔rule regex-pattern-match {valuePath "events[].name", pattern
			"^[A-Z][A-Za-z0-9]*$"}; errorMessage acionavel (normalizar + mover detalhe
			p/ description); rationale conecta ao adr-104 (name é chave cross-artifact).
			enforcement "warn".

			Estado verificado: dispara em 22 de 83 names (rew parentéticos, dlv/inv
			espaços) — born-warn como inventário, NÃO born-green. 0 bloqueantes. A
			normalização dos 22 → promoção a reject é sub-pass futuro (decisões de
			nome). cue vet 0; runner default exit 0.
			"""
	}]

	findings: {}

	summary: """
		sc-ev-01: convenção de event-name PascalCase via regex-pattern-match (adr-107),
		born-warn. Dispara em 22 names não-normalizados (inventário). Trava o
		vocabulário do adr-104 em warn; reject após normalização. Conforma
		#StructuralCheck; sem findings fail/warn no self-review.
		"""

	singleRoundRationale: "Uma rodada: instância direta do kind adr-107 (aprovado antes da escrita), born-warn, efeito (22 findings, 0 bloqueantes) medido por cue vet + runner. Sem espaço de red-team."
}
