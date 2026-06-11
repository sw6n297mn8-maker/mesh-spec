package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-088": {
	version:     1
	title:       "Criar C4 L1 — System Context (atores + sistemas externos + sistema Mesh)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/c4/system-context.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		L1 stack-agnóstico. Referencia stakeholder-map (atores humanos) + external systems do context-map (financial-institution, government-authority, saas-provider). Não depende de stack — pode ser instanciado antes de WI-087.
		"""
}
