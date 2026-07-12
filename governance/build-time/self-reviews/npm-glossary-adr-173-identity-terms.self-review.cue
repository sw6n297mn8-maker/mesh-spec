package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

npmGlossaryAdr173IdentityTerms: build_time.#SelfReviewReport & {
	reportId: "srr-npm-glossary-adr-173-identity-terms"

	artifactPath:       "contexts/npm/glossary.cue"
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
			Round 1 — self-review da EDIÇÃO per adr-173 em 2 termos:
			term-participante ('Identificada por CNPJ' → 'identificada por
			identificador legal qualificado por esquema, br-cnpj no Brasil,
			mandatório per SCD/Bacen') e term-dados-cadastrais ('CNPJ, razão
			social...' → 'identificador legal qualificado (esquema + valor;
			br-cnpj no Brasil), razão social...'). Definições seguem a UL do
			termo canônico novo do idc. [uq-08]: cue vet EXIT=0; shape #Glossary
			intacta (só definitions editadas). [uq-06]: consistência cross-BC
			com term-identificador-legal-qualificado (idc). [uq-03]: adr-173
			citado existe na fatia. [uq-01/04/05/07]: OK — rationales dos termos
			preservados (não descrevem a mudança, registram o porquê original);
			constraint SCD/Bacen explícita na definition; zero placeholder.
			[uq-09]: arco de checkpoint único aprovado (batch).
			"""
	}]

	findings: {}

	summary: """
			Glossário npm alinhado ao adr-173: participante e dados cadastrais
		identificados por identificador legal qualificado (br-cnpj no Brasil).
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
			Round único proporcional: 2 definitions editadas executando ADR
		aprovado; verificação substantiva no review isolado da fatia.
		"""
}
