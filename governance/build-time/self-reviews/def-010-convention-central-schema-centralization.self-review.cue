package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def010: build_time.#SelfReviewReport & {
	reportId: "srr-def-010"

	artifactPath:       "architecture/deferred-decisions/def-010-convention-central-schema-centralization.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

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
		summary:   "def-010 backfills shared deferral em adr-046 + adr-048 (#Convention central schema deferido até n=2 convenções concretas) — prose 'Known gaps declarados' converted para def-XXX queryable per adr-062 forward direction. originatingArtifacts=[adr-046, adr-048]; ambas ADRs pré-adr-062 grandfathered, modified neste mesmo commit para adicionar defersTo: [def-010] + editar prose item para referenciar def. Trigger automatic: recurrence scope=filename pattern '^architecture/conventions/' threshold=2 (atualmente count=1: api-spec-convention.cue; fires quando 2nd convention materializar). Pattern verified clean — schema declarations vivem em artifact-schemas/, não em conventions/. Trade-off articulado per pattern ten-009: zero-cost com 1 convention; commitment prematuro a estrutura sem evidence custaria mais. costOfDeferral severity=low + blastRadius=local."
	}]

	findings: {}

	summary: "def-010: backfill mínimo de prose gap shared entre adr-046 + adr-048 (#Convention central schema). Trigger codificado threshold=2 + manual-review."

	singleRoundRationale: "Backfill de gap pre-adr-062 com clear def-XXX shape (decisão deferida + trade-off + trigger codificável). Conservador: 1 def único cobrindo gap shared entre 2 ADRs. Round único suficiente."
}
