package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr034SelfReview: build_time.#SelfReviewReport & {
	reportId:           "srr-adr-034-canvas-schema-evolution"
	artifactPath:       "architecture/adrs/adr-034-canvas-schema-evolution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"
	canonicalSource:    "governance/build-time/quality-gate.cue"
	executionMode:      "isolated-subagent"
	generatedAt:        "2026-04-01"
	roundsExecuted:     1
	maxRounds:          4
	status:             "stable"

	singleRoundRationale: """
		ADR-034 documenta evolução estrutural do canvas schema e adição de
		#ExternalSystemRef ao context-map. Sub-agente isolado avaliou contra
		11 critérios (uq-01..uq-08 + tq-adr-01..tq-adr-03). Alternativa
		considerada presente (canvas mínimo + artefatos separados, rejeitada).
		Metadata de risco coerente: reversibility high (sem canvases commitados),
		blastRadius cross-artifact (2 schemas). Paths em affectedArtifacts e
		derivedArtifacts verificados como existentes. principlesApplied (P0, P1,
		dp-08, dp-10) rastreáveis. Zero findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou ADR-034 contra uq-01..uq-08 e tq-adr-01..tq-adr-03. Context descreve 6 gaps concretos identificados durante planejamento do primeiro canvas (CMT). Decision enumera 12 mudanças no canvas + 1 no context-map. Consequences lista 4 positivas e 4 negativas. Alternativa de artefatos separados rejeitada por fragmentação. reversibility high justificada pela ausência de canvases commitados. blastRadius cross-artifact coerente com 2 schemas afetados. Paths verificados no disco. Zero findings."
	}]

	findings: {}

	summary: """
		ADR-034 estável em 1 round por sub-agente isolado. Documenta
		evolução do canvas de identidade mínima para documento raiz completo
		e adição de identidade canônica para sistemas externos. Zero findings.
		"""
}
