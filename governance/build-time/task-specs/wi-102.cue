package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: adr-140 e instancia de #ADR (+ def-040/049 instancias de
// #DeferredDecision) — create-instance e o template factualmente aplicavel.
taskSpecs: "WI-102": {
	version:     1
	title:       "Autorar ADR — Codegen/contracts (CUE SoT → tipos gerados) + slice de contrato HTTP"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"adr-139 aceito (reconciliação de stack: filtro spec×runtime, keystone-first)",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-140-codegen-contracts.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-040-http-runtime-stack.cue"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-049-assertion-to-test-mechanism.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Keystone (adr-139): materializa o codegen path estabilizado — CUE como SoT gera tipos/validadores/stubs (P1) — incluindo as regras de contrato HTTP (Money-string, payload via schema) como slice próprio. O runtime HTTP (framework, IdP, ingress/gateway) é deferido a def-040. É o contrato que o golden-example CMT consome via WI-134.
		"""
}
