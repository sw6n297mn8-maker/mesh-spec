package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr105ScopedCrossFileIdExistsKind: build_time.#SelfReviewReport & {
	reportId: "srr-adr-105-scoped-cross-file-id-exists-kind"

	artifactPath:       "architecture/adrs/adr-105-scoped-cross-file-id-exists-kind.cue"
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
			Self-review do adr-105 (kind scoped-cross-file-id-exists + sc-cm-06 +
			resolve def-019). Nome e design (guard = ambos endpoints built) aprovados
			pelo founder antes da escrita.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility/blastRadius coerentes. tq-adr-01: alternativa
			rejeitada com motivo (hardcode da lógica built↔built no runner = débito
			estilo GOVERNED_ELSEWHERE; allowance fica declarativa). affectedArtifacts =
			4 paths reais.

			(b) Design: gêmeo guardado do cross-file-id-exists (adr-102); a allowance
			built↔built é DECLARATIVA (guardFields + guardPresenceGlob). Propriedade
			notável registrada: o check AUTO-EXPANDE quando um BC planejado materializa
			seu domain-model (entra no escopo sem editar o check).

			(c) Verificacao empirica: cue vet ./... EXIT 0; runner --self-test PASS;
			runner default → sc-cm-06 verde (0 missing built↔built, sobre a base
			canônica do adr-104), 0 bloqueantes, exit 0. Resolve def-019.
			"""
	}]

	findings: {}

	summary: """
		adr-105 adiciona o kind scoped-cross-file-id-exists (cross-ref guardado por
		presença, allowance declarativa para forward-declarations), autora sc-cm-06
		(events↔BC built↔built, born-green) e resolve def-019. Sem findings fail/warn.
		Verificação: sc-cm-06 verde, 0 bloqueantes, cue vet 0.
		"""

	singleRoundRationale: """
		Uma rodada basta: nome e design aprovados pelo founder antes da escrita;
		born-green verificado sobre a base canônica do adr-104 (cue vet + self-test +
		runner). Sem espaco de decisao aberto a red-team adicional.
		"""
}
