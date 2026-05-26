package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapStructuralChecks: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-structural-checks"

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
			4 checks de integridade referencial intra-arquivo do context-map
			(sc-cm-01..04, kind local-field-reference-integrity, adr-100), born-warn.
			Aprovados pelo founder antes da escrita.

			Conformancia #StructuralCheck (tq-sc-01/02/03):
			- ids ^sc-[a-z0-9-]+-[0-9]{2}$: sc-cm-01..04 PASS.
			- artifactType "context-map" ∈ #ArtifactType.
			- kind↔rule pela uniao discriminada: kind local-field-reference-integrity +
			  rule {referencePath, namespacePath} nas 4 instancias. PASS.
			- errorMessage especifica e acionavel (cita o ref e o que corrigir);
			  rationale conecta a caso concreto (context-map = drift original do audit;
			  integridade que o cue vet de shape nao alcanca).
			- enforcement "warn" nas 4: born-warn deliberado (catraca adr-097).

			Cobertura das 4 referencias intra-arquivo verificaveis:
			- sc-cm-01/02: endpoints source/target → contexts declarados.
			- sc-cm-03: reverseRelationshipId → codes de relationship (bidirecionalidade).
			- sc-cm-04: ownerContext de subdomainOwnership → contexts declarados.

			Verificacao empirica: protótipo sobre os dados reais → 0 drift nas 4
			dimensoes (nascem verdes, guardas de regressao); cue vet ./... EXIT 0;
			runner --self-test PASS; runner default → sc-cm-01..04 sem FAIL/WARN, 0
			bloqueantes, exit 0; context-map sai da lista de descobertos do M2.
			"""
	}]

	findings: {}

	summary: """
		sc-cm-01..04: integridade referencial intra-arquivo do context-map
		(local-field-reference-integrity, adr-100), born-warn. Conformam
		#StructuralCheck; nascem verdes (0 drift). Sem findings fail/warn. Movem o
		context-map de descoberto para coberto na meta-cobertura (M2).
		"""

	singleRoundRationale: """
		Uma rodada basta: sao 4 instancias diretas do kind definido em adr-100
		(aprovado antes da escrita), born-warn, cuja conformidade e efeito (verdes,
		context-map sai do M2, 0 bloqueantes) foram verificados por protótipo + cue vet
		+ self-test + execucao do runner. Sem espaco de decisao aberto a red-team.
		"""
}
