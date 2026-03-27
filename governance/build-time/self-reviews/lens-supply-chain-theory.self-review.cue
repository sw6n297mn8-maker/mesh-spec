package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensSupplyChainTheory: build_time.#SelfReviewReport & {
	reportId: "srr-lens-supply-chain-theory"

	artifactPath:       "architecture/lenses/lens-supply-chain-theory.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou artefato parcial (trigger + concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes. Demais critérios pass sobre conteúdo presente. tq-ln-01 pass (15 condições testáveis, 7 excludeWhen)."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 avalia artefato completo: reasoningProtocol (15 steps com routing operacional, elegibilidade, tipo, Kraljic, formalidade, gap informacional, transmissão, bullwhip, multi-tier, payment gap, capacidade, SCF loop, sazonalidade, dilution e coordenação), meshExamples (3 cenários: bullwhip de concreto, progress billing de serviço elétrico, falha multi-tier de argamassa), principleIds (6 refs: ax-05, ax-06, ax-07, dp-02, dp-05, dp-09), relatedLenses (10 relações), limitations (10 limitações), rationale. uq-01 pass: rationale explicam por que (e.g., 'Sem routing, a lente vira pesada demais para uso operacional'). uq-02 pass: fortemente ancorado em construção civil — concreto, boletim, medição, canteiro, retenção, argamassa, cimento, aço, NF. uq-03 pass: dependsOn internos consistentes, principleIds conformam com PrincipleRef regex. uq-04 pass. uq-05 pass: 10 limitações com alternativas. uq-06 pass: terminologia consistente (material/serviço, payment gap, dilution, bullwhip, Kraljic, tier). uq-07 pass. uq-08 pendente cue vet. tq-ln-01 pass. tq-ln-02 pass: 15 reasoning steps com perguntas específicas de supply chain — routing por semáforo, elegibilidade operacional, classe de material/serviço, Kraljic dinâmico, regime de formalidade, gap informacional, transmissão causal, bullwhip relativo, propagação multi-tier, payment gap real, capacidade/saturação, SCF loop diagnosis, sazonalidade vs deterioração, dilution calibrada, coordenação como valor autônomo. tq-ln-03 pass: 3 exemplos concretos com materiais e serviços reais da construção civil. tq-ln-04 pass: 10 limitações reais com alternativas operacionais."
	}]

	findings: {}

	summary: """
		Lente de supply chain theory completa com 15 conceitos, 15 reasoning
		steps, 3 exemplos Mesh, 6 principleIds, 10 relatedLenses e 10 limitações.
		Round 1 identificou fail por campos ausentes (artefato parcial). Round 2
		avalia artefato completo — todos os critérios universais e type-specific
		passam. uq-08 pendente validação cue vet.
		"""
}
