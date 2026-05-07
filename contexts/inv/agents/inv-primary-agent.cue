package inv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// inv-primary-agent.cue — Agent Spec: Invoicing Primary Agent.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Phase 4 do WI-053 INV bootstrap. Materializa execution layer
// determinística sobre os artefatos formais de Phase 1-3.5:
// canvas (governanceScope) + glossary (firewall semântico) +
// domain-model (sistema formal) + structural-checks (garantias +
// limites Phase 3.5).
//
// Conceito central founder framing Phase 4:
//   execution ≠ action
//   execution = action + proof that it can happen
//
// Agent não executa comandos — agent prova que a execução é
// válida antes de existir. Execution semantics: atomic-proposal
// triggered por gates determinísticos (GUARDS Layer 4 +
// STRUCTURAL GATES Phase 3.5).
//
// Phase 4 Part 1 + Part 2 + Part 3 + R2 review (este file):
// Founder R2 adversarial review post-Phase 4 — 4 findings applied:
//   (R2-1) Observation consistency assumption (atomic emit ≠ atomic
//     observation; consumers MUST treat InvoiceIssued + Receivable-
//     Materialized como atomic semantic pair — declared via cst-
//     system-boundary-acknowledged)
//   (R2-2) Cancel state-based ordering (replay/reorder safe —
//     cst-gate-cancel-ordering atualizado: aggregate-state-
//     evaluation-time-check replaces sequence-based predecessor;
//     ordering-at-evaluation-time NÃO event-arrival)
//   (R2-3) Verify-uncertain SOFT vs structural-breach HARD distinction
//     (suspicious-input escalation atualizado com sub-classifications
//     VERIFIED → HARD vs VERIFICATION-UNCERTAIN → SOFT retry-
//     eligible; previne falso negativo operacional)
//   (R2-4) Single entry point assumption (all Invoice creation MUST
//     pass through gate-enforced path — declared via cst-system-
//     boundary-acknowledged)
//
// Phase 4 Part 1 + Part 2 + Part 3 base scope:
//   Part 1 — act-issue-invoice + 5 constraints (2 cst-gate-issue-*
//     + 3 cst-issue-* + 1 cst-schema-openness ACK)
//   Part 2 — act-cancel-invoice + 6 constraints (3 cst-gate-cancel-*
//     + 3 cst-cancel-*) + 6 traps endereçados estruturalmente
//     (T1 cancel-as-undo, T2 window ambiguity, T3 silent mutation,
//     T4 post-finality, T5 event optional, T6 cancel-as-correction)
//   Part 3 — 3 reactive actions (act-block-emit-on-stale BLOCK +
//     act-filter-non-terminal-dlv FILTER + act-escalate-regime-
//     anomaly ESCALATE) + 2 transversal reactive constraints
//     (cst-react-no-event-coupling + cst-react-classification-
//     mandatory) + 5 traps reactive endereçados estruturalmente
//     (T-R1 orchestrator, T-R2 retry, T-R3 event-as-command,
//     T-R4 stale==missing, T-R5 act-without-classification)
//
// 5 escalationConditions (folded scenarios via OR per category,
// padrão DLV precedent — insufficient-context + out-of-scope +
// suspicious-input + conflicting-signals + unclassifiable-anomaly)
// + 8 signals (3 issue + 3 cancel + 2 reactive new) + 20 audit
// fields (7 min + 8 INV + 3 cancel + 2 reactive). Asymmetry:
//   - Issue exige consistência ESTRUTURAL
//   - Cancel exige ESTRUTURAL + TEMPORAL + REGULATÓRIA
//   - Reactive exige CLASSIFICATION-DISCIPLINED + DEFAULT-NO-ACTION
//
// Conceito central founder framing Phase 4 reactive:
// 'agent controla quando o mundo NÃO deve causar ação' —
// transforma sistema em determinístico SOB eventos não-determinísticos.
//
// 3 usos reais cst-gate-* (issue + cancel + supervisedDecision/
// reactive) → ADR-081 cristalização ready post-Part 3 SRR.
//
// 4 ajustes founder pre-write incorporated (workaround pre-ADR-081):
//   (1) kind: structural-gate marker em verification YAML +
//       description first-line para visibility (schema closed-struct
//       constraint impede top-level field; cristalização ADR-081
//       após 3 usos reais — issue + cancel + reactive)
//   (2) enforcementLevel: hard | advisory em TODOS requiredChecks
//       (hard=bloqueia; advisory=registra)
//   (3) ESCALATION DEFERRED (não NONE) — comunica comportamento
//       futuro possível
//   (4) ABORT_ACTION (action-specific) vs HALT_AGENT (agent-wide)
//       padronizados — distinção crítica retryable vs fatal

agentSpec: artifact_schemas.#AgentSpec & {
	code:              "agt-inv-primary"
	name:              "Invoicing Primary Agent"
	description: """
		Agent operador autônomo da emissão fiscal determinística do
		BC INV. Phase 4 framing: agent prova que execução é válida
		ANTES de existir — execution = action + proof. Execution
		semantics: atomic-proposal triggered por GUARDS (Layer 4
		predicates) + STRUCTURAL GATES (Phase 3.5 sc-inv-* per
		ADR-080).

		Agent ONLY binds input → command sob gates determinísticos
		hierárquicos. Agent NEVER computes tax, decides regime,
		enriches payload, orchestrates downstream, queries CMT
		synchronously, OR mutates existing Invoice (cst-issue-
		forbidden-responsibilities — 6 forbidden categorias).
		"""
	boundedContextRef: "inv"
	role:              "domain-agent"
	governanceRef:     "inv-primary-agent"

	operationalScope: {
		aggregates: ["agg-invoice"]
		commands: [
			"cmd-issue-invoice",
			"cmd-cancel-invoice",
		]
		events: [
			"evt-invoice-issued",
			"evt-receivable-materialized",
			"evt-invoice-cancelled",
		]
		invariants: [
			"inv-atomic-dual-emission",
			"inv-idempotent-issuance",
			"inv-regime-immutability",
			"inv-lifecycle-states",
			"inv-cancellation-boundary",
			"inv-fiscal-doc-ref-integrity",
			"inv-cancellation-event-required",
			"inv-receivable-referential-integrity",
		]
		projections: ["prj-invoice-by-identity"]
	}

	actions: [{
		code: "act-issue-invoice"
		name: "Issue Invoice (atomic dual emission)"
		description: """
			Materializar Invoice + Receivable como fato canônico atomic.
			Execution type: atomic-proposal — agent propõe creation como
			single atomic unit; emission é all-or-nothing (InvoiceIssued
			∧ ReceivableMaterialized) OR emit(nothing).

			LAYERED EXECUTION MODEL (Phase 4 binding):
			- preconditions = GUARDS (Layer 4 predicates; depend on
			  WORLD state — projection availability/completeness/
			  freshness + verification outcome)
			- structural gates (cst-gate-* with kind:structural-gate
			  marker; ADR-081 future schema mod promove a first-class
			  field) = STRUCTURAL CHECKS as execution gates (depend
			  on SYSTEM state — sc-inv-* per ADR-080)
			- constraints = behavioral + immutability + boundary
			  enforcement (cst-issue-*)

			ABORT_ACTION (action-specific decision) vs HALT_AGENT
			(agent-wide stop) distinção mantida em failure handling.

			Agent ONLY binds input → command. Agent does NOT compute
			tax, does NOT decide regime, does NOT enrich payload, does
			NOT orchestrate downstream (cst-issue-forbidden-
			responsibilities).
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-issue-invoice",
			"agg-invoice",
			"evt-invoice-issued",
			"evt-receivable-materialized",
			"inv-atomic-dual-emission",
			"inv-idempotent-issuance",
			"inv-fiscal-doc-ref-integrity",
		]
		preconditions: [
			"GUARD (Layer 4): canIssueInvoice(commitmentRef, evidenceRef) == true",
			"GUARD (Layer 4): projection.available(commitmentRef)",
			"GUARD (Layer 4): projection.complete(commitmentRef)",
			"GUARD (Layer 4): projection.fresh(commitmentRef)",
			"GUARD (Layer 4): verificationOutcome == approved",
		]
		postconditions: [
			"InvoiceIssued + ReceivableMaterialized emitted atomically (single transactional boundary)",
			"Invoice.status == issued; Receivable created paired via invoiceId",
			"sc-inv-01 atomic-dual-emission maintained (cardinality 1:1; amount + currency conservation)",
			"sc-inv-02 idempotent-issuance maintained (single Invoice per tuple)",
			"sc-inv-06 fiscal-doc-ref-integrity maintained (fiscalDocRef non-empty + write-once)",
		]
	}, {
		code: "act-cancel-invoice"
		name: "Cancel Invoice (fiscal-boundary constrained)"
		description: """
			Cancelar Invoice existente dentro da janela fiscal permitida.
			Execution type: constrained-mutation — operação IRREVERSÍVEL
			no domínio INV, limitada por boundary temporal regulatório
			externo (cancellationWindow(regimeVersion) — função pura
			externa per domain-model).

			Cancel NÃO é simétrico a issue:
			- Issue cria realidade
			- Cancel invalida realidade sob regras externas (regulatórias)

			Cancel NÃO corrige:
			- erro contábil → DRC
			- pagamento → FCE
			- crédito → SCF

			Cancel apenas declara: 'este fato não é mais válido dentro
			do regime fiscal permitido'. Cancel NÃO substitui invoice;
			NÃO cria nova invoice; NÃO reemite; NÃO corrige.
			Supersession é DLV/DRC pattern — NÃO INV.

			LAYERED EXECUTION MODEL (idêntico a issue):
			- preconditions = GUARDS (Layer 4 predicates; world state —
			  invoice exists + status issued + NOT post-finality)
			- structural gates (cst-gate-cancel-* with kind:structural-
			  gate marker; ADR-081 future schema mod) = STRUCTURAL CHECKS
			  as execution gates (system state — sc-inv-* per ADR-080)
			- constraints = behavioral + immutability + supersession
			  prohibition (cst-cancel-*)

			Issue exige consistência ESTRUTURAL.
			Cancel exige consistência ESTRUTURAL + TEMPORAL + REGULATÓRIA.

			6 traps canônicos endereçados estruturalmente (NÃO via
			comentário): (T1) cancel-as-undo via cst-cancel-no-supersession;
			(T2) window ambiguity via clockSource:canonical em verification;
			(T3) silent mutation via cst-cancel-no-mutation;
			(T4) post-finality via cst-gate-cancel-finality-protection;
			(T5) event optional via cst-cancel-event-required;
			(T6) cancel-as-correction via description prohibition + glossary
			antiTerms (anti-mini-DRC + anti-mini-FCE + anti-mini-SCF).
			"""
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-cancel-invoice",
			"agg-invoice",
			"evt-invoice-cancelled",
			"inv-cancellation-boundary",
			"inv-cancellation-event-required",
			"inv-lifecycle-states",
			"inv-regime-immutability",
		]
		preconditions: [
			"GUARD (Layer 4): exists Invoice(invoiceId) in aggregate canonical state",
			"GUARD (Layer 4): Invoice.status == issued",
			"GUARD (Layer 4): NOT isPostFinalityBoundary(invoiceId) — finality boundary não cruzada",
		]
		postconditions: [
			"InvoiceCancelled emitted explicitly (NÃO state-only mutation; sc-inv-07)",
			"Invoice.status == cancelled (transição issued → cancelled per inv-lifecycle-states)",
			"sc-inv-04 lifecycle-states maintained (transição válida + ordering [InvoiceIssued → InvoiceCancelled])",
			"sc-inv-05 cancellation-boundary maintained (cancel ocorreu dentro de cancellationWindow)",
			"sc-inv-07 cancellation-event-required maintained (event explícito emitido)",
			"sc-inv-03 regime-immutability maintained (regimeVersion NÃO mutada por cancel)",
			"sc-inv-06 fiscal-doc-ref-integrity maintained (fiscalDocRef NÃO mutado por cancel; write-once preservado)",
		]
	}, {
		code: "act-block-emit-on-stale"
		name: "Block invoice emission on stale projection (reactive BLOCK)"
		description: """
			REACTIVE BLOCK action — triggered por evt-delivery-verified
			(DLV cross-BC; trusted-internal). Default = NO_ACTION.
			Decisão de NÃO emitir invoice quando projection stale para
			(commitmentRef) detected. NÃO é if-event-then-action;
			NÃO é retry; NÃO é fallback sync query. Block é hard
			permanent até state mudar (event-driven re-evaluation).

			Conceito reactive (founder framing):
			'agent controla quando o mundo NÃO deve causar ação' —
			default reactive é NO_ACTION; action-decision é exception
			structurally constrained, NÃO obrigação derivada de event.

			LAYERED EXECUTION (reactive — pattern paralelo issue/cancel):
			- preconditions = GUARDS (event signature + projection
			  availability + staleness classification disciplinada)
			- DECISION = ABORT_ACTION-FOR-ISSUE (block issue path
			  for this tuple; emit nothing for issue)
			- SIGNAL = sig-issue-structural-gate-blocked com
			  staleness-type=stale (NÃO missing — Trap T-R4)
			- ESCALATION = DEFERRED (until threshold breach via
			  esc-projection-stale-sustained canvas escalation)

			3 traps endereçados estruturalmente:
			- T-R2 (retry automático) — postcondition declara block
			  permanente até event-driven re-evaluation; NÃO retry loop
			- T-R3 (event vira command) — default NO_ACTION; block
			  decision é exception, não obrigação per evento
			- T-R4 (stale ≡ missing) — staleness-type classification
			  disciplinada {stale, missing, fresh-but-incomplete,
			  fresh-and-complete} — agent NÃO confunde dimensions
			"""
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-invoice",
			"prj-invoice-by-identity",
			"inv-atomic-dual-emission",
			"inv-idempotent-issuance",
		]
		preconditions: [
			"GUARD (Layer 4): trigger event = evt-delivery-verified (DLV cross-BC; trusted-internal)",
			"GUARD (Layer 4): projection.available(commitmentRef) — projection reachable (NÃO confundido com missing)",
			"GUARD (Layer 4): staleness classification == stale (NÃO missing; NÃO fresh-but-incomplete; NÃO fresh-and-complete)",
		]
		postconditions: [
			"act-issue-invoice path BLOCKED for this (commitmentRef, evidenceRef) tuple",
			"sig-issue-structural-gate-blocked emitted com payload {staleness-type: stale, blockedDimension: projection-staleness}",
			"BD4 deterministic-fiscal-projection preserved (stale → no fiscal emission per BD4)",
			"NO retry loop; block é permanent até event-driven state change (Trap T-R2 endereçado)",
			"Escalation classification: DEFERRED — threshold-based via canvas esc-projection-stale-sustained Phase 1+",
		]
	}, {
		code: "act-filter-non-terminal-dlv"
		name: "Filter non-terminal delivery events (reactive FILTER)"
		description: """
			REACTIVE FILTER action — triggered por evt-delivery-verified.
			Default = NO_ACTION (silent ignore). Classifica
			event.terminality; non-terminal events são informational
			(parcial OR superseded OR transitional), NÃO actionable.
			INV emite invoice APENAS para deliveries terminais per
			inv-idempotent-issuance (idempotency identity baseada em
			tuple terminal).

			Conceito reactive (founder framing):
			'agent controla quando o mundo NÃO deve causar ação' —
			este é o caso onde NÃO ação é a ação correta. Silent
			ignore preserva determinismo + replay independence.

			LAYERED EXECUTION (reactive):
			- preconditions = GUARDS (event signature + terminality
			  classification ANTES de qualquer decisão)
			- DECISION = NO_ACTION (silent ignore; no emission attempt;
			  no state change)
			- SIGNAL = sig-dlv-filtered-non-terminal (info-level
			  observability only — NÃO warn; NÃO escalation)
			- ESCALATION = none (filter é normal classification, NÃO
			  anomaly)

			2 traps endereçados estruturalmente:
			- T-R3 (event vira command) — filter ESTABELECE que nem
			  todo event obriga ação; non-terminal = informational
			- T-R5 (reagir sem classificar) — terminality classification
			  obrigatória ANTES de filter decision; default NO_ACTION
			  até classification completed
			"""
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-invoice",
			"inv-idempotent-issuance",
		]
		preconditions: [
			"GUARD (Layer 4): trigger event = evt-delivery-verified",
			"GUARD (Layer 4): terminality classification completed (NÃO act sem classification — Trap T-R5)",
			"GUARD (Layer 4): event.terminal == false (parcial OR superseded OR transitional OR ambiguous)",
		]
		postconditions: [
			"Event classified non-terminal; NO emission attempt para act-issue-invoice path",
			"sig-dlv-filtered-non-terminal emitted (info-level — observability only)",
			"NO escalation; NO state mutation; NO audit trail entry beyond filter signal",
			"Idempotency identity preserved — non-terminal events NÃO consomem idempotency-tuple slot",
		]
	}, {
		code: "act-escalate-regime-anomaly"
		name: "Escalate regime version anomaly (reactive ESCALATE)"
		description: """
			REACTIVE ESCALATE action — triggered por evt-delivery-verified.
			Default = NO_ACTION. Detecta regimeVersion inconsistency
			(non-monotonic jump, expired-but-active, mismatch contra
			expected pattern from CMT projection) → ABORT_ACTION-FOR-
			ISSUE (block issue path) + HARD ESCALATION
			(DOMAIN-INCONSISTENCY classification).

			Conceito reactive crítico (founder framing):
			agent NÃO chama CMT sync para 'corrigir' regime; agent
			SINALIZA + ESCALA + AGUARDA. Anti-mini-ATO preservado:
			ATO domain owns regime tax logic; INV NÃO computa regime
			correction. Detection é INV responsibility (boundary
			recognition); correction é ATO/CMT responsibility
			(boundary respect).

			LAYERED EXECUTION (reactive):
			- preconditions = GUARDS (event signature + projection
			  availability + regime classification anomalous)
			- DECISION = ABORT_ACTION-FOR-ISSUE + DO_NOT_CORRECT
			- SIGNAL = sig-regime-anomaly-detected (critical level)
			- ESCALATION = HARD (DOMAIN-INCONSISTENCY; routed via
			  envelope governance Phase 5 escalation-routing block)

			2 traps endereçados estruturalmente:
			- T-R1 (reactive virar orchestrator) — DO_NOT_CORRECT
			  postcondition explícita; agent NÃO chama CMT sync;
			  agent NÃO emit cross-BC commands em response
			- T-R5 (reagir sem classificar) — regime classification
			  required ANTES de anomaly determination; classification
			  dimensions {monotonic-progression, anomalous-jump,
			  expired-but-active, missing}
			"""
		category:        "escalation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-invoice",
			"inv-regime-immutability",
		]
		preconditions: [
			"GUARD (Layer 4): trigger event = evt-delivery-verified",
			"GUARD (Layer 4): projection.available(commitmentRef)",
			"GUARD (Layer 4): regime classification completed (Trap T-R5 endereçado)",
			"GUARD (Layer 4): regime-classification ∈ {anomalous-jump, expired-but-active, missing} (NÃO monotonic-progression)",
		]
		postconditions: [
			"act-issue-invoice path BLOCKED for this (commitmentRef, evidenceRef) tuple",
			"sig-regime-anomaly-detected emitted (critical; DOMAIN-INCONSISTENCY classification)",
			"HARD escalation routed via envelope governance Phase 5 escalation-routing",
			"NO regime correction attempted (anti-mini-ATO; Trap T-R1 endereçado — agent NÃO orchestrates)",
			"NO sync query CMT (boundary preservation; agent reage NÃO orquestra)",
		]
	}]

	constraints: [{
		code: "cst-gate-issue-idempotency-pre-execution"
		name: "[KIND: structural-gate / phase: pre-execution] sc-inv-02 idempotent-issuance"
		description: """
			[KIND: structural-gate / phase: pre-execution]

			STRUCTURAL GATE (NÃO precondition; NÃO behavioral
			constraint). Enforced PRE-EXECUTION per Phase 3.5 ADR-080
			domain-invariant kind. Action act-issue-invoice MUST
			satisfy sc-inv-02 antes de qualquer emission attempt —
			proposed (commitmentRef, evidenceRef) tuple has zero
			existing Invoice in aggregate canonical state.
			"""
		verification: """
			kind: structural-gate
			gatePhase: pre-execution
			structuralCheckRef: sc-inv-02
			invariantRef: inv-idempotent-issuance
			requiredChecks:
			- type: aggregate-state-lookup
			  target: agg-invoice
			  query: (commitmentRef, evidenceRef)
			  expected: not-exists
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-02
			  binding: pre-execution-gate
			  expected: not-violated
			  enforcementLevel: hard
			- type: identity-source-discipline
			  target: aggregate-canonical-state
			  forbidden-source: prj-invoice-by-identity
			  expected: identity-from-aggregate-only
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa BD3 + sc-inv-02 como structural gate pre-execution. kind: structural-gate marker (description + verification top) é workaround pre-ADR-081 — schema mod cristalizado após 3 usos reais (issue + cancel + reactive). Identity check via aggregate canonical (NÃO projection) preserva replay independence + projection-non-authoritativeness (anti-projection-poisoning attack N2)."
	}, {
		code: "cst-gate-issue-atomic-feasibility-execution"
		name: "[KIND: structural-gate / phase: execution] sc-inv-01 atomic-dual-emission"
		description: """
			[KIND: structural-gate / phase: execution-feasibility]

			STRUCTURAL GATE (execution-feasibility — boundary
			constraint DURING execution). emit(InvoiceIssued) ∧
			emit(ReceivableMaterialized) atomic OR emit(nothing).
			Sem fallback parcial; sem retry automático
			cross-component; sem saga compensation.
			"""
		verification: """
			kind: structural-gate
			gatePhase: execution-feasibility
			structuralCheckRef: sc-inv-01
			invariantRef: inv-atomic-dual-emission
			requiredChecks:
			- type: infrastructure-primitive-availability
			  target: transactional-outbox
			  expected: available + responsive
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-01
			  binding: execution-feasibility-constraint
			  expected: atomic-boundary-guaranteed
			  enforcementLevel: hard
			- type: emission-cardinality
			  target: paired-events
			  expected: exactly-2-OR-exactly-0
			  enforcementLevel: hard
			- type: amount-currency-conservation
			  target: Invoice ↔ Receivable
			  expected: identical-source-derived
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa BD7 + sc-inv-01 como structural gate execution-feasibility. kind: structural-gate marker (description + verification top). Atomicidade é hard constraint da execution layer; mecanismo é responsabilidade da infrastructure (transactional outbox); agent detecta limite estrutural canônico — falha estrutural detectável, NÃO bug runtime."
	}, {
		code: "cst-issue-fiscal-doc-ref-integrity"
		name: "Issue preserves fiscalDocRef integrity"
		description: "[KIND: behavioral-constraint] Invoice emitida MUST have fiscalDocRef non-empty + write-once post-creation per inv-fiscal-doc-ref-integrity."
		verification: """
			kind: behavioral-constraint
			invariantRef: inv-fiscal-doc-ref-integrity
			requiredChecks:
			- type: field-non-empty
			  target: Invoice.fiscalDocRef
			  expected: non-empty-string
			  enforcementLevel: hard
			- type: persistence-write-once
			  target: Invoice.fiscalDocRef
			  expected: immutable-post-creation
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-06
			  expected: not-violated
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa cc-04 audit trail regulatory-grade. Reference é canonical para audit ≥5 anos NF-e."
	}, {
		code: "cst-issue-forbidden-responsibilities"
		name: "Issue forbidden domain responsibilities (anti-drift)"
		description: """
			[KIND: behavioral-constraint / category: anti-drift]

			Action act-issue-invoice MUST NOT perform 6 forbidden
			categorias: (1) decide payment terms — FCE; (2) compute
			tax logic — ATO; (3) evaluate credit/eligibility —
			SCF/REW; (4) query CMT synchronously — runtime coupling;
			(5) mutate existing Invoice — immutability; (6) enrich
			event payload beyond domain model — anti-payload-bloat.
			"""
		verification: """
			kind: behavioral-constraint
			category: anti-drift-boundary
			requiredChecks:
			- type: code-pattern-absent
			  target: tax-computation-logic
			  rationale: regimeVersion is read-only input from CMT projection
			  enforcementLevel: hard
			- type: payload-field-set-closed
			  target: InvoiceIssued
			  forbidden-fields: [paymentMethod, paymentSchedule, accountRef, riskScore, eligibilityFlag]
			  enforcementLevel: hard
			- type: receivable-emission-unconditional
			  target: act-issue-invoice
			  forbidden: eligibility-filter-on-receivable
			  expected: receivable-always-emitted-when-invoice-issued
			  enforcementLevel: hard
			- type: sync-query-absent
			  target: critical-path
			  forbidden-target: CMT
			  expected: cmt-projection-async-only
			  enforcementLevel: hard
			- type: mutation-call-absent
			  target: existing-Invoice-records
			  expected: no-mutation-calls
			  enforcementLevel: hard
			- type: payload-field-set-closed
			  target: act-issue-invoice-emissions
			  forbidden-additions: beyond-domain-model-declared-payload
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa BD2 + BD9 + BD10 boundary preservation transversal. 6 forbidden categorias mapeiam a antiTerms canônicos do glossary."
	}, {
		code: "cst-schema-openness-acknowledged"
		name: "Schema openness explicitly acknowledged (NOT structurally enforced)"
		description: """
			[KIND: declarative-acknowledgment / riskLevel: high]

			ACKNOWLEDGED LIMIT: domain-model.cue allows field extension
			unless explicitly constrained. cst-issue-forbidden-
			responsibilities protege COMPORTAMENTO via verification
			check-oriented; schema-level field-set closure NÃO é
			structurally enforced.

			Phase 0 mitigation: validation-prompt advisory + glossary
			antiTerms + review discipline. Phase 1+ promotion:
			structural-check kind 'allowed-fields-closed' OR schema
			closed-struct enforcement (deferred ADR future).
			"""
		verification: """
			kind: declarative-acknowledgment
			category: residual-risk-declaration
			riskLevel: high
			impact: boundary-risk
			acknowledgedLimit:
			  type: schema-openness-gap
			  scope: domain-model field-set extension
			  attack-vectors-residual: [L1-policy-injection, L2-receivable-enrichment, L3-payload-enrichment, E4-field-addition-undetected]
			mitigations-active:
			- glossary-antiTerm-coverage (anti-mini-FCE + anti-mini-SCF + anti-mini-ATO)
			- validation-prompt-advisory (validate-domain-model)
			- review-discipline (founder approval gate)
			mitigations-future:
			- structural-check-kind-allowed-fields-closed (Phase 1+)
			- schema-closed-struct-enforcement (Phase 1+ ADR)
			requiredChecks:
			- type: declarative-acknowledgment
			  target: schema-openness-gap
			  expected: documented-in-rationale
			  enforcementLevel: advisory
			- type: glossary-antiTerm-coverage
			  target: anti-mini-FCE + anti-mini-SCF + anti-mini-ATO
			  expected: covered-via-glossary-discipline
			  enforcementLevel: advisory
			- type: validation-prompt-presence
			  target: validate-domain-model
			  expected: advisory-layer-active
			  enforcementLevel: advisory
			"""
		onViolation: "log-only"
		rationale: "Honesty arquitetural: declara explicitamente schema openness gap como riskLevel: high (boundary-risk impact). enforcementLevel: advisory porque é declarativo (ACK), não block; Phase 1+ promotion para structural-check kind 'allowed-fields-closed' transformará advisory→hard."
	}, {
		code: "cst-gate-cancel-within-window"
		name: "[KIND: structural-gate / phase: pre-execution] sc-inv-05 cancellation-boundary (temporal)"
		description: """
			[KIND: structural-gate / phase: pre-execution]

			STRUCTURAL GATE temporal-boundary (NÃO precondition; NÃO
			behavioral). Enforced PRE-EXECUTION per Phase 3.5 ADR-080
			domain-invariant kind. Cancel attempt MUST satisfy sc-inv-05
			antes de qualquer emit attempt — (now - issuedAt) ≤
			cancellationWindow(regimeVersion).

			cancellationWindow é função pura externa ao domínio
			(declarado canonicamente em domain-model.cue) — agent NÃO
			computa janela; agent CONSULTA via canonical clockSource.
			Trap T2 (window ambiguity) endereçado via clockSource:
			canonical explicit em verification.
			"""
		verification: """
			kind: structural-gate
			gatePhase: pre-execution
			structuralCheckRef: sc-inv-05
			invariantRef: inv-cancellation-boundary
			requiredChecks:
			- type: temporal-boundary-check
			  target: Invoice
			  condition: (now - issuedAt) ≤ cancellationWindow(regimeVersion)
			  clockSource: canonical
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-05
			  binding: pre-execution-gate
			  expected: not-violated
			  enforcementLevel: hard
			- type: window-function-pure-external
			  target: cancellationWindow
			  expected: function-pure-external-to-domain
			  forbidden-source: agent-computed-window
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa BD temporal-boundary + sc-inv-05 como structural gate pre-execution. clockSource:canonical evita Trap T2 (window ambiguity → sistema não-determinístico). cancellationWindow declarada externa preserva separação domain ↔ regulamentação fiscal (regime versioning vive em CMT, não INV)."
	}, {
		code: "cst-gate-cancel-finality-protection"
		name: "[KIND: structural-gate / phase: pre-execution] post-finality cancellation forbidden"
		description: """
			[KIND: structural-gate / phase: pre-execution]

			STRUCTURAL GATE finality-protection. Cancel attempt em invoice
			cuja finality boundary já foi cruzada é regulatory violation
			estrutural — NÃO retry-able + NÃO fallback. Trap T4 (cancel
			pós-finality → violação domínio regulatório) endereçado.

			Distinção crítica: finality-boundary é estado terminal
			(receivable settled OR fiscal lock period expirado per regime
			fiscal jurisdicional) — separado de cancellationWindow
			(janela temporal pre-finality). Agent NÃO infere finality;
			consulta projection canônica.
			"""
		verification: """
			kind: structural-gate
			gatePhase: pre-execution
			invariantRef: inv-cancellation-boundary
			requiredChecks:
			- type: finality-boundary-check
			  target: Invoice
			  expected: not-crossed
			  enforcementLevel: hard
			- type: finality-source-discipline
			  target: invoice-finality-state
			  expected: query-from-canonical-projection
			  forbidden-source: agent-inferred-finality
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa Trap T4 estruturalmente. Cancel pós-finality é regulatory-violation HARD — NÃO retry, NÃO fallback. Finality discovery via canonical projection (NÃO agent-inferred) preserva auditability + previne race-condition entre agent state e canonical state."
	}, {
		code: "cst-gate-cancel-ordering"
		name: "[KIND: structural-gate / phase: execution] lifecycle ordering integrity"
		description: """
			[KIND: structural-gate / phase: execution]

			STRUCTURAL GATE ordering integrity DURING execution. Sequence
			[InvoiceIssued → InvoiceCancelled] strictly-ordered MUST
			be preserved per inv-lifecycle-states + sc-inv-04. Gate
			detecta tentativa de emit InvoiceCancelled sem InvoiceIssued
			predecessor OR ordering inversion (timestamp inconsistency).

			Distinção temporal vs ordering: cancellationWindow é
			temporal (janela permitida); ordering é causal (sequence
			InvoiceIssued antes de InvoiceCancelled). Ambos hard
			constraints, dimensões diferentes.
			"""
		verification: """
			kind: structural-gate
			gatePhase: execution
			structuralCheckRef: sc-inv-04
			invariantRef: inv-lifecycle-states
			requiredChecks:
			- type: aggregate-state-evaluation-time-check
			  target: agg-invoice
			  scope: same-invoice-id
			  expected: Invoice exists in aggregate canonical state with status=issued AT EVALUATION TIME
			  rationale: founder R2 adversarial review fix — replay/reorder safe; cancel re-checks aggregate state AT evaluation time, NÃO event arrival sequence (distributed systems não garantem event ordering)
			  forbidden: rely-on-event-arrival-order-OR-event-sequence-as-source-of-truth
			  enforcementLevel: hard
			- type: event-ordering-at-evaluation-time
			  sequence: [InvoiceIssued, InvoiceCancelled]
			  expected: strictly-ordered AT EVALUATION TIME (system state ordering verifiable via aggregate canonical state)
			  rationale: ordering invariance per state, NÃO per event arrival
			  forbidden: arrival-order-as-ordering-proof
			  enforcementLevel: hard
			- type: predecessor-state-existence
			  target: agg-invoice
			  scope: same-invoice-id
			  expected: invoice-exists-in-aggregate-canonical-state-with-status-issued-at-evaluation-time
			  rationale: state-based predecessor check (NÃO event sequence) — replay/reorder safe
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-04
			  binding: execution-ordering-constraint
			  expected: not-violated
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa BD lifecycle-ordering + sc-inv-04 + state-based ordering invariance (R2 founder adversarial review pre-Phase 5: cancel re-checks aggregate canonical state AT evaluation time, NÃO event arrival sequence — distributed system replay-safe + reorder-safe). Distinção 3 dimensões: cancellationWindow é temporal (janela permitida); ordering é causal (sequence preservada AT evaluation time per system state); state-evaluation é authoritative source (aggregate canonical, NÃO event sequence). Trap related: previne emit-cancel-without-issue (cancel órfão) + previne false-pass-via-reorder (cancel chega antes de issue em event log mas state já tem issue confirmed; replay/reorder não pode validar cancel se state não confirma)."
	}, {
		code: "cst-cancel-no-mutation"
		name: "Cancel MUST NOT mutate Invoice fields (audit trail preservation)"
		description: """
			[KIND: behavioral-constraint / category: immutability]

			Cancel NÃO altera campos da Invoice — apenas transiciona
			status (issued → cancelled) e emite InvoiceCancelled event.
			Forbidden mutations: amount, currency, regimeVersion,
			fiscalDocRef, commitmentRef, evidenceRef, issuedAt.

			Trap T3 (mutation silenciosa → audit trail destruído)
			endereçado estruturalmente. Reinforces sc-inv-03 (regime-
			immutability) + sc-inv-06 (fiscalDocRef write-once) — cancel
			operation MUST preserve all immutable fields verbatim.
			"""
		verification: """
			kind: behavioral-constraint
			category: immutability-preservation
			requiredChecks:
			- type: mutation-absence
			  target: Invoice
			  forbidden-fields: [amount, currency, regimeVersion, fiscalDocRef, commitmentRef, evidenceRef, issuedAt]
			  expected: no-change-on-cancel
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-03
			  expected: not-violated
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-06
			  expected: not-violated
			  enforcementLevel: hard
			- type: state-transition-only
			  target: Invoice.status
			  allowed-transition: [issued → cancelled]
			  expected: state-transition-isolated-to-status-field
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa Trap T3 estruturalmente + cc-04 audit trail regulatory-grade preservation. Cancel é state-transition-only (status field) + event-emission; qualquer mutation além disso destrói audit forensics (regulação tributária requer rastreabilidade ≥5 anos)."
	}, {
		code: "cst-cancel-event-required"
		name: "Cancel MUST emit explicit InvoiceCancelled event"
		description: """
			[KIND: behavioral-constraint / category: event-emission-mandatory]

			Cancel é state transition + event emission, NÃO state mutation
			silenciosa. evt-invoice-cancelled MUST be emitted; absence
			equivale a cancel inválido per inv-cancellation-event-required.

			Trap T5 (event optional → história do sistema perdida)
			endereçado estruturalmente. Reinforces sc-inv-07 — sistema
			NÃO confia em state inspection retroativa para reconstruir
			cancellation history; event-stream é canonical source.
			"""
		verification: """
			kind: behavioral-constraint
			category: event-emission-mandatory
			invariantRef: inv-cancellation-event-required
			requiredChecks:
			- type: event-emission
			  target: evt-invoice-cancelled
			  expected: emitted
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-07
			  expected: not-violated
			  enforcementLevel: hard
			- type: payload-completeness
			  target: InvoiceCancelled
			  required-fields: [invoiceId, cancelledAt, regimeVersionAtCancel]
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa Trap T5 estruturalmente + sc-inv-07 cancellation-event-required. Event-stream é canonical history source (não state snapshot); cancel sem event invisibiliza transição perante audit + downstream consumers (FCE/REW que reagem a cancellation)."
	}, {
		code: "cst-cancel-no-supersession"
		name: "Cancel MUST NOT behave as supersession (anti-DLV/DRC pattern leak)"
		description: """
			[KIND: behavioral-constraint / category: anti-drift-pattern-leak]

			Cancel NÃO substitui invoice; NÃO cria nova invoice; NÃO
			reemite; NÃO corrige. Supersession é DLV (evidence supersession)
			OR DRC (accounting reversal) pattern — explicitamente NÃO INV.

			Trap T1 (cancel ≡ undo → supersession escondida) + Trap T6
			(cancel-as-correction → erro sistêmico mascarado) endereçados
			estruturalmente. Forbidden post-cancel emissions:
			InvoiceIssued (mesma invoiceId), InvoiceIssued (commitmentRef
			compartilhado novo invoiceId implícito-replace).
			"""
		verification: """
			kind: behavioral-constraint
			category: anti-drift-pattern-leak
			requiredChecks:
			- type: emission-absence
			  forbidden-event: evt-invoice-issued
			  context: post-cancel-same-invoice-id
			  enforcementLevel: hard
			- type: emission-absence
			  forbidden-event: evt-invoice-issued
			  context: post-cancel-same-commitmentRef-evidenceRef-tuple
			  rationale: previne replace-by-reissue camuflado
			  enforcementLevel: hard
			- type: cancel-purpose-acknowledgment
			  target: cancellation-reasonCode
			  expected: regulatory-cancellation-only
			  forbidden-purpose: [accounting-correction, payment-correction, credit-correction]
			  enforcementLevel: hard
			- type: glossary-antiTerm-coverage
			  target: anti-mini-DRC + anti-mini-FCE + anti-mini-SCF
			  expected: pattern-leak-prevented-via-glossary-discipline
			  enforcementLevel: advisory
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa Traps T1 + T6 estruturalmente + boundary preservation transversal. Supersession leak from DLV/DRC into INV destroys regulatory-cancellation purity (cancel é declaração regulatória de invalidação, NÃO ferramenta correção contábil/pagamento/crédito). Glossary antiTerms (anti-mini-*) reforçam advisory layer."
	}, {
		code: "cst-react-no-event-coupling"
		name: "Reactive actions MUST NOT couple to events as commands (boundary preservation transversal)"
		description: """
			[KIND: behavioral-constraint / category: anti-drift-reactive]

			Reactive actions (act-block-emit-on-stale + act-filter-
			non-terminal-dlv + act-escalate-regime-anomaly) NÃO são
			if-event-then-action. Default reactive = NO_ACTION.
			Action-decision é exception structurally constrained,
			NÃO obrigação derivada de event.

			3 traps reactive endereçados transversalmente:
			- T-R1 (orchestrator leak) — reactive NÃO emite cross-BC
			  commands em response a event; agent reage NÃO orquestra
			- T-R2 (retry automático) — failed gate/decision NÃO
			  dispara retry loop; comportamento = event-driven re-
			  evaluation OR no-action; NÃO automatic retry
			- T-R3 (event vira command) — every-event-mandates-action
			  destrói determinismo; default NO_ACTION até classification
			  + structural permission satisfeitos

			Conceito central founder framing Phase 4 reactive:
			'agent controla quando o mundo NÃO deve causar ação' —
			isso transforma sistema em determinístico SOB eventos
			não determinísticos.
			"""
		verification: """
			kind: behavioral-constraint
			category: anti-drift-reactive
			scope: reactive-actions
			requiredChecks:
			- type: cross-bc-command-emission-absent
			  target: reactive-actions
			  forbidden: cmd-* targeting non-INV bounded contexts
			  expected: zero-cross-bc-command-emission
			  enforcementLevel: hard
			- type: retry-loop-absent
			  target: reactive-actions
			  forbidden: automatic-retry on failed gate OR decision
			  expected: event-driven-re-evaluation OR no-action
			  enforcementLevel: hard
			- type: default-no-action-discipline
			  target: reactive-actions
			  expected: classification-required-before-decision
			  forbidden: action-derived-mandatorily-from-event
			  enforcementLevel: hard
			- type: sync-query-absent-reactive-path
			  target: reactive-critical-path
			  forbidden-target: external-BC-sync-query-during-reactive
			  expected: trusted-internal-projection-only OR no-action
			  enforcementLevel: hard
			- type: boundary-preservation-anti-mini-ATO
			  target: act-escalate-regime-anomaly
			  expected: detection-only-NOT-correction
			  forbidden: regime-correction-attempted-by-agent
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa Traps T-R1 + T-R2 + T-R3 estruturalmente. Reactive boundary preservation transversal — agent reage NÃO orquestra; agent SINALIZA NÃO retry; agent CLASSIFICA NÃO obriga. BD10 anti-orchestrator + replay independence preservados. Founder framing: 'agent controla quando o mundo NÃO deve causar ação' transforma sistema em determinístico sob eventos não-determinísticos."
	}, {
		code: "cst-react-classification-mandatory"
		name: "Reactive actions MUST classify before deciding (classification discipline)"
		description: """
			[KIND: behavioral-constraint / category: classification-discipline]

			Reactive actions MUST classify event/state characteristics
			BEFORE qualquer decisão de ação. Sem classification
			disciplinada, BD4 (deterministic-fiscal-projection) é
			destruído via stale==missing equivalence + comportamento
			torna-se não-determinístico.

			2 traps endereçados transversalmente:
			- T-R4 (stale ≡ missing) — distintas dimensions, distintos
			  handling: stale = block-and-defer (BD4 protected);
			  missing = wait (eventual consistency);
			  fresh-but-incomplete = wait (data integrity); fresh-
			  and-complete = proceed
			- T-R5 (reagir sem classificar) — classification step
			  é precondition mandatory; default NO_ACTION até
			  classification completed

			Classification dimensions per reactive action:
			- act-block-emit-on-stale: staleness-type ∈ {stale,
			  missing, fresh-but-incomplete, fresh-and-complete}
			- act-filter-non-terminal-dlv: terminality ∈ {terminal,
			  non-terminal, superseded, transitional, ambiguous}
			- act-escalate-regime-anomaly: regime-classification ∈
			  {monotonic-progression, anomalous-jump, expired-but-
			  active, missing}
			"""
		verification: """
			kind: behavioral-constraint
			category: classification-discipline
			scope: reactive-actions
			requiredChecks:
			- type: classification-precedes-decision
			  target: reactive-actions
			  expected: classification-step-completed-before-action-decision
			  forbidden: action-decision-without-classification-completed
			  enforcementLevel: hard
			- type: staleness-vs-missing-disjoint
			  target: act-block-emit-on-stale
			  expected: distinct-classifications [stale, missing, fresh-but-incomplete, fresh-and-complete]
			  forbidden: stale-treated-as-missing OR missing-treated-as-stale
			  enforcementLevel: hard
			- type: terminality-classification-required
			  target: act-filter-non-terminal-dlv
			  expected: terminality-classified-before-filter-decision
			  enforcementLevel: hard
			- type: regime-classification-required
			  target: act-escalate-regime-anomaly
			  expected: regime-classification-before-anomaly-determination
			  enforcementLevel: hard
			- type: classification-dimension-completeness
			  target: reactive-actions
			  expected: every-reactive-declares-its-classification-dimension
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa Traps T-R4 + T-R5 estruturalmente. Classification discipline transversal — sem classification disciplinada, BD4 destruído (stale==missing) + comportamento não-determinístico. Cada reactive carrega sua classification dimension declarada; agent NÃO age sem classification completa. Pattern paralelo P10 (gates determinísticos validam) aplicado a reactive layer."
	}, {
		code: "cst-system-boundary-acknowledged"
		name: "System-level boundary assumptions explicitly acknowledged (NOT structurally enforced by agent)"
		description: """
			[KIND: declarative-acknowledgment / category: system-boundary-assumption]

			ACKNOWLEDGED LIMITS (founder R2 adversarial review post-
			Phase 4 — 2 system-level assumptions implícitas tornadas
			canônicas):

			(A) OBSERVATION CONSISTENCY — atomic emit ≠ atomic
			observation. Agent garante emission atomicity (sc-inv-01
			via cst-gate-issue-atomic-feasibility-execution); CONSUMERS
			+ INFRASTRUCTURE responsibility: tratar InvoiceIssued +
			ReceivableMaterialized como atomic semantic pair em
			observation/consumption side. Partial observation (e.g.,
			projection updates antes de ambos eventos arrivers; reader
			pega snapshot intermediário; downstream consume out-of-
			order) é INVALID STATE — consumers MUST treat per
			correlationId / event-grouping / same-txId boundary.
			Agent declara expectation; NÃO enforce consumer side.

			(B) SINGLE ENTRY POINT — all Invoice creation MUST pass
			through act-issue-invoice (OR equivalent gate-enforced
			path). Backfill scripts, migration scripts, batch imports,
			manual corrections que bypassam agent gate path violam
			boundary preservation transversal — invariantes podem ser
			bypassed silently. Agent NÃO controla system-wide creation
			paths Phase 0; sistema-wide governance + ops discipline
			responsibility. Agent declara expectation; NÃO enforce
			ops side.

			Both são SYSTEM-LEVEL assumptions — agent declara
			canonicamente per honesty arquitetural (sistema declara
			escopo real de enforcement, NÃO finge cobertura completa).
			Phase 1+ promotion para mecanismos estruturais
			(correlationId/txId schema mod ADR; structural-check kind
			'aggregate-creation-paths-restricted') deferred.
			"""
		verification: """
			kind: declarative-acknowledgment
			category: system-boundary-assumption
			riskLevel: high (observation-consistency) | medium-high (single-entry-point)
			impact: cross-system-correctness
			acknowledgedAssumptions:
			- id: observation-consistency
			  type: atomic-pair-observation-required
			  scope: consumers + infrastructure layer
			  attack-vectors-residual: [partial-observation-via-projection-update-skew, snapshot-intermediate-read, out-of-order-downstream-consumption]
			  ideal-mitigation: correlationId OR event-grouping OR same-txId boundary (Phase 1+)
			- id: single-entry-point
			  type: all-creation-via-gate-enforced-path
			  scope: system-wide governance + ops discipline
			  attack-vectors-residual: [backfill-script-bypass, migration-bypass, batch-import-bypass, manual-correction-bypass]
			  ideal-mitigation: ADR-backfill-policy + structural-check kind aggregate-creation-paths-restricted (Phase 1+)
			requiredChecks:
			- type: declarative-acknowledgment
			  target: observation-consistency
			  expected: documented-in-rationale
			  enforcementLevel: advisory
			- type: declarative-acknowledgment
			  target: single-entry-point
			  expected: documented-in-rationale
			  enforcementLevel: advisory
			- type: srr-declared-residual-risk
			  target: srr-inv-primary-agent
			  expected: round-2-findings-explicitly-declared
			  enforcementLevel: advisory
			"""
		onViolation: "log-only"
		rationale: "Founder R2 adversarial review post-Phase 4 identificou 2 assumptions implícitas que NÃO eram declared canonicamente: observation consistency (R1 high — atomic emit ≠ atomic observation; consumer responsibility) + single entry point (R4 medium-high — backfill/migration/batch bypass possíveis). Honesty arquitetural: agent declara escopo real de enforcement (emission é guaranteed; observation + entry-point são system-level responsibility distintas). Phase 1+ promotion: correlationId/txId mechanism (R1 → ADR future) + structural-check kind 'aggregate-creation-paths-restricted' (R4 → Phase 1+). enforcementLevel: advisory porque é declarativo system-boundary ACK, NÃO agent-enforceable."
	}]

	escalationConditions: [{
		category: "insufficient-context"
		description: """
			Folded scenarios (issue + cancel + reactive actions):

			(A) ISSUE — GUARD failure (Layer 4 predicate
			canIssueInvoice): projection unavailable/incomplete/stale
			(BD4) OR verificationOutcome != approved.

			(B) CANCEL — GUARD failure: invoice not found in aggregate
			canonical state OR Invoice.status != issued (already
			cancelled OR transitional state).

			(C) REACTIVE BLOCK (act-block-emit-on-stale) — staleness
			classification == stale detected on evt-delivery-verified
			trigger; act-issue-invoice path BLOCKED for tuple. Stale
			distinct from missing (Trap T-R4 endereçado).

			DECISION local: ABORT_ACTION (action does not execute;
			emit nothing). Aplicável a todos cenários.
			ESCALATION systemic: DEFERRED — propose-and-wait com
			structured failureReason classified (missing/incomplete/
			stale/verification-failed para issue; not-found/wrong-
			status para cancel; staleness-type=stale para reactive).
			Threshold-based escalation per esc-projection-missing OR
			esc-projection-stale-sustained soft canvas escalation
			pode disparar Phase 1+ se condition persists.
			"""
		rationale: "BD4 + BD1 RECTOR. Guard failure NÃO é decisão a escalar imediatamente — é estado a aguardar. Local ABORT_ACTION distinto de DEFERRED systemic ESCALATION (pode acontecer depois via threshold) — wait pattern preserva replay independence. Cancel-not-found tipicamente reflete eventual consistency lag (DEFERRED válido); reactive stale-block é classification disciplinada NÃO confundindo com missing (Trap T-R4); padrão DLV precedent (folded scenarios via OR per category)."
	}, {
		category: "out-of-scope"
		description: """
			Folded scenarios (issue + cancel actions):

			(A) ISSUE — STRUCTURAL GATE violation pre-emit:
			cst-gate-issue-idempotency-pre-execution detecta tuple
			(commitmentRef, evidenceRef) já existente em aggregate
			state. Replay legítimo é normal; pattern anômalo dispara
			SOFT/HARD threshold-based.

			(B) CANCEL — STRUCTURAL GATE violation: tentativa de
			cancel fora da janela fiscal (sc-inv-05 cancellation-
			boundary cruzada) OR post-finality (cst-gate-cancel-
			finality-protection violado). REGULATORY VIOLATION
			structural — distintamente HARD (não soft replay).

			DECISION local: ABORT_ACTION (no-op replay-safe para issue;
			permanent block para cancel — boundary regulatório não-
			retryable).
			ESCALATION systemic:
			- ISSUE: SOFT (audit-trail entry + pattern-detection
			  counter); HARD apenas em pattern adversarial
			- CANCEL: HARD imediato — REGULATORY VIOLATION
			  (out-of-window OR post-finality é regulatory boundary
			  breach, NÃO retryable).
			"""
		rationale: "BD3 + sc-inv-02 (issue) + sc-inv-05 + finality-protection (cancel). Issue out-of-scope é tipicamente replay legítimo (SOFT), cancel out-of-scope é regulatory violation (HARD imediato — janela fiscal expirada NÃO se reabre). Distinção severity refletida no description; padrão DLV precedent (folded via OR)."
	}, {
		category: "suspicious-input"
		description: """
			Folded scenarios (issue + cancel actions) com sub-
			classification founder R2 review (verify-failed ≠
			invariant-violated):

			(A) ISSUE — STRUCTURAL GATE failure (cst-gate-issue-
			atomic-feasibility-execution):
			Sub-classifications:
			- INFRASTRUCTURE-BREACH (VERIFIED): outbox primitive
			  CONFIRMED unavailable OR partial state CONFIRMED
			  observable post-emit. Real structural breach.
			- VERIFICATION-UNCERTAIN: agent NÃO consegue verificar
			  gate (DB timeout durante state lookup; projection
			  unavailable; leitura inconsistente). Verify failed
			  mas violação NÃO confirmed.

			(B) CANCEL — TEMPORAL/ORDERING inconsistency:
			Sub-classifications:
			- TEMPORAL-INCONSISTENCY (VERIFIED): clock skew
			  CONFIRMED via cross-source comparison OR ordering
			  inversion CONFIRMED via aggregate state contradiction.
			- VERIFICATION-UNCERTAIN: clockSource canonical
			  unreachable durante check; aggregate state evaluation
			  incomplete. Verify failed mas violação NÃO confirmed.

			Founder R2 distinction: verify-failed ≠ invariant-
			violated. Agent NÃO trata 'não consegui verificar' como
			'violação real' — previne falso negativo operacional +
			escalation overhead + throughput loss.

			DECISION local: ABORT_ACTION immediately (no retry
			parcial in-flight; no compensation step). Aplicável a
			TODOS cenários (verified OR uncertain).

			ESCALATION systemic distinct per sub-classification:
			- VERIFIED breach (INFRASTRUCTURE-BREACH OR TEMPORAL-
			  INCONSISTENCY) → HARD imediato (real breach
			  classification)
			- VERIFICATION-UNCERTAIN → SOFT (audit-trail entry +
			  retry-eligible classification + pattern-detection
			  counter); HARD apenas em pattern sustained (envelope
			  governance Phase 5 threshold) — distingue glitch
			  ocasional de breach sustentado
			"""
		rationale: "BD7 + sc-inv-01 (issue) + cst-gate-cancel-ordering + clockSource canonical (cancel). Founder R2 adversarial review distinction: VERIFIED breach (HARD imediato — real structural failure) vs VERIFY-UNCERTAIN (SOFT retry-eligible — verify failed mas violação NÃO confirmed). Distinção previne falso negativo operacional (DB timeout NÃO é INFRASTRUCTURE-BREACH; clockSource glitch NÃO é TEMPORAL-INCONSISTENCY). Local ABORT_ACTION mandatory em ambos (no retry in-flight); diferença é SEVERITY systemic + retry-eligibility downstream. Pattern preserva determinism (action-decision deterministic) + reduz escalation overhead operacional."
	}, {
		category: "conflicting-signals"
		description: """
			REACTIVE ESCALATE scenario (act-escalate-regime-anomaly):
			regimeVersion observed (via projection OR event payload)
			conflita com expected pattern (CMT projection canonical
			source). Classifications anomalous: anomalous-jump (non-
			monotonic version progression); expired-but-active (regime
			past validity but still tagged active); missing
			(commitmentRef has no resolved regimeVersion).

			DECISION local: ABORT_ACTION-FOR-ISSUE (block issue path
			for affected tuple) + DO_NOT_CORRECT (anti-mini-ATO; ATO
			domain owns regime correction logic).
			ESCALATION systemic: HARD imediato — DOMAIN-INCONSISTENCY
			classification; routed via envelope governance Phase 5
			escalation-routing block.

			Boundary preservation crítica: agent NÃO corrige regime
			(Trap T-R1 reactive virar orchestrator). Detection é INV
			responsibility (recognize boundary breach); correction é
			ATO/CMT responsibility (respect boundary).
			"""
		rationale: "Conflicting-signals captura reactive ESCALATE pattern (regime classification anomalous vs expected from CMT projection — sinais contraditórios de fontes diferentes per #EscalationCategory definition). Distinto de unclassifiable-anomaly (post-emit corruption) — regime anomaly é PRE-emit detection que bloqueia issue path + escala detection. Anti-mini-ATO preservado: agent reage NÃO orquestra; agent SINALIZA NÃO corrige."
	}, {
		category: "unclassifiable-anomaly"
		description: """
			POST-EXECUTION invariant violation: sc-inv-* audit detecta
			invariant violado apesar de gates passing pre-emit.
			Examples: amount mismatch Invoice ↔ Receivable; orphan
			Invoice OR orphan Receivable; cardinalidade != 1; status
			outside enum; fiscalDocRef mutation.

			DECISION local: HALT_AGENT (no further autonomous action
			across ANY action — agent-wide stop, NÃO action-specific).
			ESCALATION systemic: HARD imediato — DOMAIN-CORRUPTION;
			founder review + audit reconciliation mandatory; agent
			não pode 'corrigir' domain corruption (fora do envelope
			de autonomy).
			"""
		rationale: "Distinção crítica: HALT_AGENT (agent-wide stop) ≠ ABORT_ACTION (action-specific). Domain corruption afeta agent confidence inteira — não apenas a action atual; humano + audit trail são única recovery path Phase 0."
	}]

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas INV materializa governanceScope (autonomousDecisions + supervisedDecisions + 7 escalationCriteria) + 6 verificationMetrics + 10 BDs (incluindo BD2 deterministic-fiscal-projection + BD7 atomic-dual-emission + BD10 anti-orchestrator) — todos referências de actions e constraints do agent."
		}, {
			artifactType: "domain-model"
			rationale:    "Domain-model materializa 8 invariants formais + 1 aggregate (Invoice + Receivable interna) + lifecycle 2 estados + 3 events + 2 commands + 1 projection — todas referências de actions, postconditions, e structural-check refs."
		}, {
			artifactType: "glossary"
			rationale:    "Ubiquitous Language INV (18 termos canônicos em 4 layers + 27 antiTerms) é vocabulário canonical; agent uses para naming actions + signals + boundary clarity (antiTerms anti-mini-FCE/ATO/SCF/REW)."
		}, {
			artifactType: "agent-governance"
			rationale:    "Governance envelope (Phase 5 forward-ref) declara COMO escalar (canal, SLA, destinatário) + autonomy calibration overrides — agent-spec declara QUANDO; envelope declara COMO. Antifragility 4 blocks (autonomy-overrides + escalation-routing + freeze-model + drift-detection-metrics) elaboram runtime layer per cada runtimeGap declarado nos structural-checks Phase 3.5 (architecture/structural-checks/inv-domain-model.cue per ADR-080 — referenced via runtimeGap.enforcedBy fields)."
		}]
		estimatedBudget: "moderate"
	}

	observability: {
		signals: [{
			code:           "sig-invoice-issued-emitted"
			name:           "Invoice issued (atomic dual emission)"
			description:    "Emitido após emit atomic bem-sucedido de InvoiceIssued + ReceivableMaterialized via transactional outbox. Indica ciclo completo da action act-issue-invoice (BD7 atomic-dual-emission realizada)."
			coversCategory: "mutation"
			trigger:        "Post-emit success: ambos eventos InvoiceIssued + ReceivableMaterialized acked pelo broker em single transactional boundary."
			level:          "info"
			payloadFields: [
				"timestamp",
				"invoiceId",
				"receivableId",
				"commitmentRef",
				"evidenceRef",
				"regimeVersion",
				"fiscalDocRef",
			]
		}, {
			code:           "sig-issue-structural-gate-blocked"
			name:           "Issue blocked by structural gate (pre-emit)"
			description:    "Emitido quando cst-gate-issue-idempotency-pre-execution OU cst-gate-issue-atomic-feasibility-execution bloqueia emissão pre-emit. Distingue replay legítimo (sc-inv-02 idempotency) de infrastructure breach (sc-inv-01 atomic-feasibility)."
			coversCategory: "mutation"
			trigger:        "Pre-emit: structural gate (cst-gate-*) detecta violação per Phase 3.5 ADR-080 (sc-inv-01 atomic-feasibility OR sc-inv-02 idempotency)."
			level:          "warn"
			payloadFields: [
				"timestamp",
				"gateRef",
				"structuralCheckRef",
				"blockedReason",
				"commitmentRef",
				"evidenceRef",
			]
		}, {
			code:           "sig-issue-domain-corruption-detected"
			name:           "Domain corruption detected post-emit"
			description:    "Emitido quando audit pós-emit detecta invariant violation apesar de gates passing pre-emit. Dispara HALT_AGENT (agent-wide stop) per escalationCondition unclassifiable-anomaly."
			coversCategory: "mutation"
			trigger:        "Post-emit: sc-inv-* audit detecta violação de invariant (amount mismatch Invoice ↔ Receivable, orphan event, cardinality != 1, status outside enum, fiscalDocRef mutation)."
			level:          "critical"
			payloadFields: [
				"timestamp",
				"invariantRef",
				"violationDescription",
				"invoiceId",
				"receivableId",
				"auditTimestamp",
			]
		}, {
			code:           "sig-invoice-cancelled-emitted"
			name:           "Invoice cancelled (within fiscal window)"
			description:    "Emitido após emit bem-sucedido de InvoiceCancelled dentro de cancellationWindow. Indica ciclo completo da action act-cancel-invoice (BD cancellation-boundary respeitada + sc-inv-04/05/07 mantidos)."
			coversCategory: "mutation"
			trigger:        "Post-emit success: evt-invoice-cancelled acked pelo broker; transição issued → cancelled persistida; ordering [InvoiceIssued → InvoiceCancelled] preservada."
			level:          "info"
			payloadFields: [
				"timestamp",
				"invoiceId",
				"cancelledAt",
				"regimeVersionAtCancel",
				"cancellationReasonCode",
				"issuedAt",
				"windowAtCancel",
			]
		}, {
			code:           "sig-cancel-structural-gate-blocked"
			name:           "Cancel blocked by structural gate (pre-emit)"
			description:    "Emitido quando cst-gate-cancel-within-window OU cst-gate-cancel-finality-protection OU cst-gate-cancel-ordering bloqueia emissão pre-emit. Distingue blocking dimension (temporal vs finality vs ordering) para diagnostic clarity."
			coversCategory: "mutation"
			trigger:        "Pre-emit: structural gate cancel-* detecta violação per Phase 3.5 ADR-080 (sc-inv-04 lifecycle-states OR sc-inv-05 cancellation-boundary OR finality-protection)."
			level:          "warn"
			payloadFields: [
				"timestamp",
				"gateRef",
				"structuralCheckRef",
				"blockedDimension",
				"invoiceId",
				"now",
				"issuedAt",
				"cancellationWindowSnapshot",
			]
		}, {
			code:           "sig-cancel-regulatory-violation-attempt"
			name:           "Cancel attempt violates regulatory boundary (HARD escalation)"
			description:    "Emitido em escalation HARD por out-of-scope cancel: tentativa fora da janela fiscal (window expired) OU post-finality. Distinto de structural-gate-blocked (que cobre dimension diagnostic genérico) — este signal é regulatory-violation classification específica."
			coversCategory: "mutation"
			trigger:        "Pre-emit: cancel attempt cruza boundary regulatório (window expired OR finality crossed). HARD ESCALATION imediata per escalationCondition out-of-scope."
			level:          "error"
			payloadFields: [
				"timestamp",
				"invoiceId",
				"violationType",
				"regimeVersion",
				"now",
				"issuedAt",
				"windowExpiredAt",
				"finalityCrossedAt",
			]
		}, {
			code:           "sig-dlv-filtered-non-terminal"
			name:           "Delivery event filtered (non-terminal)"
			description:    "Emitido por act-filter-non-terminal-dlv quando evt-delivery-verified é classificado non-terminal (parcial OR superseded OR transitional OR ambiguous). Info-level observability — NÃO escalation; NÃO state mutation. Captura proporção de events filtered vs actioned para drift detection (Phase 5 envelope drift-detection-metrics block)."
			coversCategory: "validation"
			trigger:        "Reactive trigger: evt-delivery-verified classified terminality=non-terminal. Default NO_ACTION pattern executed."
			level:          "info"
			payloadFields: [
				"timestamp",
				"triggerEventRef",
				"commitmentRef",
				"evidenceRef",
				"terminalityClassification",
				"filterDecision",
			]
		}, {
			code:           "sig-regime-anomaly-detected"
			name:           "Regime version anomaly detected (reactive ESCALATE)"
			description:    "Emitido por act-escalate-regime-anomaly quando regimeVersion classification ∈ {anomalous-jump, expired-but-active, missing}. Critical-level — DOMAIN-INCONSISTENCY classification distinto de DOMAIN-CORRUPTION (post-emit). Pre-emit detection bloqueia issue path + HARD escalation; agent NÃO corrige (anti-mini-ATO; T-R1 endereçado)."
			coversCategory: "escalation"
			trigger:        "Reactive trigger: evt-delivery-verified com regime classification anomalous detected via projection comparison contra expected pattern."
			level:          "critical"
			payloadFields: [
				"timestamp",
				"triggerEventRef",
				"commitmentRef",
				"evidenceRef",
				"regimeClassification",
				"expectedRegimePattern",
				"observedRegimeVersion",
				"escalationClassification",
			]
		}]

		auditTrail: {
			requiredFields: [
				// _minimumAuditFields (regulatory-grade per tq-ag-13)
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				// INV-specific extensions (cc-04 fiscal audit trail) — issue + cancel
				"commitmentRef",
				"evidenceRef",
				"invoiceId",
				"receivableId",
				"regimeVersion",
				"fiscalDocRef",
				"executionResult",
				"reasonCode",
				// Cancel-specific extensions (Phase 4 Part 2 — temporal + regulatory traceability)
				"cancellationTimestamp",
				"cancellationReasonCode",
				"windowAtCancel",
				// Reactive-specific extensions (Phase 4 Part 3 — trigger event traceability + classification dimension)
				"triggerEventRef",
				"reactiveClassificationDimension",
			]
			storageHint: "Fiscal-grade audit log (regulação tributária requer rastreabilidade documento + inputs + outputs + escalation events; retention legal ≥5 anos NF-e Brasil; equivalentes em outros regimes jurisdicionais Phase 1+). Cancel events demandam trail simétrico — cancellationTimestamp + reasonCode + windowAtCancel preservam evidence forensics da decisão de invalidação dentro de boundary regulatório. Reactive actions registram triggerEventRef (evt-delivery-verified cross-BC traceability) + reactiveClassificationDimension (staleness-type | terminality | regime-classification) per Trap T-R5 (classification mandatory antes de decisão). Detalhes de implementação vivem no Architecture Communication Canvas."
			rationale:   "cc-04 audit trail regulatory-grade simétrico para issue + cancel + reactive. _minimumAuditFields ⊆ requiredFields satisfeito (7 minimum + 8 INV core + 3 cancel-specific + 2 reactive-specific = 20 fields total). Reactive-specific fields capturam trigger event cross-BC + classification dimension declarada — forensics permite reconstruir reactive decision path (evento → classification → decision); previne classification opacity (Trap T-R5) via audit trail mandatory."
		}
	}

	rationale: """
		Phase 4 Part 1 (act-issue-invoice) materializa execution layer
		determinística sobre Phase 1-3.5 artifacts. Conceito central:
		execution = action + proof that it can happen.

		**Execution model layered**:
		- preconditions = GUARDS (Layer 4 predicates; world state)
		- structural gates (cst-gate-* with kind:structural-gate
		  marker) = STRUCTURAL CHECKS (system state — sc-inv-* per
		  ADR-080)
		- constraints = behavioral + immutability + boundary
		  enforcement (cst-issue-*)

		**Workaround pre-ADR-081**: kind:structural-gate marker em
		description first-line + verification YAML top — schema
		closed-struct constraint impede top-level field; cristalização
		ADR-081 após 3 usos reais (issue + cancel + reactive).
		enforcementLevel: hard | advisory em cada requiredCheck (hard
		bloqueia execução; advisory registra).

		**ABORT_ACTION vs HALT_AGENT distinction**:
		- ABORT_ACTION (action-specific local decision): action does
		  not execute; emit nothing
		- HALT_AGENT (agent-wide stop): no further autonomous action
		  across ANY action — domain corruption escape
		Distinção previne tratamento errado (HALT como retryable;
		confusão com erro leve).

		**ESCALATION DEFERRED vs SOFT vs HARD**:
		- DEFERRED: pode acontecer depois via threshold (guard fail)
		- SOFT: audit-trail entry + pattern-detection counter
		  (replay legítimo)
		- HARD: imediato + infrastructure-breach OR domain-corruption
		  classification

		**Honesty arquitetural** (cst-schema-openness-acknowledged):
		schema-level field-set closure NÃO é structurally enforced
		Phase 0 — declarado como riskLevel: high + impact: boundary-
		risk + 4 attack vectors residuais + mitigations-active +
		mitigations-future. Sistema declara escopo real de
		enforcement, não finge cobertura completa.

		**Phase 4 Part 1 + Part 2 + Part 3 + R2 review scope** (este
		file): 5 actions (issue-invoice + cancel-invoice + 3 reactive)
		+ 14 constraints (2 cst-gate-issue-* + 3 cst-issue-* + 1 cst-
		schema-openness ACK + 3 cst-gate-cancel-* + 3 cst-cancel-* +
		2 cst-react-* transversal + 1 cst-system-boundary-acknowledged
		R2 ACK) + 5 escalationConditions (suspicious-input com sub-
		classifications VERIFIED → HARD vs VERIFICATION-UNCERTAIN →
		SOFT per founder R2 distinction; demais inalteradas) + 8
		observability signals (3 issue + 3 cancel + 2 reactive) + 20
		audit fields (7 minimum + 8 INV core + 3 cancel-specific + 2
		reactive-specific).

		**Founder R2 adversarial review (post-Phase 4) — 4 findings**:
		- R2-1 (HIGH) Observation consistency: declared via cst-
		  system-boundary-acknowledged (system-level assumption —
		  atomic emit ≠ atomic observation; consumer responsibility)
		- R2-2 (MED-HIGH) Cancel state-based ordering: cst-gate-
		  cancel-ordering atualizado (aggregate-state-evaluation-time
		  replaces sequence-based predecessor; replay/reorder safe)
		- R2-3 (OPER) Verify-uncertain distinction: suspicious-input
		  escalation atualizado (VERIFIED → HARD vs VERIFICATION-
		  UNCERTAIN → SOFT retry-eligible; previne falso negativo
		  operacional)
		- R2-4 (GOV) Single entry point: declared via cst-system-
		  boundary-acknowledged (system-level assumption — backfill/
		  migration/batch bypass possíveis Phase 0)

		**Cancel asymmetry com issue** (founder framing canônico):
		- Issue cria realidade (consistência ESTRUTURAL apenas)
		- Cancel invalida realidade sob regras externas (consistência
		  ESTRUTURAL + TEMPORAL + REGULATÓRIA — três dimensões)

		**6 traps cancel endereçados estruturalmente** (NÃO via
		comentário): T1 cancel-as-undo via cst-cancel-no-supersession;
		T2 window ambiguity via clockSource:canonical em verification;
		T3 silent mutation via cst-cancel-no-mutation; T4 post-finality
		via cst-gate-cancel-finality-protection; T5 event optional via
		cst-cancel-event-required; T6 cancel-as-correction via
		cst-cancel-no-supersession + glossary antiTerms anti-mini-DRC/
		FCE/SCF.

		**Severity asymmetry em escalationConditions folded**:
		- Issue out-of-scope → SOFT (replay legítimo é normal)
		- Cancel out-of-scope → HARD (regulatory boundary breach;
		  janela fiscal expirada NÃO se reabre — não retryable)
		- Issue suspicious-input → INFRASTRUCTURE-BREACH classification
		- Cancel suspicious-input → TEMPORAL-INCONSISTENCY classification
		Distinção severity preserva diagnostic clarity sem fragmentar
		categories (DLV precedent: 1 entry per category, scenarios
		folded via OR).

		**Reactive layer (Phase 4 Part 3)** — 3 reactive actions
		BLOCK/FILTER/ESCALATE materializadas:
		- act-block-emit-on-stale (BLOCK): stale projection → ABORT_
		  ACTION + sig-issue-structural-gate-blocked + DEFERRED
		- act-filter-non-terminal-dlv (FILTER): non-terminal event →
		  NO_ACTION + sig-dlv-filtered-non-terminal + no escalation
		- act-escalate-regime-anomaly (ESCALATE): regime anomalous →
		  ABORT + DO_NOT_CORRECT + sig-regime-anomaly-detected + HARD

		**5 reactive traps endereçados transversalmente** via 2
		constraints: cst-react-no-event-coupling cobre T-R1
		(orchestrator) + T-R2 (retry) + T-R3 (event-as-command);
		cst-react-classification-mandatory cobre T-R4 (stale==
		missing) + T-R5 (act-without-classification).

		**Conceito central reactive (founder framing canonical)**:
		'agent controla quando o mundo NÃO deve causar ação' →
		default reactive = NO_ACTION; action-decision é exception
		structurally constrained. Transforma sistema em
		determinístico SOB eventos não-determinísticos.

		**Asymmetry Issue/Cancel/Reactive**:
		- Issue: consistência ESTRUTURAL
		- Cancel: ESTRUTURAL + TEMPORAL + REGULATÓRIA (cancel é
		  asymmetric — invalidação sob regras externas, não simétrico
		  a issue creation)
		- Reactive: CLASSIFICATION-DISCIPLINED + DEFAULT-NO-ACTION
		  (default = não agir; agir é exception)

		**Pendente próximo commit**: SRR consolidado Phase 4 (1 agent-
		spec → 1 SRR final, padrão glossary/domain-model/structural-
		checks). ADR-081 schema mod (kind structural-gate first-class
		field + failureHandling discriminated + classificationDimension
		field) cristalização ready: 3 usos reais agora satisfeitos
		(cst-gate-issue-* + cst-gate-cancel-* + cst-react-* — founder
		rule '3 usos reais → vira schema').

		**Forward-refs Phase 5**: governanceRef='inv-primary-agent'
		aponta para envelope `contexts/inv/agents/inv-primary-agent.
		governance.cue` (Phase 5 antifragility 4 blocks: autonomy-
		overrides + escalation-routing + freeze-model + drift-
		detection-metrics) que elabora runtime enforcement layer
		per cada runtimeGap declarado nos structural-checks Phase
		3.5.

		Pattern paralelo DLV/P2P/SSC bootstrap discipline; primeiro
		agent-spec integrando structural-checks (kind domain-invariant
		ADR-080) como execution gates — sets pattern para backfill
		Phase 1+ outros BCs.
		"""
}
