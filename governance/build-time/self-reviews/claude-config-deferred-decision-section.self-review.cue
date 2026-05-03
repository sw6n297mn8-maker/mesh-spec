package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

claudeConfigDeferredDecisionSection: build_time.#SelfReviewReport & {
	reportId: "srr-claude-config-deferred-decision-section"

	artifactPath:       "governance/claude/config.cue"
	artifactSchemaPath: "governance/claude/schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Adicionada section 'Deferimento Consciente Governado' ao final de governance/claude/config.cue per adr-062. canonicalSource aponta para architecture/artifact-schemas/deferred-decision.cue (schema canônico). Conteúdo: critério de pertinência anti-catch-all, lifecycle automatizado (open → runner annotations → founder edit → resolved/withdrawn), guidance sobre defersTo field, manual-review escape valve. Pattern paralelo a 'Aplicação de Production Guides' (adr-057): seção comportamental que NÃO redefine schema mas instrui consumo. CLAUDE.md regenerado via cue export ./governance/claude -e output --out text > CLAUDE.md."
	}]

	findings: {}

	summary: "Section 'Deferimento Consciente Governado' adicionada a CLAUDE.md (via config.cue source) materializando adr-062. CLAUDE.md regen aplicado."

	singleRoundRationale: "Materialização direta de decisão registrada em adr-062 + 3 rounds de red-team. Section content é resumo comportamental do schema/PG canônicos; não re-define semantics. Round único suficiente."
}
