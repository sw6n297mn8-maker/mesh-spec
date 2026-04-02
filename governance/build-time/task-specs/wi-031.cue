package task_specs

taskSpecs: "WI-031": {
	version:               1
	title:                 "Criar domain/stakeholder-map.cue"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Domain-definition com tese e mecanismos para identificar stakeholders relevantes",
	]
	outputs: [{
		artifact: "domain/stakeholder-map.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/canvas.cue",
	]
	rationale: "Instância do catálogo de stakeholders. Desbloqueia refs sh-* no canvas. Depende do schema #StakeholderMap (WI-029)."
}
