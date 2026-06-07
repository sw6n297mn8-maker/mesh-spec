package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def050: build_time.#SelfReviewReport & {
	reportId: "srr-def-050-port-interface-conformance-runtime"

	artifactPath:       "architecture/deferred-decisions/def-050-port-interface-conformance-runtime.cue"
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
			Self-review em sessao: deferimento da conformancia interface-Kotlin<->manifest (cross-repo).
			Conforma #DeferredDecision (status open; description, deferralRationale, triggerCalibrationRationale,
			costOfDeferral.description e trigger manual-review.reason satisfazem os MinRunes impostos por cue
			vet). A PREFERENCIA explicita por GERAR a interface mora aqui (no def), nao no adr-144 — coerente
			com o re-review isolado conjunto que confirmou def-050 como deferimento NEUTRO e ten-015
			neutralizado (gerar OU gate runtime). trigger manual-review justificado (2 julgamentos
			qualitativos do founder, nao machine-evaluable). cue vet pass. Sem fail.
			"""
	}]

	findings: {}

	summary: """
		def-050 (conformancia interface-Kotlin<->manifest, cross-repo; preferencia=gerar a interface).
		Self-review LIMPO: conforma #DeferredDecision, trade-off articulado, trigger manual-review
		justificado, coerente com ten-015 neutralizado. cue vet pass.
		"""

	singleRoundRationale: """
		1 round: conforma ao #DeferredDecision (cue vet impoe MinRunes + a uniao por status), com trade-off
		concreto e a preferencia (gerar) corretamente alojada no def — sem fail.
		"""
}
