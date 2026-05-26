package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr104CanonicalEventVocabulary: build_time.#SelfReviewReport & {
	reportId: "srr-adr-104-canonical-event-vocabulary"

	artifactPath:       "architecture/adrs/adr-104-canonical-event-vocabulary.cue"
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
			Self-review do adr-104 (identidade canônica de event + reconciliação
			built↔built). Escopo e as 7 decisões aprovados pelo founder antes da
			escrita. Confirmacoes:

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural"; reversibility "medium" + blastRadius "repo-wide"; defersTo
			["def-019"]. tq-adr-01: alternativa rejeitada com motivo (code evt-* como
			chave cross-artifact — menos legível, contra o grão; permanece id interno).
			affectedArtifacts = 3 paths reais e alterados.

			(b) As 7 decisões do founder embutidas no campo decision (incl. #6
			Onboarded=Qualified e #7 granular-não-umbrella, que preservam semântica
			operacional). Escopo built-only + planned como forward-declaration
			registrado. Escopo negativo (o check em si; convenção dos demais names)
			declarado.

			(c) Segurança dos renames verificada ANTES: grep confirmou que os 4 display
			names não são referenciados fora do domain-model; refs internas
			(emitsEvents/policies) usam code evt-*, não name — renames são display-only.

			(d) Verificacao empirica: cue vet ./... EXIT 0; runner default →
			domain-invariant checks (71) intactos, 0 bloqueantes, exit 0; protótipo →
			built↔built 0 missing (100% consistente) pós-reconciliação. context-map e
			domain-model não exigem SRR (não constam em artifact_type_for_path); este
			SRR cobre o ADR keystone que governa a mudança.
			"""
	}]

	findings: {}

	summary: """
		adr-104 estabelece a identidade canônica de event (name PascalCase = chave
		cross-artifact; producer domain-model.events[] = SoT; code = id interno;
		built-only; planned = forward-declaration) e registra as 7 decisões de
		reconciliação built↔built do founder, aplicadas em context-map + dlv/rew
		domain-models. Sem findings fail/warn. Verificação: built↔built 100%
		consistente, domain-invariant intactos, cue vet 0. Check events↔BC fica para
		o próximo pass (defersTo def-019).
		"""

	singleRoundRationale: """
		Uma rodada basta: as 7 decisões e o escopo foram detalhados e aprovados pelo
		founder antes da escrita; a segurança dos renames e o efeito (built↔built
		consistente, sem regressão) foram verificados de forma determinística por grep
		+ cue vet + runner + protótipo. Sem espaco de decisao aberto a red-team.
		"""
}
