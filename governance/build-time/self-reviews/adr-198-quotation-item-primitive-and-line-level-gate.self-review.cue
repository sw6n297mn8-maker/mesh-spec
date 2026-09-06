package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr198QuotationItemPrimitiveAndLineLevelGate: build_time.#SelfReviewReport & {
	reportId: "srr-adr-198-quotation-item-primitive-and-line-level-gate"

	artifactPath:       "architecture/adrs/adr-198-quotation-item-primitive-and-line-level-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-06"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Dois fails corrigidos na autoria: (a) a leitura do disparo da
			falsificação (a) do adr-177 — a condição materializou por direção
			não antecipada (split por linha no one-shot, não o domínio
			preferred/strategic que ela vigiava); registrada com essa
			honestidade no context, sem retrofit (falsificação que só acerta
			reescrita não prova nada). (b) A primeira forma do gate mantinha
			quantity singular ao lado das lines — redundância incoerente;
			migrado integralmente para as linhas com Σ lineAmount == amount
			como total (tq-adr-02: a decisão real é por linha).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Ajuste do founder na aprovação incorporado: N2
			reescrito apontando def-093 nominalmente (defersTo) com o motivo
			de urgência (unidades divergentes quebram a comparação por linha
			EM SILÊNCIO), substituindo 'candidata a def na aprovação'.
			Warn declarado: nomes de vo-item-award e dos outcomes
			(awarded/no-quotation/withheld) são INDICATIVOS — glossário do
			ssc decide na fatia (precedente adr-196), ratificado nominalmente.
			Enum decisionClass conferido (structural; precedentes
			adr-174/175/177/180); supersedes verificado como NÃO-cabível
			(adr-177 segue majoritariamente vigente — união discriminada
			exigiria supersessão total); defersTo aponta apenas o def que
			esta decisão cria. def-087/def-088 flipados open→resolved neste
			mesmo commit (padrão def-079/adr-177), cobertos pelos próprios
			SRRs.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round da INCLUSÃO DAS SUPERFÍCIES (decisão do founder na
			aprovação do Ato 2: opção A — os dois api.yaml entram nesta
			fatia; manter a superfície gerada descrevendo a view antiga
			deixaria a main internamente incoerente, o mesmo vício da alt-1
			rejeitada, um nível acima).

			DECISÃO DE CONTRATO DESTA FATIA (não consequência da decisão (6)
			do ADR — correção de registro exigida pelo founder): a
			QuotationMapView do contexts/ssc/api.yaml NÃO é espelho
			mecânico do domain-model; é REDESENHO de superfície gerada.
			Forma escolhida — orientação LINHA-PRIMEIRO: `items` são as
			linhas da matriz (item do escopo + `cells` por fornecedor que o
			cotou + `award` pós-decisão) e `quotations` passa a ser o
			CABEÇALHO por fornecedor (currency, rodadas, condições,
			status), sem duplicar preço.

			ALTERNATIVA DESCARTADA: manter a view agregada POR COTAÇÃO
			(cada cotação com suas `lines` dentro) e montar a matriz na
			borda — transposição no consumidor. REJEITADA por dois motivos:
			(a) a LINHA VAZIA não teria onde existir — item que nenhum
			fornecedor cotou (o no-quotation da decisão (3) do ADR) não
			pertence a cotação alguma, e some da view justamente onde a
			decisão o tornou visível; (b) transpor na borda é derivação
			FORA do read model, o vício que o prj-quotation-map existe para
			evitar ('encapsula derivação numérica para evitar drift de
			cálculo entre consumers') — a implementação recriaria a
			granularidade grossa que esta fatia existiu para eliminar.

			A decisão do adr-198 NÃO foi editada para acomodar a
			superfície (instrução explícita do founder); o registro vive
			aqui e no corpo do PR. affectedArtifacts ganhou os quatro
			arquivos incluídos (2 espelhos P14 + 2 api.yaml) —
			rastreabilidade, não decisão.

			FRONTEND NÃO É TOCADO AGORA: o pin do mesh-frontend-runtime
			está congelado e a regeneração da view (rtd-024, 1ª view do
			regime generated) é fatia futura NAQUELE repo — fora do escopo
			desta e não implicada por ela.

			Verificação: os dois api.yaml parseiam; zero $ref quebrado e
			zero schema órfão (41 no ssc, 30 no p2p); prosa de path
			reexpressa onde descrevia a forma antiga.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message:     "O alcance da coevolução dos espelhos P14 (contexts/*/schemas/events.cue) e das superfícies api.yaml foi descoberto NA EXECUÇÃO — não constava do diff aprovado arquivo a arquivo; escalado ao founder antes do commit com opções e recomendação."
			rationale:   "RESOLVIDO no round 3: espelhos P14 exigidos pelo próprio gate de codegen (não eram opcionais) e api.yaml incluídos por decisão do founder (opção A), com a QuotationMapView registrada como decisão de contrato desta fatia. O warn permanece registrado como o histórico do gap medida-vs-diff."
		}]
	}

	summary: """
		adr-198 accepted por aprovação nominal do founder sobre o texto
		redigido (com o ajuste do N2 → def-093 incorporado): item como
		primitiva (VO com identidade local, alt-2 rejeitada), proposta
		parcial legítima, adjudicação por item com linha vazia nomeada
		(no-quotation/withheld), elo no nível do item carregado pelo p2p
		(alt-3/(i-b) não reabertas), 2º braço reexpresso por linha com
		total como soma (alt-4/alt-5 rejeitadas), sob a primeira
		falsificação disparada do repo (adr-177 (a), por direção não
		antecipada). Evidência de prática: Mesa de Adjudicação (protótipo,
		não norma). Resolve def-087/def-088; cria def-093.
		"""
}
