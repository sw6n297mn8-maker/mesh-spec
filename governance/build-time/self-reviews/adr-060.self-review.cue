package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr060: build_time.#SelfReviewReport & {
	reportId: "srr-adr-060"

	artifactPath:       "architecture/adrs/adr-060-extend-artifact-type-for-path-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
		summary:   "ADR-060 (extend artifact_type_for_path) founder-approved Opção D escope (sessão 2026-05-01). Discovery: scripts/ci/check-self-review.sh artifact_type_for_path mapping não cobria contexts/*/agents/*-primary-agent.cue (agent-spec) nem contexts/*/agents/*.governance.cue (agent-governance) — gap de governance enforcement identificado durante autoria de idc-primary-agent.governance.cue + amendments F1/F2/F3 de idc-primary-agent.cue. 4 alternativas (a-d): status quo rejected; only agent-governance rejected (asymmetric); both agent-spec + agent-governance recommended (este); all instance types rejected (scope creep). 6 decision items. 4P/4N consequences. tq-adr-01 satisfeito (4 alternativas com motivos); tq-adr-02 satisfeito (reversibility 'high' por script edit aditivo + zero data persisted; blastRadius 'cross-cutting' por afetar todos agent instances current + future); tq-adr-03 satisfeito (paths reais — scripts/ci/check-self-review.sh existing-altered em affectedArtifacts; 6 self-reviews new-created em plannedOutputs incluindo este). principlesApplied P10/P12 verificados. uq-02 specificity passa (b62f6c2, F1/F2/F3 amendments, adr-013/014/015, scripts/ci real path). cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: "ADR-060 estende CI artifact_type_for_path para cobrir agent-spec + agent-governance instances. Script edit + 4 retroativos para arquivos modificados nesta branch. Gap de governance enforcement fechado per founder-approved Opção D."

	singleRoundRationale: "Decisão founder-approved single coordinated commit. Script edit puramente aditivo; ADR + script + retroativos formam unidade lógica. Round 1 verifica: cue vet EXIT=0; CI script local mostra agent-* paths agora detectados; reports retroativos cobrem 4 modificações in flight (cmt/npm/idc envelopes + idc agent-spec); ctr envelope já tem report existente (ctr-primary-agent-governance.self-review.cue) que CI matches automaticamente."
}
