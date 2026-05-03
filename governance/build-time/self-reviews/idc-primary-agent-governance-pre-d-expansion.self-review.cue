package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

idcPrimaryAgentGovernancePreDExpansion: build_time.#SelfReviewReport & {
	reportId: "srr-idc-primary-agent-governance-pre-d-expansion"

	artifactPath:       "contexts/idc/agents/idc-primary-agent.governance.cue"
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
		summary:   "Retroativo per adr-060 (Opção D) cobrindo as touches deste envelope nesta branch: (1) creation completa em commit b62f6c2 (one-shot proposal per founder; 6 escalation routes cobrindo todas categories do agent-spec; blast radius 2/40 onboarding canonical; drift detection 5 métricas IDC-specific; calibração 15/60→50/90; sem autonomyOverrides Phase 0; failure handling como tech debt narrative inicial); (2) modificação em commit 4f40448 via adr-058 (failureHandling promoted from narrative to first-class field per #FailureHandling shape; severity tier máximo raiz de confiança regulatory: suspend-and-escalate em 3 events; retry conservador apenas para fontes externas; 3/24h threshold). Tq-gv-06..15 + tq-gvg-01..09 satisfeitos por inspeção (bidirectional ref válido; lifecycle taxonomy; routing coverage 6/6; caps onboarding range; calibration measurable; P10 em overrides N/A; routing precedence articulada; drift→action bindings declarados; lifecycle×caps monotonicidade; failureHandling first-class; envelope is control plane). cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "Retroativo per adr-060: cobre creation (b62f6c2) + adr-058 modification (4f40448) do envelope IDC. Single round consolidando ambas touches; tq-gv + tq-gvg satisfeitos."

	singleRoundRationale: "Retroativo criado pós-fact em adr-060 commit per founder-approved Opção D plan (gap de CI enforcement identificado retroativamente). Single round porque ambas touches (creation + adr-058 amendment) são part de coordenação atomic em commits que tinham seus próprios reports cobrindo aspectos parciais (srr-adr-058 cobre adr-058 commit; este report cobre o envelope-specific evidence)."
}
