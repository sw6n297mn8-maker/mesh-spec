package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

economicMechanismCrossfile: build_time.#SelfReviewReport & {
	reportId: "srr-economic-mechanism-crossfile"

	artifactPath:       "architecture/structural-checks/economic-mechanism-model.cue"
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
			sc-em-01/02 (kind cross-file-id-exists, adr-111), born-warn. Aprovados pelo
			founder. Conformancia #StructuralCheck: ids ^sc-[a-z0-9-]+-[0-9]{2}$;
			artifactType "economic-mechanism-model" ∈ #ArtifactType; kind↔rule
			cross-file-id-exists {referencePath, targetGlob, targetIdPath}; errorMessage
			acionável; rationale conecta ao caso (mecanismo apontando para imperativo/
			risco fantasma quebra rastreabilidade). enforcement "warn".
			- sc-em-01: mechanisms[].enforces[] → systemImplications[].id (imp-*).
			- sc-em-02: mechanisms[].protectsAgainst[] → realityInvariants[].id (ri-*).
			Verificacao: protótipo → 9 refs todas resolvem (18 ids); cue vet 0; runner
			default → sc-em sem FAIL/WARN (born-green), 0 bloqueantes.
			"""
	}]

	findings: {}

	summary: "sc-em-01/02: integridade cross-file dos mecanismos econômicos (enforces→imp, protectsAgainst→ri) via cross-file-id-exists (adr-111), born-warn/born-green. Conforma #StructuralCheck; sem findings."

	singleRoundRationale: "Uma rodada: instâncias diretas do cross-file-id-exists, born-green verificado por protótipo + cue vet + runner. Sem espaço de red-team."
}
