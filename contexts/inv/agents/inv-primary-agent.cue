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
// Phase 4 Part 1 (este commit): act-issue-invoice + 5 constraints
// (2 cst-gate-* + 3 cst-issue-* + 1 cst-schema-openness ACK) +
// 4 escalationConditions cobrindo failure modes per founder
// canonical block. Part 2 estende com act-cancel-invoice +
// reactive actions (filter-non-terminal-dlv + block-emit-on-stale)
// + supervisedDecision regime-anomaly + full INV agent-spec.
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
	}]

	escalationConditions: [{
		category: "insufficient-context"
		description: """
			GUARD failure (Layer 4 predicate canIssueInvoice):
			projection unavailable/incomplete/stale (BD4) OR
			verificationOutcome != approved.

			DECISION local: ABORT_ACTION (action does not execute;
			emit nothing).
			ESCALATION systemic: DEFERRED — propose-and-wait com
			structured failureReason classified (missing/incomplete/
			stale/verification-failed). Threshold-based escalation
			per esc-projection-missing soft canvas escalation pode
			disparar Phase 1+ se condition persists.
			"""
		rationale: "BD4 + BD1 RECTOR. Guard failure NÃO é decisão a escalar imediatamente — é estado a aguardar. Local ABORT_ACTION distinto de DEFERRED systemic ESCALATION (pode acontecer depois via threshold) — wait pattern preserva replay independence."
	}, {
		category: "out-of-scope"
		description: """
			STRUCTURAL GATE violation pre-emit: cst-gate-issue-
			idempotency-pre-execution detecta tuple (commitmentRef,
			evidenceRef) já existente em aggregate state.

			DECISION local: ABORT_ACTION (no-op replay-safe; emit
			nothing).
			ESCALATION systemic: SOFT (audit-trail entry +
			pattern-detection counter). Replay legítimo é normal;
			pattern anômalo (high rate sustained) dispara HARD
			escalation per esc-duplicate-issuance-attempt-detected
			canvas escalation (Phase 1+ pattern threshold).
			"""
		rationale: "BD3 + sc-inv-02 pre-execution gate. Local ABORT_ACTION distinto de SOFT systemic ESCALATION (audit + counter); HARD apenas em pattern adversarial."
	}, {
		category: "suspicious-input"
		description: """
			STRUCTURAL GATE failure: cst-gate-issue-atomic-feasibility-
			execution detecta transactional outbox primitive failure
			pre-emit OR partial state observable post-emit.

			DECISION local: ABORT_ACTION immediately (no retry parcial;
			no compensation step).
			ESCALATION systemic: HARD imediato — INFRASTRUCTURE-BREACH.
			Freeze de fluxo escalado per esc-atomic-emit-primitive-
			failure canvas escalation se pattern sistêmico (múltiplas
			falhas em janela curta).
			"""
		rationale: "BD7 + sc-inv-01. Atomicidade falha é estrutural — local ABORT_ACTION mandatory + systemic HARD ESCALATION imediata. Agent detecta limite estrutural canônico (founder framing 'falha estrutural detectável, não bug')."
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
				// INV-specific extensions (cc-04 fiscal audit trail)
				"commitmentRef",
				"evidenceRef",
				"invoiceId",
				"receivableId",
				"regimeVersion",
				"fiscalDocRef",
				"executionResult",
				"reasonCode",
			]
			storageHint: "Fiscal-grade audit log (regulação tributária requer rastreabilidade documento + inputs + outputs + escalation events; retention legal ≥5 anos NF-e Brasil; equivalentes em outros regimes jurisdicionais Phase 1+). Detalhes de implementação vivem no Architecture Communication Canvas."
			rationale:   "cc-04 audit trail regulatory-grade. Cada execution emit OR escalation registra cadeia completa para forensic + dispute resolution. _minimumAuditFields ⊆ requiredFields satisfeito (7 minimum + 8 INV-specific extensions = 15 fields total)."
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

		**Phase 4 Part 1 scope**: 1 action (issue-invoice) + 5
		constraints (2 cst-gate-* + 3 cst-issue-* + 1 cst-schema-
		openness ACK) + 4 escalationConditions cobrindo failure
		modes founder canonical block. Part 2 estende com act-cancel-
		invoice (irreversibilidade + boundary regulatório fiscal)
		+ reactive actions (filter-non-terminal-dlv + block-emit-
		on-stale-or-missing-projection) + supervisedDecision
		emit-with-regime-anomaly.

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
