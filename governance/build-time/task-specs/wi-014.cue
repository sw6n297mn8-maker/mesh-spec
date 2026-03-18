package task_specs

taskSpecs: "WI-014": {
	version:     1
	title:       "Alinhar domain/stakeholder-map.cue com glossário universal"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Glossário universal (domain/ubiquitous-language/) existir e estar aprovado",
	]
	outputs: [{
		artifact: "domain/stakeholder-map.cue"
		type:     "update"
	}]
	affects: []
	rationale: "Nomes, descrições e roles no stakeholder-map devem usar exatamente os termos canônicos do glossário. Sem alinhamento, o artefato diverge da linguagem ubíqua."
}
