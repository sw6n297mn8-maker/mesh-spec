package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def021: artifact_schemas.#DeferredDecision & {
	id:    "def-021"
	title: "Check de integrationEvents do cross-context-flow contra domain-model events (dimensão events)"
	date:  "2026-05-26"

	description: """
		Autorar um check (scoped-cross-file-id-exists, como o sc-cm-06) que verifique
		que todo phases[].integrationEvents do cross-context-flow existe em
		contexts/*/domain-model.cue events[].name, escopado a phases cujo ownerContext
		seja um BC construído. adr-112 cobriu ownerContext (sc-ccf-01) e ownerSubdomain
		(sc-ccf-02); falta a dimensão integrationEvents.
		"""

	deferralRationale: """
		MOTIVO: dos 9 integrationEvents do commitment-lifecycle, 3 não resolvem hoje
		(BudgetCommitted, CommitmentClosed, PaymentSettled). Mix de (a) event de BC
		construído ainda não materializado no domain-model (bdg/cmt podem não ter
		BudgetCommitted/CommitmentClosed) e (b) BC planejado (PaymentSettled → fce, sem
		domain-model). Mesma natureza do def-019 (events↔BC): gatear cru afoga sinal
		real em ruído de roadmap/incompletude.
		RISCO de gatear agora: 3 falsos/incompletos → born-red, perde sinal. Custo de
		deferir: um integrationEvent fictício passa — baixo, pois o cross-context-flow
		é singleton revisado e os events são roadmap.
		"""

	triggerCalibrationRationale: """
		Trigger manual-review: a precondição é a materialização dos 3 events nos
		domain-models (built BCs completam BudgetCommitted/CommitmentClosed; fce
		materializa PaymentSettled) — não há path único machine-evaluable. Quando o
		sc-cm-06 (events↔BC) cobrir built↔built sem gaps e os 3 resolverem, autora-se
		o check scoped de integrationEvents. Founder revisita nessa materialização.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-112-cross-context-flow-crossfile-check.cue",
		"architecture/deferred-decisions/def-019-events-bc-cross-file-check.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			A dimensão integrationEvents do cross-context-flow fica sem gate enquanto os
			3 events não materializam. Baixo: cross-context-flow é singleton revisado;
			ownerContext/ownerSubdomain (as âncoras estruturais) já são gateados por
			sc-ccf-01/02. Não-cumulativo.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Precondição é materialização dos 3 integrationEvents não-resolvidos nos domain-models (built completam BudgetCommitted/CommitmentClosed; fce materializa PaymentSettled) — não machine-evaluable. Founder revisita e então autora o check scoped de integrationEvents."
	}]

	status: "open"
}
