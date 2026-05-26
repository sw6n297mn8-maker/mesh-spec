package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainDefinitionCrossfilePaths: build_time.#SelfReviewReport & {
	reportId: "srr-domain-definition-crossfile-paths"

	artifactPath:       "architecture/structural-checks/domain-definition.cue"
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
			sc-dd-01/02 (kind filesystem-path-exists, adr-106), born-warn. Aprovados
			pelo founder. Conformancia #StructuralCheck: ids ^sc-[a-z0-9-]+-[0-9]{2}$;
			artifactType "domain-definition" ∈ #ArtifactType; kind↔rule
			filesystem-path-exists {sourcePath, isList:false}; errorMessage acionavel;
			rationale conecta ao caso (domain-definition ancora tese nos princípios +
			stakeholder-map por path). enforcement "warn".
			Verificacao: design-principles.cue e stakeholder-map.cue existem (born-green);
			cue vet 0; runner default → sc-dd sem FAIL/WARN, 0 bloqueantes.
			"""
	}]

	findings: {}

	summary: "sc-dd-01/02: refs por path do domain-definition (designPrinciplesRef, stakeholderMapRef) via filesystem-path-exists, born-warn/born-green (adr-106). Conforma #StructuralCheck; sem findings."

	singleRoundRationale: "Uma rodada: instâncias diretas de kind existente (filesystem-path-exists), born-green verificado por cue vet + runner. Sem espaço de red-team."
}
