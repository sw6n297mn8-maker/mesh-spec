package task_specs

// Par materializado para integridade referencial da state machine (sc-wg-01);
// admissao registrada em backfill; este task-spec NAO habilita execucao —
// ver evento terminal no stream. TRANSCRICAO do wave-plan (precedente Nivel 1).
taskSpecs: "WI-101": {
	version:     1
	title:       "Criar build-time check — C4 drift detection"
	templateRef: "tmpl-validate-artifact@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "governance/build-time/c4-drift.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Drift detection entre fonte CUE e DSL gerado, similar a projection-drift (adr-027). Spec change → diagram regenerated → diff visible. CI integration garante diagrams nunca ficam stale.
		"""
}
