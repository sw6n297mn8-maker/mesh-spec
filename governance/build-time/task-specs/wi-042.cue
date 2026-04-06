package task_specs

taskSpecs: "WI-042": {
	version:               1
	title:                 "Criar artefatos de domínio para Delivery & Verification (DLV)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — DLV consome evidência de LOG com integridade de IDC; publica verificação para INV, REW, NIM e DRC",
	]
	outputs: [{
		artifact: "contexts/dlv/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/dlv/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/dlv/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/dlv/agents/dlv-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/dlv/agents/dlv-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC core DLV. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Core domain — verifica execução de compromissos contra
		critérios acordados. Consome evidência operacional de LOG
		com integridade garantida por IDC; publica verificação para
		INV (faturamento), REW (risco), NIM (mecanismos) e DRC
		(disputas). Ponto de convergência entre evidência física
		e compromisso econômico.

		Criticality medium (default template) — não controla decisão
		sobre dinheiro nem boundary regulatório direto. Verificação
		é gate operacional, não financeiro.
		"""
}
