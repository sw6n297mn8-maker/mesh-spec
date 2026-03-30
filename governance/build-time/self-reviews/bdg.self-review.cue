package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgSubdomain: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-bdg"

	artifactPath:       "strategic/subdomains/bdg.cue"
	artifactSchemaPath: "architecture/artifact-schemas/subdomain.cue"
	artifactType:       "subdomain"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-30T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 avaliou BDG contra critérios universais e type-specific.
			Finding: (1) fail — falta negativeBoundary para DRC (disputas
			sobre aprovação orçamentária). Demais critérios passam:
			supporting-subdomain sem refs obrigatórios, purpose justifica
			separação, definition no espaço de problema, boundaries
			concretas e atribuídas. Classificação supporting validada por
			red team (RT-2.2): budget control não é generic porque o gate
			é Mesh-aware e integrado ao commitment lifecycle.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			NegativeBoundary para DRC adicionado. Verificação de regressão
			confirmou estabilidade. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		BDG estável no round 2. Round 1 identificou 1 fail
		(negativeBoundary DRC ausente). Corrigido. Supporting-subdomain
		com 4 negativeBoundaries cobrindo CMT, FCE, REW e DRC.
		"""
}
