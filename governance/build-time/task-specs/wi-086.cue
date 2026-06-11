package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-086": {
	version:     1
	title:       "Criar schemas C4 — #C4Workspace, #C4View, #C4Element, #C4Relationship"
	templateRef: "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/c4-workspace.cue"
		type:     "create"
	}]
	affects: [
		"architecture/c4/*.cue",
	]
	rationale: """
		Schema canonical para C4 artifacts. Estruturalmente alinhado com Structurizr DSL model (people, software systems, containers, components, relationships, views). Habilita codegen + drift detection.
		"""
}
