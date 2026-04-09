package task_specs

taskSpecs: "WI-027": {
	version:               2
	title:                 "Definir convenção OpenAPI/AsyncAPI por capability flags"
	templateRef:           "tmpl-create-convention@v1"
	semanticPrerequisites: [
		"Canvas CMT com hasSyncSurface e hasAsyncSurface como referência de uso",
	]
	outputs: [{
		artifact: "architecture/conventions/api-spec-convention.cue"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-047-extend-artifact-type-for-api-specs.cue"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-048-api-spec-convention-conditional-presence.cue"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-049-extend-structural-check-conditional-file-presence.cue"
		type:     "create"
	}, {
		artifact: "architecture/artifact-schemas/quality-criteria.cue"
		type:     "update"
	}, {
		artifact: "architecture/artifact-schemas/structural-check.cue"
		type:     "update"
	}, {
		artifact: "architecture/structural-checks/canvas.cue"
		type:     "update"
	}]
	affects: [
		"contexts/*/api.yaml",
		"contexts/*/async-api.yaml",
	]
	rationale: "Canvas declara hasSyncSurface e hasAsyncSurface. Convenção define quando e como gerar OpenAPI/AsyncAPI specs condicionalmente a partir das capability flags. Entrega em 3 fases: B.0 (extensão do enum #ArtifactType, adr-047), B.1 (convenção + adr-048), B.2 (structural-check + adr-049)."
}
