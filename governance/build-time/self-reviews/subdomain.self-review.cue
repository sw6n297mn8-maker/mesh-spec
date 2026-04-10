package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

subdomainSchema: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-schema"

	artifactPath:       "architecture/artifact-schemas/subdomain.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Mudança incremental e mecânica em subdomain.cue para Fase 1
		do rollout definido em adr-043: (a) adição de campo opcional
		verticalApplicability?: shared_types.#VerticalApplicability
		dentro do struct #Subdomain, posicionado após strategicProfile?
		por paralelo semântico (ambos são dimensões de perfil); (b)
		adição de quality criterion tq-sd-08 com severity warn em
		_qualityCriteria.criteria, sinalizando ausência do campo como
		finding advisory durante a Fase 1. Nenhum campo existente foi
		alterado, removido ou re-tipado; nenhum critério existente
		(tq-sd-01 a tq-sd-07) teve test, severity ou rationale
		modificados. O import de shared_types já existia (linha 3,
		usado por #SubdomainClassification). cue vet limpo após a
		edição. Conteúdo entrou no self-review formal já refinado por
		round dialógico explícito com o founder que aprovou
		posicionamento, texto do critério, consistência de rationale
		entre os três schemas-alvo (subdomain/canvas/lens) e a
		decisão de não tocar a estrutura existente do schema além
		do necessário para a Fase 1 — exatamente as classes de
		problema que self-review tipicamente surface em mudanças
		mecânicas guiadas por ADR.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação self-reported da edição mecânica de Fase 1
			adr-043 sobre subdomain.cue: campo opcional
			verticalApplicability? adicionado após strategicProfile?
			dentro de #Subdomain, e critério tq-sd-08 (severity warn)
			adicionado como último item de _qualityCriteria.criteria.
			Critérios universais e type-specific de #ArtifactSchema
			avaliados contra o schema modificado.

			uq-01 (rationale=WHY): rationale do novo critério tq-sd-08
			explica por que existe (Fase 1 do rollout adr-043,
			obrigatoriedade normativa de authoring sinalizada por
			advisory) sem descrever mecanicamente o que o critério
			faz. Pass.

			uq-02 (Mesh-specific): teste de substituição "qualquer
			fintech" falha — o critério é específico de um sistema
			que afirma agnosticismo a verticais com execução física
			verificável e que governa essa afirmação via campo
			tipado e quality criterion advisory. Pass.

			uq-03 (refs cruzadas existem): tq-sd-08 referencia
			adr-043, que existe em
			architecture/adrs/adr-043-vertical-applicability-governance-surface.cue
			(commitado em f147a6b); o tipo
			shared_types.#VerticalApplicability referenciado pelo
			campo verticalApplicability? existe em
			architecture/shared-types/vertical-applicability.cue
			(commitado no mesmo commit). Pass.

			uq-04 (consistência com design principles): a adição
			implementa P0 (definição do tipo vive em shared_types,
			schema importa não copia), P1 (schema-first, tipo
			canônico precede instância) e P10 (warn advisory na
			Fase 1, fail estrutural na Fase 2 — gate determinístico
			só após backfill verificado). Sem contradição. Pass.

			uq-05 (limitações declaradas): a Fase 1 advisory é
			explicitamente declarada no rationale do tq-sd-08; a
			ADR-043 carrega as limitações da decisão, e o
			critério aponta para ela como fonte normativa. Pass.

			uq-06 (ubiquitous language): "vertical-agnostic",
			"vertical-specific", "vertical-adaptable",
			"verticalApplicability", "Fase 1", "rollout"
			consistentes com o vocabulário introduzido em
			adr-043 e em vertical-applicability.cue. Pass.

			uq-07 (zero placeholder): sem TODO/TBD. Pass.

			uq-08 (conforma com #ArtifactSchema): _schema.location
			preservado intacto (canonicalPathRegex, fileNameRegex,
			cardinality, allowNested); _qualityCriteria continua
			conformando com #QualityCriteria — novo entry tem id
			no padrão tq-sd-NN, description não vazio, test
			específico, severity (warn) válido, rationale não
			vazio. Estrutura do struct #Subdomain mantida; novo
			campo é opcional (não quebra instâncias existentes
			estrutural ou semanticamente). Pass.

			tq-as-01/02/03 (type-specific de artifact-schema):
			schema continua sendo struct closed com campos
			descritos, _schema completo e _qualityCriteria
			com lista não vazia de critérios — todos preservados
			pela edição incremental. Pass.

			Conclusão: 0 fails, 0 warns, 0 infos. Edição mecânica
			Fase 1 adr-043, sem regressão sobre os critérios
			existentes.
			"""
	}]

	findings: {}

	summary: """
		Edição de Fase 1 do rollout adr-043 sobre subdomain.cue:
		campo opcional verticalApplicability? adicionado dentro de
		#Subdomain após strategicProfile?, e critério warn tq-sd-08
		adicionado em _qualityCriteria.criteria. Estável em 1 round
		via self-reported review com zero findings. A natureza
		mecânica da edição (adição de campo opcional + critério
		advisory, sem alteração de campos ou critérios existentes)
		e a aprovação prévia dialógica do founder sobre
		posicionamento e texto justificam estabilização em uma
		única passada.
		"""
}
