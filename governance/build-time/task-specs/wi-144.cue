package task_specs

taskSpecs: "WI-144": {
	version:     1
	title:       "Ampliar a superfície de leitura do FCE: query de escalados (QueryEscalatedPayments) — o degrau de leitura do oq-fce-1 para a tela de override"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/fce/api.yaml — JÁ EXISTE (WI-143, recorte de leitura by-id): este WI o AMPLIA com a primeira query de lista do repo; molde de View e mirrors x-mesh-cue-ref estabelecidos lá.",
		"contexts/fce/domain-model.cue — agg-payment carrega amount (decimal), escalatedAt (datetime, carimbo adr-155), invoiceId e commitmentRef: a matéria-prima FCE-local do alarme rico; NENHUM campo novo é criado.",
		"contexts/fce/schemas/events.cue — #PaymentGuardEscalated (paymentId + escalatedConditions) e #OverriddenGuardConditions (piso de 3 flags) e #Money (shared, def-025): fontes dos mirrors da View.",
		"architecture/adrs/adr-155-human-override-prepayment-guard-fce.cue (accepted) — o estado escalated e o piso inoverridável que a fila expõe.",
		"architecture/adrs/adr-157-frontend-runtime-bootstrap-handoff.cue — o consumidor imediato: a tela de override do frontend-runtime, hoje sobre dev-fixture (forma (a)); esta query é o degrau de LEITURA do transporte.",
		"contexts/cmt/api.yaml + contexts/dlv/api.yaml — as queries existentes (commitment-state; evidence-ledger/verification-status) que o cliente segue via commitmentRef para compor o dossiê profundo — por isso o alarme rico NÃO precisa de JOIN servidor.",
	]
	outputs: [{
		artifact: "contexts/fce/canvas.cue"
		type:     "update"
	}, {
		artifact: "contexts/fce/api.yaml"
		type:     "update"
	}]
	affects: [
		"architecture/structural-checks/canvas.cue",
	]
	rationale: """
		Degrau de LEITURA do oq-fce-1 (NÃO o fecha; deadline 2026-07-31): a fila
		de dúvidas da cadeia esperando decisão humana. Dois toques: (1) canvas —
		+1 entry query-surface (QueryEscalatedPayments) no inbound, ao lado da
		QueryPaymentSettlementStatus, + atualização do impact do oq-fce-1
		(parcialmente materializada); (2) api.yaml — +1 path GET
		/v1/fce/queries/escalated-payments + EscalatedPaymentsView/Item + mirrors
		Money e OverriddenGuardConditions, + header refletindo o recorte ampliado.

		FORMA (decisão do founder, sessão 2026-07-02): alarme rico FCE-local +
		referências navegáveis. A View = {items: [{paymentId, commitmentRef,
		invoiceId, amount, escalatedAt, escalatedConditions}]} — TUDO projeção
		FCE-local do mesmo event log (mistura estado do aggregate e fato de
		escalação; mesma natureza da PaymentSettlementStatusView; o FCE não
		declara projection no domain-model). O dossiê profundo compõe-se no
		CLIENTE via as queries CMT/DLV existentes seguindo o commitmentRef;
		dossiê servidor cross-BC é projeção cross-agregado Phase 1+ (NIM,
		adr-165) — explicitamente fora. Envelope {items} desde o v1 (objeto, não
		array nu): paginação/filtros/metadados entram aditivamente; NENHUM no v1
		— primeira query de LISTA do repo, o envelope é a aposta de evolução
		aditiva do contrato.

		def-024 NÃO bloqueia: a query entra sob a mesma postura sem
		security/servers do slice (deferimento consciente registrado). O command
		de resolve segue deferido (command-surface no canvas + def-024) — o
		degrau de ESCRITA é WI futuro.

		Instanciação de BC sob molde existente — SEM ADR (precedente WI-143;
		nenhum schema/protocolo alterado). Standalone task-spec — não entra no
		wave-plan (precedente WI-129/130/131/143). Criticality medium (default
		tmpl-create-instance@v1). Reversível por remoção do path/entry.
		"""
}
