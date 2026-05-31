package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adoptedArtifactsSchemaAdoption: build_time.#SelfReviewReport & {
	reportId: "srr-adopted-artifacts-schema"

	artifactPath:       "architecture/artifact-schemas/adopted-artifacts.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-16T16:40:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Adoção verbatim de schema portfolio-wide (tekton-spec@7151c92,
		v0.2.0) per ADR-050 (merged PR #27). Sem autoria local: o arquivo
		é cópia exata, verificável por hash sha256
		318f9d76b879b62f4df87da956741832e78f7aa4284e5f2247f3671eb922d198
		declarado em governance/adopted-artifacts.cue (primeiro manifest
		de mesh-spec). Auto-validação estrutural (uq-01..08 + tq-as-01..04)
		já foi feita no contexto da source — mesh-spec adota a validação
		upstream. Single round é o modo canônico para adoção verbatim
		onde o agente local não faz decisões de design, apenas verifica
		hash e registra adoção.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Adopted-artifacts.cue schema adotado verbatim de tekton-spec.
			Schema define #AdoptedArtifactsManifest + #AdoptionMode +
			#AdoptedArtifact com 4 modos (verbatim, extended, forked,
			migration-pending) e 7 quality criteria. Sem autoria mesh-spec;
			hash verificado. uq-01..08 passam via herança da source
			(tekton-spec já validou). tq-as-01 (_schema.location presente),
			tq-as-02 (_qualityCriteria presente), tq-as-03 (tests acionáveis),
			tq-as-04 (rationale do conjunto) — todos passam estruturalmente.
			"""
	}]

	findings: {}

	summary: "Adopted-artifacts.cue schema stable em 1 round. Adoção verbatim de tekton-spec v0.2.0 per ADR-050. Sem findings. Validação upstream herdada."
}

// ci-smoke-test: PR descartável para testar se o pipeline (CI + merge) dispara num PR limpo. DO NOT MERGE.
