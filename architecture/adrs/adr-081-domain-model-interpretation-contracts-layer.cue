package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr081: artifact_schemas.#ADR & {
	id:    "adr-081"
	title: "Introduce interpretation contracts layer in DomainModel schema (consistencyBoundary + systemConsistencyModel + decisionAuthorityModel)"
	date:  "2026-05-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Schema #DomainModel + #Aggregate (architecture/artifact-schemas/
		domain-model.cue) modela building blocks DDD (events, commands,
		invariants, valueObjects, aggregates, lifecycles, policies,
		projections) — mas NÃO modela CONTRATOS DE INTERPRETAÇÃO do
		domínio: como consumers cross-BC devem tratar resultados; qual
		é o modelo de consistência cross-aggregate; quais garantias
		falham e como.

		Tensão estrutural emergiu durante materialização de WI-046 REW
		Phase 3 (commit 31feaf9 Part 1 + S5 Part 2 em draft):
		(1) Cross-aggregate interactions (evt-risk-evaluation-emitted →
		    evt-risk-alert-raised) sem declaração explícita de
		    consistência. Default 'eventual via events' funciona, mas
		    consumers assumem consistência mais forte possível sem
		    declaração — over-promise por construção.
		(2) Aggregate boundaries (agg-risk-evaluation, agg-risk-alert,
		    agg-risk-model, agg-risk-policy) com responsabilidade
		    transacional implícita — quebra arquitetural fácil em
		    escala (alert mutando evaluation; model state vazando
		    cross-aggregate; etc).
		(3) Decision authority sem declaração: consumers (CMT, FCE,
		    SCF) integrando REW NÃO sabem se eligibility decision é
		    authoritative (DEVEM obedecer) ou advisory (PODEM ignorar)
		    sem ler outer rationale prose. Risk de divergência
		    cross-BC silenciosa.

		Founder Phase 3 directive (insights canonical): 'sem declarar
		consistência, usuários assumem a mais forte possível' +
		'sem decisionAuthorityModel, integração com outros BCs vai
		quebrar silenciosamente' + 'aggregate boundary não é
		agrupamento lógico — é contrato de consistência'. Conceitos
		NÃO são dados operacionais; são CONTRATOS DE INTERPRETAÇÃO do
		domínio que governam integração cross-BC + comportamento sob
		concorrência + handling de falhas.

		3 alternativas consideradas:
		(A1) Documentar via prose em rationale fields existentes.
		     REJEITADA — declarações ad-hoc; não inspecionáveis
		     programaticamente; runner futuro NÃO pode validar
		     consistencyBoundary não-overlapping cross-aggregates;
		     consumers integrando lêem prose, NÃO structured data.
		(A2) Criar artefato novo 'architecture/consistency-models/
		     <bc>.cue'. REJEITADA — fragmenta enforcement em múltiplos
		     lugares; cria nova categoria de artefato sem precedente;
		     viola 'lugar único de verdade'. Domain-model é onde
		     building blocks vivem; contratos de interpretação dos
		     building blocks vivem juntos.
		(A3) Schema extension: adicionar 3 types + 3 optional fields
		     ao #DomainModel/#Aggregate. ADOPTED — preserva 'lugar
		     único de verdade' (domain-model carrega building blocks +
		     contracts); fields optional = backward-compat (INV/DLV/
		     SSC/PG/P2P existentes preservados sem migration); types
		     marcados via #InterpretationContractMarker embedding
		     previnem mistura semântica com operational data.
		"""

	decision: """
		ADOPT 7 mudanças coordenadas em
		architecture/artifact-schemas/domain-model.cue:

		(D1) Add #InterpretationContractMarker definition (embedded
		     marker pattern para single source of truth de _meta value;
		     previne drift cross-type via convenção):
		     #InterpretationContractMarker: {
		         _meta: "interpretation-contract"
		     }

		(D2) Add #ConsistencyBoundary type (closed struct embedding
		     marker):
		     - guarantees: non-empty list of non-empty strings
		     - explicitlyDoesNotGuarantee: non-empty list
		     - failureModes: non-empty list
		     - rationale: non-empty string
		     - _meta via embedding

		(D3) Add #SystemConsistencyModel type (closed struct embedding
		     marker):
		     - type: "eventual" | "strong" | "causal"
		     - intraAggregateGuarantees: non-empty list
		     - crossAggregateGuarantees: non-empty list
		     - explicitlyDoesNotGuarantee: non-empty list
		     - conflictResolution: {strategy: "last-write-wins" |
		       "explicit-command" | "causal-ordering", rationale: string}
		     - rationale: non-empty string
		     - _meta via embedding

		(D4) Add #DecisionAuthorityModel as discriminated union
		     (paralelo a #DomainEvent pattern):
		     #DecisionAuthorityModel:
		         #AuthoritativeAuthority |
		         #AdvisoryAuthority |
		         #HybridAuthority

		     Cada branch obriga scope field correspondente E PROÍBE
		     scopes não-aplicáveis via _|_ (bottom — torna estado
		     misto irrepresentável):
		     - #AuthoritativeAuthority: type='authoritative',
		       authoritativeScope obrigatório, advisoryScope?: _|_
		     - #AdvisoryAuthority: type='advisory',
		       authoritativeScope?: _|_, advisoryScope obrigatório
		     - #HybridAuthority: type='hybrid', AMBOS scopes
		       obrigatórios

		(D5) Add optional field consistencyBoundary?: #ConsistencyBoundary
		     to #Aggregate.

		(D6) Add optional fields to #DomainModel:
		     - systemConsistencyModel?: #SystemConsistencyModel
		     - decisionAuthorityModel?: #DecisionAuthorityModel

		(D7) NO new quality criteria (tq-dm-18+) added in this ADR —
		     contratos são DECLARATIVOS (informational), não enforced
		     em cue vet. Future ADR pode adicionar criteria como
		     'aggregate com consistencyBoundary deve ter overlap-free
		     guarantees cross-aggregates' ou 'systemConsistencyModel.
		     type=strong implies all aggregates declare
		     consistencyBoundary' — deferred até evidência empírica.

		**RESTRIÇÕES (manter compatibility)**:
		- Nenhuma alteração nos fields existentes de #DomainModel ou
		  #Aggregate (events, commands, invariants, valueObjects,
		  aggregates, modules, policies, projections, rationale, etc.
		  inalterados)
		- Compatibilidade total com domain-model instances existentes
		  (INV, DLV, SSC, P2P, REW Part 1) — fields novos são optional;
		  cue vet de instances atuais NÃO afetado
		- Marker via #InterpretationContractMarker embedding evita
		  duplicação inline + previne drift cross-type (single source
		  of _meta value)

		**3 GUARDRAILS APLICADOS via founder pre-write tightening**:
		(G1) Listas non-empty: [string & !='', ...string & !=''] em
		     todas guarantees/doesNotGuarantee/failureModes — 'contrato
		     vazio é pior que ausência de contrato'.
		(G2) Marker via embedding (não inline _meta literal): previne
		     drift de _meta value cross-type + aproveita CUE hidden
		     field semantics (`_*` não exportado em cue export).
		(G3) Discriminated union exclusiva via _|_: estado inválido
		     (advisory com authoritativeScope) é IRREPRESENTÁVEL por
		     construção — 'se o estado inválido for representável,
		     ele vai aparecer'.

		**Conceito central introduzido**: 'INTERPRETATION CONTRACT
		LAYER' — separa data declarations (events, VOs, etc.) de
		interpretation contracts (consistency, authority, failure
		handling). Sem essa separação, schemas mais expressivos viram
		'feature creep'. Marker #InterpretationContractMarker torna a
		separação inspecionável por tooling (futuro runner pode
		filtrar interpretation-contract types via _meta value;
		consumers podem extrair structured contracts em vez de
		parsing prose).
		"""

	consequences: """
		(a) Domain-models ganham capacidade de declarar contratos de
		    interpretação como structured data — inspecionáveis por
		    tooling, integração cross-BC, validação cross-aggregate.

		(b) REW Phase 3 Part 2 pode declarar:
		    - 4 consistencyBoundary (1 per aggregate)
		    - 1 systemConsistencyModel (eventual + explicit-command
		      conflict resolution)
		    - 1 decisionAuthorityModel (authoritative + risk-assessment
		      scope)

		(c) Consumers cross-BC (CMT/FCE/SCF integrando REW) ganham
		    contract structured para integração: REW eligibility é
		    authoritative (DEVEM tratar como source of truth); REW
		    consistency é eventual (DEVEM tolerar staleness); cross-
		    aggregate failure modes declarados (DEVEM handlear).

		(d) Pattern transversal — Phase 3 future de outros BCs (CMT,
		    FCE, SCF, NIM, NPM) ganha vocabulário canonical para
		    declarar mesmas dimensões. INV/DLV/SSC/P2P existentes
		    podem retroativamente declarar contracts em commits
		    posteriores (não obrigatório por backward-compat).

		(e) Tooling atual permanece funcional — schema additions são
		    optional fields; instances atuais (INV/DLV/SSC/P2P/REW
		    Part 1) cue vet OK sem qualquer mudança.

		(f) Marker #InterpretationContractMarker previne drift
		    semântico ao longo do tempo: quando alguém adiciona
		    consistencyBoundary em novo BC, marker recordsa que
		    aquilo NÃO é dado operacional. Documentation por
		    construção via embedded type.

		(g) Validation-prompts (advisory layer per adr-040) ganham
		    estrutura para avaliar:
		    - Coerência entre consistencyBoundary.guarantees vs
		      protectsInvariants do aggregate
		    - Alinhamento entre systemConsistencyModel.type vs
		      lifecycle modeling (strong consistency requer fewer
		      eventual transitions)
		    - decisionAuthorityModel scope vs canvas outbound
		      events (authoritative scope deve aparecer como
		      published events no canvas)

		(h) Pattern paralelo a adr-080 (#StructuralCheck domain-
		    invariant kind) + adr-076 (#ADR schema hardening) —
		    sequência de schema evolution emergente de WI bootstraps
		    demonstra metodologia 'evolução governada via descoberta
		    empírica' (Mesh-level moat).

		(i) RISCO RESIDUAL declarado: contracts declarados em domain-
		    model são informational até tooling consumir (Phase 4
		    agent-spec referencing contracts; Phase 5 envelope
		    governance referencing contracts; future runner validation).
		    Founder explicit acknowledgment: 'se isso não for usado
		    até Phase 4, vira decoração'. Mitigation: REW Phase 3
		    Part 2 será primeira aplicação; Phase 4 agent-spec terá
		    direta referência aos contracts via outbound integration
		    contracts.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/domain-model.cue",
	]

	plannedOutputs: [
		"#InterpretationContractMarker definition (architecture/artifact-schemas/domain-model.cue)",
		"#ConsistencyBoundary type",
		"#SystemConsistencyModel type",
		"#DecisionAuthorityModel discriminated union (#AuthoritativeAuthority | #AdvisoryAuthority | #HybridAuthority) com exclusividade via _|_",
		"consistencyBoundary?: optional field in #Aggregate",
		"systemConsistencyModel?: optional field in #DomainModel",
		"decisionAuthorityModel?: optional field in #DomainModel",
	]

	derivedArtifacts: [
		"contexts/rew/domain-model.cue (Phase 3 Part 2 — primeira aplicação: 4 consistencyBoundary + 1 systemConsistencyModel + 1 decisionAuthorityModel)",
	]

	principlesApplied: [
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-076-harden-adr-schema-and-extend-structural-check-with-at-least-one-block-present",
		"adr-080-extend-structural-check-domain-invariants",
	]

	rationale: """
		Reversibility medium: schema addition é optional/non-breaking
		(novos fields + types isolados), mas remoção pós-adoção
		exigiria backward-incompat ADR + migration de domain-model
		instances que adotarem (REW Phase 3 Part 2 será primeira;
		potencial backfill futuro). BlastRadius cross-cutting: schema
		domain-model é central; afeta TODOS BCs futuros + retroativo
		opcional.

		Decisão prioriza UNIFICAÇÃO ('lugar único de verdade' — domain-
		model carrega building blocks + contracts) sobre PUREZA
		TEÓRICA (separar artefatos por categoria conceitual). Marker
		via #InterpretationContractMarker embedding resolve a tensão:
		types ESTÃO no domain-model.cue, mas embedding explícito previne
		mistura semântica com operational data + aproveita CUE hidden
		field semantics (`_meta` não exportado em cue export).

		3 guardrails finais aplicados pre-write (founder Phase 3
		tightening):
		(G1) Listas non-empty — contrato vazio é pior que ausência
		(G2) Marker via embedding — single source of _meta value
		(G3) Discriminated union exclusiva via _|_ — estado inválido
		     irrepresentável

		Conceito central 'INTERPRETATION CONTRACT LAYER' transforma
		domain-model de:
		  'declaração de building blocks DDD' →
		  'declaração de building blocks DDD + contratos de
		   interpretação para integração e operação'

		Sem este shift, REW Phase 3 Part 2 (4 aggregates + cross-
		aggregate interactions) declararia contracts via prose em
		rationale — impossível de validar programaticamente,
		impossível de extrair para consumers cross-BC, drift
		silencioso ao longo de Phases futuras.

		Pattern emergente: schema evolution segue WI bootstraps
		descobrindo gaps. INV bootstrap descobriu domain-invariant
		kind (adr-080); REW bootstrap descobriu interpretation
		contracts layer (este ADR). Próximos BCs vão descobrir
		próximos gaps. Metodologia 'evolução governada via descoberta
		empírica' previne over-engineering preemptivo (não inventamos
		conceitos antes de evidence) + drift silencioso (cada
		descoberta vira ADR + schema extension explícita).
		"""
}
