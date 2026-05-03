package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-008": artifact_schemas.#DeferredDecision & {
	id:    "def-008"
	title: "Policy distributed evaluation — onde executar avaliação de policy quando múltiplos consumers possíveis"
	date:  "2026-05-03"

	description: """
		Quando 2+ artefatos consomem mesma policy (e.g., command handler
		+ event reactor + agent envelope), surge questão de onde
		avaliar: (a) cada consumer avalia independentemente (duplicação
		de logic, risco de divergence); (b) shared evaluator service
		(acoplamento + latência); (c) decision cached + invalidated por
		event (eventually consistent); (d) re-evaluation fresh em cada
		consumer. Trade-off: duplicação vs latência vs consistency.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue",
		"governance/build-time/task-specs/wi-040.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Distributed evaluation pattern só faz sentido quando 2+
		consumers compartilham mesma policy. Com volume baixo de
		policies, cada uma tem 1 consumer típico (próprio BC). Quando
		policy começar a ser referenciada por múltiplos artifacts
		(commands + events + agents), surge questão de evaluation
		locality. Custo de continuar deferindo: zero HOJE; cresce
		com cross-references.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence filename) detecta volume via mesmo
		pattern de def-007 mas threshold=2 — 2+ policies é sinal mais
		precoce de que evaluation locality começa a aparecer (cada
		policy potencialmente usada por múltiplos consumers internos
		do BC). Trigger 2 (manual-review) escape para priorização
		antecipada — e.g., quando 1ª policy explicitamente referenciada
		por agent-governance E command handler simultaneamente.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "cross-artifact"
		description: """
			Distributed evaluation gap é teórico com volume baixo. Cada
			policy pode ter 1 consumer típico até 2+ consumers materializem.
			Severity low HOJE; cresce quando policy compartilhada vira
			pattern. blastRadius cross-artifact porque evaluation locality
			afeta múltiplos consumers do mesmo policy.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "^domain/policies/pol-"
		scope:     "filename"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar distributed evaluation pattern antes de 2 policies — e.g., quando 1ª policy é simultaneamente referenciada por #AgentGovernanceEnvelope + command handler de BC + reactor de event, antecipando que cross-reference pattern materializa imediatamente."
	}]

	status: "open"
}
