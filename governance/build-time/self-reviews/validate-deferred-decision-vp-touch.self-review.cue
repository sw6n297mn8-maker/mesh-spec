package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

validateDeferredDecisionVpTouch: build_time.#SelfReviewReport & {
	reportId: "srr-validate-deferred-decision-vp-touch"

	artifactPath:       "architecture/validation-prompts/validate-deferred-decision.cue"
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
		summary:   "Retroativo per adr-069 decision item 3. Cobre criação da VP architecture/validation-prompts/validate-deferred-decision.cue durante branch claude/resume-mesh-work-jv2MC. Criada em adr-062 commit 4f6abfc (deferred-decision artifact type bundle: schema + PG + VP + structural-check). VP declara checks advisory para def-XXX instances (genuinidade do trade-off, calibração do trigger, ausência de catch-all). Mudança constitutiva codifica protocolo advisory específico ao tipo; VP conformante a #ValidationPrompt schema."
	}]

	findings: {}

	summary: "Retroativo per adr-069: criação de validation-prompts/validate-deferred-decision.cue em adr-062 (bundle deferred-decision)."

	singleRoundRationale: "Retroativo cobre criação já validada por adr-062 self-review existente. Round único suficiente."
}
