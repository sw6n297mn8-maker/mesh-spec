package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

singletonCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-singleton-coverage"

	artifactPath:       "architecture/structural-checks/singleton-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Criacao da SC architecture/structural-checks/singleton-coverage.cue
			(sc-sg-01) per adr-090, gemeo de sc-pg-01 (production-guide-
			coverage). Nasce VERDE: requiredSingletons lista apenas singletons
			que JA existem — context-map, domain-definition, repo-structure,
			stakeholder-map — cada um com schema declarando
			_schema.location.cardinality == "singleton" e canonicalPathRegex
			literal-ancora. Trava de regressao contra delecao acidental, nao
			debito retroativo. Whitelist explicita (nao auto-discovery),
			WIP-safe, cresce por change-on-touch (agent-governance global
			entra quando criado, pos-cutover). Conformante a #StructuralCheck
			schema (kind singleton-coverage + #SingletonCoverageRule);
			errorMessage e rationale especificos ao kind. cue vet confirmado
			verde no design.
			"""
	}]

	findings: {}

	summary: "sc-sg-01 single-round SRR. Instancia born-green do kind singleton-coverage per adr-090: trava de regressao para os 4 singletons existentes (context-map, domain-definition, repo-structure, stakeholder-map). Presenca pura; resolucao cross-file permanece deferida (def-002)."

	singleRoundRationale: "Single-round suficiente: SC born-green sobre singletons existentes (nenhuma violacao no estado atual). Decisao registrada em adr-090; o kind singleton-coverage foi red-teamed no SRR do schema. cue vet passa; rounds adicionais nao detectariam new findings."
}
