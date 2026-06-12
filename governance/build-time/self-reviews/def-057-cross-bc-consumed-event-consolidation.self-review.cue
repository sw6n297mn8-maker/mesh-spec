package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def057SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-def-057-cross-bc-consumed-event-consolidation"

	artifactPath:       "architecture/deferred-decisions/def-057-cross-bc-consumed-event-consolidation.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-06-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		DD pequeno seguindo a forma de def-055/def-056 (mesma classe:
		deferimento de mecanismo ate 2a instancia real, precedente
		def-022/def-025). Trade-off articulado (custo evitado vs custo de
		continuar), trigger machine-evaluable onde possivel (file-exists
		rew) + manual-review com razao explicita para o caso geral.
		Decisao do founder no pacote 2 do Caminho B (escolha beta).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Checagem contra o criterio anti-catch-all do CLAUDE.md: e
			deferimento consciente (trade-off articulado + condicao
			codificada de revisita), nao WI rotineiro nem tension-entry.
			Originating artifacts apontam o espelho (fce) e o canonico
			(inv). cue vet OK.
			"""
	}]

	findings: {}

	summary: """
		def-057 registra o deferimento do mecanismo de consolidacao de
		eventos consumidos cross-BC, originado pelo 1o espelho
		(InvoiceIssued no FCE, decisao beta do founder na fatia FCE do
		WI-140). Opcoes (a)-(d) enumeradas; decisao na 2a instancia.
		"""
}
