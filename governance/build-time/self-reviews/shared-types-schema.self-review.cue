package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sharedTypesSchema: build_time.#SelfReviewReport & {
	reportId: "srr-shared-types-schema"

	artifactPath:       "architecture/artifact-schemas/shared-types.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Novo schema #SharedTypes per adr-094 / passo (i) do cutover adr-090,
			2º fundacional. EXPLICITAMENTE um location/convention schema para
			biblioteca CUE, NÃO um instance-shape schema (registrado no header do
			schema e no adr-094):
			- _schema.location collection (^architecture/shared-types/[a-z0-9-]+\\.cue$,
			  cardinality collection) — tira vertical-applicability.cue e
			  strategic-classification.cue da zona órfã (matched).
			- Struct aberta (...): não impõe shape de dados (os arquivos são defs).
			- _qualityCriteria ADVISORY (severity warn): tq-st-01 (package
			  shared_types + ≥1 definição) e tq-st-02 (vocabulário canônico expande
			  via ADR). NÃO finge validação de shape.

			NÃO toca nas defs existentes (#VerticalClass, #VerticalApplicability,
			#SubdomainClassification) — confirmado: nenhum arquivo shared-types
			alterado neste commit. Sem colisão: #SharedTypes inexistente em
			artifact_schemas.

			Verificado localmente com cue v0.16.0: cue vet OK (módulo unifica;
			shared-types/* seguem válidas, sem conformance forçada);
			#SharedTypes._schema.location extraível pelo runner (def #, struct
			concreta) — confirma classificação matched dos 2 arquivos.
			"""
	}]

	findings: {}

	summary: """
		Schema #SharedTypes (location/convention, NÃO instance-shape) para a
		biblioteca de tipos shared-types (adr-094, passo i do adr-090, 2º
		fundacional). Location collection + struct aberta + 2 critérios advisory
		(warn). Tira os 2 arquivos da zona órfã sem tocar nas defs nem fingir
		validação de shape. cue vet + extração de location validados localmente.
		"""

	singleRoundRationale: "Schema de localização/convenção de escopo mínimo (location collection + critérios advisory), exceção conceitual registrada em adr-094; sem edição das defs existentes. cue vet + extração de location validados localmente; rounds adicionais não detectariam new findings."
}
