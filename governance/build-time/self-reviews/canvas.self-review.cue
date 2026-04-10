package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

canvasSchema: build_time.#SelfReviewReport & {
	reportId: "srr-canvas-schema-v3"

	artifactPath:       "architecture/artifact-schemas/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Mudança incremental e mecânica em canvas.cue para Fase 1
		do rollout definido em adr-043: (a) adição do import de
		shared_types (canvas.cue não importava nada antes); (b)
		adição de campo opcional verticalApplicability?:
		shared_types.#VerticalApplicability dentro do struct
		#Canvas, posicionado após classification por paralelo
		semântico direto (ambas são classificações transversais
		do BC); (c) adição de quality criterion tq-cv-13 com
		severity warn em _qualityCriteria.criteria, sinalizando
		ausência do campo como finding advisory durante a Fase 1.
		Nenhum dos 12 critérios existentes (tq-cv-01 a tq-cv-12)
		teve test, severity ou rationale modificados; nenhum
		campo existente foi alterado, removido ou re-tipado;
		_schema.location intacto. cue vet limpo após a edição.
		Conteúdo entrou no self-review formal já refinado por
		round dialógico explícito com o founder que aprovou
		posicionamento (após classification, antes de domainRoles),
		texto do critério, consistência de rationale entre os
		três schemas-alvo e a decisão de não tocar a estrutura
		existente do schema além do necessário para a Fase 1.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação self-reported da edição mecânica de Fase 1
			adr-043 sobre canvas.cue: import de shared_types
			adicionado, campo opcional verticalApplicability?
			adicionado após classification dentro de #Canvas,
			critério tq-cv-13 (severity warn) adicionado como
			último item de _qualityCriteria.criteria.

			uq-01 (rationale=WHY): rationale do novo critério
			tq-cv-13 explica por que existe (Fase 1 do rollout
			adr-043, obrigatoriedade normativa de authoring
			sinalizada por advisory) sem descrever mecanicamente
			o que o critério faz. Pass.

			uq-02 (Mesh-specific): teste de substituição "qualquer
			fintech" falha — o critério é específico de um sistema
			que governa BC Canvas como documento raiz de identidade
			de contexto e que afirma agnosticismo a verticais com
			execução física verificável. Pass.

			uq-03 (refs cruzadas existem): tq-cv-13 referencia
			adr-043 (commitado em f147a6b);
			shared_types.#VerticalApplicability existe em
			architecture/shared-types/vertical-applicability.cue
			(commitado no mesmo commit); o import path
			github.com/sw6n297mn8-maker/mesh-spec/architecture/
			shared-types:shared_types resolve corretamente
			(verificado por cue vet). Pass.

			uq-04 (consistência com design principles): a adição
			implementa P0 (definição vive em shared_types,
			schema importa não copia), P1 (schema-first), P10
			(warn advisory Fase 1 → fail estrutural Fase 2 só
			após backfill). Sem contradição com nenhum princípio
			do canvas. Pass.

			uq-05 (limitações declaradas): Fase 1 advisory
			explicitamente declarada no rationale do tq-cv-13;
			adr-043 carrega limitações e o critério aponta para
			ela como fonte normativa. Pass.

			uq-06 (ubiquitous language): novos termos
			(verticalApplicability, vertical-agnostic/specific/
			adaptable, Fase 1, rollout) consistentes com adr-043
			e vertical-applicability.cue; vocabulário existente
			do canvas (subdomainType, businessRole, domainRoles,
			communication etc.) preservado intacto. Pass.

			uq-07 (zero placeholder): sem TODO/TBD. Pass.

			uq-08 (conforma com #ArtifactSchema): _schema.location
			preservado; _qualityCriteria continua conformando
			com #QualityCriteria — novo entry tem id no padrão
			tq-cv-NN, description não vazio, test específico,
			severity warn válido, rationale não vazio. Struct
			#Canvas mantido; novo campo é opcional, não quebra
			instâncias existentes. Pass.

			tq-as-01/02/03 (type-specific): schema continua
			sendo struct closed com campos descritos, _schema
			completo e _qualityCriteria com lista não vazia
			(agora 13 critérios). Pass.

			Conclusão: 0 fails, 0 warns, 0 infos. Edição mecânica
			Fase 1 adr-043, sem regressão sobre os critérios
			existentes do canvas.
			"""
	}]

	findings: {}

	summary: """
		Edição de Fase 1 do rollout adr-043 sobre canvas.cue:
		import de shared_types adicionado, campo opcional
		verticalApplicability? adicionado dentro de #Canvas após
		classification, e critério warn tq-cv-13 adicionado em
		_qualityCriteria.criteria (agora com 13 critérios).
		Estável em 1 round via self-reported review com zero
		findings. A natureza mecânica da edição e a aprovação
		prévia dialógica do founder sobre posicionamento e texto
		justificam estabilização em uma única passada.
		"""
}
