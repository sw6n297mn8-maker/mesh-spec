package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def023: artifact_schemas.#DeferredDecision & {
	id:     "def-023"
	title:  "Transport bindings nos async-api.yaml dos BCs, deferidos até existir ADR de transport"
	date:   "2026-05-28"
	status: "open"

	description: """
		AsyncAPI 2.6.0 permite declarar bindings (channelBindings, operationBindings,
		messageBindings) por transport (kafka/amqp/mqtt/outro). Sem ADR de stack que
		decida o transport da mesh, os async-api.yaml dos BCs do slice (CMT, DLV, INV)
		são autorados SEM bindings nem servers. A omissão é registrada como deferimento
		consciente (não tension-entry, porque é decisão de adiar com critério de
		revisita, não força de design concorrente).
		"""

	deferralRationale: """
		MOTIVO: o transport é decisão arquitetural de stack que ainda não foi tomada
		— não há ADR de stack/transport no repo. Per tq-async-04 do PG asyncapi-spec,
		bindings inventados sem ADR falham; declarar binding agora fixaria contrato
		escondido com um broker sem decisão registrada, criando dívida invisível
		cross-BC.
		RISCO de gatear agora: escolha aleatória de transport contamina os
		async-api.yaml de TODOS os BCs do slice; refactor cross-BC quando o ADR de
		stack chegar. Custo de deferir: async-api.yaml não declara nível-de-protocolo
		hoje — consumidor descobre transporte por documentação fora do arquivo até o
		ADR existir.
		"""

	triggerCalibrationRationale: """
		Trigger MANUAL-REVIEW por limitação técnica do schema #Trigger: as 6 kinds
		(recurrence threshold>=2, adjacent-need com path específico, volume-threshold
		por artifactType, temporal, file-content-occurrence-count com path específico,
		manual-review) não expressam cleanly 'qualquer ADR futuro de número
		desconhecido menciona decisão de transport'. recurrence exige >=2 ocorrências
		(perde o primeiro ADR); adjacent-need e file-content-occurrence-count exigem
		path fixo (especular adr-NNN é dead trigger se nome divergir).
		Aceito o warn de tq-def-03 (preferência por trigger não-manual) deliberadamente
		— é limitação técnica, não preguiça. Founder revisita os async-api.yaml e
		preenche bindings quando ADR de stack/transport for mergeado.
		"""

	originatingArtifacts: [
		"architecture/production-guides/asyncapi-spec.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			Async-api.yaml dos BCs do slice (CMT, DLV, INV) ficam sem bindings nem
			servers até ADR de transport. Cross-cutting porque afeta todos os BCs com
			hasAsyncSurface, mas baixo porque AsyncAPI sem bindings ainda é válido —
			declara contrato lógico de canais/messages, só não fixa transporte.
			Reversível mecanicamente quando ADR existir (adicionar bindings sem mudar
			shape do payload nem dos channels).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Trigger automático requer path conhecido ou pattern com >=2 ocorrências; ADR de stack/transport tem número e momento estratégicos imprevisíveis, e a primeira ocorrência não é capturável pelas kinds do schema #Trigger. Founder revisita quando autorar ADR de stack — limitação técnica documentada, não preguiça."
	}]
}
