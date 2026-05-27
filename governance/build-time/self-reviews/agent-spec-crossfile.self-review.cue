package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentSpecCrossfile: build_time.#SelfReviewReport & {
	reportId: "srr-agent-spec-crossfile"

	artifactPath:       "architecture/structural-checks/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-27"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			sc-ag-01 (kind instance-scoped-cross-file-id-exists, adr-113), born-warn.
			Aprovado pelo founder. Conformancia #StructuralCheck: id
			^sc-[a-z0-9-]+-[0-9]{2}$; artifactType "agent-spec" ∈ #ArtifactType;
			kind↔rule instance-scoped-cross-file-id-exists {referencePaths, scopeField,
			targetGlobTemplate, targetIdPaths}; errorMessage acionável (com {ref} e
			{scope}); rationale conecta ao caso (ref a building block fantasma ou
			vazamento cross-BC = violação de least-privilege tq-ag-01/02). enforcement
			"warn".
			- referencePaths: operationalScope.{aggregates,commands,events,invariants,
			  projections}[] + actions[].domainModelRefs[].
			- scopeField boundedContextRef; targetGlobTemplate contexts/{scope}/
			  domain-model.cue; targetIdPaths = 11 paths de code (aggregates/entities/
			  commands/domainServices/events/invariants/modules/policies/projections/
			  queryCapabilities/valueObjects) — enumeração verificada completa contra
			  os 12 domain-models (nenhum path de code omitido → sem falso-positivo).
			Verificacao: protótipo → 309 refs dos 12 agentes, 0 não-resolvidas
			(born-green); cue vet 0; runner default → sc-ag-01 sem FAIL/WARN, 0
			bloqueantes.
			"""
	}]

	findings: {}

	summary: "sc-ag-01: integridade cross-file per-BC dos refs de domain model do agent-spec (operationalScope/domainModelRefs → domain-model do próprio BC) via instance-scoped-cross-file-id-exists (adr-113), born-warn/born-green. Escopo least-privilege (tq-ag-01/02). Conforma #StructuralCheck; sem findings. Zera o bucket cross-file do M2."

	singleRoundRationale: "Uma rodada: instância direta do kind novo (adr-113), com targetIdPaths verificado completo contra os 12 domain-models e born-green confirmado por protótipo + cue vet + runner. Sem espaço de red-team."
}
