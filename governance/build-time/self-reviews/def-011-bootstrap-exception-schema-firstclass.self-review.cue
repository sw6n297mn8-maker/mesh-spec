package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def011: build_time.#SelfReviewReport & {
	reportId: "srr-def-011"

	artifactPath:       "architecture/deferred-decisions/def-011-bootstrap-exception-schema-firstclass.cue"
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
		summary:   "def-011 difere promoção de #BootstrapException a schema first-class (campos category enum, lifecycle enum, exitCondition + structural-check de stale detection). Originated em adr-067 quando 3ª categoria de bootstrap exception (pre-mapping-transient) foi introduzida com 4 entries em batch único — volume insuficiente para generalização (ten-009 expand-when-needed). Trigger 1: recurrence scope=filename pattern '^architecture/adrs/adr-\\d+-extend-artifact-type-for-.*\\.cue$' threshold=4 (calibrado per founder articulation: conta hoje=3, dispara na 4ª ocorrência). Trigger 2: manual-review fallback porque schema atual sem field category/lifecycle não permite contagem mecânica de transient exceptions sem parser de prose. costOfDeferral: severity low, blastRadius local. Pattern self-match check verified clean: def-011 não vive em adrs/."
	}]

	findings: {}

	summary: "def-011: deferimento de schema first-class para #BootstrapException. Recurrence threshold=4 sobre path-mapping ADRs + manual-review fallback."

	singleRoundRationale: "Trigger calibration pre-write per founder explicit guidance; threshold respeita schema; round único suficiente."
}
