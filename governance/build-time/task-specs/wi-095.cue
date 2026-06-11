package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-095": {
	version:     1
	title:       "Criar C4 L3 — Components para INV"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/c4/components-inv.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		L3 derivado de contexts/inv/domain-model.cue.
		"""
}
