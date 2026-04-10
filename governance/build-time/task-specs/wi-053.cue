package task_specs

taskSpecs: "WI-053": {
	version:               1
	title:                 "Criar artefatos de domínio para Invoicing (INV)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — INV consome DeliveryVerified de DLV; publica InvoiceIssued para FCE, SCF e ATO",
	]
	outputs: [{
		artifact: "contexts/inv/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/inv/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/inv/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/inv/agents/inv-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/inv/agents/inv-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting INV. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — emite faturas vinculadas a entrega
		verificada (DLV); publica InvoiceIssued consumido por FCE
		(liquidação), SCF (antecipação de recebíveis) e ATO
		(obrigações fiscais). Ponto de materialização de recebíveis
		na cadeia operacional.

		Criticality medium (default template) — regras de NF-e e
		regulação tributária serão invariantes no domain-model, mas
		INV não controla decisão sobre dinheiro nem boundary
		regulatório direto.
		"""
}
