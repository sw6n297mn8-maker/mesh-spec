package task_specs

taskSpecs: "WI-131": {
	version:     1
	title:       "Derivar superfícies de interação do BC INV (async-api.yaml + schemas de payload) a partir do domain-model"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/inv/domain-model.cue — eventos (InvoiceIssued, ReceivableMaterialized), comandos e invariantes do BC Invoicing: fonte canônica dos contratos.",
		"contexts/inv/canvas.cue — hasSyncSurface=false e hasAsyncSurface=true: só async-api.yaml é exigido (sc-cv-03); NÃO criar api.yaml.",
		"architecture/conventions/api-spec-convention.cue — convenção condicional a capability flags (justifica ausência de api.yaml aqui).",
		"architecture/shared-schemas/ — envelope CloudEvents, Money canônico e regras Ion que os payloads devem reusar.",
		"contexts/dlv/schemas/events.cue (WI-130) — DeliveryVerified é o input que dispara InvoiceIssued/ReceivableMaterialized; consumir o contrato fixado por DLV.",
	]
	outputs: [{
		artifact: "contexts/inv/schemas/events.cue"
		type:     "create"
	}, {
		artifact: "contexts/inv/async-api.yaml"
		type:     "create"
	}]
	affects: [
		"contexts/inv/canvas.cue",
	]
	rationale: """
		Mesmo padrão do WI-129/130, para o BC INV (Invoicing). Diferença relevante: o
		canvas do INV declara hasSyncSurface=false / hasAsyncSurface=true — logo o output
		é apenas async-api.yaml + schemas de payload; api.yaml NÃO deve ser criado (a
		convenção api-spec é condicional à capability, e criar api.yaml violaria a
		presença bicondicional do sc-cv-02).

		INV materializa o recebível (ReceivableMaterialized) a partir de DeliveryVerified
		(DLV) — é a ponta do flywheel que vira crédito antecipável. O schema de payload
		deve referenciar o contrato fixado em WI-130 para coerência cross-BC.

		Derivar, não modelar do zero. Criticality medium. Reversível. Terceiro WI do slice.
		"""
}
