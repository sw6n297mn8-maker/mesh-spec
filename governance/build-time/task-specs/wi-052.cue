package task_specs

taskSpecs: "WI-052": {
	version:               1
	title:                 "Criar artefatos de domínio para International Trade & Customs (ITC)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — ITC governa comércio exterior: freight forwarding, desembaraço, documentação comex; consome de LOG e CTR; publica para ATO",
	]
	outputs: [{
		artifact: "contexts/itc/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/itc/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/itc/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/itc/agents/itc-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/itc/agents/itc-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting ITC. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — governa operações de comércio exterior:
		freight forwarding, desembaraço aduaneiro, documentação comex
		e compliance aduaneiro. Consome de LOG e CTR; publica para
		ATO (obrigações fiscais aduaneiras).

		Criticality high — boundary regulatório e obrigação acessória.
		Siscomex, câmbio e legislação aduaneira impõem constraints
		de compliance. Diferente de FCE/REW que controlam dinheiro,
		ITC materializa obrigações aduaneiras cuja especificação
		incorreta gera bloqueio de importação/exportação.
		"""
}
