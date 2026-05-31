package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def035: artifact_schemas.#DeferredDecision & {
	id:     "def-035"
	title:  "Residual do Ciclo 4 (agent-probe): promover cobertura warn→reject, automação do dispatch, wiring no painel, PGs dos 2 tipos"
	date:   "2026-05-31"
	status: "open"

	description: """
		adr-134 instituiu o agent-probe com cobertura A born-warn (sc-apr-02, 13 warns).
		Ficam deferidos, conscientemente, quatro itens: (1) promover sc-apr-02 de warn
		para reject quando os 14 canvases forem probados (catraca adr-097 — fechar o
		gate quando verde); (2) automação do dispatch do probe (hoje é human-in-loop
		manual; o teste de egress confirmou que o CI alcança a API Anthropic mas falta o
		secret ANTHROPIC_API_KEY); (3) wiring dos probe-records como métrica do painel
		def-034 (4ª métrica de saúde: ratio spec-finding/probe-noise + cobertura); (4)
		production-guides para agent-probe-protocol e agent-probe-record (adr-053
		universal coverage — hoje os 2 tipos não têm PG, consistente com os ~23 tipos
		já sem PG).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: (1) a promoção warn→reject só faz sentido quando a
		cobertura estiver verde (14/14 probados) — promover com 13 warns seria born-red,
		o anti-pattern que adr-134 rejeitou; (2) a automação do dispatch depende de
		infra externa (secret de API no CI) que é decisão de ops do founder, não de
		modelagem; (3) o painel (def-034) ele próprio está deferido (depende de
		def-031+032); o wiring do probe é uma 4ª métrica que só faz sentido quando o
		painel existir; (4) PGs especulativos antes de exercitar os tipos em volume
		arriscam guides mal-calibrados (mesma lógica de def-029). Custo evitado:
		gate born-red + automação prematura + PG especulativo. Custo de continuar: a
		cobertura fica em warn permanente (risco zombie, observado pela
		falsificationCondition do adr-134) até os 14 serem probados manualmente.
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
		pattern:   "architecture/agent-probes/records/[a-z0-9-]+\\.cue$"
		scope:     "filename"
		threshold: 2
	}]
}
