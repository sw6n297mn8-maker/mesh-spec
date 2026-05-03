package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

tensionEntryScTouch: build_time.#SelfReviewReport & {
	reportId: "srr-tension-entry-sc-touch"

	artifactPath:       "architecture/structural-checks/tension-entry.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

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
		summary:   "Retroativo per adr-068 decision item 3. Cobre touch da SC architecture/structural-checks/tension-entry.cue durante branch claude/resume-mesh-work-jv2MC. Modificação em adr-063 commit 4cd3e2e (filesystem-path-exists kind addition + 4 SCs novos per Opção B retomada). SC valida tension-entries per kind rules; mudança aditiva alinha cobertura com novos kinds disponíveis. SC conformante a #StructuralCheck schema."
	}]

	findings: {}

	summary: "Retroativo per adr-068: touch de structural-checks/tension-entry.cue cobrindo adição de filesystem-path-exists kind em adr-063."

	singleRoundRationale: "Retroativo cobre touch específica já validada por adr-063 self-review existente. Round único suficiente."
}
