package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

readmeConfigSchemaAdoption: build_time.#SelfReviewReport & {
	reportId: "srr-readme-config-schema"

	artifactPath:       "architecture/artifact-schemas/readme-config.cue"
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
		0734a8f705dfa7ca048162845aa76cd5afdc1d47a6f080c5d0e1c0ce60ec69ac
		declarado em governance/adopted-artifacts.cue. Schema define
		#ReadmeConfig + #ReadmeSection + #RepositoryTree + #DirectoryNote
		com tree obrigatório per ADR-005 (tekton-spec). Auto-validação
		estrutural (uq-01..08 + tq-as-01..04) já foi feita no contexto
		da source — mesh-spec adota a validação upstream. Single round é
		o modo canônico para adoção verbatim onde o agente local não faz
		decisões de design, apenas verifica hash e registra adoção.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Readme-config.cue schema adotado verbatim de tekton-spec. Schema
			define o shape de governance/readme/config.cue: repo, heading,
			description (MinRunes 50), tree obrigatório (#RepositoryTree com
			entries mínimo 1), sections mínimo 1. Sub-tipos #DirectoryNote
			(path, purpose MinRunes 20, conventions, rationale) e
			#RepositoryTree (rootPath, entries, rationale). 5 quality criteria
			tq-rc-01..05 (4 fail shape + 1 warn CI). Sem autoria mesh-spec;
			hash verificado. Metacritérios tq-as-01..04 passam estruturalmente.
			"""
	}]

	findings: {}

	summary: "Readme-config.cue schema stable em 1 round. Adoção verbatim de tekton-spec v0.2.0 per ADR-050. Sem findings. Validação upstream herdada. Habilita stages 3-6 do ADR-050 (output.cue template, config.cue instance, regen README.md)."
}
