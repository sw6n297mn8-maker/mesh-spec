package task_specs

taskSpecs: "WI-016": {
	version:     1
	title:       "Criar projeções blocked-items e in-progress"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"work-events/ com streams suficientes para derivar estado",
		"ready-queue.cue como referência de estrutura de projeção",
	]
	outputs: [{
		artifact: "governance/build-time/projections/blocked-items.cue"
		type:     "create"
	}, {
		artifact: "governance/build-time/projections/in-progress.cue"
		type:     "create"
	}]
	affects: []
	rationale: "Projeções complementares à ready-queue completam visibilidade do estado do sistema. Sem elas, itens bloqueados e em progresso requerem inspeção manual de event streams."
}
