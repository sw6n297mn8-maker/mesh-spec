package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dsBuyerProcurementJourneyWi161RefsFill: build_time.#SelfReviewReport & {
	reportId: "srr-ds-buyer-procurement-journey-wi-161-refs-fill"

	artifactPath:       "strategic/domain-stories/buyer-procurement-journey.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "domain-story"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único (precedente das fatias de domínio WI-151/152/adr-177,
		modo self-reported): os critérios verificáveis mecanicamente foram
		provados por gate real na própria fatia (cue vet; runner estrutural
		com sc-ds/sc-ag/sc-fct em reject; verbatim-diff programático do am;
		fidelidade command→event extraída por export e reportada verbatim no
		checkpoint per instrução do founder) e as decisões interpretativas
		foram aprovadas explicitamente pelo founder na proposta consolidada
		com 3 calibrações — a dimensão restante é o founder review final da
		fatia, gate humano que rounds adicionais de self-review não
		substituem.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — refs-fill do passo 8 (molde WI-151/WI-152: a story
			testa a cobertura do modelo; as refs entram QUANDO os elementos
			nascem, na mesma fatia): commandRefs (propose-counter-terms /
			revise-quotation / decline-counter-terms), eventRefs (os 3
			fatos internal), readModelRefs/queryRefs (prj/qry-quotation-map
			— a mesa da negociação É o mapa, agora com as rodadas),
			termRefs (os 4 termos novos do glossário). Narrativa (action)
			INTOCADA — fonte real preservada; workItem.description
			intocada; rationale reescrito no padrão dos passos fechados
			(vazio do exame original → FECHADO em 2026-07-28 pelo WI-161,
			com a regra de ouro e o elo adr-177 nomeados). Todas as refs
			resolvem no domain-model do BC do passo (ssc) — verificado
			pelos gates item-scoped sc-ds-04/05/07/08 (reject) no runner
			da fatia, e por leitura direta na autoria. cue vet PASS.
			"""
	}]

	findings: {}

	summary: """
		O vazio mais denso em valor da story fecha no mesmo padrão dos
		anteriores: refs apontam elementos REAIS criados na fatia — a
		story nunca inventou para preencher (regra única do adr-170), e o
		passo 8 esperou a modelagem chegar. Com ele, os 5 passos do ssc
		na jornada (abertura, cotação, mapa, negociação, decisão) têm lar
		de escrita/leitura completo.
		"""
}
