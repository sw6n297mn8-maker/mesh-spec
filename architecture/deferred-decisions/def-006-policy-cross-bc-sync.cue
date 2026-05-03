package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-006": artifact_schemas.#DeferredDecision & {
	id:    "def-006"
	title: "Policy cross-BC sync — como manter consistência de versão e estado entre BCs que avaliam mesma policy"
	date:  "2026-05-03"

	description: """
		Quando 2+ BCs avaliam mesma policy cross-BC, surge questão de
		sincronização: (a) cada BC carrega versão local da policy
		(eventually consistent via PLR) com risco de avaliação sob
		estados diferentes; (b) BCs consultam PLR em runtime (acoplamento
		PLR-as-runtime, contradiz adr-065 enforcement: external);
		(c) policy push proativo via event-driven (PLR notifica BCs em
		mudança). Decisão depende de tolerância a inconsistência +
		latência aceitável.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue",
		"governance/build-time/task-specs/wi-040.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Sync mechanism só faz sentido quando 2+ cross-BC policies
		coexistem — questão de consistência inter-BC só emerge com
		volume. Com 0 ou 1 cross-bc policies, sync é abstrato. Custo
		de continuar deferindo: zero HOJE; cresce quando 2ª cross-bc
		instance materializar. Trade-off: aguardar 2 cases vs design
		sync engine sem instância de teste real.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence) usa mesmo pattern de def-005 mas
		threshold=2 — 2ª cross-bc instance é sinal de que sync
		question vira concrete (não abstract). Pattern verificado
		clean (NÃO self-matches schema). Trigger 2 (manual-review)
		escape para priorização antes — e.g., quando regulatory
		ambiguity entre BCs detectada antes de 2 cases.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "cross-cutting"
		description: """
			Com 0-1 cross-bc policies, sync gap é teórico. Severity low
			HOJE; cresce para medium quando 2+ cross-bc instances coexistem
			(silent inconsistency entre BCs vira risco real). blastRadius
			cross-cutting porque qualquer sync issue afeta múltiplos BCs.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "scope:\\s+\"cross-bc\""
		scope:     "file-content"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar sync mechanism antes de 2ª instância — e.g., quando regulatory ambiguity entre BCs detectada (mesma regulação interpretada diferentemente por BC) ou quando enforcement consistency é requirement legal antecipado."
	}]

	status: "open"
}
