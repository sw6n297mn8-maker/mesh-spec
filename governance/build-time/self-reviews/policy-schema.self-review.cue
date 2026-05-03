package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

policySchema: build_time.#SelfReviewReport & {
	reportId: "srr-policy-schema"

	artifactPath:       "architecture/artifact-schemas/policy.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

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
		summary:   "Schema #Policy minimal per adr-065: 9 fields (id regex, scope enum, class enum, enforcement literal-locked='external', appliesTo, definition open struct, owner, version int>=1, rationale MinRunes(50)). enforcement: 'external' literal-locked é gate determinístico contra PLR drift de virar engine via cue vet shape. 4 quality criteria (tq-pol-01..04): scope-appliesTo alignment fail, class calibration fail, definition substantivity fail, owner/version discipline warn. 3 fail + 1 warn proporção. _schema.location aponta domain/policies/pol-XXX.cue (analogous a domain/stakeholder-map.cue). Cardinality collection. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema #Policy minimal — registry-only mandate enforced via enforcement literal-locked. 4 quality criteria + path domain/policies/."

	singleRoundRationale: "Schema produto direto de adr-065 + founder ajuste 2 (scope/class/enforcement separation). Round único suficiente — substantive review já no pre-write proposal."
}
