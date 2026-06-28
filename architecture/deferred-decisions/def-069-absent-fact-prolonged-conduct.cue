package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def069: artifact_schemas.#DeferredDecision & {
	id:     "def-069"
	title:  "Ausência prolongada de invoice/eligibility no PrePaymentGuard: timeout/fail-safe operacional?"
	date:   "2026-06-28"
	status: "open"

	description: """
		adr-161 fixa que invoice/eligibility AUSENTE no authorize fica guarded
		(waiting-for-information), sem escalar. Fica deferido SE a ausência
		PROLONGADA deve virar escalation ou outro fail-safe operacional — e qual
		política (janela de tempo, qual informação falta, severidade, SLA,
		responsável, consequência) governaria essa transição.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: decidir a conduta de ausência-prolongada exigiria
		cravar parâmetros operacionais (SLA, janela de tempo, ownership,
		consequência) sem dados de produção e sem o mecanismo de tempo/agenda do
		FCE — cristalizaria política por palpite, o oposto do gate determinístico.
		CUSTO EVITADO: uma policy de timeout arbitrária que provavelmente seria
		refeita ao primeiro contato com produção. CUSTO de continuar deferindo:
		baixo — enquanto não há fluxo de produção materializando Payments (o único
		caller hoje é o teste de composição), a ausência-prolongada não ocorre, e
		a conduta waiting de adr-161 já é segura (fica guarded, dinheiro não move).
		"""

	triggerCalibrationRationale: """
		manual-review-only: a condição (ausência prolongada causar dano) só é
		avaliável com fluxo de produção real MAIS uma política de SLA do founder;
		não há sinal machine-evaluable no mesh-spec hoje (sem scheduler do FCE,
		sem Payments de produção). adjacent-need sobre a existência do mecanismo de
		tempo/agenda do FCE serviria quando esse artefato existir — hoje seria
		trigger para um alvo inexistente.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-161-absent-fact-conduct-prepayment-guard.cue",
		"session:fce-fatia3-ghost-ausencia",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Sem fluxo de produção (só o teste de composição cria Payments), a
			ausência-prolongada não ocorre; a conduta waiting de adr-161 já é segura
			(guarded, dinheiro não move). O custo é apenas a política futura de
			timeout não-escrita, contida ao guard do FCE.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Ausência-prolongada exige política operacional (SLA / janela /
			ownership / consequência) do founder somada a fluxo de produção real;
			não é machine-evaluable no estado atual do repo (sem scheduler, sem
			Payments de produção).
			"""
	}]
}
