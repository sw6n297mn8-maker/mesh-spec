package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr065: build_time.#SelfReviewReport & {
	reportId: "srr-adr-065"

	artifactPath:       "architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue"
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
		summary:   "ADR fecha WI-040 (proposed 2026-04-05, awaiting ~1 mês). Founder reframe substantivo durante sessão 2026-05-03: PLR como registry-only (NÃO engine) — escolha A com restrição crítica que evita solution-in-search-of-problem. Schema enforcement: 'external' literal-locked é gate determinístico contra drift futuro. 7 decision items numerados explícitos. 4 alternativas rejeitadas (a/b/c originais + d artifactType-only). 5 deferrals codificados via def-005..009 (cross-BC execution, sync, data consistency, distributed evaluation, lifecycle/versioning) com triggers automáticos + manual-review fallback. 5 negativeBoundaries declaradas com 3 (2/4/5) usando external-system ref como workaround para mecanismos internos não-subdomain — schema gap explicitamente registrado em known gaps. 6 founder ajustes incorporados: path domain/policies/, schema scope+class+enforcement-locked, 5 boundaries com workaround documentado, 5 defs com auto trigger, +def-009 lifecycle, status=accepted. principlesApplied: P0, P1, P10, P12. decisionClass=structural, reversibility=medium, blastRadius=cross-cutting. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "ADR-065 estabelece PLR como supporting subdomain registry-only com 5 deferrals + 5 negativeBoundaries + 7 decision items + sanity test invariante schema-locked. Pattern minimalism preservado per founder reframe."

	singleRoundRationale: "Founder reframe substantivo + 6 ajustes obrigatórios incorporados em pré-write proposal. Decisão final crystallized antes da escrita; round único suficiente."
}
