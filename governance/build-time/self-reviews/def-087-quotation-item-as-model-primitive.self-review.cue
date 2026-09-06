package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def087QuotationItemAsModelPrimitive: build_time.#SelfReviewReport & {
	reportId: "srr-def-087-quotation-item-as-model-primitive"

	artifactPath:       "architecture/deferred-decisions/def-087-quotation-item-as-model-primitive.cue"
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
			1 fail corrigido: o território foi verificado contra o disco antes
			da proposta — vo-rfq-scope confirmado como escopo único (singular)
			e unitPrice no nível da proposta em contexts/ssc/domain-model.cue
			(uq-03: refs resolvem por leitura, não por memória do comando).
			Estatuto 'frente ativa' redigido como o founder mandou: território
			sendo resolvido, não pendência parada.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Warn tq-def-03 (manual-only) mantido e declarado;
			calibração medium/cross-cutting ratificada nominalmente pelo
			founder na aprovação do passe. Trigger conforma #TriggerStrict no
			branch open (manual-review, reason ≥40 runes); cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a condição real de revisita (frente §0 + L1 devolver a forma do item) é trabalho vivo fora deste repo, não-machine-evaluable pelo runner."
			rationale:   "Warn aceito com precedente ratificado (def-079, mesma classe: sequenciamento do founder sem predicado livre de falso-positivo); articulado em triggerCalibrationRationale."
		}]
	}

	summary: """
		def-087 registra o território da frente ativa §0 + L1 — item de
		cotação como primitiva (matriz item × fornecedor) — com veredito do
		founder (modelo incompleto, tela certa) e fundamentação econômica
		citada. Autorado no passe de morada com renumeração G2 confirmada
		(085→087) e calibrações ratificadas nominalmente.
		"""
}
