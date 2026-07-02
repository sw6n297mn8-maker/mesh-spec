package task_specs

taskSpecs: "WI-146": {
	version:     1
	title:       "Command surface do resolve-guard-escalation — o degrau de ESCRITA do override (canvas inbound + POST no api.yaml, sob def-024)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-155-human-override-prepayment-guard-fce.cue (accepted) — a decisão de domínio: supervisedDecision com atribuição nominal obrigatória; command + 2 outcomes + piso inoverridável JÁ materializados no domain-model/events (nenhuma mudança de domínio neste WI).",
		"contexts/fce/domain-model.cue cmd-resolve-guard-escalation — os 5 campos do request (paymentId, supervisorId, reason, decision, overriddenConditions); decision é primitive string com a disjunção approve|deny nas transições — o mirror crava enum por fidelidade.",
		"contexts/fce/schemas/events.cue — #PaymentGuardOverridden (com proof) e #PaymentGuardOverrideRefused: os 2 outcomes que o 200 devolve (oneOf, molde CMT 'devolve o evento emitido').",
		"contexts/cmt/api.yaml — o MOLDE de comando vigente (POST /v1/{bc}/commands/{kebab}, Idempotency-Key, {Command}Request, 400/404/409/422/500 Problem+json): herança, não precedente novo.",
		"architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue — a postura sem security/servers sob a qual este write entra (como os 6 POSTs do CMT); permanece open; amendment textual do costOfDeferral registra o custo subindo de posto.",
		"contexts/fce/canvas.cue oq-fce-1 — o item (a) que este WI materializa; impact atualizado; (b) caminho autônomo e (c) async seguem abertos.",
	]
	outputs: [{
		artifact: "contexts/fce/canvas.cue"
		type:     "update"
	}, {
		artifact: "contexts/fce/api.yaml"
		type:     "update"
	}, {
		artifact: "architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue"
		type:     "update"
	}]
	affects: [
		"architecture/structural-checks/canvas.cue",
	]
	rationale: """
		Degrau de ESCRITA do oq-fce-1 (não o fecha: caminho autônomo + async
		seguem abertos): o primeiro command supervisionado da Mesh na borda
		sync. Dois toques + um registro: (1) canvas — +1 command-handler no
		inbound (sync, espelho do ConfirmCommitmentAcceptance: o supervisor
		espera confirmação imediata; resultingEvents os 2 outcomes) + impact
		do oq-fce-1; (2) api.yaml — +1 POST no molde CMT com request dos 5
		campos do command, decision como enum [approve, deny] (decisão do
		founder: fidelidade à disjunção das transições), 200 devolvendo o
		EVENTO emitido em oneOf (PaymentGuardOverridden com proof — auditável
		— ou PaymentGuardOverrideRefused), 409 para transição ilegal, 422
		para invariante violado; (3) def-024 — amendment textual mínimo do
		costOfDeferral (write supervisionado eleva o custo do deferimento;
		status open e trigger intactos — resolver agora inventaria auth sem
		ADR, exatamente o que o def proíbe).

		POSTURA (def-024): supervisorId é atribuição nominal NÃO-verificada
		na borda até o ADR de auth. A garantia estrutural do adr-155
		(impossível emitir sem supervisorId) vive no schema; enforcement
		humano-only é estágio 2 (oq-fce-3, agent-governance) — fora desta
		superfície.

		CLASSIFICAÇÃO: instanciação sob adr-155 (o command, os eventos, as
		transições e o piso foram decididos lá; este WI só os expõe na borda
		sob molde existente) — SEM ADR novo (precedente WI-143/144/145).
		Standalone task-spec. Reversível por remoção do path/entry.
		Downstream (fora deste WI): W2 runtime (handler POST no serve +
		transição no slice; flag registrada — o handler precisará construir
		AuthorizationProof com valores dev-honestos; pre-flight do W2
		verifica se o runtime já tem construção de proof); W3 frontend
		(onConfirm real no seam type-only).
		"""
}
