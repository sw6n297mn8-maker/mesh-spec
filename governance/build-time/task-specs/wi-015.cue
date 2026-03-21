package task_specs

taskSpecs: "WI-015": {
	version:     1
	title:       "Criar CI validation de work-events"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"work-governance.cue com state machines, command authority e idempotency definidos",
		"command-rights.cue como SoT de autoridade",
		"work-events/ com streams existentes para testar validação",
	]
	outputs: [{
		artifact: "governance/build-time/event-validation.cue"
		type:     "create"
	}]
	affects: [
		"governance/build-time/work-events/*.cue",
	]
	rationale: "Sem CI validation, regras de state machine, autoridade e idempotência existem apenas como especificação — enforcement é manual e falível. Bootstrap exception: eventos deste WI não são validados pelo CI que ele próprio cria."
}
