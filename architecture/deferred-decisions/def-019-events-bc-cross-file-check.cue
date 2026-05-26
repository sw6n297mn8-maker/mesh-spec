package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def019: artifact_schemas.#DeferredDecision & {
	id:    "def-019"
	title: "Check cross-file events↔BC (events referenciados no context-map existem nos BCs)"
	date:  "2026-05-26"

	description: """
		Autorar um structural-check cross-file-id-exists que verifique que todo
		event referenciado em context-map.relationships[].events[] existe definido
		em algum BC (domain-model.events[].name). O kind cross-file-id-exists já
		existe (adr-102); o check é expressável — falta o pré-requisito de domínio
		(vocabulário canônico de events), abaixo.
		"""

	deferralRationale: """
		DIAGNÓSTICO AFIADO (revisado após adr-103, investigação posterior): o
		bloqueio NÃO é "events não materializados" — eles ESTÃO materializados em
		domain-model.events[] (com code evt-kebab + name PascalCase). O bloqueio
		real é VOCABULÁRIO DE EVENTS INCONSISTENTE entre artefatos:
		- o context-map referencia em PascalCase (e.g., DeliveryVerified,
		  IdentityVerificationCompleted, NetworkParticipantOnboarded);
		- os domain-models misturam convenções — uns PascalCase (idc:
		  IdentityVerified), outros prosa-com-espaços (dlv: "Delivery Verified";
		  rew: "Risk Alert Raised") — e os nomes nem batem semanticamente
		  (IdentityVerificationCompleted vs IdentityVerified; NetworkParticipant
		  Onboarded vs ParticipantRegistered).
		Mesmo escopando a relationships entre BCs construídos (built↔built), 7 de 16
		events referenciados não casam — por DIVERGÊNCIA DE NOME, não por ausência.
		Gatear agora produziria ruído (falha por nome-não-bate), não sinal de drift
		acionável. Custo evitado: gate ruidoso que mascara o sinal real. Custo de
		continuar deferindo: um event referenciado genuinamente fictício passa batido
		— mitigado porque o context-map é singleton revisado e events ainda são
		roadmap, não contrato ativo consumido por terceiros.
		"""

	triggerCalibrationRationale: """
		Trigger manual-review (não file-exists/adjacent-need) porque o pré-requisito
		é uma DECISÃO DE DOMÍNIO, não o aparecimento de um arquivo: canonizar o
		vocabulário de events (nome canônico por event + convenção única + reconciliar
		context-map ↔ domain-models). Nenhum kind de trigger machine-evaluable expressa
		"vocabulário foi canonizado". O founder revisita quando a canonização for feita
		— aí o check cross-file-id-exists (referencePath context-map events,
		targetGlob contexts/*/domain-model.cue, targetIdPath events[].name) vira
		born-green trivial. Usar manual-review aqui é articulado, não preguiça.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-103-filesystem-declared-coverage-kind.cue",
		"architecture/adrs/adr-102-cross-file-id-exists-kind.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			Event referenciado genuinamente fictício/typo no context-map passa sem
			gate enquanto o vocabulário não é canonizado (o ruído de nome-não-bate
			esconderia o sinal). Custo baixo: events são roadmap, não contrato ativo;
			context-map é singleton revisado manualmente. Não-cumulativo no curto prazo.
			O achado em si (vocabulário de events inconsistente) é drift real do audit
			— endereçável por canonização de domínio, registrado aqui para revisita.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Pré-requisito é canonização do vocabulário de events (decisão de domínio: nome canônico + convenção única + reconciliar context-map↔domain-models), não machine-evaluable. Founder revisita ao fazer a canonização — então autora o check cross-file-id-exists contra domain-model.events[].name."
	}]

	status:     "resolved"
	resolvedBy: "architecture/adrs/adr-105-scoped-cross-file-id-exists-kind.cue"
}
