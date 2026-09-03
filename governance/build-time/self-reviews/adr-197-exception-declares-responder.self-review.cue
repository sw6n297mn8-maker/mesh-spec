package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr197ExceptionDeclaresResponder: build_time.#SelfReviewReport & {
	reportId: "srr-adr-197-exception-declares-responder"

	artifactPath:       "architecture/adrs/adr-197-exception-declares-responder.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-03"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 2
		infoCount: 0
		summary:   "Dois fails corrigidos na passada: (a) a aparição do cancelamento constava na lista com a contagem original de cinco — a verificação em disco encontrou cancelledBy nos três comandos e a aparição saiu da lista, virando nota com a fronteira para a def-080 (tq-dsg-espírito: o disco manda, contagem 5→4); (b) recipient do #EscalationRoute citado sem o tipo real — adicionada a linha exata do schema (#NonEmptyString, agent-governance.cue) que prova o placeholder silencioso (tq-adr-03/uq-03)."
	}, {
		round:     2
		failCount: 0
		warnCount: 2
		infoCount: 0
		summary:   "Zero fails. Dois warns declarados e mantidos como transparência: (uq-05) contagem de envelopes dos demais BCs e nomes de campo (respondedBy/rota) ficam para a fatia de mecanização; a demonstração de fronteira com a def-080 (invocador-passado x respondedor-futuro) foi apresentada integral no chat e resumida no rationale."
	}]

	findings: {}

	summary: "adr-197 autorado após verificação aparição-a-aparição: 1 verificada plena (envelope do ssc roteando founder placeholder), 1 parcial (suspensão sem destino para a proposta órfã), 2 relatadas com origem externa citada, 1 removida da lista pela verificação (cancelledBy existe nos três agregados — recorte da def-080). Predicado (b-restrita) aprovado pelo founder; calibrações confirmadas nominalmente (structural/high/cross-cutting, P10/P12, N=3); status accepted por aprovação nominal."
}
