package task_specs

taskSpecs: "WI-036": {
	version:               1
	title:                 "Corrigir domain-definition.cue — ontologia raiz incompleta"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Definição expandida do domínio fornecida pelo founder (sessão 2026-04-04)",
	]
	outputs: [{
		artifact: "domain/domain-definition.cue"
		type:     "update"
	}]
	affects: [
		"strategic/subdomains/",
		"strategic/context-map.cue",
		"contexts/cmt/canvas.cue",
		"contexts/ctr/canvas.cue",
		"domain/stakeholder-map.cue",
	]
	rationale: """
		domain-definition.cue ensina o sistema a pensar o domínio. O
		artefato atual exclui de outOfScope atividades que são in-scope
		(P2P, SSC, logística como atividade fim, ITC, TCM, INS, IDC) e
		posiciona a Mesh como 'infraestrutura financeira' quando a
		definição correta é 'sistema operacional do ciclo de compromissos
		econômicos'. Erro de ontologia raiz: tudo que deriva deste
		artefato herda o viés de escopo. Sem esta correção, expansão de
		subdomínios e reconstrução do context map operam sobre premissa
		estratégica incorreta.
		"""
}
