package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def076StakeholderMapSchemaDrift: build_time.#SelfReviewReport & {
	reportId: "srr-def-076-stakeholder-map-schema-drift"

	artifactPath:       "architecture/deferred-decisions/def-076-stakeholder-map-schema-drift.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-05"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do def-076 (crack do stakeholder-map: instância na shape antiga
			não unifica com o schema evoluído; re-autoria é decisão de conteúdo do founder).

			[uq-08 CONFORMÂNCIA #DeferredDecision]: OK. cue vet EXIT=0. Numeração sequencial ao
			def-075 (G2: def-75 confirmado próximo-livre via --assert; def-076 imediatamente
			seguinte na mesma fatia — documentado no checkpoint).

			[ANTI-CATCH-ALL]: OK, com atenção à fronteira 'bug travestido'. O drift PARECE bug,
			mas o deferimento não é do CONSERTO (mecânico, impossível: 4 campos sem destino) e sim
			da RE-AUTORIA com conteúdo de negócio novo (manipulationVectors per dp-08, mapeamento
			concerns→ce-01..07, categoria do sh-06 possivelmente via extensão de enum em ADR) —
			decisão que pertence ao founder. Trade-off articulado + condição de revisita codificada
			= deferimento consciente legítimo, não gap escondido: o VEREDITO do Tempo 1 (migração
			NÃO-mecânica, campo a campo) é a evidência.

			[tq-def-01 TRADE-OFF]: OK. Custo evitado: stakeholder-map FABRICADO por agente (o
			proibido dos proibidos — semântica de incentivos inventada). Custo de continuar:
			instância segue não-validada + isenção stale do meta-coverage alegando proteção
			fictícia — ambos agora REGISTRADOS em vez de silenciosos.

			[tq-def-02 CODIFICADO / tq-def-03 ≥1 NON-MANUAL]: OK. adjacent-need file-exists sobre
			architecture/structural-checks/stakeholder-map.cue (machine-evaluable; hoje ausente —
			verificado; o trigger dispara quando alguém materializar os tq-sm-* como checks, o
			momento em que a instância migrada vira pré-requisito). manual-review com reason
			substantiva (conteúdo de negócio).

			[tq-def-04 COERENTE]: OK. medium/local: artefato canônico fora de validação é
			precedente ruim (medium), mas consumidores leem stakeholders[].code presente nas duas
			shapes (local) — a ponte VERIFICADA no Tempo 1 (sc-ds-01 funciona sobre a shape atual).

			[uq-03 REFS]: OK — domain/stakeholder-map.cue e architecture/artifact-schemas/
			stakeholder-map.cue existem; campos citados das duas shapes conferidos no disco no
			Tempo 1 (type/role/influence/concerns/interactsWith vs category/platformRelationships/
			interests/painPoints+costRef/incentiveProfile+manipulationVectors); ce-01..07 e dp-08
			existem. [uq-01 WHY]: OK. [uq-02 MESH]: OK — dp-08, vetores de manipulação, sh-06
			adversário. [uq-04]: OK. [uq-05]: OK — as 3 camadas de silêncio declaradas. [uq-06]: OK.
			[uq-07]: OK.

			[uq-09 SECTION GATES]: PG deferred-decision aplicado; arco de checkpoint único do
			founder (Tempo 2); auto-checks em batch no checkpoint (pattern def-074).
			"""
	}]

	findings: {}

	summary: """
		def-076: registro do crack do stakeholder-map (instância shape antiga não unifica com schema
		novo; 3 camadas de silêncio; migração NÃO-mecânica per veredito campo-a-campo do Tempo 1) com
		re-autoria deferida ao founder. VEREDITO: stable, 0 fail. Fronteira anti-catch-all defendida
		explicitamente (defere a re-autoria com conteúdo novo, não o conserto de bug); trigger
		adjacent-need machine-evaluable + manual-review substantivo; ponte sc-ds-01 verificada
		(stakeholders[].code nas duas shapes) mantém o elo ator↔story vivo durante o deferimento.
		"""

	singleRoundRationale: """
		Round único proporcional: o def materializa o veredito do Tempo 1 desta mesma fatia
		(investigação campo-a-campo das duas shapes, ordenada pelo founder com o adendo
		'campo sem destino limpo = PERDA → para'), que já foi o review substantivo do conteúdo.
		O round confirmou conformância, calibração de triggers e a fronteira anti-catch-all sem
		findings novos.
		"""
}
