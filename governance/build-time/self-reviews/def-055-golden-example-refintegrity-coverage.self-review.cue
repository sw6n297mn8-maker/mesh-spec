package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def055GoldenExampleRefintegrity: build_time.#SelfReviewReport & {
	reportId: "srr-def-055-golden-example-refintegrity-coverage"

	artifactPath:       "architecture/deferred-decisions/def-055-golden-example-refintegrity-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-08"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-055 (cobertura de ref-integrity do #GoldenExample). tq-def-01: deferralRationale
			articula trade-off concreto -- custo evitado (check estatico redundante com o harness WI-137 que
			exercita os refs) vs custo de continuar (golden-example governado-sem-cobertura se WI-137 abandonar);
			nao "fazer depois". tq-def-02: 2 triggers codificados (#Trigger union) -- adjacent-need file-exists em
			scripts/ci/validate-codegen.sh + manual-review. tq-def-03 (warn): satisfeito -- ha trigger
			non-manual-review (adjacent-need); o manual-review cobre o desfecho ABANDONAR (estado, nao file-exists
			positivo). tq-def-04 (warn): costOfDeferral low + cross-artifact coerente (a ref cruza fronteira de
			artefato; custo baixo por review + harness + <=1 instancia). originatingArtifacts: adr-145 + golden-example
			schema. status open. Governa o reopening da isencao de structural-check (adr-145 item 6 / sc-meta-02
			exemptType harness), tornando-o adr-062-consistente (defersTo->def vs prosa solta).
			"""
	}]

	findings: {}

	summary: """
		def-055 defere a cobertura de ref-integrity do #GoldenExample (isenta em sc-meta-02, categoria harness) com
		trade-off articulado e 2 triggers (file-exists no harness WI-137 -> cobertura realizada; manual-review ->
		abandono). Self-review LIMPO (tq-def-01/02 fail-criteria pass; tq-def-03/04 warn pass). adr-145.defersTo e o
		exemptType do meta-coverage agora apontam def-055 (adr-062-consistente: defersTo->def, nao prosa). cue vet 0.
		"""

	singleRoundRationale: """
		1 round: o deferimento tem trade-off concreto (redundancia-com-harness vs governado-sem-cobertura-se-abandona),
		triggers codificados (adjacent-need file-exists + manual-review para o desfecho de estado) e custo coerente;
		conforma #DeferredDecision sem fail. Nada a iterar.
		"""
}
