package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr062: build_time.#SelfReviewReport & {
	reportId: "srr-adr-062"

	artifactPath:       "architecture/adrs/adr-062-introduce-deferred-decision-artifact.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 4
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 (red team): identificados 5 failure modes principais — triggers não-machine-evaluable (FM1), rationale fields confusos (FM2), status one-way não enforçado (FM3), originatingArtifact não aceita chat origins (FM4), bootstrap cost subestimado (FM5)."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 (post R1 corrections): 6 failure modes adicionais — discriminated union explode em cue vet (FM6, aceito), runner mutar def-XXX cria conflito (FM7, fix: annotations-only), trigger oscilante não auto-reverte (FM8, fix: aceita audit trail), AdjacentCondition expandindo demais (FM9, fix: 2 kinds minimal), dual pattern prose+def-XXX durante interim (FM10, fix: grandfather strategy), status withdrawn sem rationale (FM11, fix: withdrawalRationale required)."
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 3 (post R2 corrections): 5 failure modes adicionais — calibration sem doutrina (FM12, fix: PG codifica 'comece conservador, refine via amendment'), testabilidade do runner (FM13, deferred), ADR-062 risco de justificativa fraca (FM14, fix: 4 alternativas explicitamente), founder manual override path (FM15, fix: documentado), bootstrap cost re-avaliado (FM16, accepted)."
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 4 (final consolidation): schema final com 4 disjuncts em status discriminated union, OriginRef union (.cue ou session:), 3 rationale fields com MinRunes (description 50, deferralRationale 100, triggerCalibrationRationale 50). 5 trigger kinds, manual-review com reason MinRunes(40). Convention: tq-defg-NN para PG criteria seguindo precedente PG-ADR (CUE bypass via hidden field)."
	}]

	findings: {}

	summary: "ADR-062 estabelece #DeferredDecision artifact type após 3 rounds de red-teaming + 4 alternativas explicitamente rejeitadas. 4 known gaps declarados (validation-prompt deferido para commit 2; structural-check minimal v1; backfill de prose deferida; AdjacentCondition v1 minimal). Pattern paralelo a adr-047 + adr-049 (extension via ADR atomic)."

	singleRoundRationale: "N/A — 4 rounds executados conforme red-team request do founder."
}
