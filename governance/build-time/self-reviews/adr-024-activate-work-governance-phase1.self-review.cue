package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr024: build_time.#SelfReviewReport & {
	reportId: "srr-adr-024"

	artifactPath:       "architecture/adrs/adr-024-activate-work-governance-phase1.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-20"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		ADR segue padrão estabelecido por 23 ADRs anteriores no
		repositório. Estrutura direta: contexto claro (gap de
		visibilidade), decisão específica (4 artefatos em ordem),
		alternativa rejeitada (status nas task-specs), metadata de
		risco consistente (high reversibility porque são arquivos
		novos, cross-cutting porque afeta governança inteira).
		Todos os critérios universais (uq-01 a uq-08) e
		type-specific (tq-adr-01 a tq-adr-03) passam sem findings.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação contra 11 critérios (8 universais + 3 type-specific).
			uq-01: rationale explica necessidade operacional imediata (why).
			uq-02: referencia P0 Three SoTs, mecanismo específico da Mesh.
			uq-03: ADR-005, P0, P8, P12 existem no repositório.
			uq-04: alinhado com P0 (SoTs formais), P8 (projeções), P12 (policy-as-code).
			uq-05: limitação de timestamps aproximados declarada em consequences.
			uq-06: terminologia consistente (Phase 1, task-specs, work-events).
			uq-07: zero placeholders.
			uq-08: todos os campos obrigatórios de #ADR presentes.
			tq-adr-01: alternativa "status nas task-specs" rejeitada com justificativa.
			tq-adr-02: reversibility high (arquivos novos), blastRadius cross-cutting (governança).
			tq-adr-03: paths em affectedArtifacts serão criados como output da decisão.
			"""
	}]

	findings: {}

	summary: """
		ADR-024 registra ativação antecipada de Phase 1 da governança
		de trabalho. Decisão estrutural que cria 4 artefatos novos
		(command-rights, task-governance, work-events, projections).
		Self-review estável em round único — padrão ADR maduro no
		repositório, sem ambiguidade nos critérios.
		"""
}
