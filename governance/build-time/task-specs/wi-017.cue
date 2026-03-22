package task_specs

taskSpecs: "WI-017": {
	version:     1
	title:       "Implementar validação CI de claim expiration"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"CI validation de work-events operacional (WI-015)",
		"work-governance.cue seção claimLeases com semântica de expiração definida",
	]
	outputs: [{
		artifact: "governance/build-time/claim-expiration-validation.cue"
		type:     "create"
	}]
	affects: [
		"governance/build-time/event-validation.cue",
	]
	rationale: "Validação de task-claim-expired como extensão do CI. Garante que eventos de expiração são válidos (commandId determinístico, referência a claim original) sem depender de scheduling central."
}
