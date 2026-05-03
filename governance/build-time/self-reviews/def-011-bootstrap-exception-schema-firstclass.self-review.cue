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
		summary:   "def-011 difere promoção de #BootstrapException a schema first-class (campos category enum, lifecycle enum, exitCondition + structural-check de stale detection). Originated em adr-067 quando 3ª categoria de bootstrap exception (pre-mapping-transient) foi introduzida com 4 entries em batch único — volume insuficiente para generalização (ten-009 expand-when-needed). Trigger 1: recurrence scope=filename pattern '^architecture/adrs/adr-\\d+-extend-artifact-type-for-.*\\.cue$' threshold=4 (calibrado per founder articulation: conta hoje=3, dispara na 4ª ocorrência). Trigger 2: manual-review fallback porque schema atual sem field category/lifecycle não permite contagem mecânica de transient exceptions sem parser de prose. costOfDeferral: severity low, blastRadius local. Pattern self-match check verified clean: def-011 não vive em adrs/. RESOLUTION (2026-05-03): trigger 1 fired duas vezes consecutivas em adr-068 (count 3→4) e adr-069 (count 4→5); founder articulou active reconsideration; resolved por adr-070 (schema first-class promotion: category + lifecycle + exitCondition?, sem conditional category→lifecycle por enquanto, migration declarativa de 20 entries existentes). Stale detection structural-check deferida adicionalmente per def-012."
	}]

	findings: {}

	summary: "def-011: deferimento de schema first-class para #BootstrapException — RESOLVED por adr-070 após 2 trigger refires consecutivos. Stale detection sc deferida em def-012."

	singleRoundRationale: "Trigger calibration pre-write per founder explicit guidance; threshold respeita schema; round único suficiente. Resolution amendment cobre conclusão do lifecycle."
}
