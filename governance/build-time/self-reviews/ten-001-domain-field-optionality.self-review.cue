package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ten001SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-ten-001-domain-field-optionality"

	artifactPath:       "architecture/tension-log/ten-001-domain-field-optionality.cue"
	artifactSchemaPath: "architecture/artifact-schemas/tension-entry.cue"
	artifactType:       "tension-entry"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Primeira instância de #TensionEntry — schema acabou de ser criado
		e revisado pelo founder em 3 rounds de ataque/correção. Tensão
		foi extensivamente discutida durante design do CTR domain model
		(vo-lineage chainOrigin discriminator). Conteúdo dos campos
		description e resolution reproduz decisão já validada. Target
		e manifestsIn apontam para paths existentes. Status accepted
		com structuralResolutionPath preenchido.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação de ten-001 contra 8 critérios universais + 4
			critérios de tension-entry (tq-te-01/02/03/04). tq-te-01:
			tensionTarget aponta para architecture/artifact-schemas/
			domain-model.cue — path existente. tq-te-02: resolution
			descreve alternativa escolhida (VO único + discriminador),
			alternativa rejeitada (dois VOs distintos), e trade-off
			(optionalidade semântica, não estrutural). tq-te-03:
			manifestsIn aponta para contexts/ctr/domain-model.cue —
			path existente. tq-te-04: status accepted, critério não
			aplicável. uq-02: ancoragem Mesh via #DomainField,
			inv-lineage-integrity, vo-lineage chainOrigin. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Primeira instância de #TensionEntry: schema-limitation de
		#DomainField que não suporta optionalidade condicional,
		manifestada em vo-lineage do CTR domain model. Trade-off
		aceito: discriminador chainOrigin + nullability por convenção.
		Estabilizou em 1 round — tensão extensivamente discutida
		durante design do domain model.
		"""
}
