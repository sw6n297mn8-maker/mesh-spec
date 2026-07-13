package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscDomainModelWi152QuotationMap: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-domain-model-wi-152-quotation-map"

	artifactPath:       "contexts/ssc/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

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
			Round 1 — self-review do MAPA DE COTAÇÕES CONSULTÁVEL (WI-152,
			decisão B do founder): +2 events INTERNAL (evt-quotation-submitted
			com fields espelhando ent-quotation/cmd-submit-quotation — nenhum
			dado novo; evt-quotation-withdrawn com rfqId+supplierRef+
			withdrawnAt — 1 fornecedor → 1 cotação por RFQ em Phase 0
			identifica sem quotationId), +prj-quotation-map (consome os 2
			internal + 3 de RFQ + evt-sourcing-decision-made) +
			qry-quotation-map (por rfqId, filtro categoryRef, ordenado por
			TCO equalizado, vencedor destacado pós-decisão); rationales de
			cmd-submit/withdraw-quotation re-papelizados (o fato agora é
			observável INTRA-BC); wiring emitsEvents +2; rationale raiz
			coevoluído (lens eda 6+2+1 events / 4 projections; bloco WI-152;
			glossary alignment 20 terms + mapping novo — lição do WI-151:
			zero prosa stale de contagem).

			[DECISÃO B REGISTRADA — o porquê da confidencialidade]: os 2
			events são INTERNAL, NUNCA published — o veto do write original
			('NÃO event público Phase 0') é contra evento PÚBLICO (um
			fornecedor não pode ver a cotação do outro); o fato existir
			internamente não viola o veto, e é o que torna o mapa vivo
			projetável (tq-dm-06: projections consomem events — sem o fato,
			o mapa pré-decisão não tinha o que consumir). Canvas outbound
			INTOCADO; ZERO aresta nova no context-map (guard sc-cm-07 — lição
			do WI-153: events internal não geram dependência cross-BC).

			[EQUALIZAÇÃO DERIVADA — precedente citado]: a projection NÃO
			recalcula de forma nova nem redefine componentes de TCO — deriva
			deterministicamente do mesmo material do svc-fitness-rule-
			evaluator (fitness rules da categoria; lógica em
			FitnessRuleContent, configuração versionada, shape oq-ssc-8),
			seguindo o precedente literal do prj-cost-center-availability
			('encapsula derivação numérica para evitar drift de cálculo
			entre consumers'). Distinção indicativa (rules vigentes,
			pré-decisão) vs auditável (snapshot da decisão) explícita.

			[ANTI-RETROFIT]: o mapa vem do passo 7 da story ('consolida o
			mapa de cotações... e compara' — action literal) e o evento vem
			do passo 6 (o finding do exame original registrou a lacuna do
			evento) — ambos PEDIDOS pela narrativa, nada sintetizado.
			[def-079 INTOCADO]: a qry declara ser o pré-requisito do exit
			(a superfície que o elo referenciará), não o exit — o elo
			requisição↔cotação não existe no ssc e segue governado pelo
			def-079. [uq-08]: cue vet EXIT=0; tq-dm-02 (events novos em
			emitsEvents), tq-dm-06 (projection consome só catálogo — os 2
			novos estão no catálogo), tq-dm-13 (prefixos/unicidade) fechados
			por inspeção. [uq-07]: zero placeholder.
			"""
	}]

	findings: {}

	summary: """
		Mapa de cotações consultável no ssc (WI-152, decisão B): o fato
		interno da cotação nasce (internal, nunca published — confidencialidade
		preservada, zero aresta cross-BC), o mapa vive durante a janela com
		equalização DERIVADA (precedente prj-cost-center-availability) e ganha
		o carimbo da decisão. O comprador deixa de estar cego na comparação
		que o sistema calcula. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: materialização da fatia WI-152 executando a
		decisão B do founder pré-cravada no Tempo 2 (o Tempo 1 read-only
		serviu de section-gate do desenho, com o terreno verificado contra o
		disco); a verificação determinística corre nos gates da validação
		integral do checkpoint (sc-ds em REJECT, tq-dm, runner).
		"""
}
