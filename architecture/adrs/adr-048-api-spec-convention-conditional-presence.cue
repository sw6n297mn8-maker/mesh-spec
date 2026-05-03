package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr048: artifact_schemas.#ADR & {
	id:    "adr-048"
	title: "Convenção api-spec: presença bicondicional de specs por capability flags do canvas"
	date:  "2026-04-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-046 criou a categoria architecture/conventions/ e o
		template tmpl-create-convention@v1 (Parte A meta-estrutural
		de WI-027). adr-047 estendeu #ArtifactType com
		openapi-spec e asyncapi-spec (B.0 — pré-requisito mecânico
		de B.2). O schema esqueletal api-spec.cue está frozen com
		self-review stable em 2 rounds (commit 4bc1aac).

		WI-027 B.1 é a primeira convenção concreta do repositório:
		deve codificar o protocolo que relaciona canvas.capabilities
		(hasSyncSurface, hasAsyncSurface) com a presença de
		api.yaml e async-api.yaml em contexts/{bc}/. A relação é
		latente no design — canvas declara flags, schemas de
		api-spec declaram paths canônicos, tq-cv-11 (warn) já
		avalia consistência entre flags e communication entries —
		mas nenhum artefato formaliza o protocolo completo de
		presença condicionada como norma enforceável.

		Sem convenção: a relação vive em rationales individuais
		(api-spec.cue header, canvas.cue tq-cv-11), prosa de
		ADRs (adr-040 menciona delegação a structural-check), e
		conhecimento tácito (agente assume presença quando flag
		é true). Drift por construção: três fontes parciais do
		mesmo protocolo sem ponto canônico único.

		Com convenção: norma vive em um artefato, enforcement
		vive em structural-check (B.2), review advisory vive em
		validation prompt (follow-up). P0 satisfeito —
		localização canônica única do protocolo.

		A convenção NÃO cria schema central #Convention —
		decisão deferida até n=2 convenções concretas existirem
		(pattern ten-009, adr-046 decisão 1). A shape da
		convenção é livre nesta fase; padrão editorial extraído
		do template tmpl-create-convention@v1.

		A convenção NÃO materializa o structural-check — B.2
		é objeto de decisão separada. B.2 depende de avaliar se
		o kind necessário (presença condicional cross-artifact)
		é expressável nos kinds v1 do schema de structural-check
		(per adr-041) ou se exige extensão. Esta separação
		convenção→check é deliberada: a norma deve existir
		antes do mecanismo, não ser criada junto com o mecanismo.

		Alternativas consideradas e rejeitadas:

		- (a) Embutir o protocolo dentro do schema #Canvas
		  (estender capabilities com descrição dos outputs que
		  cada flag espera). Rejeitada: schemas descrevem
		  estrutura interna do próprio tipo. Descrever presença
		  de api.yaml dentro do canvas viola P0 (protocolo
		  viveria em dois lugares: canvas e api-spec.cue) e P1
		  (schema de um tipo não define campos de outro tipo).
		  Mesma alternativa rejeitada em adr-046 contexto (c).

		- (b) Promover a relação a princípio em
		  design-principles.cue. Rejeitada: princípios são
		  invariantes universais do sistema; esta relação é
		  específica ao par canvas↔api-spec. Se amanhã um BC
		  tiver superfície gRPC, a relação canvas↔grpc-spec
		  será outra convenção, não extensão deste princípio.
		  Mesma alternativa rejeitada em adr-046 contexto (b).

		- (c) Criar structural-check e convenção no mesmo
		  commit (fundir B.1 e B.2). Rejeitada: o kind
		  necessário para o check (cross-artifact conditional
		  presence) pode não ser expressável nos 3 kinds v1 de
		  adr-041 — dependência desconhecida. Fundir forçaria
		  resolver a expressividade do schema de check dentro
		  do escopo desta ADR, inflando blast radius. Separar
		  mantém cada decisão atômica e isolada.

		- (d) Adiar a convenção até o structural-check ser
		  viável (escrever B.2 antes de B.1). Rejeitada: a
		  norma deve existir independente do mecanismo de
		  enforcement — o protocolo é real mesmo sem gate
		  materializado. Adiar a norma porque o gate não
		  existe inverte a relação correta (norma primeiro,
		  gate depois). Agentes sem convenção dependem de
		  inferência tácita a partir de múltiplas fontes
		  parciais — exatamente o drift que motivou a WI.
		"""

	decision: """
		Criar architecture/conventions/api-spec-convention.cue
		como primeira convenção concreta do repositório,
		codificando o protocolo de presença bicondicional entre
		canvas capability flags e API specs.

		(1) [governedTypes] Três tipos governados: canvas
		(upstream), openapi-spec (downstream), asyncapi-spec
		(downstream). Cada tipo referenciado por schema
		canônico e definition (#Canvas, #OpenAPISpec,
		#AsyncAPISpec).

		(2) [upstreamSources] Canvas é SoT por relação:
		capabilities.hasSyncSurface dirige api.yaml,
		capabilities.hasAsyncSurface dirige async-api.yaml.
		sourceField é referência documental, não compile-time —
		staleness é detectada pelo structural-check que lê o
		canvas diretamente.

		(3) [presenceConditions] Bicondicional (if-and-only-if)
		por bounded context: flag true → spec DEVE existir;
		flag false → spec NÃO DEVE existir. Flag false com spec
		presente não é estado válido estável — é drift a ser
		removido no mesmo commit ou no seguinte, antes do próximo
		gate de conformidade. Precondição: canvas.cue deve
		existir no BC para que condições ativem.

		(4) [materialization] pure-authored — specs são escritos
		conforme padrão externo (OpenAPI 3.x / AsyncAPI 2.x);
		convenção declara quando, não como.

		(5) [validationPolicy] Duas camadas per adr-040:
		- structural: follow-up (B.2 do WI-027). Invariante de
		  presença é decidível por inspeção de filesystem. B.2
		  decidirá entre expressar a regra por composição dos
		  kinds existentes, se isso for semanticamente
		  suficiente, ou introduzir extensão explícita do
		  schema de structural-check.
		- advisory: follow-up. Coerência entre communication
		  entries do canvas e operações no spec é dimensão
		  interpretativa, complementar a tq-cv-11.
		  Validation prompt para 'convention' não existe.

		(6) [regulatoryBoundary] Convenção governa presença, não
		conteúdo. BCs regulados têm obrigações sobre conteúdo
		dos specs — responsabilidade de cada BC e de enforcement
		futuro, não desta convenção.

		A convenção é singleton CUE sem schema parent
		#Convention. Shape livre nesta fase — deferido até n=2
		per adr-046. Padrão editorial extraído de
		tmpl-create-convention@v1.
		"""

	consequences: """
		Positivas:
		- Protocolo de presença condicionada ganha localização
		  canônica única. Agentes leem um artefato, não três
		  fontes parciais.
		- Norma existe antes do mecanismo — B.2 pode ser
		  executado contra norma já formalizada, não contra
		  inferência tácita.
		- Bicondicionalidade explicita captura ambos os sentidos
		  de drift: spec ausente quando flag é true, e spec
		  órfão quando flag é false.
		- architecture/conventions/ deixa de ser diretório vazio
		  — a categoria criada por adr-046 tem sua primeira
		  instância.

		Negativas:
		- Enforcement da norma é exclusivamente editorial/manual
		  até B.2 materializar o structural-check. Agentes que
		  não leiam a convenção podem violar o protocolo sem
		  sinal mecânico.
		- Shape livre sem #Convention schema dificulta validação
		  mecânica da estrutura da convenção — somente cue vet
		  de sintaxe, sem unificação contra tipo.
		- presenceConditions usa strings livres para
		  condition/effect — enforcement é pelo structural-check,
		  não por parsing destas strings. Gap semântico entre
		  declaração e execução.

		Known gaps declarados (não omitidos):
		- Structural-check (B.2) é follow-up explícito. Kind
		  necessário (presença condicional cross-artifact) pode
		  exigir extensão do schema v1 de structural-check.
		- Advisory (validation prompt para convention) é
		  follow-up separado. Custo de parsing OpenAPI/AsyncAPI
		  para comparação com canvas justifica deferral.
		- #Convention schema central deferido até n=2.
		- sourceField em upstreamSources é string documental,
		  não referência compile-time.

		Fronteira regulatória: api.yaml/async-api.yaml de BCs
		regulados podem conter contratos com obrigações
		regulatórias. Esta ADR governa presença condicionada a
		flags, não conteúdo. Constraints regulatórias sobre
		conteúdo são responsabilidade do enforcement futuro do
		padrão externo, não desta convenção.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: []

	plannedOutputs: [
		"architecture/conventions/api-spec-convention.cue",
	]

	principlesApplied: ["P0", "P1", "P10", "P12"]

	supersedes: []

	rationale: "Protocolo de presença condicionada entre canvas capability flags e API specs vivia disperso em rationales individuais, prose de ADRs e conhecimento tácito — três fontes parciais do mesmo protocolo sem ponto canônico único. Convenção fixa a norma em artefato dedicado conforme a categoria criada por adr-046. Bicondicionalidade (flag true → spec deve existir; flag false → spec não deve existir) torna ambos os sentidos de drift explícitos e enforceáveis. Esta convenção fixa a norma antes do mecanismo; a materialização do gate estrutural permanece dependente de decisão adicional sobre a expressividade do schema de structural-check. reversibility=high porque a convenção é aditiva sem consumidores mecânicos até B.2; blastRadius=cross-artifact porque governa relação entre canvas e api-specs em todos os BCs."
}
