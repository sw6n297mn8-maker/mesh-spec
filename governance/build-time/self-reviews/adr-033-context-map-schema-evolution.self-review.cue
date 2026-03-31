package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr033SelfReview: build_time.#SelfReviewReport & {
	reportId:           "srr-adr-033-context-map-schema-evolution"
	artifactPath:       "architecture/adrs/adr-033-context-map-schema-evolution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"
	canonicalSource:    "governance/build-time/quality-gate.cue"
	executionMode:      "isolated-subagent"
	generatedAt:        "2026-03-31"
	roundsExecuted:     1
	maxRounds:          4
	status:             "stable"

	singleRoundRationale: """
		ADR-033 é decisão estrutural com escopo bem delimitado (evolução de
		um schema existente). Todos os 11 critérios (8 universais + 3
		type-specific) passaram sem findings no round 1 executado por
		sub-agente isolado. Alternativa considerada presente, metadata de
		risco coerente, paths em affectedArtifacts verificados como
		existentes, principlesApplied rastreáveis em design-principles.cue
		e domain-definition.cue.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou ADR-033 contra 11 critérios (uq-01..uq-08 + tq-adr-01..tq-adr-03). Zero findings: schema conforma com #ADR, rationale explica WHY (necessidade concreta durante construção da instância com 21 BCs), alternativa de texto livre rejeitada por violar P1, reversibility high justificada pela ausência de dados persistidos, blastRadius cross-artifact coerente com impacto em schema + instância, paths verificados como existentes no repositório."
	}]

	findings: {}

	summary: """
		ADR-033 documenta evolução do schema #ContextMap de 8 para 23
		variantes com typed endpoints, FlowPayload e external relationships.
		Self-review estável em 1 round por sub-agente isolado — todos os
		critérios universais e type-specific satisfeitos sem findings.
		"""
}
