package task_specs

taskSpecs: "WI-152": {
	version:     1
	title:       "Superfície de leitura do mapa de cotações no BC ssc — projection/query de comparação (equalização TCO consultável); paralelo ao padrão read-surface do WI-144 (QueryEscalatedPayments)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/ssc/domain-model.cue — o ssc tem a ESCRITA das cotações e a equalização TCO, mas NENHUMA projection/query de comparação: o mapa de cotações não é consultável. Superfície de escrita desta fatia (adicionar readModel + query). Output.",
		"governance/build-time/task-specs/wi-144.cue — precedente do padrão read-surface: QueryEscalatedPayments ampliou a superfície de leitura do FCE (query de escalados). Esta fatia espelha o mesmo padrão (projection/query sobre um write já existente) para o mapa de cotações do ssc.",
		"strategic/domain-stories/buyer-procurement-journey.cue — o mapa de cotações é o instrumento central do comprador na jornada; a lacuna de leitura o deixa cego na comparação. Fecha uma lacuna que a jornada expõe.",
		"O número WI-152 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/ssc/domain-model.cue"
		type:     "update"
	}]
	affects: [
		"strategic/domain-stories/buyer-procurement-journey.cue",
	]
	rationale: """
		O mapa de cotações não é consultável: o ssc tem o write e a equalização
		TCO, mas nenhuma projection/query de comparação. É lacuna de LEITURA no
		instrumento central do comprador — ele não enxerga a comparação que o
		próprio sistema já calcula.

		Padrão já provado no repo: WI-144 (QueryEscalatedPayments) ampliou a
		superfície de leitura do FCE com uma query sobre um write existente.
		Esta fatia aplica o mesmo padrão ao ssc: readModel do mapa de cotações +
		query de comparação (equalização TCO consultável).

		Independente de def-078 e da fatia da requisição (WI-151): é lacuna de
		leitura pura, não toca a ordem da aprovação nem o conceito de requisição.
		Pode ser sequenciada isoladamente.

		CLASSIFICAÇÃO: instância de schema existente (projection/query no
		domain-model do ssc) → tmpl-create-instance@v1.
		"""
}
