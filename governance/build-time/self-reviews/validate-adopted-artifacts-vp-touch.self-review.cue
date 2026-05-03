package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

validateAdoptedArtifactsVpTouch: build_time.#SelfReviewReport & {
	reportId: "srr-validate-adopted-artifacts-vp-touch"

	artifactPath:       "architecture/validation-prompts/validate-adopted-artifacts.cue"
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
		summary:   "Retroativo per adr-069 decision item 3. Cobre criação da VP architecture/validation-prompts/validate-adopted-artifacts.cue durante branch claude/resume-mesh-work-jv2MC. Criada em adr-061 commit 06236f6 (WI-067 batch validate-* per extensão de #ArtifactType). VP declara matchPatterns + checks para adopted-artifacts singleton. Mudança constitutiva codifica protocolo advisory de design review; VP conformante a #ValidationPrompt schema."
	}]

	findings: {}

	summary: "Retroativo per adr-069: criação de validation-prompts/validate-adopted-artifacts.cue em adr-061 (WI-067 batch)."

	singleRoundRationale: "Retroativo cobre criação já validada por adr-061 self-review existente. Round único suficiente."
}
