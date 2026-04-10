package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensCommonsCollectiveAction: build_time.#SelfReviewReport & {
	reportId: "srr-lens-commons-collective-action"

	artifactPath:       "architecture/lenses/lens-commons-collective-action.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 1 avaliou lente completa (trigger + 16 concepts + 13 reasoning steps + 3 examples + 6 principleIds + 7 relatedLenses + 6 limitations). uq-01 pass: rationales explicam WHY. uq-02 pass: meshManifestation ancorado em FIDC, scoring, anchor tenants, Ostrom, construção civil, AUROC, HHI. uq-03 warn: principleIds todos existem; 5 de 9 crossDependsOn e 6 de 7 relatedLenses referenciam lenses planejadas ainda não criadas (padrão comum no repo). uq-04 pass: sem contradição com design-principles. uq-05 pass: 6 limitações declaradas com alternativas. uq-06 pass: terminologia consistente. uq-07 pass: zero placeholders. uq-08 pass: todos os campos obrigatórios do #AnalyticalLens presentes. tq-ln-01 pass: 11 condições testáveis, 5 excludeWhen. tq-ln-02 pass: 13 reasoning steps com perguntas específicas e appliesWhen condicionais. tq-ln-03 pass: 3 exemplos com cenário, análise e recomendação concretos. tq-ln-04 pass: 6 limitações reais com alternativas."
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 2 (adr-043 Fase 1 backfill): adicionado campo verticalApplicability ao lens. Classificação: vertical-adaptable, primaryVertical=construction, validatedVerticals omitido. Rationale dialogicamente refinado com founder distinguindo dependência estrutural (presente — toda a instanciação operacional bootstrapada em construção) de mera ausência de validação cross-vertical. tq-ln-05 (novo critério warn em lens.cue) pass: campo presente, mode válido para lens com instanciação setorial, rationale explícito sobre o que é universal (núcleo Ostrom/CPR) e o que é setorial (meshManifestation, meshImplication, meshExamples). uq-03 warn pré-existente mantido (forward references a lenses planejadas — não relacionado a este round). Demais critérios universais e type-specific permanecem pass."
	}]

	findings: {
		warn: [{
			criterionId: "uq-03"
			severity:  "warn"
			message:   "5 de 9 crossDependsOn (lens-financial-intermediation, lens-behavioral-economics, lens-information-economics, lens-credit-risk) e 6 de 7 relatedLenses referenciam lenses que ainda não existem no repo. Forward references a lenses planejadas — padrão consistente com outras lenses existentes no repo."
		}]
	}

	summary: """
		Lente commons-collective-action completa com 16 conceitos (15 theoretical
		+ 1 operational), trigger (11 condições, 31 keywords, 5 excludeWhen),
		13 reasoning steps com appliesWhen condicionais, 3 meshExamples (data
		quality degradation, funding pool concentration, Q1 churn from commons
		leveling), 6 principleIds verificados, 7 relatedLenses e 6 limitations.
		Stable em 1 round. Warn (uq-03) por forward references a lenses planejadas
		— padrão comum no repo. Demais critérios universais e type-specific pass.
		"""
}
