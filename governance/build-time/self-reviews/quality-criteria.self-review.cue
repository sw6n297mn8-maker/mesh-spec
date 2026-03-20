package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteria: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria"

	artifactPath:       "architecture/artifact-schemas/quality-criteria.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-20"

	roundsExecuted: 4
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Adição de _severityInvariant a #QualityCriterionFinding validada contra uq-01 a uq-08 e tq-as-01 a tq-as-03. Todos passam."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Consistência cross-file verificada: _severityInvariant referencia tq-srr-04, criado no mesmo commit. Sem findings."
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Verificação de impacto em instâncias existentes de #QualityCriterionFinding. Hidden fields com defaults não quebram instâncias. Sem findings."
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Estabilidade confirmada."
	}]

	findings: {}

	summary: """
		Adição de _severityInvariant a #QualityCriterionFinding —
		política canônica de que finding.severity == criterion.severity.
		Campo hidden com valores constantes, não impacta instâncias
		existentes. Enforcement por protocolo (tq-srr-04) e CI futuro.
		Estável desde round 1.
		"""
}
