package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def090FitnessSignalsProvenanceVerification: build_time.#SelfReviewReport & {
	reportId: "srr-def-090-fitness-signals-provenance-verification"

	artifactPath:       "architecture/deferred-decisions/def-090-fitness-signals-provenance-verification.cue"
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
			1 fail corrigido: a âncora do act citada no comando do founder
			('act-verify-fitness-signal-completeness') não existe no disco —
			verificação encontrou act-evaluate-signal-sufficiency no
			agent-spec do ssc, com a semântica exata que o comando descrevia
			(completude estrutural, não procedência); o def cita o code real
			e a correção foi reportada ao founder na proposta (uq-03: o disco
			manda, não a citação). Decisão do founder e consequência medida
			(1 célula de 13, 0 na decidida) citadas com origem externa
			declarada (protótipo).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Warn tq-def-03 (manual-only) mantido; calibração
			medium/local ratificada nominalmente (medium+local não é combo
			suspeito de tq-def-04). #TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a condição real de revisita (sinal externo NIM/CTR populando os campos optional) é fato de runtime cross-BC, invisível ao disco deste repo."
			rationale:   "Warn aceito com precedente (def-086, mesma classe de condição fora do alcance do runner); articulado em triggerCalibrationRationale."
		}]
	}

	summary: """
		def-090 separa o que existe (completude estrutural via
		act-evaluate-signal-sufficiency) do que não existe (verificação de
		PROCEDÊNCIA do vo-fitness-signals) e registra a decisão do founder:
		dado não conferido não sustenta decisão que a Mesh endossa — com a
		consequência medida na superfície e o que a verificação destrava.
		Âncora corrigida contra o disco na autoria.
		"""
}
