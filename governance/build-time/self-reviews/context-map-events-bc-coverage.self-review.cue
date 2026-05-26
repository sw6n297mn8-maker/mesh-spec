package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapEventsBcCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-events-bc-coverage"

	artifactPath:       "architecture/structural-checks/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Delta (adr-105): adiciona sc-cm-06 (kind scoped-cross-file-id-exists) ao
			context-map.cue, ao lado de sc-cm-01..05. Born-warn. Aprovado pelo founder.

			Conformancia #StructuralCheck (tq-sc-01/02/03):
			- id sc-cm-06 ^sc-[a-z0-9-]+-[0-9]{2}$ PASS; nao colide.
			- artifactType "context-map" ∈ #ArtifactType.
			- kind↔rule: scoped-cross-file-id-exists + rule {itemsPath "relationships",
			  guardFields [source.context,target.context], guardPresenceGlob
			  "contexts/*/domain-model.cue", refField "events", targetGlob
			  "contexts/*/domain-model.cue", targetIdPath "events[].name"}.
			- errorMessage especifica e acionavel (cita vocabulário canônico adr-104);
			  rationale conecta ao caso (event trocado entre BCs construídos indefinido
			  = drift de contrato; allowance evita falso-positivo de BC planejado).
			- enforcement "warn": born-warn.

			Verificacao empirica: cue vet ./... EXIT 0; runner --self-test PASS; runner
			default → sc-cm-06 sem FAIL/WARN (0 missing built↔built sobre a base
			canônica do adr-104), 0 bloqueantes, exit 0. Resolve def-019.
			"""
	}]

	findings: {}

	summary: """
		sc-cm-06: events de relationship built↔built existem no domain-model do
		produtor (kind scoped-cross-file-id-exists, adr-105), born-warn. Conforma
		#StructuralCheck; nasce verde (0 missing). Resolve def-019 com allowance
		declarativa para BCs planejados. Sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: instancia direta do kind definido em adr-105 (aprovado antes
		da escrita), born-warn, born-green verificado por cue vet + self-test +
		execucao sobre a base canônica do adr-104. Sem espaco de decisao aberto a
		red-team.
		"""
}
