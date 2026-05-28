package task_specs

taskSpecs: "WI-130": {
	version:     1
	title:       "Derivar superfícies de interação do BC DLV (api.yaml + async-api.yaml + schemas de payload) a partir do domain-model"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/dlv/domain-model.cue — eventos, comandos, invariantes e aggregate do BC Delivery & Verification: fonte canônica dos contratos.",
		"contexts/dlv/canvas.cue — capabilities hasSyncSurface=true e hasAsyncSurface=true declaram que as superfícies devem existir (sc-cv-02/03).",
		"architecture/conventions/api-spec-convention.cue — convenção de api/async-api condicional a capability flags.",
		"architecture/shared-schemas/ — envelope CloudEvents, Money canônico e regras Ion que os payloads devem reusar (não duplicar).",
		"contexts/cmt/schemas/events.cue (WI-129) — DeliveryVerified alimenta INV/INV; manter coerência de envelope/versionamento entre BCs do slice.",
	]
	outputs: [{
		artifact: "contexts/dlv/schemas/events.cue"
		type:     "create"
	}, {
		artifact: "contexts/dlv/api.yaml"
		type:     "create"
	}, {
		artifact: "contexts/dlv/async-api.yaml"
		type:     "create"
	}]
	affects: [
		"contexts/dlv/canvas.cue",
	]
	rationale: """
		Mesmo padrão do WI-129, para o BC DLV (Delivery & Verification): o domain-model já
		está completo; falta a camada de superfície/contrato (schemas de payload +
		api.yaml + async-api.yaml), declarada pelas capabilities do canvas mas ausente
		(sc-cv-02/03).

		DLV é o nó que produz a evidência de execução verificada (DeliveryVerified) — o
		gatilho do flywheel evidência→recebível. Seu evento de saída é consumido por INV
		(WI-131), então o schema de payload deve fixar o contrato de envelope/versionamento
		que INV vai referenciar.

		Derivar, não modelar do zero. Criticality medium. Reversível. Segundo WI do slice.
		"""
}
