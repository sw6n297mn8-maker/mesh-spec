package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def019EventsBcCrossFileCheck: build_time.#SelfReviewReport & {
	reportId: "srr-def-019-events-bc-cross-file-check"

	artifactPath:       "architecture/deferred-decisions/def-019-events-bc-cross-file-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

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
			def-019 defere o check cross-file events↔BC per adr-103. Aprovado pelo
			founder.

			Conformancia #DeferredDecision:
			- description: PASS (autorar cross-file-id-exists para events do context-map).
			- deferralRationale: PASS (custo evitado = gate cheio de falso-positivo;
			  investigação adr-103 mostrou events não materializados, sem fonte
			  canônica de id; BankSettlementConfirmed inexistente).
			- triggerCalibrationRationale: PASS (articula POR QUE manual-review e não
			  file-exists — events materializam por BC, sem path único nem convenção
			  canônica de id; manual-review é articulado, não preguiça per adr-062).
			- originatingArtifacts: PASS (adr-103 + adr-102).
			- costOfDeferral: severity low + blastRadius cross-artifact, não-cumulativo
			  (events são roadmap, não contrato ativo).
			- triggers: 1 manual-review com reason. status open.

			Anti-catch-all (adr-062): deferimento genuíno com trade-off articulado e
			condição de revisita (materialização de events). Não é WI rotineiro,
			tension nem bug travestido — é decisão de NÃO gatear até a precondição
			(events estruturados) existir.

			Verificacao: cue vet ./... EXIT 0.
			"""
	}]

	findings: {}

	summary: """
		def-019: deferimento consciente do check events↔BC até os events
		materializarem como artefato estruturado com fonte canônica de id. Trigger
		manual-review articulado (sem path único machine-evaluable). Conforma
		#DeferredDecision; sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: deferred-decision de registro de trade-off + trigger, cuja
		premissa (events não materializados) foi verificada empiricamente em adr-103
		e cuja estrutura conforma #DeferredDecision (cue vet 0). Sem espaco de decisao
		aberto a red-team.
		"""
}
