package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

idcGlossaryAdr173IdentityTerms: build_time.#SelfReviewReport & {
	reportId: "srr-idc-glossary-adr-173-identity-terms"

	artifactPath:       "contexts/idc/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da EDIÇÃO per adr-173: termo NOVO
			term-identificador-legal-qualificado (classification; definition com
			o par esquema+valor, br-cnpj mandatório BR, registro aberto;
			antiTerms defendendo as duas confusões previsíveis — 'CNPJ como
			sinônimo de identidade' e 'ParticipantId como identidade externa') +
			ajuste em term-identidade-organizacional ('CNPJ ou equivalente' →
			referência explícita ao termo novo) + relatedTerms atualizado.
			[uq-08]: cue vet EXIT=0 pós-correção mecânica (termEn sem hífen —
			regex do schema; corrigida e mostrada). [uq-06]: o termo novo é a
			âncora de UL que npm referencia — consistência cross-BC nas duas
			pontas. [uq-01]: rationale registra por quê (anti-reintrodução de
			CNPJ hardcoded; restauração da intenção fundacional). [uq-03]:
			relatedTerms resolvem no próprio glossário. [uq-05/07]: OK.
			[uq-09]: arco de checkpoint único aprovado (batch).
			"""
	}]

	findings: {}

	summary: """
			Glossário idc per adr-173: termo canônico novo para o identificador
		legal qualificado + termo central ajustado. VEREDITO: stable, 0 fail
		(1 correção mecânica de regex termEn durante autoria, mostrada).
		"""

	singleRoundRationale: """
			Round único proporcional: 1 termo novo + 1 ajuste executando ADR
		aprovado; verificação substantiva no review isolado da fatia.
		"""
}
