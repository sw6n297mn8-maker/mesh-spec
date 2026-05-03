package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr046DefersToBackfill: build_time.#SelfReviewReport & {
	reportId: "srr-adr-046-defersto-backfill"

	artifactPath:       "architecture/adrs/adr-046-conventions-category-and-tmpl-create-convention.cue"
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
		summary:   "Backfill edits per founder direction sessão 2026-05-03 (Backfill prose 'Known gaps declarados' antigas → def-XXX): (1) added defersTo: [def-010] field (post-adr-062 capability aplicada retroativamente; ADR original pre-adr-062 grandfathered mas backfill agrega traceability); (2) editado prose 'Known gaps declarados' item #Convention central para referenciar def-010 (gap canônico agora vive em def-010; prose mantida com pointer per P0 — single source of truth). Demais 2 prose items (3-camadas formalization + scope notes) permanecem inalterados — não qualificam como def-XXX (3-camadas é WI-style; scope notes são factual). Edição é editorial/mecânica per CLAUDE.md classification (não altera semantic da decisão; agrega pointer + reformula 1 item para canonical reference)."
	}]

	findings: {}

	summary: "adr-046 backfill: defersTo: [def-010] + prose item #1 reformulado para referenciar def-010. 2 outros prose items permanecem (não qualificam como def-XXX)."

	singleRoundRationale: "Edição editorial/mecânica retroativa para integrar adr-046 ao sistema deferred-decision (post-adr-062). Não altera decisão; agrega traceability. Round único suficiente."
}
