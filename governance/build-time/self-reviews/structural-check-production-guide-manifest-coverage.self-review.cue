package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scProductionGuideManifestCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-production-guide-manifest-coverage"

	artifactPath:       "architecture/structural-checks/production-guide.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review em sessao: sc-pg-01.coveredSchemas += 'port-manifest' e 'aggregate-manifest'
			(change-on-touch per adr-056; cascade ordering adr-054 dec13 — nome adicionado no MESMO commit
			que cria os 2 production-guides). Os 2 PGs existem no disco, entao a rule nasce verde
			(cobertura satisfeita). Nenhum outro campo de sc-pg-01/02/03 tocado. Conforma #StructuralCheck.
			cue vet pass. Sem fail.
			"""
	}]

	findings: {}

	summary: """
		structural-checks/production-guide.cue (sc-pg-01.coveredSchemas += port-manifest/aggregate-manifest).
		Self-review LIMPO: append de 2 nomes a whitelist, com os PGs correspondentes ja no disco (rule
		verde), satisfazendo cascade ordering. cue vet pass.
		"""

	singleRoundRationale: """
		1 round: edit mecanico de whitelist (append de 2 nomes); os production-guides correspondentes
		existem no disco e cue vet passa — sem ambiguidade nem fail a iterar.
		"""
}
