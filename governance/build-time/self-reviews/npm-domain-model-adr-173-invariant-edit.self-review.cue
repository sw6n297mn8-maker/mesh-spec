package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

npmDomainModelAdr173InvariantEdit: build_time.#SelfReviewReport & {
	reportId: "srr-npm-domain-model-adr-173-invariant-edit"

	artifactPath:       "contexts/npm/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da EDIÇÃO per adr-173: inv-single-active-identity
			rule 'para o mesmo CNPJ' → 'para o mesmo identificador legal
			qualificado (esquema, valor — br-cnpj no Brasil, per adr-173)'.
			Edição de 1 campo rule; nome, rationale e semântica de unicidade
			preservados (generalização, não mudança de regra). [uq-08]: cue vet
			EXIT=0. [uq-03]: adr-173 existe na mesma fatia. [uq-01/04/06/07]:
			OK — a regra continua registrando por quê (anti-duplicidade que
			contornaria terminação); constraint preservada; UL alinhada aos
			termos atualizados do glossário npm; zero placeholder. [uq-09]:
			arco de checkpoint único aprovado (batch, pattern def-074).
			"""
	}]

	findings: {}

	summary: """
			Edição do inv-single-active-identity do npm: unicidade generalizada de
		CNPJ para identificador legal qualificado per adr-173. VEREDITO:
		stable, 0 fail.
		"""

	singleRoundRationale: """
			Round único proporcional: generalização de 1 rule executando ADR
		aprovado; verificação substantiva no review isolado da fatia.
		"""
}
