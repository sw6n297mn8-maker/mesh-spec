package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapDiskDeclaredCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-disk-declared-coverage"

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
			Delta (adr-103): adiciona sc-cm-05 (kind filesystem-declared-coverage) ao
			context-map.cue, ao lado de sc-cm-01..04 (local-field-reference-integrity).
			Born-warn. Aprovado pelo founder antes da escrita.

			Conformancia #StructuralCheck (tq-sc-01/02/03):
			- id sc-cm-05 ^sc-[a-z0-9-]+-[0-9]{2}$ PASS; nao colide.
			- artifactType "context-map" ∈ #ArtifactType.
			- kind↔rule: filesystem-declared-coverage + rule {pathGlob: "contexts/*/",
			  targetGlob: "strategic/context-map.cue", targetIdPath: "contexts[].context"}.
			- errorMessage especifica e acionavel; rationale conecta ao audit (mapas
			  discordam com o disco) na direção segura disco→map.
			- enforcement "warn": born-warn.

			Verificacao empirica: investigação → 0 dir contexts/*/ não-declarado
			(BORN-GREEN); cue vet ./... EXIT 0; runner --self-test PASS; runner
			default → sc-cm-05 sem FAIL/WARN, 0 bloqueantes, exit 0.
			"""
	}]

	findings: {}

	summary: """
		sc-cm-05: todo diretório de BC no disco está declarado no context-map
		(kind filesystem-declared-coverage, adr-103), born-warn. Conforma
		#StructuralCheck; nasce verde (0 não-declarado). Fecha o drift real
		disco→map do audit. Sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: instancia direta do kind definido em adr-103 (aprovado
		antes da escrita), born-warn, conformidade e efeito (born-green) verificados
		por investigação + cue vet + self-test + execucao. Sem espaco de decisao
		aberto a red-team.
		"""
}
