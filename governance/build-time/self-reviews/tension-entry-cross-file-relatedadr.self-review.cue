package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

tensionEntryCrossFileRelatedADR: build_time.#SelfReviewReport & {
	reportId: "srr-tension-entry-cross-file-relatedadr"

	artifactPath:       "architecture/structural-checks/tension-entry.cue"
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
			Delta (adr-102): adiciona sc-te-02 (kind cross-file-id-exists) ao
			tension-entry.cue, ao lado do sc-te-01 (manifestsIn, filesystem-path-exists)
			pre-existente. Born-warn. Aprovado pelo founder antes da escrita.

			Conformancia #StructuralCheck (tq-sc-01/02/03):
			- id sc-te-02 ^sc-[a-z0-9-]+-[0-9]{2}$ PASS; nao colide com sc-te-01.
			- artifactType "tension-entry" ∈ #ArtifactType.
			- kind↔rule: cross-file-id-exists + rule {referencePath: "relatedADR",
			  targetGlob: "architecture/adrs/*.cue", targetIdPath: "id"}. PASS.
			- errorMessage especifica e acionavel; rationale conecta ao caso concreto
			  (relatedADR era o alvo nomeado no def-002; id ficticio passa no regex).
			- enforcement "warn": born-warn (catraca adr-097).

			O comentario do arquivo foi atualizado: sc-te-relatedADR deixou de ser
			"depende de cross-file-id-exists / def-002" e passou a sc-te-02
			implementado via adr-102.

			Verificacao empirica: protótipo → 5 relatedADR, todos existem entre 99 ADR
			ids (BORN-GREEN); cue vet ./... EXIT 0; runner --self-test PASS; runner
			default → sc-te-02 sem FAIL/WARN, 0 bloqueantes, exit 0.
			"""
	}]

	findings: {}

	summary: """
		sc-te-02: integridade cross-file de tension-entry.relatedADR → ADR ids
		(kind cross-file-id-exists, adr-102), born-warn. Conforma #StructuralCheck;
		nasce verde (5/5 refs existem). Primeiro check do kind generico, provando o
		mecanismo no caso born-green nomeado no def-002. Sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: instancia direta do kind definido em adr-102 (aprovado
		antes da escrita), born-warn, conformidade e efeito (born-green) verificados
		por protótipo + cue vet + self-test + execucao. Sem espaco de decisao aberto
		a red-team.
		"""
}
