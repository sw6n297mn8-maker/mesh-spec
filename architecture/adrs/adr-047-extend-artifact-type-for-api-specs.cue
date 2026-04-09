package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr047: artifact_schemas.#ADR & {
	id:    "adr-047"
	title: "Estender #ArtifactType com openapi-spec e asyncapi-spec — pré-requisito mecânico de structural-checks"
	date:  "2026-04-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-046 criou a categoria architecture/conventions/ e o
		template tmpl-create-convention@v1 como Parte A
		meta-estrutural de WI-027. A primeira convenção concreta —
		api-spec-convention.cue — é a Parte B prevista para commit
		subsequente. Como pré-requisito ontológico de B, o schema
		esqueletal architecture/artifact-schemas/api-spec.cue foi
		escrito declarando #OpenAPISpec e #AsyncAPISpec sem
		_qualityCriteria, alinhado a adr-040 (schema declara
		ontologia; invariantes vivem em structural-check + design
		review).

		Durante a Parte B do plano, o passo B.2 prevê criar o
		structural-check dedicado da convenção (instância de
		#StructuralCheck per adr-041) que enforça as invariantes
		cross-artifact: presença de api.yaml condicionada por
		canvas.hasSyncSurface, presença de async-api.yaml
		condicionada por canvas.hasAsyncSurface, coerência com
		interaction-contracts do BC. Validação adversarial sobre o
		schema esqueletal revelou um bloqueador estrutural mecânico
		para B.2 que não é detectável por inspeção isolada do
		schema:

		#StructuralCheck.artifactType
		(architecture/artifact-schemas/structural-check.cue linha 44)
		referencia #ArtifactType — enum FECHADO declarado em
		architecture/artifact-schemas/quality-criteria.cue linhas
		20-37. O enum atual contém 17 valores cobrindo os artifact
		types hoje reconhecidos pela infraestrutura de quality
		criteria e structural checks. Não contém valores cobrindo
		os tipos do novo schema api-spec.cue. Adicionalmente, a
		lista canônica de abreviações usadas em IDs de critérios
		type-specific (quality-criteria.cue linhas 42-46) não
		contém prefixo para os tipos api-spec.

		Consequência mecânica: qualquer instância de #StructuralCheck
		para a convenção api-spec falha em cue vet — o campo
		artifactType não pode receber valor não-listado no enum
		fechado. B.2 não pode nascer sem extensão prévia da fonte
		de verdade do enum.

		A descoberta deste bloqueador foi precoce — ocorreu durante
		validação adversarial do schema esqueletal, antes de
		qualquer tentativa de escrever o structural-check. Resolver
		agora, em decisão atômica isolada, é mais barato do que
		descobrir no meio de B.2 com pressão de scope criando
		incentivo para atalhos. A natureza do bloqueador (extensão
		de enum fechado que outros schemas referenciam) é
		estrutural e merece ADR próprio per CLAUDE.md.

		Alternativas consideradas e rejeitadas:

		- (a) Single umbrella value 'api-spec' cobrindo ambos os
		  flavors. Rejeitada: colapsa duas identidades ontológicas
		  distintas (#OpenAPISpec governa síncrono OpenAPI 3.x;
		  #AsyncAPISpec governa assíncrono AsyncAPI 2.x) sob um
		  único artifactType. Structural-checks que precisem
		  discriminar enforcement por flavor (e.g., presença
		  condicionada a hasSyncSurface vs hasAsyncSurface)
		  perderiam a capacidade de despachar pelo tipo. A camada
		  de unificação correta entre os dois é a convenção
		  (api-spec-convention.cue), não o enum.

		- (b) Adiar a extensão até o momento de escrever o
		  structural-check em B.2. Rejeitada: o bloqueador já está
		  identificado e a resolução é mecânica — adiar significa
		  carregar uma dependência conhecida não-resolvida pelo
		  resto de B.1, criando risco de descoberta tardia ou de
		  atalho ao chegar em B.2. Resolver na ordem em que o
		  bloqueador é detectado é mais honesto e mais barato.

		- (c) Não estender o enum e aceitar que api-spec viva sem
		  structural-check. Rejeitada: viola o ponto central de
		  adr-040 — schema declara ontologia E structural-check
		  enforça invariantes. Tipo cujas invariantes não podem
		  ser enforçadas porque a fonte de verdade do enum bloqueia
		  o structural-check é uma violação categórica do split
		  adr-040. Implicaria também aceitar que #OpenAPISpec /
		  #AsyncAPISpec ficam para sempre como tipos órfãos do
		  regime de gating estrutural, contradizendo o motivo de
		  existirem como artifact schemas.

		- (d) Trocar #ArtifactType por string aberto em
		  #StructuralCheck.artifactType. Rejeitada: enum fechado é
		  mecanismo deliberado em quality-criteria.cue (comment
		  explícito linhas 16-19: 'deliberadamente restrito aos
		  artefatos com critérios de qualidade específicos
		  validados na prática'). Abrir significaria perder
		  enforcement compile-time de que structural-checks só
		  existem para tipos sob regime conhecido — exatamente o
		  que o enum protege. Custo de extensão é baixo
		  (acrescentar dois valores); benefício do enum permanece.
		"""

	decision: """
		Duas mudanças acopladas em
		architecture/artifact-schemas/quality-criteria.cue,
		aplicadas no mesmo commit que esta ADR:

		(1) [enum-extension] Estender #ArtifactType para incluir
		dois novos valores: 'openapi-spec' e 'asyncapi-spec'. Os
		valores são adicionados como entradas do enum fechado
		existente, preservando a propriedade de fechamento. A
		ordem de inserção segue agrupamento natural ao final do
		enum (não há ordenação semanticamente significativa no
		enum atual).

		(2) [abbrev-extension] Estender a lista canônica de
		abreviações no comment block (linhas 42-46) para incluir
		'oas (openapi-spec)' e 'aas (asyncapi-spec)'. Ambas as
		abreviações têm 3 caracteres, dentro do range permitido
		pelo regex de #QualityCriterion.id ([a-z]{2,3}). Escolha
		de oas/aas segue convenção pública dos padrões externos
		(OpenAPI Specification → OAS; AsyncAPI Specification →
		AAS). A forma 2-char 'as' já está canonicamente atribuída
		a artifact-schema, motivando a forma 3-char para evitar
		colisão.

		Promoção a B.0 do WI-027: este ADR e a extensão
		correspondente do enum constituem um novo passo B.0 do
		WI-027, lógico-temporalmente antes de B.2 (criação do
		structural-check). B.0 não altera scope da WI — apenas
		explicita uma dependência mecânica que a estrutura
		original não previa. WI-027 task-spec não é alterado por
		esta ADR (o task-spec não declara fases internas); a
		relação B.0 é registrada nesta ADR como rastreabilidade
		do plano de execução.

		Esta decisão NÃO cria o structural-check da convenção
		api-spec — isso é objeto de B.2. Apenas remove o
		bloqueador mecânico que impedia B.2 de nascer.
		"""

	consequences: """
		Positivas:
		- B.2 do WI-027 pode nascer sem bloqueio mecânico de
		  cue vet.
		- Mantém o enum fechado, preservando o enforcement
		  compile-time de que structural-checks só existem para
		  tipos sob regime conhecido.
		- Preserva a distinção ontológica entre #OpenAPISpec e
		  #AsyncAPISpec, mantendo a possibilidade de
		  structural-checks discriminarem enforcement por flavor.
		- Adiciona dois prefixos canônicos de abreviação alinhados
		  com convenção pública dos padrões externos.

		Negativas:
		- #ArtifactType cresce em 2 valores (17 → 19). Cada novo
		  valor amplia a superfície que precisa permanecer
		  consistente entre quality-criteria.cue,
		  structural-check.cue e self-review-report.cue.
		- Pattern criado: cada novo flavor de api-spec futuro
		  (e.g., GraphQL spec, gRPC proto) exigirá repetir esta
		  extensão. Aceitável: extensão de enum fechado é trabalho
		  mecânico baixo, e a alternativa (string aberto) destrói
		  o valor do enum.
		- Tipos openapi-spec e asyncapi-spec entram em
		  #ArtifactType, mas seus schemas continuam sem
		  _qualityCriteria; portanto, no regime de self-review,
		  permanecem sob fallback-to-universal de
		  criteriaResolution. Coerente com a decisão de adr-040:
		  ontologia primeiro, enforcement via structural-check
		  separado.

		Known gaps declarados (não omitidos):
		- Ausência de instâncias de #StructuralCheck para
		  openapi-spec / asyncapi-spec após este commit é estado
		  esperado, não defeito. A criação dessas instâncias é
		  objeto de B.2 do WI-027.
		- O comment block que cataloga as abreviações é texto
		  livre — não há enforcement automático de que toda
		  abreviação usada em IDs (uq|tq-XX-NN) esteja registrada
		  na lista. Manter sincronizado é responsabilidade
		  editorial. Esta ADR mantém o pattern existente.

		Fronteira regulatória: api-spec governa contratos públicos
		de superfície de BCs — quando a convenção concreta
		materializar-se, BCs regulados (FCE, SCF, BKR, REW, IDC,
		ATO, INS, ITC) podem ter contratos com obrigações
		regulatórias. Esta ADR é meta-estrutural e não toca
		conteúdo de qualquer instância — constraints regulatórias
		sobre api.yaml/async-api.yaml concretos serão tratadas no
		ADR da convenção (B.1) ou no ADR do structural-check
		(B.2).
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	principlesApplied: ["P0", "P1", "P12"]

	supersedes: []

	rationale: "Bloqueador estrutural mecânico revelado por validação adversarial sobre api-spec.cue: #StructuralCheck.artifactType referencia #ArtifactType, enum fechado que não contém os tipos do novo schema. B.2 do WI-027 (criação do structural-check da convenção api-spec) não pode nascer sem extensão prévia. Resolver na ordem em que o bloqueador foi detectado, em decisão atômica isolada, é mais barato e mais honesto do que carregar dependência conhecida não-resolvida pelo resto da execução. reversibility=high refere-se à mecânica do enum: enquanto não houver instâncias de #StructuralCheck consumindo openapi-spec/asyncapi-spec, removê-los é trivial. blastRadius=cross-artifact reflete o escopo real: a mudança toca quality-criteria.cue diretamente e desbloqueia structural-check.cue como consumidor; não atinge o domínio inteiro nem propaga para BCs."
}
