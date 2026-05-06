package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr075: artifact_schemas.#ADR & {
	id:    "adr-075"
	title: "Envelope governance schema additions for Actor-Scoped Adaptive Containment + Bounded Wait Queue Governance via composition of existing primitives"
	date:  "2026-05-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		WI-057 P2P bootstrap Phase 5 envelope authoring revelou 3
		fragilidades estruturais em #AgentGovernanceEnvelope schema
		identificadas por founder review iterativo durante composição:

		(1) Actor-scoping runner-implicit: regression triggers para
		    vetores adversariais actor-localized (sh-01 Fracionamento,
		    sh-02 renegotiation pressure) precisavam scope ator-afetado.
		    Schema atual #RegressionTrigger.immediateAction é single
		    global enum (reduce-autonomy/revert-to-previous-stage/
		    suspend-and-escalate) — sem mecanismo formal para scopar
		    redução de autonomia per ator. Articular scope em prose
		    do rationale força runner a inferir comportamento, quebrando
		    auditabilidade + portabilidade + verificabilidade via cue
		    vet (governança fora do sistema).

		(2) Tier 3 Systemic sem efeito automático: padrões coordenados
		    cross-actor + cross-category exigem contenção sistêmica
		    sem suspend global. Schema atual não distingue actor-localized
		    de systemic — único trigger único reduce-autonomy global é
		    ou over-reach (suspend agent inteiro por padrão localized)
		    ou under-reach (sem efeito automático real). Detection sem
		    contention é detection sem governance.

		(3) Bounded wait sem queue governance: routing alert-and-block
		    com escape hatch supervisionado (per Ajuste 1 founder Phase
		    5 evitando deadlock sistêmico) cria fila bounded entre
		    detection e founder decision. Schema atual #EscalationRoute
		    não modela queue limits / overflow policy — backlog
		    invisível pode crescer sem governança formal, levando a
		    decisões ruins sob pressão.

		Fragilidades surfaced durante:
		- 5 ciclos red team pre-write (autonomy regression + allocation
		  mis-categorization + cancel split + negative verification +
		  pre-emit allocation eval)
		- 3 founder ajustes Phase 5 (insufficient-context bounded wait
		  + onTimeout LOCAL vs EXTERNAL + Actor-Scoped Adaptive
		  Containment 3-tier)
		- 1 founder Recomendação forte (substituir trigger Fracionamento
		  global suspend-and-escalate por containment progressivo
		  scoped + reversível)
		- Avaliação crítica de 3 propostas alternativas (Caminhos A/B/C)
		"""

	decision: """
		ADOPT Caminho D' — composição de primitives existentes via 3
		schema additions optional, sem breaking change para 6 envelopes
		existentes (CMT/CTR/IDC/NPM/BDG/SSC), preservando ten-009
		expand-when-needed.

		Schema additions optional (decision items):

		(1) #ObservabilitySignal.payloadFields?: [string, ...] em
		    architecture/artifact-schemas/agent-spec.cue. Declara campos
		    do signal payload — base contract para signal-as-contract
		    pattern. Phase 0 list-of-string (presence validation);
		    typed payloadSchema deferred via def-013 trigger 1.

		(2) #RegressionTrigger.scopedBySignal?: #ObservabilitySignalRef
		    typed reference em architecture/artifact-schemas/
		    agent-governance.cue. Scope resolution deterministic via
		    signal payload snapshot at trigger time — runtime evaluation
		    derives state from audit log; envelope declares contracts,
		    not state. Audit trail captures {trigger code,
		    signal-payload-snapshot, action, resolved-scope}. Substitui
		    runner-implicit actor-scoping por contract explícito
		    auditável.

		(3) #RegressionTrigger.clearanceCondition?: #ClearanceCondition
		    discriminated union em agent-governance.cue. Phase 0: 1
		    variant (#ClearanceByNoSignalInWindow com signalRef +
		    window + scope enum + maxOccurrences int — todos campos
		    typed/enums/refs, ZERO prose). Variants futuros
		    (clearance-by-metric-below-threshold, by-duration-elapsed,
		    by-manual-review) deferred via def-013 trigger 2 quando
		    primeira instância requisitar — extension não-breaking via
		    discriminated union pattern.

		(4) #EscalationRoute queue governance fields em agent-governance.cue:
		    - maxQueueDepth?: int & >=1
		    - maxQueueAge?: #DurationDescriptor (^[0-9]+(h|d|w)$)
		    - overflowPolicy?: #OverflowPolicy

		    #OverflowPolicy é struct fail-safe-only:
		    - action: 'auto-cancel-and-escalate' (closed enum, single
		      Phase 0 value)
		    - cancelReasonCode: string MUST match vo-cancellation-reason
		      (OR equivalente) reasonCode constraint do domain-model
		      do BC alvo (CUE não resolve cross-context enum; contract
		      validado por inspeção + runner cross-file futuro)
		    - escalateVia: #EscalationCategory (re-routes via existing
		      escalation taxonomy)

		    DDoS-induced queue overflow → automatic cleanup +
		    founder escalation, NÃO auto-approve. Invariant RECTOR
		    preservado sob queue pressure.

		Decision items secundários:
		(5) Add 'queue-overflow' reasonCode em vo-cancellation-reason
		    do P2P domain-model (mechanical fix; sustenta
		    #OverflowPolicy.cancelReasonCode references).
		(6) PG-A-G updates: 3 heuristics articulando os 3 patterns +
		    3 finalValidation steps validando uso correto.
		(7) def-013 registra 3 deferimentos de tipagem (payloadSchema
		    typed, ClearanceCondition variants, runtime evaluation
		    engine como separação arquitetural por design).

		Schema additions secundárias (suporte aos 3 patterns):
		- #ObservabilitySignalRef typed alias em agent-spec.cue
		  (string com regex sig-prefix; permite future cross-validation
		  via runner sem breaking change)
		- #DurationDescriptor typed alias em agent-governance.cue
		  (string ^[0-9]+(h|d|w)$ format; reusable em window +
		  maxQueueAge)

		ALTERNATIVES REJEITADAS:

		(A) Manter schema atual + 3 def-XXX para 3 fragilidades.
		    REJEITADA: debt acumula sem mecanismo de pressure;
		    fragilidades reais (auditability, automatic containment,
		    queue governance) ficam como heuristic 'runner MUST
		    implement' indefinidamente. Pre-PMF é momento de fechar
		    classes de erro, não documentar como debt. Custo evitado
		    é trivial (3 def-XXX entries) vs custo de continuar
		    deferindo (heuristic governance).

		(B) Full schema evolution com 3 new primitives first-class:
		    #ExecutionScope (com $fromSignal.X runtime interpolation)
		    + #SystemMode (modes paralelos a lifecycleStage)
		    + #QueueState (com runtime state fields).
		    REJEITADA CONTUNDENTEMENTE por 5 razões:

		    (B.1) Runner-dependence em forma diferente: $fromSignal.X
		    é runtime interpolation que CUE não suporta nativamente.
		    Resolver refs em runtime requer engine de evaluation que
		    não existe Phase 0. Schema gain é shape-only (string vs
		    runtime semantics); audit trail enforcement permanece
		    runner-implícito. Move o problema, não resolve.

		    (B.2) #SystemMode duplica vocabulário com lifecycleStage
		    (onboarding/validation/operational/mature já modela estado
		    operacional). Adicionar normal/degraded/restricted cria
		    2 dimensões para descrever estado — risco de drift
		    conceitual ('operational + degraded' significa o quê?).
		    Mode lifecycle (transitions detected → active → cleared)
		    NÃO modelado — exatamente a crítica que motivou esta
		    decisão (state sem lifecycle é state mal-formado).

		    (B.3) #QueueState mistura configuration vs runtime state.
		    Fields como currentSize/oldestAge são runtime values
		    transientes — não pertencem em envelope estático CUE.
		    Categoria erro: envelope DECLARES policy; runner OBSERVES
		    state. Decision item 4 desta ADR resolve a parte legítima
		    (limits + overflow policy = config) sem misturar runtime.

		    (B.4) Auto-approve-without-authority em #QueueState
		    overflow seria red flag de invariant violation: bypass
		    automático de RECTOR (inv-purchase-order-requires-valid-
		    authority no caso P2P) sob queue pressure cria classe de
		    erro adversarial — DDoS-induced queue overflow induziria
		    auto-approves. Fail-safe é correto; fail-permissive é
		    classe inteira de erro. #OverflowPolicy desta ADR é
		    fail-safe-only (auto-cancel-and-escalate).

		    (B.5) Migration burden alto vs ten-009 expand-when-needed:
		    introduzir 3 primitives requer 3 ADRs adicionais + 3 PGs
		    novos (cascade ordering adr-053) + 3 structural-checks +
		    3 validation prompts + migração 6 envelopes existentes
		    (todos em main + governando agentes em produção
		    conceitual) + schema versioning bump. ~3-5 WIs separados
		    de schema evolution. Risk paralelo a #PolicyRegistryEntry
		    pós-adr-065 (criado sem instâncias por meses até rename
		    em adr-077 — design speculative). 1 caso (P2P
		    Fracionamento) NÃO é pattern recurrence — viola
		    expand-when-needed.

		(C) Queue-limits inline only + 2 def-XXX para actor-scoping +
		    Tier 3.
		    REJEITADA: resolve apenas 1/3 (queue governance) via route
		    extension; ignora actor-scoping e Tier 3 deixando-os como
		    heuristic. Métade-solução não satisfaz exigência de
		    fechamento de classes de erro pre-PMF.

		(D') CHOSEN: composição via signal-as-contract +
		    clearanceCondition discriminated union (typed, ZERO prose)
		    + queue governance route extensions fail-safe-only.

		Por que D' é superior:
		- Signal-as-contract reaproveita audit log como source of truth
		  (paralelo circuit breaker / rate limiter / antifraud em
		  sistemas críticos); state deriva de log (single source),
		  não armazenado em envelope (separation honesta config vs
		  runtime — runtime evaluation derives state from audit log;
		  envelope declares contracts, not state).
		- ClearanceCondition discriminated union permite extension
		  não-breaking conforme variants emergem (paralelo
		  #DomainEvent + #DomainField extension pattern); Phase 0
		  variant single resolve case P2P concreto sem speculation.
		- Queue governance limits + overflow fail-safe-only preserva
		  invariants sob pressure (anti-pattern 'fail-permissive sob
		  pressure' explicitamente vetado).
		- Zero breaking change: 3 fields optional; 6 envelopes existentes
		  continuam válidos.
		- Schema additions ~70 linhas total (3 fields optional + 2
		  typed structs + 1 discriminated union + 2 typed aliases).
		- Auditável via cue vet (refs validáveis a signals existentes;
		  enums fechados; numerics explícitos; ZERO prose em campos
		  críticos).
		- Phase 0 limitations explicitamente acknowledged via def-013
		  (typing maturation, variants extensions, runtime evaluation
		  engine como separação arquitetural por design).
		"""

	consequences: """
		Schema additions optional (sem breaking change):
		- agent-spec.cue: #ObservabilitySignal.payloadFields? +
		  #ObservabilitySignalRef typed alias
		- agent-governance.cue: #RegressionTrigger.scopedBySignal? +
		  clearanceCondition? + #EscalationRoute.maxQueueDepth/
		  maxQueueAge/overflowPolicy? + 3 typed structs (#OverflowPolicy
		  + #ClearanceCondition + #ClearanceByNoSignalInWindow) + 1
		  typed alias (#DurationDescriptor)

		Existing 6 envelopes (CMT/CTR/IDC/NPM/BDG/SSC) continuam
		válidos sem mudança — fields são optional. Migration zero.

		Envelope P2P (Phase 5 do WI-057) é primeira instância usando
		os 3 patterns:
		- 6 escalationRoutes incluindo queue governance em
		  insufficient-context route
		- regression triggers Tier 2 + Tier 3 com scopedBySignal +
		  clearanceCondition

		Auditability ganhada:
		- Scope resolution via signal payload snapshot — audit trail
		  captures determinístico
		- Clearance condition typed (ZERO prose); cue vet valida refs
		  + enums + format constraints
		- Queue overflow auto-cancel-and-escalate (NÃO auto-approve)
		  preserva invariants sob pressure

		Anti-mini-NIM preservado: agente NÃO julga intent (signal payload
		carries scope; envelope acts on contract; founder assesses
		intent post-escalation). Boundary structural absence
		(operationalScope + queryDeps) reforçada.

		PG-A-G ganha 3 heuristics + 3 finalValidation steps articulando
		os 3 patterns como expected discipline para envelopes que
		adotem (P2P primeiro caso; outros envelopes podem opt-in
		conforme padrão recorrer).

		Phase 0 limitations explicitamente deferred via def-013:
		(a) payloadFields → typed payloadSchema (trigger 1: ≥2 envelopes
		    usando scopedBySignal pattern)
		(b) #ClearanceCondition variants extensions (trigger 2: ≥3
		    envelopes usando clearanceCondition)
		(c) Runtime evaluation engine como separação arquitetural
		    (trigger 3: manual-review quando WI-069 Phase 1+ runner
		    materialization progredir)

		tq-gv-XX criteria existentes não exigem mudança imediata
		(additions optional não violam criteria existing). PG-A-G
		ganha disciplina explícita; tq-gvg-XX podem absorver os 3
		patterns como heuristics-level até evidência empírica
		justificar promotion.

		def-013 registra 3 deferimentos governados (status: open;
		triggers calibrados conservadoramente).

		Risk mitigation:
		- Falso positivo destrutivo evitado (signal-as-contract +
		  scope from payload + reversibility via clearanceCondition)
		- Adversarial-resistant (auto-cancel-and-escalate sob queue
		  overflow vs auto-approve que cria DDoS bypass classe)
		- Continuidade operacional preservada (po-specific scope +
		  ator-afetado scope + category-affected scope; suspend
		  global apenas para falhas LOCAIS do agente)

		Reversibilidade da decisão:
		- Schema additions optional são reverter-friendly (remoção
		  ou deprecation de fields optional)
		- def-013 lifecycle (open → triggered → resolved) governa
		  evolution path
		- Pode ser superseded por adr futura se padrão emergir que
		  justifique #ExecutionScope/#SystemMode/#QueueState first-
		  class (B revisitada com evidência empírica)

		Princípio canônico estabelecido: runtime evaluation derives
		state from audit log; envelope declares contracts, not state.
		Esta separação é reusável cross-Mesh (paralelo a circuit
		breaker / rate limiter / antifraud patterns) e pode virar
		guideline formal cross-BC quando ≥2 envelopes adotarem os
		patterns (def-013 trigger 1 fires).
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-spec.cue",
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/production-guides/agent-governance.cue",
		"contexts/p2p/agents/p2p-primary-agent.governance.cue",
		"contexts/p2p/domain-model.cue",
		"architecture/deferred-decisions/def-013-envelope-governance-typing-maturity.cue",
	]

	defersTo: ["def-013"]

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	rationale: """
		Reversibilidade medium: schema additions são optional fields,
		retroativamente reverter-friendly (deprecation OR removal de
		field optional sem breaking 6 envelopes existentes que NÃO
		usam). PORÉM 1 envelope (P2P) usa imediatamente — reverter
		exige migration desse envelope. Não é high (zero migration)
		nem low (multi-system migration); medium reflete que reversal
		toca P2P envelope mas preserva retrocompatibilidade ampla.

		BlastRadius cross-cutting: 2 schemas afetados (agent-spec.cue +
		agent-governance.cue) governando todos os 7 envelopes (CMT/
		CTR/IDC/NPM/BDG/SSC + P2P new) + PG-A-G atualizado +
		domain-model P2P (queue-overflow reasonCode) + def-013
		(governance evolution path). Não é local (single artifact)
		nem repo-wide (não toca core principles/lenses/domain
		definition); cross-cutting reflete escopo subsystem governance
		multi-artifact.

		Princípios aplicados:
		- P1 (CUE como SoT): schema declara contracts auditáveis
		  (typed refs, discriminated unions, fail-safe enums); cue vet
		  enforça validation antes de runner.
		- P10 (gates determinísticos validam, agentes recomendam):
		  schema é gate (declaração); runner é executor (enforcement);
		  separation rigorosa preserva determinism.
		- dp-04 (single ownership): signal payload é single source
		  for scope (não envelope; não runner inferência); audit log
		  é single source for state.
		- ten-009 (expand-when-needed): minimal additions sob evidence
		  empírica concreta (P2P primeira instância) vs speculative
		  full-schema-evolution rejeitada como B.
		"""

	principlesApplied: [
		"P1 (CUE como SoT — schema declara contracts auditáveis)",
		"P10 (gates determinísticos validam, agentes recomendam — schema é gate; runner é executor)",
		"dp-04 (single ownership — signal payload é single source para scope)",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/agent-spec.cue (#ObservabilitySignal.payloadFields? + #ObservabilitySignalRef added)",
		"architecture/artifact-schemas/agent-governance.cue (#RegressionTrigger.scopedBySignal? + clearanceCondition? + #EscalationRoute queue fields + #OverflowPolicy + #ClearanceCondition + #ClearanceByNoSignalInWindow + #DurationDescriptor added)",
		"architecture/production-guides/agent-governance.cue (3 heuristics + 3 finalValidation steps added)",
		"contexts/p2p/domain-model.cue (queue-overflow reasonCode added in vo-cancellation-reason)",
		"architecture/deferred-decisions/def-013-envelope-governance-typing-maturity.cue (new)",
		"contexts/p2p/agents/p2p-primary-agent.governance.cue (new — first instance using 3 patterns)",
		"governance/build-time/self-reviews/adr-075-envelope-governance-schema-additions-d-prime.self-review.cue (new SRR)",
		"governance/build-time/self-reviews/p2p-primary-agent-governance.self-review.cue (new SRR)",
	]
}
