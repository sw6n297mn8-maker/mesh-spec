package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def073: artifact_schemas.#DeferredDecision & {
	id:     "def-073"
	title:  "Materialização do grafo causal no envelope de evento do EventLogPort"
	date:   "2026-07-01"
	status: "open"

	description: """
		P3 manda "grafo causal obrigatório" no Event Log (causationId/correlationId/
		commandId por evento). adr-165 nomeou-o como a 2ª obrigação latente de P3 e
		NÃO a descarregou: o envelope de evento atual (mesh-runtime CanonEvent) é um
		marker vazio e o contrato do Port (adr-141) não carrega metadata causal. Fica
		deferida a materialização do grafo causal — adicionar os campos causais ao
		contrato de evento e a disciplina de o produtor populá-los.
		"""

	deferralRationale: """
		MOTIVO. O grafo causal é obrigação de ENVELOPE-locus (o produtor põe a
		causalidade no evento; o adapter só persiste fielmente — não pode fabricá-la),
		da mesma família do eventId/idempotência que adr-165 deferiu sob gate. NÃO é
		descarregável como obrigação-de-adapter (seria erro de categoria: o adapter
		não manufatura causalidade que o produtor não deu). Custo evitado: enriquecer
		o contrato de evento antes de haver fluxo causal real a registrar. PORÉM a
		irreversibilidade é real: causalidade é intrínseca-ao-append — o que não for
		capturado no momento do append NÃO se reconstrói do stream nu. Para o organismo
		sintético/descartável de AGORA a irreversibilidade ainda NÃO morde (evento sem
		causalidade se descarta e reinicia); ela morde quando DADO REAL RETIDO começar
		(Phase 1+). Custo de continuar deferindo além desse ponto: alto e irreversível
		(a janela de dado retido sem causalidade é permanente).
		"""

	triggerCalibrationRationale: """
		O gatilho é ancorado na IRREVERSIBILIDADE: revisitar ANTES da entrada de dado
		real retido (Phase 1+ / enriquecimento do envelope de evento com eventId +
		metadata causal), porque o não-capturado ali é permanente. O evento real vive
		no runtime (o momento em que o envelope é enriquecido / a produção começa),
		sem sensor honesto no mesh-spec. manual-review (founder revisita na entrada de
		dado retido) + temporal 180d de backstop. Não é "algum dia": a condição é o
		começo da retenção real.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-165-eventlogport-trajectory-postgres-vendor.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium porque enquanto o dado é sintético/descartável a irreversibilidade
			não morde (descarta e reinicia); vira alto/irreversível na entrada de dado
			real retido (Phase 1+). cross-artifact porque o envelope de evento é
			consumido por todos os BCs e cruza o EventLogPort.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Entrada de dado real retido (Phase 1+) / enriquecimento do envelope de evento com metadata causal — o ponto ANTES do qual a causalidade deve ser capturada, porque o não-capturado não se reconstrói. Evento vive no runtime; founder revisita na transição para retenção real."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
