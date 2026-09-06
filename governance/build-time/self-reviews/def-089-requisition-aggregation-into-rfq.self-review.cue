package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def089RequisitionAggregationIntoRfq: build_time.#SelfReviewReport & {
	reportId: "srr-def-089-requisition-aggregation-into-rfq"

	artifactPath:       "architecture/deferred-decisions/def-089-requisition-aggregation-into-rfq.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-06"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			1 fail corrigido: o 'vizinho inverso' foi verificado no disco
			antes de nomear a tensão — vetores adversariais de Fracionamento
			encontrados em contexts/cmt/canvas.cue (manipulationVector +
			oq-cmt-5) e contexts/bdg/agents/bdg-primary-agent.cue
			(act-detect-fragmentation-pattern), citados como
			originatingArtifacts em vez de prosa de memória (uq-03).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Warn tq-def-03 (manual-only) mantido; calibração
			medium/cross-cutting (p2p↔ssc + eixo adversarial cmt/bdg)
			ratificada nominalmente. #TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a fatia de agregação abrir depende de def-087/def-088 e do desenho adversarial junto a cmt/bdg — sequenciamento do founder, não fato de disco."
			rationale:   "Warn aceito com precedente (def-079); predicado de conteúdo dispararia nos vetores adversariais já escritos."
		}]
	}

	summary: """
		def-089 dá morada ao limite declarado da triagem (agrupar
		requisições numa cotação não tem lar no modelo) e NOMEIA a tensão
		com o único parente no repo — o Fracionamento, seu inverso
		adversarial: agregar é desejável economicamente, fracionar é vetor
		de ataque; modelagem futura de agregação nasce respondendo à
		detecção de fracionamento.
		"""
}
