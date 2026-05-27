package task_specs

taskSpecs: "WI-129": {
	version:     1
	title:       "Derivar superfícies de interação do BC CMT (api.yaml + async-api.yaml + schemas de payload) a partir do domain-model"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/cmt/domain-model.cue — 11 eventos, 8 comandos, 8 invariantes, aggregate agg-commitment com lifecycle: fonte canônica dos contratos.",
		"contexts/cmt/canvas.cue — capabilities hasSyncSurface=true e hasAsyncSurface=true declaram que as superfícies devem existir (sc-cv-02/03).",
		"architecture/conventions/api-spec-convention.cue — convenção de api/async-api condicional a capability flags.",
		"architecture/shared-schemas/ — envelope CloudEvents, Money canônico e regras Ion que os payloads devem reusar (não duplicar).",
	]
	outputs: [{
		artifact: "contexts/cmt/schemas/events.cue"
		type:     "create"
	}, {
		artifact: "contexts/cmt/api.yaml"
		type:     "create"
	}, {
		artifact: "contexts/cmt/async-api.yaml"
		type:     "create"
	}]
	affects: [
		"contexts/cmt/canvas.cue",
	]
	rationale: """
		A modelagem de domínio do CMT já está completa (eventos, comandos, invariantes,
		aggregate com state-machine no lifecycle, policies, projection). O que falta para
		buildabilidade é a camada de superfície/contrato: os schemas de payload concretos
		dos eventos (contexts/cmt/schemas/) e as specs de superfície sync/async (api.yaml,
		async-api.yaml) que o canvas declara via hasSyncSurface/hasAsyncSurface=true mas
		não existem (warns sc-cv-02 e sc-cv-03).

		Trabalho é DERIVAR, não modelar do zero: os schemas de payload materializam os
		fields dos eventos do domain-model (reusando o envelope CloudEvents e Money/Ion de
		architecture/shared-schemas/); api.yaml/async-api.yaml expõem comandos/queries
		(sync) e canais de eventos (async) referenciando esses payloads.

		Criticality medium (default tmpl-create-instance@v1). Reversível por remoção dos
		artefatos de superfície; não altera o domain-model fonte. Primeiro WI do slice
		CMT→DLV→INV (rota até código, ADR-115 contexto de fundo à parte).
		"""
}
