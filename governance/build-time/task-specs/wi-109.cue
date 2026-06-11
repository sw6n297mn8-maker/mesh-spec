package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-109": {
	version:     1
	title:       "Criar quality criteria família tq-stack-NN (coherence do conjunto in-scope)"
	templateRef: "tmpl-validate-artifact@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/structural-checks/stack-coherence.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Os ADRs de stack in-scope (adr-140 codegen/contracts + adr-141 kernel/Ports + ADRs de Port-vendor materializados JIT) decidem em isolamento mas devem ser coerentes: CUE-first codegen path existe + Port contracts conformes a P7 + per-Port deferrals (def-041..045) rastreados. Quality criteria família valida coherence. Escopo estreitado per adr-139 — não cobre mais observability/deploy/frontend (runtime/deferidos).
		"""
}
