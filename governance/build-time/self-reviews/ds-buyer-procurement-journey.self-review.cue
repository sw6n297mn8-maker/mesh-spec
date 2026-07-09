package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dsBuyerProcurementJourney: build_time.#SelfReviewReport & {
	reportId: "srr-ds-buyer-procurement-journey"

	artifactPath:       "strategic/domain-stories/buyer-procurement-journey.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "domain-story"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-08"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da 1ª instância de #DomainStory
			(ds-buyer-procurement-journey, jornada de compras do comprador da
			construtora, 10 passos, recorte necessidade→pedido).

			[uq-08 CONFORMÂNCIA #DomainStory]: OK. cue vet EXIT=0; code ds-* sem
			hífen final; steps não-vazio; cada passo com actorRef sh-NN + action +
			workItem{description, boundedContextRef} + rationale; refs opcionais
			satisfazendo os regexes por prefixo.

			[tq-dsg-01 REFS VERIFICADAS — fail-class do PG]: OK. Toda ref
			preenchida foi verificada por leitura direta ANTES da proposta, contra
			inventário extraído deterministicamente (script sobre os
			domain-models): actorRefs sh-01/sh-02 ∈ stakeholders[].code;
			boundedContextRefs p2p/npm/ssc ∈ canvas.code; subdomainRef p2p ∈
			strategic/subdomains; cmd/evt/prj/qry de cada passo ∈ coleção correta
			do domain-model DO BC DO PASSO; NENHUMA ref sustentada por cópia
			consumida (flags [CONSUMED] checados). Prova determinística no ato da
			escrita: runner full com a story no disco = 31/0, zero violações
			sc-ds (os 8 gates avaliaram a instância real).

			[tq-dsg-02 LACUNA HONESTA — fail-class]: OK. 5 passos vazios (1,2,3 —
			requisição inexistente em QUALQUER BC, grep 'requisi' zero; 7 — mapa
			de cotações sem read-side; 8 — negociação sem elementos) + 2 parciais
			com faltante nomeado (6 — cmd sem evento; 9 — decisão sem alçada).
			NADA foi inventado para preencher; o relatório de lacunas (10 vazios +
			3 divergências de ordem) acompanhou a proposta como entregável, per
			PG. Auto-suspeita de retrofit executada: cobertura ~50%, concentrada
			na metade final — coerente com modelo incompleto.

			[tq-dsg-03 FONTE REAL / ANTI-RETROFIT — fail-class]: OK. Fonte
			declarada no purpose (entrevistas com compradores + vídeos de
			referência, founder, 2026-07); passos extraídos DAS transcrições na
			ordem da dor ANTES do mapeamento ao modelo; a divergência de ordem
			entre as próprias fontes (posição da aprovação) foi declarada e a
			ordem VIVIDA adotada; a story revela que o modelo começa no passo 5 —
			evidência estrutural de que não foi sintetizada do modelo.

			[tq-dsg-04 ESCOPO POR-ITEM]: OK. Refs limpas (sem chave composta);
			cada ref resolve no BC do scopeField do próprio passo; cenário
			cópia-consumida explicitamente evitado (evt-purchase-order-emitted
			referenciado no passo 10 onde p2p é DONO; a cópia consumida vive no
			cmt e não foi usada).

			[uq-01/02/05/06/07]: OK — rationales de porquê por passo; ancorado em
			codes reais da Mesh e na cunha de compras; limitações declaradas
			(termRefs frouxos per def-075; atores intra-org todos sh-01 —
			granularidade registrada como achado, ponte def-076); UL consistente
			(read model = projection); zero placeholder. [uq-03]: OK — todas as
			refs verificadas (acima). [uq-04]: OK — instância aplica adr-170 (a
			regra única) e P0 (refs como ponteiros).

			[uq-09 SECTION GATES]: PG domain-story aplicado nas 3 sections em
			arco: narrative-and-scope (derivação das transcrições apresentada com
			espinha explícita pré-mapeamento), steps-and-model-resolution
			(mapeamento com refs verificadas + inventários), gaps-validation-and-
			submission (relatório de lacunas + mapa visual + Q&A de 4 rodadas com
			o founder — identidade/login, cobertura cmd/evt, sequenciamento,
			cadastro) → aprovação explícita do founder ('Sim') antes desta
			materialização. Cláusula batch do serializationRule (arco de
			checkpoint único, pattern def-074).
			"""
	}]

	findings: {}

	summary: """
		1ª instância de #DomainStory: ds-buyer-procurement-journey (10 passos,
		fonte real, ordem da dor). VEREDITO: stable, 0 fail, 0 warn. Refs
		verificadas deterministicamente contra os domain-models dos BCs de cada
		passo (runner 31/0 com a story no disco, zero violações sc-ds); lacunas
		honestas registradas em relatório entregue ao founder (5 vazios + 2
		parciais + 3 divergências de ordem); anti-retrofit satisfeito por
		construção (derivação das transcrições precedeu o mapeamento).
		"""

	singleRoundRationale: """
		Round único proporcional: a instância passou por ciclo de review MAIOR
		que um round interno — proposta integral em chat com relatório de
		lacunas, mapa visual de cobertura, 4 rodadas de Q&A com o founder e
		aprovação explícita; as refs têm prova determinística (runner) além da
		verificação manual. Um segundo round interno não adicionaria dimensão
		não coberta.
		"""
}
