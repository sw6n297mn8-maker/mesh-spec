package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def051: build_time.#SelfReviewReport & {
	reportId: "srr-def-051-manifest-true-coverage"

	artifactPath:       "architecture/deferred-decisions/def-051-manifest-true-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review em sessao: deferimento da true-coverage entidade->manifest. Conforma
			#DeferredDecision (status open; MinRunes OK). trade-off concreto e duplo: (a) nao-expressivel
			com os kinds v1 (exige kind novo declared-id-requires-file); (b) nao-dormante (aggregates/BCs ja
			existem, manifests nao -> o check falharia imediatamente, contra born-warn). Por isso deferida,
			nao materializada no C5 — coerente com adr-144 N6. trigger manual-review (conjuncao kind-novo +
			WI-140, ambos founder-gated). cue vet pass. Sem fail.
			"""
	}]

	findings: {}

	summary: """
		def-051 (true-coverage entidade->manifest; exige kind novo declared-id-requires-file + WI-140).
		Self-review LIMPO: conforma #DeferredDecision; trade-off = nao-expressibilidade v1 + nao-dormancia;
		trigger manual-review justificado. cue vet pass.
		"""

	singleRoundRationale: """
		1 round: conforma ao schema; o trade-off (nao-expressivel agora E falharia trivial) e o motivo de
		deferir, articulado e coerente com adr-144 N6 — sem fail.
		"""
}
