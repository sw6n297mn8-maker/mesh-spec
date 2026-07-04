package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def035: artifact_schemas.#DeferredDecision & {
	id:          "def-035"
	title:       "Residual do Ciclo 4 (agent-probe): promover cobertura warn→reject, automação do dispatch, wiring no painel, PGs dos 2 tipos"
	date:        "2026-05-31"
	status:      "triggered"
	triggeredAt: "2026-07-04"
	triggeredCondition: """
		Backstop recurrence disparou como desenhado ('mecanismo vivo,
		revisite'): 5 probe-records (bdg, cmt, drc, fce, scf) >= threshold
		2. Re-triagem de mérito 2026-07-04 (pós-reforma do runner,
		adr-166/adr-167), decisão do founder sobre a evidência — MANTIDO
		DEFERIDO com o estado atualizado dos 4 residuais:

		(1) Catraca sc-apr-02 warn→reject: aguarda 14/14 — cobertura hoje
		5/14 (faltam bkr, ctr, dlv, idc, inv, npm, p2p, rew, ssc);
		promover agora seria born-red em 9 canvases (anti-pattern
		adr-097).

		(2) Automação do dispatch: segue decisão de ops do founder
		(secret ANTHROPIC_API_KEY no CI); nada mudou.

		(3) Wiring no painel: RESOLVIDO POR FORA — adr-136 resolveu
		def-034 e scripts/ci/modeling-health.sh materializa a Métrica 4
		('Cobertura probe (sc-apr-02 / canvas->probe-record): X/14', com
		lista dos faltantes). O texto original deste def (que citava o
		painel como deferido) foi corrigido nesta transição.

		(4) PG do agent-probe-record: fundamento mudou de especulativo
		para recorrência real (5 records autorados sem PG). NÃO abrir a
		fatia agora — candidata registrada com gatilho: 6º record
		divergindo do padrão dos existentes, OU decisão do founder. O
		agent-probe-protocol permanece exempt de PG (meta-coverage:
		singleton self-contained).
		"""

	description: """
		adr-134 instituiu o agent-probe com cobertura A born-warn (sc-apr-02, 13 warns).
		Ficam deferidos, conscientemente, quatro itens: (1) promover sc-apr-02 de warn
		para reject quando os 14 canvases forem probados (catraca adr-097 — fechar o
		gate quando verde); (2) automação do dispatch do probe (hoje é human-in-loop
		manual; o teste de egress confirmou que o CI alcança a API Anthropic mas falta o
		secret ANTHROPIC_API_KEY); (3) wiring dos probe-records como métrica do painel
		def-034 [CORRIGIDO 2026-07-04: resolvido por fora — adr-136 resolveu def-034 e
		a Métrica 4 do scripts/ci/modeling-health.sh JÁ é a cobertura probe; ver
		triggeredCondition]; (4) production-guides para agent-probe-protocol e
		agent-probe-record [ATUALIZADO 2026-07-04: o protocol é exempt per
		meta-coverage; o PG do record deixou de ser especulativo com 5 records —
		candidata com gatilho registrado no triggeredCondition].
		"""

	deferralRationale: """
		MOTIVO de deferir agora: (1) a promoção warn→reject só faz sentido quando a
		cobertura estiver verde (14/14 probados) — promover com 13 warns seria born-red,
		o anti-pattern que adr-134 rejeitou; (2) a automação do dispatch depende de
		infra externa (secret de API no CI) que é decisão de ops do founder, não de
		modelagem; (3) o painel (def-034) ele próprio está deferido (depende de
		def-031+032) [CORRIGIDO 2026-07-04: o painel materializou via adr-136 e o
		wiring já existe — item quitado por fora, ver triggeredCondition]; (4) PGs
		especulativos antes de exercitar os tipos em volume arriscam guides
		mal-calibrados (mesma lógica de def-029) [ATUALIZADO 2026-07-04: com 5
		records o PG do record não é mais especulativo — candidata com gatilho
		próprio]. Custo evitado: gate born-red + automação prematura + PG
		especulativo. Custo de continuar: a cobertura fica em warn permanente
		(risco zombie, observado pela falsificationCondition do adr-134) até os 14
		serem probados manualmente.
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review: a decisão de promover a catraca e de automatizar
		o dispatch é founder-only (envolve ops/secret e julgamento sobre maturidade do
		mecanismo) — não machine-evaluable. Backstop recurrence (records, threshold 2):
		quando existir um 2º probe-record além do fce, o mecanismo está sendo usado de
		fato — sinal concreto de que vale revisitar promoção/automação/painel. Threshold
		2 (não 14) porque o objetivo do backstop é pegar 'o mecanismo está vivo, revisite
		o residual', não esperar a cobertura completa.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-134-agent-probe-protocol.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			Sem a promoção, a cobertura do agent-probe fica em warn permanente — canvas
			não-probado é visível mas não bloqueia (risco zombie). Sem automação, o probe
			depende de execução manual por sessão. medium porque o mecanismo já existe e
			funciona (sc-apr-01 verde, cobertura visível); cross-cutting porque o
			agent-probe cobre todos os canvases do repo.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Promover sc-apr-02 warn→reject (catraca), automatizar o dispatch (depende de
			secret de API — decisão de ops) e wirar no painel (def-034) são decisões
			founder-only não machine-evaluable. O founder revisita quando a cobertura
			amadurecer.
			"""
	}, {
		kind:      "recurrence"
		// Âncora '^' anexada no tightening do adr-166 (contagem idêntica).
		pattern:   "^architecture/agent-probes/records/[a-z0-9-]+\\.cue$"
		scope:     "filename"
		threshold: 2
	}]
}
