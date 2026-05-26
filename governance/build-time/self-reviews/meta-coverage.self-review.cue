package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

metaCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-meta-coverage"

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
			Instancias sc-meta-01 (evaluator-coverage) e sc-meta-02
			(structural-check-coverage) da camada de meta-cobertura (adr-099), born-warn.
			Aprovadas pelo founder antes da escrita.

			Conformancia #StructuralCheck (tq-sc-01/02/03):
			- id ^sc-[a-z0-9-]+-[0-9]{2}$: sc-meta-01, sc-meta-02 PASS.
			- artifactType "structural-check" ∈ #ArtifactType (os meta-checks validam a
			  propria camada de structural-checks).
			- kind↔rule pela uniao discriminada: sc-meta-01 kind evaluator-coverage +
			  rule {checkSchemaPath}; sc-meta-02 kind structural-check-coverage + rule
			  {exemptTypes: []}. PASS.
			- errorMessage especifica e acionavel (diz implementar evaluator+EVAL, ou
			  adicionar check / registrar isencao com rationale). rationale conecta a
			  caso concreto (a descoberta do cartaz-sem-fiscal; o sc-pg-01 como gemeo).
			- enforcement "warn" em ambos: born-warn deliberado (catraca adr-097).

			Verificacao empirica: cue vet ./... EXIT 0; runner --self-test PASS; runner
			default → sc-meta-01 NAO dispara (0 kinds sem evaluator, nasce verde),
			sc-meta-02 dispara em WARN listando ~30 tipos governados sem check
			comportamental; 0 BLOQUEANTES, exit 0. exemptTypes nasce vazio de proposito
			(o inventario warn e o backlog de triagem antes de qualquer promocao).
			"""
	}]

	findings: {}

	summary: """
		sc-meta-01 (M1, evaluator-coverage) e sc-meta-02 (M2, structural-check-coverage)
		born-warn per adr-099. Conformam #StructuralCheck (id/artifactType/kind↔rule/
		errorMessage/rationale/enforcement). Sem findings fail/warn. Verificacao:
		M1 verde, M2 lista ~30 tipos em warn, 0 bloqueantes, exit 0.
		"""

	singleRoundRationale: """
		Uma rodada basta: sao 2 instancias diretas dos kinds definidos em adr-099
		(aprovado antes da escrita), born-warn (nao bloqueiam), cuja conformidade e
		efeito (M1 verde, M2 inventario, 0 bloqueantes) foram verificados por cue vet +
		self-test + execucao do runner. Sem espaco de decisao aberto a red-team.
		"""
}
