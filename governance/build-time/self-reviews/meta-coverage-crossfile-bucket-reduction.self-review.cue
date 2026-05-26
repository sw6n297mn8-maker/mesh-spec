package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

metaCoverageCrossfileBucketReduction: build_time.#SelfReviewReport & {
	reportId: "srr-meta-coverage-crossfile-bucket-reduction"

	artifactPath:       "architecture/structural-checks/meta-coverage.cue"
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
			Delta (adr-106) em sc-meta-02.exemptTypes: removidos domain-definition e
			service-contract (agora cobertos por sc-dd-01/02 e sc-sv-01);
			recategorizados subdomain + stakeholder-map → (P) (sem ref cross-file) e
			policy → (sem instâncias); afinados os rationale de agent-spec,
			economic-mechanism-model e cross-context-flow (específicos, não placeholder).
			Aprovado pelo founder.

			Conformancia: o campo exemptTypes segue conforme #StructuralCheckCoverageRule
			(lista de {type, rationale} non-empty); enforcement sc-meta-01/02 intactos
			(reject). cue vet 0.

			Efeito verificado: runner default → M2 (sc-meta-02) NÃO dispara (zero
			descobertos) — domain-definition e service-contract saíram por terem check;
			os recategorizados continuam isentos com rationale honesta. 0 bloqueantes.
			Bucket cross-file do M2: 8 → 3 (agent-spec, economic-mechanism-model,
			cross-context-flow), com rationale específico cada.
			"""
	}]

	findings: {}

	summary: """
		Reshape das isenções do sc-meta-02 (adr-106): -2 (cobertos), 3
		recategorizados (P / sem-instâncias), 3 deferidos com rationale específico.
		M2 segue em zero descobertos; bucket cross-file 8→3. Conforma #StructuralCheck;
		sem findings fail/warn.
		"""

	singleRoundRationale: "Uma rodada: reshape de isenções executando decisão aprovada (adr-106), conformidade e efeito (M2=0) verificados por cue vet + runner. Sem espaço de red-team."
}
