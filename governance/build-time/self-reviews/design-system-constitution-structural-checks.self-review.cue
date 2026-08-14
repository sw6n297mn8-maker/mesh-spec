package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

designSystemConstitutionStructuralChecks: build_time.#SelfReviewReport & {
	reportId: "srr-design-system-constitution-structural-checks"

	artifactPath:       "architecture/structural-checks/design-system-constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-14"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Estabilização em round único com evidência mecânica: a escolha do kind
		foi DERIVADA de leitura do runner (structural-check-runner.py) antes da
		autoria — load_artifact opera por arquivo (cue export <file>), logo os
		kinds baseados em conteúdo de instância (required-block,
		same-artifact-consistency, local-field-reference-integrity) seriam
		VACUAMENTE verdes sobre a instância composta (arquivo parcial não
		exporta → skip silencioso); o exemplo sugerido na missão
		(same-artifact-consistency sobre derivesFrom) foi por isso substituído
		por (a) enum fechado #DerivationSource no schema — enforcement
		compile-time MAIS forte (P14) — e (b) dois directory-pair-coverage
		bidirecionais (kind com evaluator ev_directory_pair no EVAL, sem kind
		novo — sc-meta-01 ok), a única garantia determinística REAL disponível:
		co-presença dos 3 arquivos (trava de deleção parcial, gêmea do sc-sg-01
		que não alcança regex não-literal). tq-sc-01 ✓ (errorMessages nomeiam
		os arquivos e a ação corretiva); tq-sc-02 ✓ (rule conforma ao kind via
		união discriminada — cue vet verde); tq-sc-03 ✓ (rationales conectam a
		regra ao caso concreto: instância composta fora do alcance do V1 +
		unicidade lógica do adr-194); born-warn per adr-097 ✓ (default,
		catraca posterior); cobertura sc-meta-02 satisfeita (tipo governado
		com ≥2 checks de artifactType correspondente — sem isenção necessária).
		Verificação de execução real: runner executado no working tree — ambos
		os checks avaliam (não-vácuos) e passam verdes.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			sc-dsc-01/02 (directory-pair-coverage bidirecional sobre os pares
			canonical-cases↔constitution e token-contract↔constitution):
			avaliados pelo runner real no working tree — 0 violações, checks
			não-vácuos (evaluator baseado em filesystem, não em load de
			instância). Análise de vacuidade dos kinds de conteúdo documentada
			no header do arquivo (honestidade sobre o alcance — a limitação
			não é escondida, é a razão declarada do desenho).
			"""
	}]

	findings: {}

	summary: """
		Structural-checks do tipo novo design-system-constitution (adr-194
		dec 9): 2 checks directory-pair-coverage bidirecionais garantindo a
		co-presença dos 3 arquivos da instância composta — a garantia
		determinística real que o runner V1 alcança para singleton lógico
		multi-arquivo; integridade interna (derivesFrom) coberta por enum
		fechado em cue vet (P14), camada mais forte que check pós-commit.
		Round único com evidência de execução real do runner (ambos verdes,
		não-vácuos); zero kind novo de evaluator criado.
		"""
}
