package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

canvasPg: build_time.#SelfReviewReport & {
	reportId: "srr-canvas-pg"

	artifactPath:       "architecture/production-guides/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "PG canvas materializado por cascade-ordering requirement de adr-053/adr-054. Authoring manual após dispatch subagent timeout (per adr-074 fallbackPolicy onAmbiguity/manual takeover). 8 sections cobrindo activity-based partitioning de #Canvas authoring: identity-and-purpose, strategic-classification, domain-roles-and-capabilities, communication, business-decisions, stakeholders-incentives-and-costs, ownership-and-governance, epistemic-and-validation. workOrder permutação exata de 8 keys. 4 _qualityCriteria (tq-cv-01..04) com severity 'fail' hardened — alignment com subdomain registry, no fabricated integration relations, grounded design via stakeholders + incentives, invariants substantivos. Ajustes founder pre-commit: (1) wording 'Phase 2' → 'cascade-ordering requirement'; (2) ownership.doneCriteria relaxed de ≥3/≥3/≥3 para ≥1/≥1/≥3 (BCs simples não fabricam decisões); (3) communication.doneCriteria adicionada cláusula 'inbound.commands ≥1 OR rationale event/query-only interface'. Cross-references META-PG disciplines (tq-mg-06/07/08/09/10) integradas em heuristics + finalValidation. finalValidation.steps[-1] = founder approval bloqueante per adr-057. cue vet ./architecture/production-guides/ EXIT=0; CI self-review-check local PASSED."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 (2026-05-29): adicionada 9ª section "boundary-derivation"
			(primeira no workOrder) materializando o protocolo de P13 (adr-125)
			— 3 testes de separação + teste de remoção + ordem de classificação
			de relação cross-BC + ônus invertido sobre ciclos + ponteiro para o
			validation-prompt advisory def-029. target #Canvas; process (4 steps)
			+ heuristics (4) + doneCriteria + ifGap. workOrder volta a ser
			permutação exata das keys de sections (9 ↔ 9; sc-pg-02/sc-pg-03
			preservados). As 8 sections originais permanecem inalteradas. cue vet
			./... EXIT=0.
			"""
	}]

	findings: {}

	summary: "PG canvas: 9 sections activity-based (boundary-derivation + 8 originais), 4 tq-cv-XX hardened fail, cross-refs META-PG disciplines. Round 2 adiciona boundary-derivation (materializa P13/adr-125). workOrder permutação exata de 9 keys."
}
