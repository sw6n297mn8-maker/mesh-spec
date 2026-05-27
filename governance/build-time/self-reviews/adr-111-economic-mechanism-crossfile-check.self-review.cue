package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr111EconomicMechanismCrossfileCheck: build_time.#SelfReviewReport & {
	reportId: "srr-adr-111-economic-mechanism-crossfile-check"

	artifactPath:       "architecture/adrs/adr-111-economic-mechanism-crossfile-check.cue"
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
			Self-review do adr-111 (check cross-file economic-mechanism → assumptions).
			Aprovado pelo founder ("autore") após análise da consequência.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "high" + blastRadius "repo-wide". tq-adr-01:
			escopo negativo explícito (não é a ponte negócio↔domínio; não valida
			adequação; não cobre direção reversa). affectedArtifacts = 2 reais.

			(b) Honestidade de escopo: o ADR declara que o check guarda a integridade
			INTERNA do modelo econômico (mecanismo↔assumptions), NÃO a ponte
			negócio↔domínio — apesar de ter surgido daquela conversa.

			(c) Verificacao empirica: protótipo → 9 refs todas resolvem (18 ids
			imp-*/ri-*); cue vet ./... EXIT 0; runner --self-test PASS; runner default
			→ sc-em-01/02 verdes (born-green), M2 descobertos = 0, bucket cross-file
			3→2, 0 bloqueantes, exit 0.
			"""
	}]

	findings: {}

	summary: """
		adr-111 autora sc-em-01/02 (cross-file-id-exists, born-warn/born-green):
		mechanism.enforces→imp-* e protectsAgainst→ri-* no economic-assumption-model.
		Trava a integridade referencial interna do modelo econômico; remove
		economic-mechanism-model do M2 (bucket cross-file 3→2). Sem findings fail/warn.
		"""

	singleRoundRationale: """
		Uma rodada basta: instâncias diretas de kind existente (adr-102), born-green
		verificado por protótipo + cue vet + self-test + runner. Sem espaco de decisao
		aberto a red-team.
		"""
}
