package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

designPrinciplesSchema: build_time.#SelfReviewReport & {
	reportId: "srr-design-principles-schema"

	artifactPath:       "architecture/artifact-schemas/design-principles.cue"
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
			Novo schema #DesignPrinciples (singleton) per adr-093 / passo (i) do
			cutover adr-090. Declara o shape que architecture/design-principles.cue
			JA segue: principles indexado por id (chave==id, injetada pelo pattern),
			#DesignPrinciple {id, group, statement, rationale} e #PrincipleGroup
			(5 grupos). _schema.location singleton (^architecture/design-principles\\.cue$,
			cardinality singleton). _qualityCriteria com 2 criterios ESTRUTURAIS
			(tq-dp-01 completude de campos; tq-dp-02 id==chave referenciavel) —
			deliberadamente NAO avaliam o merito do conteudo dos principios.

			Espelha o padrao de domain-definition.cue (singleton com _schema +
			_qualityCriteria internos; tipos de suporte no nivel do package).
			Tipos #DesignPrinciple/#PrincipleGroup movidos de package
			design_principles para package artifact_schemas; sem colisao (nomes
			inexistentes em artifact_schemas; domain-definition usa #Principle,
			outro tipo).

			Verificado localmente com cue v0.16.0: cue vet OK; injecao de id
			funciona (principles.P0.id == "P0"; P12.group == "Governance");
			#DesignPrinciples._schema.location extraivel pelo runner (def #, resolve)
			— confirma que architecture/design-principles.cue passa de unmatched
			para matched.
			"""
	}]

	findings: {}

	summary: """
		Schema #DesignPrinciples singleton para o fundacional design-principles
		(adr-093, passo i do adr-090). Shape + location singleton + 2 criterios
		estruturais minimos; sem semantica dos principios. Tira o artefato da zona
		orfa. cue vet + injecao de id + extracao de location validados localmente.
		"""

	singleRoundRationale: "Schema mecanico e de escopo minimo (shape ja seguido pela instancia + location + criterios estruturais), decisao registrada em adr-093. Padrao espelhado de domain-definition. cue vet e conformance validados localmente; rounds adicionais nao detectariam new findings."
}
