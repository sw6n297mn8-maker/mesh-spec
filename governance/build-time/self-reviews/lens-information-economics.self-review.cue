package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensInformationEconomics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-information-economics"

	artifactPath:       "architecture/lenses/lens-information-economics.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: "Lente completa com 11 conceitos, 12 reasoning steps, 3 meshExamples, 6 principleIds, 6 relatedLenses e 5 limitations. Round 1 identificou zero fail e 1 warn (uq-03 forward references a lenses planejadas). Todos os campos obrigatórios do schema presentes. Conteúdo fornecido integralmente pelo founder em 3 entregas parciais — self-review validou consistência interna, especificidade Mesh, rationales e conformidade com schema."

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 1 avaliou lente completa (trigger + 11 concepts + 12 reasoning steps + 3 examples + 6 principleIds + 6 relatedLenses + 5 limitations). uq-01 pass: rationales explicam WHY. uq-02 pass: meshManifestation ancorado em construção civil, supply chain, fusão banco↔supply chain, NF eletrônica, registradora, ERP, AUROC, scoring. uq-03 warn: principleIds todos existem; md-screening e ct-verifiability-gap existem; cr-model-risk e be-bounded-rationality-real referenciam lenses planejadas (lens-credit-risk e lens-behavioral-economics não existem ainda); 4 de 6 relatedLenses são forward references. uq-04 pass: sem contradição com design-principles. uq-05 pass: 5 limitações declaradas com alternativas. uq-06 pass: terminologia consistente. uq-07 pass: zero placeholders. uq-08 pass: todos os campos obrigatórios presentes. tq-ln-01 pass: 12 condições testáveis, 5 excludeWhen. tq-ln-02 pass: 12 reasoning steps com perguntas específicas e appliesWhen condicionais. tq-ln-03 pass: 3 exemplos com cenário, análise e recomendação concretos da Mesh. tq-ln-04 pass: 5 limitações reais com alternativas."
	}]

	findings: {
		warn: [{
			criterionId: "uq-03"
			severity:  "warn"
			message:   "2 de 7 crossDependsOn (cr-model-risk em lens-credit-risk, be-bounded-rationality-real em lens-behavioral-economics) e 4 de 6 relatedLenses referenciam lenses que ainda não existem no repo. Forward references a lenses planejadas — padrão consistente com outras lenses existentes."
		}]
	}

	summary: """
		Lente information-economics completa com 11 conceitos (10 theoretical
		+ 1 operational), trigger (12 condições, 24 keywords, 5 excludeWhen),
		12 reasoning steps com appliesWhen condicionais, 3 meshExamples (signal
		selection para scoring, buyer data externality, score disclosure
		multidirectional), 6 principleIds verificados, 6 relatedLenses e 5
		limitations. Stable em 1 round. Warn (uq-03) por forward references
		a lenses planejadas — padrão comum no repo. Demais critérios universais
		e type-specific pass.
		"""
}
