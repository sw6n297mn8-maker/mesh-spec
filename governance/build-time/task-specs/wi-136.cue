package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: criacao do schema #GoldenExample (+ PG, cascade sc-pg-01) — create-schema.
taskSpecs: "WI-136": {
	version:     1
	title:       "Criar schema #GoldenExample + production-guide"
	templateRef: "tmpl-create-schema@v1"
	semanticPrerequisites: []
	outputs: [{
		artifact: "architecture/artifact-schemas/golden-example.cue"
		type:     "create"
	}, {
		artifact: "architecture/production-guides/golden-example.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Cascade ordering (sc-pg-01): schema + production-guide antes da instância. golden-examples são referenciados no CLAUDE.md mas o tipo nunca foi formalizado (0 instâncias) — este WI fecha a lacuna. Formalizado como ArtifactType em adr-145 (schema #GoldenExample + PG + enum #ArtifactType + cobertura sc-pg-01).
		"""
}
