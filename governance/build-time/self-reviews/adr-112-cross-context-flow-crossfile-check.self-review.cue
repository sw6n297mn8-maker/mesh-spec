package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr112CrossContextFlowCrossfileCheck: build_time.#SelfReviewReport & {
	reportId: "srr-adr-112-cross-context-flow-crossfile-check"

	artifactPath:       "architecture/adrs/adr-112-cross-context-flow-crossfile-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
			Self-review do adr-112 (check cross-file cross-context-flow →
			context-map/subdomains). Aprovado pelo founder ("2") após análise da
			consequência.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "high" + blastRadius "repo-wide".
			affectedArtifacts = 3 reais (cross-context-flow.cue, meta-coverage.cue,
			def-021). defersTo = def-021. tq-adr-01: escopo negativo explícito (não
			cobre integrationEvents [def-021]; não promove a reject; não cobre direção
			reversa; resta agent-spec).

			(b) Honestidade de escopo: o ADR gateia só as âncoras ESTRUTURAIS
			(ownerContext/ownerSubdomain) e defere conscientemente a dimensão
			integrationEvents (3 de 9 refs não resolvem: BudgetCommitted/
			CommitmentClosed built-incompleto, PaymentSettled→fce planejado) — não
			gateia cru para evitar born-red. Mesma natureza do def-019.

			(c) Verificacao empirica: protótipo → ownerContext (bdg/cmt/dlv/fce/inv)
			∈ 25 contexts; ownerSubdomain ∈ 26 subdomain codes; cue vet ./... EXIT 0;
			runner --self-test PASS; runner default → sc-ccf-01/02 verdes (born-green),
			M2 descobertos = 0, bucket cross-file 2→1 (resta agent-spec), 0
			bloqueantes, exit 0.
			"""
	}]

	findings: {}

	summary: """
		adr-112 autora sc-ccf-01/02 (cross-file-id-exists, born-warn/born-green):
		phase.ownerContext→context-map e phase.ownerSubdomain→subdomains/*.cue no
		cross-context-flow. Trava a integridade referencial das âncoras estruturais
		do flow; remove cross-context-flow do M2 (bucket cross-file 2→1, resta
		agent-spec); defere a dimensão integrationEvents a def-021. Sem findings
		fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: instâncias diretas de kind existente (adr-102), born-green
		verificado por protótipo + cue vet + self-test + runner; a dimensão não-green
		(integrationEvents) é deferida (def-021), não improvisada. Sem espaco de
		decisao aberto a red-team.
		"""
}
