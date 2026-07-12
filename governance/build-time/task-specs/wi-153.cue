package task_specs

taskSpecs: "WI-153": {
	version:     1
	title:       "Re-papel bdg-side do two-phase Reservation/Confirmation (adr-174) — pol-commitment-accepted-triggers-approval muda de gate-tardio para EFETIVAÇÃO da reserva feita na aprovação pré-pedido; evento de reserva + chave por requisição"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-174-approval-as-gate-before-order.cue — a decisão que esta fatia materializa no lado bdg: aprovação é PORTÃO pré-pedido (decisão A do def-078); two-phase Reservation/Confirmation (ADR-C4-2.0 §2.0.8): aprovação RESERVA, commitment aceito EFETIVA, cancelamento LIBERA. O lado p2p entrou no WI-151; o re-papel bdg-side é DECLARADO no adr-174 decisão 4 e executado aqui — uma fatia por vez.",
		"architecture/deferred-decisions/def-078-approval-order-gate-vs-consequence.cue (resolved) — a ordem da aprovação está decidida e resolvida por adr-174; esta fatia NÃO reabre a decisão, apenas materializa o papel novo do bdg sob ela.",
		"contexts/bdg/domain-model.cue — superfície de escrita da fatia: pol-commitment-accepted-triggers-approval re-papelizada (de disparo do Gate de Cobertura pós-commitment para EFETIVAÇÃO da reserva pré-existente); evento de reserva + chave por requisição (a surface QueryBudgetApprovalStatus hoje é keyed por CommitmentId — a janela declarada no adr-174 consequences fecha aqui). Output.",
		"contexts/p2p/domain-model.cue — o lado p2p do acoplamento (WI-151): inv-approval-requires-coverage-reservation declara dependsOnAggregateState → bdg agg-cost-center via QueryBudgetApprovalStatus; coverageReservationRef nos events/commands da requisição; release no cancelamento de requisição approved. Esta fatia fecha o outro lado do mesmo contrato.",
		"O número WI-153 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/bdg/domain-model.cue"
		type:     "update"
	}]
	affects: [
		"contexts/p2p/domain-model.cue",
		"contexts/p2p/canvas.cue",
		"contexts/bdg/canvas.cue",
		"strategic/context-map.cue",
	]
	rationale: """
		O adr-174 preservou o mecanismo do bdg integralmente e mudou o TEMPO
		da invocação: o Gate de Cobertura (Saldo Disponível + Alçada) passa a
		ser invocado na aprovação da requisição, PRÉ-pedido. Isso deixa a
		policy antiga do bdg (pol-commitment-accepted-triggers-approval)
		descrevendo o papel velho — gate-tardio pós-CommitmentAccepted. Esta
		fatia re-papeliza: CommitmentAccepted passa a EFETIVAR a reserva
		feita na aprovação (two-phase Reservation/Confirmation §2.0.8), com
		evento de reserva próprio e chave por requisição na superfície de
		leitura (QueryBudgetApprovalStatus hoje é keyed por CommitmentId).

		JANELA DECLARADA (adr-174 consequences): até esta fatia executar, a
		policy antiga ainda descreve o papel velho — divergência conhecida e
		datada, não drift silencioso. Cancelamento de requisição approved já
		declara a liberação da reserva no lado p2p (cmd-release-budget-
		commitment existe no bdg); o disparo materializa aqui.

		A JANELA COBRE TAMBÉM O ESPELHO ESTRUTURAL do acoplamento: no
		shape npm↔idc (adr-055 decisão 5), a dependência sync aparece
		como query-dependency no canvas do consumidor E como relação no
		context-map. O canvas do p2p pós-WI-151 declara a interação do
		PORTÃO apenas em prosa (handler ApprovePurchase) — a entry
		query-dependency p2p→bdg e a relação p2p-to-bdg no context-map
		entram AQUI, junto com a chave por requisição (declarar contrato
		estrutural sobre surface keyed por CommitmentId cristalizaria a
		chave errada).

		NÃO executar junto ao WI-151 — uma fatia por vez, per adr-174
		decisão 4. Registro nasce no mesmo commit da fatia p2p (o adr-174
		declara wi-153.cue em plannedOutputs).

		CLASSIFICAÇÃO: instância de schema existente (edições no domain-model
		do bdg — policy/event/projection) → tmpl-create-instance@v1.
		"""
}
