package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-100": {
	version:     1
	title:       "Criar scripts/build/generate-c4-dsl.sh — codegen CUE → Structurizr DSL"
	templateRef: "tmpl-create-script@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "scripts/build/generate-c4-dsl.sh"
		type:     "create"
	}]
	affects: []
	rationale: """
		Codegen script segue pattern de WI-065 (generate-claude-md.sh). cue export sobre package c4 → Structurizr DSL. Idempotência byte-a-byte enforcement.
		"""
}
