package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr114PromoteCrossfileChecksToReject: build_time.#SelfReviewReport & {
	reportId: "srr-adr-114-promote-crossfile-checks-to-reject"

	artifactPath:       "architecture/adrs/adr-114-promote-crossfile-checks-to-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-27"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-114 (catraca: promover 5 checks cross-file born-green a
			reject). Lista aprovada pelo founder antes da escrita (escolha "1 e depois 4").

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "high" (baixar enforcement reverte numa linha) +
			blastRadius "repo-wide". tq-adr-01: alternativa rejeitada com motivo (manter
			warn não impede drift). affectedArtifacts = 3 structural-check files reais.

			(b) Escopo exato: sc-em-01/02, sc-ccf-01/02, sc-ag-01 (5). sc-cv-02/03 (com
			findings, decisão de produto) e os 71 domain-invariant explicitamente fora —
			sem promover check que bloquearia o CI. A dimensão integrationEvents do
			cross-context-flow já está fora dos checks promovidos (def-021), então a
			promoção não arrasta roadmap.

			(c) Verificacao empirica: os 5 com zero findings ANTES da promoção (medido —
			nenhum dispara); cue vet ./... EXIT 0; runner --self-test PASS; pós-flip → 5
			enforcement reject, runner default 0 bloqueantes, exit 0 (os 21 remanescentes
			são sc-cv-02/03 em warn). A promoção não quebra o CI.

			Nota SRR: os 3 structural-check files já têm SRRs cobrindo seus artifactPath
			(da autoria born-warn em adr-111/112/113); a promoção uniforme (warn→reject) é
			registrada por este ADR, mesmo padrão do adr-109 — sem delta-SRR por arquivo
			para evitar churn de flip uniforme.
			"""
	}]

	findings: {}

	summary: """
		adr-114 promove a reject 5 structural-checks cross-file born-green (sc-em-01/02,
		sc-ccf-01/02, sc-ag-01) — a catraca do adr-097/adr-109 convertendo a cobertura
		que zerou o bucket cross-file do M2 em gate real. Zero findings antes da
		promoção; 0 bloqueantes depois. Sem findings fail/warn. sc-cv-02/03 e os
		domain-invariant ficam fora.
		"""

	singleRoundRationale: """
		Uma rodada basta: a lista de checks foi aprovada pelo founder antes da escrita;
		o estado verde (zero findings) e o efeito (0 bloqueantes pós-promoção) foram
		medidos de forma determinística por cue vet + self-test + runner. Sem espaco de
		decisao aberto a red-team adicional.
		"""
}
