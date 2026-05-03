package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def004: build_time.#SelfReviewReport & {
	reportId: "srr-def-004"

	artifactPath:       "architecture/deferred-decisions/def-004-formalize-tq-as-05-or-convert-references.cue"
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
		summary:   "def-004 captura dívida real surfaced pelo review subagent durante WI-069 first dispatch (uq-03 finding): tq-as-05 referenciado em ~30 lugares no repo mas nunca formalmente definido em #ArtifactSchema._qualityCriteria. Review explicit: 'NÃO é defeito introduzido por este PG — shared problem do repo'. Trade-off articulado: cleanup mecânico (~30 refs) vs continuar com convenção informal funcionando operacionalmente. 2 triggers calibrados: volume-threshold via recurrence pattern 'tq-as-05' threshold=35 (baseline ~30 + commits desta sessão ~3-5 → threshold capture growth +50%) + manual-review escape para founder priorizar durante schema cleanup major futuro. Runner validated: count=7 < threshold=35 (esperado — primeira commit registrando)."
	}]

	findings: {}

	summary: "def-004: deferimento formal de tq-as-05 dívida (surfaced por review subagent WI-069). Trigger via volume-threshold codificado captura growth da convenção informal."

	singleRoundRationale: "Deferimento bem-fitting ao critério #DeferredDecision: trade-off articulado (formalize vs convert vs continuar) + condição codificada (volume threshold). Calibração inicial conservadora — refinement futuro se sinal recorre. Round único suficiente."
}
