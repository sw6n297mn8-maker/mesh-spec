package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

metaCoverageTriagePromotion: build_time.#SelfReviewReport & {
	reportId: "srr-meta-coverage-triage-promotion"

	artifactPath:       "architecture/structural-checks/meta-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Delta (adr-101) em meta-coverage.cue: sc-meta-02.rule.exemptTypes populado
			com as 29 isenções (era []), e enforcement de sc-meta-01 e sc-meta-02
			promovido de "warn" para "reject". Aprovado pelo founder.

			Conformancia #StructuralCheck: exemptTypes conforma
			#StructuralCheckCoverageRule (lista de {type, rationale} non-empty);
			enforcement "reject" e valor valido do enum; ids/kind/errorMessage/rationale
			intactos. cue vet ./... EXIT 0.

			Cobertura das 29 isenções (cada uma com type + rationale categorizada):
			- 18 (P): authoring-policy, quality-gate, self-review-bootstrap-policy,
			  self-review-ci-policy, subagent-execution-log, validation-findings-w001,
			  quality-criteria, readme-config, repo-structure, design-principles,
			  shared-types, task-template, lens, validation-prompt,
			  economic-assumption-model, glossary, api-spec, agent-governance.
			- 8 (def-002): cross-context-flow, subdomain, domain-definition,
			  stakeholder-map, agent-spec, service-contract, economic-mechanism-model,
			  policy.
			- 3 (follow-on): wave-plan, deferred-decision, adopted-artifacts.

			Verificacao empirica: com as isenções, M2 reporta ZERO descobertos
			(sc-meta-02 nao dispara); promovido a reject, runner default exit 0. Teste
			adversarial (schema-probe sem cobertura) → sc-meta-02 FAIL/exit 1, revertido
			→ exit 0. A promocao bloqueia tipo novo descoberto por construcao.
			"""
	}]

	findings: {}

	summary: """
		meta-coverage.cue: exemptTypes populado com as 29 isenções categorizadas
		(P/def-002/follow-on) e M1/M2 promovidos a reject (adr-101). Conforma
		#StructuralCheck; M2 nasce verde como gate (zero descobertos). Sem findings
		fail/warn. Verificado por cue vet + execucao + teste adversarial.
		"""

	singleRoundRationale: """
		Uma rodada basta: o delta (popular exemptTypes + flipar enforcement) executa
		decisao aprovada em adr-101, com conformidade e efeito verificados de forma
		deterministica (cue vet, M2=0, exit 0, teste adversarial exit 1). Sem espaco
		de decisao aberto a red-team.
		"""
}
