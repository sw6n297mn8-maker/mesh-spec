package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr067: build_time.#SelfReviewReport & {
	reportId: "srr-adr-067"

	artifactPath:       "architecture/adrs/adr-067-extend-artifact-type-for-production-guide.cue"
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
		summary:   "ADR estende artifact_type_for_path em scripts/ci/check-self-review.sh para cobrir production-guide instances per pattern progressivo de adr-060 + adr-066. Pattern broad ('architecture/production-guides/*.cue') reflete que TODOS os arquivos no diretório são PG instances — diferente de deferred-decisions/ onde 'def-*.cue' filtra futuros prefixos não-PG. 9 instances totais; via git diff origin/main...HEAD apenas 2 PGs modificadas nesta branch (deferred-decision.cue + tension-entry.cue), nenhuma com SRR matching path antes deste commit → 2 retroativos materializados (deferred-decision-pg-touch + tension-entry-pg-touch). Regularização transitória das 4 PGs em main pre-path-mapping (adr.cue, agent-governance.cue, agent-spec.cue, structural-check.cue) via 4 entries em self-review-bootstrap-policy.cue (categoria pre-mapping-transient): cada exception sai quando próxima modificação criar SRR matching path. Schema first-class para transient lifecycle (category/lifecycle/exitCondition fields + structural-check de stale detection) deferido per def-011 com trigger recurrence threshold=4 sobre filename pattern de path-mapping ADRs (conta hoje=3; próximo dispara) + manual-review fallback. 4 alternativas explicitamente rejeitadas (status quo, narrow pattern, batch com structural-check + validation-prompt, skip retroativos). Known gaps em prose: structural-check + validation-prompt + canvas/glossary/domain-model paths (separate ADRs per progressive pattern). Discrepância detectada e corrigida pré-commit: prose original claimed 7 modified PGs, verificação rigorosa via git diff confirmou apenas 2 — escopo de retros corrigido para apenas in-flight per pattern adr-060; 4 PGs main regularizadas via bootstrap exception. defersTo: [def-011]. principlesApplied: P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-cutting. Pattern paralelo a adr-060 (5 retros) e continuidade direta de adr-066 (zero retros por discipline preventiva). cue vet ./... EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "ADR-067 adiciona production-guide ao CI mapping (continuação adr-060 + adr-066 progressive). Pattern broad *.cue. 2 retroativos in-flight + 4 bootstrap exceptions transient para PGs main pre-mapping + def-011 (deferimento de schema first-class). Commit consolidado."

	singleRoundRationale: "Pattern bem-estabelecido (adr-060 + adr-066 directly applicable). Retroativos in-flight + regularização transitória articulados explicitamente em prose + plannedOutputs + defersTo. Round único suficiente."
}
