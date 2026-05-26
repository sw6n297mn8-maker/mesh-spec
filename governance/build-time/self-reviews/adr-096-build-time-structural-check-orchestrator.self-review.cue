package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr096BuildTimeStructuralCheckOrchestrator: build_time.#SelfReviewReport & {
	reportId: "srr-adr-096-build-time-structural-check-orchestrator"

	artifactPath:       "architecture/adrs/adr-096-build-time-structural-check-orchestrator.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review mínimo (per direção do founder) sobre adr-096, backfill de
			ADR para o Build-Time Structural Check Orchestrator já mergeado
			(efbcced + wiring d081b28). Três confirmações:

			(a) Conformância #ADR (adr.cue): id ^adr-[0-9]{3}$ ok; status "accepted"
			(união não-superseded, supersededBy ausente — ok); decisionClass
			"structural" coerente com decision/consequences (mecanismo de
			governança/CI, não redefinição de princípio); reversibility "high" +
			blastRadius "repo-wide" consistentes (warn é aditivo/removível; avalia
			repo inteiro). tq-adr-01 (alternativa "execução pelo agente" rejeitada),
			tq-adr-02 (metadata reflete a decisão), tq-adr-03/04 (≥1 bloco de
			rastreabilidade non-empty) satisfeitos.

			(b) Coerência plannedOutputs/affectedArtifacts: ambos os outputs diretos
			da ativação em plannedOutputs (runner novo + wiring validate.yml);
			affectedArtifacts vazio — nenhum artefato normativo pré-existente é
			meramente afetado. Paths verificados como reais:
			scripts/ci/structural-check-runner.py e .github/workflows/validate.yml
			existem no repo. tq-adr-04 satisfeito via plannedOutputs.

			(c) Distinção runner ≠ generator (adr-090): confirmado por leitura — o
			adr-090 entrega o GERADOR (generate-structure-index.sh, deriva o mapa)
			e não menciona o avaliador; adr-096 entrega o ORCHESTRATOR
			(structural-check-runner.py, executa as regras #StructuralCheck).
			Responsabilidades distintas e complementares; sem sobreposição de
			plannedOutputs entre os dois ADRs.
			"""
	}]

	findings: {}

	summary: """
		adr-096 conforma a #ADR e registra retroativamente a decisão (de fato já
		vigente) de ativar o Build-Time Structural Check Orchestrator em
		build-time. Sem findings fail/warn. plannedOutputs captura runner + wiring
		como outputs diretos da ativação; affectedArtifacts vazio. Distinção
		runner≠generator do adr-090 verificada por leitura dos dois ADRs.
		"""

	singleRoundRationale: """
		Uma rodada basta: é backfill de ADR para artefato (runner) já implementado,
		mergeado e em operação no CI — a decisão não está em aberto, o review apenas
		confirma conformância de schema, coerência de rastreabilidade e ausência de
		sobreposição com o adr-090. Sem espaço de decisão novo a red-team.
		"""
}
