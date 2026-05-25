package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr094: artifact_schemas.#ADR & {
	id:    "adr-094"
	title: "Schematizar shared-types via location/convention schema — passo i do cutover adr-090"
	date:  "2026-05-25"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-090 passo (i) + def-018 já apontam literalmente para
		architecture/artifact-schemas/shared-types.cue: o 2º trigger do def-018 é
		file-exists nesse path. Os arquivos architecture/shared-types/*.cue
		(vertical-applicability.cue, strategic-classification.cue) vivem na zona
		órfã (unmatched) por não terem schema que case seu path.

		Diferença conceitual de design-principles (adr-093): aqueles arquivos NÃO
		são instâncias de dados — são BIBLIOTECAS DE DEFINIÇÕES CUE (package
		shared_types) consumidas por outros schemas (subdomain.cue, canvas.cue,
		via adr-043). Um artifact-schema, por convenção, valida o shape de uma
		INSTÂNCIA; uma biblioteca de tipos não tem instância cujo shape validar.
		"""

	decision: """
		Criar architecture/artifact-schemas/shared-types.cue declarando
		#SharedTypes EXPLICITAMENTE como location/convention schema para
		biblioteca CUE, NÃO um instance-shape schema. Concretamente:

		(1) _schema.location como collection (^architecture/shared-types/[a-z0-9-]+\\.cue$),
		para que o runner classifique os arquivos da biblioteca como matched.
		(2) Struct aberta (...): não impõe shape de dados — os arquivos são defs.
		(3) _qualityCriteria apenas ADVISORY (severity warn): tq-st-01 (package
		shared_types + ≥1 definição) e tq-st-02 (vocabulário canônico expande via
		ADR). NÃO finge validação de shape de instância.
		(4) NÃO toca nas defs existentes em shared-types/* — #VerticalClass,
		#VerticalApplicability, #SubdomainClassification permanecem inalteradas.

		Esta decisão registra explicitamente a EXCEÇÃO CONCEITUAL: shared-types.cue
		é um location/convention schema para biblioteca CUE, não um instance-shape
		schema como os demais artifact-schemas.
		"""

	consequences: """
		Positivas: (1) vertical-applicability.cue e strategic-classification.cue
		saem da zona órfã (unmatched) e passam a ser classificados pelo novo schema;
		(2) arma o 2º trigger do def-018 (file-exists architecture/artifact-schemas/
		shared-types.cue) — com ambos os fundacionais schematizados, def-018 fica
		pronto para a revisita de promoção órfão→reject; (3) mantém a sequência
		adr-090/def-018 intacta.

		Negativas / exceção aceita: (1) #SharedTypes é um esticão do conceito de
		artifact-schema (location/convention, não instance-shape) — aceito porque a
		alternativa (excluir shared-types/ via repo-structure) desviaria da
		sequência e exigiria emendar o trigger do def-018; (2) os _qualityCriteria
		advisory não são gate determinístico (warn), por construção — não há
		instância para validar.
		"""

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/shared-types.cue",
		"architecture/shared-types/vertical-applicability.cue",
		"architecture/shared-types/strategic-classification.cue",
	]

	defersTo: []
	principlesApplied: ["P0 — localização canônica única por unidade de conhecimento", "P12 — governança como código"]

	rationale: """
		Materializa o passo (i) do cutover adr-090 para o 2º fundacional. A exceção
		conceitual (location/convention schema, não instance-shape) é aceita por
		dois motivos: (a) manter a sequência adr-090/def-018 intacta — o trigger do
		def-018 aponta literalmente para este path, e desviar exigiria emendar a
		deferred-decision; (b) eliminar o órfão SEM redesenhar shared-types (regra
		do founder: não tocar nas defs). artifact-schemas normalmente validam
		instâncias; type-libraries não são instâncias, daí os critérios serem
		advisory. P0: dá à biblioteca uma localização canônica governada. P12: o
		schema entra na classificação de CI. decisionClass structural (altera o
		contrato estrutural do repo — por isso shared-types/* entram em
		affectedArtifacts mesmo sem edição: passam a ser classificados pelo schema);
		reversibility medium; blastRadius cross-artifact.
		"""
}
