package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr102CrossFileIdExistsKind: build_time.#SelfReviewReport & {
	reportId: "srr-adr-102-cross-file-id-exists-kind"

	artifactPath:       "architecture/adrs/adr-102-cross-file-id-exists-kind.cue"
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
			Self-review do adr-102 (kind cross-file-id-exists, resolve def-002, +
			primeiro check sc-te-02). Escopo contido e wording aprovados pelo founder
			antes da escrita. Confirmacoes:

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "medium" + blastRadius "repo-wide".
			tq-adr-01: alternativa rejeitada com motivo (estender filesystem-path-exists
			confunde path-no-disco com id-em-artefato). affectedArtifacts = 5 paths
			reais e alterados.

			(b) Wording-care do founder RESPEITADO: o ADR afirma explicitamente que o
			resolvido e a CAPACIDADE (kind generico existe), NAO "todas as referencias
			cross-file cobertas"; checks especificos sao incrementais. Escopo negativo
			(events↔BC, context↔disco) declarado com o motivo (risco plannedIn).

			(c) Verificacao empirica: cue vet ./... EXIT 0; runner --self-test PASS;
			protótipo → relatedADR born-green (5/5 existem entre 99 ADR ids); runner
			default → sc-te-02 verde, 0 bloqueantes, exit 0.

			(d) Consistencia da meta-cobertura: as 8 isenções "(def-002)" foram
			atualizadas (def-002 deixou de estar deferido) — nao afirmam mais "exige
			cross-file-id-exists deferido"; a isencao vale ate o check do tipo existir.
			"""
	}]

	findings: {}

	summary: """
		adr-102 adiciona o kind cross-file-id-exists (resolve def-002 no sentido de
		CAPACIDADE — nao cobertura total) e autora o primeiro check born-green
		sc-te-02 (tension-entry.relatedADR → ADR ids). Sem findings fail/warn.
		Wording-care respeitado: checks especificos sao incrementais; events↔BC e
		context↔disco ficam para pass dedicado (risco plannedIn).
		"""

	singleRoundRationale: """
		Uma rodada basta: escopo contido e wording aprovados pelo founder antes da
		escrita; viabilidade verificada por protótipo born-green + cue vet +
		self-test + execucao. Sem espaco de decisao aberto a red-team adicional.
		"""
}
