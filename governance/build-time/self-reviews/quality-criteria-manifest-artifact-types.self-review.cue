package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

qualityCriteriaManifestTypes: build_time.#SelfReviewReport & {
	reportId: "srr-quality-criteria-manifest-artifact-types"

	artifactPath:       "architecture/artifact-schemas/quality-criteria.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-05"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Re-review isolado dedicado da extensao do enum #ArtifactType (sub-agente fresco): 5/5 PASS, 0
			fail / 0 warn. A adicao de "port-manifest" e "aggregate-manifest" e APPEND NAO-DESTRUTIVO — os
			31 membros pre-existentes permanecem intactos e na mesma ordem; o membro antes terminal recebeu
			o pipe de continuacao. Abreviacoes pm/am sem colisao com as existentes (2 chars, dentro do
			regex). Monotonico para os consumidores (#StructuralCheck.artifactType, #ValidationPrompt) e e
			justamente o pre-requisito que destrava os structural-checks manifest-conformance/
			manifest-ref-integrity (que ja declaram esses artifactTypes). 2 info same-arc: o descritor 'validados na pratica' do header excluiria os born-green --
			apertado neste arco para incluir tipos que entram no regime de self-review; sem validation-prompt
			cobrindo-os (advisory, P10 — cobertura via structural-checks determinísticos).
			"""
	}]

	findings: {}

	summary: """
		quality-criteria.cue (enum #ArtifactType += port-manifest/aggregate-manifest + abreviacoes pm/am).
		Re-review isolado dedicado LIMPO (0 fail / 0 warn): append nao-destrutivo, sem colisao de
		abreviacao, monotonico para consumidores — pre-condicao que destrava os sc-checks de manifest. 2
		info same-arc nao-bloqueantes.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: a mudanca e um append puro a uma union de string literals (monotonico, sem
		conflito de unificacao), confirmado nao-destrutivo pelo re-review isolado dedicado e por cue vet.
		"""
}
