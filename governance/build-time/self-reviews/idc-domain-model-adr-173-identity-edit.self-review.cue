package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

idcDomainModelAdr173IdentityEdit: build_time.#SelfReviewReport & {
	reportId: "srr-idc-domain-model-adr-173-identity-edit"

	artifactPath:       "contexts/idc/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

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
			Round 1 — self-review da EDIÇÃO per adr-173: vo-cnpj-identifier →
			vo-legal-entity-identifier (scheme+value; br-cnpj primeiro esquema,
			mandatório BR); rootIdentity do agg-organizational-identity 'cnpj' →
			'legalIdentifier'; description do aggregate generalizada para
			'(esquema, valor)'; refs internas atualizadas (signerIdentity + 2
			listas usesValueObjects) — grep pós-edição: ZERO refs órfãs ao VO
			antigo no repo inteiro. [uq-08]: cue vet EXIT=0; shape #DomainModel
			intacta (edição não toca events/commands/invariants além do
			catalogado). [uq-03]: refs cruzadas verificadas — o agent do idc
			atualizado em par (sc-ag-01 vê o par consistente). [uq-01]: rationale
			do VO registra o porquê (restauração da intenção fundacional, com
			proveniência). [uq-04]: constraint SCD/Bacen preservada por
			construção (br-cnpj mandatório BR declarado no campo scheme).
			[uq-05]: limitação declarada via defersTo do adr-173 → def-077
			(agregação multi-identificador). [uq-06]: UL alinhada ao termo novo
			do glossário idc. [uq-07]: zero placeholder. [uq-09]: edição de
			instância dentro do arco de checkpoint único aprovado pelo founder
			(proposta integral em chat + 'ok'); batch no checkpoint (pattern
			def-074). Menções exemplificativas a CNPJ preservadas per adr-173
			item 5 (evt-identity-revoked 'baixa de CNPJ').
			"""
	}]

	findings: {}

	summary: """
			Edição do domain-model do idc per adr-173: identidade legal qualificada
		por esquema substitui CNPJ hardcoded na raiz do aggregate; refs internas
		e agent atualizados em par; zero órfãos. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
			Round único proporcional: edição cirúrgica executando decisão de ADR
		aprovado em proposta integral; a verificação substantiva (refs elemento
		a elemento, baseline do runner, proveniência Mesh-Old) corre no review
		isolado dos ADRs da mesma fatia.
		"""
}
