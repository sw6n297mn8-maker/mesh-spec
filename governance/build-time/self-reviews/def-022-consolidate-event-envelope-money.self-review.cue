package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def022ConsolidateEventEnvelopeMoney: build_time.#SelfReviewReport & {
	reportId: "srr-def-022-consolidate-event-envelope-money"

	artifactPath:       "architecture/deferred-decisions/def-022-consolidate-event-envelope-money.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-28"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-022 (consolidar envelope+Money em shared-schemas quando
			2º BC do slice precisar). Texto aprovado pelo founder no chat antes da escrita
			(opção C: inline + def-XXX) com 3 refinamentos incorporados.

			(a) Conformância #DeferredDecision: id ^def-[0-9]{3}$; status "open" (sem
			triggeredAt/triggeredCondition/resolvedBy — discriminado por união); description
			descreve afirmativamente o que se está deferindo (consolidação em shared-schemas).
			deferralRationale articula trade-off concreto (tq-def-01): MOTIVO de adiar (evitar
			abstração prematura, validar shape por 2 usos), RISCO de gatear agora (shape
			generalizado pode não servir DLV), CUSTO de deferir (1 duplicação local,
			reversível mecanicamente).

			(b) Trigger machine-evaluable (tq-def-02): adjacent-need com condition file-exists
			path="contexts/dlv/schemas/events.cue" — runner deterministico avalia, sem
			depender de revisão humana. Non-manual-review (tq-def-03 satisfeito).

			(c) costOfDeferral coerente (tq-def-04): severity=low + blastRadius=local
			refletem que enquanto for 1 BC só, a dívida é contida; cumulatividade começa
			quando DLV materializar (que é exatamente o trigger).

			(d) originatingArtifacts referencia governance/build-time/task-specs/wi-129.cue
			(existe na main pós-#68).

			(e) Verificação: cue vet ./architecture/deferred-decisions/... exit 0;
			structural-check-runner 0 bloqueantes.
			"""
	}]

	summary: "def-022 conforma #DeferredDecision (tq-def-01..04): trade-off articulado (evitar abstração prematura vs duplicação local contida), trigger machine-evaluable (adjacent-need + file-exists), costOfDeferral coerente (low+local). Verificado: cue vet exit 0; structural-check-runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: opção C foi escolhida explicitamente pelo founder no chat com direção clara (envelope inline, Money inline, opaques cross-BC, trigger em contexts/dlv/schemas/events.cue); conformância de schema verificada empiricamente sem findings."
}
