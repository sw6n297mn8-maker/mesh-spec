package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def048: build_time.#SelfReviewReport & {
	reportId: "srr-def-048-cmt-modify-terms-downstream-notification"

	artifactPath:       "architecture/deferred-decisions/def-048-cmt-modify-terms-downstream-notification.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-048 (notificação downstream de modify_terms para consumidores de termos —
			SD2 deferida de adr-143). Avaliado contra universalCriteria + tq-def-01..04.
			tq-def-01 (trade-off concreto): custo evitado (amplificação cross-cutting de uma fatia
			intra-CMT — evento publicado novo + adaptação de BDG/INV) vs custo de continuar (janela
			conhecida onde consumidores operam sobre termos pré-modificação; modify_terms é caminho de
			exceção e o termsHash recomputado já garante consistência interna). Não é "fazer depois". Pass.
			tq-def-02: manual-review conforme #Trigger. Pass. tq-def-03 (≥1 non-manual OU manual-only
			justificado): manual-only JUSTIFICADO — a forma da notificação é decisão de design + frequência
			de modify_terms em produção, nenhuma machine-evaluable a partir de mesh-spec; reason ≥40 runes.
			Pass. tq-def-04 (coerência): low + cross-artifact — coerente (BDG/INV potencialmente afetados;
			não é combinação suspeita como low+repo-wide). Pass. uq-02 (Mesh): modify_terms, termsHash,
			BDG/INV snapshot, CommitmentTermsModified — específico. uq-08 (conforma #DeferredDecision): cue
			vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-048 defere a forma da notificação downstream de modify_terms (evento dedicado vs sync manual)
		a consumidores que fizeram snapshot de termos (BDG/INV) — decisão cross-BC + dependente da
		frequência de modify_terms em produção. Trigger manual-review justificado (não machine-evaluable).
		low/cross-artifact. Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com calibração travada pelo founder (low/cross-artifact, manual-review com reason
		articulando por que automação não é viável — decisão de design + frequência em produção);
		conformance a #DeferredDecision verificável por inspeção direta (MinRunes, shape do trigger, cue
		vet EXIT=0). Trade-off concreto articulado — sem ambiguidade que rounds adicionais resolveriam.
		"""
}
