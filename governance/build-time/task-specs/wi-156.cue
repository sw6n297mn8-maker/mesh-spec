package task_specs

taskSpecs: "WI-156": {
	version:     1
	title:       "Fatia de spec da triagem — POST /v1/p2p/commands/triage-requisition no api.yaml (a 'fatia da tela 2' que o adr-178 D1 deixou fora por decisão) + extensão da 2ª família do contrato de frontend com a action-surface da triagem"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue — D1 deixa o POST da triagem FORA do kit por decisão; esta fatia o materializa herdando convenção adr-048 e postura def-024 (sem security/servers) sem re-decidir; a onda p2p que N4 exigia preceder/acompanhar foi drenada em 2026-07-16 (worklist vazia).",
		"architecture/adrs/adr-179-frontend-promotion-mandate-reading-contract.cue — reading contract de fatia de tela (dec 2); a extensão da família p2p aqui NÃO dispara a promoção a schema (gatilho permanece adr-178 D3, a 3ª família).",
		"contexts/p2p/domain-model.cue — cmd-triage-requisition (outcome routed-to-sourcing | returned | rejected) + evt-purchase-requisition-triaged + prj/qry-pending-requisitions: o domínio da triagem existe desde WI-151/adr-174; esta fatia é superfície, não modelagem.",
		"contexts/p2p/api.yaml + contexts/p2p/schemas/events.cue — molde dos 2 paths existentes (envelope {items}, Idempotency-Key, evento-confirmação como resposta 200, x-mesh-cue-ref); a triagem segue o molde; a nota P14 do outcome ABERTO nos schemas permanece (o domínio não o fecha).",
		"governance/build-time/frontend-codegen-contract.cue — v2, famílias fce + p2p; a action-surface da triagem estende a família p2p (par botão-humano+tool-de-agente de UMA definição per adr-150); a view da fila permanece regime hand da 1ª família.",
		"O número WI-156 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/p2p/api.yaml"
		type:     "update"
	}, {
		artifact: "governance/build-time/frontend-codegen-contract.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Passo 3 da ds-buyer-procurement-journey: a triagem é a fronteira
		requisitante→comprador e a primeira tela de DECISÃO humana do arco
		(fila → análise → routed-to-sourcing | returned | rejected). O adr-178
		D1 deixou o POST fora do kit por decisão explícita; esta fatia o
		materializa no molde dos 2 paths existentes e estende a família p2p do
		contrato com a action-surface da triagem — confirmação estruturada
		devolvendo evt-purchase-requisition-triaged; dinheiro não move,
		Approval-as-Confirmation não é acionada (adr-150 dec 2c). Prioridade 1
		do arco jornada→produção (ordem da jornada, adr-178 P4: o dado real da
		submissão alimenta a fila; a triagem alimenta o sourcing).
		CLASSIFICAÇÃO: updates em instâncias de schemas existentes (api-spec +
		contrato de codegen) → tmpl-create-instance@v1, molde WI-155.
		"""
}
