package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def017DeletionSrrScriptHandling: build_time.#SelfReviewReport & {
	reportId: "srr-def-017-deletion-srr-script-handling"

	artifactPath:       "architecture/deferred-decisions/def-017-deletion-srr-script-handling.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-21"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			def-017 registra observação de que check-self-review.sh trata
			arquivos deletados como modificados e exige SRR para ambos
			os casos. Workaround pragmático aplicado durante reset Phase
			desta sessão: 10 SRRs minimal de deleção criadas seguindo
			template uniforme.

			Per founder direction: "PR #43 é reset corretivo, não o
			momento certo para refatorar o motor de governance.
			Opção A agora + follow-up explícito para depois".

			Esta SRR documenta o deferimento. Decisão de fix futuro
			(Opção B do diálogo: modify check-self-review.sh com
			diff-filter para excluir deleções) registrada como manual-
			review trigger porque condição não é machine-evaluable e
			depende de pressão operacional do momento.

			Schema satisfaction tq-adr-equivalent verificações:
			- description ≥50 runes: PASS
			- deferralRationale ≥100 runes: PASS
			- triggerCalibrationRationale ≥50 runes: PASS
			- originatingArtifacts ≥1: PASS (11 entries: 10 deletion
			  SRRs + 1 session ref)
			- costOfDeferral declarado: PASS (severity=low, blastRadius=
			  local)
			- triggers ≥1: PASS (1 manual-review trigger com reason)
			- status open: PASS

			Originating context: reset Phase commits no PR #43 que
			apaga contexts/fce/, contexts/ntf/, contexts/nim/ + 13
			SRRs correspondentes em governance/build-time/self-reviews/.

			Custo de deferimento avaliado como low/local: 10 SRRs
			ruidosos permanecem em governance/build-time/self-reviews/
			mas não bloqueiam operação. Workaround atual é tractable.

			Per anti-catch-all critério adr-062: este deferimento é
			genuíno deferimento consciente (trade-off articulado:
			caminho mais curto agora vs script hardening depois;
			condição codificada de revisita via manual-review com
			reason explicit). NÃO é WI rotineiro, NÃO é tension
			entry, NÃO é bug travestido.
			"""
	}]

	findings: {}

	summary: """
		def-017 single-round SRR. Deferimento consciente per adr-062:
		check-self-review.sh handling de delete-only diffs adiado
		até próximo episódio de delete ou hardening governance
		independente. Trade-off explícito: 10 SRRs ruidosos agora vs
		ADR + script change durante reset Phase.

		Trigger manual-review com reason articulando POR QUE
		automação não é viável (decisão estratégica, não pattern
		textual matchable).
		"""

	singleRoundRationale: """
		Single-round suficiente: deferred-decision é artefato simples
		de registro de trade-off + trigger. Estrutura é canonical per
		schema #DeferredDecision; rounds adicionais não detectariam
		new findings.

		Cue vet PASS confirmed local pre-commit.
		"""
}
