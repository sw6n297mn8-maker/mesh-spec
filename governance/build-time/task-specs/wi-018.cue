package task_specs

taskSpecs: "WI-018": {
	version:     1
	title:       "Criar completion-gates e enforcement CI"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"CI validation de work-events operacional (WI-015)",
		"task-governance.cue com regras de execução por template",
	]
	outputs: [{
		artifact: "governance/build-time/completion-gates.cue"
		type:     "create"
	}]
	affects: [
		"governance/build-time/event-validation.cue",
	]
	rationale: "Define gates obrigatórios por tipo de artefato e estende CI para validar gatesPassed em task-completed. Sem definição formal, completionValidation aceita qualquer lista — sem enforcement real."
}
