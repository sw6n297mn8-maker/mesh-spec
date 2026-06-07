package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

aggregateManifestSchema: build_time.#SelfReviewReport & {
	reportId: "srr-aggregate-manifest-schema"

	artifactPath:       "architecture/artifact-schemas/aggregate-manifest.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

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
		infoCount: 3
		summary: """
			Re-review isolado dedicado de #AggregateManifest (sub-agente fresco): 7/7 PASS, 0 fail / 0
			warn. Campos derivam do adr-141 item 5 (name/id, commandsAccepted, eventsEmitted, invariants,
			portsRequired subset dos 5, generatedArtifacts); aggregateRef #AggregateRef required (elo ao
			domain-model); commands/events/invariants sao IDS (shape via #CommandRef/#EventRef/#InvariantRef)
			-- a EXISTENCIA cross-file e deferida a def-052, distinta do subset-do-canon runtime (cross-repo,
			adr-144 C1); portsRequired list.UniqueItems + subset dos 5; tq-am-01/02 e tq-as-01/02/03 OK. 3
			info (nao-defeito): generatedArtifacts/invariants admitem lista vazia (coerente com item 5 +
			tq-am-01 que garante nao-vacuidade via command/event); helper types detalhados; tipo no enum +
			abreviacao am registrados.
			"""
	}]

	findings: {}

	summary: """
		#AggregateManifest (SoT spec-side de um aggregate). Re-review isolado dedicado LIMPO (0 fail / 0
		warn): materializa as regras na fronteira correta — constraint nativa (portsRequired subset 5,
		shape de ids) vs gate deferido (existencia cross-file -> def-052; subset-do-canon -> cross-repo).
		A distincao existencia-no-domain-model vs subset-do-canon, ponto central, esta explicita e ancorada
		em adr-144/def-052. 3 info nao-bloqueantes.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: o re-review isolado dedicado confirmou 0 fail / 0 warn, com a separacao
		existencia/canon (o risco principal do tipo) verificada correta contra def-052 e adr-144 C1; shape
		validado por cue vet.
		"""
}
