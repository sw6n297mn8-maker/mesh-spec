package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def058SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-def-058-evidenceport-signal-proof-reverification"

	artifactPath:       "architecture/deferred-decisions/def-058-evidenceport-signal-proof-reverification.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-06-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		DD pequeno seguindo a forma de def-057 (mesma fatia, mesma classe:
		deferimento de mecanismo ate o fluxo consumidor materializar).
		Trade-off articulado (contrato fabricado + type mismatch contra
		rtd-012 evitados vs re-verificacao runtime-deferred ja canonizada
		pelo domain-model), trigger manual-review com razao explicita de
		por que automacao nao e viavel (gatilho e padrao de conteudo em
		arquivo existente, nao path novo). Decisao do founder na Etapa 2
		da fatia REW (PR #139).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Checagem contra o criterio anti-catch-all do CLAUDE.md: e
			deferimento consciente (trade-off articulado + condicao de
			revisita declarada), nao WI rotineiro nem tension-entry.
			manual-review unico justificado (nao-default): file-exists
			nao discrimina conteudo de arquivo que ja existe.
			Originating artifacts apontam pm-rew (decisao) e domain-model
			(canonizacao da re-verificacao como runtime concern). cue vet OK.
			"""
	}]

	findings: {}

	summary: """
		def-058 registra o deferimento da forma de re-verificacao
		semantica de integrity proofs de signals upstream no REW,
		originado pela decisao do pm-rew de nao consumir EvidencePort na
		fatia do caminho da elegibilidade (criterio 'integridade !=
		veracidade'; idempotency split cobre a integridade da ingestao).
		Opcoes (a)-(d) enumeradas; decisao quando a fatia de
		alerts/excecoes materializar o fluxo consumidor.
		"""
}
