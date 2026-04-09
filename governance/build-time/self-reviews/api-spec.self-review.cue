package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

apiSpecSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-api-spec-schema"

	artifactPath:       "architecture/artifact-schemas/api-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-08"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 sobre api-spec.cue aplicando o regime de
			criteriaResolution.fallback declarado em quality-gate.cue:
			schema sem _qualityCriteria entra em fallback-to-universal e
			é avaliado APENAS contra os 8 critérios universais
			(uq-01 a uq-08). Critérios type-specific tq-as-01/02/03 NÃO
			foram aplicados — sua aplicação a um schema sem
			_qualityCriteria é incoerente com o regime fallback. O
			report v1 desta passada cometeu esse erro (afirmou
			'vacuously PASS em tq-as-02/03'); a presente reescrita
			corrige.

			Resultados por critério universal:

			- uq-01 (rationale como WHY, fail): PASS. Os rationales de
			  _schema.location em #OpenAPISpec e #AsyncAPISpec declaram
			  propósito conceitual ('Specs síncronos vivem ao lado do
			  canvas.cue do BC. Presença é condicionada por
			  canvas.hasSyncSurface — enforçada por structural-check
			  da convenção, não por este schema.'), não consequência
			  mecânica.

			- uq-02 (ancoragem em fontes canônicas, fail): PASS. O
			  comment header ancora em adr-040 (separação categórica
			  schema/structural-check), em canvas.hasSyncSurface /
			  hasAsyncSurface (condicionante de presença) e em
			  governance/repo-structure.cue (limitação do mecanismo
			  de file classification a arquivos .cue).

			- uq-03 (referências verificáveis, fail): PASS. Todas as
			  referências citadas existem no repositório:
			  architecture/adrs/adr-040.cue, contexts/cmt/canvas.cue,
			  contexts/ctr/canvas.cue, contexts/idc/canvas.cue,
			  contexts/npm/canvas.cue, governance/repo-structure.cue.

			- uq-04 (alinhamento com princípios, fail): PASS. Schema
			  declarando apenas ontologia (location) sem
			  _qualityCriteria conforma a P0 (zero duplicação:
			  invariantes de presença/coerência vivem em ponto único
			  na convenção e structural-check), P1 (schema-first como
			  primitiva ontológica) e P10 (gates determinísticos
			  validam — schema delega a structural-check, não
			  implementa enforcement).

			- uq-05 (limitações declaradas, warn): WARN. Quatro
			  limitações conhecidas exigem registro explícito; ver
			  findings.warn abaixo.

			- uq-06 (rationale específico ao contexto, fail): PASS. Os
			  rationales referenciam hasSyncSurface/hasAsyncSurface
			  por nome e enunciam o par schema/structural-check
			  específico desta convenção; não são frases genéricas.

			- uq-07 (convenções de naming, fail): PASS. Definições
			  #OpenAPISpec e #AsyncAPISpec seguem PascalCase com
			  prefixo #; arquivo api-spec.cue em kebab-case;
			  canonicalPathRegex e fileNameRegex usam padrões
			  consistentes com a convenção real (api.yaml,
			  async-api.yaml em contexts/<bc>/).

			- uq-08 (conformidade ao artifact schema, fail): PASS.
			  Cada definição instancia _schema.location segundo o
			  padrão nested-in-definition documentado no header de
			  artifact-schema.cue (precedente: adr.cue). Campos
			  obrigatórios canonicalPathRegex, fileNameRegex,
			  description, rationale, cardinality e allowNested
			  presentes nos dois tipos.

			Conclusão round 1: 0 fail, 1 warn (uq-05 expandido em 4
			itens nos findings), 0 info. Não estável ainda — round 2
			necessário para incorporar evidência externa e reavaliar.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 2 incorpora evidência externa: execução do
			validation prompt vp-artifact-schema sobre api-spec.cue
			em sessão isolada (matchPattern
			^architecture/artifact-schemas/[a-z0-9-]+\\.cue$ fez
			match). Os 4 checks do prompt foram executados em
			modo advisory-only:

			- vc-as-01 (especificidade equilibrada, warn, narrative):
			  zero findings. Schema não over-specifica campos
			  opcionais; não under-specifica campos observáveis.
			  location.canonicalPathRegex captura a estrutura
			  relevante sem adicionar constraints prematuros.

			- vc-as-02 (cobertura de _qualityCriteria, fail,
			  finding-only): zero findings. Ausência de
			  _qualityCriteria é decisão deliberada ancorada em
			  adr-040 e legitimada por criteriaResolution.fallback.

			- vc-as-03 (location consistente com instâncias, fail,
			  pass-fail): PASS. canonicalPathRegex e fileNameRegex
			  acomodam o naming previsto para api.yaml e
			  async-api.yaml em contexts/<bc>/; cardinality
			  'collection' é coerente com 'um spec por BC com a
			  surface'.

			- vc-as-04 (preparação para evolução, warn, narrative):
			  zero findings. Schema esqueletal é trivialmente
			  evolutivo dentro da camada de ontologia — extensão
			  futura adiciona campos sem quebrar leitura existente.

			Nota epistemológica: vp-artifact-schema é design review
			advisory de espectro fixo (4 checks definidos pelo
			prompt), não red team adversarial exaustivo. Ausência
			de findings advisory NÃO certifica ausência de
			fragilidades possíveis; significa apenas que os checks
			definidos não detectaram problema sob seu próprio
			framing. Esta distinção é registrada para evitar
			overclaim de validação.

			Reavaliação dos 8 critérios universais à luz da
			evidência advisory: nenhuma transição. uq-01..uq-04 e
			uq-06..uq-08 permanecem PASS. uq-05 permanece WARN —
			as 4 limitações declaradas no round 1 são limitações
			reais, não defeitos corrigíveis dentro do escopo deste
			schema; ficam registradas para visibilidade conforme o
			SeverityPolicy (warn não bloqueia estabilidade).

			Stability condition satisfeita: zero fails em dois
			rounds consecutivos sem alteração estrutural do
			artefato entre rounds. Status final stable.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 1 — file classification em
				governance/repo-structure.cue processa apenas arquivos
				.cue. canonicalPathRegex de #OpenAPISpec e #AsyncAPISpec
				apontam para .yaml, portanto NÃO alimentam o fluxo
				automático de classification por enquanto. Cobertura de
				presença depende exclusivamente do structural-check
				prospectivo da convenção, ancorado em
				canvas.hasSyncSurface/hasAsyncSurface. O comment header
				de api-spec.cue declara essa limitação explicitamente.
				"""
			rationale: """
				Limitação real do mecanismo de classification, não
				defeito do schema. Resolução exige extensão do próprio
				mecanismo de classification para arquivos não-.cue ou
				aceite explícito de que cobertura de presença para
				schemas esqueletais delega inteiramente a
				structural-check. Aceito como limitação conhecida desta
				etapa.
				"""
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 2 — o comment header referencia
				api-spec-convention.cue e structural-check dedicado como
				mecanismos de enforcement das normas de
				presença/coerência. Nenhum dos dois existe no
				repositório no momento da criação deste schema.
				Adicionalmente, o diretório architecture/conventions/
				ainda não existe; sua criação faz parte de WI-027 B.1.
				O texto atual do header pode ser lido como se esses
				mecanismos já existissem — ajuste editorial planejado
				para etapa 4 do pipeline de correção desta passada.
				"""
			rationale: """
				Dependência prospectiva legítima da sequência A→B do
				WI-027 (schema antes da convenção que o usa).
				Materialização da convenção e do structural-check é
				trabalho subsequente explicitamente planejado, não
				trabalho esquecido. Registrado para visibilidade.
				"""
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 3 — versionamento implícito.
				canonicalPathRegex/fileNameRegex codificam os nomes
				api.yaml e async-api.yaml mas não codificam compromisso
				versionado com OpenAPI 3.x ou AsyncAPI 2.x. Os
				comentários do header e os campos description mencionam
				as versões, mas qualquer instância de outra major
				version (e.g., AsyncAPI 3.x) seria aceita por matching
				de path. Verificação de conformance ao padrão externo é
				responsabilidade da convenção/structural-check
				prospectivos, não deste schema.
				"""
			rationale: """
				Esta separação é coerente com adr-040: schema declara
				ontologia (este tipo existe e vive aqui); enforcement
				de versão e conformance estrutural ao padrão externo
				vive em outro lugar. Limitação registrada para que a
				convenção a materialize explicitamente.
				"""
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 4 — bloqueador mecânico para B.2 do WI-027.
				O enum #ArtifactType em
				architecture/artifact-schemas/quality-criteria.cue é
				fechado e NÃO contém valores como 'openapi-spec',
				'asyncapi-spec' ou 'api-spec'.
				#StructuralCheck.artifactType referencia #ArtifactType,
				portanto o structural-check prospectivo da convenção
				não poderá nascer sem extensão do enum. Adicionalmente,
				a lista canônica de abreviações na mesma fonte não
				contém prefixo para api-spec. Resolução requer ADR de
				extensão (planejado como etapa 3 do pipeline de
				correção desta passada — promovido a B.0 do WI-027 como
				pré-requisito mecânico de B.2).
				"""
			rationale: """
				Bloqueador estrutural revelado por validação
				adversarial sobre o schema. Não corrigível dentro de
				api-spec.cue — exige decisão de design separada
				(ADR-047). Registrado aqui para que o report seja
				explícito sobre o estado prospectivo do enforcement
				do tipo.
				"""
		}]
	}

	summary: """
		Self-review stable em 2 rounds para api-spec.cue — artifact
		schema esqueletal declarando #OpenAPISpec e #AsyncAPISpec com
		apenas _schema.location, sem _qualityCriteria por alinhamento
		explícito com adr-040 (schema = ontologia; structural-check =
		enforcement).

		Esta passada SUBSTITUI o report v1 (single-round +
		singleRoundRationale) que aplicou incorretamente
		tq-as-01/02/03 a um schema sem _qualityCriteria — violação
		do regime criteriaResolution.fallback declarado em
		quality-gate.cue. A reescrita refaz o round 1 sob o regime
		correto (apenas universalCriteria) e adiciona round 2
		incorporando execução isolada de vp-artifact-schema como
		evidência externa advisory.

		Zero fail findings nos dois rounds. 1 warn em uq-05 expandido
		em 4 limitações conhecidas: (1) file classification não cobre
		.yaml; (2) convenção e structural-check prospectivos +
		diretório architecture/conventions/ inexistente;
		(3) versionamento implícito do padrão externo; (4) bloqueador
		mecânico do enum #ArtifactType para criação do
		structural-check (motiva ADR-047 como B.0 do WI-027).

		Nota epistemológica registrada no round 2: vp-artifact-schema
		é design review advisory de 4 checks fixos, não red team
		adversarial exaustivo. Ausência de findings advisory significa
		apenas que os checks do prompt não detectaram problema sob
		seu próprio framing.
		"""
}
