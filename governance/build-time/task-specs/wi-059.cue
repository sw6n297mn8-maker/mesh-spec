package task_specs

taskSpecs: "WI-059": {
	version:               1
	title:                 "Criar artefatos de domínio para Supply Chain Finance (SCF)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — SCF estrutura produtos financeiros sobre recebíveis; consome de INV, CMT, REW, CTR, INS; opera como SCD",
		"contexts/cmt/domain-model.cue — CMT governa compromissos sobre os quais SCF origina produtos financeiros",
	]
	outputs: [{
		artifact: "contexts/scf/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/scf/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/scf/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/scf/agents/scf-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/scf/agents/scf-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting SCF. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — estrutura e oferta de produtos financeiros
		sobre recebíveis operacionais: antecipação, reverse factoring,
		dynamic discounting, preparação de portfólios de securitização.
		Opera como SCD. Consome recebíveis de INV, compromissos de
		CMT, elegibilidade de REW, termos de CTR e cobertura de INS.

		Criticality high — controla decisão sobre dinheiro. Cessão
		de recebíveis, operação de FIDC e regras de SCD exigem
		precisão regulatória. Produto financeiro mal especificado
		gera risco de crédito e non-compliance com Bacen.
		"""
}
