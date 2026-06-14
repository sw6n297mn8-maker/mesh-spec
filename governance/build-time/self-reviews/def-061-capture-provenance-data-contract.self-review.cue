package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def061SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-def-061-capture-provenance-data-contract"

	artifactPath:       "architecture/deferred-decisions/def-061-capture-provenance-data-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-14"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		DD criado junto com adr-150 (itens 4/7) e revisado como parte do bundle no
		isolated-subagent review do adr-150 (2 rounds, stable) -- higiene de
		categoria (proveniencia = dominio de evidencia, separada do vendor de
		cliente do def-060) e anchor file-contains especifico do DLV (evita
		falso-positivo do confidenceProvenance do REW) confirmados la. Este self-
		report registra a checagem anti-catch-all e a calibracao do trigger.
		Decisao do founder no arco de ratificacao do adr-150 (PR #142), F2.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Checagem anti-catch-all do CLAUDE.md: deferimento consciente (trade-off
			articulado: especular o shape do dado C2PA antes da linha de evidencia
			materializar vs costura declarada sem tipo; revisita quando o tipo
			aterrissar no dominio do DLV ou na ratificacao-irma do Evidence Store),
			nao WI nem tension-entry. Trigger nao-manual de verdade (adjacent-need
			file-contains no DLV) + manual-review backstop; sem temporal (sem
			watchpoint datado). originatingArtifacts aponta adr-150 + pm-dlv. cue vet OK.
			"""
	}]

	findings: {}

	summary: """
		def-061 registra o deferimento do contrato de dado de proveniencia de
		captura a linha de evidencia, originado pelo adr-150 (item 4): a costura
		captura-local -> custodia e ancorada, o tipo e deferido. trigger
		adjacent-need file-contains no DLV (grep-able dentro do mesh-spec) +
		manual-review backstop. Estavel em 1 round.
		"""
}
