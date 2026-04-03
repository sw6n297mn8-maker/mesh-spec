package task_specs

taskSpecs: "WI-034": {
	version:               1
	title:                 "Adicionar vetor de colusão e operador plataforma à incentive analysis do CMT canvas"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Canvas CMT com incentiveAnalysis existente (contexts/cmt/canvas.cue)",
		"SCF subdomain definido com cadeia de recebíveis downstream documentada",
	]
	outputs: [{
		artifact: "contexts/cmt/canvas.cue"
		type:     "update"
	}]
	affects: [
		"contexts/cmt/canvas.cue",
	]
	rationale: "Validação semântica vc-cv-02 detectou dois gaps: (1) colusão entre proponente e contraparte para criar compromissos fictícios que alimentam SCF — bypassa gate bilateral por design; (2) operador plataforma (sh-05, agente IA) não analisado como participante com poder assimétrico. Ambos são vetores materiais para um sistema onde CommitmentAccepted origina recebíveis financeiros."
}
