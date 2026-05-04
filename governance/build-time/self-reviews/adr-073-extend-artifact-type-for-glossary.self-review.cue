package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr073: build_time.#SelfReviewReport & {
	reportId: "srr-adr-073"

	artifactPath:       "architecture/adrs/adr-073-extend-artifact-type-for-glossary.cue"
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
		summary:   "ADR estende artifact_type_for_path em scripts/ci/check-self-review.sh para cobrir glossary instances per pattern progressivo de adr-060/066/067/068/069/072. Pattern broad ('contexts/*/glossary.cue') paralelo a adr-072 canvas (convenção estrutural fixa). 4 BC instances totais (cmt, ctr, idc, npm); via git diff origin/main...HEAD ZERO modificadas → zero retroativos in-flight. Regularização transitória de 4 BC glossaries main pre-path-mapping via 4 entries em self-review-bootstrap-policy.cue. Cleanup oportunista de adr-067 gap: PG inventory mostra que adr-067 omitiu domain-model.cue + glossary.cue PGs em transient exceptions (gap dormente 5 commits). +2 entries adicionais resolve gap mecanicamente — mesmo arquivo, mesma categoria, mesmo mecanismo (anti-catch-all preservado). Total cumulativo da categoria pre-mapping-transient pós-adr-073: 24 entries (4 original adr-067 + 1 adr-068 + 9 adr-069 + 4 canvas adr-072 + 4 BC glossary adr-073 + 2 PG cleanup adr-073). def-012 is expected to fire because transient bootstrap exceptions reach 24; this commit intentionally creates the revisitation signal for stale-detection structural-check. Trigger threshold=20 atravessado intencionalmente; founder revisita per adr-070 lifecycle (decide implementar sc-be-01 OR ajustar threshold OR registrar acknowledgment). 4 alternativas explicitamente rejeitadas (status quo, narrow pattern, separate ADR para gap, def-XXX para gap). principlesApplied: P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-cutting. Volume baixo (5 arquivos) com cleanup oportunista embutido. cue vet ./... EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "ADR-073 adiciona glossary ao CI mapping (continuação adr-060/066/067/068/069/072 progressive) + cleanup oportunista de adr-067 PG gap (domain-model + glossary). Pattern broad contexts/*/glossary.cue. Zero retros + 6 transient bootstrap exceptions (4 BC glossary + 2 PG cleanup). def-012 fires intencionalmente (count 24 ≥ 20). Commit consolidado 5 arquivos."

	singleRoundRationale: "Pattern bem-estabelecido (adr-060/066/067/068/069/072 directly applicable) + schema first-class operacional (adr-070). Cleanup oportunista é gap mecânico mesmo arquivo. def-012 fire intencional articulado em consequences. Round único suficiente."
}
