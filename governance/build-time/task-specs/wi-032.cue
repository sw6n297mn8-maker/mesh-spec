package task_specs

taskSpecs: "WI-032": {
	version:               1
	title:                 "Criar runner de validação cross-artifact"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Schemas de canvas, domain-model, glossary e agent-spec definidos com quality criteria cross-artifact",
		"Ao menos uma instância de cada tipo para ter dados reais contra os quais validar",
	]
	outputs: [{
		artifact: "governance/build-time/runners/cross-artifact-runner.cue"
		type:     "create"
	}]
	affects: [
		"contexts/*/canvas.cue",
		"contexts/*/domain-model.cue",
		"contexts/*/glossary.cue",
		"contexts/*/agents/*.cue",
		"strategic/context-map.cue",
	]
	rationale: "Runner generalizado que enforça quality criteria cross-artifact além do escopo do context-map runner (WI-014). Cobre integridade referencial canvas↔domain-model, domain-model↔glossary, glossary↔canvas, agent-spec↔domain-model. Complementa WI-014 que cobre apenas tq-cm-02."
}
