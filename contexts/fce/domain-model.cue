package fce

// domain-model.cue — Domain Model FCE: Financial Commitment Execution.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// =============================================================================
// CENTERING PRINCIPLES (charter constitucional Phase 3.0 — founder approved
// com 7 refinements integrated; embedded também em outer rationale)
// =============================================================================
//
// P1 — Gravitational center: "authoritative economic convergence under
//      integrity constraints". NÃO é Payment, Settlement, Ledger,
//      Transaction, Workflow, Orchestration. Todo building block deve
//      parecer derivado deste centro; aparência ERP/payment-processor é
//      sinal amarelo imediato.
//
// P2 — Invariant tripartition ontológica: 11 invariants organizadas em 3
//      classes — Boundary (inv-bdy-*, 4), Convergence (inv-cvg-*, 4),
//      Epistemic (inv-eps-*, 3). Cada invariant carrega primaryClass +
//      secondaryTraits no rationale opening (parseable por future tooling).
//
// P3 — State machine bipartition: EconomicLifecycleState (FCE-owned,
//      authoritative — 9 states no aggregate lifecycle) ⊕
//      ObservedSettlementSnapshot (BKR-owned imported truth, modelada como
//      VO read-only — anti-shadow-ownership framing). Settlement truth é
//      BKR-owned; economic consequence é FCE-owned.
//
// P4 — Services as integrity guardians, NOT application services /
//      orchestrators. Protect semantic invariants, not execution
//      continuity. Failure semantics: fail/defer/escalate, NEVER
//      degrade gracefully or retry-recover-partial.
//
// P5 — Naming is architecture. Forbidden by construction:
//      Payment{Completed|Processed|Executed|Fulfilled},
//      Transaction{Completed}, Optimized{...}, FastTrack{...},
//      Smart{...}, AutoApproved{...}. Success-oriented +
//      collapse-FCE-BKR naming proibidos.
//
// P6 — Authoring order canonical (followed in this file):
//      invariants → state machine → value objects → services →
//      commands/events → aggregate assembly → policies → projections.
//      Projections last because they collapse ontology into views —
//      derive from model, never influence it.
//
// P7 — Threat model elevation (vs Phase 2 lexical):
//      structural drift + temporal drift + ontological drift +
//      institutional drift (Phase 5+ risk: throughput pressure,
//      operational exception normalization, waivers becoming permanent,
//      escalation fatigue, convergence weakening framed as business
//      pragmatism). Cada sub-phase fez gravity check vs P1 e threat
//      class identification vs P7.
//
// =============================================================================
//
// 19 events (8 internal ACL + 11 published economic-consequence)
// 11 commands (intent-named, never execution-named)
// 11 invariants (4 boundary + 4 convergence + 3 epistemic)
// 8 value objects (incluindo ObservedSettlementSnapshot read-only)
// 1 aggregate root (PaymentObligation; lifecycle = EconomicLifecycleState, 9
//   states, 10 transitions)
// 6 domain services (integrity guardians P4)
// 10 policies (6 upstream-signal explicit per ajuste #5 + 4 outras)
// 3 projections (read models last per P6)
//
// Lenses ativadas (5): lens-mechanism-design (primária — convergence as
// canonical mechanism), lens-trust-and-credibility-design (integrity-over-
// throughput), lens-distributed-systems-design (eventual consistency
// cross-BC + epistemic non-collapse), lens-regulatory-compliance-as-
// architecture (reverse settlement upstream-mandated-only), lens-domain-
// language-and-terminology-design (UL preserved via glossary anchors).
//
// Materializado em Phase 3 do WI-043 FCE bootstrap; 3 BC artifacts agora
// completos (canvas + glossary + domain-model). Cascade ordering preservado:
// canvas Phase 1 closed (0ad3302), glossary Phase 2 closed (e85c85b),
// domain-model materializa building blocks DDD ancorados a ambos.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code: "fce"
	name: "Domain Model FCE — Financial Commitment Execution"

	boundedContextRef: "fce"

	// =========================================================================
	// EVENTS — 19 total (8 internal ACL + 11 published economic-consequence)
	// =========================================================================

	events: [
		// === INTERNAL EVENTS (ACL translations de upstream signals) ===
		{
			code:        "evt-budget-availability-observed"
			name:        "BudgetAvailabilityObserved"
			description: "ACL translation de signal BDG indicando availability de budget line. Evento interno FCE; alimenta UpstreamConditionSnapshot em AuthorizationConvergenceSet evaluation."
			rationale:   "FCE observa BDG canonical state via consumed event; nunca queries BDG read-write. Materializa inv-bdy-1 + term-upstream-condition."
			visibility:    "internal"
			sourceContext: "bdg"
			fields: [
				{kind: "primitive", name: "budgetLineRef", type: "string"},
				{kind: "primitive", name: "available", type: "boolean"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-risk-gate-observed"
			name:        "RiskGateObserved"
			description: "ACL translation de signal REW indicando risk gate decision. Alimenta UpstreamConditionSnapshot."
			rationale:   "FCE observa REW risk decision; nunca arbitra risk. Boundary preserved."
			visibility:    "internal"
			sourceContext: "rew"
			fields: [
				{kind: "primitive", name: "riskDecisionId", type: "string"},
				{kind: "primitive", name: "passed", type: "boolean"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-commitment-state-observed"
			name:        "CommitmentStateObserved"
			description: "ACL translation de signal CMT indicando commitment lifecycle state. Alimenta UpstreamConditionSnapshot."
			rationale:   "FCE consome CMT canonical state; nunca authors commitment lifecycle. Boundary preserved per canonical clause."
			visibility:    "internal"
			sourceContext: "cmt"
			fields: [
				{kind: "primitive", name: "commitmentRef", type: "string"},
				{kind: "primitive", name: "state", type: "string"},
				{kind: "primitive", name: "active", type: "boolean"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-evidence-validation-observed"
			name:        "EvidenceValidationObserved"
			description: "ACL translation de signal DLV indicando evidence validation outcome. Alimenta UpstreamConditionSnapshot para authorization + retention release convergence."
			rationale:   "Cross-cutting upstream condition: alimenta dois ConvergenceSets (Authorization + RetentionRelease) per retention type. Materializa mech-evidence anchor canonical."
			visibility:    "internal"
			sourceContext: "dlv"
			fields: [
				{kind: "primitive", name: "evidenceRef", type: "string"},
				{kind: "primitive", name: "validated", type: "boolean"},
				{kind: "primitive", name: "evidenceType", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-invoice-approval-observed"
			name:        "InvoiceApprovalObserved"
			description: "ACL translation de signal INV indicando invoice approval state."
			rationale:   "FCE consome INV canonical state; boundary preserved."
			visibility:    "internal"
			sourceContext: "inv"
			fields: [
				{kind: "primitive", name: "invoiceRef", type: "string"},
				{kind: "primitive", name: "approved", type: "boolean"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-counterparty-qualification-observed"
			name:        "CounterpartyQualificationObserved"
			description: "ACL translation de signal NPM indicando counterparty qualification status."
			rationale:   "FCE consome NPM canonical state; boundary preserved per inv-bdy-1."
			visibility:    "internal"
			sourceContext: "npm"
			fields: [
				{kind: "primitive", name: "counterpartyRef", type: "string"},
				{kind: "primitive", name: "qualified", type: "boolean"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-bkr-settlement-outcome-observed"
			name:        "BkrSettlementOutcomeObserved"
			description: "ACL translation de canonical BKRSettlementOutcome (Succeeded/Failed/Indeterminate). Input para economic interpretation. Anchora term-bkr-settlement-outcome do glossary."
			rationale:   "Boundary crítica FCE↔BKR. Snapshot é embedded em ObservedSettlementSnapshot VO (P3 anti-shadow-ownership framing). FCE não arbitra outcome — apenas consome e interpreta economicamente per inv-bdy-2 + inv-eps-2."
			visibility:    "internal"
			sourceContext: "bkr"
			fields: [
				{kind: "primitive", name: "instructionRef", type: "string"},
				{kind: "primitive", name: "outcomeState", type: "string"},
				{kind: "primitive", name: "bkrEventRef", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-reverse-settlement-mandate-observed"
			name:        "ReverseSettlementMandateObserved"
			description: "ACL translation de upstream mandate para reverse settlement — tipicamente CMT.CommitmentCancelled com retroactive flag, ou upstream process responding to regulatory mandate, ou contractual reverse clause triggered upstream."
			rationale:   "Boundary crítica per inv-bdy-3. Mandate origina upstream; FCE consome e executa. Internal-origin reverse commands rejeitados estructuralmente."
			visibility:    "internal"
			sourceContext: "cmt"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "mandateKind", type: "string"},
				{kind: "primitive", name: "mandateSourceRef", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},

		// === PUBLISHED EVENTS (FCE-originated economic consequence per canonical clause #2) ===
		{
			code:        "evt-authorization-converged"
			name:        "AuthorizationConverged"
			description: "Crystallization of authoritative economic convergence observada — AuthorizationConvergenceSet integralmente satisfeito. FCE-canonical fact distinct from upstream conditions individually."
			rationale:   "Materializa canonical clause #1 (authorization is convergence not decision). Published para downstream que rastreia gravidade de convergence (não para action; ato canonical é PaymentObligationAuthorized adiante)."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "convergenceObservationRef", type: "string"},
				{kind: "primitive", name: "convergedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-authorization-deferred"
			name:        "AuthorizationDeferred"
			description: "Canonical defer-path event quando convergence incompleta within validity window. Per canonical clause #4: FCE defer, jamais accelerate by weakening."
			rationale:   "Defer-path explícito impede silent failure ou silent weakening. Downstream consumers visibility into deferred state — supports reconciliation workflow."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "deferralReason", type: "string"},
				{kind: "primitive", name: "deferredAt", type: "datetime"},
				{kind: "primitive", name: "missingConditions", type: "string"},
			]
		},
		{
			code:        "evt-payment-obligation-authorized"
			name:        "PaymentObligationAuthorized"
			description: "PaymentObligation entered Authorized state. AuthorizationProof emitida + cryptographically bound to instruction payload. Aggregate ready para dispatch."
			rationale:   "Canonical authorization economic event. ATO (accounting), TCM (treasury) consumem para downstream reactions. Per canonical clause #2, este evento é economic consequence — settlement truth separadamente consumível direto de BKR."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "value", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
				{kind: "primitive", name: "authorizedAt", type: "datetime"},
				{kind: "primitive", name: "authorizationProofRef", type: "string"},
			]
		},
		{
			code:        "evt-payment-instruction-dispatched-to-bkr"
			name:        "PaymentInstructionDispatchedToBkr"
			description: "FCE dispatched PaymentInstruction value object para BKR consumption (cross-BC handoff). Explicit naming sinaliza FCE não executa pagamento — FCE dispatches instruction; BKR executes."
			rationale:   "Naming explícito 'DispatchedToBkr' previne interpretação errônea de FCE como executor. Per P5 (naming is architecture): forbidden alternatives Sent/Issued/Processed/Executed would obscure ownership boundary."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "instructionRef", type: "string"},
				{kind: "primitive", name: "dispatchedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-payment-obligation-settled"
			name:        "PaymentObligationSettled"
			description: "Economic interpretation FCE-side de BKRSettlementOutcome.Succeeded. Distinto do BKR settlement fact — FCE produces economic consequence; settlement truth permanece BKR-owned (peer event no BKR outbound)."
			rationale:   "Materializa inv-bdy-4: downstream consumers podem precisar consumir AMBOS — FCE event para economic consequence + BKR event para settlement proof. FCE não é proxy universal do BKR."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "bkrOutcomeRef", type: "string"},
				{kind: "primitive", name: "settledAt", type: "datetime"},
			]
		},
		{
			code:        "evt-payment-obligation-failed"
			name:        "PaymentObligationFailed"
			description: "Economic interpretation FCE-side de BKRSettlementOutcome.Failed. Distinto do BKR settlement fact."
			rationale:   "Mesmo framing de evt-payment-obligation-settled: economic consequence FCE-owned, settlement-side truth BKR-owned (peer event)."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "bkrOutcomeRef", type: "string"},
				{kind: "primitive", name: "failureClassification", type: "string"},
				{kind: "primitive", name: "failedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-payment-pending-final-reconciliation-declared"
			name:        "PaymentPendingFinalReconciliationDeclared"
			description: "Epistemic non-collapse canonical event — FCE declares PaymentObligation entered PendingFinalReconciliation state porque BKR reported Indeterminate. Anchora term-payment-pending-final-reconciliation."
			rationale:   "Per inv-eps-1: incerteza preservada explicitamente. Downstream consumers consume este event para reconciliation workflow triggering — NÃO para collapse-into-success-or-failure inference."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "bkrIndeterminateRef", type: "string"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
			]
		},
		{
			code:        "evt-payment-obligation-cancelled"
			name:        "PaymentObligationCancelled"
			description: "Pre-settlement cancellation FCE-authored. Tipicamente TOCTOU detection ou upstream condition mutated entre observation e dispatch."
			rationale:   "Cancellation pre-settlement é estado terminal canônico (diferente de Reversed pós-settlement upstream-mandated)."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "cancellationReason", type: "string"},
				{kind: "primitive", name: "cancelledAt", type: "datetime"},
			]
		},
		{
			code:        "evt-payment-obligation-reversed"
			name:        "PaymentObligationReversed"
			description: "Post-settlement reverse execution complete — upstream-mandated per inv-bdy-3."
			rationale:   "FCE executes reverse; mandate origin upstream-authoritative. Internal-origin reverse mandates impossível por construção."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "mandateSourceRef", type: "string"},
				{kind: "primitive", name: "reverseInstructionRef", type: "string"},
				{kind: "primitive", name: "reversedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-retention-held"
			name:        "RetentionHeld"
			description: "Retention sub-status declared como held quando PaymentObligation atinge Settled com retention>0. Status retenção é dimensão subordinada de Retention VO; lifecycle principal permanece Settled."
			rationale:   "Per founder Phase 3 ajuste #1: retention não é state principal — é status de VO subordinado. Evento documenta status change sem state machine transition principal."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "heldValue", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
				{kind: "primitive", name: "heldAt", type: "datetime"},
			]
		},
		{
			code:        "evt-retention-released"
			name:        "RetentionReleased"
			description: "Retention status transitioned para released — RetentionReleaseConvergenceSet observed convergir; dispatch de nova PaymentInstruction para released value triggered."
			rationale:   "Sub-status change documented sem state machine transition principal (PaymentObligation permanece Settled). Materializa inv-cvg-4 convergence integrity."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "releasedValue", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
				{kind: "primitive", name: "releaseInstructionRef", type: "string"},
				{kind: "primitive", name: "releasedAt", type: "datetime"},
			]
		},
	]

	// =========================================================================
	// COMMANDS — 11 total
	// =========================================================================

	commands: [
		{
			code:        "cmd-financialize"
			name:        "Financialize"
			description: "Trigger atomic linking dos 4 vínculos (CMT.commitment + BDG.budget-line + REW.risk-decision + PaymentObligation creation) via svc-financialization. All-or-nothing per inv-cvg-2."
			rationale:   "Entry point canônico para crystallization. Coordenado por svc-financialization (integrity guardian P4)."
			fields: [
				{kind: "primitive", name: "commitmentRef", type: "string"},
				{kind: "primitive", name: "budgetLineRef", type: "string"},
				{kind: "primitive", name: "riskDecisionRef", type: "string"},
				{kind: "primitive", name: "invoiceRef", type: "string"},
				{kind: "primitive", name: "value", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
			]
		},
		{
			code:        "cmd-authorize-payment-obligation"
			name:        "AuthorizePaymentObligation"
			description: "Trigger AuthorizationConvergence integrity check via svc-authorization-convergence. Proof emission é efeito interno do service (não é comando primário). Transition lifecycle AuthorizationPending → Authorized somente quando set converge integralmente."
			rationale:   "Per founder Phase 3 ajuste #2: command principal é intent-named (Authorize), não execution-named (EmitProof). Service internally handles proof emission as effect."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
			]
		},
		{
			code:        "cmd-defer-authorization"
			name:        "DeferAuthorization"
			description: "Canonical defer-path quando convergence incomplete within validity window. Per canonical clause #4: defer, never accelerate by weakening."
			rationale:   "Defer-path explícito impede silent weakening sob pressure. Transição AuthorizationPending → AuthorizationDeferred."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "deferralReason", type: "string"},
				{kind: "primitive", name: "missingConditions", type: "string"},
			]
		},
		{
			code:        "cmd-dispatch-payment-instruction"
			name:        "DispatchPaymentInstruction"
			description: "Trigger PrepaymentGuard pre-dispatch checks + dispatch PaymentInstruction para BKR via cross-BC handoff."
			rationale:   "Coordenado por svc-prepayment-guard (integrity guardian P4). Última linha de defesa pre-BKR fronteira; TOCTOU defense + idempotency + cryptographic proof validation."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
			]
		},
		{
			code:        "cmd-process-bkr-settlement-outcome"
			name:        "ProcessBkrSettlementOutcome"
			description: "Trigger economic interpretation de BKR-observed outcome via svc-economic-interpretation. Branches internamente: Succeeded → Settled, Failed → Failed, Indeterminate → PaymentPendingFinalReconciliation."
			rationale:   "Coordenado por svc-economic-interpretation (integrity guardian P4). Epistemic non-collapse preservation enforced via inv-eps-1."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "bkrOutcomeRef", type: "string"},
			]
		},
		{
			code:        "cmd-declare-pending-final-reconciliation"
			name:        "DeclarePendingFinalReconciliation"
			description: "Canonical command emitted quando BKRSettlementOutcome.Indeterminate consumed. Triggers transition InstructionDispatched → PaymentPendingFinalReconciliation."
			rationale:   "Per inv-eps-1: explicit declaration impede silent collapse de Indeterminate. Path canônico para reconciliation workflow upstream."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "bkrIndeterminateRef", type: "string"},
			]
		},
		{
			code:        "cmd-resolve-reconciliation"
			name:        "ResolveReconciliation"
			description: "Triggered quando reconciliation process upstream-authoritative produces determination definitive. resolutionEvidence MUST originate from BKR canonical event, Bacen/rail authoritative query, or supervised reconciliation process upstream — NEVER FCE-local heuristic inference."
			rationale:   "Per inv-eps-2 + inv-bdy-2: FCE jamais infere settlement truth. Resolution path mantém epistemic boundary — FCE applies authoritative external determination, não derives one. Field resolutionSource carrega evidence origin para auditability."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "resolutionSource", type: "string"},
				{kind: "primitive", name: "resolutionEvidenceRef", type: "string"},
				{kind: "primitive", name: "resolvedOutcomeState", type: "string"},
			]
		},
		{
			code:        "cmd-cancel-payment-obligation"
			name:        "CancelPaymentObligation"
			description: "Pre-settlement cancellation FCE-authored. Tipicamente triggered por PrepaymentGuard TOCTOU detection ou upstream condition mutated."
			rationale:   "Pre-settlement terminal state. Distinto de cmd-execute-reverse-settlement (post-settlement upstream-mandated)."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "cancellationReason", type: "string"},
			]
		},
		{
			code:        "cmd-execute-reverse-settlement"
			name:        "ExecuteReverseSettlement"
			description: "Triggered por evt-reverse-settlement-mandate-observed consumed (upstream mandate authoritative). Coordenado por svc-reverse-settlement-execution. Mandate origin upstream MUST be validated; internal-origin rejected."
			rationale:   "Per inv-bdy-3: FCE executa apenas; jamais decide whether reversal is deserved. Internal-origin commands estruturalmente rejected pelo service."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "mandateSourceRef", type: "string"},
				{kind: "primitive", name: "mandateKind", type: "string"},
			]
		},
		{
			code:        "cmd-mark-retention-held"
			name:        "MarkRetentionHeld"
			description: "Mark vo-retention.status = held quando PaymentObligation atinge Settled com retention>0. Internal command; muta retention VO status, não lifecycle state."
			rationale:   "Per founder Phase 3 ajuste #1: retention é sub-status de VO subordinado, não state principal. Comando documenta status change internamente."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
				{kind: "primitive", name: "heldValue", type: "decimal"},
			]
		},
		{
			code:        "cmd-execute-retention-release"
			name:        "ExecuteRetentionRelease"
			description: "Trigger RetentionReleaseConvergenceSet integrity check via svc-retention-release. Convergence integral observed → muta vo-retention.status = released + dispatch nova PaymentInstruction para released value. PaymentObligation lifecycle state permanece Settled."
			rationale:   "Coordenado por svc-retention-release (integrity guardian P4). Per inv-cvg-4: convergence integrity enforced; commercial/temporal pressure jamais override."
			fields: [
				{kind: "primitive", name: "paymentObligationRef", type: "string"},
			]
		},
	]

	// =========================================================================
	// INVARIANTS — 11 total (tripartite: 4 boundary + 4 convergence + 3 epistemic)
	// =========================================================================

	invariants: [
		// === BOUNDARY CLASS (4) ===
		{
			code: "inv-bdy-fce-never-mutates-upstream-truth"
			name: "FCE nunca muta verdade upstream"
			rule: """
				Nenhuma operação interna do FCE pode escrever, modificar,
				ou solicitar modificação sem command/protocol upstream-owned
				de estado canonical em BCs upstream (BDG, REW, CMT, DLV,
				INV, NPM). FCE observa upstream conditions via
				cross-bc-condition-evaluation capability; consome upstream
				events; pode disparar requests legítimos via upstream-owned
				protocol (mas não controla resultado nem escreve diretamente).
				Tentativa estrutural de write direto upstream é violation —
				abort + escalate per ec-condition-weakening-to-accelerate
				adjacent.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Materializa canonical clause 'FCE is downstream-
				authoritative, not upstream-controlling' (canvas Phase 1.4)
				+ term-downstream-authoritative (glossary). Sem esta
				invariant, FCE pode silently writeback upstream para
				'corrigir' conditions não-convergentes — colapso
				epistemological de upstream truth sovereignty.

				Institutional-resistant trait: pressão organizacional para
				FCE 'agilizar' upstream sync é vetor recorrente Phase 5+ —
				esta invariant rejeita estructuralmente write direto, mas
				permite request via protocol upstream-owned (FCE não
				controla resultado).

				Enforcement loci: cross-bc-condition-evaluation capability
				(svc-prepayment-guard adjacent), command authorization
				checks no aggregate, policies que NUNCA emitem write
				commands upstream.
				"""
		},
		{
			code: "inv-bdy-fce-never-arbitrates-settlement-outcome"
			name: "FCE nunca arbitra resultado de liquidação"
			rule: """
				FCE consome BKRSettlementOutcome (Succeeded/Failed/
				Indeterminate) como input canonical para economic
				interpretation. FCE nunca decide o que BKR settlement
				observou; nunca substitui outcome BKR-reported por outcome
				inferido FCE-side; nunca 'corrige' outcome via heurística
				local; nunca infere Succeeded ou Failed a partir de
				evidence circumstantial. Settlement truth é BKR-owned
				single authority. FCE may create economic consequences
				from BKR outcomes, but not alternative settlement
				outcomes.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [epistemic-sensitive,
				ontological-sensitive].

				Materializa canonical clause #2 + term-bkr-settlement-
				outcome (glossary). Drift dominante sem esta invariant é
				FCE 'improving' outcome accuracy via heurística — exactly
				o vetor que destrói single source of truth do BKR e cria
				epistemic collapse de Indeterminate em Succeeded ou
				Failed.

				Distinção crítica: economic consequences (Settled, Failed
				como economic states) são FCE-authored downstream
				interpretation; alternative settlement outcomes (claiming
				rail actually succeeded when BKR said otherwise) são
				forbidden.

				Enforcement loci: svc-economic-interpretation (integrity
				guardian), state machine transitions InstructionDispatched
				→ Settled/Failed (require BKRSettlementOutcome consumption,
				never inference).
				"""
		},
		{
			code: "inv-bdy-reverse-settlement-requires-upstream-mandate"
			name: "Liquidação reversa requer mandate upstream"
			rule: """
				FCE nunca origina ReverseSettlement por decisão interna.
				Toda execução de reverse settlement requer mandate
				upstream-authoritative: CommitmentCancelled (CMT),
				upstream process responding to regulatory mandate
				(compliance authority via upstream BC, não FCE direto),
				contractual reverse provision triggered upstream (CMT
				clause), ou dispute resolution outcome upstream-
				authoritative. FCE recebe mandate como input canonical e
				executa via nova PaymentInstruction com reverse-direction
				flag — jamais decide whether reversal is deserved.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, institutional-resistant,
				ontological-sensitive].

				Materializa bd-reverse-settlement-upstream-mandated-only +
				term-reverse-settlement (glossary). Refinement crítico
				canvas precedence: regulador não autoriza FCE diretamente
				— autoriza upstream process que pode mandate reverse;
				FCE consome o mandate canonicalmente. Sem esta invariant,
				FCE pode aparentar authority 'self-deciding' reversals.

				Institutional-resistant trait: pressão organizacional para
				FCE 'act fast on fraud' é vetor recorrente Phase 5+ —
				resposta canônica é escalate to CMT/regulatory para gerar
				mandate upstream, não originate FCE-internal.

				Enforcement loci: svc-reverse-settlement-execution
				(integrity guardian — origin validation gate), aggregate
				command handlers (reject internal-origin reverse commands).
				"""
		},
		{
			code: "inv-bdy-economic-interpretation-not-settlement-truth"
			name: "Interpretação econômica não é verdade settlement"
			rule: """
				Eventos FCE outbound (PaymentObligationSettled,
				PaymentObligationCancelled, RetentionReleased,
				PaymentObligationReversed) expressam economic
				interpretation FCE-side de canonical settlement outcomes
				observados, não settlement execution truth itself.
				Downstream consumers (ATO, CRM, TCM) may need to consume
				both — FCE para economic consequence + BKR para settlement
				proof. FCE não canoniza settlement truth em seu próprio
				outbound layer; não é proxy universal do BKR.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [epistemic-sensitive,
				ontological-sensitive, structural].

				Materializa canonical clause #2 + term-economic-
				interpretation (glossary). Refinement crítico: previne
				FCE virar proxy universal do BKR — downstream consumers
				responsáveis por consumir each event canonical para sua
				purpose (economic consequence vs settlement proof).

				Enforcement loci: outbound event emission service (event
				naming conventions P5 forbidden names enforced),
				published events visibility check tq-dm-11 canvas
				alignment.
				"""
		},

		// === CONVERGENCE CLASS (4) ===
		{
			code: "inv-cvg-authorization-requires-full-convergence"
			name: "Autorização requer convergência integral"
			rule: """
				AuthorizationProof só pode ser emitida quando
				AuthorizationConvergenceSet converge integralmente —
				todos N upstream conditions satisfied simultaneamente
				dentro de validity windows respectivos. Convergência
				parcial (N-1 de N) NÃO produz authorization. Nenhuma
				condition pode ser substituída por proxy mais permissivo;
				nenhum threshold pode ser relaxado para acelerar; nenhum
				bypass condicional é admissível. Detection de attempt é
				ec-condition-weakening-to-accelerate.
				"""
			rationale: """
				Primary class: CONVERGENCE.
				Secondary traits: [atomic, ontological-sensitive,
				institutional-resistant].

				Materializa canonical clause #1 ('authorization is
				convergence not decision') + canonical clause #4 (defer
				never weaken) + term-authorization-convergence (glossary).
				Sem esta invariant, FCE pode emitir authorization sob
				convergência parcial — vetor primário que destrói
				epistemic posture do BC.

				Institutional-resistant trait: pressão operacional para
				'just authorize this one' sob deadline é vetor recorrente
				Phase 5+.

				Enforcement loci: svc-authorization-convergence (integrity
				guardian), state machine transition AuthorizationPending
				→ Authorized.
				"""
		},
		{
			code: "inv-cvg-no-partial-financialization"
			name: "Financialização não pode ser parcial"
			rule: """
				FinancializationService coordena 4 vínculos como unidade
				transacional: link CMT.commitment, reserve BDG.budget-line,
				freeze REW.risk-decision, create PaymentObligation. Falha
				em qualquer um dos 4 aborta integralmente — reverte
				budget reservation, reverte commitment link, libera risk
				freeze, não cria PaymentObligation. Estado intermediário
				partial-linked é forbidden por construção; sistema retorna
				a estado pre-attempt indistinguível.
				"""
			rationale: """
				Primary class: CONVERGENCE.
				Secondary traits: [atomic, structural].

				Materializa bd-financialization-is-atomic (canvas Phase
				1.3) — a #1 business decision do BC. Sem esta invariant,
				FCE pode terminar em estado financeiro inconsistente
				(budget consumed sem obligation, obligation born sem
				budget link, risk frozen sem commitment) — qualquer
				parcialidade quebra audit trail.

				Structural trait: atomicidade é propriedade arquitetural
				do service, não policy operacional negociável.

				Enforcement loci: svc-financialization (integrity guardian
				P4 — protects atomicity, not execution continuity;
				fail/escalate, never partial-recover).
				"""
		},
		{
			code: "inv-cvg-no-stale-eligibility-beyond-threshold"
			name: "Elegibilidade vencida não é re-validável"
			rule: """
				UpstreamCondition snapshots observados durante convergence
				evaluation carregam timestamps de observação + validity
				windows canonical per condition type. PrepaymentGuard
				rejeita dispatch se qualquer snapshot in AuthorizationProof
				excede staleness threshold no momento de pre-dispatch.
				Stale snapshots NÃO podem ser 'extended' por FCE
				inference, 'refreshed' por heurística local, ou 'accepted
				with caveat' — devem ser re-observed via fresh
				cross-bc-condition-evaluation antes de re-attempt
				authorization.
				"""
			rationale: """
				Primary class: CONVERGENCE.
				Secondary traits: [temporal, epistemic-sensitive,
				boundary-sensitive].

				Materializa propriedade temporal de convergence + term-
				prepayment-guard (TOCTOU window defense). Sem esta
				invariant, FCE pode dispatch PaymentInstruction baseado
				em conditions modificadas upstream entre observation e
				dispatch — race condition que produces dispatch sob estado
				upstream inconsistente.

				Temporal trait: invariant é fundamentalmente sobre
				time-bound validity. Boundary-sensitive: re-validation
				requer re-observation upstream, não FCE-internal refresh.

				Enforcement loci: svc-prepayment-guard (integrity guardian),
				vo-validity-window, state machine transition Authorized →
				InstructionDispatched.
				"""
		},
		{
			code: "inv-cvg-retention-release-requires-full-operational-convergence"
			name: "Liberação de retenção requer convergência operacional integral"
			rule: """
				Retention release só pode ser executada quando
				RetentionReleaseConvergenceSet converge integralmente —
				todos operational truth conditions (DLV evidence, CMT
				milestone signals, outras per retention type) satisfied
				simultaneamente. Convergência parcial NÃO libera retention.
				Pressão comercial ('goodwill release'), pressão temporal
				('counterparty deadline'), ou substituição de operational
				condition por proxy mais permissivo são todos
				ec-condition-weakening-to-accelerate hits — abort +
				escalate, nunca silently allow.
				"""
			rationale: """
				Primary class: CONVERGENCE.
				Secondary traits: [atomic, institutional-resistant,
				boundary-sensitive].

				Materializa bd-retention-release-conditional-on-operational-
				truth + term-retention-release + term-retention-release-
				convergence-set (glossary). Sem esta invariant, retention
				release vira ato discricionário sob policy variável — vetor
				que destrói materialização local de mech-evidence.

				Institutional-resistant trait: pressão comercial para
				'goodwill release' é vetor recorrente Phase 5+ —
				especialmente perigoso porque framing é benigno
				('relationship preservation').

				Enforcement loci: svc-retention-release (integrity guardian
				P4), vo-retention-release-convergence-set.
				"""
		},

		// === EPISTEMIC CLASS (3) ===
		{
			code: "inv-eps-indeterminate-must-not-collapse"
			name: "Indeterminate não pode colapsar em Settled ou Failed"
			rule: """
				Quando FCE consome BKRSettlementOutcome.Indeterminate
				(rail outcome ambíguo, irreconcilable dentro do SLA
				imediato), PaymentObligation MUST transition para estado
				canônico PaymentPendingFinalReconciliation —
				explicitamente epistemic-preserving. FCE NÃO pode inferir
				Succeeded por confidence operacional, NÃO pode inferir
				Failed por timeout heuristic, NÃO pode colapsar incerteza
				em certainty via 'best-effort assumption'. Resolution
				exige reconciliation process upstream-authoritative
				(Bacen ledger query, rail direct query, supervised
				reconciliation), nunca FCE-internal inference.
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [temporal, ontological-sensitive,
				institutional-resistant].

				Materializa term-payment-pending-final-reconciliation +
				canonical epistemic non-collapse property. Founder Phase
				2.1 explicit: 'protege epistemic non-collapse no lado
				econômico do FCE'. Sem esta invariant, drift dominante é
				optimistic collapse (assume Succeeded) ou pessimistic
				collapse (assume Failed) — qualquer dos dois produz state
				que pode contradizer física.

				Institutional-resistant trait: pressão operacional para
				'just decide already, customer is waiting' é vetor
				recorrente Phase 5+.

				Enforcement loci: svc-economic-interpretation (integrity
				guardian — produces PendingFinalReconciliation transition
				para Indeterminate input, never bypass), state machine
				transition InstructionDispatched → {Settled|Failed|
				PendingFinalReconciliation}.
				"""
		},
		{
			code: "inv-eps-no-inferred-settlement-truth"
			name: "Verdade settlement não pode ser inferida FCE-side"
			rule: """
				FCE jamais infere settlement truth a partir de evidence
				circumstantial: timeout, partial ack, sibling-payment
				success, historical pattern matching, ou heurística local.
				Settlement truth canonical chega exclusivamente via
				BKRSettlementOutcome consumido como evento canonical
				BKR-published. Hipóteses internas FCE sobre 'provavelmente
				settled' ou 'provavelmente failed' não produzem state
				transition; produzem nada — sistema permanece em estado
				anterior até evidence canônica chegue ou
				PaymentPendingFinalReconciliation seja triggered por
				BKR-published Indeterminate.
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [boundary-sensitive,
				ontological-sensitive].

				Materializa canonical clause #2 + inv-bdy-2 cross-class
				reinforcement. Esta invariant é epistemic-specific
				complement: inv-bdy-2 proíbe arbitragem; inv-eps-2 proíbe
				inferência (forma sutil de arbitragem disfarçada). Sem
				esta invariant, FCE 'helpful inference' vira shadow
				authority sobre settlement.

				Enforcement loci: svc-economic-interpretation (explicit
				refusal of inference paths), state machine transitions
				InstructionDispatched → terminal states (guards reference
				BKRSettlementOutcome consumption only).
				"""
		},
		{
			code: "inv-eps-no-proxy-substitution-for-condition"
			name: "Proxy substitution proibida em UpstreamCondition"
			rule: """
				UpstreamCondition em AuthorizationConvergenceSet ou
				RetentionReleaseConvergenceSet jamais pode ser substituída
				por condition diferente classificada como 'proxy
				razoável'. Exemplos forbidden: DLV.evidence-uploaded como
				proxy para DLV.evidence-validated; CMT.commitment-recorded
				como proxy para CMT.commitment-active; REW.risk-historical-
				low como proxy para REW.risk-gate-passed. Cada condition
				tem semantic owner upstream cuja determination é única
				authority — proxy substitution é silent boundary
				violation + ec-condition-weakening-to-accelerate.
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [boundary-sensitive, structural,
				institutional-resistant].

				Materializa canonical clause #4 + term-condition-weakening
				(glossary). Subtler form de condition weakening é proxy
				substitution disfarçada como 'reasonable approximation'.
				Sem esta invariant, drift gradual via accumulating proxies
				é institutional-level vector ('this proxy worked 99% of
				cases historically').

				Cross-class reinforcement: estructural-similar a inv-bdy-1
				(no upstream mutation) — esta é epistemic specialization
				(no upstream semantic substitution).

				Enforcement loci: svc-authorization-convergence (strict
				semantic identity check per condition), svc-retention-
				release (same check para retention path).
				"""
		},
	]

	// =========================================================================
	// VALUE OBJECTS — 8 total
	// =========================================================================

	valueObjects: [
		{
			code:        "vo-authorization-convergence-set"
			name:        "AuthorizationConvergenceSet"
			description: "Conjunto canônico finito fechado de UpstreamConditions cuja convergência integral autoriza crystallization. Predeclared at design-time per payment obligation type — não improvisado per case."
			fields: [
				{kind: "primitive", name: "setType", type: "string"},
				{kind: "domain-type", name: "requiredConditions", type: "UpstreamConditionSnapshotList"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
				{kind: "primitive", name: "schemaVersion", type: "string"},
			]
			rationale: "Anchora term-authorization-convergence-set (glossary); protege inv-cvg-1 via predeclared property; protege contra ec-convergence-boundary-erosion via schemaVersion tracking. Mutação do set é decisão de design FCE separada de processamento de convergência."
		},
		{
			code:        "vo-authorization-proof"
			name:        "AuthorizationProof"
			description: "Value FCE-originated evidenciando convergência observada com cryptographic binding ao PaymentInstruction payload. Cross-BC peer: BKR glossary term-authorization-proof define lens consumer."
			fields: [
				{kind: "domain-type", name: "signature", type: "Signature"},
				{kind: "primitive", name: "nonce", type: "string"},
				{kind: "primitive", name: "issuedAt", type: "datetime"},
				{kind: "value-object-ref", name: "validityWindow", valueObjectRef: "vo-validity-window"},
				{kind: "primitive", name: "convergenceObservationRef", type: "string"},
				{kind: "primitive", name: "claimChain", type: "string"},
			]
			rationale: "Anchora term-authorization-proof (glossary); cryptographic binding semantic: mutação de payload invalida signature por construção. Per-instruction single-use; não reutilizável entre instructions."
		},
		{
			code:        "vo-retention-release-convergence-set"
			name:        "RetentionReleaseConvergenceSet"
			description: "Conjunto canônico operational truth-heavy para retention release. Análogo estrutural a AuthorizationConvergenceSet mas com composition diferente (operational vs financial)."
			fields: [
				{kind: "primitive", name: "retentionType", type: "string"},
				{kind: "domain-type", name: "requiredOperationalConditions", type: "UpstreamConditionSnapshotList"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
				{kind: "primitive", name: "schemaVersion", type: "string"},
			]
			rationale: "Anchora term-retention-release-convergence-set (glossary); protege inv-cvg-4 via predeclared property. Composition operational-heavy (DLV evidence + CMT milestones) — diferente de AuthorizationConvergenceSet (financial+operational mix)."
		},
		{
			code:        "vo-upstream-condition-snapshot"
			name:        "UpstreamConditionSnapshot"
			description: "Snapshot imutável de single UpstreamCondition observed at convergence evaluation. Carries semantic owner + observation timestamp para staleness check."
			fields: [
				{kind: "primitive", name: "semanticOwner", type: "string"},
				{kind: "primitive", name: "conditionName", type: "string"},
				{kind: "primitive", name: "satisfied", type: "boolean"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
				{kind: "value-object-ref", name: "validityWindow", valueObjectRef: "vo-validity-window"},
				{kind: "primitive", name: "metadata", type: "string"},
			]
			rationale: "Anchora term-upstream-condition (glossary); protege inv-cvg-3 (staleness check) + inv-eps-3 (no proxy substitution — semanticOwner + conditionName são identity). semanticOwner enumerable: bdg|rew|cmt|dlv|inv|npm."
		},
		{
			code:        "vo-observed-settlement-snapshot"
			name:        "ObservedSettlementSnapshot"
			description: "Imported truth snapshot of BKR settlement state, embedded read-only no aggregate FCE. Naming 'Observed' + 'Snapshot' sinaliza imported truth — anti-shadow-ownership framing P3."
			fields: [
				{kind: "primitive", name: "observedState", type: "string"},
				{kind: "primitive", name: "bkrEventRef", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
				{kind: "primitive", name: "rawOutcomeMetadata", type: "string"},
			]
			rationale: "Materializa P3 refinement: settlement observation é imported truth structured como VO read-only, NÃO lifecycle FCE-owned. observedState enumerable: Pending|Dispatching|Succeeded|Failed|Indeterminate|AwaitingReconciliation. Muta apenas via cmd-process-bkr-settlement-outcome (substituição integral)."
		},
		{
			code:        "vo-payment-instruction-payload"
			name:        "PaymentInstructionPayload"
			description: "Value cross-BC FCE-originated representando intent autorizado cristalizado para BKR consume. Após emission, immutable from FCE side."
			fields: [
				{kind: "primitive", name: "instructionId", type: "string"},
				{kind: "primitive", name: "payer", type: "string"},
				{kind: "primitive", name: "payee", type: "string"},
				{kind: "primitive", name: "value", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
				{kind: "primitive", name: "railHint", type: "string"},
				{kind: "value-object-ref", name: "authorizationProof", valueObjectRef: "vo-authorization-proof"},
				{kind: "value-object-ref", name: "validityWindow", valueObjectRef: "vo-validity-window"},
				{kind: "primitive", name: "reverseDirection", type: "boolean"},
			]
			rationale: "Anchora term-payment-instruction (glossary); cross-BC peer com BKR glossary consumer lens. reverseDirection flag para reverse settlement execution."
		},
		{
			code:        "vo-validity-window"
			name:        "ValidityWindow"
			description: "Time-bound window definindo when observation/proof é canonical-valid. Reused em AuthorizationProof + UpstreamConditionSnapshot + PaymentInstructionPayload."
			fields: [
				{kind: "primitive", name: "issuedAt", type: "datetime"},
				{kind: "primitive", name: "expiresAt", type: "datetime"},
				{kind: "primitive", name: "windowKind", type: "string"},
			]
			rationale: "Suporta inv-cvg-3 staleness enforcement transversalmente. windowKind enumerable: authorization|condition-observation|instruction-dispatch."
		},
		{
			code:        "vo-retention"
			name:        "Retention"
			description: "Value FCE-internal representando parcela financeira held condicionalmente. Status enumerable como sub-dimension; lifecycle principal de PaymentObligation NÃO transita por retention states."
			fields: [
				{kind: "primitive", name: "heldValue", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
				{kind: "value-object-ref", name: "convergenceSet", valueObjectRef: "vo-retention-release-convergence-set"},
				{kind: "primitive", name: "status", type: "string"},
				{kind: "primitive", name: "heldSince", type: "datetime"},
			]
			rationale: "Anchora term-retention (glossary); materializa mech-evidence localmente. status enumerable: none|held|released|blocked. Per founder Phase 3 ajuste #1: retention é dimensão subordinada de PaymentObligation, não state principal — lifecycle permanece Settled enquanto retention.status varia."
		},
	]

	// =========================================================================
	// AGGREGATES — 1 (PaymentObligation single root)
	// =========================================================================

	aggregates: [
		{
			code:        "agg-payment-obligation"
			name:        "PaymentObligation"
			description: "Aggregate root central FCE. Carrega lifecycle de obrigação econômica desde authorization até reconciliação final. ObservedSettlementSnapshot embedded read-only (anti-shadow-ownership P3). Retention modelada como VO embedded (sub-dimension)."

			rootIdentity: {
				field: "paymentObligationId"
				type: {kind: "primitive", type: "string"}
			}

			fields: [
				{kind: "primitive", name: "value", type: "decimal"},
				{kind: "primitive", name: "currency", type: "string"},
				{kind: "primitive", name: "commitmentRef", type: "string"},
				{kind: "primitive", name: "invoiceRef", type: "string"},
				{kind: "primitive", name: "budgetLineRef", type: "string"},
				{kind: "primitive", name: "riskDecisionRef", type: "string"},
				{kind: "value-object-ref", name: "authorizationConvergenceSet", valueObjectRef: "vo-authorization-convergence-set"},
				{kind: "value-object-ref", name: "authorizationProof", valueObjectRef: "vo-authorization-proof"},
				{kind: "value-object-ref", name: "observedSettlement", valueObjectRef: "vo-observed-settlement-snapshot"},
				{kind: "value-object-ref", name: "retention", valueObjectRef: "vo-retention"},
				{kind: "primitive", name: "authorizedAt", type: "datetime"},
				{kind: "primitive", name: "lastInstructionRef", type: "string"},
			]

			usesValueObjects: [
				"vo-authorization-convergence-set",
				"vo-authorization-proof",
				"vo-retention-release-convergence-set",
				"vo-upstream-condition-snapshot",
				"vo-observed-settlement-snapshot",
				"vo-payment-instruction-payload",
				"vo-validity-window",
				"vo-retention",
			]

			handlesCommands: [
				"cmd-financialize",
				"cmd-authorize-payment-obligation",
				"cmd-defer-authorization",
				"cmd-dispatch-payment-instruction",
				"cmd-process-bkr-settlement-outcome",
				"cmd-declare-pending-final-reconciliation",
				"cmd-resolve-reconciliation",
				"cmd-cancel-payment-obligation",
				"cmd-execute-reverse-settlement",
				"cmd-mark-retention-held",
				"cmd-execute-retention-release",
			]

			emitsEvents: [
				"evt-authorization-converged",
				"evt-authorization-deferred",
				"evt-payment-obligation-authorized",
				"evt-payment-instruction-dispatched-to-bkr",
				"evt-payment-obligation-settled",
				"evt-payment-obligation-failed",
				"evt-payment-pending-final-reconciliation-declared",
				"evt-payment-obligation-cancelled",
				"evt-payment-obligation-reversed",
				"evt-retention-held",
				"evt-retention-released",
			]

			protectsInvariants: [
				"inv-bdy-fce-never-mutates-upstream-truth",
				"inv-bdy-fce-never-arbitrates-settlement-outcome",
				"inv-bdy-reverse-settlement-requires-upstream-mandate",
				"inv-bdy-economic-interpretation-not-settlement-truth",
				"inv-cvg-authorization-requires-full-convergence",
				"inv-cvg-no-partial-financialization",
				"inv-cvg-no-stale-eligibility-beyond-threshold",
				"inv-cvg-retention-release-requires-full-operational-convergence",
				"inv-eps-indeterminate-must-not-collapse",
				"inv-eps-no-inferred-settlement-truth",
				"inv-eps-no-proxy-substitution-for-condition",
			]

			lifecycle: {
				initialState: "AuthorizationPending"
				states: [
					"AuthorizationPending",
					"AuthorizationDeferred",
					"Authorized",
					"InstructionDispatched",
					"Settled",
					"Failed",
					"PaymentPendingFinalReconciliation",
					"Cancelled",
					"Reversed",
				]
				transitions: [
					{
						from:               "AuthorizationPending"
						to:                 "Authorized"
						triggeredByCommand: "cmd-authorize-payment-obligation"
						emitsEvents: [
							"evt-authorization-converged",
							"evt-payment-obligation-authorized",
						]
						guards: [
							"inv-cvg-authorization-requires-full-convergence",
							"inv-cvg-no-partial-financialization",
							"inv-cvg-no-stale-eligibility-beyond-threshold",
							"inv-eps-no-proxy-substitution-for-condition",
							"inv-bdy-fce-never-mutates-upstream-truth",
						]
						description: "Crystallization complete; AuthorizationProof emitida por svc-authorization-convergence como efeito interno."
					},
					{
						from:               "AuthorizationPending"
						to:                 "AuthorizationDeferred"
						triggeredByCommand: "cmd-defer-authorization"
						emitsEvents:        ["evt-authorization-deferred"]
						guards: ["inv-cvg-authorization-requires-full-convergence"]
						description: "Defer-path canonical per clause #4 — convergence incomplete within window."
					},
					{
						from:               "Authorized"
						to:                 "InstructionDispatched"
						triggeredByCommand: "cmd-dispatch-payment-instruction"
						emitsEvents:        ["evt-payment-instruction-dispatched-to-bkr"]
						guards: [
							"inv-cvg-no-stale-eligibility-beyond-threshold",
							"inv-bdy-fce-never-mutates-upstream-truth",
						]
						description: "PrepaymentGuard pre-dispatch checks passed; instruction dispatched para BKR consumption."
					},
					{
						from:               "Authorized"
						to:                 "Cancelled"
						triggeredByCommand: "cmd-cancel-payment-obligation"
						emitsEvents:        ["evt-payment-obligation-cancelled"]
						guards: ["inv-bdy-reverse-settlement-requires-upstream-mandate"]
						description: "Pre-settlement cancellation FCE-authored (TOCTOU detection ou upstream mutation)."
					},
					{
						from:               "InstructionDispatched"
						to:                 "Settled"
						triggeredByCommand: "cmd-process-bkr-settlement-outcome"
						emitsEvents:        ["evt-payment-obligation-settled"]
						guards: [
							"inv-eps-no-inferred-settlement-truth",
							"inv-bdy-fce-never-arbitrates-settlement-outcome",
							"inv-bdy-economic-interpretation-not-settlement-truth",
						]
						description: "Economic interpretation FCE-side de BKRSettlementOutcome.Succeeded."
					},
					{
						from:               "InstructionDispatched"
						to:                 "Failed"
						triggeredByCommand: "cmd-process-bkr-settlement-outcome"
						emitsEvents:        ["evt-payment-obligation-failed"]
						guards: [
							"inv-eps-no-inferred-settlement-truth",
							"inv-bdy-fce-never-arbitrates-settlement-outcome",
						]
						description: "Economic interpretation FCE-side de BKRSettlementOutcome.Failed."
					},
					{
						from:               "InstructionDispatched"
						to:                 "PaymentPendingFinalReconciliation"
						triggeredByCommand: "cmd-declare-pending-final-reconciliation"
						emitsEvents:        ["evt-payment-pending-final-reconciliation-declared"]
						guards: ["inv-eps-indeterminate-must-not-collapse"]
						description: "Epistemic non-collapse path canonical — BKR Indeterminate consumed; no inference."
					},
					{
						from:               "PaymentPendingFinalReconciliation"
						to:                 "Settled"
						triggeredByCommand: "cmd-resolve-reconciliation"
						emitsEvents:        ["evt-payment-obligation-settled"]
						guards: ["inv-eps-no-inferred-settlement-truth"]
						description: "Reconciliation resolved authoritatively (BKR canonical event, Bacen/rail query, supervised reconciliation) — FCE applies external determination."
					},
					{
						from:               "PaymentPendingFinalReconciliation"
						to:                 "Failed"
						triggeredByCommand: "cmd-resolve-reconciliation"
						emitsEvents:        ["evt-payment-obligation-failed"]
						guards: ["inv-eps-no-inferred-settlement-truth"]
						description: "Reconciliation resolved authoritatively como failure — FCE applies external determination."
					},
					{
						from:               "Settled"
						to:                 "Reversed"
						triggeredByCommand: "cmd-execute-reverse-settlement"
						emitsEvents:        ["evt-payment-obligation-reversed"]
						guards: ["inv-bdy-reverse-settlement-requires-upstream-mandate"]
						description: "Post-settlement reverse execution upstream-mandated — never FCE-internal-origin."
					},
				]
			}

			consistencyBoundary: {
				guarantees: [
					"Atomicidade transacional intra-aggregate: financialization (4 vínculos) succeeds ou rollback completo.",
					"Lifecycle state machine: transitions FCE-authored apenas sob guards canonical satisfied.",
					"Retention sub-status mutations intra-aggregate: vo-retention.status modificável apenas via cmd-mark-retention-held + cmd-execute-retention-release com convergence integrity.",
				]
				explicitlyDoesNotGuarantee: [
					"Cross-BC consistency com BKR settlement state em tempo real — eventual via consumed BKRSettlementOutcome events.",
					"Cross-BC consistency com upstream BCs (BDG, REW, CMT, DLV, INV, NPM) em tempo real — eventual via consumed events.",
					"Idempotência de PaymentInstruction execution rail-side — responsability cross-BC (BKR-owned).",
				]
				failureModes: [
					"Financialization partial failure: rollback automático completo + emit failure event downstream.",
					"AuthorizationConvergence incomplete: defer path explicit (não silent ignore).",
					"BKR Indeterminate consumption: transition para PaymentPendingFinalReconciliation (never collapse).",
					"TOCTOU mutation entre observation e dispatch: PrepaymentGuard aborts + emit cancellation.",
				]
				rationale: "Per adr-081: consistency boundary intra-aggregate é atomic; cross-aggregate + cross-BC é eventual via events. failureModes documentados explicitly — sem isso, consistency é promessa falsa."
			}

			rationale: """
				Single aggregate root do BC FCE. Aggregate é consequência
				arquitetural de invariantes (11 tripartite) + state machine
				(EconomicLifecycleState 9 states) + value objects (8) +
				services (6 integrity guardians) — não estrutura primária
				per P6.

				Single-aggregate decision: PaymentObligation centraliza
				todos building blocks porque transaction boundaries do BC
				convergem ao seu lifecycle. Retention modelada como VO
				embedded (vo-retention) com status field — NÃO entity
				separada nem state machine principal (per founder Phase 3
				ajuste #1).

				ObservedSettlementSnapshot (vo-observed-settlement-
				snapshot) é embedded read-only — anti-shadow-ownership
				framing P3. Estado settlement BKR-owned permanece
				imported truth dentro do aggregate FCE; muta apenas via
				cmd-process-bkr-settlement-outcome (substituição integral
				de snapshot).

				Lifecycle 9 states cobertura: AuthorizationPending
				(initial), AuthorizationDeferred (defer path), Authorized
				(crystallized), InstructionDispatched (dispatched to BKR),
				Settled / Failed (economic interpretations),
				PaymentPendingFinalReconciliation (epistemic non-collapse),
				Cancelled (pre-settlement), Reversed (post-settlement
				upstream-mandated). 10 transitions com guards canonical
				per invariants tripartite.
				"""
		},
	]

	// =========================================================================
	// DOMAIN SERVICES — 6 (integrity guardians per P4)
	// =========================================================================

	domainServices: [
		{
			code:        "svc-financialization"
			name:        "FinancializationService"
			description: "Integrity guardian de atomicidade. Coordena 4 vínculos como unidade transacional (CMT.commitment + BDG.budget-line + REW.risk-decision + PaymentObligation creation). Falha → rollback completo + escalate; jamais partial-recover ou retry-degrade."
			orchestrates: ["agg-payment-obligation"]
			rationale:    "Cap canvas cap-financialization-service. Integrity guardian P4: protege semantic invariant (atomicity), não execution continuity. Materializa inv-cvg-2."
		},
		{
			code:        "svc-authorization-convergence"
			name:        "AuthorizationConvergenceService"
			description: "Integrity guardian de convergence integrity. Observa AuthorizationConvergenceSet completeness; valida semantic identity per condition (no proxy substitution); checks staleness threshold; emite AuthorizationProof somente sob convergência integral + non-stale + non-proxied. Falha → defer (cmd-defer-authorization), nunca weaken."
			orchestrates: ["agg-payment-obligation"]
			rationale:    "Materializa canonical clause #1 operacionalmente. Integrity guardian P4 protege inv-cvg-1 + inv-cvg-3 + inv-eps-3. Proof emission é efeito interno; comando primário é cmd-authorize-payment-obligation (intent-named per founder Phase 3 ajuste #2)."
		},
		{
			code:        "svc-prepayment-guard"
			name:        "PrepaymentGuardService"
			description: "Integrity guardian de TOCTOU defense pre-dispatch. Re-checks upstream snapshot consistency + AuthorizationProof validity + idempotency-key não-usado + evidence-binding intact. Falha → abort dispatch + emit cancellation event."
			orchestrates: ["agg-payment-obligation"]
			rationale:    "Cap canvas cap-prepayment-guard-service. Última linha de defesa pre-BKR fronteira; protege inv-cvg-3 + inv-bdy-1 + mech-evidence local materialization. Integrity guardian P4."
		},
		{
			code:        "svc-economic-interpretation"
			name:        "EconomicInterpretationService"
			description: "Integrity guardian de epistemic non-collapse. Translation BKR outcome → FCE economic state: Succeeded → Settled, Failed → Failed, Indeterminate → PaymentPendingFinalReconciliation. Inference paths explicitly refused; collapse de uncertainty impossível por construção."
			orchestrates: ["agg-payment-obligation"]
			rationale:    "Cap canvas cap-payment-outcome-routing. Materializa canonical clause #2 operacionalmente. Protege inv-eps-1 + inv-eps-2 + inv-bdy-2 + inv-bdy-4. Integrity guardian P4."
		},
		{
			code:        "svc-retention-release"
			name:        "RetentionReleaseService"
			description: "Integrity guardian de retention release convergence integrity. Observa RetentionReleaseConvergenceSet operational truth conditions; libera retention apenas sob convergência integral. Commercial pressure, temporal pressure, proxy substitution todos rejeitados estructuralmente."
			orchestrates: ["agg-payment-obligation"]
			rationale:    "Cap canvas cap-retention-release-conditional. Materializa bd-retention-release-conditional-on-operational-truth operacionalmente. Protege inv-cvg-4. Integrity guardian P4 — integrity over execution continuity."
		},
		{
			code:        "svc-reverse-settlement-execution"
			name:        "ReverseSettlementExecutionService"
			description: "Integrity guardian de upstream mandate origin validation. Validates upstream mandate authenticity antes de executar reverse PaymentInstruction. Internal-origin reverse commands rejected estructuralmente; FCE internal operators must escalate para upstream-mandate-generation pathway."
			orchestrates: ["agg-payment-obligation"]
			rationale:    "Materializa bd-reverse-settlement-upstream-mandated-only operacionalmente. Protege inv-bdy-3. Integrity guardian P4: rejeita internal-origin estruturalmente, não 'best-effort'."
		},
	]

	// =========================================================================
	// POLICIES — 10 (6 upstream-signal explicit per founder ajuste #5 + 4 outras)
	// =========================================================================

	policies: [
		// === 6 upstream-signal policies (authorization convergence evaluation) ===
		{
			code:        "pol-on-budget-availability-evaluate-authorization-convergence"
			name:        "OnBudgetAvailabilityEvaluateAuthorizationConvergence"
			description: "Quando BDG signal observed, trigger authorization convergence re-evaluation."
			triggeredByEvent: "evt-budget-availability-observed"
			issuesCommand:    "cmd-authorize-payment-obligation"
			guards: ["inv-cvg-authorization-requires-full-convergence"]
			rationale: "BDG é uma das 6 upstream conditions. Convergence re-evaluation invoked; emit proof somente se ALL conditions satisfied (não apenas BDG)."
		},
		{
			code:        "pol-on-risk-gate-evaluate-authorization-convergence"
			name:        "OnRiskGateEvaluateAuthorizationConvergence"
			description: "Quando REW signal observed, trigger authorization convergence re-evaluation."
			triggeredByEvent: "evt-risk-gate-observed"
			issuesCommand:    "cmd-authorize-payment-obligation"
			guards: ["inv-cvg-authorization-requires-full-convergence"]
			rationale: "REW risk decision é condition crítica. Re-evaluation invoked; convergence integrity enforced."
		},
		{
			code:        "pol-on-commitment-state-evaluate-authorization-convergence"
			name:        "OnCommitmentStateEvaluateAuthorizationConvergence"
			description: "Quando CMT signal observed, trigger authorization convergence re-evaluation."
			triggeredByEvent: "evt-commitment-state-observed"
			issuesCommand:    "cmd-authorize-payment-obligation"
			guards: ["inv-cvg-authorization-requires-full-convergence"]
			rationale: "CMT commitment active state required. Re-evaluation invoked under convergence integrity."
		},
		{
			code:        "pol-on-evidence-validation-evaluate-authorization-convergence"
			name:        "OnEvidenceValidationEvaluateAuthorizationConvergence"
			description: "Quando DLV signal observed, trigger authorization convergence re-evaluation."
			triggeredByEvent: "evt-evidence-validation-observed"
			issuesCommand:    "cmd-authorize-payment-obligation"
			guards: ["inv-cvg-authorization-requires-full-convergence"]
			rationale: "DLV evidence é dual-purpose: alimenta authorization E retention release. Esta policy é authorization path; retention path tem policy separada."
		},
		{
			code:        "pol-on-invoice-approval-evaluate-authorization-convergence"
			name:        "OnInvoiceApprovalEvaluateAuthorizationConvergence"
			description: "Quando INV signal observed, trigger authorization convergence re-evaluation."
			triggeredByEvent: "evt-invoice-approval-observed"
			issuesCommand:    "cmd-authorize-payment-obligation"
			guards: ["inv-cvg-authorization-requires-full-convergence"]
			rationale: "INV invoice approval é condition canonical no set típico."
		},
		{
			code:        "pol-on-counterparty-qualification-evaluate-authorization-convergence"
			name:        "OnCounterpartyQualificationEvaluateAuthorizationConvergence"
			description: "Quando NPM signal observed, trigger authorization convergence re-evaluation."
			triggeredByEvent: "evt-counterparty-qualification-observed"
			issuesCommand:    "cmd-authorize-payment-obligation"
			guards: ["inv-cvg-authorization-requires-full-convergence"]
			rationale: "NPM counterparty qualification é condition canonical para B2B context."
		},

		// === 4 outras policies ===
		{
			code:        "pol-on-evidence-validation-evaluate-retention-release"
			name:        "OnEvidenceValidationEvaluateRetentionRelease"
			description: "Quando DLV evidence observed, trigger retention release convergence evaluation (independent do path authorization)."
			triggeredByEvent: "evt-evidence-validation-observed"
			issuesCommand:    "cmd-execute-retention-release"
			guards: ["inv-cvg-retention-release-requires-full-operational-convergence"]
			rationale: "DLV evidence dual-purpose: alimenta authorization (path acima) E retention release (este path). Policies separadas porque same trigger event issues different commands."
		},
		{
			code:        "pol-on-commitment-state-evaluate-retention-release"
			name:        "OnCommitmentStateEvaluateRetentionRelease"
			description: "Quando CMT milestone signal observed, trigger retention release convergence evaluation."
			triggeredByEvent: "evt-commitment-state-observed"
			issuesCommand:    "cmd-execute-retention-release"
			guards: ["inv-cvg-retention-release-requires-full-operational-convergence"]
			rationale: "CMT milestone signals alimentam retention release convergence (e.g., milestone-closed). Dual-purpose: authorization path acima + retention path aqui."
		},
		{
			code:        "pol-on-bkr-outcome-trigger-economic-interpretation"
			name:        "OnBkrOutcomeTriggerEconomicInterpretation"
			description: "Quando BKR settlement outcome observed, trigger economic interpretation via svc-economic-interpretation."
			triggeredByEvent: "evt-bkr-settlement-outcome-observed"
			issuesCommand:    "cmd-process-bkr-settlement-outcome"
			guards: [
				"inv-eps-no-inferred-settlement-truth",
				"inv-bdy-fce-never-arbitrates-settlement-outcome",
			]
			rationale: "BKR outcome consumido → trigger economic interpretation. Indeterminate path branches internamente no service (não policy)."
		},
		{
			code:        "pol-on-reverse-mandate-trigger-reverse-execution"
			name:        "OnReverseMandateTriggerReverseExecution"
			description: "Quando upstream reverse mandate observed (e.g., CommitmentCancelled retroactive), trigger reverse execution via svc-reverse-settlement-execution."
			triggeredByEvent: "evt-reverse-settlement-mandate-observed"
			issuesCommand:    "cmd-execute-reverse-settlement"
			guards: ["inv-bdy-reverse-settlement-requires-upstream-mandate"]
			rationale: "Upstream mandate observed → trigger reverse execution. Service validates mandate origin authenticity; internal-origin would be impossible por design (não há policy para internal-origin)."
		},
	]

	// =========================================================================
	// PROJECTIONS — 3 (read models last per P6: collapse ontology into views)
	// =========================================================================

	projections: [
		{
			code:        "prj-payment-obligation-lifecycle-view"
			name:        "PaymentObligationLifecycleView"
			description: "Read model derivado de published events do PaymentObligation lifecycle. Flattens 9 states + transitions em view consultável por correlation refs."
			consumesEvents: [
				"evt-payment-obligation-authorized",
				"evt-payment-instruction-dispatched-to-bkr",
				"evt-payment-obligation-settled",
				"evt-payment-obligation-failed",
				"evt-payment-pending-final-reconciliation-declared",
				"evt-payment-obligation-cancelled",
				"evt-payment-obligation-reversed",
			]
			queryCapabilities: [
				{
					code:        "qry-payment-obligation-by-id"
					description: "Recupera economic state atual + history transitions para PaymentObligationId específico."
					rationale:   "Query canonical para diagnóstico operacional e auditability."
				},
				{
					code:        "qry-payment-obligation-by-commitment"
					description: "Lista PaymentObligations associadas a commitment-ref específico."
					rationale:   "Suporta cross-BC query surface (CMT consumers)."
				},
			]
			rationale: "Per P6: projection collapses lifecycle ontology em view. Flattening é acknowledged ontology collapse — view derive do modelo, jamais influencia aggregate state. Read-only via construção."
		},
		{
			code:        "prj-retention-status-view"
			name:        "RetentionStatusView"
			description: "Read model focused em retention sub-lifecycle. Surface para queries operacionais sobre retention status."
			consumesEvents: [
				"evt-retention-held",
				"evt-retention-released",
			]
			queryCapabilities: [
				{
					code:        "qry-retention-by-obligation"
					description: "Retention status atual para PaymentObligationId específico."
					rationale:   "Query operacional canonical para retention queries."
				},
				{
					code:        "qry-retention-pending-convergence"
					description: "Lista retentions awaiting operational truth convergence (status=held)."
					rationale:   "Operational alert query: identify retentions long-held awaiting evidence."
				},
			]
			rationale: "Per founder Phase 3 ajuste #1: retention é dimensão subordinada — projection separada reflete isso (não mistura com lifecycle principal). Per P6: collapse ontology aceita explicitly."
		},
		{
			code:        "prj-pending-reconciliation-view"
			name:        "PendingReconciliationView"
			description: "Read model para PaymentObligations em PaymentPendingFinalReconciliation state. Surface canonical para reconciliation workflow upstream."
			consumesEvents: ["evt-payment-pending-final-reconciliation-declared"]
			queryCapabilities: [
				{
					code:        "qry-pending-reconciliation-by-age"
					description: "PaymentObligations em PaymentPendingFinalReconciliation state ordered by declared age — operational alert para reconciliation backlog."
					rationale:   "Operational visibility canonical para epistemic non-collapse state — supports reconciliation SLA monitoring upstream."
				},
			]
			rationale: "Materializa visibilidade canonical do epistemic non-collapse state. Surface canônica para reconciliation workflow upstream — projection NÃO resolves reconciliation, apenas surface visibility (resolution path é via cmd-resolve-reconciliation com authoritative source)."
		},
	]

	// =========================================================================
	// INTERPRETATION CONTRACTS (per adr-081)
	// =========================================================================

	systemConsistencyModel: {
		type: "eventual"
		intraAggregateGuarantees: [
			"Atomicidade transacional intra-aggregate: financialization 4-link atomic, lifecycle transitions single-step com guards canonical.",
			"Lifecycle state machine: 9 states + 10 transitions com invariant guards explicit; no implicit transitions.",
			"Retention sub-status mutations: vo-retention.status modificável apenas via cmd-mark-retention-held + cmd-execute-retention-release com convergence integrity.",
		]
		crossAggregateGuarantees: [
			"Cross-BC eventual consistency com upstream (BDG, REW, CMT, DLV, INV, NPM) via consumed events — observation latency aceito sob inv-cvg-3 staleness window.",
			"Cross-BC eventual consistency com BKR via consumed BKRSettlementOutcome — economic interpretation downstream-eventual.",
			"Downstream consumers (ATO, CRM, TCM) consomem FCE published events sob eventual semantics — settlement proof BKR-direct consumption recommended para semantics canonical.",
		]
		explicitlyDoesNotGuarantee: [
			"Strong consistency cross-BC em tempo real.",
			"Idempotência de PaymentInstruction execution rail-side (BKR-owned).",
			"Throughput SLAs sob optimization pressure — convergence integrity precede throughput per canonical evaluation metric.",
		]
		conflictResolution: {
			strategy: "explicit-command"
			rationale: "Conflitos cross-BC resolvidos via explicit commands canonical (cmd-process-bkr-settlement-outcome, cmd-resolve-reconciliation, cmd-execute-reverse-settlement) — não last-write-wins (que permitiria stale state corrupção) nem causal-ordering automatic (FCE não infers ordering)."
		}
		rationale: "Per adr-081: eventual consistency com explicit-command resolution é correct posture para BC convergence-centric com cross-BC ownership boundaries. Strong consistency cross-BC seria over-promise (BKR + upstream BCs evoluem independente); causal-ordering automatic implicaria inference (inv-eps-2 violation)."
	}

	decisionAuthorityModel: {
		type: "hybrid"
		authoritativeScope: "Economic interpretation of canonical settlement outcomes (FCE-owned downstream economic consequences) + AuthorizationConvergence determination + RetentionRelease convergence determination + reverse settlement execution per upstream mandate."
		advisoryScope:      "Upstream condition observations (consumed read-only; FCE não authors upstream state) + settlement execution truth (BKR-owned; FCE consume canonical outcomes apenas)."
		rationale: "Per adr-081: FCE é hybrid authority — authoritative downstream sobre economic interpretation, advisory upstream sobre conditions consumed. Materializa canonical clause base 'downstream-authoritative, not upstream-controlling' + term-downstream-authoritative (glossary)."
	}

	// =========================================================================
	// OUTER RATIONALE — Centering principles embedding + class organization
	// =========================================================================

	rationale: """
		Domain model FCE materializa Phase 3 do WI-043 FCE bootstrap.
		Charter constitucional Phase 3.0 founder-approved aplicado
		throughout (7 centering principles embedded como lodestone +
		threat-class identification governando each sub-phase).

		=========================================================================
		CENTERING PRINCIPLES EMBEDDED (charter Phase 3.0)
		=========================================================================

		P1 — GRAVITATIONAL CENTER: 'authoritative economic convergence
		under integrity constraints' (não Payment, Settlement, Ledger,
		Transaction, Workflow). Each building block deve parecer derivado
		deste centro. Refinement: 'economic' explicit ancora BC contra
		drift para workflow/orchestration genérico.

		P2 — INVARIANT TRIPARTITION: 11 invariants em 3 classes (Boundary
		4 + Convergence 4 + Epistemic 3) com primaryClass + secondaryTraits
		em rationale opening. Tags secondaryTraits cobrem: structural,
		temporal, atomic, epistemic-sensitive, boundary-sensitive,
		ontological-sensitive, institutional-resistant.

		P3 — STATE MACHINE BIPARTITION: EconomicLifecycleState (FCE-owned
		authoritative, 9 states no aggregate lifecycle) ⊕
		ObservedSettlementSnapshot (BKR-owned imported truth, modelada
		como VO read-only — anti-shadow-ownership). Settlement truth
		BKR-owned, economic consequence FCE-owned. RetentionHeld/
		RetentionReleased NÃO são states principais — são sub-status de
		vo-retention.

		P4 — INTEGRITY GUARDIANS: 6 services protect semantic invariants,
		NOT execution continuity. Fail/defer/escalate semantics canonical;
		degrade-gracefully + retry-recover-partial forbidden.

		P5 — NAMING IS ARCHITECTURE: forbidden by construction —
		PaymentCompleted/Processed/Executed/Fulfilled (collapse FCE↔BKR);
		Optimized/FastTrack/Smart/AutoApproved (success-oriented
		throughput gravity). Naming patterns canonical preserve ownership
		lens.

		P6 — AUTHORING ORDER CANONICAL (aplicado neste arquivo):
		invariants → state machine → value objects → services →
		commands/events → aggregate assembly → policies → projections.
		Projections last because they collapse ontology into views;
		derive do modelo, nunca influenciam.

		P7 — THREAT MODEL ELEVATION (vs Phase 2 lexical):
		structural drift + temporal drift + ontological drift +
		institutional drift (Phase 5+ risk: throughput pressure,
		operational exception normalization, waivers becoming permanent,
		escalation fatigue, convergence weakening framed as business
		pragmatism). Cada invariant carrega institutional-resistant tag
		quando aplicável (8 de 11 invariants têm essa tag — 73%).

		=========================================================================
		INVARIANT CLASS ORGANIZATION & CROSS-CLASS REINFORCEMENT
		=========================================================================

		Boundary (4):
		- inv-bdy-1 (no upstream mutation) — structural + ontological +
		  institutional-resistant
		- inv-bdy-2 (no settlement arbitration) — epistemic-sensitive +
		  ontological-sensitive
		- inv-bdy-3 (reverse upstream-mandate) — structural +
		  institutional-resistant + ontological-sensitive
		- inv-bdy-4 (economic interpretation distinct) — epistemic-
		  sensitive + ontological-sensitive + structural

		Convergence (4):
		- inv-cvg-1 (full convergence required) — atomic + ontological-
		  sensitive + institutional-resistant
		- inv-cvg-2 (atomic financialization) — atomic + structural
		- inv-cvg-3 (no stale eligibility) — temporal + epistemic-
		  sensitive + boundary-sensitive
		- inv-cvg-4 (retention release convergence) — atomic +
		  institutional-resistant + boundary-sensitive

		Epistemic (3):
		- inv-eps-1 (indeterminate non-collapse) — temporal +
		  ontological-sensitive + institutional-resistant
		- inv-eps-2 (no inferred settlement truth) — boundary-sensitive +
		  ontological-sensitive
		- inv-eps-3 (no proxy substitution) — boundary-sensitive +
		  structural + institutional-resistant

		Cross-class reinforcement matrix:
		- inv-bdy-1 (boundary) ↔ inv-eps-3 (epistemic): same upstream-
		  inviolability theme, complementary angles
		- inv-bdy-2 (boundary) ↔ inv-eps-2 (epistemic): no settlement
		  arbitration ⊕ no inference (closes both vectors)
		- inv-cvg-3 (convergence) ↔ inv-bdy-1 (boundary): temporal
		  validity requires upstream re-observation (not internal refresh)

		=========================================================================
		FOUNDER AJUSTES INTEGRATED PRE-WRITE (10 total)
		=========================================================================

		Phase 3.0 charter (7 refinements pre-Phase 3.1):
		1. P1 + 'economic': protege contra workflow/orchestration drift
		2. P2 + secondary traits: tags para SRR + governance + observability
		3. P3 + ObservedSettlementState framing: anti-shadow-ownership
		4. P4 + 'integrity not continuity': fail/defer/escalate explicit
		5. P5 + success-oriented forbidden: anti-throughput-gravity
		6. P6 + 'projections collapse ontology': last per epistemic reason
		7. P7 + institutional drift: 5ª class threat model

		Phase 3.1.A Boundary (4 ajustes):
		- inv-bdy-1: 'solicitar modificação' → '...sem command/protocol
		  upstream-owned' (FCE pode request via protocol, não controla
		  resultado)
		- inv-bdy-2: + 'FCE may create economic consequences from BKR
		  outcomes, but not alternative settlement outcomes'
		- inv-bdy-3: 'regulatory mandate' → 'upstream process responding
		  to regulatory mandate' (regulador não autoriza FCE diretamente)
		- inv-bdy-4: + downstream consume both clause (FCE economic +
		  BKR settlement proof) — anti-proxy-universal

		Phase 3.1.B Convergence: clean approval (zero ajustes).
		Phase 3.1.C Epistemic + 3.2-3.7: clean approval com 6 ajustes
		estruturais finais aplicados aqui no write.

		Phase 3 mega ajustes (6 final pre-write):
		1. Retention NOT states principais — vo-retention.status field
		   {none|held|released|blocked}; eventos preservados como
		   status changes documented
		2. cmd-authorize-payment-obligation principal (não cmd-emit-
		   authorization-proof); proof emission é internal service effect
		3. cmd-resolve-reconciliation guard forte: resolutionEvidence
		   MUST originate from BKR/Bacen/supervised reconciliation;
		   resolutionSource field carrega evidence origin
		4. evt-payment-obligation-sent → evt-payment-instruction-
		   dispatched-to-bkr (explicit; FCE não executa); state name
		   também InstructionDispatched
		5. 6 explicit policies para upstream signals (BDG/REW/CMT/DLV/
		   INV/NPM) — não policy genérica
		6. Events count: 8 internal + 11 published = 19 (sem ambiguidade)

		=========================================================================
		COVERAGE NUMERICAL
		=========================================================================

		11 invariants (4 bdy + 4 cvg + 3 eps)
		19 events (8 internal ACL + 11 published)
		11 commands (all intent-named; no execution-named)
		8 value objects (incluindo ObservedSettlementSnapshot read-only)
		1 aggregate root (PaymentObligation single + 9 states + 10
		  transitions)
		6 domain services (integrity guardians per P4)
		10 policies (6 upstream-signal + 4 outras: 2 retention-release
		  upstream + 1 bkr-outcome + 1 reverse-mandate)
		3 projections (lifecycle + retention status + pending
		  reconciliation)

		=========================================================================
		CANVAS PHASE 1 + GLOSSARY PHASE 2 TRACEABILITY
		=========================================================================

		7 canvas capabilities mapped to building blocks:
		- cap-payment-lifecycle-state-machine → aggregate lifecycle
		  (EconomicLifecycleState, 9 states)
		- cap-prepayment-guard-service → svc-prepayment-guard
		- cap-financialization-service → svc-financialization
		- cap-authorization-proof-emission → svc-authorization-convergence
		  (proof emission como efeito interno)
		- cap-cross-bc-condition-evaluation → 6 upstream-signal policies
		  + svc-authorization-convergence
		- cap-payment-outcome-routing → svc-economic-interpretation
		- cap-retention-release-conditional → svc-retention-release

		7 canvas businessDecisions cited in invariant rationales:
		- bd-financialization-is-atomic → inv-cvg-2
		- bd-authorization-is-convergence-not-decision → inv-cvg-1
		- bd-upstream-truth-immutable-from-fce → inv-bdy-1
		- bd-authorization-proof-cryptographic-binding → vo-authorization-
		  proof + inv-bdy-1
		- bd-settlement-delegated-to-bkr → inv-bdy-2 + inv-bdy-4 +
		  vo-observed-settlement-snapshot
		- bd-retention-release-conditional-on-operational-truth → inv-cvg-4
		- bd-reverse-settlement-upstream-mandated-only → inv-bdy-3

		22 glossary terms anchored in building blocks (cobertura tq-gl-04):
		- term-payment-obligation → agg-payment-obligation
		- term-payment-lifecycle → aggregate.lifecycle
		- term-financialization → svc-financialization + inv-cvg-2
		- term-prepayment-guard → svc-prepayment-guard
		- term-authorization-convergence → svc-authorization-convergence
		  + inv-cvg-1
		- term-authorization-convergence-set → vo-authorization-convergence-set
		- term-authorization-proof → vo-authorization-proof
		- term-payment-instruction → vo-payment-instruction-payload
		- term-bkr-settlement-outcome → vo-observed-settlement-snapshot +
		  evt-bkr-settlement-outcome-observed
		- term-payment-pending-final-reconciliation → state
		  PaymentPendingFinalReconciliation + evt-...-declared
		- term-retention → vo-retention
		- term-retention-release → svc-retention-release + cmd-execute-
		  retention-release
		- term-retention-release-convergence-set → vo-retention-release-
		  convergence-set
		- term-reverse-settlement → svc-reverse-settlement-execution +
		  cmd-execute-reverse-settlement
		- term-economic-interpretation → svc-economic-interpretation
		- term-downstream-authoritative → decisionAuthorityModel (hybrid
		  with downstream-authoritative scope)
		- term-upstream-condition → vo-upstream-condition-snapshot
		- term-cross-bc-condition-evaluation → 6 upstream-signal policies
		- term-condition-weakening → inv-cvg-1 + inv-eps-3 (anti-pattern
		  rule terms)
		- term-convergence-boundary-erosion → vo-...-convergence-set
		  schemaVersion field (boundary erosion detection)
		- term-convergence-integrity → systemConsistencyModel rationale
		  + integrity guardian framing
		- term-economic-authority-crystallization → centering principle P1
		  + crystallization concept throughout

		=========================================================================
		LENSES (5)
		=========================================================================

		- lens-mechanism-design (primária): convergence as canonical
		  mechanism — explicitly modeled (AuthorizationConvergenceSet +
		  RetentionReleaseConvergenceSet as VOs; convergence integrity
		  as metric).
		- lens-trust-and-credibility-design: integrity-over-throughput
		  posture canonical (P1 + P7 + canonical evaluation metric).
		- lens-distributed-systems-design: eventual consistency cross-BC
		  via events + epistemic non-collapse (PaymentPendingFinal
		  Reconciliation state).
		- lens-regulatory-compliance-as-architecture: reverse settlement
		  upstream-mandated-only (inv-bdy-3); regulatory mandate via
		  upstream process, não FCE direto.
		- lens-domain-language-and-terminology-design: 22 glossary terms
		  anchored in building blocks; UL canonical preserved
		  estruturalmente.

		Phase 3.8 SRR (srr-fce-domain-model) próximo. Phase 4 (primary
		agent-spec) + Phase 5 (governance envelope) restam para fechar
		WI-043.
		"""
}
