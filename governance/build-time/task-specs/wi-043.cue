package task_specs

taskSpecs: "WI-043": {
	version:               1
	title:                 "Criar artefatos de domínio para Financial Commitment Execution (FCE)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — FCE executa liquidação condicionada a gates de REW e fatura de INV, com settlement via BKR e disponibilidade de TCM",
		"contexts/cmt/domain-model.cue — CMT publica compromissos que FCE liquida; entender interface upstream",
	]
	outputs: [{
		artifact: "contexts/fce/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/fce/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/fce/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/fce/agents/fce-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/fce/agents/fce-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC core FCE. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Core domain — executa liquidação financeira condicionada a
		gates de risco (REW) e fatura válida (INV), com disponibilidade
		informada por TCM e settlement físico via BKR. Publica sinais
		de pagamento para REW, ATO e TCM. Ponto de convergência
		financeira: onde decisões de compromisso se tornam movimentos
		de dinheiro.

		Criticality high — controla decisão e movimento de dinheiro.
		Liquidação financeira regulada por Bacen/SCD. Especificação
		incorreta de gates ou condições de settlement pode gerar
		pagamento indevido ou bloqueio de operação legítima.
		"""
}
