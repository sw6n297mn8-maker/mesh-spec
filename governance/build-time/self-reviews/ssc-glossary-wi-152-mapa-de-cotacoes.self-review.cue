package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscGlossaryWi152MapaDeCotacoes: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-glossary-wi-152-mapa-de-cotacoes"

	artifactPath:       "contexts/ssc/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

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
			Round 1 — coevolução UL do ssc (WI-152): 20º term
			term-mapa-de-cotacoes (category value — comparação consolidada
			consultável; viva na janela, carimbada pela decisão) posicionado
			junto ao term-equalizacao-tco (o padrão analítico do qual o mapa
			é a superfície); antiTerms fecham as duas confusões prováveis
			(Decisão de Sourcing — o mapa suporta a escolha, a decisão a
			consuma; Equalização TCO — o mapa apresenta, não redefine);
			relatedTerms do term-equalizacao-tco ganhou o ponteiro reverso;
			rationale raiz do glossário coevoluído com o instrumento. O nome
			vem das FONTES da story ('consolida o mapa de cotações' — a
			jornada o chama pelo nome). cue vet EXIT=0; contagem real: 20
			code term- no arquivo.
			"""
	}]

	findings: {}

	summary: """
		term-mapa-de-cotacoes canoniza o instrumento central do comprador na
		UL do ssc, em par com o domain-model (prj/qry) no mesmo movimento.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: materialização da fatia WI-152 executando a
		decisão B do founder pré-cravada no Tempo 2 (o Tempo 1 read-only
		serviu de section-gate do desenho, com o terreno verificado contra o
		disco); a verificação determinística corre nos gates da validação
		integral do checkpoint (sc-ds em REJECT, tq-dm, runner).
		"""
}
