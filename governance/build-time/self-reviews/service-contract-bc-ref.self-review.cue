package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

serviceContractBcRef: build_time.#SelfReviewReport & {
	reportId: "srr-service-contract-bc-ref"

	artifactPath:       "architecture/structural-checks/service-contract.cue"
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
			sc-sv-01 (kind cross-file-id-exists, adr-106), born-warn. Aprovado pelo
			founder. Conformancia #StructuralCheck: id sc-sv-01; artifactType
			"service-contract" ∈ #ArtifactType; kind↔rule cross-file-id-exists
			{referencePath "boundedContextRef", targetGlob "strategic/context-map.cue",
			targetIdPath "contexts[].context"}; errorMessage acionavel; rationale
			conecta ao caso (contrato órfão de topologia se o BC dono não está no mapa).
			enforcement "warn".
			Verificacao: ctr declarado em context-map.contexts (born-green); cue vet 0;
			runner default → sc-sv-01 sem FAIL/WARN, 0 bloqueantes.
			Escopo: cobre boundedContextRef; async/sync/errors (refs a events/operations)
			ficam fora (mesmo risco vocabulário dos events) — não bloqueia este check.
			"""
	}]

	findings: {}

	summary: "sc-sv-01: service-contract.boundedContextRef ∈ context-map.contexts[].context via cross-file-id-exists, born-warn/born-green (adr-106). Conforma #StructuralCheck; sem findings."

	singleRoundRationale: "Uma rodada: instância direta de kind existente (cross-file-id-exists), born-green verificado por cue vet + runner. Sem espaço de red-team."
}
