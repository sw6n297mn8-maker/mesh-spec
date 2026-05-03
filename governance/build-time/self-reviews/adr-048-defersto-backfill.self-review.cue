package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr048DefersToBackfill: build_time.#SelfReviewReport & {
	reportId: "srr-adr-048-defersto-backfill"

	artifactPath:       "architecture/adrs/adr-048-api-spec-convention-conditional-presence.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
		summary:   "Backfill edits per founder direction sessão 2026-05-03 (paralelo a adr-046 backfill — gap shared): (1) added defersTo: [def-010] (post-adr-062 capability retroativa); (2) editado prose 'Known gaps declarados' item #3 (#Convention central) para referenciar def-010 (gap canônico agora em def-010). Demais 3 prose items (structural-check follow-up B.2, advisory follow-up, sourceField compile-time) permanecem inalterados — structural-check + advisory são WI-027 B.2/B.3 tracked (não def-XXX); sourceField compile-time é minor schema limitation borderline (não backfilled neste minimum scope; pode virar def-XXX futuro se padrão recorrer). Edição editorial/mecânica per CLAUDE.md classification."
	}]

	findings: {}

	summary: "adr-048 backfill paralelo a adr-046: defersTo: [def-010] + prose item #3 reformulado. 3 outros items permanecem (WI-tracked + minor schema limitation)."

	singleRoundRationale: "Edição editorial/mecânica retroativa shared com adr-046 backfill. Não altera decisão. Round único suficiente."
}
