package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr036GlossarySchemaSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-036-glossary-schema"

	artifactPath:       "architecture/adrs/adr-036-glossary-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"

	generatedAt: "2026-04-02"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR-036 segue padrão estabelecido por ADR-035 (domain-model schema).
		Mesma classe de decisão (structural), mesmos principlesApplied,
		mesma estrutura de artefato. Nenhuma decisão arquiteturalmente
		nova — extensão do padrão de artifact schema para novo tipo.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente avaliou ADR-036 contra 8 critérios universais +
			critérios específicos de ADR. Zero findings: context explica
			necessidade do schema, decision enumera as decisões de design
			concretas (bilingual, cross-layer, rejected alternatives,
			13 criteria, lens aplicada), consequences documenta positivas
			e negativas, principlesApplied lista P0 e P1,
			affectedArtifacts inclui glossary.cue e quality-criteria.cue.
			"""
	}]

	findings: {}

	summary: """
		ADR-036 registra decisão de criar #Glossary schema. Decisão
		structural com reversibility high (zero instâncias commitadas).
		Segue padrão de ADR-035 (domain-model schema). Estabilizou
		em 1 round — extensão de padrão existente, sem decisão
		arquiteturalmente nova.
		"""
}
