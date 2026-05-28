package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def025MoneyConsolidationPending2ndConsumer: build_time.#SelfReviewReport & {
	reportId: "srr-def-025-money-consolidation-pending-2nd-consumer"

	artifactPath:       "architecture/deferred-decisions/def-025-money-consolidation-pending-2nd-consumer.cue"
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
			Self-review do def-025 (Money consolidation pending 2nd consumer real).
			Recorte do def-022 quando a consolidação cross-BC executou apenas #Envelope
			(DLV não usa Money). Proposta passou por 3 ciclos de red team junto com a
			resolução do def-022 antes da aprovação; texto e triggers aprovados pelo
			founder no chat.

			(a) Conformância #DeferredDecision: id ^def-[0-9]{3}$; status 'open'
			(triggeredAt/triggeredCondition/resolvedBy ausentes — discriminado por
			união); description >=50 runes afirmativa sobre o que se está deferindo
			(consolidar Money inline em shared-schemas quando 2º BC do slice usar);
			deferralRationale com trade-off concreto: MOTIVO (princípio do def-022
			aplicado a Money — 1 consumidor não justifica abstração), RISCO de gatear
			agora (shape não servir INV/BDG/BKR — decisões de precisão decimal, minor
			units, quantity+unit-of-measure), CUSTO de deferir (~5 linhas em 1 BC,
			reversível mecanicamente, não-cumulativo enquanto for 1 BC) — tq-def-01
			satisfeito.

			(b) Triggers: 2 triggers conformam #Trigger discriminated union — primário
			adjacent-need com file-exists em contexts/inv/schemas/events.cue (INV é
			candidato mais provável per canvas de inventário/valoração); secundário
			manual-review com reason MinRunes(40)+ articulando incerteza específica
			sobre qual será o 2º consumidor (BDG/BKR podem materializar antes de INV).
			tq-def-02 satisfeito (ambos machine-evaluable: file-exists é determinístico,
			manual-review é skip explícito). tq-def-03 SATISFEITO (não warn): existe
			trigger non-manual-review (file-exists em INV) — manual-review é hedge
			complementar, não primário.

			(c) costOfDeferral coerente: severity=low + blastRadius=local + description
			articulando duplicação contida (~5 linhas em 1 BC) e reversibilidade
			mecânica (mesmo pattern do def-022 resolution) — tq-def-04 satisfeito,
			combinação low+local consistente com escopo descrito.

			(d) Decisão revisada por 3 ciclos de red team durante a consolidação def-022:
			Ciclo 1 pegou que trigger único file-exists em INV é específico demais
			(Money pode emergir em BDG/BKR). Ciclos 2-3 adicionaram manual-review como
			hedge complementar e ajustaram reason MinRunes(40)+ pra articular a
			incerteza concreta (não preguiça). originatingArtifacts aponta para
			def-022 (Money foi recortado dele).

			(e) Verificação: cue vet ./architecture/deferred-decisions/... EXIT 0;
			structural-check-runner 0 bloqueantes; nenhum warn — todos os 4 tq-def-*
			critérios satisfeitos.
			"""
	}]

	summary: "def-025 conforma #DeferredDecision (tq-def-01/02/03/04 todos satisfeitos — não há warns; trigger primário adjacent-need em INV + secundário manual-review como hedge contra incerteza sobre 2º consumidor real). Recorte do def-022 quando consolidação cross-BC executou apenas #Envelope. 3 ciclos de red team durante a consolidação. Verificado: cue vet exit 0; structural-check-runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round após 3 ciclos de red team pré-aprovação durante a consolidação do def-022: triggers refinados especificamente nesses ciclos (single trigger INV → dual trigger INV+manual-review hedge); conformância de schema verificada por cue vet + runner sem findings fail nem warn. Recorte limpo do def-022 com originatingArtifacts apontando de volta."
}
