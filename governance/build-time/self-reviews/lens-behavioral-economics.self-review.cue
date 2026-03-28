package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensBehavioralEconomics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-behavioral-economics"

	artifactPath:       "architecture/lenses/lens-behavioral-economics.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: "Lente completa com 17 conceitos, 14 reasoning steps, 3 meshExamples, 5 principleIds, 6 relatedLenses e 6 limitations. Round 1 identificou zero fail e 1 warn (uq-03: 3 de 6 relatedLenses são forward references). Todos os campos obrigatórios do schema presentes. crossDependsOn referencia cr-cure-roll-rate, cr-operational-transmission e cr-expected-loss que existem em lens-credit-risk. Conteúdo fornecido integralmente pelo founder em 3 entregas parciais."

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 1 avaliou lente completa (trigger + 17 concepts + 14 reasoning steps + 3 examples + 5 principleIds + 6 relatedLenses + 6 limitations). uq-01 pass: rationales explicam WHY. uq-02 pass: meshManifestation ancorado em construção civil, fornecedores pequenos, DMU, CFO, procurement, ERP, banco, canteiro, IA, score, antecipação. uq-03 warn: principleIds todos existem; crossDependsOn cr-cure-roll-rate, cr-operational-transmission e cr-expected-loss existem em lens-credit-risk; 3 de 6 relatedLenses (lens-platform-dynamics, lens-financial-intermediation, lens-theory-of-firm) são forward references. uq-04 pass. uq-05 pass: 6 limitações com alternativas. uq-06 pass. uq-07 pass. uq-08 pass. tq-ln-01 pass: 10 condições testáveis, 5 excludeWhen. tq-ln-02 pass: 14 reasoning steps com perguntas específicas por viés e por audiência. tq-ln-03 pass: 3 exemplos concretos (onboarding, DMU institucional, comunicação de crise). tq-ln-04 pass: 6 limitações reais incluindo decay de nudges e fronteira ética."
	}]

	findings: {
		warn: [{
			criterion: "uq-03"
			severity:  "warn"
			message:   "3 de 6 relatedLenses (lens-platform-dynamics, lens-financial-intermediation, lens-theory-of-firm) são forward references — arquivos não existem ainda no repo. Padrão consistente com outras lenses."
		}]
	}

	summary: """
		Lente behavioral-economics completa com 17 conceitos (16 theoretical
		+ 1 operational semi-annual), trigger (10 condições, 36 keywords, 5
		excludeWhen), 14 reasoning steps, 3 meshExamples (supplier onboarding
		friction, buyer institutional adoption, crisis communication), 5
		principleIds verificados, 6 relatedLenses e 6 limitations. Stable em
		1 round. Warn (uq-03) por 3 forward references em relatedLenses.
		"""
}
