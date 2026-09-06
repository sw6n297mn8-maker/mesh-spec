package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def093UnitOfMeasureCanonization: build_time.#SelfReviewReport & {
	reportId: "srr-def-093-unit-of-measure-canonization"

	artifactPath:       "architecture/deferred-decisions/def-093-unit-of-measure-canonization.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-06"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único porque o def nasce de decisão nominal do founder na
		aprovação do adr-198 ('def-093: sim, no mesmo commit'), com escopo
		estreito e molde direto nos irmãos do passe de morada: o review
		conferiu (a) tq-def-01: trade-off articulado (governança de
		taxonomia não se decide de passagem numa fatia de estrutura vs
		janela de comparação silenciosamente incomparável, mitigada pela
		prática); (b) o motivo de urgência do founder incorporado (unidades
		divergentes quebram a comparação por linha EM SILÊNCIO); (c)
		tq-def-02/#TriggerStrict no branch open (manual-review, reason ≥40
		runes); (d) tq-def-04: medium + cross-artifact coerentes (falha
		condicionada; ssc + p2p + def-091); (e) uq-03: originatingArtifact
		(adr-198) criado no mesmo commit, defersTo recíproco no ADR; (f)
		numeração confirmada pelo freshness gate (--assert def=093, G2 ok).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			1 warn consciente (tq-def-03): manual-review-only — o gatilho
			real é o primeiro conflito de unidade observado em uso ou a
			fatia do def-091 exigir comparabilidade; predicado de conteúdo
			sobre 'unit' dispararia em todo o modelo itemizado que o adr-198
			acabou de criar. Mesmo shape aceito nos irmãos def-087..092.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a condição real (conflito de unidade em uso; abertura da fatia def-091) é fato de uso/sequenciamento, não de disco."
			rationale:   "Warn aceito com precedente direto do passe de morada; articulado em triggerCalibrationRationale."
		}]
	}

	summary: """
		def-093 dá morada à fronteira do unit que o adr-198 criou (string
		declarada, não taxonomia) — decisão explícita do founder de não
		recriar a órfã que o passe de morada corrigiu: fronteira declarada
		em prosa de ADR sem def é o defeito, e este def nasce no mesmo
		commit da fronteira, com o defersTo recíproco.
		"""
}
