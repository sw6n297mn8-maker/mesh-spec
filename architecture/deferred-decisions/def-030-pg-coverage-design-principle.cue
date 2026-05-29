package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def030: artifact_schemas.#DeferredDecision & {
	id:     "def-030"
	title:  "Avaliar cobertura de production-guide para design-principle (whitelist sc-pg-01 + production-guides/design-principle.cue)"
	date:   "2026-05-29"
	status: "open"

	description: """
		O pre-flight de adr-125/P13 mostrou que o tipo design-principle não está
		na whitelist coveredSchemas do sc-pg-01 (cobertura universal de adr-053
		é enforced por adr-056 como whitelist opt-in deliberada, não
		auto-discovery). P0–P13 foram todos autorados sem
		production-guides/design-principle.cue; canvas também está fora da
		whitelist. Este deferimento cobre a decisão de SE vale adicionar
		design-principle à whitelist sc-pg-01 + criar o type-PG
		production-guides/design-principle.cue (perseguir cobertura universal) OU
		manter design-principle deliberadamente fora (raridade de novos
		princípios não justifica o type-PG).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: (1) o gate determinístico (sc-pg-01) NÃO exige o
		type-PG — design-principle está fora da whitelist por design, então não
		há quebra de CI nem débito retroativo; (2) novos design-principles são
		raros (P13 é o primeiro desde a schematização adr-090 follow-on), então
		um type-PG teria baixa frequência de uso — autorá-lo agora é trabalho
		especulativo sem necessidade recorrente; (3) a decisão de perseguir
		cobertura universal de PG é estratégica e pode emergir junto de outras
		adições à whitelist, não isoladamente. Custo evitado: autoria de type-PG
		de baixo uso. Custo de continuar: gap entre cobertura universal declarada
		(adr-053) e cobertura enforced (whitelist) permanece para
		design-principle — atualmente inócuo.
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review: perseguir cobertura universal de PG é
		decisão estratégica/interpretativa do founder, não machine-evaluable.

		Trigger secundário adjacent-need file-contains em
		architecture/structural-checks/production-guide.cue com pattern
		"design-principle": dispara exatamente quando design-principle for
		adicionado a coveredSchemas (i.e., quando alguém agir sobre este
		deferimento), sinalizando revisita/resolução. Não dispara agora —
		"design-principle" não aparece no arquivo do sc-pg-01.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-125-derivation-of-bounded-contexts.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Gap entre cobertura universal de PG declarada (adr-053) e enforced
			(whitelist sc-pg-01) para o tipo design-principle. severity low:
			autorar design-principles sem type-PG é o status quo (P0–P13) e não
			causa dano — convenção voluntária + self-review suprem. blastRadius
			local: afeta apenas o tipo design-principle e a whitelist do sc-pg-01.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Perseguir cobertura universal de PG para design-principle é decisão
			estratégica do founder (custo de autoria de type-PG de baixo uso vs
			completude de cobertura). Não machine-evaluable.
			"""
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "architecture/structural-checks/production-guide.cue"
			pattern: "design-principle"
		}
	}]
}
