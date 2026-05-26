package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def019: artifact_schemas.#DeferredDecision & {
	id:    "def-019"
	title: "Check cross-file events↔BC (events referenciados no context-map existem nos BCs)"
	date:  "2026-05-26"

	description: """
		Autorar um structural-check cross-file-id-exists que verifique que todo
		event referenciado em context-map.relationships[].events[] existe definido
		em algum BC. O kind cross-file-id-exists já existe (adr-102); falta o check
		específico para events.
		"""

	deferralRationale: """
		Custo evitado por NÃO autorar agora: gate cheio de falso-positivo. A
		investigação (adr-103) mostrou que os BCs ainda não materializaram events
		como artefato estruturado — nenhum tem events/, commands/ ou schemas/; só
		canvas/domain-model/glossary. Os 44 events referenciados nas relationships
		são forward-declarations da arquitetura-alvo (e.g., BankSettlementConfirmed
		não aparece definido em lugar nenhum). Não há fonte canônica de ids de event
		para montar o namespace; gatear agora misturaria gap real com contrato
		não-materializado, punindo a própria incompletude planejada do spec.
		Custo de continuar deferindo: um event referenciado com typo/fictício passa
		batido até os events materializarem — mitigado parcialmente porque o
		context-map é singleton revisado e os events ainda são roadmap, não contrato
		ativo.
		"""

	triggerCalibrationRationale: """
		Trigger manual-review (não file-exists/adjacent-need) porque não há um path
		único machine-evaluable a observar: events materializariam POR BC (múltiplos
		paths) e ainda não há convenção canônica de onde o id de event vive
		(events/*.cue? bloco em domain-model? shared-schemas?). Um trigger file-exists
		sobre um path representativo seria frágil e enganoso. O founder revisita quando
		a materialização de events virar milestone — aí define a fonte canônica de ids
		e este check (cross-file-id-exists com targetGlob/targetIdPath apontando para
		ela) vira born-verificável. Usar manual-review aqui é articulado, não preguiça.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-103-filesystem-declared-coverage-kind.cue",
		"architecture/adrs/adr-102-cross-file-id-exists-kind.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			Event referenciado fictício/typo no context-map passa sem gate até os
			events materializarem. Custo baixo enquanto events são roadmap (não
			contrato ativo consumido por terceiros) e o context-map é singleton
			revisado manualmente. Não-cumulativo no curto prazo.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Sem path único machine-evaluable: events materializam por BC e não há convenção canônica de id de event ainda. Founder revisita quando a materialização de events for milestone e a fonte canônica de ids existir — então autora o check cross-file-id-exists."
	}]

	status: "open"
}
