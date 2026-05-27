package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr109PromoteGreenChecksToReject: build_time.#SelfReviewReport & {
	reportId: "srr-adr-109-promote-green-checks-to-reject"

	artifactPath:       "architecture/adrs/adr-109-promote-green-checks-to-reject.cue"
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
			Self-review do adr-109 (catraca: promover 10 checks born-green a reject).
			Lista de checks aprovada pelo founder antes da escrita.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "high" (baixar enforcement reverte) + blastRadius
			"repo-wide". tq-adr-01: alternativa rejeitada com motivo (manter warn não
			impede drift). affectedArtifacts = 4 structural-check files reais.

			(b) Escopo exato: sc-cm-01..06, sc-te-02, sc-dd-01/02, sc-sv-01 (10).
			sc-cv-02/03 (com findings, decisão de produto) e sc-te-01 explicitamente
			fora — sem promover check que bloquearia o CI.

			(c) Verificacao empirica: os 10 com zero findings ANTES da promoção
			(medido — nenhum dispara); cue vet ./... EXIT 0; runner --self-test PASS;
			pós-flip → 10 enforcement reject, runner default 0 bloqueantes, exit 0 (os 21
			remanescentes são sc-cv-02/03 em warn). A promoção não quebra o CI.

			Nota SRR: os 4 structural-check files já têm SRRs cobrindo seus artifactPath
			(da autoria born-warn); a promoção uniforme (warn→reject) é registrada por
			este ADR. Sem delta-SRR por arquivo para evitar churn de flip uniforme.
			"""
	}]

	findings: {}

	summary: """
		adr-109 promove a reject 10 structural-checks born-green (sc-cm-01..06,
		sc-te-02, sc-dd-01/02, sc-sv-01) — a catraca do adr-097 convertendo cobertura
		nominal em gate real. Zero findings antes da promoção; 0 bloqueantes depois.
		Sem findings fail/warn. sc-cv-02/03 e sc-te-01 ficam fora.
		"""

	singleRoundRationale: """
		Uma rodada basta: a lista de checks foi aprovada pelo founder antes da escrita;
		o estado verde (zero findings) e o efeito (0 bloqueantes pós-promoção) foram
		medidos de forma determinística por cue vet + self-test + runner. Sem espaco de
		decisao aberto a red-team adicional.
		"""
}
