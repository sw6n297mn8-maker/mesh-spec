package task_specs

taskSpecs: "WI-162": {
	version:     1
	title:       "Materializar a proposta de decisão de sourcing como fato de domínio do ssc (adr-196): evento interno da preparação + projection viva com query, cobertura no agent-spec e refs do passo 7 da story"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-196-materialize-sourcing-decision-proposal.cue — a decisão que esta fatia executa (status accepted). Decisão (1) evento interno com ranking + allocationPolicy + decisionRationale + fitnessRuleSnapshot; (2) projection viva com query, carimbada pela decisão; (3) a fatia decide o NAMING final sob o glossário do ssc (os nomes do ADR são indicativos); (4) a postura transitória da alternativa C cessa quando esta fatia executar.",
		"contexts/ssc/domain-model.cue — o lar: o evento entra no catálogo do agg-sourcing-process e a projection ao lado de prj-quotation-map, que o ADR nomeia como MOLDE (viva durante a janela, carimbada pela decisão). O evento é INTERNO (confidencialidade competitiva, molde dos fatos de cotação — consequência N4 do ADR).",
		"contexts/ssc/agents/ssc-primary-agent.cue — catraca agente↔modelo (adr-175/adr-176, sc-ag-02 em reject): act-evaluate-and-conclude-rfq passa a cobrir o evento novo no MESMO commit. O ADR nomeia esta cobertura na decisão (3).",
		"contexts/ssc/glossary.cue — a decisão (3) roteia o naming final por aqui; o regime adr-151 Forma A exige coreNoun/termo para elemento first-class.",
		"strategic/domain-stories/buyer-procurement-journey.cue — passo 7 entrou com commandRefs/eventRefs VAZIOS por lacuna honesta (adr-170); a fatia fecha as refs (molde refs-fill do WI-151/WI-152).",
		"CADÊNCIA DE EMISSÃO — a consequência N2 do adr-196 declara a pergunta SEM resposta: re-avaliação a cada cotação nova emitiria ruído; emitir no fecho da janela ou como re-proposta explícita é decisão DESTA fatia. Resolver antes de modelar o evento; sem isso o fato nasce com semântica ambígua.",
		"FALSIFICAÇÃO HERDADA — o adr-196 declara: proposta materializada sem consumidor real é cerimônia, não evidência. A projection nasce com queryCapability ou a fatia não cumpre o ADR.",
		"O número WI-162 deve ser re-derivado pelo freshness gate (G2 --assert WI=162) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/ssc/domain-model.cue"
		type:     "update"
	}, {
		artifact: "contexts/ssc/agents/ssc-primary-agent.cue"
		type:     "update"
	}, {
		artifact: "contexts/ssc/glossary.cue"
		type:     "update"
	}, {
		artifact: "strategic/domain-stories/buyer-procurement-journey.cue"
		type:     "update"
	}]
	affects: [
		"contexts/ssc/aggregate-manifests/am-sourcing-process.cue",
		"governance/build-time/first-class-backfill-worklist.cue",
	]
	rationale: """
		Execução de decisão já tomada, não decisão nova: o adr-196 está
		accepted desde 2026-09-03 e defere a materialização a fatia própria.
		Enquanto a fatia não roda, vigora a postura transitória da decisão (4)
		— a superfície de ratificação exibe a proposta sob marca de
		não-verificado — e a plataforma cuja tese é evidência verificável
		mantém sua peça central de preparação como não-verificável.

		Fecha também uma órfã de governança: o adr-196 é o único ADR do arco
		de compras sem defersTo e sem work-item que o cite — a cobrança da
		execução não existia em nenhuma das duas vias. Este WI é a via.

		A fatia carrega UMA decisão de modelagem que o ADR deixou aberta de
		propósito (N2): a cadência de emissão. Resolver primeiro, modelar
		depois — um fato emitido a cada cotação recebida transforma a
		história do agregado em ruído e falsifica o próprio ADR pelo outro
		lado (evidência que ninguém consegue ler não é evidência).
		CLASSIFICAÇÃO: updates em instâncias de schemas existentes →
		tmpl-create-instance@v1; sem ADR novo (a decisão é o adr-196); sem
		número novo de família além do próprio WI.
		"""
}
