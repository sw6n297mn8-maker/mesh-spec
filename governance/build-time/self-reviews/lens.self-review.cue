package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lens: build_time.#SelfReviewReport & {
	reportId: "srr-lens"

	artifactPath:       "architecture/artifact-schemas/lens.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Mudança incremental e mecânica em lens.cue para Fase 1 do
		rollout definido em adr-043: (a) expansão do import de
		"list" para bloco import com adição de shared_types; (b)
		adição de campo opcional verticalApplicability?:
		shared_types.#VerticalApplicability dentro do struct
		#AnalyticalLens, posicionado após status (entre identidade
		e trigger); (c) adição de quality criterion tq-ln-05 com
		severity warn em _qualityCriteria.criteria. O
		_qualityCriteria de lens.cue está declarado em escopo
		package-level, não dentro do struct #AnalyticalLens — drift
		estrutural pré-existente em relação a subdomain.cue e
		canvas.cue, conhecido e deliberadamente não corrigido neste
		commit (CLAUDE.md: não fazer refactor não pedido; correção
		seria mudança estrutural exigindo ADR próprio). Novo
		critério tq-ln-05 foi adicionado no escopo atual
		(package-level) para preservar a topologia existente. Os
		quatro critérios prévios (tq-ln-01 a tq-ln-04) e a
		estrutura do struct #AnalyticalLens permanecem intactos;
		cue vet limpo após a edição. Conteúdo entrou no
		self-review formal já refinado por round dialógico
		explícito com o founder, que sinalizei o drift estrutural
		do _qualityCriteria, propus opção (a) — adicionar no mesmo
		escopo sem corrigir o drift — e obtive aprovação explícita.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação self-reported da edição mecânica de Fase 1
			adr-043 sobre lens.cue: import de shared_types
			adicionado em bloco junto com "list", campo opcional
			verticalApplicability? adicionado após status dentro
			de #AnalyticalLens, critério tq-ln-05 (severity warn)
			adicionado como último item de _qualityCriteria.criteria
			(que vive em escopo package-level — drift pré-existente
			deliberadamente não corrigido aqui).

			uq-01 (rationale=WHY): rationale do novo critério
			tq-ln-05 explica por que existe (Fase 1 do rollout
			adr-043) sem descrever mecanicamente o que faz. Pass.

			uq-02 (Mesh-specific): teste de substituição "qualquer
			fintech" falha — o critério é específico de um sistema
			que governa lentes analíticas como artefatos de
			raciocínio aplicados a problemas Mesh e que afirma
			agnosticismo a verticais. Lentes analíticas são
			especialmente sensíveis a vieses verticais ocultos —
			frameworks analíticos é onde generalização aparente
			esconde os pressupostos mais difíceis de detectar. Pass.

			uq-03 (refs cruzadas existem): tq-ln-05 referencia
			adr-043 (commitado em f147a6b);
			shared_types.#VerticalApplicability existe em
			architecture/shared-types/vertical-applicability.cue
			(commitado no mesmo commit). Pass.

			uq-04 (consistência com design principles): adição
			implementa P0 (tipo vive em shared_types, schema
			importa), P1 (schema-first), P10 (warn advisory Fase
			1 → fail estrutural Fase 2 só após backfill). Sem
			contradição. Pass.

			uq-05 (limitações declaradas): Fase 1 advisory
			declarada no rationale do tq-ln-05; drift estrutural
			pré-existente do _qualityCriteria declarado neste
			singleRoundRationale como conhecido e deliberadamente
			não corrigido (escopo separado). Pass.

			uq-06 (ubiquitous language): novos termos
			(verticalApplicability, vertical-agnostic/specific/
			adaptable, Fase 1, rollout) consistentes com adr-043
			e vertical-applicability.cue; vocabulário existente
			da lens (concepts, reasoningProtocol, meshExamples,
			principleIds, reviewCadence) preservado intacto. Pass.

			uq-07 (zero placeholder): sem TODO/TBD. Pass.

			uq-08 (conforma com #ArtifactSchema): _schema.location
			preservado; _qualityCriteria continua conformando com
			#QualityCriteria — novo entry tem id no padrão
			tq-ln-NN, description não vazio, test específico,
			severity warn válido, rationale não vazio. Struct
			#AnalyticalLens mantido (apenas com campo opcional
			adicional); instâncias existentes não quebram. Pass.

			tq-as-01/02/03: schema continua sendo struct closed
			com campos descritos, _schema completo,
			_qualityCriteria com lista não vazia (agora 5
			critérios). Pass.

			Conclusão: 0 fails, 0 warns, 0 infos. Edição mecânica
			Fase 1 adr-043 sobre lens.cue, sem regressão sobre os
			critérios existentes e sem alteração da topologia
			estrutural pré-existente.
			"""
	}]

	findings: {}

	summary: """
		Edição de Fase 1 do rollout adr-043 sobre lens.cue:
		import de shared_types adicionado em bloco, campo opcional
		verticalApplicability? adicionado dentro de #AnalyticalLens
		após status, e critério warn tq-ln-05 adicionado em
		_qualityCriteria.criteria no escopo package-level (drift
		pré-existente em relação a subdomain.cue/canvas.cue
		deliberadamente preservado, correção fica para escopo
		separado). Estável em 1 round via self-reported review com
		zero findings. A natureza mecânica da edição, o tratamento
		explícito do drift estrutural conhecido e a aprovação
		prévia dialógica do founder sobre posicionamento e
		opção (a) justificam estabilização em uma única passada.
		"""
}
