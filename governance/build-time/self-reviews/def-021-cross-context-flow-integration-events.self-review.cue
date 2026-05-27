package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def021CrossContextFlowIntegrationEvents: build_time.#SelfReviewReport & {
	reportId: "srr-def-021-cross-context-flow-integration-events"

	artifactPath:       "architecture/deferred-decisions/def-021-cross-context-flow-integration-events.cue"
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
			def-021 defere o check de integrationEvents do cross-context-flow contra
			domain-model events. Formulação aprovada pelo founder no mesmo passo do
			adr-112.

			Conformancia #DeferredDecision:
			- description: PASS (check scoped-cross-file-id-exists, como sc-cm-06, que
			  verifica phases[].integrationEvents ∈ contexts/*/domain-model.cue
			  events[].name, escopado a phases de BC construído).
			- deferralRationale: PASS — MOTIVO: dos 9 integrationEvents do
			  commitment-lifecycle, 3 não resolvem (BudgetCommitted/CommitmentClosed
			  built-incompleto; PaymentSettled→fce planejado). RISCO de gatear agora:
			  3 falsos/incompletos → born-red, perde sinal. Custo de deferir: baixo
			  (flow é singleton revisado; events são roadmap). Mesma natureza do
			  def-019 (events↔BC).
			- triggerCalibrationRationale: PASS (manual-review porque a precondição é
			  a materialização dos 3 events nos domain-models — não machine-evaluable;
			  quando sc-cm-06 cobrir built↔built sem gaps e os 3 resolverem, autora-se
			  o check scoped).
			- originatingArtifacts: PASS (adr-112 + def-019).
			- costOfDeferral: severity low + blastRadius cross-artifact, não-cumulativo
			  (ownerContext/ownerSubdomain já gateados por sc-ccf-01/02).
			- triggers: 1 manual-review com reason. status open.

			Anti-catch-all (adr-062): deferimento genuíno — trade-off articulado
			(custo evitado = born-red por roadmap/incompletude; custo de deferir =
			baixo, mitigado pelas âncoras estruturais já gateadas) e condição de
			revisita (materialização dos 3 events). Não é WI rotineiro nem bug.

			Verificacao: cue vet ./... EXIT 0.
			"""
	}]

	findings: {}

	summary: """
		def-021: deferimento consciente do check de integrationEvents do
		cross-context-flow — prematuro enquanto 3 dos 9 events não materializam
		(built-BC incompleto + fce planejado); gatear cru = born-red. Trigger
		manual-review (materialização dos 3 events nos domain-models). Âncoras
		estruturais (ownerContext/ownerSubdomain) já gateadas por sc-ccf-01/02.
		Conforma #DeferredDecision; sem findings.
		"""

	singleRoundRationale: """
		Uma rodada basta: deferred-decision de registro de trade-off + trigger, cuja
		premissa (3 events não resolvem: BudgetCommitted/CommitmentClosed/
		PaymentSettled) foi verificada empiricamente e cuja estrutura conforma
		#DeferredDecision (cue vet 0). Sem espaco de decisao aberto a red-team.
		"""
}
