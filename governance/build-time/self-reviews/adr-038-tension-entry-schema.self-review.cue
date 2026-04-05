package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr038SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-038-tension-entry-schema"

	artifactPath:       "architecture/adrs/adr-038-tension-entry-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR registra decisão de criar #TensionEntry schema — decisão
		já extensivamente revisada pelo founder em 3 rounds de
		ataque/correção sobre o schema principal. ADR segue padrão
		estabelecido por adr-035/036/037. Contexto menciona alternativa
		(tensões em rationales individuais) com justificativa de rejeição.
		Metadata de risco (reversibility high, blastRadius cross-artifact)
		reflete artefato novo sem instâncias. affectedArtifacts aponta
		para paths reais criados neste commit.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação de adr-038 contra 8 critérios universais + 3
			critérios de ADR (tq-adr-01/02/03). tq-adr-01: contexto
			menciona alternativa (tensões dispersas em rationales)
			e justifica rejeição (invisíveis para agentes cross-context).
			tq-adr-02: reversibility high e blastRadius cross-artifact
			são consistentes — schema novo sem instâncias, mas afeta
			quality-criteria.cue (#ArtifactType expandido). tq-adr-03:
			3 paths em affectedArtifacts serão criados neste commit.
			uq-02: ancoragem Mesh via axiomas tensionáveis e agentes
			stateless. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		ADR para criação de #TensionEntry schema. Decisão structural
		com reversibility high (sem instâncias) e blastRadius
		cross-artifact (expande #ArtifactType). Estabilizou em 1
		round — contexto revisado extensivamente pelo founder durante
		design do schema. Alternativa documentada e rejeitada.
		"""
}
