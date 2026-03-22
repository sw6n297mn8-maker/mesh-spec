package task_specs

taskSpecs: "WI-019": {
	version:     1
	title:       "Drift detection de projeções"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Projeções blocked-items e in-progress criadas (WI-016)",
		"ready-queue.cue como referência de projeção existente",
	]
	outputs: [{
		artifact: "governance/build-time/projection-drift.cue"
		type:     "create"
	}]
	affects: [
		"governance/build-time/projections/*.cue",
	]
	rationale: "CI detecta divergência entre projeções commitadas e estado computado das fontes de verdade. Falha se drift > 0 — agente/humano atualiza. Alternativa rejeitada: auto-rebuild com commit automático, que viola o modelo proposta-antes-de-implementar."
}
