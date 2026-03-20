package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

artifactSchema: build_time.#SelfReviewReport & {
	reportId: "srr-artifact-schema"

	artifactPath:       "architecture/artifact-schemas/artifact-schema.cue"
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
		summary:   "Draft inicial validado contra uq-01 a uq-08 e tq-as-01 a tq-as-03 (auto-referencial). Todos passam."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Verificação de blind spots e consistência cross-file. Sem findings novos."
	}, {
		round:     3
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "tq-as-01 exigia _schema.type que schemas existentes não têm. Critério revisado para exigir apenas _schema.location. Fail resolvido no mesmo round."
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Verificação pós-correção. Zero fails, zero regressões. Estável."
	}]

	findings: {}

	summary: """
		Meta-schema para artifact schemas com 3 critérios type-specific
		(tq-as-01 a tq-as-03). Auto-referencial: passa seus próprios
		critérios. Round 3 encontrou tq-as-01 aspiracional (exigia
		_schema.type inexistente em schemas atuais) — corrigido para
		exigir apenas _schema.location. Estabilizado em round 4.
		"""
}
