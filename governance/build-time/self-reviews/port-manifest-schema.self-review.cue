package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

portManifestSchema: build_time.#SelfReviewReport & {
	reportId: "srr-port-manifest-schema"

	artifactPath:       "architecture/artifact-schemas/port-manifest.cue"
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
		infoCount: 1
		summary: """
			Re-review isolado dedicado de #PortManifest (sub-agente fresco, sem acesso a autoria): 8/8
			PASS, 0 fail / 0 warn. Campos derivam 1:1 do adr-141 item 5 (portsConsumed, operations,
			adaptersForGoldenExample, contractTestsRequired, referenceAdapterRequired); #PortRef canonico
			dos 5 Ports como localizacao unica (P0); portsConsumed list.UniqueItems + >=1 (primeiro
			elemento obrigatorio); tq-pm-01/02 well-formedness c-puro; zero overclaim de conformance
			interface<->manifest (deferida a def-050); tq-as-01/02/03 OK. 1 info editorial (abaixo de
			warn): header L13-14 'governa ... ref-integrity' e leve overclaim de escopo do arquivo (o
			schema habilita o check via campo boundedContextRef; o check em si e structural-check) -- sem
			impacto de shape/semantica.
			"""
	}]

	findings: {}

	summary: """
		#PortManifest (SoT spec-side da superficie de Port por BC). Re-review isolado dedicado LIMPO (0
		fail / 0 warn): campos fieis ao adr-141 item 5, c-puro (conformance interface<->manifest em
		def-050, fora do schema), #PortRef canonico (P0). 1 info editorial nao-bloqueante (header L13-14).
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: o re-review isolado dedicado nao achou fail nem warn (so 1 info editorial
		no header), e o schema deriva diretamente do adr-141 item 5 (decisao ja isolada-revisada) com
		shape validado por cue vet.
		"""
}
