package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

serviceContractSchema: build_time.#SelfReviewReport & {
	reportId: "srr-service-contract-schema"

	artifactPath:       "architecture/artifact-schemas/service-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-04-10"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 3
		warnCount: 1
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou #ServiceContract contra 8 critérios
			universais + 3 critérios específicos de artifact-schema
			(tq-as-01/02/03). Findings aceitos: uq-03 (fail) —
			'service-contract' ausente de #ArtifactType e abreviação
			'ct' ausente da lista canônica em quality-criteria.cue;
			uq-01 (fail) — _qualityCriteria.rationale descreve estrutura
			de três camadas (WHAT) sem explicar por que a separação
			epistemológica importa para contratos de superfície (WHY);
			uq-05 (warn) — limitações parcialmente declaradas em
			comentários mas #CacheTier sem definição semântica de cada
			valor. Findings rejeitados: uq-07 (fail) — sub-agente
			avaliou representação abreviada do schema no prompt (campos
			test como 'Regex check', '[long test...]') ao invés do
			conteúdo real onde todos os 12 critérios têm test completo
			e acionável; tq-as-02 (fail) — mesma causa, falso-positivo
			por prompt abreviado.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Correções aplicadas: (1) _qualityCriteria.rationale reescrito
			para explicar WHY — separação em três camadas por natureza
			epistemológica (mecânica/determinística/semântica), com
			referência a adr-040 e P10, e justificativa de por que
			misturar camadas produz falsos bloqueios; (2) uq-03
			companion: adição de 'service-contract' a #ArtifactType e
			'ct' à lista canônica de abreviações em quality-criteria.cue
			planejada para mesmo commit. Warn uq-05 mantido como
			acknowledged — #CacheTier tem definição semântica implícita
			nos nomes (volatile/list/terminal mapeiam para cache headers
			HTTP na projeção OpenAPI) mas poderia ter comentário mais
			explícito; decisão do founder. Zero fails remanescentes.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message:     "#CacheTier enum ('volatile', 'list', 'terminal') sem definição semântica explícita de cada valor em comentário. Significado é inferível pelo nome e pelo uso na projeção de cache headers, mas não está documentado no schema."
		}]
	}

	summary: """
		Schema #ServiceContract para contrato canônico de superfície de BC
		com 20+ tipos (sync/async surfaces, union discriminated commands/
		queries, domain errors, ACL boundary, idempotency/concurrency
		policies, HATEOAS links, auth) e 12 quality criteria (tq-ct-01 a
		tq-ct-12). Estabilizou em 2/4 rounds via isolated-subagent. Round
		1: 5 findings — 2 rejeitados como falso-positivo (uq-07 e
		tq-as-02 avaliaram prompt abreviado, não conteúdo real), 2 aceitos
		como companion (uq-03: enum e abreviação em quality-criteria.cue),
		1 aceito e corrigido (uq-01: rationale WHAT→WHY). Round 2: zero
		fails, 1 warn acknowledged (uq-05: #CacheTier sem doc explícita).
		"""
}
