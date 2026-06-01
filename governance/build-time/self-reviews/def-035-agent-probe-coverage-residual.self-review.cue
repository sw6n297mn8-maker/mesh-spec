package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def035: build_time.#SelfReviewReport & {
	reportId: "srr-def-035-agent-probe-coverage-residual"

	artifactPath:       "architecture/deferred-decisions/def-035-agent-probe-coverage-residual.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-31"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-035 (residual do Ciclo 4). Avaliado contra 8
			universalCriteria + critério anti-catch-all do CLAUDE.md (deferimento
			consciente exige trade-off articulado + condição de revisita).

			Pertinência (anti-dumping): def-035 NÃO é trabalho rotineiro nem bug travestido
			— é deferimento consciente com trade-off explícito (custo evitado: born-red +
			automação prematura + PG especulativo; custo de continuar: warn permanente/
			zombie) E condição codificada de revisita (manual-review + recurrence
			threshold 2). Pass.
			uq-01 (WHY): deferralRationale explica por que adiar cada item (promoção só
			com cobertura verde; automação depende de secret/ops; painel depende de
			def-034). Pass.
			uq-03 (refs): originatingArtifacts aponta a adr-134 (criado no mesmo PR);
			referencia def-029/def-034 existentes. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #DeferredDecision): id/title/date/status/description/
			deferralRationale/triggerCalibrationRationale/originatingArtifacts/
			costOfDeferral/triggers presentes; trigger recurrence tem pattern/scope/
			threshold; manual-review tem reason. cue vet EXIT=0. Pass.
			"""
	}]

	findings: {}

	summary: """
		def-035 registra o residual do Ciclo 4 (promover cobertura warn->reject;
		automação do dispatch; wiring no painel def-034; PGs dos 2 tipos) como
		deferimento consciente per adr-062 — trade-off articulado + revisita por
		manual-review + recurrence (2º record). Lar do residual citado pelo adr-134
		(sem prose 'Known gaps'). Colisão de id com earmark do audit WI-132 resolvida
		(Ciclo 4 materializa primeiro -> fica com 035). Estável em 1 round.
		"""

	singleRoundRationale: """
		DD mirror estrutural de def-034 (mesmo schema, mesmos campos); conteúdo deriva
		direto das decisões do adr-134. Pertinência anti-catch-all e conformance ao
		schema verificáveis por inspeção direta. Sem ambiguidade pendente.
		"""
}
