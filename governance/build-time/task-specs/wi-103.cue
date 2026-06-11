package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: adr-141 e instancia de #ADR (+ def-041..045 instancias de
// #DeferredDecision).
// PATH-DRIFT (espelha o stream wi-103): os outputs de deferred-decision
// materializaram como def-04X-*-vendor-of-record.cue, divergindo dos paths
// planejados no wave-plan (def-04X-*-vendor.cue). Outputs abaixo = REAIS
// verificados no disco; correcao dos paths planejados no wave-plan = Nivel 2.
taskSpecs: "WI-103": {
	version:     1
	title:       "Autorar ADR — Runtime kernel / Port contracts (P7 concreto) + topologia lógica de containers"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"adr-139 aceito (reconciliação de stack: filtro spec×runtime, keystone-first)",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-141-runtime-kernel-port-contracts.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-041-eventlogport-vendor-of-record.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-042-ledgerport-vendor-of-record.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-043-workflowport-vendor-of-record.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-044-deliveryport-vendor-of-record.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-045-evidenceport-vendor-of-record.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Keystone (adr-139): materializa P7 concreto — 5 Ports retornando PortResult<T>, value classes na fronteira de Port, module boundary — e a topologia LÓGICA de containers (BC→módulo), absorvendo o escopo de WI-087. A seleção de vendor atrás de cada Port é deferida per-Port (def-041..045) e materializada JIT pós golden-example. Consumido pelo golden-example CMT via WI-134 (EventLogPort + adapter-stub).
		"""
}
