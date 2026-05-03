package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def012: build_time.#SelfReviewReport & {
	reportId: "srr-def-012"

	artifactPath:       "architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

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
		summary:   "def-012 difere implementação de structural-check sc-be-01 (bootstrap-exception-stale-detection) que detecta automaticamente transient bootstrap exceptions cuja artifactPath passou a ter SRR matching (deveriam sair do policy). Originated em adr-070 promoção de #BootstrapException a schema first-class — schema agora suporta query mecânica mas detection cleanup ainda manual. Trigger 1: file-content-occurrence-count (kind novo per adr-071) path 'governance/build-time/self-review-bootstrap-policy.cue' pattern 'lifecycle:\\s+\"transient\"' threshold=20. Baseline=14 entries; +6 para fire (absorve 1-2 next path-mapping ADRs). Pattern self-match check verified clean: pattern busca whitespace real ('\\s+'); def-012.cue contém escaped literal ('\\\\s+'), não match. Trigger 2: manual-review fallback porque founder pode acionar antes de threshold (e.g., observe primeira stale empirically; OR maturação de outras decisões sobre sc kinds; OR re-priorização). Por que kind file-content-occurrence-count é uso apropriado aqui (não abuse): policy file é singleton governance file; sinal é occurrences dentro do arquivo; recurrence scope=file-content não serve. costOfDeferral: severity low (optimization, não correctness gate), blastRadius local."
	}]

	findings: {}

	summary: "def-012: deferimento de sc-be-01 stale detection structural-check. Trigger automático conservador (file-content-occurrence-count threshold=20) + manual-review fallback."

	singleRoundRationale: "Trigger calibration pre-write per adr-070/adr-071 design; threshold respeita schema; pattern self-match verified clean; round único suficiente."
}
