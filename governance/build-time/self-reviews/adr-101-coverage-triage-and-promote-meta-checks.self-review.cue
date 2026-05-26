package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr101CoverageTriageAndPromoteMetaChecks: build_time.#SelfReviewReport & {
	reportId: "srr-adr-101-coverage-triage-and-promote-meta-checks"

	artifactPath:       "architecture/adrs/adr-101-coverage-triage-and-promote-meta-checks.cue"
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
			Self-review do adr-101 (triagem dos 29 tipos restantes em isenções
			registradas + promoção de M1/M2 a reject). Aprovado pelo founder ("1":
			isentar + promover). Confirmacoes:

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural" (promove 2 gates + registra 29 decisoes de cobertura);
			reversibility "medium" + blastRadius "repo-wide"; defersTo ["def-002"].
			tq-adr-01: 2 alternativas rejeitadas com motivo (manter warn = sem garantia
			forward; autorar checks rasos agora = cerimonia, os de valor estao em
			def-002). affectedArtifacts = meta-coverage.cue (path real e alterado).

			(b) Anti-dumping-ground (adr-062): as 29 isenções sao categorizadas (P=18
			permanente shape/engine; def-002=8 cross-file justificado; follow-on=3
			expressavel-mas-adiado), cada uma com rationale e, quando adiada, pointer
			explicito. Nao e dump — e decisao revisavel.

			(c) Verificacao empirica: cue vet ./... EXIT 0; com as 29 isenções M2
			reporta ZERO descobertos (sc-meta-02 nao dispara); promovido a reject,
			runner default exit 0 (os 21 remanescentes sao sc-cv-02/03 em warn). Teste
			ADVERSARIAL: schema-probe de tipo governado sem cobertura → sc-meta-02 FAIL,
			exit 1; pos-revert exit 0 — a promocao tem dentes (gate real).

			(d) Cobertura != adequacao mantido explicito (P10): M2 garante existencia de
			check/decisao, nao suficiencia do check.
			"""
	}]

	findings: {}

	summary: """
		adr-101 fecha o arco da meta-cobertura: registra as 29 isenções restantes
		(categorizadas P/def-002/follow-on, anti-dumping per adr-062) e promove M1/M2
		a reject. M2 nasce verde como gate (zero descobertos); teste adversarial
		confirma que tipo novo sem cobertura passa a falhar o CI. Sem findings
		fail/warn. defersTo def-002 (8 isenções cross-file).
		"""

	singleRoundRationale: """
		Uma rodada basta: a decisao (isentar + promover) foi aprovada pelo founder; a
		triagem ja vinha de adr-099/100; e a verificacao (cue vet, M2=0, promocao
		exit 0, teste adversarial exit 1) e deterministica e passou. Sem espaco de
		decisao aberto a red-team adicional.
		"""
}
