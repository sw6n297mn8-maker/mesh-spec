package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr110GateLivenessM3: build_time.#SelfReviewReport & {
	reportId: "srr-adr-110-gate-liveness-m3"

	artifactPath:       "architecture/adrs/adr-110-gate-liveness-m3.cue"
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
			Self-review do adr-110 (M3 liveness do gate). Abordagem (a)+(b) aprovada
			pelo founder após eu surfacer o paradoxo da raiz de confiança.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "high" + blastRadius "repo-wide". tq-adr-01:
			alternativa rejeitada com motivo (M3 como structural-check in-runner =
			autoengano pelo paradoxo). affectedArtifacts = 2 (.github workflows).

			(b) Honestidade central registrada: M3 NÃO pode ser um gate in-runner (o
			runner não prova a própria invocação); a raiz de confiança é externa
			(branch-protection required-check, ação de config do founder). O guard
			independente quebra PARCIALMENTE o paradoxo (vive em workflow separado),
			não absolutamente — declarado.

			(c) Verificacao empirica: a lógica do guard foi testada localmente — passa
			no validate.yml atual (forma bloqueante), falha em '--mode warn' e em
			'runner removido' (ambos fail=1). cue vet ./... EXIT 0; runner --self-test
			PASS; runner default exit 0. Os .yml não exigem SRR (.github = plataforma,
			fora do regime de artifact-schema); este SRR cobre o ADR.
			"""
	}]

	findings: {}

	summary: """
		adr-110 governa a liveness do gate (M3): invariante de invocação do runner no
		validate.yml + guard independente (ci-liveness.yml) que pega neutralização e
		remoção, com a honestidade de que a raiz de confiança final é externa
		(branch-protection). Sem findings fail/warn. Guard verificado (passa atual,
		falha nas adulterações).
		"""

	singleRoundRationale: """
		Uma rodada basta: a abordagem (a)+(b) e o limite (raiz externa) foram
		apresentados e aprovados pelo founder antes da escrita; a lógica do guard foi
		verificada de forma determinística (passa/falha nos casos). Sem espaco de
		decisao aberto a red-team adicional.
		"""
}
