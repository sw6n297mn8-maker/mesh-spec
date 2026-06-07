package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

manifestRefIntegrity: build_time.#SelfReviewReport & {
	reportId: "srr-manifest-ref-integrity"

	artifactPath:       "architecture/structural-checks/manifest-ref-integrity.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

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
			Self-review em sessao: 2 checks — sc-mri-01 (boundedContextRef -> strategic/context-map.cue
			contexts[].context, espelha o padrao provado de sc-sv-01) + sc-mri-02 (aggregateRef ->
			contexts/*/domain-model.cue aggregates[].code), kind cross-file-id-exists plain, born-warn.
			Anchors confirmados no disco por grep: context-map tem contexts[].context; domain-model declara
			aggregates por .code (nao .id). artifactType port-manifest (sc-mri-01) / aggregate-manifest
			(sc-mri-02). Dormant-safe: 0 instancias -> 0 violacoes. O scoping plain-vs-instance-scoped fica
			rastreado em def-052. Materializa o item 5(b). cue vet pass. Sem fail.
			"""
	}]

	findings: {}

	summary: """
		manifest-ref-integrity.cue (2x cross-file-id-exists plain). Self-review LIMPO: paths-alvo
		verificados no disco (contexts[].context; aggregates[].code), conforma #StructuralCheck, materializa
		o item 5(b) do adr-144, born-warn e dormant-safe; aperto same-BC deferido a def-052. cue vet pass.
		"""

	singleRoundRationale: """
		1 round: os paths-alvo foram verificados existentes no disco (grep), o kind tem evaluator, os
		checks sao dormant-safe e materializam o item 5(b) ja isolada-revisado — sem fail.
		"""
}
