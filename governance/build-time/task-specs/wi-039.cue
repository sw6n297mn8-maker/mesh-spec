package task_specs

taskSpecs: "WI-039": {
	version:               1
	title:                 "Revisar canvas e domain models existentes pós-expansão ontológica"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Context map v2 reconstruído (WI-038)",
	]
	outputs: [{
		artifact: "contexts/cmt/canvas.cue"
		type:     "update"
	}, {
		artifact: "contexts/ctr/canvas.cue"
		type:     "update"
	}]
	affects: [
		"contexts/cmt/domain-model.cue",
		"contexts/cmt/glossary.cue",
	]
	rationale: """
		Canvas CMT e CTR foram modelados com a Mesh posicionada como
		infraestrutura financeira. Com a ontologia expandida, CTR deixa
		de ser entrada do sistema e vira estágio pós-sourcing; CMT recebe
		novos upstream dependencies (P2P, SSC via CTR). Ambos precisam
		revisão de posicionamento no macrofluxo, upstream/downstream
		dependencies, stakeholders e commands de entrada. Domain model e
		glossary do CMT podem precisar ajustes derivados. O conteúdo
		existente é preservável — a revisão é de posicionamento e
		fronteiras, não de reescrita.
		"""
}
