package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr107RegexPatternMatchKind: build_time.#SelfReviewReport & {
	reportId: "srr-adr-107-regex-pattern-match-kind"

	artifactPath:       "architecture/adrs/adr-107-regex-pattern-match-kind.cue"
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
			Self-review do adr-107 (kind regex-pattern-match + sc-ev-01 + resolve
			def-003). Opção (a) born-warn aprovada pelo founder antes da escrita.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility/blastRadius coerentes. tq-adr-01: alternativa
			rejeitada com motivo (normalizar os 22 no mesmo pass — parentéticos do rew
			precisam migrar p/ description, merece revisão). affectedArtifacts = 4 reais.

			(b) Honestidade sobre born-RED: o ADR declara que sc-ev-01 dispara em 22
			names hoje (não born-green) — born-warn como inventário; promoção a reject
			após normalização. Sem falsa alegação de trava efetiva imediata.

			(c) Verificacao empirica: cue vet ./... EXIT 0; runner --self-test PASS;
			runner default → sc-ev-01 com 22 findings em warn (medido), 0 bloqueantes,
			exit 0. def-003 resolvido (capacidade do kind).
			"""
	}]

	findings: {}

	summary: """
		adr-107 adiciona o kind regex-pattern-match (validação de convenção de formato,
		resolve def-003) e autora sc-ev-01 (event name PascalCase), born-warn —
		disparando nos 22 names ainda não-normalizados como inventário. Trava o
		vocabulário do adr-104 (warn agora; reject após normalizar). Sem findings
		fail/warn no self-review.
		"""

	singleRoundRationale: """
		Uma rodada basta: opção born-warn aprovada antes da escrita; o efeito (22
		findings em warn, 0 bloqueantes) foi medido por cue vet + self-test + runner.
		Sem espaco de decisao aberto a red-team adicional.
		"""
}
