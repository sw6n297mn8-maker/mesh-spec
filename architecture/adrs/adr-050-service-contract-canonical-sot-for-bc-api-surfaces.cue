package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr050: artifact_schemas.#ADR & {
	id:    "adr-050"
	title: "Service contract as canonical SoT for BC API surfaces"
	date:  "2026-04-10"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	context: """
		api.yaml e async-api.yaml viviam como artefatos autorais
		nos diretórios de BC — escritos manualmente, sem schema
		governante, e sem relação formal com o domain model ou o
		canvas do BC. Isso criava três problemas concretos:

		(1) P1 declara CUE como SoT de contratos de domínio, mas
		a superfície de API era a exceção — escrita em YAML sem
		correspondência autoral em CUE. Resultado: drift silencioso
		entre domain model (CUE) e contrato de superfície (YAML).

		(2) Validação era limitada ao padrão externo (OpenAPI/
		AsyncAPI conformance). Critérios de domínio — refs resolvem
		no domain model, erros catalogados, superfície bicondicional
		com canvas flags — não tinham onde viver.

		(3) Relação entre canvas.capabilities (hasSyncSurface,
		hasAsyncSurface) e conteúdo dos specs era apenas editorial.
		api-spec-convention.cue (adr-048) governa presença de
		arquivo, não semântica de conteúdo.

		Alternativas consideradas e rejeitadas:

		- (a) Manter YAMLs como artefatos autorais com schema CUE
		  adicional para validação cross-ref. Rejeitada: CUE
		  validaria YAML por parsing externo — P1 exige que CUE
		  seja SoT, não validador secundário. Dois artefatos
		  autorais para a mesma informação viola P0.

		- (b) Schemas separados por superfície (sync-contract.cue,
		  async-contract.cue). Rejeitada: canvas declara ambas as
		  superfícies como capabilities de um único BC.
		  Bicondicionalidade (tq-ct-04) exige teste cruzado entre
		  sync e async presentes no contrato vs. flags do canvas.
		  Dois schemas separam o que precisa ser validado junto.

		- (c) Estender domain-model.cue com seções de API surface.
		  Rejeitada: domain model governa building blocks táticos
		  (aggregates, events, invariants). API surface é concern
		  de consumidor — inclui semântica HTTP, HATEOAS, auth,
		  erros projetáveis, idempotência, concorrência. Misturar
		  poluiria ambos os artefatos. Service contract referencia
		  domain model por refs, sem absorvê-lo.

		- (d) OpenAPI-in-CUE (transcrever estrutura OpenAPI em
		  CUE). Rejeitada: OpenAPI é spec de formato de transporte,
		  verbosa por natureza. Transcrever paths/parameters/
		  responses em CUE reproduz a estrutura sem agregar
		  semântica de domínio. Melhor: CUE semântico (commands,
		  queries, events, erros) do qual OpenAPI é projeção
		  mecânica.
		"""

	decision: """
		Criar #ServiceContract como artifact schema canônico para a
		superfície de API de cada Bounded Context.

		(1) [SoT] service-contract.cue (instância por BC) é a source
		of truth autoral da superfície síncrona e assíncrona. api.yaml
		e async-api.yaml passam a ser artefatos derivados — gerados
		mecanicamente, nunca editados diretamente. Reclassificação
		em api-spec-convention.cue (pure-authored → derived)
		materializada no commit de propagação desta decisão.

		(2) [schema] #ServiceContract em
		architecture/artifact-schemas/service-contract.cue. Estrutura:
		- name, apiVersion (semver), boundedContextRef, description
		- sync?: #SyncSurface (commands + queries)
		- async?: #AsyncSurface (publishedEvents + consumedEvents)
		- errors: [...#DomainError] — somente erros de negócio
		- defaultAuth: #AuthPolicy — override por operação
		- rationale obrigatório

		(3) [unions discriminadas] Tipos modelados como union para
		eliminar estados inválidos:
		- #CommandOperation = #CreateCommand | #ActionCommand
		  CreateCommand: idempotência obrigatória, concorrência proibida.
		  ActionCommand: concorrência obrigatória, idempotência declarada.
		- #QueryOperation = #SingleQuery | #CollectionQuery
		  SingleQuery: paginação proibida.
		  CollectionQuery: paginação default true.
		- #IdempotencyPolicy: required=false → mechanism proibido;
		  required=true → mechanism obrigatório.
		- #SupervisionRequirement: required=false → approver proibido;
		  required=true → approver obrigatório.

		(4) [quality criteria] 13 critérios (tq-ct-01 a tq-ct-13) em
		3 camadas epistemológicas:
		- Integridade referencial (tq-ct-01 a 03): refs resolvem em
		  domain model e internamente. Mecânico, fail.
		- Alinhamento cross-artifact (tq-ct-04, 05, 11, 12, 13):
		  bicondicionalidade com canvas, ACL boundary, wiring tático,
		  visibility de eventos. Determinístico, fail.
		- Qualidade advisory (tq-ct-06 a 10): naming, descriptions,
		  estado interno, adequação HTTP. Interpretativo, warn. P10.

		(5) [erros de domínio] Somente erros semânticos de negócio
		do BC. Erros de transporte (400 validation, 412 precondition,
		429 rate limit) são platform policy — excluídos do catálogo.
		httpStatusCode é hint de projeção, não mistura de domínio com
		transporte.

		(6) [campos deliberadamente fracos] Dois campos mantidos como
		string livre com follow-up documentado:
		- ConcurrencyPolicy.versionField: ref por convenção, não por
		  tipo. Migra para #FieldRef quando ontologia de domain fields
		  suportar.
		- ConsumedEventEntry.reaction: texto livre descritivo. Migra
		  para ref estruturada quando 2+ instâncias revelarem padrão.
		  Hotspot prioritário de red team.

		(7) [escopo negativo] O que vive fora do service contract:
		retry policy, rate limiting, pagination profile, SLA, observ-
		ability, deprecation schedule, consumer hints — todos são
		platform policy ou overlays. Service contract é semântica de
		superfície, não saco de tudo.
		"""

	consequences: """
		Positivas:
		- CUE é SoT de contratos de API, fechando a exceção que
		  existia em relação a P1. OpenAPI/AsyncAPI são derivados.
		- 13 quality criteria permitem validação que YAML autoral
		  não suportava: refs para domain model, bicondicionalidade
		  com canvas, coerência de wiring tático.
		- Unions discriminadas eliminam estados inválidos por
		  construção — CreateCommand sem concorrência, ActionCommand
		  sem idempotência não declarada, SingleQuery com paginação.
		- Primeiro BC (CTR) instanciado com red team de 3 rounds,
		  validando que o schema é instanciável e os critérios são
		  exercitáveis.
		- api-spec-convention.cue reclassificada de pure-authored
		  para derived (materializada em commit de propagação).

		Negativas:
		- Generator OpenAPI/AsyncAPI não existe. Até existir,
		  derivação é bootstrap manual — operacionalmente frágil.
		  Custo aceito: formalizar norma antes do mecanismo é
		  padrão recorrente do repositório (api-spec-convention
		  fez o mesmo).
		- Cada BC precisa migrar para service-contract.cue. BCs
		  que já tinham YAMLs autorais perdem esses artefatos.
		  Migração é gradual — CTR é primeiro, demais seguem.
		- ConcurrencyPolicy.versionField e ConsumedEventEntry.
		  reaction são strings livres — tipagem fraca consciente
		  com follow-up. Risco: follow-up pode não acontecer e
		  campos viram depósitos semânticos inconsistentes.
		- Validation prompt (validate-service-contract.cue) ainda
		  não existe. Critérios advisory (tq-ct-06 a 10) não têm
		  mecanismo de design review até criação do prompt.

		Dependência de runner cross-BC (sem artefato materializado):
		- tq-ct-01 exige que consumedEvents[].eventRef resolva no
		  domain model. Para eventos consumidos de outro BC, o
		  runner precisa implementar resolução cross-BC: resolver
		  eventRef contra sourceContext domain model, não contra
		  domain model local. Instância CTR (evt-sourcing-decision-
		  made de SSC) documenta esta pré-condição explicitamente.
		  Não há artefato concreto para o runner hoje — path não
		  pode ser listado em affectedArtifacts sem violar
		  tq-adr-03. Quando o runner materializar, deve referenciar
		  adr-050 e implementar resolução cross-BC como requisito.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/service-contract.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/conventions/api-spec-convention.cue",
		"contexts/ctr/service-contract.cue",
	]

	principlesApplied: ["P0", "P1", "P10"]

	supersedes: []

	rationale: "P1 declarava CUE como SoT de contratos de domínio, mas a superfície de API era a exceção — YAMLs autorais sem correspondência CUE. #ServiceContract fecha esta lacuna: CUE semântico (commands, queries, events, erros, auth, HATEOAS) do qual OpenAPI/AsyncAPI são projeções mecânicas. decisionClass=foundational porque estabelece o artefato-chave que conecta canvas (intenção), domain model (building blocks) e API surface (contrato com consumidores) — triângulo de consistência de cada BC. reversibility=medium porque instâncias já existem (CTR) e outros BCs migrarão; reverter exige restaurar YAMLs autorais e reclassificar api-spec-convention. blastRadius=cross-cutting porque afeta todos os BCs e a cadeia de derivação de specs."
}
