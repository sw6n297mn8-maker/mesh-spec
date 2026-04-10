package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr050ServiceContractSot: build_time.#SelfReviewReport & {
	reportId: "srr-adr-050-service-contract-sot"

	artifactPath:       "architecture/adrs/adr-050-service-contract-canonical-sot-for-bc-api-surfaces.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-10"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ADR-050 estabilizou em round único porque o conteúdo foi
		extensivamente revisado pelo founder antes da proposta:
		5 correções explícitas aplicadas (import syntax, decisionClass
		validado contra enum, derivedArtifacts removido, reclassificação
		confirmada como fato consumado, runner cross-BC documentado em
		consequences). Revisão humana de substância substitui rounds
		adicionais de self-review — o artefato chegou ao protocolo já
		corrigido.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação contra 8 critérios universais + 3 critérios
			específicos de ADR (tq-adr-01/02/03). Todos passaram.
			uq-01: rationales explicam WHY em todos os campos —
			rationale principal ancora em P1, triângulo canvas/domain-
			model/API, e justifica cada metadado (reversibility,
			blastRadius). uq-02: referências a P0, P1, P10, 3 SoTs,
			agentes com gates — específicos da Mesh. uq-03: 4 paths
			em affectedArtifacts verificados (todos existem); P0/P1/
			P10 existem em design-principles.cue; adr-048 referenciado
			no context existe. uq-04: nenhuma contradição com
			princípios. uq-05: 5 limitações declaradas (generator
			inexistente, migração gradual, tipagem fraca, runner
			cross-BC, validation prompt). uq-06: terminologia
			consistente. uq-07: zero placeholders. uq-08: todos os
			campos obrigatórios de #ADR presentes, decisionClass
			'foundational' validado no enum. tq-adr-01: 4 alternativas
			(a-d) com justificativa de rejeição. tq-adr-02:
			reversibility=medium e blastRadius=cross-cutting consistentes
			com decisão (instância CTR existe, afeta todos BCs).
			tq-adr-03: 4 paths em affectedArtifacts verificados —
			todos existem no repositório.
			"""
	}]

	findings: {}

	summary: """
		ADR-050 documenta a decisão foundational de estabelecer
		#ServiceContract como SoT canônico para superfícies de API
		de BCs, reclassificando api.yaml/async-api.yaml de autorais
		para derivados. Conteúdo revisado extensivamente pelo founder
		com 5 correções aplicadas antes do self-review. Todos os 11
		critérios (8 universais + 3 type-specific) passaram. Modo
		self-reported (não isolated-subagent) porque o founder já
		validou substância — sub-agente adicionaria custo sem valor
		incremental neste caso.
		"""
}
