package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def052: build_time.#SelfReviewReport & {
	reportId: "srr-def-052-manifest-cross-file-scoping"

	artifactPath:       "architecture/deferred-decisions/def-052-manifest-cross-file-scoping.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review em sessao: deferimento do scoping plain-vs-instance-scoped dos cross-file checks de
			manifest, AMPLIADO (finding #4 do re-review conjunto) para cobrir tambem a existencia de
			cmd/evt/inv no domain-model — os dois sao a mesma pergunta de scoping. Conforma #DeferredDecision
			(status open; MinRunes OK). trade-off: o item 5 escolheu plain explicitamente (precedente
			sc-sv-01, dormant-safe); o aperto para instance-scoped (same-BC) so se justifica com evidencia
			de falso-positivo real (ref cross-BC indevida). trigger manual-review. cue vet pass. Sem fail.
			"""
	}]

	findings: {}

	summary: """
		def-052 (scoping plain-vs-instance-scoped dos cross-file checks de manifest; ampliado p/ existencia
		cmd/evt/inv). Self-review LIMPO: conforma #DeferredDecision; escopo ampliado coerente (mesma
		pergunta nos dois eixos); trigger manual-review justificado. cue vet pass.
		"""

	singleRoundRationale: """
		1 round: conforma ao schema; o escopo ampliado (ref-integrity + existencia de ids, mesma decisao
		plain-vs-instance-scoped) e coerente e o trade-off (plain por precedente; apertar so com evidencia)
		esta articulado — sem fail.
		"""
}
