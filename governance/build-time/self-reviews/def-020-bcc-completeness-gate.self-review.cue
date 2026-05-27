package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def020BccCompletenessGate: build_time.#SelfReviewReport & {
	reportId: "srr-def-020-bcc-completeness-gate"

	artifactPath:       "architecture/deferred-decisions/def-020-bcc-completeness-gate.cue"
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
			def-020 defere o gate de completude bcc↔wave-plan/disco. Formulação aprovada
			pelo founder.

			Conformancia #DeferredDecision:
			- description: PASS (gate reconciliando bcc required-artifacts com disco/wave-plan).
			- deferralRationale: PASS — MOTIVO: completude total é roadmap, não invariável
			  atual; RISCO: gate cru vira all-red e perde sinal (verificado: BCs têm só
			  canvas/domain-model/glossary/agents vs ~7 exigidos). Fora de escopo: NÃO
			  relaxa os checks já existentes de canvas/domain-model/glossary/agents quando
			  requeridos (eles seguem; o gate de órfão impede .cue ungoverned).
			- triggerCalibrationRationale: PASS (manual-review porque o gatilho é decisão
			  de FASE — BC completo obrigatório OU wave-plan materializar sistematicamente
			  — não machine-evaluable).
			- originatingArtifacts: PASS (bcc + adr-090).
			- costOfDeferral: severity low + blastRadius cross-cutting, não-cumulativo.
			- triggers: 1 manual-review com reason. status open.

			Anti-catch-all (adr-062): deferimento genuíno — trade-off articulado (custo
			evitado = gate all-red ruidoso; custo de deferir = baixo, mitigado por checks
			existentes + órfão) e condição de revisita (decisão de fase / wave-plan).
			Não é WI rotineiro (não é trabalho pendente sem trade-off) nem bug.

			Verificacao: cue vet ./... EXIT 0.
			"""
	}]

	findings: {}

	summary: """
		def-020: deferimento consciente do gate de completude bcc↔wave-plan/disco —
		prematuro enquanto a completude total de BC é roadmap (gate cru = all-red).
		Trigger manual-review (decisão de fase / materialização via wave-plan). Não
		relaxa checks existentes. Conforma #DeferredDecision; sem findings.
		"""

	singleRoundRationale: """
		Uma rodada basta: deferred-decision de registro de trade-off + trigger, cuja
		premissa (BCs roadmap-incompletos: só canvas/domain-model/glossary/agents) foi
		verificada empiricamente e cuja estrutura conforma #DeferredDecision (cue vet
		0). Sem espaco de decisao aberto a red-team.
		"""
}
