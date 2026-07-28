package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscGlossaryWi161NegotiationTerms: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-glossary-wi-161-negotiation-terms"

	artifactPath:       "contexts/ssc/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

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
			Round 1 — +4 termos da negociação (WI-161), 20→24:
			term-contraproposta (value; fixa na UL a assimetria
			comprador-pede/fornecedor-declara, com antiTerm Revisão de
			Cotação), term-rodada-de-negociacao (process; antiTerm BAFO —
			a distinção explícita do que oq-ssc-9 mantém aberto),
			term-condicoes-de-pagamento (value; o eixo do fluxo de caixa,
			com antiTerm Prazo de Entrega separando financeiro de
			logístico), term-entregas-programadas (value). layerMapping
			para os 3 com espelho de código (CounterTerms/PaymentTerms/
			DeliverySchedule); categorias dentro do enum #TermCategory
			(value/process). Definições em UL pura (sem protocolo/runtime
			— lição dos 9 ajustes do founder no disp-008); rationales
			ancorados na narrativa real do passo 8. Header e rationale
			raiz coevoluídos (24 terms; bloco da negociação). Terms
			referenciados pelo domain-model (glossary alignment) e pela
			story (termRefs do passo 8) existem — consistência
			cross-artifact na mesma fatia. cue vet PASS.
			"""
	}]

	findings: {}

	summary: """
		Extensão manual do glossário na fatia de domínio (precedente
		WI-152 term-mapa-de-cotacoes; dispatch é para criação de
		instância). Os 4 termos nascem da narrativa real (tq-dsg-03:
		entrevistas + vídeos 2026-07) — vocabulário que comprador e
		fornecedor usam na mesa, não invenção de modelo.
		"""
}
