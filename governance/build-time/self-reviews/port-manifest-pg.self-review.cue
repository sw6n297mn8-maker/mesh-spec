package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

portManifestPg: build_time.#SelfReviewReport & {
	reportId: "srr-port-manifest-pg"

	artifactPath:       "architecture/production-guides/port-manifest.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Re-review isolado dedicado do PG de #PortManifest (sub-agente fresco): tq-pg-01..06 todos PASS,
			0 fail / 0 warn. workOrder<->sections bijetivo (5 keys; sc-pg-02/03); cada section.target =
			#PortManifest; collectFromFounder cobre os 6 campos do schema; tq-pmg-01/02 + gapPolicy +
			rationale-and-validation proibem em 3 lugares distintos modelar a conformance interface-Kotlin
			<->manifest (deferida a def-050) -- boundary c-puro fiel ao adr-144 N4 e ao def-050 (verificado
			no disco); finalValidation termina em founder gate (adr-057). 1 info editorial: o arquivo e
			ASCII-only (consistente com os demais artefatos do arco).
			"""
	}]

	findings: {}

	summary: """
		PG de #PortManifest (autoria de instancias per-BC). Re-review isolado dedicado LIMPO (0 fail / 0
		warn): conforma integralmente a #ProductionGuide (tq-pg-01..06), cobre os 6 campos, e blinda o
		boundary c-puro em 3 pontos (nao modelar conformance interface<->manifest; fica em def-050). 1
		info editorial (ASCII) nao-bloqueante.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: o re-review isolado dedicado confirmou bijecao workOrder<->sections,
		cobertura dos campos e a proibicao tripla de overclaim de interface, 0 fail / 0 warn; cue vet
		valida o shape.
		"""
}
