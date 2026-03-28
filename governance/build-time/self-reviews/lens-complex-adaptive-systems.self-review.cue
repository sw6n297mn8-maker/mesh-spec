package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensComplexAdaptiveSystems: build_time.#SelfReviewReport & {
	reportId: "srr-lens-complex-adaptive-systems"

	artifactPath:       "architecture/lenses/lens-complex-adaptive-systems.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-28"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou artefato parcial (trigger + 13 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations ausentes. Demais critérios pass sobre conteúdo presente. tq-ln-01 pass (12 condições testáveis, 5 excludeWhen)."
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 2 avalia artefato completo: reasoningProtocol (12 steps cobrindo motivação, timescale, feedback loops, adaptação/Goodhart, delays, tipping points, path dependence, governança, fragilidade/resiliência/antifragilidade, leverage points, pre-mortem e decisão terminal), meshExamples (3 cenários: scoring Goodhart, convergência de crise, path dependence bootstrap), principleIds (6 refs: ax-03, ax-04, ax-05, dp-05, dp-07, dp-09), relatedLenses (7 relações), limitations (6 limitações), rationale. uq-01 pass: rationales explicam WHY. uq-02 pass: ancorado na Mesh — scoring, fornecedores, compradores, funding, FIDC, anchor, bootstrap, cohort, NPS, AUROC, churn Q1. uq-03 warn: 2 de 7 relatedLenses são forward references (lens-platform-dynamics, lens-financial-intermediation). uq-04 pass. uq-05 pass: 6 limitações com alternativas. uq-06 pass: terminologia consistente — loops, delays, tipping points, regime, leverage points, stocks canônicos, Goodhart, path dependence, edge of chaos. uq-07 pass. uq-08 pass: todos os campos obrigatórios presentes. tq-ln-01 pass. tq-ln-02 pass: 12 reasoning steps. tq-ln-03 pass: 3 exemplos concretos. tq-ln-04 pass: 6 limitações reais."
	}]

	findings: {
		warn: [{
			criterionId: "uq-03"
			severity:    "warn"
			message:     "2 de 7 relatedLenses (lens-platform-dynamics, lens-financial-intermediation) são forward references — arquivos não existem ainda no repo."
		}]
	}

	summary: """
		Lente complex-adaptive-systems completa com 13 conceitos, 12
		reasoning steps, 3 meshExamples (scoring Goodhart, convergência
		de crise, path dependence bootstrap), 6 principleIds, 7
		relatedLenses e 6 limitations. Round 1 fail por campos ausentes
		(artefato parcial). Round 2 stable com warn (uq-03: 2 forward
		references em relatedLenses).
		"""
}
