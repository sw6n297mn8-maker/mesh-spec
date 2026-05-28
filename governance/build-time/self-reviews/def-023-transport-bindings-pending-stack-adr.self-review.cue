package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def023TransportBindingsPendingStackAdr: build_time.#SelfReviewReport & {
	reportId: "srr-def-023-transport-bindings-pending-stack-adr"

	artifactPath:       "architecture/deferred-decisions/def-023-transport-bindings-pending-stack-adr.cue"
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
		warnCount: 1
		infoCount: 0
		summary: """
			Self-review do def-023 (transport bindings deferidos até ADR de stack).
			Proposta passou por 3 ciclos de red team antes da aprovação; texto e
			trigger aprovados pelo founder no chat com 2 ajustes finais aplicados ao
			async-api.yaml (não a este def). 1 warn ESPERADO e documentado.

			(a) Conformância #DeferredDecision: id ^def-[0-9]{3}$; status 'open'
			(triggeredAt/triggeredCondition/resolvedBy ausentes — discriminado por
			união); description >=50 runes afirmativa sobre o que se está deferindo
			(bindings + servers nos async-api.yaml dos 3 BCs do slice); deferralRationale
			com trade-off concreto: MOTIVO (sem ADR de stack/transport), RISCO de gatear
			agora (refactor cross-BC), CUSTO de deferir (sem nível-de-protocolo no
			arquivo) — tq-def-01 satisfeito.

			(b) Trigger e tq-def-03 WARN ESPERADO: única trigger é manual-review com
			reason articulando que NENHUMA das 6 kinds (recurrence, adjacent-need,
			volume-threshold, temporal, file-content-occurrence-count, manual-review)
			expressa cleanly 'qualquer ADR futuro menciona decisão de transport' —
			limitação técnica do schema #Trigger, não preguiça. tq-def-03 advisory warn
			(preferência por trigger não-manual) é ACEITO DELIBERADAMENTE e documentado
			tanto no triggerCalibrationRationale quanto neste SRR. Sem warn de
			tq-def-02: a kind manual-review é machine-evaluable (skip explícito).

			(c) Decisão revisada por 3 ciclos de red team:
			Ciclo 1 pegou trigger especulativo (path adr-117 que pode nunca existir),
			x-mesh-cue-ref com ## não-padrão, JSON Schema mirror frouxo (só format).
			Ciclos 2-3 refinaram (warn aceito explícito, descrições com path completo,
			info.version 0.1.0 honesto, dataschema/source como const). Esses ajustes
			aterrissaram no async-api.yaml/def-023 finais.

			(d) Verificação: cue vet ./architecture/deferred-decisions/... EXIT 0;
			structural-check-runner 0 bloqueantes; tq-def-03 warn confirmado e
			documentado como aceito.
			"""
	}]

	summary: "def-023 conforma #DeferredDecision (tq-def-01/02/04 fail satisfeitos; tq-def-03 warn ACEITO E DOCUMENTADO por limitação técnica do #Trigger schema — nenhuma das 6 kinds expressa cleanly 'qualquer ADR futuro menciona transport'). 3 ciclos de red team antes da aprovação. Verificado: cue vet exit 0; structural-check-runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round após 3 ciclos de red team pré-aprovação: motivo e trigger foram refinados especificamente nesses ciclos (trigger especulativo → manual-review com reason técnica); conformância de schema verificada por cue vet + runner sem findings fail. O único warn (tq-def-03) é aceito deliberadamente e documentado no rationale do próprio trigger."
}
