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
		summary:   "Schema #DeferredDecision com discriminated union sobre 4 status (open/triggered/resolved/withdrawn) — fields auxiliares (triggeredAt, triggeredCondition, resolvedBy, withdrawalRationale) habilitados/proibidos por status. Pattern análogo a #ADR (status ↔ supersededBy). #Trigger union de 5 kinds (recurrence, adjacent-need, volume-threshold, temporal, manual-review); #AdjacentCondition union v1 minimal de 2 kinds (file-exists, file-contains). #OriginRef admite path .cue ou session:<slug>. _qualityCriteria com 4 critérios (tq-def-01 fail trade-off, tq-def-02 fail triggers codificados, tq-def-03 warn ≥1 non-manual-review, tq-def-04 warn cost coherence). cue vet ./... EXIT=0. AMENDMENT (2026-05-03 per adr-071): #Trigger union estendida com 6º kind 'file-content-occurrence-count' (path + pattern + threshold). USO RESTRITO documentado em comment + adr-071 rationale: trigger de singleton governance file (conta occurrences regex DENTRO de UM arquivo, não files com matches across repo). Distinto de scope=file-content. Originado em def-012 use case (monitorar crescimento de transient bootstrap exceptions em policy file). Conditions for revisit declaradas em adr-071: 2nd use case dentro de N meses valida; ausência de 2nd use case após 3+ next path-mapping ADRs sugere over-built."
	}]

	findings: {}

	summary: "Schema first-class para deferimento consciente governado, post-3-rounds red-team. Discriminated union enforce lifecycle; triggers codificados machine-evaluable. Amendment per adr-071 adiciona file-content-occurrence-count kind (uso restrito a singleton governance files)."

	singleRoundRationale: "Schema produto direto de ADR-062 + 3 rounds de red-team via chat. Round único suficiente — substantive review já incorporado em design. Amendment per adr-071 cobre extensão atômica ao kind union."
}
