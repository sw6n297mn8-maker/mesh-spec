package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

validateProductionGuideVpTouch: build_time.#SelfReviewReport & {
	reportId: "srr-validate-production-guide-vp-touch"

	artifactPath:       "architecture/validation-prompts/validate-production-guide.cue"
	artifactSchemaPath: "architecture/artifact-schemas/validation-prompt.cue"
	artifactType:       "validation-prompt"

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
		summary:   "Retroativo per adr-069 decision item 3. Cobre criação da VP architecture/validation-prompts/validate-production-guide.cue durante branch claude/resume-mesh-work-jv2MC. Criada em WI-067 commit 06236f6 (batch validate-* per extensão de #ArtifactType). VP declara checks advisory para PG instances (verifiable outputs vc-pg-01 fine-tune, completude do protocolo). Mudança constitutiva; VP conformante a #ValidationPrompt schema."
	}]

	findings: {}

	summary: "Retroativo per adr-069: criação de validation-prompts/validate-production-guide.cue em WI-067 batch (commit 06236f6)."

	singleRoundRationale: "Retroativo cobre criação já validada por adr-061 self-review existente. Round único suficiente."
}
