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
// Phase 4 Part 1 + Part 2 (este file):
//   Part 1 — act-issue-invoice + 5 constraints (2 cst-gate-issue-*
//     + 3 cst-issue-* + 1 cst-schema-openness ACK)
//   Part 2 — act-cancel-invoice + 6 constraints (3 cst-gate-cancel-*
//     + 3 cst-cancel-*) + 6 traps endereçados estruturalmente
//     (T1 cancel-as-undo, T2 window ambiguity, T3 silent mutation,
//     T4 post-finality, T5 event optional, T6 cancel-as-correction)
// 4 escalationConditions (folded scenarios via OR per category,
// padrão DLV precedent) + 6 signals (3 issue + 3 cancel) +
// 18 audit fields (7 min + 8 INV + 3 cancel). Part 3 estende com
// reactive actions (filter-non-terminal-dlv + block-emit-on-stale)
// + supervisedDecision regime-anomaly. Cancel asymmetry: issue
// exige consistência ESTRUTURAL; cancel exige ESTRUTURAL +
// TEMPORAL + REGULATÓRIA.
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
			- type: event-ordering
			  sequence: [InvoiceIssued, InvoiceCancelled]
			  expected: strictly-ordered
			  enforcementLevel: hard
			- type: predecessor-event-existence
			  target: evt-invoice-issued
			  scope: same-invoice-id
			  expected: must-exist-before-cancel-emit
			  enforcementLevel: hard
			- type: structural-check-ref
			  target: sc-inv-04
			  binding: execution-ordering-constraint
			  expected: not-violated
			  enforcementLevel: hard
			"""
		onViolation: "block-and-escalate"
		rationale: "Materializa BD lifecycle-ordering + sc-inv-04 como execution-phase structural gate. Ordering integrity é causal (predecessor InvoiceIssued obrigatório); separado de temporal (window). Trap related: previne emit-cancel-without-issue (cancel órfão) que destruiria audit trail history."
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
	}]

	escalationConditions: [{
		category: "insufficient-context"
		description: """
			Folded scenarios (issue + cancel actions):

			(A) ISSUE — GUARD failure (Layer 4 predicate
			canIssueInvoice): projection unavailable/incomplete/stale
			(BD4) OR verificationOutcome != approved.

			(B) CANCEL — GUARD failure: invoice not found in aggregate
			canonical state OR Invoice.status != issued (already
			cancelled OR transitional state).

			DECISION local: ABORT_ACTION (action does not execute;
			emit nothing). Aplicável a ambos cenários.
			ESCALATION systemic: DEFERRED — propose-and-wait com
			structured failureReason classified (missing/incomplete/
			stale/verification-failed para issue; not-found/wrong-
			status para cancel). Threshold-based escalation
			per esc-projection-missing soft canvas escalation pode
			disparar Phase 1+ se condition persists.
			"""
		rationale: "BD4 + BD1 RECTOR. Guard failure NÃO é decisão a escalar imediatamente — é estado a aguardar. Local ABORT_ACTION distinto de DEFERRED systemic ESCALATION (pode acontecer depois via threshold) — wait pattern preserva replay independence. Cancel-not-found tipicamente reflete eventual consistency lag (DEFERRED válido); padrão DLV precedent (folded scenarios via OR per category)."
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
			Folded scenarios (issue + cancel actions):

			(A) ISSUE — STRUCTURAL GATE failure: cst-gate-issue-
			atomic-feasibility-execution detecta transactional outbox
			primitive failure pre-emit OR partial state observable
			post-emit. INFRASTRUCTURE-BREACH classification.

			(B) CANCEL — TEMPORAL/ORDERING inconsistency: clock
			source inconsistente (multiple authoritative clocks) OR
			ordering inversion detected (cst-gate-cancel-ordering
			violation — InvoiceCancelled emit attempt sem
			InvoiceIssued predecessor in event store). TEMPORAL-
			INCONSISTENCY classification.

			DECISION local: ABORT_ACTION immediately (no retry parcial;
			no compensation step). Aplicável a ambos cenários.
			ESCALATION systemic: HARD imediato — distintos por
			classification:
			- ISSUE: INFRASTRUCTURE-BREACH (outbox failure)
			- CANCEL: TEMPORAL-INCONSISTENCY (clock OR ordering)
			Freeze de fluxo escalado per canvas escalations se
			pattern sistêmico.
			"""
		rationale: "BD7 + sc-inv-01 (issue) + cst-gate-cancel-ordering + clockSource canonical (cancel). Ambos cenários são estruturais — local ABORT_ACTION mandatory + systemic HARD ESCALATION imediata. Classification distinct (INFRASTRUCTURE vs TEMPORAL) preserva diagnostic clarity para forensics; agent detecta limite estrutural canônico em ambos."
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
			]
			storageHint: "Fiscal-grade audit log (regulação tributária requer rastreabilidade documento + inputs + outputs + escalation events; retention legal ≥5 anos NF-e Brasil; equivalentes em outros regimes jurisdicionais Phase 1+). Cancel events demandam trail simétrico — cancellationTimestamp + reasonCode + windowAtCancel preservam evidence forensics da decisão de invalidação dentro de boundary regulatório. Detalhes de implementação vivem no Architecture Communication Canvas."
			rationale:   "cc-04 audit trail regulatory-grade simétrico para issue + cancel. _minimumAuditFields ⊆ requiredFields satisfeito (7 minimum + 8 INV core extensions + 3 cancel-specific = 18 fields total). Cancel-specific fields capturam temporal boundary (cancellationTimestamp + windowAtCancel) + regulatory classification (cancellationReasonCode) — forensics demanda janela snapshot in-flight (NÃO recomputed post-hoc) per Trap T2 (window ambiguity)."
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

		**Phase 4 Part 1 + Part 2 scope** (este file): 2 actions
		(issue-invoice + cancel-invoice) + 11 constraints (2 cst-gate-
		issue-* + 3 cst-issue-* + 1 cst-schema-openness ACK + 3 cst-
		gate-cancel-* + 3 cst-cancel-*) + 4 escalationConditions
		(folded scenarios issue + cancel via OR per category, padrão
		DLV precedent) + 6 observability signals (3 issue + 3 cancel)
		+ 18 audit fields (7 minimum + 8 INV core + 3 cancel-specific).

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

		**Pendente Phase 4 Part 3** (próximo commit): reactive actions
		(filter-non-terminal-dlv + block-emit-on-stale-or-missing-
		projection) + supervisedDecision (emit-with-regime-anomaly).
		ADR-081 schema mod (kind structural-gate first-class field +
		failureHandling discriminated) cristalizará após Part 3
		(3 usos reais: issue + cancel + reactive — founder rule).

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
