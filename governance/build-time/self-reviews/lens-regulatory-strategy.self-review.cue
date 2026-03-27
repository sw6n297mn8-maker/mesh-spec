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
		summary:   "Lente regulatória com 10 conceitos, 8 reasoning steps, 3 exemplos e 3 limitações. Validação contra #AnalyticalLens: estrutura conforme, concept IDs únicos, dependsOn resolvem internamente. uq-01 a uq-08 passam — rationales explicam WHY, conceitos ancorados em mecanismos Mesh (NF, duplicata, FIDC, servicer, cessão, registradora), referências cruzadas válidas, zero placeholders. tq-ln-01 a tq-ln-04 passam — condições testáveis, reasoning protocol específico para análise regulatória, exemplos concretos com cenários Mesh, limitações reais com alternativas."
	}]

	findings: {}

	singleRoundRationale: "Conteúdo fornecido integralmente pelo founder, sem decisões estruturais do agente. Validação verificou conformidade com schema, critérios universais e type-specific — todos passam sem findings. Complexidade do artefato é alta, mas o conteúdo já veio elaborado e completo."

	summary: """
		Lente de Estratégia Regulatória (lens-regulatory-strategy) com status
		active. Cobre enquadramento regulatório, capital legal, LGPD, FIDC,
		tributação, fronteiras de regime e risco correlacionado. 10 conceitos
		com dependências internas válidas, 8 reasoning steps específicos para
		análise regulatória, 3 exemplos Mesh concretos, 4 relações com lentes
		complementares. Zero findings em 1 round.
		"""
}
