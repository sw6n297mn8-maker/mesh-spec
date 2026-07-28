package task_specs

taskSpecs: "WI-159": {
	version:     1
	title:       "Kit de superfície do ssc + api de abertura de RFQ (molde adr-178, 3º kit da cadeia FCE→p2p→ssc) — api.yaml, schemas/events.cue, am-sourcing-process, port-manifest; destrava a geração runtime (discovery rtd-013) e o degrau da 3ª família"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue — o molde do kit: api.yaml (convenção adr-048; postura def-024 sem security/servers), schemas como #Envelope sobre shared-schemas com fidelidade P14, manifest zero-drift verbatim do domain-model, port-manifest com grafia canônica; async-api segue o precedente do gatilho browser-live (fora do kit).",
		"contexts/ssc/domain-model.cue — o domínio do recorte existe (WI-152 fechou os vazios de leitura/observabilidade): agg-sourcing-process, cmd-open-rfq/evt-rfq-opened, cmd-submit-quotation/evt-quotation-submitted (internal — confidencialidade competitiva veta evento público, não o fato), cmd-make-one-shot-sourcing-decision/evt-sourcing-decision-made; esta fatia é superfície.",
		"contexts/ssc/canvas.cue — declara surfaces true sem os arquivos (warns de coevolução vivos); o api.yaml quita o warn da sync surface, molde do que o adr-178 P3 fez no p2p.",
		"governance/build-time/first-class-backfill-worklist.cue — CONSEQUÊNCIA CONHECIDA: o 1º aggregate-manifest do ssc traz os conceitos cross-contract do recorte para dentro do sc-fct-01 como pendências RECONHECIDAS (falsificação 4 do adr-151: pendente-reconhecido ≠ verde-falso; gate segue reject); a drenagem é a onda ssc, higiene subsequente no molde das 5 ondas anteriores — declarada, nunca retrocesso silencioso (uq-05).",
		"O número WI-159 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/ssc/api.yaml"
		type:     "create"
	}, {
		artifact: "contexts/ssc/schemas/events.cue"
		type:     "create"
	}, {
		artifact: "contexts/ssc/aggregate-manifests/am-sourcing-process.cue"
		type:     "create"
	}, {
		artifact: "contexts/ssc/port-manifest.cue"
		type:     "create"
	}, {
		artifact: "governance/build-time/first-class-backfill-worklist.cue"
		type:     "update"
	}]
	affects: [
		"contexts/ssc/canvas.cue",
	]
	rationale: """
		Abre o ssc no arco de telas: repete o padrão provado (FCE
		WI-140/143/144/146; p2p adr-178) no BC da cotação — o kit é o degrau
		spec que habilita a geração runtime (o discovery pega o BC no próximo
		regenerate, sem ação daquele repo) e a superfície de abertura de RFQ
		(passo 5 da story, onde a jornada modelada originalmente começava). O
		recorte de paths do api.yaml (abertura + leituras do recorte) é decisão
		da execução no molde adr-178 D1 (recorte EXATO declarado lá); o GET do
		mapa de cotações fica FORA — é a fatia do WI-160. A entrada de cotação
		do fornecedor (passo 6) fica FORA — aguarda a decisão de produto
		(portal vs registro pelo comprador), registrada em WI próprio após a
		decisão. Consequência worklist declarada nos prerequisites (uq-05).
		CLASSIFICAÇÃO: create de instâncias de tipos com schema existente
		(api-spec, eventos, aggregate-manifest, port-manifest) →
		tmpl-create-instance@v1.
		"""
}
