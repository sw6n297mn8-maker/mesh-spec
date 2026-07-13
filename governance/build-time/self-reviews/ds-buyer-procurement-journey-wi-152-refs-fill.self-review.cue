package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dsBuyerProcurementJourneyWi152RefsFill: build_time.#SelfReviewReport & {
	reportId: "srr-ds-buyer-procurement-journey-wi-152-refs-fill"

	artifactPath:       "strategic/domain-stories/buyer-procurement-journey.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "domain-story"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — preenchimento de refs dos passos 6-7 da story (WI-152):
			passo 6 ganhou eventRefs [evt-quotation-submitted] (o finding do
			exame original pediu exatamente este fato); passo 7 ganhou
			readModelRefs [prj-quotation-map] + queryRefs [qry-quotation-map]
			+ term-mapa-de-cotacoes somado aos termRefs (o termo que nasce
			nomeia o instrumento que a action do passo cita literalmente).
			Rationales dos passos 6 e 7 DATADOS per convenção estabelecida
			(story é teste de cobertura VIVO): lacuna identificada no exame
			original (2026-07-12) e FECHADA em 2026-07-13 pelo WI-152, com os
			elementos que a fecharam nomeados — a história do exame
			preservada. [ANTI-RETROFIT]: os codes preenchidos vêm dos
			elementos reais criados no ssc nesta mesma fatia; direção jornada
			→ decisão B → materialização → refs. [ESCOPO]: SÓ os passos 6-7 —
			nenhum outro rationale tocado; vazios de refs de elemento: 3 → 2
			(restam passo 1 — canteiro — e passo 8 — negociação, o vazio mais
			denso declarado). Verificação determinística final: sc-ds-01..08
			em REJECT no runner (motor per-item adr-169). cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		Passos 6-7 da ds-buyer-procurement-journey preenchidos com os codes
		reais do WI-152 e datados como teste vivo; vazios 3 → 2 (restam
		canteiro e negociação). VEREDITO: stable, 0 fail — gates sc-ds em
		REJECT confirmam no runner.
		"""

	singleRoundRationale: """
		Round único proporcional: materialização da fatia WI-152 executando a
		decisão B do founder pré-cravada no Tempo 2 (o Tempo 1 read-only
		serviu de section-gate do desenho, com o terreno verificado contra o
		disco); a verificação determinística corre nos gates da validação
		integral do checkpoint (sc-ds em REJECT, tq-dm, runner).
		"""
}
