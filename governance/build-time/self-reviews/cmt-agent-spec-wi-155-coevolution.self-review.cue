package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtAgentSpecWi155Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-cmt-agent-spec-wi-155-coevolution"

	artifactPath:       "contexts/cmt/agents/cmt-primary-agent.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-spec.cue"
	artifactType:       "agent-spec"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 1 — coevolução WI-155 (higiene B, adr-175) do agent-spec do
			cmt, a metade mecânica da fatia. PARTIÇÃO (tq-agg-11): 2
			cobertura, 0 exclusão — evt-contract-terms-cancelled-received
			(events; o 3º irmão dos ACL-received de CTR que faltou na
			autoria original — activated/superseded já estavam; ref em
			act-flag-at-risk: compromisso com termos CANCELADOS é avaliado
			para sinalização de risco, invalidação mais grave que
			supersession) e inv-dispute-modify-terms-revalidates-ctr
			(invariants; governa exatamente act-handle-dispute-resolution —
			modify_terms valida sync contra CTR fail-closed; ref + prosa da
			action estendida com o outcome modificar-termos; precedente: o
			cmt lista todas as demais invariants).

			[uq-08]: cue vet EXIT=0. [tq-ag-02]: refs novos ⊆ scope. [uq-09/
			tq-agg-11]: runner confirmou sc-ag-02 do cmt = ZERO.

			[INFO — nota doutrinária, sem ação]: os 5 commands policy-issued
			do cmt permanecem COBERTOS com actions próprias (shape
			pré-existente da autoria do cmt, distinto do carve-out puro que
			bdg/p2p excluíram na higiene A). Cobertos permanecem cobertos —
			a higiene trata descobertos; re-litigar cobertura existente
			seria churn sem drift.
			"""
	}]

	findings: {}

	summary: """
		Coevolução mecânica do agent-spec do cmt: 2 coberturas (o ACL-event
		de cancelamento de termos que faltou + a invariant do modify_terms
		na action de disputa), zero exclusão. sc-ag-02 do cmt a ZERO.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: 2 itens mecânicos com partição pré-cravada
		(Tempo 1) e moradas óbvias em actions existentes; evidência
		determinística (runner zero + vet) reproduzível nesta execução.
		"""
}
