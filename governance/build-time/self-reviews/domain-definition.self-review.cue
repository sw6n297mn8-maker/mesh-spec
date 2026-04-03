package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainDefinitionSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-domain-definition-autonomy-ref-fix"

	artifactPath:       "domain/domain-definition.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-definition.cue"
	artifactType:       "domain-definition"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-02"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Mudança estritamente editorial: substituição de referência stale
		'autonomy-policy.cue por bounded context' pelo caminho correto
		da governança de agentes (architecture/agent-governance.cue global
		+ contexts/{bc}/agents/{name}.governance.cue per-agent envelope).
		Nenhum campo novo, nenhuma semântica alterada, nenhum tipo
		modificado. Alinhamento com ADR-037 e agent-governance.cue.
		Round único justificado porque não há decisão de design —
		apenas correção de referência textual dentro de description.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Verificação da referência corrigida no campo description do
			mechanism mech-agent-gate: 'autonomy-policy.cue por bounded
			context' substituído por referência aos artefatos de governança
			reais definidos em ADR-037. Texto mantém coerência com o
			mecanismo descrito. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Correção editorial de referência stale em domain/domain-definition.cue:
		autonomy-policy.cue → governança de agentes (dois níveis, ADR-037).
		Estável em 1 round — mudança editorial sem decisão de design.
		"""
}
