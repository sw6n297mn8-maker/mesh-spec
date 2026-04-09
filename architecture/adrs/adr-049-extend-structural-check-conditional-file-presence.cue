package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr049: artifact_schemas.#ADR & {
	id:    "adr-049"
	title: "Extend structural-check with kind conditional-file-presence"
	date:  "2026-04-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-048 criou a primeira convenção concreta do repositório
		(api-spec-convention.cue), codificando o protocolo de
		presença bicondicional entre canvas capability flags
		(hasSyncSurface, hasAsyncSurface) e API specs (api.yaml,
		async-api.yaml). A convenção declara a norma; o enforcement
		estrutural é follow-up explícito (B.2 de WI-027).

		B.2 exige decidir: o kind necessário para o check
		(presença condicional de arquivo cross-artifact) é
		expressável por composição dos kinds v1 existentes, ou
		exige extensão explícita do schema?

		Análise dos 3 kinds v1 (per adr-041):

		- required-block: verifica presença de bloco nomeado NO
		  MESMO artefato. api.yaml é arquivo separado do canvas,
		  não bloco dentro dele. Não se aplica.

		- reference-exists: verifica referências INTRA-ARTEFATO.
		  Cross-artifact reference checking está explicitamente
		  fora da v1 (comentário no schema e decisão (2) de
		  adr-041). Não se aplica.

		- same-artifact-consistency: verifica relação entre blocos
		  DO MESMO artefato. Canvas e api.yaml são artefatos
		  distintos em paths distintos. Não se aplica.

		Conclusão: composição dos kinds v1 não é semanticamente
		suficiente. Nenhum kind opera sobre dois artefatos; a
		necessidade concreta é ler um booleano em um artefato-fonte
		(canvas) e verificar existência/ausência de um arquivo-alvo
		(api.yaml/async-api.yaml) no mesmo scope de diretório.

		Alternativas consideradas e rejeitadas:

		- (a) Composição dos kinds v1 existentes. Rejeitada pela
		  análise acima: todos os 3 kinds são intra-artifact. Forçar
		  composição exigiria reinterpretar semântica (e.g., tratar
		  api.yaml como "bloco" de canvas) — desonesto com o
		  contrato do kind e com o runner futuro.

		- (b) Kind genérico cross-artifact-reference. Rejeitada:
		  sobredimensionado para o caso concreto. A necessidade é
		  presença condicional de arquivo por path, não referência
		  genérica entre artefatos. Um meta-kind cross-artifact
		  genérico exigiria definir semântica de "artefato"
		  (parsing, resolução de campos, namespace) que está fora
		  do escopo. Per adr-041: crescimento orgânico por caso
		  concreto, não por especulação.

		- (c) Adiar extensão até mais casos cross-artifact
		  existirem. Rejeitada: a convenção (adr-048) já formaliza
		  a norma e declara enforcement estrutural como follow-up.
		  Adiar o check deixa a convenção sem enforcement além do
		  editorial/manual. O caso concreto existe — adr-041
		  define que novos kinds são adicionados quando casos
		  concretos aparecem, e este é o primeiro.

		- (d) Rule como snippet CUE arbitrário para o check
		  específico. Rejeitada pelo mesmo argumento de adr-041:
		  transforma o schema em mini-DSL cuja semântica de
		  execução não é decidível por inspection — viola P10.
		"""

	decision: """
		Estender #StructuralCheck com 4º kind:
		conditional-file-presence.

		(1) [kind] conditional-file-presence — verifica presença
		ou ausência de um arquivo-alvo por path, condicionada a
		um campo booleano em um artefato-fonte no mesmo scope de
		diretório. O kind é deliberadamente sobre arquivo por
		path, não sobre "artefato" abstrato — evita escorregar
		para meta-kind cross-artifact genérico prematuramente.

		(2) [rule shape] #ConditionalFilePresenceRule com 4 campos:
		- sourcePattern: glob pattern do artefato-fonte (wildcard
		  * delimita o scope compartilhado com target).
		- conditionField: caminho dot-separated ao campo booleano
		  no artefato-fonte.
		- targetPattern: path pattern do arquivo-alvo (mesmo *
		  scope).
		- biconditional: bool. true = field true exige target,
		  field false proíbe target. false = apenas field true
		  exige target.

		(3) [instâncias] Duas instâncias em
		architecture/structural-checks/canvas.cue (mesmo arquivo
		de sc-cv-01, organizado por artifactType):
		- sc-cv-02: hasSyncSurface → api.yaml, biconditional=true.
		- sc-cv-03: hasAsyncSurface → async-api.yaml,
		  biconditional=true.
		artifactType das instâncias: "canvas" — check é ancorado
		no canvas como upstream SoT.

		(4) [schema edits] Adição de "conditional-file-presence"
		a #StructuralCheckKind, #ConditionalFilePresenceRule a
		#StructuralCheckRule, e 4º braço na união discriminada
		de #StructuralCheck.

		(5) [runner] O runner concreto não é parte desta decisão
		(mesma posição de adr-041). O kind é runner-friendly:
		encontrar sources por glob, extrair campo booleano,
		verificar presença/ausência de arquivo por path. Lógica
		determinística, sem ambiguidade interpretativa.
		"""

	consequences: """
		Positivas:
		- api-spec-convention ganha enforcement estrutural
		  materializado. Norma (B.1) e mecanismo (B.2) coexistem
		  — agentes recebem sinal mecânico, não apenas editorial.
		- Schema de structural-check cresce organicamente por caso
		  concreto, conforme modelo de adr-041. Primeiro kind
		  adicionado após a v1 original.
		- Bicondicionalidade é enforçável mecanicamente: flag true
		  sem spec e flag false com spec são ambos detectáveis.
		- Kind é sobre arquivo por path — runner não precisa
		  parsear conteúdo do target, apenas verificar existência
		  no filesystem.

		Negativas:
		- Schema passa de 3 para 4 kinds. Cada kind adiciona uma
		  implementação no runner futuro. Custo aceito: o kind é
		  mínimo (4 campos) e cobre caso concreto real.
		- sourcePattern usa glob com * — runner precisa resolver
		  wildcard e mapear scope entre source e target.
		  Complexidade menor que parsing de conteúdo, mas é lógica
		  de correspondência de path que v1 não tinha.
		- Self-review de structural-check.cue v1 fica stale nos
		  detalhes (mencionava 3 kinds) — staleness editorial
		  aceita, cobertura do delta pela self-review de adr-049.

		Known gaps declarados:
		- Runner concreto não existe. Kind é runner-friendly por
		  construção, mas execução depende de implementação futura.
		- conditionField como string dot-separated não é referência
		  compile-time ao canvas schema — mesma limitação de
		  sourceField em api-spec-convention.cue.
		- Scope matching entre sourcePattern e targetPattern depende
		  de wildcards na mesma posição — runner precisa validar
		  consistência dos patterns.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"architecture/structural-checks/canvas.cue",
	]

	principlesApplied: ["P10", "P12"]

	supersedes: []

	rationale: "Primeiro kind adicionado ao schema de structural-check após a v1 original (adr-041). O caso concreto motivador é o enforcement da convenção api-spec (adr-048, B.2 de WI-027): presença condicional de api.yaml/async-api.yaml por canvas capability flags é check cross-artifact que nenhum kind intra-artifact da v1 expressa. Kind conditional-file-presence é deliberadamente sobre arquivo por path — mínimo, focado, sem escorregar para meta-kind cross-artifact genérico. reversibility=high porque kind é aditivo e runner não existe; blastRadius=cross-artifact porque governa relação canvas↔api-specs em todos os BCs."
}
