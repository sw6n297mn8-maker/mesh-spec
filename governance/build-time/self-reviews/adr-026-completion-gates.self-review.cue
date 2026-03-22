package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr026CompletionGates: build_time.#SelfReviewReport & {
	reportId: "srr-adr-026-completion-gates"

	artifactPath:       "architecture/adrs/adr-026-completion-gates.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-22T13:30:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		ADR-026 é estruturalmente simples: documenta decisão já validada
		pelo founder durante revisão da proposta de completion-gates.cue.
		Alternativas (Opção A/B/C) foram discutidas explicitamente com o
		founder antes da aprovação. Context, decision e consequences
		refletem diretamente o feedback do founder sobre gap semântico
		entre template e output path. Critérios type-specific (alternativas
		documentadas, risk metadata, paths válidos) são satisfeitos sem
		ambiguidade.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "ADR-026 documenta decisão de completion gates com override por task. Context captura o gap semântico (obrigação condicional por output path vs enforcement estático por template). Decision descreve 3 camadas (catálogo, template mapping, task override) + ev-11. Consequences declara trade-off de manutenção por task. Três alternativas avaliadas (A adoptada, B diferida, C rejeitada). Todos os critérios universais e type-specific satisfeitos."
	}]

	findings: {}

	summary: "ADR-026 estável no round 1. Decisão previamente validada com founder. Alternativas documentadas, risk metadata preenchido, affected artifacts correspondem aos artefatos criados/modificados no mesmo commit."
}
