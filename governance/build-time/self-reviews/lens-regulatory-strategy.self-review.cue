package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensRegulatoryStrategy: build_time.#SelfReviewReport & {
	reportId: "srr-lens-regulatory-strategy"

	artifactPath:       "architecture/lenses/lens-regulatory-strategy.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Lente regulatória com 10 conceitos, 5 reasoning steps, 2 exemplos e 2 limitações. Versão simplificada pelo founder. Validação contra #AnalyticalLens: estrutura conforme (min 4 reasoning steps, min 2 examples, min 2 limitations), concept IDs únicos, dependsOn resolvem internamente. uq-01 a uq-08 passam — rationales explicam WHY, conceitos ancorados em mecanismos Mesh (NF, duplicata, FIDC, servicer, cessão, registradora), referências cruzadas válidas (ax-01, ax-03, ax-05, dp-04, dp-05), zero placeholders. tq-ln-01 a tq-ln-04 passam — condições testáveis, reasoning protocol focado em enquadramento regulatório, exemplos concretos, limitações reais."
	}]

	findings: {}

	singleRoundRationale: "Conteúdo fornecido e simplificado pelo founder. Validação verificou conformidade com schema e critérios — todos passam. Mudança é editorial (simplificação de seções existentes), sem alteração de semântica dos conceitos."

	summary: """
		Lente de Estratégia Regulatória (lens-regulatory-strategy) com status
		active. 10 conceitos, 5 reasoning steps, 2 exemplos, 5 principleIds,
		4 relatedLenses, 2 limitações. Versão simplificada pelo founder —
		reasoning protocol, examples, principleIds e limitations reduzidos.
		Zero findings em 1 round.
		"""
}
