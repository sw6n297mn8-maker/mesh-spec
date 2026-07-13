package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def080StructureActorEnforcement: build_time.#SelfReviewReport & {
	reportId: "srr-def-080-structure-actor-enforcement"

	artifactPath:       "architecture/deferred-decisions/def-080-structure-command-actor-and-invariant-enforcement.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 — self-review do def-080 (F3 do review isolado do adr-175,
			decisão (a) do founder): registra como deferimento consciente
			governado o que estava só em prosa no ADR — a estruturação de
			campo de ator no #Command e de enforcement no #Invariant, que
			mecanizaria os padrões A/B de exclusão legítima do sc-ag-02.

			[tq-def-01 trade-off]: articulado nos dois lados — custo evitado
			(fatia repo-wide no schema do domain-model + retrofit 12+ BCs +
			modelagem de híbridos não-triviais: cmd-record-evidence
			ACL+stakeholder, cmd-cancel-purchase-order multi-cenário — casos
			REAIS do disco, conferidos na revisão de arquiteto) vs custo de
			continuar (legitimidade por leitura, risco de exclusão-carimbo
			vigiado pela falsificationCondition (a) do adr-175; volume atual
			~2 padrão-A + ~20 padrão-B baixo para leitura-guiada).
			[tq-def-04 coerência]: medium/cross-artifact — ENUMS CONFERIDOS
			contra o schema antes da escrita (lição do def-078): severity ∈
			{low,medium,high}, blastRadius ∈ {local,cross-artifact,
			cross-cutting,repo-wide}; medium porque o gate funciona sem a
			mecanização; cross-artifact porque acopla schema do domain-model
			aos agent-specs no retrofit. [uq-08]: cue vet EXIT=0. defersTo
			adicionado ao adr-175 no mesmo ciclo (adr-062) + entry em
			plannedOutputs (adr-059 — path novo criado pela decisão).

			[tq-def-03 WARN ACEITO E DECLARADO]: trigger manual-review único.
			O gatilho real é julgamento do founder sobre a experiência das
			higienes (volume/ambiguidade da leitura-guiada) — não fato de
			disco: contagem de scopeExclusions não distingue exclusão
			legítima de carimbo (a distinção É o que o def adia mecanizar);
			trigger de conteúdo dispararia em prosa que já usa os termos.
			Mesma classe de aceite do def-078/def-079.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review único (sem trigger automático). Aceito e justificado no triggerCalibrationRationale: o gatilho é julgamento do founder sobre volume/ambiguidade das exclusões por prosa nas higienes WI-154/WI-155 — não machine-evaluable sem falso-positivo (contagem não distingue legitimidade; trigger de conteúdo dispara em prosa existente). Revisita ancorada: adr-175 defersTo + higienes como momento de medição."
		}]
	}

	summary: """
		def-080 registra o deferimento consciente da estruturação de
		ator/enforcement (mecanização dos padrões A/B de exclusão do
		sc-ag-02): trade-off articulado com casos reais do disco, enums de
		costOfDeferral conferidos contra o schema (medium/cross-artifact),
		trigger manual-review com warn tq-def-03 aceito e declarado, defersTo
		no adr-175 fechando o F3 per adr-062. VEREDITO: stable, 0 fail, 1
		warn declarado.
		"""

	singleRoundRationale: """
		Round único proporcional: instância de tipo com PG existente, desenho
		pré-cravado pelo founder (F3 → (a)) e conteúdo derivado de material
		já verificado contra o disco na revisão de arquiteto desta fatia
		(padrões A/B, contagens, híbridos); este round confirmou conformância
		ao schema, enums válidos e a declaração do warn.
		"""
}
