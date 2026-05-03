package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

deferredDecisionSchema: build_time.#SelfReviewReport & {
	reportId: "srr-deferred-decision-schema"

	artifactPath:       "architecture/artifact-schemas/deferred-decision.cue"
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
		summary:   "Schema #DeferredDecision com discriminated union sobre 4 status (open/triggered/resolved/withdrawn) — fields auxiliares (triggeredAt, triggeredCondition, resolvedBy, withdrawalRationale) habilitados/proibidos por status. Pattern análogo a #ADR (status ↔ supersededBy). #Trigger union de 5 kinds (recurrence, adjacent-need, volume-threshold, temporal, manual-review); #AdjacentCondition union v1 minimal de 2 kinds (file-exists, file-contains). #OriginRef admite path .cue ou session:<slug>. _qualityCriteria com 4 critérios (tq-def-01 fail trade-off, tq-def-02 fail triggers codificados, tq-def-03 warn ≥1 non-manual-review, tq-def-04 warn cost coherence). cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Schema first-class para deferimento consciente governado, post-3-rounds red-team. Discriminated union enforce lifecycle; triggers codificados machine-evaluable."

	singleRoundRationale: "Schema produto direto de ADR-062 + 3 rounds de red-team via chat. Round único suficiente — substantive review já incorporado em design."
}
