package task_specs

taskSpecs: "WI-161": {
	version:     1
	title:       "Modelar a negociação no ssc (passo 8 da story — o vazio mais denso em valor): rodadas de contraproposta, condições de pagamento, volume com entregas programadas — do mapa de cotações às condições finais que a decisão formaliza"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/domain-stories/buyer-procurement-journey.cue — passo 8: 'não aceita o primeiro preço... o fluxo de caixa é o que evita a obra quebrar'; zero elementos em qualquer BC; a story ganha as refs do passo na execução (molde WI-151/WI-152 refs-fill).",
		"contexts/ssc/domain-model.cue + contexts/ssc/glossary.cue — o lar da modelagem: a negociação vive entre o mapa (prj-quotation-map) e a decisão (cmd-make-one-shot-sourcing-decision); a fonte é a narrativa real (tq-dsg-03: entrevistas + vídeos, 2026-07), não o modelo existente.",
		"architecture/adrs/adr-177-requisition-quotation-link-and-price-provenance-gate.cue — o braço de procedência de preço do portão duplo: a aprovação confere as condições FINAIS; a modelagem da negociação preserva a procedência (as condições negociadas não podem quebrar o elo requisição↔cotação).",
		"contexts/ssc/agents/ssc-primary-agent.cue — catraca agente↔modelo (adr-175/adr-176, sc-ag-02 em reject): todo command/event novo exige cobertura no agent-spec ou exclusão formal per critério do adr-175, no MESMO commit.",
		"O número WI-161 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/ssc/domain-model.cue"
		type:     "update"
	}, {
		artifact: "contexts/ssc/glossary.cue"
		type:     "update"
	}, {
		artifact: "contexts/ssc/agents/ssc-primary-agent.cue"
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
		O único pedaço de modelagem-do-zero do arco: o passo que as fontes
		chamam de 'arte' e que salva o fluxo de caixa da obra não tem nenhum
		comando, evento ou registro — a jornada modelada pula da comparação à
		decisão formal, e o valor real vive exatamente no meio. A modelagem
		nasce das fontes na ordem vivida, liga mapa→decisão preservando a
		procedência de preço (adr-177) e preenche as refs do passo 8 da story.
		Catraca agente↔modelo viaja no mesmo commit. Affects: se os conceitos
		novos cruzarem contrato e entrarem no manifest (que o WI-159 cria), a
		worklist do sc-fct-01 recebe as pendências reconhecidas — mesmo regime
		declarado no WI-159. Sem dependência dura em grafo; prioridade após o
		mapa na ordem da jornada (adr-178 P4). CLASSIFICAÇÃO: updates em
		instâncias de schemas existentes → tmpl-create-instance@v1.
		"""
}
