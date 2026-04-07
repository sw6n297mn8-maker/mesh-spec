package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr043: build_time.#SelfReviewReport & {
	reportId: "srr-adr-043"

	artifactPath:       "architecture/adrs/adr-043-vertical-applicability-governance-surface.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Passada única contra 8 universais + 3 type-specific de
			#ADR (tq-adr-01/02/03) sobre adr-043, que introduz duas
			coisas acopladas: (a) tipos reutilizáveis #VerticalClass
			(enum fechado de 6 valores em kebab-case) e
			#VerticalApplicability (união discriminada por mode com
			três branches: vertical-agnostic, vertical-specific,
			vertical-adaptable) em
			architecture/shared-types/vertical-applicability.cue;
			(b) regime de adoção em duas fases — Fase 1 com campo
			opcional + quality criterion warn em três schemas-alvo
			(Subdomain, BoundedContextCanvas, AnalyticalLens), Fase 2
			(ADR posterior, condicionada a backfill completo) com
			campo obrigatório + warn elevado a fail.

			uq-01 (rationale=WHY): o campo rationale do ADR explica
			a razão da decisão — agnosticismo a cadeia produtiva é
			afirmação central da tese Mesh mas vive apenas em prosa,
			não em superfície tipada — não descreve mecanicamente
			o que o tipo faz. Pass.

			uq-02 (Mesh-specific): teste de substituição "qualquer
			fintech" falha — o argumento depende especificamente de
			a Mesh afirmar agnosticismo a verticais com execução
			física verificável (premissa em domain-definition.cue),
			e da existência de schemas de domínio (Subdomain, Canvas,
			Lens) que podem embutir premissas setoriais sem
			sinalização. Não se aplica a sistemas que não têm essa
			premissa de universalidade ou que não modelam recortes
			produtivos. Pass.

			uq-03 (refs cruzadas existem):
			architecture/shared-types/vertical-applicability.cue é
			afetado e foi escrito previamente nesta sessão com
			cue vet limpo; architecture/artifact-schemas/subdomain.cue,
			canvas.cue e lens.cue existem no repo (verificados via
			ls em architecture/artifact-schemas/);
			domain/domain-definition.cue existe e é a fonte da
			afirmação de agnosticismo citada no context. Pass.

			uq-04 (consistência com design principles): P0, P1 e
			P10 invocados em principlesApplied existem em
			architecture/design-principles.cue com semântica
			compatível — P0 (zero duplicação) ancora a decisão de
			localizar o tipo num único arquivo em shared_types
			com schemas consumidores importando, não copiando;
			P1 (schemas CUE como source of truth) ancora a decisão
			de o tipo canônico preceder qualquer instância;
			P10 (agentes estocásticos recomendam, gates determinísticos
			validam) ancora a escolha de severity warn na Fase 1 e
			a transição a fail só na Fase 2 quando a invariante for
			deterministicamente verificável. Nenhuma contradição com
			outros princípios. Pass.

			uq-05 (limitações declaradas): consequences negativas
			declaram explicitamente o custo cognitivo adicional por
			artefato, a fricção deliberada de expansão do enum, a
			heterogeneidade temporária do rollout, e — adicionado
			como ajuste 5 do round dialógico com o founder — o
			resíduo epistemológico de que a classificação entre os
			três modos continua sendo julgamento semântico, não
			objetividade absoluta. Pass.

			uq-06 (ubiquitous language consistente): termos
			"vertical-agnostic", "vertical-specific",
			"vertical-adaptable", "verticalApplicability",
			"primaryVertical", "validatedVerticals" e "cadeia
			produtiva" usados consistentemente em context, decision
			e consequences, sem mistura de sinônimos. Pass.

			uq-07 (zero placeholder): nenhum TODO, TBD ou texto
			genérico de preenchimento. Pass.

			uq-08 (conforma com #ADR): id "adr-043" satisfaz
			^adr-[0-9]{3}$; status "accepted" é #NonSupersededStatus
			(branch sem supersededBy); date "2026-04-07" satisfaz
			^[0-9]{4}-[0-9]{2}-[0-9]{2}$; decisionClass "structural",
			reversibility "medium", blastRadius "cross-cutting" são
			valores válidos dos enums correspondentes;
			affectedArtifacts contém 4 paths não vazios;
			principlesApplied contém 3 entries não vazias;
			supersedes é lista vazia (opcional); rationale presente
			e não vazio. Conformidade estrutural confirmada via
			cue vet imediatamente após a escrita do arquivo. Pass.

			tq-adr-01 (alternativas com rejeição): o campo context
			lista sete alternativas explicitamente rejeitadas, cada
			uma com justificativa específica — campo livre tipo
			string (perde governabilidade), booleano isVerticalAgnostic
			(colapsa três estados em dois), enum incluindo
			general-b2b-physical-execution (universalidade não é
			vertical), incluir industrial (sobreposição com 3 outros
			valores), manter em prosa (status quo que produz o
			problema), obrigatório imediato (invalida base instalada),
			supportedVerticals genérico misturando intenção e
			evidência (perde a distinção que é o ganho governável).
			Pass.

			tq-adr-02 (metadata de risco reflete decisão): reversibility
			"medium" é defensável — adicionar campo opcional num
			schema CUE é barato e local; removê-lo após adoção exige
			churn em todas as instâncias que o declararam, custo
			proporcional ao número de instâncias adotantes; não é
			"high" (porque há custo de reversão real após adoção),
			não é "low" (porque o tipo não persiste em SoT nem cruza
			contrato externo). blastRadius "cross-cutting" é
			defensável — afeta três schemas distintos em
			architecture/artifact-schemas/ e todas as instâncias
			futuras dos três tipos correspondentes; não é "local"
			(toca múltiplos artefatos), não é "repo-wide" (não toca
			CI, governance global nem estrutura do repo). Pass.

			tq-adr-03 (paths em affectedArtifacts são reais):
			architecture/shared-types/vertical-applicability.cue
			existe (escrito previamente nesta sessão);
			architecture/artifact-schemas/subdomain.cue,
			canvas.cue e lens.cue existem no repo. Pass.

			Conclusão do round 1: 0 fails, 0 warns, 0 infos.
			Estabilização em uma única passada.
			"""
	}]

	findings: {}

	summary: """
		ADR-043 introduz superfície de governança tipada para
		aplicabilidade de artefatos por vertical de cadeia produtiva,
		com tipo canônico em shared_types
		(#VerticalClass + #VerticalApplicability como união
		discriminada de três modos) e rollout em duas fases sobre
		Subdomain, BoundedContextCanvas e AnalyticalLens (Fase 1
		opcional + warn nesta ADR; Fase 2 obrigatório + fail em
		ADR posterior condicionada a backfill). Estável em 1 round
		com zero findings residuais. A estabilização em uma única
		passada é evidenciada pelo singleRoundRationale: o conteúdo
		entrou no self-review formal já refinado por três rounds
		de revisão dialógica explícita com o founder, que cobriu
		exatamente as classes de problema que self-review tipicamente
		surface (ambiguidade de supersession, semântica de
		validatedVerticals, rationale do recorte fora-de-escopo,
		limitação epistemológica em consequences).
		"""

	singleRoundRationale: """
		O conteúdo do ADR-043 atravessou três rounds de revisão
		dialógica explícita com o founder antes de chegar ao
		self-review formal: (1) proposta inicial completa; (2)
		aprovação condicional com cinco ajustes redacionais e
		normativos (reescrita do bloco de Fase 2 para eliminar
		uso ambíguo de "supersedes parcial", reescrita da Fase 1
		para deixar explícito que obrigatoriedade nesta fase é
		norma de authoring e não propriedade enforçada por schema,
		aperto da semântica de validatedVerticals para excluir
		validações que exigiram redefinição material do núcleo,
		endurecimento do rationale do recorte fora-de-escopo
		para fechar pollution semântica em superfícies meta,
		adição de limitação epistemológica explícita em
		consequences); (3) consolidação final aplicando os cinco
		ajustes literalmente. Cada ajuste foi negociado contra
		texto específico e endereçou justamente as classes de
		problema que o self-review tipicamente surface — ambiguidade
		de mecanismo de versioning, leitura ambígua de
		obrigatoriedade fase-dependente, frouxidão semântica em
		campo de evidência, racional fraco para exclusão de
		escopo, e ausência de honestidade epistemológica sobre
		o limite do que o tipo entrega. Por isso o round 1 do
		self-review formal apenas confirma a conformidade contra
		os critérios, sem encontrar novos findings — o trabalho
		correspondente já foi realizado fora do laço self-review,
		dentro do laço dialógico autorizado pelo founder.
		"""
}
