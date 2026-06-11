package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-127": {
	version:     1
	title:       "Criar ADR — C4 generation strategy (CUE-derived Structurizr DSL)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/adrs/adr-097-c4-generation-strategy.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Decisão crítica: CUE-derived (codegen para Structurizr DSL, single source of truth, no drift) vs manual Structurizr workspace + sync rules vs híbrido. ADR documenta escolha (CUE-derived alinhado com P1) + path de codegen.
		"""
}
