package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

crossContextFlowCrossfile: build_time.#SelfReviewReport & {
	reportId: "srr-cross-context-flow-crossfile"

	artifactPath:       "architecture/structural-checks/cross-context-flow.cue"
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
			sc-ccf-01/02 (kind cross-file-id-exists, adr-112), born-warn. Aprovados
			pelo founder. Conformancia #StructuralCheck: ids ^sc-[a-z0-9-]+-[0-9]{2}$;
			artifactType "cross-context-flow" ∈ #ArtifactType; kind↔rule
			cross-file-id-exists {referencePath, targetGlob, targetIdPath};
			errorMessage acionável; rationale conecta ao caso (phase atribuída a
			BC/subdomínio fantasma = drift referencial). enforcement "warn".
			- sc-ccf-01: phases[].ownerContext → context-map contexts[].context.
			- sc-ccf-02: phases[].ownerSubdomain → subdomains/*.cue code.
			Verificacao: protótipo → ownerContext (bdg/cmt/dlv/fce/inv) ∈ 25 contexts;
			ownerSubdomain ∈ 26 codes; cue vet 0; runner default → sc-ccf sem
			FAIL/WARN (born-green), 0 bloqueantes. A dimensão integrationEvents NÃO é
			coberta aqui (def-021): 3 refs não resolvem.
			"""
	}]

	findings: {}

	summary: "sc-ccf-01/02: integridade cross-file das âncoras estruturais do cross-context-flow (ownerContext→context-map, ownerSubdomain→subdomains) via cross-file-id-exists (adr-112), born-warn/born-green. Conforma #StructuralCheck; sem findings. integrationEvents deferida (def-021)."

	singleRoundRationale: "Uma rodada: instâncias diretas do cross-file-id-exists, born-green verificado por protótipo + cue vet + runner. A dimensão não-green é deferida (def-021), não improvisada. Sem espaço de red-team."
}
