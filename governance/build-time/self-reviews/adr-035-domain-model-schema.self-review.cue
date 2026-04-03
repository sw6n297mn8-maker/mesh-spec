package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr035SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-adr-035-domain-model-schema"

	artifactPath:       "architecture/adrs/adr-035-domain-model-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"

	generatedAt: "2026-04-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR-035 registra decisão de criar #DomainModel schema — artefato
		extensamente revisado pelo founder em múltiplos rounds de proposta
		e red-team antes do ADR ser redigido. Conteúdo do ADR reflete
		decisões já congeladas (union discriminada, #SourceContextRef,
		16 quality criteria, prefixed refs). Todos os critérios (8
		universais + 3 específicos de ADR) passam no primeiro round
		porque o contexto decisório já estava maduro.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliou ADR-035 contra 8 critérios universais (uq-01..08) e
			3 critérios específicos de ADR (tq-adr-01/02/03). tq-adr-01
			(alternativas): context menciona alternativa considerada
			(domain model como texto livre/seção do canvas) com
			justificativa de rejeição. tq-adr-02 (metadata de risco):
			reversibility high é consistente (zero instâncias commitadas),
			blastRadius cross-artifact é consistente (quality criteria
			validam contra canvas, #ArtifactType expandido). tq-adr-03
			(paths reais): affectedArtifacts lista domain-model.cue
			(criado neste commit) e quality-criteria.cue (editado neste
			commit). uq-02 (Mesh-specific): ancora em P0, P1, P3, P10
			com referências concretas a Event Log, gates determinísticos
			e type-safety por CUE. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		ADR-035 documenta a decisão de criar #DomainModel artifact schema
		para DDD tactical design. Cobre behavior-first ordering, union
		discriminada em #DomainEvent, #SourceContextRef, 16 quality
		criteria e prefixed refs. Estável em 1/4 rounds — decisão
		madura após múltiplos rounds de revisão do schema pelo founder.
		"""
}
