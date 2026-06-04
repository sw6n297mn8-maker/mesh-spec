package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def047: build_time.#SelfReviewReport & {
	reportId: "srr-def-047-drc-dispute-resolution-canonicalization"

	artifactPath:       "architecture/deferred-decisions/def-047-drc-dispute-resolution-canonicalization.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-047 (canonicalização de DisputeResolution no DRC quando ele ganhar
			domain-model — Caminho B de adr-143). Avaliado contra universalCriteria + tq-def-01..04.
			tq-def-01 (trade-off concreto): custo evitado (scope creep — scaffoldar um BC inteiro numa
			fatia de orquestração) vs custo de continuar (dívida pequena; o enum local cobre o caso atual).
			Não é "fazer depois". Pass. tq-def-02 (triggers codificados): adjacent-need file-exists em
			contexts/drc/domain-model.cue conforme #Trigger. Pass. tq-def-03 (≥1 non-manual-review): SIM —
			adjacent-need é automático (path do DRC conhecido, condição binária). Pass. tq-def-04
			(coerência): low + local — taxonomia local mecanicamente reconciliável, escopo restrito ao ACL
			do CMT. Pass. uq-02 (Mesh): ACL consumer, DRC canvas-only, Caminho B, domain-model — específico.
			uq-03: originatingArtifacts (adr-143 + session) válidos. uq-08 (conforma #DeferredDecision):
			status open, MinRunes dos campos, trigger adjacent-need bem-formado; cue vet EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		def-047 defere a canonicalização de DisputeResolution no DRC (hoje canvas-only) — o enum local
		fechado do CMT é ACL consumer até o DRC ganhar domain-model. Trigger adjacent-need file-exists em
		contexts/drc/domain-model.cue (machine-evaluable). low/local. Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Deferral com calibração travada pelo founder (low/local, trigger adjacent-need→DRC domain-model)
		e Caminho B decidido em adr-143; conformance a #DeferredDecision verificável por inspeção direta
		(MinRunes, shape do trigger file-exists, cue vet EXIT=0). Trade-off concreto + trigger non-manual
		machine-evaluable — sem ambiguidade que rounds adicionais resolveriam.
		"""
}
