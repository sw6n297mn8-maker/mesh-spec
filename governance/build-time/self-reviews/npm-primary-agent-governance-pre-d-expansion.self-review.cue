package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

npmPrimaryAgentGovernancePreDExpansion: build_time.#SelfReviewReport & {
	reportId: "srr-npm-primary-agent-governance-pre-d-expansion"

	artifactPath:       "contexts/npm/agents/npm-primary-agent.governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-governance.cue"
	artifactType:       "agent-governance"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Retroativo per adr-060 (Opção D) cobrindo a touch deste envelope durante adr-058 (commit 4f40448): adicionado bloco failureHandling per nova schema field #FailureHandling (suspend-and-escalate em 3 events com defaults conservadores Phase 0; retryPolicy 'max 1 retry exponential backoff' em onTimeout; threshold '3 failures' / timeWindow '24h' em onRepeatedFailure). Mudança coordenada com schema delta + PG-B updates + 3 outras envelopes via adr-058. NPM é gateway da rede; failure handling alinhado com criticality de qualificação cross-BC (CTR/SSC e indiretamente BCs downstream). cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Retroativo per adr-060: cobre touch do envelope NPM durante adr-058 (failureHandling block adicionado per schema delta). Single round; defaults conservadores Phase 0."

	singleRoundRationale: "Retroativo criado pós-fact em adr-060 commit per founder-approved Opção D plan. Touch original era extension trivial via adr-058 schema delta; single round reflete a touch específica."
}
