package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do def-038 — re-deferimento pós-triagem (adr-162): trigger file-exists esgotado
// substituído por manual-review (evento real no runtime/infra) + temporal 180d backstop.
// Revisado em subagente ISOLADO (batch das 9 re-adiações). 1 round, stable, 0 fail.

def038: build_time.#SelfReviewReport & {
	reportId: "srr-def-038-compute-platform-deploy-topology"

	artifactPath:       "architecture/deferred-decisions/def-038-compute-platform-deploy-topology.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-28"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-review isolated-subagent (batch das 9 re-adiações, triagem adr-162) do def-038 após
			re-deferimento. O trigger original adjacent-need file-exists em adr-141 (proxy-prematuro)
			foi substituído por manual-review + temporal 180d. Verificado: status open; triggers ==
			[manual-review, temporal(180)]; manual-review.reason >=40 runes nomeando o evento real
			(1º workload runtime a precisar de deploy persistente fora de in-memory — compute +
			topologia física), evento de infra/runtime no mesh-runtime sem sensor honesto no runner de
			mesh-spec; tq-def-03 satisfeito (temporal). date refrescada para 2026-06-28 (idade 0 — não
			re-dispara) com a data ORIGINAL (2026-06-03) preservada no triggerCalibrationRationale.
			deferralRationale/description/costOfDeferral inalterados e íntegros (severity medium mantida).
			tq-def-01/02/04 PASS; anti-catch-all OK. cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-038 RE-ADIADO na triagem do backlog disparado (adr-162): o trigger file-exists esgotado
		(proxy-prematuro em adr-141) deu lugar a manual-review (1º workload com deploy persistente fora
		de in-memory — evento de infra/runtime sem sensor honesto no mesh-spec) + temporal 180d
		backstop; status segue open; date refrescada com proveniência preservada. Re-review isolado
		(batch): 0 fail / 0 warn, stable em 1 round; cue vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: a re-adiação é troca de calibração de gatilho de escopo estreito e uniforme entre os 9
		defs, revisada por subagente ISOLADO em batch (viés de auto-ratificação reduzido) com PASS
		direto. O eixo de risco — gatilho desonesto — foi verificado ausente: o manual-review nomeia o
		evento real de runtime (deploy persistente do 1º workload) e o temporal 180d é o backstop
		gateável (adr-162). Shape, reason>=40, temporal presente e proveniência da data verificados;
		sem delta a re-rodar.
		"""
}
