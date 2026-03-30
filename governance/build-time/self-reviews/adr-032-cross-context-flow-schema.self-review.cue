package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr032: build_time.#SelfReviewReport & {
	reportId: "srr-adr-032-cross-context-flow-schema"

	artifactPath:       "architecture/adrs/adr-032-cross-context-flow-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-30T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ADR-032 avaliado contra 8 critérios universais (uq-01 a uq-08)
		e 3 type-specific (tq-adr-01 a tq-adr-03). (uq-01) rationale
		explica WHY: schema nasce de necessidade concreta de modelar
		commitment lifecycle como composição de BCs. (uq-02) Mesh-specific:
		vinculado a ECL, subdomínios, lenses, BCs Wave 0. (uq-03) refs
		válidas: P0, P1, dp-01, dp-03, dp-05 existem em design-principles;
		affectedArtifacts path será criado como output da decisão. (uq-04)
		consistente com P0 (artefatos CUE), dp-01 (domínio antes de
		tecnologia), dp-03 (blast radius), dp-05 (auditabilidade). (uq-05)
		limitações declaradas: v1 linear, refs por nome sem validação CUE
		nativa, #ArtifactType pendente. (uq-06) terminologia consistente
		(CrossContextFlow, BoundedContextRef). (uq-07) zero placeholders.
		(uq-08) conforme #ADR schema. (tq-adr-01) alternativa considerada
		e rejeitada: markdown/diagrama ad hoc — viola princípio de formato
		e não permite validação CI. (tq-adr-02) metadata de risco
		consistente: reversibility high (pre-código, sem dados persistidos),
		blastRadius cross-artifact (novo schema + self-review + instâncias
		futuras). (tq-adr-03) affectedArtifacts: path do schema será criado
		no mesmo commit. Zero findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Avaliação contra 11 critérios (8 universais + 3 type-specific). Alternativa documentada (markdown ad hoc rejeitada). Metadata de risco consistente com decisão pre-código. Paths verificáveis. Zero findings."
	}]

	findings: {}

	summary: "ADR-032 estável no round 1. Registra introdução do schema #CrossContextFlow motivado pela decomposição de ECL. Zero findings em 11 critérios."
}
