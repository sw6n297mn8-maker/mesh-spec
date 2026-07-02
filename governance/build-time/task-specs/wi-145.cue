package task_specs

taskSpecs: "WI-145": {
	version:     1
	title:       "Enriquecer PaymentGuardEscalated com o contexto de triagem (commitmentRef + invoiceId + amount) — o produtor do alarme rico do WI-144"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/fce/api.yaml — a View do WI-144 (EscalatedPaymentItem) exige commitmentRef/invoiceId/amount/escalatedAt; escalatedAt sai do envelope.time; os outros 3 NÃO existem no log persistido (o materialize não emite evento — 'aggregate birth, no event', PaymentSlice) — este WI fecha o gap no PRODUTOR.",
		"contexts/fce/schemas/events.cue — #PaymentGuardEscalated atual (paymentId + escalatedConditions); #CommitmentRef/#InvoiceId já declarados como opaque refs no arquivo; #DecimalString = canônico shared (money.cue, def-025) — alias local adicionado neste WI (nada semântico novo é criado).",
		"contexts/fce/domain-model.cue — evt-payment-guard-escalated.fields espelha o aggregate (fidelidade interna): commitmentRef → vo-commitment-ref; invoiceId/amount → primitives (string/decimal), como o agg-payment os declara.",
		"architecture/deferred-decisions/def-074 + mesh-runtime rtd-026/029 — o wire de persistência é PROVISÓRIO pré-Ion: dado sintético descarta-e-regera → os 3 campos entram REQUIRED com type mantido em v1 (sem migração; o organismo regrava do zero).",
		"architecture/adrs/adr-140 (Ion-3/Ion-4) — a disciplina de compatibilidade futura: pós-retenção real, mudança equivalente exigiria as 3 camadas ou bump de versão; registrado como fronteira, não aplicável ao regime atual.",
	]
	outputs: [{
		artifact: "contexts/fce/schemas/events.cue"
		type:     "update"
	}, {
		artifact: "contexts/fce/domain-model.cue"
		type:     "update"
	}]
	affects: [
		"contexts/fce/api.yaml",
	]
	rationale: """
		T2a do arco de transporte: o fato da escalação passa a carregar seu
		contexto de triagem — os 3 campos que a fila (QueryEscalatedPayments,
		WI-144) precisa e que o log de hoje não tem. O locus é o PRODUTOR: o
		runtime TEM os dados no momento da decisão (MaterializedPayment +
		invoiceFact no authorize) e o adapter só persiste o que o produtor dá.
		REQUIRED com fundamento (def-074/rtd-026: wire transitório,
		descarta-e-regera; type v1 mantido). amount é #DecimalString puro,
		espelhando o AGGREGATE (decimal sem currency; Ion-4 satisfeito) —
		decisão do founder no corte do T2a: NÃO carregar #Money completo, não
		inventar currency que o aggregate não possui.

		NOTA — lacuna do currency (registro decidido pelo founder):
		aggregate/evento sem currency declarado; correção = enriquecer
		aggregate com #Money completo em fatia própria; gatilho = entrada de
		dado retido (mesmo do def-074). Ripple conhecido: a View do WI-144
		(EscalatedPaymentItem.amount → Money{amount, currency}) fica com
		currency impreenchível até essa fatia — o degrau seguinte (T2b)
		propõe o ajuste da View (amount → decimal string) ou aguarda; decisão
		fora deste WI. A assimetria Kotlin-vs-TS reportada no mapa T2a
		dissolve-se com esta escolha (ambos os recortes gerados passam a
		carregar decimal string sem currency) — registrada como inerte, nada
		a tocar.

		CLASSIFICAÇÃO (lean, decidida pelo founder no corte do T2a):
		instanciação sob adr-155 — o evento materializa o estado escalated
		decidido lá; enriquecer o data com o contexto que a decisão adr-155 +
		o contrato WI-144 já exigem é instanciação dessas decisões, sem novo
		schema e sem novo ADR. CONTRA-ARGUMENTO (apresentado para decisão
		final no PR): shape de evento é contrato CONSUMIDO cross-repo (dois
		geradores) — mudá-lo tem cheiro de 'Semântica: altera contrato';
		mitigantes: zero consumidores externos reais (organismo sintético),
		wire transitório declarado, type v1 mantido, e a mudança é aditiva.
		Downstream (fora deste WI): mesh-runtime regen + produtor preenche
		(T2b); mesh-frontend regen (aditivo, tela compila inalterada).
		Standalone task-spec (precedente WI-143/144). Reversível por remoção
		dos campos + regen (dado sintético).
		"""
}
