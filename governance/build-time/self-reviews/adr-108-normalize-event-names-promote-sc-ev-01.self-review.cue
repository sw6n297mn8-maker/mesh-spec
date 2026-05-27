package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr108NormalizeEventNamesPromoteScEv01: build_time.#SelfReviewReport & {
	reportId: "srr-adr-108-normalize-event-names-promote-sc-ev-01"

	artifactPath:       "architecture/adrs/adr-108-normalize-event-names-promote-sc-ev-01.cue"
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
			Self-review do adr-108 (normalizar 22 event-names + promover sc-ev-01 a
			reject). Os 22 nomes canônicos (incl. as 3 decisões dos verbosos) aprovados
			pelo founder antes da escrita.

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility/blastRadius coerentes. tq-adr-01: alternativa
			rejeitada com motivo (promover sem normalizar = bloqueio; manter warn = não
			trava). affectedArtifacts = 4 reais (3 domain-models + o check).

			(b) Segurança dos renames verificada ANTES: os 22 não estão no context-map
			(sc-cm-06 intacto); refs internas por code (evt-*); descriptions presentes;
			zero colisões. Renames display-only.

			(c) Verificacao empirica: python rename (count==1 por find, abort-on-mismatch)
			aplicou os 22; cue vet ./... EXIT 0; runner --self-test PASS; sc-ev-01 →
			zero violações pós-rename; promovido a reject → runner default 0
			bloqueantes, exit 0; teste ADVERSARIAL: "Delivery Borked" → sc-ev-01 reject
			FAIL, exit 1; pós-revert exit 0. A promoção tem dentes.
			"""
	}]

	findings: {}

	summary: """
		adr-108 normaliza os 22 event-names à convenção canônica (PascalCase; detalhe
		dos parentéticos no description) e promove sc-ev-01 a reject — fechando a
		catraca adr-104/107. Vocabulário de event-name 100% canônico e travado por
		gate. Sem findings fail/warn. Verificação: zero violações, 0 bloqueantes,
		teste adversarial bloqueia name não-canônico.
		"""

	singleRoundRationale: """
		Uma rodada basta: os 22 nomes (incl. 3 decisões) aprovados pelo founder antes
		da escrita; segurança dos renames e efeito (zero violações, promoção exit 0,
		adversarial exit 1) verificados de forma determinística. Sem espaco de decisao
		aberto a red-team adicional.
		"""
}
