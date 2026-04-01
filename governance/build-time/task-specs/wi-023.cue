package task_specs

taskSpecs: "WI-023": {
	version:               1
	title:                 "Criar contexts/cmt/glossary.cue"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Canvas CMT com ubiquitousLanguageRef apontando para contexts/cmt/glossary.cue",
	]
	outputs: [{
		artifact: "contexts/cmt/glossary.cue"
		type:     "create"
	}]
	affects: []
	rationale: "Primeira instância de glossary. Desbloqueia ubiquitousLanguageRef do canvas CMT. Define termos canônicos da Ubiquitous Language do Commitment Management."
}
