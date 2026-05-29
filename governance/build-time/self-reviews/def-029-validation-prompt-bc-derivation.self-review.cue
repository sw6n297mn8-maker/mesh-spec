package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def029: build_time.#SelfReviewReport & {
	reportId: "srr-def-029"

	artifactPath:       "architecture/deferred-decisions/def-029-validation-prompt-bc-derivation.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			def-029 difere a criação de um validation-prompt advisory para revisão
			de derivação de BC. Avaliado contra uq-01..09 + tq-def-01..04.

			tq-def-01 (trade-off concreto): deferralRationale articula custo
			evitado (autoria de prompt mal-calibrado sem derivações reais) vs
			custo de continuar (derivações sem design review dedicado, mitigado
			por self-review + founder). Não é "fazer depois".

			tq-def-02/03 (triggers codificados; ao menos 1 non-manual):
			manual-review (decisão interpretativa de quando) + recurrence
			scope=filename (contexts/<bc>/canvas.cue, threshold 13). tq-def-03
			satisfeito (recurrence é non-manual-review).

			tq-def-04 (custo coerente): medium/cross-artifact coerente — gap
			advisory que acumula por scaffold, tocando canvas+context-map.

			Calibração de trigger documentada: recurrence em vez de adjacent-need
			porque o schema de adjacent-need (file-exists/file-contains) não
			expressa "ao menos N canvases"; threshold 13 = 11 atuais + 2 evita
			falso disparo agora e dispara após 2 scaffolds. Verificado: 11
			canvases em contexts/ atualmente (< 13).

			cue vet ./... EXIT=0. status open (aux fields ausentes per união
			discriminada).
			"""
	}]

	findings: {}

	summary: """
		def-029 (open) defere validation-prompt advisory para derivação de BC; a
		parte dura (acyclicity) já é gate via sc-cm-07. Triggers: manual-review +
		recurrence calibrado (threshold 13 > 11 canvases atuais) para não
		disparar agora. Trade-off articulado; sem fail/warn.
		"""

	singleRoundRationale: """
		DD simples com trade-off claro e triggers calibrados contra o estado real
		do repo (11 canvases). Calibração recurrence-vs-adjacent-need documentada
		no triggerCalibrationRationale. Round único suficiente.
		"""
}
