package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

idcPrimaryAgentAdr173ValidatorEdit: build_time.#SelfReviewReport & {
	reportId: "srr-idc-primary-agent-adr-173-validator-edit"

	artifactPath:       "contexts/idc/agents/idc-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

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
			Round 1 — self-review da EDIÇÃO per adr-173 na action
			act-validate-cnpj-format: description atualizada (validação do
			identificador legal PER ESQUEMA; br-cnpj mantém formato + dígitos
			verificadores) e domainModelRefs 'vo-cnpj-identifier' →
			'vo-legal-entity-identifier'. Código da action PRESERVADO (churn
			zero em governança de agente, per adr-173 decision item 3).
			[uq-08]: cue vet EXIT=0. [uq-03]: a ref atualizada resolve no
			domain-model editado em par — exatamente o que o gate sc-ag-01
			verifica; runner sem violação sc-ag-*. [uq-01/04/06/07]: OK.
			[uq-09]: arco de checkpoint único aprovado (batch).
			"""
	}]

	findings: {}

	summary: """
			Agent do idc alinhado ao adr-173: validador vira per-esquema, ref ao VO
		novo, action code preservado. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
			Round único proporcional: 1 action editada em par com o domain-model;
		o gate sc-ag-01 é a verificação determinística do par.
		"""
}
