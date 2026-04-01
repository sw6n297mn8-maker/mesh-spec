package task_specs

taskSpecs: "WI-027": {
	version:               1
	title:                 "Definir convenção OpenAPI/AsyncAPI por capability flags"
	templateRef:           "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"Canvas CMT com hasSyncSurface e hasAsyncSurface como referência de uso",
	]
	outputs: [{
		artifact: "architecture/conventions/api-spec-convention.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/api.yaml",
		"contexts/*/async-api.yaml",
	]
	rationale: "Canvas declara hasSyncSurface e hasAsyncSurface. Convenção define quando e como gerar OpenAPI/AsyncAPI specs condicionalmente a partir das capability flags."
}
