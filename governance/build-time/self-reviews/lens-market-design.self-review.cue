package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensMarketDesign: build_time.#SelfReviewReport & {
	reportId: "srr-lens-market-design"

	artifactPath:       "architecture/lenses/lens-market-design.cue"
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
		summary:   "Round 1 avaliou artefato parcial (trigger + concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes. Demais critérios pass sobre conteúdo presente. tq-ln-01 pass (13 condições testáveis, 5 excludeWhen)."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 avalia artefato completo: reasoningProtocol (11 steps cobrindo participação racional, mercado interdependente, thickness, safety, congestion, pricing, OSP, timing/clearing, modos de falha, spillovers e sequenciamento), meshExamples (3 cenários: congestion de fim de mês, participation constraint binding, preocupação de investidor com papel dual), principleIds (6 refs: ax-05, ax-06, ax-07, dp-02, dp-05, dp-08), relatedLenses (8 relações), limitations (6 limitações), rationale. uq-01 pass: rationale explicam por que (e.g., 'Sem participação racional, o mercado falha na origem'). uq-02 pass: fortemente ancorado na Mesh — antecipação, funding, FIDC, tranches, fornecedores, compradores, outside options bancárias, fim de mês, Q1. uq-03 pass: dependsOn internos consistentes, principleIds conformam com PrincipleRef regex. uq-04 pass. uq-05 pass: 6 limitações com alternativas. uq-06 pass: terminologia consistente (thickness, congestion, clearing, matching, outside option, spread, safety, unraveling). uq-07 pass. uq-08 pendente cue vet. tq-ln-01 pass. tq-ln-02 pass: 11 reasoning steps específicos de market design — participação racional por segmento, mercado interdependente, thickness por lado e timing, safety como contorno, congestion vs thinning, pricing em três dimensões, OSP, timing/clearing, modos de falha, spillovers inter-mercados, sequenciamento fundacional. tq-ln-03 pass: 3 exemplos concretos com cenários reais da Mesh. tq-ln-04 pass: 6 limitações reais com alternativas operacionais."
	}]

	findings: {}

	summary: """
		Lente de market design completa com 14 conceitos, 11 reasoning steps,
		3 exemplos Mesh, 6 principleIds, 8 relatedLenses e 6 limitações. Round 1
		identificou fail por campos ausentes (artefato parcial). Round 2 avalia
		artefato completo — todos os critérios universais e type-specific passam.
		uq-08 pendente validação cue vet.
		"""
}
