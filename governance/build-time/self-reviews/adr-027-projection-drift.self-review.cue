package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr027ProjectionDrift: build_time.#SelfReviewReport & {
	reportId: "srr-adr-027-projection-drift"

	artifactPath:       "architecture/adrs/adr-027-projection-drift.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-22T14:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ADR-027 documenta decisão de drift detection já validada com o
		founder durante revisão da proposta de projection-drift.cue (3
		rounds de red-team + 2 ajustes explícitos aprovados). Alternativa
		rejeitada (auto-rebuild) está documentada no task spec e no ADR.
		Context, decision e consequences refletem diretamente o feedback
		do founder (união discriminada algorithmRef/algorithm, comparação
		order-insensitive). Critérios type-specific satisfeitos sem
		ambiguidade: alternativas documentadas, risk metadata preenchido,
		paths existem.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "ADR-027 formaliza drift detection entre projeções e SoTs. Context captura o gap (projeções sem enforcement de consistência). Decision descreve registry + pipeline drift-NN + política exact-match. Consequences documenta trade-off de manutenção manual vs auto-rebuild. Alternativa rejeitada (auto-rebuild) viola proposta-antes-de-implementar. Dois ajustes do founder incorporados: união discriminada para algorithmRef/algorithm e comparação order-insensitive. Todos os critérios universais e type-specific passam."
	}]

	findings: {}

	summary: "ADR-027 estável no round 1. Decisão previamente validada com founder em 2 ciclos de feedback. Alternativas documentadas, risk metadata preenchido, affected artifacts correspondem aos artefatos criados no mesmo commit."
}
