package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr132: build_time.#SelfReviewReport & {
	reportId: "srr-adr-132"

	artifactPath:       "architecture/adrs/adr-132-add-falsification-condition-to-adr-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-132 adiciona o campo falsificationCondition ao #ADR (PR-#1 da
			sequência de feedback-cycles; materializa a Camada 2 identificada na
			auditoria de ciclos). tq-adr-01 PASSED: alternativas substantivas e
			rejeitadas — Caminho C (novo structural-check kind agora; rejeitado:
			aninha evolução do motor de checks, anti-pattern do arco
			cycle-resolution onde cada kind foi PR próprio adr-102/105/107),
			Caminho B (união CUE por decisionClass; rejeitado: perde phasing
			warn→reject + força backfill dos 6 structural), shape string 2a
			(rejeitado: campo é o 1º verificável do #ADR, observableSignal como
			subcampo força disciplina que prosa livre não garante), backfill
			total (rejeitado: def-032 nomeia 127/129/131 como os que mais se
			beneficiam). tq-adr-02 PASSED: decisionClass=structural,
			reversibility=medium, blastRadius=repo-wide — coerentes (campo do
			schema base afeta todo ADR futuro; reverter = remover campo optional
			+ 3 backfills, esforço moderado). tq-adr-03/04 PASSED:
			affectedArtifacts = adr.cue + adr-127/129/131 (todos existem,
			alterados neste PR); ≥1 bloco populado (sc-adr-01). principlesApplied
			[P12,P10,P0] verificados em design-principles.cue. uq-02 PASSED:
			ancorado em mecanismos Mesh (teste de remoção P13 como fonte das
			conditions; sc-cm-07 acyclicity como observableSignal; def-032 como
			tracker do gate) — não substituível por 'qualquer fintech'.
			Dogfooding: ADR-132 carrega sua própria falsificationCondition.
			def-032 permanece OPEN (a leitura do deferralRationale amarra a
			resolução ao gate, que este ADR não entrega); nenhum def-035 criado;
			defersTo omitido (def-032 pré-existe — defersTo é para deferimentos
			que o ADR cria; relação documentada em prosa). cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		ADR-132 adiciona falsificationCondition (struct opcional) ao #ADR e faz
		backfill nos 3 ADRs de derivação de BC (127/129/131) com condição
		derivada do teste de remoção P13. Gate condicional deferido em def-032
		(permanece open; sem def-035). Dogfooding: o próprio ADR usa o campo.
		decisionClass structural, blastRadius repo-wide. cue vet EXIT=0.
		"""

	singleRoundRationale: """
		Decisão de design (shape/mecanismo/escopo/transição de def-032) tomada
		pelo founder na auditoria de ciclos; este ADR cristaliza o resultado.
		Alternativas (Caminho C/B, string, backfill-total) explicitadas e
		rejeitadas com motivo. Escopo de classe única (campo + backfill, sem
		enforcement novo) reduz a superfície de decisão e de regressão; a
		leitura de def-032 (open vs resolved) foi reportada ao founder antes da
		materialização. Round único suficiente.
		"""
}
