package task_specs

taskSpecs: "WI-051": {
	version:               1
	title:                 "Criar artefatos de domínio para Insurance & Risk Transfer (INS)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — INS governa instrumentos de proteção e transferência de risco; consome de REW, CTR; publica cobertura para SCF",
	]
	outputs: [{
		artifact: "contexts/ins/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/ins/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/ins/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/ins/agents/ins-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/ins/agents/ins-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting INS. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — governa instrumentos de proteção e
		transferência de risco: seguro garantia, seguro de carga,
		performance bonds. INS intermedia — não subscreve. Consome
		precificação de REW e termos de CTR; publica estado de
		cobertura para SCF.

		Criticality high — boundary regulatório e obrigação acessória.
		Regime SUSEP/IRB impõe constraints de compliance securitário.
		Diferente de FCE/REW que controlam dinheiro, INS governa
		instrumentos de proteção cuja especificação incorreta gera
		exposição de cobertura.
		"""
}
