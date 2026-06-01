package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentProbeStructuralChecks: build_time.#SelfReviewReport & {
	reportId: "srr-agent-probe-structural-checks"

	artifactPath:       "architecture/structural-checks/agent-probe-record.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-31"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review de sc-apr-01 + sc-apr-02 (Ciclo 4, adr-134). Avaliado contra 8
			universalCriteria + tq-sc (errorMessage específica, união discriminada por
			kind, rationale rastreável).

			uq-03 (refs): ambos os checks têm artifactType "agent-probe-record" (existe no
			#ArtifactType após o enum edit); kinds filesystem-path-exists e
			directory-pair-coverage têm evaluator em EVAL (verificado). Pass.
			uq-04 (P10): cobertura/referência são determinísticas (existência de
			path/arquivo) — gateiam o PROCESSO, não a adequação interpretativa do finding.
			Coerente com adr-040. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma #StructuralCheck): sc-apr-01 kind=filesystem-path-exists com
			rule{sourcePath:"targetCanvas"}; sc-apr-02 kind=directory-pair-coverage com
			rule{sourceGlob,targetGlob,bidirectional}; enforcement "warn" (born-warn);
			ids casam ^sc-[a-z0-9-]+-[0-9]{2}$. cue vet EXIT=0; runner: sc-apr-01 verde,
			sc-apr-02 13 warns. Pass.
			tq-sc-01 (errorMessage específica): cita o canvas/record concreto faltante. Pass.
			tq-sc-02 (união discriminada por kind): rule conforma ao shape do kind. Pass.
			tq-sc-03 (rationale rastreável): ancora em adr-134 + sc-srr-01/sc-dp-01 como
			gêmeos. Pass.
			"""
	}]

	findings: {}

	summary: """
		sc-apr-01 (referencial, filesystem-path-exists em targetCanvas, born-green) +
		sc-apr-02 (cobertura, directory-pair-coverage canvas->record, born-warn 13).
		Ambos reusam kind + handler existentes (sem kind/handler novo). Eixos ortogonais:
		referência (record aponta a canvas real) vs cobertura (canvas tem record).
		Verificado no runner: sc-apr-01 0 violações; sc-apr-02 13 warns; runner 0
		bloqueantes. Estável em 1 round.
		"""

	singleRoundRationale: """
		Checks são instâncias diretas de kinds existentes (filesystem-path-exists,
		directory-pair-coverage) com rule de shape trivial; conformance verificável por
		cue vet + execução real do runner (já rodado: sc-apr-01 verde, sc-apr-02 13 warns).
		Sem ambiguidade pendente.
		"""
}
