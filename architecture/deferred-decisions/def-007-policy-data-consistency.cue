package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-007": artifact_schemas.#DeferredDecision & {
	id:    "def-007"
	title: "Policy data consistency over EC projections — garantias de consistência quando policy avalia projeções eventually-consistent"
	date:  "2026-05-03"

	description: """
		Policies financeiras frequentemente dependem de projeções
		eventually-consistent (e.g., exposure limit consulta running
		balance projection). Sem garantias de consistency, decisões
		podem ser tomadas sobre estado stale. Decisão a tomar quando
		volume justify: (a) snapshot isolation no momento da avaliação;
		(b) read-your-writes consistency dentro do BC; (c) accepting
		eventual consistency com compensating actions; (d) strong
		consistency só para regulatory class. Trade-off: latência vs
		correção decisional.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue",
		"governance/build-time/task-specs/wi-040.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Data consistency framework só vira concreto quando 3+ policies
		coexistem (especialmente se múltiplas dependem de mesma
		projection). Com volume baixo, cada policy pode tratar
		consistency caso-a-caso em sua definition. Framework prematuro
		impõe premature commitment a uma garantia (snapshot/read-your-
		writes/eventual) sem dados sobre quais funcionam para quais
		policies. Trade-off: aguardar volume vs over-specification.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence filename) detecta volume de policies
		via filename pattern '^domain/policies/pol-' em scope=filename.
		Threshold=3 — 3+ policy instances é sinal de que consistency
		question vira concrete (especialmente porque algumas
		provavelmente dependem de projections compartilhadas).
		Trigger 2 (manual-review) escape para priorização antecipada
		— e.g., quando 1ª policy financeira concreta com dependency
		em EC projection é proposed e founder antecipa que pattern
		vai recur.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "cross-artifact"
		description: """
			Com poucas policies, cada uma resolve consistency caso-a-caso
			em definition. Severity low HOJE; cresce com volume +
			especialmente quando policies financeiras (regulatory class)
			dependem de exposure projections. blastRadius cross-artifact
			porque consistency framework afeta multiple policies + suas
			projection dependencies.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "^domain/policies/pol-"
		scope:     "filename"
		threshold: 3
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar consistency framework antes de 3 policies — e.g., quando 1ª regulatory financial policy concreta materializa com dependency explícita em EC projection (e.g., exposure limit sobre running balance), antecipando que pattern vai recur."
	}]

	status: "open"
}
