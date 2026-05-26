package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr106ReduceCrossfileExemptionBucket: build_time.#SelfReviewReport & {
	reportId: "srr-adr-106-reduce-crossfile-exemption-bucket"

	artifactPath:       "architecture/adrs/adr-106-reduce-crossfile-exemption-bucket.cue"
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
			Self-review do adr-106 (redução do bucket cross-file do M2). Plano e
			ajustes de direção aprovados pelo founder antes da escrita.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility/blastRadius coerentes. tq-adr-01: alternativa
			rejeitada com motivo (autorar os 8 de uma vez — 3 sem ref, 3 com risco
			vocabulário; ruído). affectedArtifacts = 3 paths reais.

			(b) Reusa kinds existentes (filesystem-path-exists, cross-file-id-exists) —
			sem kind novo. Recategorização honesta (subdomain/stakeholder-map sem ref →
			P; policy sem instâncias) em vez de forçar def-002 (adr-062 anti-catch-all).
			Deferidos com rationale específico (não placeholder genérico).

			(c) Verificacao empirica: investigação dos 8 (instâncias + campos);
			cue vet ./... EXIT 0; runner --self-test PASS; runner default → sc-dd-01/02
			e sc-sv-01 verdes (design-principles.cue, stakeholder-map.cue existem; ctr
			declarado), M2 descobertos = 0, 0 bloqueantes, exit 0. Bucket cross-file
			8 → 3.
			"""
	}]

	findings: {}

	summary: """
		adr-106 reduz o bucket cross-file do M2 de 8 para 3: autora 3 checks reais
		born-green (domain-definition designPrinciplesRef/stakeholderMapRef via
		filesystem-path-exists; service-contract boundedContextRef via
		cross-file-id-exists), recategoriza honestamente subdomain/stakeholder-map (P,
		sem ref) e policy (sem instâncias), e defere agent-spec/economic-mechanism/
		cross-context-flow com rationale específico. Sem kind novo. Sem findings
		fail/warn; M2 segue em zero descobertos.
		"""

	singleRoundRationale: """
		Uma rodada basta: plano e ajustes aprovados pelo founder antes da escrita;
		born-green dos 3 checks e M2=0 verificados por investigação + cue vet +
		self-test + runner. Sem espaco de decisao aberto a red-team.
		"""
}
