package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-089": {
	version:     1
	title:       "Criar C4 L2 — Containers (per topology decision)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/c4/containers.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		L2 reflete topology decision (WI-087) + stack choices (WI-103 compute, WI-104 persistence, WI-105 eventing). Containers incluem deployable units + data stores + event bus + API gateway.
		"""
}
