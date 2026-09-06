package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def088RequisitionQuotationLinkAtItemLevel: build_time.#SelfReviewReport & {
	reportId: "srr-def-088-requisition-quotation-link-at-item-level"

	artifactPath:       "architecture/deferred-decisions/def-088-requisition-quotation-link-at-item-level.cue"
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
			1 fail corrigido: a formulação foi conferida contra o disco para
			NÃO reabrir a alternativa rejeitada — def-079 resolved/resolvedBy
			adr-177 verificados, e a rejeição de (i-b) lida no texto do
			adr-177 ('força 1:1 num modelo N:1'; ssc categoria-escopado). O
			def declara o terceiro nível (item) como não-considerado na
			deliberação original, sem editar def-079 nem adr-177. Confirmado
			que o schema #DeferredDecision NÃO tem campo de relação def↔def —
			relação declarada em prosa + originatingArtifacts, e a lacuna de
			schema reportada ao founder no passe.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Warn tq-def-03 (manual-only) mantido; calibração
			medium/cross-artifact herda a do def-079 (sucessor um nível
			abaixo), ratificada nominalmente. #TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a condição real de revisita é def-087 entregar a primitiva do item — sequenciamento do founder, não fato de disco."
			rationale:   "Warn aceito com precedente direto (def-079, cuja calibração anti-falso-positivo este def herda); articulado em triggerCalibrationRationale."
		}]
	}

	summary: """
		def-088, sucessor do def-079 no nível que a deliberação original não
		considerou: o elo requisição↔cotação por ITEM — o único nível que não
		contradiz o ssc categoria-escopado (a rejeição de (i-b) permanece
		válida e intocada). Depende de def-087. Lacuna de schema (sem campo
		de relação def↔def) reportada sem correção, per comando.
		"""
}
