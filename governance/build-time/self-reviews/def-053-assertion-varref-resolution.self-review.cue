package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def053: build_time.#SelfReviewReport & {
	reportId: "srr-def-053-assertion-varref-resolution"

	artifactPath:       "architecture/deferred-decisions/def-053-assertion-varref-resolution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review em sessao do deferimento de ENFORCEMENT da resolucao #VarRef.var -> #Variable.name no
			#Assertion: o kind local-field-reference-integrity (adr-100) so percorre 1 nivel (_resolve_multi),
			nao a arvore recursiva de predicados -- gap real, nao gate-able hoje. Conforma #DeferredDecision
			(status open; description/deferralRationale/triggerCalibrationRationale >= MinRunes; costOfDeferral
			low/local; 1 trigger). tq-def-01 OK (trade-off articulado: review-trusted com 1 assertion vs
			fabricar kind sob 1 instancia -- anti-pattern recusado no adr-144 C5). tq-def-03 (manual-only)
			satisfeito pela excecao: triggerCalibrationRationale articula por que os gatilhos nao sao
			machine-evaluable. Distinto de def-054 (gramatica) e def-049 (mecanismo). cue vet pass.
			"""
	}]

	findings: {}

	summary: """
		def-053 (enforcement var->variables, deferido por inexpressibilidade do kind recursivo atual).
		Self-review LIMPO: conforma #DeferredDecision; trade-off review-trusted articulado; manual-only
		justificado (gatilhos nao machine-evaluable); distincao explicita de def-054/def-049. cue vet pass.
		"""

	singleRoundRationale: """
		1 round: conforma ao schema e o trade-off (review-trusted ate kind recursivo existir; nao mintar
		kind por 1 instancia per adr-144 C5) esta articulado -- sem fail nem warn.
		"""
}
