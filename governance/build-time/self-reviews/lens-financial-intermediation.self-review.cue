package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensFinancialIntermediation: build_time.#SelfReviewReport & {
	reportId: "srr-lens-financial-intermediation"

	artifactPath:       "architecture/lenses/lens-financial-intermediation.cue"
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
		summary:   "Round 1 avaliou lente parcial (trigger + 15 concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes — artefato parcial por decisão do founder. Demais critérios pass."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 avaliou lente completa. uq-01 pass: rationales explicam WHY em concepts, reasoningProtocol, meshExamples e limitations. uq-02 pass: meshExamples ancorados em FIDC, subordinação, covenant de concentração, fraude em recebível — cenários específicos da Mesh com decisões concretas de funding e intermediação. uq-03 pass: principleIds (ax-03, ax-04, ax-05, ax-07, dp-05, dp-08) existem; relatedLenses referenciam 6 lenses existentes (credit-risk, mechanism-design, regulatory-strategy, behavioral-economics, information-economics, theory-of-firm); dependsOn internos consistentes entre 15 concepts. uq-04 pass: sem contradição com design-principles. uq-05 pass: 4 limitations declaradas cobrindo calibração brasileira, separação de credit-risk, volatilidade de mercado e risco operacional. uq-06 pass: terminologia consistente — funding, liquidez, subordinação, FIDC, SCD, true sale, commingling, servicer, maturity mismatch, run risk, spread mínimo, covenant, elegibilidade. uq-07 pass: zero placeholders. uq-08 pass: todos os campos obrigatórios presentes — 13 reasoningProtocol steps (>=4), 3 meshExamples (>=2), 6 principleIds, 4 limitations (>=2), rationale. Correção aplicada: assumptions adicionado ao exemplo ex-public-fraud-incident (campo obrigatório no schema). tq-ln-01 pass: 13 condições testáveis, 5 excludeWhen. tq-ln-02 pass: 15 conceitos (>=5), roles válidos (13 framework + 2 method). cue vet pass."
	}]

	findings: {}

	summary: """
		Lente financial-intermediation completa com trigger (13 condições,
		41 keywords, 5 excludeWhen), 15 conceitos, 13 passos de reasoning
		protocol, 3 meshExamples (FIDC structuring, covenant pressure,
		public fraud incident), 6 principleIds, 6 relatedLenses, 4
		limitations e rationale. Estabilizada em round 2 após resolução
		do uq-08 fail do round 1. Correção de schema: assumptions
		adicionado ao ex-public-fraud-incident. cue vet pass.
		"""
}
