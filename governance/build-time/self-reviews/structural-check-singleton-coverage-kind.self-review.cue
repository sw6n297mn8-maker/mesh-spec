package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckSchemaSingletonCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-schema-singleton-coverage"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

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
			Edicao em structural-check.cue per adr-090: (1) #StructuralCheck
			uniao discriminada estendida com o kind "singleton-coverage";
			(2) #StructuralCheckKind enum 9 -> 10 valores; (3)
			#StructuralCheckRule uniao estendida com #SingletonCoverageRule;
			(4) #SingletonCoverageRule rule shape declarado com 1 field
			obrigatorio (requiredSingletons: lista nao-vazia de string
			nao-vazia). Comments do header atualizados com a motivacao
			adr-090 (gemeo de production-guide-coverage; whitelist explicita,
			nasce verde, cresce por change-on-touch; presenca pura, nao
			resolve referencia cross-file). 5th extension pattern (precedentes
			adr-049, adr-056, adr-063, adr-064). Backward compat: instancias
			existentes de #StructuralCheck permanecem validas. cue vet ./...
			confirmado verde no design.
			"""
	}]

	findings: {}

	summary: "Schema extension: #StructuralCheck +1 kind (singleton-coverage) + #SingletonCoverageRule. 5th extension pattern per adr-090. Backward compat preservada; requiredSingletons exige >=1 (nasce verde)."

	singleRoundRationale: "Edicao mecanica de schema extension, decisao registrada em adr-090. Pattern 5th application (precedentes adr-049/056/063/064). #SingletonCoverageRule e o shape mais simples da familia (1 field). cue vet passa; rounds adicionais nao detectariam new findings."
}
