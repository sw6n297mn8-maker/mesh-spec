package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr084: artifact_schemas.#ADR & {
	id:    "adr-084"
	title: "Production-safety hardening: extend #SystemConsistencyModel with consumerProtocol + systemFailureModes + replayScopeStrategy (optional fields)"
	date:  "2026-05-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		**RELATIONSHIP TO ADR-081**: This ADR REFINES adr-081 (which
		introduced interpretation contracts layer). adr-081 estabeleceu
		base structure (#ConsistencyBoundary + #SystemConsistencyModel
		+ #DecisionAuthorityModel); adr-084 adds 3 optional fields ao
		#SystemConsistencyModel para fechar gaps de PRODUCTION-SAFETY
		descobertos em pressure test escala REW.

		Sem chain de refinamento, evolução vira ruptura invisível.
		Refinement documented in prose (#ADR.refines field NÃO existe
		ainda — defer schema addition until pattern emerge cross-ADRs:
		nem todo relacionamento estrutural merece virar schema; criar
		field agora seria overfitting de um único caso). Quando ≥3
		ADRs usarem refinement pattern + tooling necessitar inspeção
		programática, future ADR pode formalizar #ADR.refines field.

		---

		Pressure test final escala (founder Phase 3 — pre-Part 2)
		descobriu 3 gaps específicos do sistema REW que NÃO são
		modelados em adr-081 base layer:

		(1) AUTHORITATIVE + EVENTUAL = CONFLITO OPERACIONAL.
		    decisionAuthorityModel='authoritative' implica CMT/FCE/SCF
		    DEVEM tratar REW evaluation como source of truth. Mas
		    systemConsistencyModel='eventual' implica atraso de
		    propagation. Sem protocolo explícito de consumo, consumer
		    pode agir sobre evaluation stale enquanto REW já tem
		    decisão atualizada — duas BCs tomando decisões conflitantes.
		    Sem declarar consumerProtocol, autoridade-sem-sincronização
		    = inconsistência sistêmica.

		(2) FALHA DISTRIBUÍDA NÃO É SOMA DE FALHAS LOCAIS.
		    #ConsistencyBoundary.failureModes (per aggregate) cobre
		    falhas LOCAIS atomicidade. Mas falhas DISTRIBUÍDAS (e.g.,
		    evaluation emit OK + alert raise lag + projection delay
		    + consumer reads parcial) NÃO somam — sistema correto
		    localmente pode ser inconsistente globalmente. Sem
		    systemFailureModes top-level, classes de falha distribuída
		    permanecem implícitas — consumers não sabem o que esperar.

		(3) REPLAY EM LARGA ESCALA REQUIRES GRANULARITY.
		    Em escala (10M+ events em event log), replay GLOBAL para
		    reconstruir 1 entity é inviável. Sem declarar
		    replayScopeStrategy explicitamente (by-entityRef vs
		    by-correlationId vs global), assumed-default falha em
		    produção. Escopo de replay define limite de inteligência
		    do sistema.

		3 alternativas consideradas:
		(A1) Adicionar fields como REQUIRED. REJEITADA — required cedo
		     demais vira acoplamento prematuro; só REW Phase 3 tem
		     evidência empírica; impor required força over-declaration
		     em outros BCs futuros pre-discovery.
		(A2) Documentar via prose em rationale fields existentes.
		     REJEITADA — viola pattern adr-081 (structured contracts >
		     prose); perde inspeção programática.
		(A3) Adicionar 3 OPTIONAL fields + tq-dm-18 (warn severity)
		     como recomendação. ADOPTED. Optional preserva backward-
		     compat com adr-081 instances futuras (REW Part 2 será
		     primeira; outros BCs declaram quando evidência empírica
		     justifique).
		"""

	decision: """
		ADOPT 4 mudanças coordenadas em
		architecture/artifact-schemas/domain-model.cue:

		(D1) Add OPTIONAL field consumerProtocol?: [string & !='',
		     ...string & !=''] em #SystemConsistencyModel. Declares
		     consumer responsibilities sob authoritativeScope (lista
		     non-empty quando presente). MANDATORY for consumers em
		     decisionAuthorityModel.authoritativeScope — enforcement
		     EXTERNAL TO REW (validated via structural-check against
		     consuming BC declarations + ADR overrides). REW publishes
		     contract; consumers (CMT/FCE/SCF) são accountable;
		     violations cross-BC requerem explicit ADR documentando
		     override rationale.

		(D2) Add OPTIONAL field systemFailureModes?: [string & !='',
		     ...string & !=''] em #SystemConsistencyModel. Declares
		     classes de FALHA DISTRIBUÍDA esperadas (falhas que NÃO
		     são soma de failureModes per-aggregate).

		(D3) Add OPTIONAL field replayScopeStrategy?: 'global' |
		     'by-entityRef' | 'by-correlationId' | 'by-aggregateRef'
		     em #SystemConsistencyModel. Declares granularidade de
		     replay. COMPROMISSO OPERACIONAL EXPLÍCITO: o BC declarando
		     este field MUST operate under declared strategy
		     (not just declarative metadata). Runtime infrastructure
		     guarantees:
		     (a) all replay operations honor the declared scope
		     (b) cross-scope replay requests rejected (e.g., cross-
		         entity replay attempt rejected sob by-entityRef regime)
		     (c) future strategy migration requires ADR + data
		         migration plan.

		(D4) Add tq-dm-18 quality criterion (severity: warn) ao
		     #DomainModel _qualityCriteria.criteria:
		     - description: 'systemConsistencyModel SHOULD define
		       consumerProtocol + systemFailureModes +
		       replayScopeStrategy (production-safety hardening)'
		     - severity: 'warn' (recomendação até evidência multi-BC
		       justificar promoção a required — path evolução
		       'warn → warn+tracking → fail' quando ≥3 BCs declararem).

		**RESTRIÇÕES (manter compatibility)**:
		- Nenhuma alteração nos fields existentes de
		  #SystemConsistencyModel (type, intra/cross-aggregate
		  guarantees, conflictResolution, rationale, _meta — todos
		  preservados)
		- Compatibilidade total com adr-081 (refinement não revoga
		  base structure; chain explícito documentado em context)
		- Fields são OPTIONAL — adr-081 instances (zero por enquanto;
		  REW Part 1 NÃO declarou systemConsistencyModel) cue vet OK
		  sem mudança
		- tq-dm-18 severity warn — runner emite recomendação;
		  NÃO bloqueia commits

		**ESCOPO**: Schema-only. Invariants production-safety (4 new
		— inv-rew-computed-must-eventually-emit-or-fail; inv-rew-
		alert-command-idempotency; inv-rew-supersede-requires-current-
		active; inv-rew-signal-validation-before-ingestion) + 2 new
		events (evt-risk-evaluation-emit-failed; evt-signal-rejected)
		+ RiskPolicy field changes (separate windows) vivem em REW
		domain-model instance Part 2. Schema define linguagem;
		invariant + event catalog define comportamento — NÃO misturar
		(misturar aumenta blast radius sem necessidade).
		"""

	consequences: """
		(a) #SystemConsistencyModel ganha 3 dimensões de production-
		    safety declaration (consumer protocol; system-level
		    failure modes; replay granularity) — fecha gaps específicos
		    descobertos em pressure test escala REW.

		(b) REW Phase 3 Part 2 será primeira instância declarando
		    todos 3 fields. Outros BCs (CMT, FCE, SCF, NIM, NPM, etc.)
		    podem retroativamente declarar quando atingirem Phase 3 +
		    pressure test próprio.

		(c) tq-dm-18 (warn severity) força awareness durante review
		    sem bloquear bootstrap. Quando evidência empírica multi-
		    BC justificar promoção a required (severity=fail), future
		    ADR pode endurecer (path evolução documentado: warn →
		    warn+tracking → fail).

		(d) Backward compat preservada — adr-081 instances cue vet
		    OK. Nenhum breaking change.

		(e) Pattern de ADR refinement chain estabelecido via prose
		    (refines field NÃO criado por enquanto — overfitting de
		    caso único). Quando ≥3 ADRs usarem pattern, future ADR
		    pode formalizar #ADR.refines field.

		(f) Production-safety hardening transversal — pattern
		    aplicável a outros BCs ao chegarem em Phase 3 (consumer
		    protocol + failure modes + replay strategy são UNIVERSAIS
		    para sistemas distribuídos).

		(g) Compromisso operacional explícito (replayScopeStrategy):
		    declaração não é só metadata — é binding operacional.
		    BCs declarando MUST operate under declared strategy;
		    cross-scope replay requests rejeitados; migration requires
		    ADR + data migration plan. Previne 'declaração sem
		    compromisso operacional'.

		(h) consumerProtocol enforcement EXTERNAL — REW publica
		    contract; consumers accountable. Violations cross-BC
		    requerem ADR explícito de override (preserva contrato
		    autoritativo + permite overrides documentados quando
		    necessário). Protocolo sem enforcement é documentação,
		    não contrato — enforcement clarity declara MEIO de
		    enforcement (structural-check + ADR review).

		(i) Pattern paralelo a adr-080 (#StructuralCheck domain-
		    invariant kind) + adr-081 (interpretation contracts layer)
		    — sequência de schema evolution emergente de WI bootstraps
		    + pressure tests demonstra metodologia 'evolução governada
		    via descoberta empírica'.
		"""

	reversibility: "high"
	blastRadius:   "local"

	affectedArtifacts: [
		"architecture/artifact-schemas/domain-model.cue",
	]

	plannedOutputs: [
		"consumerProtocol?: optional field in #SystemConsistencyModel",
		"systemFailureModes?: optional field in #SystemConsistencyModel",
		"replayScopeStrategy?: optional field in #SystemConsistencyModel",
		"tq-dm-18 quality criterion (severity warn)",
	]

	derivedArtifacts: [
		"contexts/rew/domain-model.cue (Phase 3 Part 2 — primeira aplicação dos 3 fields + tq-dm-18 warn coverage)",
	]

	principlesApplied: [
		"P10-deterministic-gates-vs-stochastic-recommendations",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-081-domain-model-interpretation-contracts-layer",
	]

	rationale: """
		Reversibility HIGH (não medium): fields são OPTIONAL; remoção
		pos-adoção exigiria apenas remover declarações em instances
		que adotarem (sem migration de data — schema-only).
		BlastRadius LOCAL (não cross-cutting): apenas
		#SystemConsistencyModel afetado; não toca core DDD blocks
		(#Aggregate, #DomainEvent, etc.).

		Decisão prioriza GRADUAL ADOPTION (optional + warn) sobre
		ENFORCEMENT IMEDIATO (required). Justificativa: required cedo
		demais vira acoplamento prematuro — só REW tem evidência
		empírica; outros BCs ainda não passaram por Phase 3 + pressure
		test próprio. tq-dm-18 warn força AWARENESS sem block; quando
		evidência multi-BC acumular (3+ BCs declarando), future ADR
		pode promote a required (path 'warn → warn+tracking → fail').

		**Refinement chain explícito**: adr-084 REFINES adr-081.
		Documentado em prose (refines field NÃO criado — primeiro uso
		≠ padrão estabelecido; criar field agora seria overfitting de
		um único caso). Sem chain de refinamento, evolução vira ruptura
		invisível — futuro reader deve poder traçar adr-084 de volta
		a adr-081 base structure.

		**Escopo deliberadamente estreito**: ADR cobre APENAS schema
		additions (4 mudanças coordenadas). 4 invariants production-
		safety + 2 novos events (evt-risk-evaluation-emit-failed +
		evt-signal-rejected) + RiskPolicy field changes vivem em REW
		domain-model instance Part 2. Schema define linguagem;
		invariant + event catalog define comportamento — NÃO misturar.

		**3 ajustes finais aplicados pre-write** (founder pressure
		test final tightening):
		(1) consumerProtocol enforcement clarity — REW publishes
		    contract; consumers accountable; violations require
		    explicit ADR override (não 'mandatory' vago).
		(2) replayScopeStrategy operational commitment — declaração
		    é binding operacional, não apenas metadata. Runtime MUST
		    operate under declared strategy.
		(3) Internal events visibility restriction — evt-risk-
		    evaluation-computed (e outros visibility='internal')
		    NUNCA consumed outside REW boundary. Documentado em
		    consumerProtocol da instance REW + event descriptions.
		    'Expor estado intermediário é uma das formas mais comuns
		    de quebrar sistemas distribuídos.'

		Pattern emergente: schema evolution é INCREMENTAL e
		EMPIRICAMENTE-DRIVEN. adr-081 estabeleceu base; adr-084
		adiciona refinement específico de production-safety
		(emergente de pressure test concreto). Próximas refinements
		surgirão de Phase 3+ de outros BCs descobrindo novos gaps —
		cada uma vira ADR com refinement chain explícito (prose por
		enquanto; field structural quando ≥3 ADRs justificarem).
		"""
}
