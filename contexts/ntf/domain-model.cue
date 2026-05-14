package ntf

// domain-model.cue — Domain Model NTF: Notifications & Communications.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// =============================================================================
// CENTERING PRINCIPLES (charter constitucional Phase 3.0 — founder approved
// com 9 refinements integrated; embedded também em outer rationale)
// =============================================================================
//
// P1 — Gravitational center: "admissibility-governed execution under
//      epistemic uncertainty". NÃO é notification/messaging/engagement
//      intelligence platform. Todo building block deve parecer derivado
//      deste centro; aparência operacional ('delivery attempt workflow',
//      'transport orchestration') é sinal amarelo imediato.
//
// P2 — Invariant tripartition ontológica: 16 invariants em 3 classes —
//      Boundary (inv-bdy-*, 5: ontology preservation across heterogeneity)
//      ⊕ Admissibility (inv-adm-*, 7: certification gate sovereignty +
//      tier separation + scope-as-identity) ⊕ Epistemic (inv-eps-*, 4:
//      uncertainty handling + claim-vs-fact asymmetry + replay isolation).
//      Constitutional triangle C7+C8+C11 forma admissibility sovereignty
//      cluster.
//
// P3 — State machine bipartition: Layer 1 SubstrateAuthorityState (NTF-
//      owned certification authority — Tier 1 claims gate Tier 2 certs)
//      ⊕ Layer 2 DependentOperationalState (execution lifecycle bound a
//      certification snapshot). Layer 6 (dispatch) NUNCA pode reopen
//      admissibility decided em Layer 1.
//
// P4 — Services as admissibility guardians, NOT delivery orchestrators.
//      Protect constitutional clauses C1-C15, not delivery success
//      rates. Failure semantics: refuse/defer/escalate, NEVER degrade-
//      gracefully nor "best-effort delivery".
//
// P5 — Naming is architecture. Forbidden by construction:
//      Delivery{Succeeded|Confirmed|Optimized|FastTracked|Smart},
//      AutoApproved{Certification}, BestEffort{Dispatch},
//      Engagement{Aware|Optimized}, BehavioralInference. Success-
//      oriented + collapse-claim-into-fact naming proibidos.
//
// P6 — Authoring order canonical (followed): invariants tripartite →
//      bipartite state machine → value objects → services → commands/
//      events → aggregate assembly → policies → projections. Projections
//      last because they collapse ontology into views — derive from
//      model, never influence it.
//
// P7 — Threat model elevation: structural drift (Tier 1 ↔ Tier 2
//      collapse) + ontological drift (claim ↔ fact collapse) + temporal
//      drift (binding stale beyond snapshot) + institutional drift
//      (refusal-reinterpretation gravity drift #12, engagement gravity
//      drift #5). Cada invariant carrega institutional-resistant tag
//      quando aplicável.
//
// P8 — Replay-forbidden é ontological execution category, NÃO
//      operational policy. Materializado via VO discriminator + state
//      machine branch + isolated service. Re-issuance é issuer
//      responsibility per inv-eps-4 — NTF refuses retry path por
//      construção.
//
// P9 — Provider-claim vs transport-observed asymmetric epistemic
//      ontology: provider-confirmed-success carries HIGH suspicion
//      weight (false-success catastrophic); transport-observed-success
//      carries LOW suspicion weight (independent observation). False-
//      failure menos perigoso que false-success — assimetria materializada
//      em vo-observation-provenance.
//
// =============================================================================
//
// 27 events (3 internal ACL + 24 published)
// 17 commands (8 substrate + 9 execution; intent-named, never delivery-named)
// 16 invariants (5 boundary + 7 admissibility + 4 epistemic)
// 12 value objects (incluindo vo-admissibility-certification-snapshot +
//   vo-execution-certification-binding + vo-replay-semantics-discriminator)
// 1 aggregate root (GuaranteeContractExecution) com 2 nested entities
//   (ent-admissibility-certification Tier 2 + ent-provider-capability-claim
//   Tier 1); 9-state primary lifecycle, 13 transitions
// 6 domain services (admissibility guardians per P4)
// 4 policies + 4 projections
//
// Lenses ativadas (5): lens-mechanism-design (primária — admissibility
// certification gate as canonical mechanism), lens-trust-and-credibility-
// design (evidence-grounded substrate; conservatism C11), lens-distributed-
// systems-design (claim vs fact asymmetric provenance + replay-forbidden
// isolation), lens-regulatory-compliance-as-architecture (tc-regulatory-
// evidentiary + court-grade audit), lens-domain-language-and-terminology-
// design (22 glossary terms anchored).
//
// Materializado em Phase 3 do WI-063 NTF bootstrap; 3 BC artifacts agora
// completos (canvas Phase 1 closed 11f7f98 + glossary Phase 2 closed
// f7e5832 + este domain-model). Cascade ordering preservado.
//
// Family Mesh pattern: FCE preserva semantic integrity of economic
// convergence; NTF preserva admissibility integrity of communication
// guarantees. Ambos refusal-centered, mechanically conservative,
// anti-degradation infrastructures — paralelo arquitetural canonical.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

domainModel: artifact_schemas.#DomainModel & {
	code: "ntf"
	name: "Domain Model NTF — Notifications & Communications"

	boundedContextRef: "ntf"

	// =========================================================================
	// EVENTS — 27 total (3 internal ACL + 24 published)
	// =========================================================================

	events: [
		// === INTERNAL EVENTS (ACL translations de provider ecosystem signals) ===
		{
			code:        "evt-provider-dispatch-acknowledgment-observed"
			name:        "ProviderDispatchAcknowledgmentObserved"
			description: "ACL translation de signal do provider ecosystem indicando dispatch acknowledgment. Per C10 + P9: claim-preserving handling — provider says, NÃO NTF accepts as fact. Provenance class carries HIGH suspicion weight (false-success catastrophic per inv-eps-1)."
			rationale:   "Materializa C10 (provider-claim epistemic limitation) na fronteira ACL. Asymmetric suspicion weighting: provider-confirmed = HIGH suspicion, transport-observed = LOW (vo-observation-provenance). Sem este event distinct de transport-observed, sistema collapses claim into fact silently — drift class #9 precursor."
			visibility:    "internal"
			sourceContext: "ext-provider-ecosystem"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "acknowledgmentRef", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-provider-dispatch-failure-observed"
			name:        "ProviderDispatchFailureObserved"
			description: "ACL translation de provider-reported failure signal. Per C10 + P9: claim-preserving handling com NORMAL suspicion weight (false-failure recoverable, menos perigoso que false-success). Asymmetry canonical materializada."
			rationale:   "Failure claims carry suspicion lower que success claims — recovery via re-attempt OR escalation é safe response. Failure-claim collapse-into-fact é menos catastrófico que success-claim collapse. Per Phase 1.5.B Section D asymmetric ajuste #4 do canvas."
			visibility:    "internal"
			sourceContext: "ext-provider-ecosystem"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "failureClass", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-provider-capability-change-notified"
			name:        "ProviderCapabilityChangeNotified"
			description: "ACL translation de provider ecosystem signal indicando capability lifecycle change (API version, feature deprecation, mode change, infrastructure migration). Triggers re-certification per C13 scope boundary check + cascading dependency invalidation."
			rationale:   "Per Phase 1.5.B Section C dependency graph: load-bearing dependency change → revocation; supporting → suspension; auxiliary → re-verification. Sem este event, sistema misses provider lifecycle events that should cascade to certification lifecycle."
			visibility:    "internal"
			sourceContext: "ext-provider-ecosystem"
			fields: [
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "changeKind", type: "string"},
				{kind: "primitive", name: "dependencySeverity", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
			]
		},

		// === PUBLISHED EVENTS (NTF-originated per CC1-CC4) ===

		// --- Tier 1 substrate lifecycle (4) ---
		{
			code:        "evt-provider-capability-claim-submitted"
			name:        "ProviderCapabilityClaimSubmitted"
			description: "Tier 1 entry recorded canonically. Per C8 + bd-substrate-two-tier: claim entry distinct from admissibility decision — claim alone NÃO grants admission per C14."
			rationale:   "Materializa Tier 1 substrate entry mechanically. Claim event distinct from CertificationIssued: claim recorded NÃO equivale a certification issued — gate must run separately per inv-adm-tier-separation-never-collapsed."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "claimRef", type: "string"},
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "transportContractDimension", type: "string"},
				{kind: "primitive", name: "submittedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-verification-evidence-submitted"
			name:        "VerificationEvidenceSubmitted"
			description: "VerificationEvidence record submitted supporting existing claim. Triggers confidence class re-assessment per Phase 1.3.B Section B sensitivity rules. Evidence é substrate-grounding requirement, NÃO marketing artifact."
			rationale:   "Per bd-evidence-as-substrate: registry stays evidence-grounded, NÃO wishful abstraction. Sem este event explicit, sistema cannot trigger confidence class re-evaluation deterministically."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "evidenceRef", type: "string"},
				{kind: "primitive", name: "supportsClaimRef", type: "string"},
				{kind: "primitive", name: "verificationMethod", type: "string"},
				{kind: "primitive", name: "confidenceImpact", type: "string"},
				{kind: "primitive", name: "submittedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-negative-capability-evidence-recorded"
			name:        "NegativeCapabilityEvidenceRecorded"
			description: "Negative evidence artifact created (failure/contradiction/drift observed). Per Phase 1.3.C Section C: strong negative triggers auto-revocation cascade; moderate triggers investigation cycle (→ suspension). Negative evidence layer coexists com positive; admissibility considers both."
			rationale:   "Per inv-adm-empirical-reliability-cannot-expand-ontology: positive empirical observations cannot offset negative evidence. Negative evidence é structural input para certification degradation/revocation per C12."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "negativeEvidenceRef", type: "string"},
				{kind: "primitive", name: "affectsCertificationRef", type: "string"},
				{kind: "primitive", name: "severity", type: "string"},
				{kind: "primitive", name: "recordedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-evidence-staleness-detected"
			name:        "EvidenceStalenessDetected"
			description: "Evidence aging triggered re-verification cycle per Section B sensitivity schedule (30/90/180 days per confidence class). Per C13: scope inclui temporal dimension; staleness é structural property of evidence."
			rationale:   "Materializa temporal dimension de evidence model. Sem este event, sistema cannot trigger re-verification deterministically — evidence ages into operational folklore (drift class #11 precursor)."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "evidenceRef", type: "string"},
				{kind: "primitive", name: "affectsCertificationRef", type: "string"},
				{kind: "primitive", name: "stalenessClass", type: "string"},
				{kind: "primitive", name: "detectedAt", type: "datetime"},
			]
		},

		// --- Tier 2 certification lifecycle (5) ---
		{
			code:        "evt-admissibility-certification-issued"
			name:        "AdmissibilityCertificationIssued"
			description: "Tier 2 certification entered admissibility matrix per CC4. Carries claim ref + evidence chain + scope boundary + confidence class + sensitivity context. NÃO emitted implicitly via empirical correlation (CC4)."
			rationale:   "Materializa gate-passage canonical. Per inv-adm-tier-separation-never-collapsed + C8 + bd-substrate-two-tier: gate é constitutional center between substrate tiers. Event emitted apenas após svc-admissibility-certification-gate produce promotion act explicit."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "claimRef", type: "string"},
				{kind: "primitive", name: "transportContractClass", type: "string"},
				{kind: "primitive", name: "confidenceClass", type: "string"},
				{kind: "primitive", name: "scopeBoundaryRef", type: "string"},
				{kind: "primitive", name: "issuedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-admissibility-certification-issuance-failed"
			name:        "AdmissibilityCertificationIssuanceFailed"
			description: "Gate evaluated claim+evidence and refused promotion to Tier 2. Per founder Phase 3.5 ajuste #2: success/failure paths split canonically — gate refusal é first-class event distinct de certification issued (paralelo a refusal-vs-certified em execution path)."
			rationale:   "Per C7 + C8 + C11: gate refusal preserves admissibility integrity. Sem este event distinct, sistema collapses 'no certification issued' em silent state — gate decision visibility requires explicit failure event."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "claimRef", type: "string"},
				{kind: "primitive", name: "transportContractClass", type: "string"},
				{kind: "primitive", name: "refusalReason", type: "string"},
				{kind: "primitive", name: "failedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-admissibility-certification-degraded"
			name:        "AdmissibilityCertificationDegraded"
			description: "Confidence class lowered per Section B degradation rules. Per CC4: explicit lifecycle event — admissibility nunca degraded implicitly. Strong → moderate → provisional → inadmissible."
			rationale:   "Per inv-adm-governed-change-path-not-implicit: degradation é explicit governance act, NÃO silent confidence erosion. Event preserves audit chain."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "fromConfidenceClass", type: "string"},
				{kind: "primitive", name: "toConfidenceClass", type: "string"},
				{kind: "primitive", name: "degradationCause", type: "string"},
				{kind: "primitive", name: "degradedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-admissibility-certification-suspended"
			name:        "AdmissibilityCertificationSuspended"
			description: "Certification temporarily unsafe pending investigation/re-verification (moderate negative evidence accumulating). Per Phase 1.5.B Section B: epistemic uncertainty escalation — recoverable via re-verification cycle."
			rationale:   "Distinct from revocation (ontological invalidation): suspension é temporary safety pause. Per inv-adm-admissibility-conservatism-refuse-not-degrade: under uncertainty, suspend rather than tolerate."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "suspensionReason", type: "string"},
				{kind: "primitive", name: "suspendedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-admissibility-certification-revoked"
			name:        "AdmissibilityCertificationRevoked"
			description: "Certification permanently invalidated (confirmed negative evidence / operator revocation / provider capability withdrawn). Per Phase 1.5.B Section B: ontological invalidation distinct de suspension."
			rationale:   "Per inv-adm-governed-change-path-not-implicit: revocation é explicit governance act. In-flight bindings to revoked certification handled per binding immutability rule (inv-adm-binding-evidence-at-time-not-portable-token + Projection #4 framing) — visibility operational, NÃO retroactive invalidation."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "revocationCause", type: "string"},
				{kind: "primitive", name: "revokedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-recertification-review-triggered"
			name:        "RecertificationReviewTriggered"
			description: "Re-certification review necessary per staleness OR provider capability change OR scope boundary stress. Per founder Phase 3.7 ajuste #1: este event NÃO altera certificação nem binding — apenas materializa necessidade de avaliação. Decisão de certificate/refuse/degrade vem em event subsequente após gate run."
			rationale:   "Per inv-adm-governed-change-path-not-implicit: review trigger é distinct from certification mutation. Trigger creates evaluation obligation; svc-admissibility-certification-gate run produces outcome event. Two-stage explicit defends against silent re-certification drift."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "triggerCause", type: "string"},
				{kind: "primitive", name: "triggeredAt", type: "datetime"},
			]
		},
		{
			code:        "evt-capability-dependency-chain-impacted"
			name:        "CapabilityDependencyChainImpacted"
			description: "Upstream dependency change cascades to certification lifecycle. Per Phase 1.5.B Section C: load-bearing dependency change → revocation; supporting → suspension; auxiliary → re-verification."
			rationale:   "Per founder Phase 3.3 ajuste #5: CapabilityDependencyChainImpacted naming consistency with canvas. Materializa dependency graph cascade canonical."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "affectsCertificationRef", type: "string"},
				{kind: "primitive", name: "dependencySeverity", type: "string"},
				{kind: "primitive", name: "cascadeAction", type: "string"},
				{kind: "primitive", name: "impactedAt", type: "datetime"},
			]
		},

		// --- Execution lifecycle Layer 2 (12 — refusal-canonical + binding + dispatch + transport facts + fallback + escalation) ---
		{
			code:        "evt-dispatch-admissibility-certified"
			name:        "DispatchAdmissibilityCertified"
			description: "Admissibility validation passed; transport submission imminent. Per C8: certification verdict explicit (não silent acceptance). Per inv-adm-binding-evidence-at-time-not-portable-token: certification snapshot bound a este dispatch instance específico."
			rationale:   "Materializa admissibility certification ato canonical para execução. Distinct from cert-issued (Tier 2 substrate): este é per-dispatch admission act, bound a snapshot at-time, NÃO portable token."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "transportContractDeclarationRef", type: "string"},
				{kind: "primitive", name: "certificationSnapshotRef", type: "string"},
				{kind: "primitive", name: "certifiedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-transport-contract-admissibility-refused"
			name:        "TransportContractAdmissibilityRefused"
			description: "Admissibility matrix produced incompatibility verdict (Class A / B1 / B2 / C). Per C7 + CC2: explicit refusal carrying class + failing dimensions + resolution path. First-class canonical outcome (paralelo a FCE PaymentObligationDeferred)."
			rationale:   "Materializa C7 constitutional center mechanically. Per bd-refusal-over-degradation: refusal é first-class valid outcome — sistema halts via canonical refusal antes de degrade contract guarantees."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "transportContractDeclarationRef", type: "string"},
				{kind: "primitive", name: "incompatibilityClass", type: "string"},
				{kind: "primitive", name: "failingDimensions", type: "string"},
				{kind: "primitive", name: "resolutionPath", type: "string"},
				{kind: "primitive", name: "refusedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-admissibility-conservatism-triggered"
			name:        "AdmissibilityConservatismTriggered"
			description: "Confidence class insufficient OR evidence stale OR provenance inadequate OR scope boundary uncertain. Per C11 + Phase 1.5.B Section A: refusal for EPISTEMIC uncertainty (distinct de structural impossibility). 'I cannot guarantee' vs 'I cannot do'."
			rationale:   "Materializa C11 conservatism mechanically. Distinct ontology de refusal: structural impossibility (refused) vs epistemic insufficiency (conservatism). Both canonical outcomes — sem this distinction, sistema collapses categorias diferentes em single signal."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "transportContractDeclarationRef", type: "string"},
				{kind: "primitive", name: "uncertaintyDimension", type: "string"},
				{kind: "primitive", name: "triggeredAt", type: "datetime"},
			]
		},
		{
			code:        "evt-execution-certification-binding-emitted"
			name:        "ExecutionCertificationBindingEmitted"
			description: "Per-dispatch binding crystallized: certification snapshot + transport contract declaration + scope context + provider identity binding all locked at-time. Per inv-adm-binding-evidence-at-time-not-portable-token: binding é evidence-at-time, NÃO portable token."
			rationale:   "Materializa binding immutability canonical. Per founder Phase 3.3 ajuste #1: bindingOperationalStatus field carries operational liveness distinct de admissibility validity — binding remains admissibility-valid mesmo while operational status varies."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "bindingRef", type: "string"},
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "certificationSnapshotRef", type: "string"},
				{kind: "primitive", name: "transportContractDeclarationRef", type: "string"},
				{kind: "primitive", name: "providerIdentityRef", type: "string"},
				{kind: "primitive", name: "emittedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-dispatch-attempted"
			name:        "DispatchAttempted"
			description: "Dispatch submitted to transport layer under binding. Lifecycle state transitions para 'Dispatched'. Carries scope context for downstream correlation."
			rationale:   "Materializa transport submission canonical. Per inv-bdy-fallback-execution-only-not-decision: dispatch executes per binding, NÃO interprets."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "bindingRef", type: "string"},
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "attemptedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-dispatch-confirmed-transport-layer"
			name:        "DispatchConfirmedTransportLayer"
			description: "Transport layer confirms delivery. Per founder Phase 3.4 ajuste #1: payload framing é 'independently observed transport fact' OR 'provider-claimed acknowledgment' explicit via provenance class. Per C10 + CC3: provenance distinguishes provider-confirmed (HIGH suspicion) vs transport-observed (LOW suspicion) — issuer interprets confidence per their semantics."
			rationale:   "Per inv-eps-claim-preserving-handling-vs-fact-preserving-handling: claim ontology vs fact ontology preserved distinctly. Sem this distinction, sistema collapses provider-claimed-success into transport-fact silently — drift class #9 catastrophic vector."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "bindingRef", type: "string"},
				{kind: "primitive", name: "observationProvenanceClass", type: "string"},
				{kind: "primitive", name: "independenceClassification", type: "string"},
				{kind: "primitive", name: "confirmedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-dispatch-failed-transport-layer"
			name:        "DispatchFailedTransportLayer"
			description: "Transport layer reports failure. Failure with class: transient (B2-eligible retry per binding) vs structural (B1) vs provider-specific (C). Per CC1: transport-layer fact only — não behavioral inference."
			rationale:   "Per inv-bdy-ntf-never-derives-recipient-semantics: failure é transport-layer fact NÃO behavioral signal (bounce ≠ disengagement). Per P9: failure-claim provenance class explicit."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "bindingRef", type: "string"},
				{kind: "primitive", name: "failureClass", type: "string"},
				{kind: "primitive", name: "observationProvenanceClass", type: "string"},
				{kind: "primitive", name: "failedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-pending-dispatch-revoked"
			name:        "PendingDispatchRevoked"
			description: "Issuer-initiated revocation processed (dispatch não yet transport-attempted). Lifecycle terminated. Replay-forbidden dispatches receive distinct escalation event (não revogation pathway)."
			rationale:   "Per C9: replay-forbidden lifecycle isolation — revocation pathway distinct from replay-forbidden failure pathway. Sem this distinction, sistema treats OTP revocation same as financial-event revocation (semantic identity corruption)."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "bindingRef", type: "string"},
				{kind: "primitive", name: "revocationCause", type: "string"},
				{kind: "primitive", name: "revokedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-fallback-executed"
			name:        "FallbackExecuted"
			description: "Issuer-declared fallback path activated per policy. Per C2: fallback policy issuer-owned; execution NTF mechanical. Original + substitute transports both recorded."
			rationale:   "Per inv-bdy-fallback-execution-only-not-decision: NTF executa fallback path declared by issuer, NÃO infers fallback. Mechanical execution preserves separation."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "originalDispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "fallbackDispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "originalTransport", type: "string"},
				{kind: "primitive", name: "substituteTransport", type: "string"},
				{kind: "primitive", name: "executedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-fallback-unavailable"
			name:        "FallbackUnavailable"
			description: "No admissible fallback per issuer policy; escalation back to issuer. Issuer decides next action (re-issue with relaxed contract, abandon, etc) — NÃO NTF degradation."
			rationale:   "Per C7 + inv-bdy-fallback-execution-only-not-decision: NTF refuses rather than improvise fallback. Escalation preserves issuer ownership of fallback semantics."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "originalDispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "exhaustedFallbacks", type: "string"},
				{kind: "primitive", name: "escalatedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-receiver-confirmation-routed"
			name:        "ReceiverConfirmationRouted"
			description: "Receiver-confirmation-required signal received from receiver-side. Per C10: receiver-side signal routed upstream untouched. Semantic interpretation by issuer, NÃO NTF."
			rationale:   "Per inv-bdy-receiver-confirmation-routed-untouched: receiver signals são routed, NÃO interpreted. Sem this rule, NTF derives recipient semantics — drift class #1 (decision leak) vector."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "receiverConfirmationRef", type: "string"},
				{kind: "primitive", name: "routedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-replay-forbidden-failure-escalated"
			name:        "ReplayForbiddenFailureEscalated"
			description: "Replay-forbidden delivery failed; cannot retry via persistence. Per C9 + inv-eps-replay-forbidden-failed-issuer-reissuance: issuer must re-issue from source (new semantic act, not retry). Distinct from generic dispatch failure."
			rationale:   "Per founder Phase 3.1.C ajuste #4: failed replay-forbidden = issuer re-issuance responsibility. NTF refuses retry path por construção — OTP being re-sent (retry) vs new OTP issued (re-issuance) é semantic identity distinction critical."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "messageIdentityRef", type: "string"},
				{kind: "primitive", name: "failureCause", type: "string"},
				{kind: "primitive", name: "escalatedAt", type: "datetime"},
			]
		},
		{
			code:        "evt-certification-scope-exceeded"
			name:        "CertificationScopeExceeded"
			description: "Query made outside certified scope (traffic burst / payload exceeded / geography mismatch / provider mode change). Per C13: triggers refusal OR re-certification request per issuer policy."
			rationale:   "Per inv-adm-scope-as-certification-identity: scope é structural identity of certification, NÃO operational parameter. Out-of-scope query produces explicit event — sem this event, sistema silently extends scope (drift class #11 vector)."
			visibility: "published"
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "exceededDimension", type: "string"},
				{kind: "primitive", name: "exceededAt", type: "datetime"},
			]
		},
	]

	// =========================================================================
	// COMMANDS — 17 total (8 substrate + 9 execution)
	// =========================================================================

	commands: [
		// === SUBSTRATE COMMANDS (8) — Tier 1 + Tier 2 governance ===
		{
			code:        "cmd-submit-provider-capability-claim"
			name:        "SubmitProviderCapabilityClaim"
			description: "Operator submits new provider capability claim para Tier 1. Per C8 + C11: claim entry NÃO triggers admissibility automatically — gate must run separately. Carries VerificationEvidence pointer + verification method declared."
			rationale:   "Entry point canônico para Tier 1 substrate. Per bd-substrate-two-tier: claim alone NÃO grants admission per C14 — gate must run."
			fields: [
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "transportContractDimension", type: "string"},
				{kind: "primitive", name: "verificationEvidenceRef", type: "string"},
				{kind: "primitive", name: "verificationMethod", type: "string"},
			]
		},
		{
			code:        "cmd-submit-verification-evidence"
			name:        "SubmitVerificationEvidence"
			description: "Operator submits verification evidence supporting existing claim. Triggers confidence class assessment per Phase 1.3.B Section B sensitivity rules."
			rationale:   "Per bd-evidence-as-substrate: evidence é substrate-grounding requirement. Per founder Phase 3.3 ajuste #2 (supportsClaimRef): evidence sempre bound a specific claim — provider-instrumented evidence treated as non-independent per inv-eps-no-evidence-via-claimed-source."
			fields: [
				{kind: "primitive", name: "supportsClaimRef", type: "string"},
				{kind: "primitive", name: "verificationMethod", type: "string"},
				{kind: "primitive", name: "evidenceArtifactRef", type: "string"},
				{kind: "primitive", name: "independenceClass", type: "string"},
			]
		},
		{
			code:        "cmd-submit-negative-capability-evidence"
			name:        "SubmitNegativeCapabilityEvidence"
			description: "Operator submits negative evidence (failure/contradiction/drift observed). Strong negative triggers auto-revocation; moderate triggers investigation cycle (suspension per Phase 1.5.B Section B)."
			rationale:   "Per inv-adm-empirical-reliability-cannot-expand-ontology: negative evidence é structural input, NÃO can be offset by positive correlation. Sem este command explicit, sistema misses pathway for substrate self-correction."
			fields: [
				{kind: "primitive", name: "affectsCertificationRef", type: "string"},
				{kind: "primitive", name: "negativeEvidenceArtifactRef", type: "string"},
				{kind: "primitive", name: "severity", type: "string"},
			]
		},
		{
			code:        "cmd-issue-admissibility-certification"
			name:        "IssueAdmissibilityCertification"
			description: "Gate evaluates claim + evidence and produces Tier 2 certification (success path). Per founder Phase 3.6 ajuste #3: gate consumes claim + evidence and issues separate Tier 2 certification — claim NÃO mutates into certification, gate produces distinct entity."
			rationale:   "Per inv-adm-tier-separation-never-collapsed: Tier 1 (claim) + Tier 2 (certification) são distinct entities. Gate é constitutional center — produces certification as new artifact, NÃO promotion in-place."
			fields: [
				{kind: "primitive", name: "claimRef", type: "string"},
				{kind: "primitive", name: "transportContractClass", type: "string"},
				{kind: "primitive", name: "scopeBoundaryRef", type: "string"},
			]
		},
		{
			code:        "cmd-refuse-admissibility-certification-issuance"
			name:        "RefuseAdmissibilityCertificationIssuance"
			description: "Gate evaluates claim + evidence and refuses Tier 2 promotion (failure path). Per founder Phase 3.5 ajuste #1: split de cmd-issue-admissibility-certification em success/failure paths canonical."
			rationale:   "Per C7 + C11 + bd-conservatism-under-uncertainty: gate refusal é first-class outcome distinct from success. Sem split explicit, sistema treats refusal as 'absence of issued' (silent state)."
			fields: [
				{kind: "primitive", name: "claimRef", type: "string"},
				{kind: "primitive", name: "transportContractClass", type: "string"},
				{kind: "primitive", name: "refusalReason", type: "string"},
			]
		},
		{
			code:        "cmd-trigger-recertification-review"
			name:        "TriggerRecertificationReview"
			description: "Triggers re-certification review per staleness OR provider capability change OR scope boundary stress. Per founder Phase 3.7 ajuste #1: este command NÃO altera certificação nem binding — apenas cria necessidade de avaliação. Decisão de certificate/degrade/revoke vem em commands subsequentes após svc-admissibility-certification-gate run."
			rationale:   "Per inv-adm-governed-change-path-not-implicit: review trigger é distinct from certification mutation. Trigger creates evaluation obligation; gate run produces outcome. Two-stage explicit defends against silent re-certification drift."
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "triggerCause", type: "string"},
			]
		},
		{
			code:        "cmd-degrade-admissibility-certification"
			name:        "DegradeAdmissibilityCertification"
			description: "Confidence class lowered per Section B degradation rules. Per CC4 + inv-adm-governed-change-path-not-implicit: degradation é explicit governance act, NÃO silent confidence erosion."
			rationale:   "Per Phase 1.5.B Section B sensitivity model: confidence class transitions explicit. Distinct from suspension (temporary safety) e revocation (ontological invalidation)."
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "toConfidenceClass", type: "string"},
				{kind: "primitive", name: "degradationCause", type: "string"},
			]
		},
		{
			code:        "cmd-revoke-admissibility-certification"
			name:        "RevokeAdmissibilityCertification"
			description: "Certification permanently invalidated (confirmed strong negative evidence / operator revocation / provider capability withdrawn). Per Phase 1.5.B Section B: ontological invalidation distinct de suspension."
			rationale:   "Per inv-adm-governed-change-path-not-implicit: revocation é explicit governance act. In-flight bindings tratados per binding immutability rule — vide Projection #4 framing."
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "revocationCause", type: "string"},
			]
		},

		// === EXECUTION COMMANDS (9) — admissibility + binding + dispatch + fallback + escalation ===
		{
			code:        "cmd-validate-transport-contract-admissibility"
			name:        "ValidateTransportContractAdmissibility"
			description: "Issuing BC requests transport dispatch under declared contract. Triggers admissibility validation via svc-admissibility-certification-gate (C7 gate) antes de transport submission. Verdict: certified | refused | conservatism-deferred."
			rationale:   "Entry point canônico para execution path. Per C7: gate runs antes de transport — mechanical NÃO interpretive. Aggregate fields capturados em vo-transport-contract-declaration."
			fields: [
				{kind: "primitive", name: "transportContractDeclarationRef", type: "string"},
				{kind: "primitive", name: "issuerRef", type: "string"},
				{kind: "primitive", name: "payloadRef", type: "string"},
				{kind: "primitive", name: "fallbackPolicyRef", type: "string"},
				{kind: "primitive", name: "scopeContextRef", type: "string"},
			]
		},
		{
			code:        "cmd-emit-execution-certification-binding"
			name:        "EmitExecutionCertificationBinding"
			description: "Crystallize per-dispatch binding: certification snapshot + transport contract declaration + scope context + provider identity all locked at-time. Coordenado por svc-binding-integrity-dispatch. Binding é evidence-at-time, NÃO portable token."
			rationale:   "Per inv-adm-binding-evidence-at-time-not-portable-token: binding immutability rule canonical. Per founder Phase 3.3 ajuste #1: bindingOperationalStatus field distinguishes operational liveness from admissibility validity."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "providerIdentityRef", type: "string"},
			]
		},
		{
			code:        "cmd-dispatch-under-binding"
			name:        "DispatchUnderBinding"
			description: "Execute transport submission under emitted binding. Per inv-bdy-fallback-execution-only-not-decision: dispatch executes mechanically per binding, NÃO interprets."
			rationale:   "Materializa cap-contract-preserving-dispatch operacionalmente. Binding integrity preserved through dispatch — Layer 6 (dispatch) NUNCA pode reopen admissibility decided em Layer 1 (per founder Phase 3.1.B ajuste #5 constraint)."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "bindingRef", type: "string"},
			]
		},
		{
			code:        "cmd-emit-transport-confirmation"
			name:        "EmitTransportConfirmation"
			description: "Transport layer confirms delivery — emit confirmation event with explicit provenance class (provider-claim vs transport-observed). Per founder Phase 3.4 ajuste #1: 'independently observed transport fact' framing canonical — service emits fact-ontology when independently observed, claim-ontology when provider-claimed."
			rationale:   "Per inv-eps-claim-preserving-handling-vs-fact-preserving-handling + C10: claim vs fact preserved distinctly via provenance class field. Asymmetric suspicion weighting downstream-visible."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "observationProvenanceClass", type: "string"},
				{kind: "primitive", name: "independenceClassification", type: "string"},
			]
		},
		{
			code:        "cmd-emit-transport-failure"
			name:        "EmitTransportFailure"
			description: "Transport layer reports failure — emit failure event with failure class (transient/structural/provider-specific) + provenance class. Per CC1: transport-layer fact only — não behavioral inference."
			rationale:   "Per inv-bdy-ntf-never-derives-recipient-semantics: failure é transport-layer fact NÃO behavioral signal."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "failureClass", type: "string"},
				{kind: "primitive", name: "observationProvenanceClass", type: "string"},
			]
		},
		{
			code:        "cmd-execute-issuer-declared-fallback"
			name:        "ExecuteIssuerDeclaredFallback"
			description: "Mechanical fallback execution per issuer policy. Per C2: fallback authorization model — policy issuer-owned, execution NTF mechanical. NÃO infers fallback paths."
			rationale:   "Per inv-bdy-fallback-execution-only-not-decision: NTF executa per declared policy, NÃO interprets. Mechanical execution preserves separation."
			fields: [
				{kind: "primitive", name: "originalDispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "fallbackPolicyRef", type: "string"},
			]
		},
		{
			code:        "cmd-revoke-pending-dispatch"
			name:        "RevokePendingDispatch"
			description: "Issuer requests revocation of pending dispatch (não yet transport-attempted). Replay-forbidden dispatches escalated immediately (não revogation pathway)."
			rationale:   "Per C9: replay-forbidden lifecycle isolation. Revocation pathway distinct from replay-forbidden escalation."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "revocationCause", type: "string"},
			]
		},
		{
			code:        "cmd-escalate-replay-forbidden-failure"
			name:        "EscalateReplayForbiddenFailure"
			description: "Replay-forbidden message failed transport — escalate 'cannot replace via NTF — re-issue from source' per C9. NÃO retry pathway. Per inv-eps-replay-forbidden-failed-issuer-reissuance: re-issuance é issuer responsibility."
			rationale:   "Per founder Phase 3.1.C ajuste #4: failed replay-forbidden = issuer re-issuance responsibility. NTF refuses retry path por construção — coordenado por svc-replay-forbidden-isolation."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "failureCause", type: "string"},
			]
		},
		{
			code:        "cmd-route-receiver-confirmation"
			name:        "RouteReceiverConfirmation"
			description: "Receiver-side confirmation signal routed upstream untouched. Per C10: semantic interpretation by issuer, NÃO NTF."
			rationale:   "Per inv-bdy-receiver-confirmation-routed-untouched: receiver signals são routed, NÃO interpreted. Drift class #1 (decision leak) defended structurally."
			fields: [
				{kind: "primitive", name: "dispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "receiverConfirmationRef", type: "string"},
			]
		},
	]

	// =========================================================================
	// INVARIANTS — 16 total (tripartite: 5 boundary + 7 admissibility + 4 epistemic)
	// =========================================================================

	invariants: [
		// === BOUNDARY CLASS (5) — ontology preservation across heterogeneity ===
		{
			code: "inv-bdy-ntf-never-derives-recipient-semantics"
			name: "NTF nunca deriva semântica de recipient"
			rule: """
				NTF NÃO interpreta engagement, preferência, fadiga, intent,
				disengagement, OR qualquer behavioral inference about
				recipient from transport-layer observations (bounce,
				deliverability metrics, click-through, open rates).
				Transport-layer facts são facts; semantic interpretation
				stays upstream (issuer-owned). Tentativa structural de
				derive recipient semantics em NTF é violation — abort +
				escalate per drift class #5 (engagement gravity) + #9
				(observability-to-semantics drift).
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Materializa C3 (transport-layer truth interpretation
				boundary) + C5 (semantic-routing prohibition). Per founder
				Phase 3.1.A ajuste #3: rename canonical from
				'claim-preserving-semantics' para
				'never-derives-recipient-semantics' — rule scope é
				recipient inference forbiddance, NÃO claim-handling
				semantics (latter is inv-eps-1 territory).

				Institutional-resistant trait: pressão organizacional para
				'leverage NTF data for engagement intelligence' é vetor
				recorrente — esta invariant rejeita estructuralmente
				telemetry → behavioral inference pathway.

				Enforcement loci: svc-transport-truth-emission (emits
				transport-layer facts only — semantic interpretation
				upstream), telemetry capability constraint, drift class
				#5/#9 detection.
				"""
		},
		{
			code: "inv-bdy-no-substitution-without-class-equivalence"
			name: "Substituição de transporte requer equivalência de classe"
			rule: """
				NTF nunca substitui transport contract por contract
				diferente class quando original é admissible. Quando
				original Class-A-incompatible, NTF refuses (C7), não
				silently substitui por mais permissivo. Quando issuer
				declares fallback policy, fallbacks devem ser
				class-equivalent (e.g., tc-transactional-financial fallback
				MUST NOT degrade para tc-operational-update). Class
				preservation é structural property of contract.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, ontological-sensitive].

				Materializa C1 fidelity tripartition + bd-refusal-over-
				degradation. Sem esta invariant, NTF pode silently 'help
				delivery succeed' via class downgrade — fidelity erosion
				(drift class #2) catastrophic vector.

				Enforcement loci: svc-admissibility-certification-gate
				(class equivalence check per fallback evaluation),
				vo-transport-contract-declaration class identity check.
				"""
		},
		{
			code: "inv-bdy-fallback-execution-only-not-decision"
			name: "Fallback é executado, não decidido"
			rule: """
				NTF nunca decides which fallback path to take when policy
				is ambiguous OR underspecified. Fallback policy é issuer-
				owned (C2); NTF mechanical executor. When policy declares
				multiple paths sequentially, NTF tries in declared order
				with class-equivalence constraint (inv-bdy-2). When
				ambiguous policy, NTF refuses execution + escalates
				'fallback policy under-specified' to issuer — does NOT
				make policy decision FCE-internal-style.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, institutional-resistant].

				Materializa C2 + bd-refusal-over-degradation. Sem esta
				invariant, NTF lentamente acquires fallback decision
				authority — fallback decisions internalize into NTF
				policy engine (drift class #4 semantic coupling + #11
				evidence-to-policy gravity).

				Enforcement loci: svc-binding-integrity-dispatch (validates
				fallback policy specification completeness antes de
				execute), refusal pathway when policy ambiguous.
				"""
		},
		{
			code: "inv-bdy-provider-identity-binding-preserved"
			name: "Provider identity preservada no binding"
			rule: """
				ExecutionCertificationBinding includes providerIdentityRef
				explicit (per founder Phase 3.1.A ajuste #4). Binding é
				to-specific-provider-instance, NÃO to-abstract-provider-
				class. Provider identity change post-binding (M&A,
				infrastructure migration, mode change) triggers binding
				re-evaluation — NTF NÃO transparently substitutes
				underlying provider identity. Provider substitutability
				operates at certification level (NTP2), NÃO at binding
				level.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, ontological-sensitive].

				Materializa Phase 1.7 NTP2 (substitutability preservation
				at certification level) + C15 (non-transitivity).
				Provider identity binding distinction critical: same
				certification class can have multiple certified providers,
				but each binding fixes one specific provider — preserves
				audit chain integrity.

				Enforcement loci: vo-execution-certification-binding
				providerIdentityRef field, svc-binding-integrity-dispatch
				validation.
				"""
		},
		{
			code: "inv-bdy-receiver-confirmation-routed-untouched"
			name: "Receiver confirmation routed untouched"
			rule: """
				Receiver-side confirmation signals (delivery confirmation
				webhook, receipt acknowledgment, regulatory ACK) são
				routed upstream untouched. NTF não interpretation,
				normalization, scoring, OR semantic enrichment. Issuer
				semantic interpretation; NTF transport-layer router only.
				"""
			rationale: """
				Primary class: BOUNDARY.
				Secondary traits: [structural, ontological-sensitive].

				Materializa C10 (provider-claim epistemic limitation
				adjacent) + cap canvas inbound receiver-confirmation
				routing. Sem this rule, NTF derives recipient confirmation
				semantics — drift class #1 (decision leak) precursor.

				Enforcement loci: ReceiverConfirmationRouted event emits
				raw signal; cmd-route-receiver-confirmation pass-through;
				no internal interpretation pathway exists.
				"""
		},

		// === ADMISSIBILITY CLASS (7) — certification gate sovereignty + tier separation + scope-as-identity ===
		{
			code: "inv-adm-admissibility-conservatism-refuse-not-degrade"
			name: "Conservadorismo de admissibilidade refusa, não degrada"
			rule: """
				Default sob incerteza é refusal, NÃO admission with caveat
				NÃO 'safer transport' substitution. When evidence quality
				insufficient OR provenance independence inadequate OR
				scope boundary uncertain OR confidence class below
				threshold, NTF emits AdmissibilityConservatismTriggered
				(epistemic refusal) — never silently picks 'safer
				transport' on issuer's behalf. Refusal-as-success operational
				semantic per C7 + C11.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Per founder Phase 3.1.B ajuste #1: 'refuse not safer
				transport' framing explicit. NTF não has authority to
				pick alternative transport — that's issuer fallback policy
				domain (C2 + inv-bdy-3). Conservatism is refusal, NÃO
				helpful substitution.

				Materializa C11 (admissibility conservatism) + C7
				constitutional center. Sem esta invariant, NTF lentamente
				acquires substitution authority under 'helpful' framing.

				Enforcement loci: svc-admissibility-certification-gate
				conservatism check, AdmissibilityConservatismTriggered
				event emission distinct from helpful substitution.
				"""
		},
		{
			code: "inv-adm-binding-evidence-at-time-not-portable-token"
			name: "Binding é evidência-at-time, não token portável"
			rule: """
				ExecutionCertificationBinding crystallizes certification
				snapshot at-time-of-dispatch. Binding é evidence-at-time,
				NÃO portable token reusable across dispatches OR queryable
				as 'still valid'. Each dispatch creates fresh binding;
				certification mutations post-binding (degraded/revoked/
				suspended) do NOT retroactively invalidate already-emitted
				binding — they only affect future binding emissions per
				Projection #4 in-flight degraded binding visibility framing.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, temporal, epistemic-
				sensitive].

				Per founder Phase 3.1.B ajuste #2: binding é evidence-at-
				time not portable token — clarifica que binding semantics
				é snapshot-bound (immutable artifact), distinct from
				certification (lifecycle entity).

				Per founder Phase 3.7 ajuste #2: in-flight degraded
				binding é visibilidade de risco operacional, NÃO invalidação
				retroativa. Materialização canonical via Projection #4.

				Enforcement loci: vo-execution-certification-binding
				immutability (no mutation fields), bindingOperationalStatus
				distinct field for operational liveness.
				"""
		},
		{
			code: "inv-adm-scope-as-certification-identity"
			name: "Escopo é identidade da certificação"
			rule: """
				Certifications são scope-bounded canonically (C13). Scope
				é structural identity of certification, NÃO operational
				parameter modifiable post-issuance. Out-of-scope queries
				produce CertificationScopeExceeded event — refusal OR
				re-certification per issuer policy. Burst conditions,
				payload size exceeding envelope, geography outside admitted
				regions, provider mode beyond certified envelope todos
				trigger refusal mechanically.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Per founder Phase 3.1.B ajuste #3: 'scope as identity'
				framing canonical. Two same-named certifications with
				different scopes são distinct certifications — not 'same
				cert with different parameters'. Identity binding via
				scope.

				Materializa C13 + C15 + bd-scope-bounded-certification.
				Sem esta invariant, certifications drift universal
				('we've certified Twilio so we can use it for anything').

				Enforcement loci: vo-certification-scope-boundary as
				identity-bearing field, CertificationScopeExceeded
				detection per dispatch.
				"""
		},
		{
			code: "inv-adm-empirical-reliability-cannot-expand-ontology"
			name: "Confiabilidade empírica não expande ontologia"
			rule: """
				Production reliability observations NÃO grant capability
				certification absent verification evidence meeting class
				threshold (C12 + C14). 'Funciona na prática' canonical
				insufficient para certification expansion. 12 months
				production reliability sem methodology verification = stays
				uncertified for that class. Empirical performance é
				admissibility input only WITHIN already-certified envelope.
				Negative evidence model captures contradiction patterns —
				positive empirical observations cannot offset.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, epistemic-sensitive,
				institutional-resistant].

				Materializa C12 (observational contamination boundary) +
				C14 (evidence-vs-expansion asymmetry) + bd-empirical-
				reliability-cannot-expand-ontology. Defends contra
				'empirically justified drift' — the mecanismo pelo qual
				pragmatic accommodation erodes formal guarantees over time.

				Institutional-resistant trait: pressão operacional para
				'we've used Twilio for 12 months without issue, just admit
				it for evidentiary contracts' é vetor recorrente Phase 5+.

				Enforcement loci: svc-admissibility-certification-gate
				strict evidence-class-threshold check independent of
				operational telemetry, svc-evidence-substrate-maintenance
				negative-evidence-coexistence-with-positive rule.
				"""
		},
		{
			code: "inv-adm-tier-separation-never-collapsed"
			name: "Separação dos dois tiers nunca colapsa"
			rule: """
				Provider capability claims (Tier 1) NUNCA enter
				admissibility matrix (Tier 2) directly. Gate
				(svc-admissibility-certification-gate) é constitutional
				center between tiers — claim alone NÃO grants ontological
				admission per C14. Tier 1 e Tier 2 são distinct entities
				with distinct lifecycles; claim mutation does NOT mutate
				certification — gate must produce new certification act.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Per founder Phase 3.6 ajuste #3: 'gate consumes claim+
				evidence and issues separate Tier 2 certification' framing
				canonical — emphasizes distinct entity production.

				Materializa C8 (admissibility sovereignty) + bd-substrate-
				two-tier. Foundational constitutional clause — sem this,
				sistema collapses Tier 1 claims into Tier 2 silently
				(operational folklore precursor + drift class #6 precursor).

				Enforcement loci: ent-admissibility-certification +
				ent-provider-capability-claim distinct entities (não
				inheritance); svc-admissibility-certification-gate as
				distinct service producing distinct artifact.
				"""
		},
		{
			code: "inv-adm-no-implicit-substitution-into-tier-2"
			name: "Substituição implícita em Tier 2 proibida"
			rule: """
				Certification em Tier 2 NUNCA pode ser implicitly substituted
				por similar-looking certification of different scope/class/
				provider-mode/sensitivity. C15 non-transitivity canonical:
				certification for Twilio-SMS-BR-low-volume does NOT
				transitively imply certification for Twilio-SMS-LATAM-high-
				volume, Twilio-Email-BR, Twilio-Whatsapp-BR, OR Twilio-SMS-
				BR-evidentiary-class. Each requires explicit certification
				cycle.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Materializa C15 (certification non-transitivity and non-
				inheritance) — Phase 1.7 NEW constitutional clause.
				Defends against 'same provider, similar enough' silent
				expansion (oq-ntf-certification-transitivity-edge-cases-3
				canvas open question).

				Institutional-resistant trait: 'we've certified Twilio,
				just use it for the new contract class' é Phase 5+ vector
				recorrente — esta invariant rejeita estructuralmente.

				Enforcement loci: svc-admissibility-certification-gate
				scope+class+provider-mode identity check; explicit re-
				certification cycle obligatory.
				"""
		},
		{
			code: "inv-adm-governed-change-path-not-implicit"
			name: "Mudanças de certificação seguem caminho governado"
			rule: """
				Certification lifecycle mutations (issuance / degradation /
				suspension / revocation) ocorrem somente via explicit
				governance commands. Implicit mutations forbidden:
				empirical correlation NÃO triggers admission (inv-adm-4);
				silent confidence erosion NÃO triggers degradation (must
				be explicit cmd-degrade-admissibility-certification);
				operational accommodation NÃO triggers scope expansion.
				Every Tier 2 mutation produces explicit governance event
				with rationale.
				"""
			rationale: """
				Primary class: ADMISSIBILITY.
				Secondary traits: [structural, institutional-resistant].

				Per founder Phase 3.1.B ajuste #4: 'governed change path
				framing' explicit — change mechanism é structural property
				of certification lifecycle, NÃO operational convenience.

				Materializa CC4 (certification lifecycle explicit) + drift
				class #11 (evidence-to-policy gravity) defense + drift
				class #12 (refusal-reinterpretation gravity) defense.

				Institutional-resistant trait: 'temporary compatibility'
				narratives (oq-ntf-temporary-compatibility-narrative-6
				canvas open question) — esta invariant rejeita
				structurally.

				Enforcement loci: svc-admissibility-certification-gate as
				only mutation path; events emitted always via explicit
				commands; no implicit mutation pathway exists.
				"""
		},

		// === EPISTEMIC CLASS (4) — uncertainty handling + claim-vs-fact asymmetry + replay isolation ===
		{
			code: "inv-eps-claim-preserving-handling-vs-fact-preserving-handling"
			name: "Tratamento que preserva claim vs tratamento que preserva fato"
			rule: """
				Provider-confirmed observations (provider-claim ontology)
				são handled with HIGH suspicion weight (claim-preserving
				handling — claim labeled as claim, NÃO promoted to fact).
				Transport-observed observations (fact ontology) são handled
				with LOW suspicion weight (fact-preserving handling — direct
				transport-layer observation independently verifiable).
				Estas são distinct ontologies — NÃO single 'probabilistic
				suspicion weight' continuum. Asymmetric provenance class
				é canonical input para every downstream interpretation.
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Per founder Phase 3.1.C ajuste #1: rename canonical de
				'asymmetric suspicion weight' para 'claim-preserving
				handling vs fact-preserving handling' — distinct ontologies
				NÃO probability gradient. False-success catastrophic
				(provider claims success but rail failed); false-failure
				recoverable (provider claims failure but actually
				succeeded — operational re-check restores correctness).

				Materializa C10 (provider-claim epistemic limitation) +
				P9 (provider-claim vs transport-observed asymmetric
				ontology). Sem esta invariant, sistema collapses provider-
				claim into transport-fact silently — drift class #9 + #11
				catastrophic vector.

				Institutional-resistant trait: pressão para 'reduce
				provider-claim suspicion to improve delivery confidence
				metrics' é vetor recorrente — esta invariant rejeita
				estructuralmente categoria collapse.

				Enforcement loci: vo-observation-provenance class field
				(provider-claim / transport-observed / independence
				classification); svc-transport-truth-emission asymmetric
				handling per provenance class.
				"""
		},
		{
			code: "inv-eps-empirical-reliability-triggers-recertification-review-only"
			name: "Confiabilidade empírica dispara revisão de recertificação, não mutação direta"
			rule: """
				Empirical reliability observations (production telemetry
				patterns, sustained delivery success rates, sustained
				failure rates) NUNCA directly mutate certification state.
				Sustained empirical patterns crossing sensitivity threshold
				trigger RecertificationReviewTriggered event (per founder
				Phase 3.7 ajuste #1: review-only, NÃO mutation) —
				certification mutation depends on subsequent gate run via
				explicit governance commands.
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [structural, epistemic-sensitive,
				institutional-resistant].

				Per founder Phase 3.1.C ajuste #2: 'empirical reliability
				triggers recertification review only' framing canonical.
				Two-stage explicit: trigger creates evaluation obligation;
				gate run produces outcome. Defends against silent
				certification mutation driven by telemetry.

				Materializa C12 (observational contamination boundary) +
				C14 (evidence-vs-expansion asymmetry) + as-ntf-empirical-
				admissibility-independence-3.

				Enforcement loci: cmd-trigger-recertification-review é
				review-only (não certification mutation); subsequent
				cmd-issue/degrade/revoke are explicit governance commands
				gated by svc-admissibility-certification-gate.
				"""
		},
		{
			code: "inv-eps-truth-never-pays-partial"
			name: "Verdade nunca paga parcial"
			rule: """
				NTF never produces 'partially admissible' OR 'admissible
				with caveat' OR 'admissible under degraded class but called
				admissible' verdicts. Admissibility é binary: certified |
				refused | conservatism-deferred. There é no 'mostly
				admissible' — partialidade é structural betrayal of
				constitutional clause C7 (refuse rather than degrade) +
				C11 (conservatism). Equivalent ontologically a FCE 'não
				existe pagamento parcial da verdade'.
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [structural, ontological-sensitive,
				institutional-resistant].

				Per founder Phase 3.1.C ajuste #3: 'não existe pagamento
				parcial da verdade' framing canonical — paralelo
				arquitetural com FCE convergence integrity. Admissibility
				integrity é binary by construction; partial-admissibility
				é category error.

				Materializa C7 + C11 mechanically. Sem esta invariant,
				institutional pressure drives 'almost admissible, let it
				through with disclaimer' creep (drift class #12 refusal-
				reinterpretation gravity).

				Institutional-resistant trait: 'just admit it with a
				disclaimer' é Phase 5+ vector recorrente — esta invariant
				rejeita estructuralmente partialidade.

				Enforcement loci: svc-admissibility-certification-gate
				binary verdict (no partial state); event emission
				canonical (certified | refused | conservatism-triggered)
				without 'partially-certified' state.
				"""
		},
		{
			code: "inv-eps-replay-forbidden-failed-issuer-reissuance"
			name: "Replay-forbidden failure responsabiliza issuer pela re-emissão"
			rule: """
				When replay-forbidden message fails transport, NTF emits
				ReplayForbiddenFailureEscalated; issuer responsible for
				re-issuing from source (new semantic act, not retry). NTF
				NÃO has retry pathway for replay-forbidden — persistence/
				queue/DLQ/reprocessing flows são structurally segregated
				por replay dimension. Re-attempt via NTF para replay-
				forbidden é semantic identity corruption — OTP being
				re-sent (retry) vs new OTP issued (re-issuance).
				"""
			rationale: """
				Primary class: EPISTEMIC.
				Secondary traits: [structural, ontological-sensitive].

				Per founder Phase 3.1.C ajuste #4: 'failed replay-forbidden
				= issuer re-issuance responsibility' framing canonical.
				Replay-forbidden é ontological execution category (P8
				charter), NÃO operational policy — materialized via
				vo-replay-semantics-discriminator + isolated lifecycle
				branch + svc-replay-forbidden-isolation.

				Materializa C9 (replay-forbidden lifecycle isolation) +
				bd-replay-distinct-from-retry mechanically.

				Enforcement loci: svc-replay-forbidden-isolation (lifecycle
				segregation), state machine branch routes replay-forbidden
				failures para escalation event NÃO retry queue,
				vm-ntf-replay-forbidden-isolation verification metric.
				"""
		},
	]

	// =========================================================================
	// VALUE OBJECTS — 12 total
	// =========================================================================

	valueObjects: [
		{
			code:        "vo-admissibility-certification-snapshot"
			name:        "AdmissibilityCertificationSnapshot"
			description: "Imutable snapshot of Tier 2 certification state at moment of binding. Carries certification ref + confidence class + scope boundary + sensitivity context + evidence chain ref at-time. Used by ExecutionCertificationBinding to lock certification state into per-dispatch binding."
			fields: [
				{kind: "primitive", name: "certificationRef", type: "string"},
				{kind: "primitive", name: "transportContractClass", type: "string"},
				{kind: "primitive", name: "confidenceClass", type: "string"},
				{kind: "value-object-ref", name: "scopeBoundary", valueObjectRef: "vo-certification-scope-boundary"},
				{kind: "primitive", name: "evidenceChainRef", type: "string"},
				{kind: "primitive", name: "snapshotAt", type: "datetime"},
			]
			rationale: "Anchora term-admissibility-certification (glossary); materializa snapshot semantics canonical. Per inv-adm-binding-evidence-at-time-not-portable-token: snapshot é evidence-at-time, NÃO portable token — captures certification state como artifact imutable bound to specific dispatch instance."
		},
		{
			code:        "vo-execution-certification-binding"
			name:        "ExecutionCertificationBinding"
			description: "Per-dispatch binding crystallized at moment of admissibility certification for execution. Locks certification snapshot + transport contract declaration + scope context + provider identity. Binding é immutable artifact; certification mutations post-binding visible operationally via bindingOperationalStatus mas NÃO retroactively invalidate."
			fields: [
				{kind: "value-object-ref", name: "certificationSnapshot", valueObjectRef: "vo-admissibility-certification-snapshot"},
				{kind: "value-object-ref", name: "transportContractDeclaration", valueObjectRef: "vo-transport-contract-declaration"},
				{kind: "primitive", name: "providerIdentityRef", type: "string"},
				{kind: "primitive", name: "scopeContextRef", type: "string"},
				{kind: "primitive", name: "bindingOperationalStatus", type: "string"},
				{kind: "primitive", name: "boundAt", type: "datetime"},
			]
			rationale: "Materializa binding immutability canonical per inv-adm-binding-evidence-at-time-not-portable-token + inv-bdy-provider-identity-binding-preserved. Per founder Phase 3.3 ajuste #1: bindingOperationalStatus enumerable {active|degraded-cert-post-binding|certification-revoked-post-binding|completed|revoked|escalated} distinguishes operational liveness from admissibility validity — degraded post-binding NÃO invalidates retroactively per Phase 3.7 ajuste #2 (Projection #4 framing)."
		},
		{
			code:        "vo-certification-scope-boundary"
			name:        "CertificationScopeBoundary"
			description: "Structural identity-bearing scope of Tier 2 certification. Per inv-adm-scope-as-certification-identity: scope é structural property, NÃO operational parameter. Covers traffic envelope + geography + payload constraints + provider mode + environmental context."
			fields: [
				{kind: "primitive", name: "trafficEnvelope", type: "string"},
				{kind: "primitive", name: "geographyConstraint", type: "string"},
				{kind: "primitive", name: "payloadConstraint", type: "string"},
				{kind: "primitive", name: "providerMode", type: "string"},
				{kind: "primitive", name: "environmentalContext", type: "string"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
			]
			rationale: "Anchora term-certification-scope-boundary (glossary). Per C13 + C15: scope é identity-bearing. Out-of-scope queries produce CertificationScopeExceeded event — sem scope as identity, certifications drift universal."
		},
		{
			code:        "vo-observation-provenance"
			name:        "ObservationProvenance"
			description: "Canonical discriminator de origem ontológica de observation. Per P9 + inv-eps-claim-preserving-handling-vs-fact-preserving-handling: provider-claim ontology (HIGH suspicion) vs transport-observed ontology (LOW suspicion) são distinct categories — NÃO single probability gradient. Independence classification carries verification quality."
			fields: [
				{kind: "primitive", name: "provenanceClass", type: "string"},
				{kind: "primitive", name: "independenceClassification", type: "string"},
				{kind: "primitive", name: "observedAt", type: "datetime"},
				{kind: "primitive", name: "observerRef", type: "string"},
			]
			rationale: "Anchora term-observation-provenance (glossary); materializa asymmetric epistemic ontology canonical. provenanceClass enumerable {provider-claim | transport-observed | mixed-degraded}; independenceClassification enumerable {independent | provider-instrumented | unknown}. Per founder Phase 3.3 ajuste #3: provider-instrumented = non-independent constraint structural — provider cannot self-verify own capability per inv-adm-empirical-reliability-cannot-expand-ontology adjacent."
		},
		{
			code:        "vo-replay-semantics-discriminator"
			name:        "ReplaySemanticsDiscriminator"
			description: "Canonical discriminator de replay ontology canonical: replay-forbidden vs replayable vs system-bounded. Per P8 + C9: replay-forbidden é ontological execution category, NÃO operational policy — discriminator é structural property of message identity."
			fields: [
				{kind: "primitive", name: "replayClass", type: "string"},
				{kind: "primitive", name: "messageIdentityRef", type: "string"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
			]
			rationale: "Anchora term-replay-semantics (glossary); materializa P8 charter principle. replayClass enumerable {replay-forbidden | replayable | system-bounded}. Per bd-replay-distinct-from-retry: replay-forbidden discriminator é structural — drives state machine branch routing failures para escalation NÃO retry queue. OTP canonical example: replayClass=replay-forbidden + retry=none."
		},
		{
			code:        "vo-transport-contract-declaration"
			name:        "TransportContractDeclaration"
			description: "Issuer-declared contract carrying 7 dimensions canonical: ordering + durability + equivalence + retry + ack + replay + persistence. Carries fallback policy ref + scope context. Issuer-owned canonical structure; NTF validates admissibility, NÃO interprets semantics."
			fields: [
				{kind: "primitive", name: "contractClass", type: "string"},
				{kind: "primitive", name: "orderingDimension", type: "string"},
				{kind: "primitive", name: "durabilityDimension", type: "string"},
				{kind: "primitive", name: "equivalenceDimension", type: "string"},
				{kind: "primitive", name: "retryDimension", type: "string"},
				{kind: "primitive", name: "ackDimension", type: "string"},
				{kind: "value-object-ref", name: "replaySemantics", valueObjectRef: "vo-replay-semantics-discriminator"},
				{kind: "primitive", name: "fallbackPolicyRef", type: "string"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
			]
			rationale: "Anchora term-canonical-transport-contract (glossary). 6 canonical contract instances declared canvas Phase 1: tc-transactional-financial, tc-regulatory-evidentiary, tc-system-webhook, tc-operational-update, tc-alerting, tc-otp-single-use. contractClass references one of these instances."
		},
		{
			code:        "vo-provider-capability-claim-record"
			name:        "ProviderCapabilityClaimRecord"
			description: "Tier 1 substrate entry — assertion (com backing evidence pointer) que provider supports specific capability dimension. Per C10: claim é structural input para certification gate, NUNCA auto-promoted to admissibility absent gate passage."
			fields: [
				{kind: "primitive", name: "providerRef", type: "string"},
				{kind: "primitive", name: "transportContractDimension", type: "string"},
				{kind: "primitive", name: "claimedAt", type: "datetime"},
				{kind: "primitive", name: "verificationEvidenceRef", type: "string"},
				{kind: "primitive", name: "verificationMethod", type: "string"},
				{kind: "value-object-ref", name: "currentConfidence", valueObjectRef: "vo-confidence-class-snapshot"},
			]
			rationale: "Anchora term-provider-capability-claim (glossary). Foundational separation entity — Tier 1 distinct from Tier 2 per inv-adm-tier-separation-never-collapsed."
		},
		{
			code:        "vo-verification-evidence-record"
			name:        "VerificationEvidenceRecord"
			description: "Evidence artifact supporting Tier 1 claim. Carries verification methodology + evidence artifact pointer + independence classification + temporal validity. Per founder Phase 3.3 ajuste #2: supportsClaimRef sempre bound to specific claim; independence classification distinguishes independent verification from provider-instrumented evidence (latter is non-independent per construction)."
			fields: [
				{kind: "primitive", name: "supportsClaimRef", type: "string"},
				{kind: "primitive", name: "verificationMethod", type: "string"},
				{kind: "primitive", name: "evidenceArtifactRef", type: "string"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef: "vo-observation-provenance"},
				{kind: "primitive", name: "validatedAt", type: "datetime"},
				{kind: "primitive", name: "stalenessClass", type: "string"},
			]
			rationale: "Anchora term-verification-evidence (glossary); materializa evidence model canonical. Per inv-adm-empirical-reliability-cannot-expand-ontology: evidence é substrate-grounding requirement, NÃO can be substituted by empirical reliability."
		},
		{
			code:        "vo-confidence-class-snapshot"
			name:        "ConfidenceClassSnapshot"
			description: "Snapshot de confidence class assessment. Enumerable {strong | moderate | provisional | inadmissible}. Per Phase 1.3.B Section B sensitivity rules: confidence class transitions explicit (degradation event canonical)."
			fields: [
				{kind: "primitive", name: "confidenceClass", type: "string"},
				{kind: "primitive", name: "assessedAt", type: "datetime"},
				{kind: "primitive", name: "evidenceBasisRef", type: "string"},
			]
			rationale: "Anchora term-confidence-class (glossary). Per CC4 + inv-adm-governed-change-path-not-implicit: transitions são explicit governance events, NÃO silent erosion."
		},
		{
			code:        "vo-negative-capability-evidence"
			name:        "NegativeCapabilityEvidence"
			description: "Negative evidence artifact — failure/contradiction/drift observation that contradicts existing claim OR certification. Per inv-adm-empirical-reliability-cannot-expand-ontology: positive correlation cannot offset negative evidence — negative layer coexists com positive."
			fields: [
				{kind: "primitive", name: "affectsCertificationRef", type: "string"},
				{kind: "primitive", name: "evidenceArtifactRef", type: "string"},
				{kind: "primitive", name: "severity", type: "string"},
				{kind: "value-object-ref", name: "provenance", valueObjectRef: "vo-observation-provenance"},
				{kind: "primitive", name: "recordedAt", type: "datetime"},
			]
			rationale: "Anchora term-negative-capability-evidence (glossary). Per Phase 1.3.C Section C: strong negative triggers auto-revocation cascade; moderate triggers investigation cycle. Severity enumerable {strong | moderate | weak}."
		},
		{
			code:        "vo-fallback-policy-declaration"
			name:        "FallbackPolicyDeclaration"
			description: "Issuer-declared fallback path specification. Per C2: fallback policy é issuer-owned; NTF mechanical executor. Carries ordered fallback paths with class-equivalence constraint enforcement."
			fields: [
				{kind: "primitive", name: "primaryTransport", type: "string"},
				{kind: "primitive", name: "orderedFallbackPaths", type: "string"},
				{kind: "primitive", name: "classEquivalenceConstraint", type: "string"},
				{kind: "primitive", name: "declaredAt", type: "datetime"},
			]
			rationale: "Anchora cap-issuer-declared-fallback-execution. Per inv-bdy-fallback-execution-only-not-decision: NTF executes per policy; ambiguous policy triggers escalation, NÃO internal decision."
		},
		{
			code:        "vo-issuer-explicit-degradation-consent"
			name:        "IssuerExplicitDegradationConsent"
			description: "Rare canonical mechanism: issuer explicitly consents to specific degradation pathway with rationale documented. Per founder Phase 3.3 ajuste #4: issuerExplicitDegradationConsentRef materializa exception pathway via explicit issuer-owned consent — NÃO NTF-internal degradation authority."
			fields: [
				{kind: "primitive", name: "issuerRef", type: "string"},
				{kind: "primitive", name: "degradationPathwayRef", type: "string"},
				{kind: "primitive", name: "rationale", type: "string"},
				{kind: "primitive", name: "validityWindow", type: "string"},
				{kind: "primitive", name: "consentedAt", type: "datetime"},
			]
			rationale: "Distinct from NTF-internal degradation (forbidden por construção per C7 + C11 + inv-bdy-fallback-execution-only-not-decision). Issuer explicit consent é alternative pathway — preserves issuer ownership of semantic interpretation per C2 adjacent. Rare canonical mechanism; typical pathway é refusal."
		},
	]

	// =========================================================================
	// AGGREGATES — 1 (GuaranteeContractExecution single root with 2 nested entities)
	// =========================================================================

	aggregates: [
		{
			code:        "agg-guarantee-contract-execution"
			name:        "GuaranteeContractExecution"
			description: "Aggregate root central NTF. Carries lifecycle de per-dispatch admissibility-certified guarantee transport execution. Contains 2 nested entities: ent-admissibility-certification (Tier 2 certification entity, lifecycle owned) + ent-provider-capability-claim (Tier 1 claim entity, lifecycle owned). Gate é constitutional center between entities per inv-adm-tier-separation-never-collapsed."

			rootIdentity: {
				field: "guaranteeContractExecutionId"
				type: {kind: "primitive", type: "string"}
			}

			fields: [
				{kind: "value-object-ref", name: "transportContractDeclaration", valueObjectRef: "vo-transport-contract-declaration"},
				{kind: "value-object-ref", name: "binding", valueObjectRef: "vo-execution-certification-binding"},
				{kind: "value-object-ref", name: "fallbackPolicy", valueObjectRef: "vo-fallback-policy-declaration"},
				{kind: "value-object-ref", name: "issuerDegradationConsent", valueObjectRef: "vo-issuer-explicit-degradation-consent"},
				{kind: "primitive", name: "issuerRef", type: "string"},
				{kind: "primitive", name: "payloadRef", type: "string"},
				{kind: "primitive", name: "scopeContextRef", type: "string"},
				{kind: "primitive", name: "currentDispatchAttemptRef", type: "string"},
				{kind: "primitive", name: "createdAt", type: "datetime"},
			]

			entities: [
				{
					code:        "ent-admissibility-certification"
					name:        "AdmissibilityCertification"
					description: "Tier 2 entity canonical do substrate NTF — guarantee estructuralmente accepted into admissibility matrix após passar gate. Per inv-adm-tier-separation-never-collapsed: distinct entity from Tier 1 claim; gate consumes claim+evidence and issues separate Tier 2 certification (founder Phase 3.6 ajuste #3)."
					identity: {
						field: "certificationId"
						type: {kind: "primitive", type: "string"}
					}
					fields: [
						{kind: "primitive", name: "claimRef", type: "string"},
						{kind: "primitive", name: "transportContractClass", type: "string"},
						{kind: "value-object-ref", name: "currentConfidence", valueObjectRef: "vo-confidence-class-snapshot"},
						{kind: "value-object-ref", name: "scopeBoundary", valueObjectRef: "vo-certification-scope-boundary"},
						{kind: "primitive", name: "evidenceChainRef", type: "string"},
						{kind: "primitive", name: "lifecycleState", type: "string"},
						{kind: "primitive", name: "issuedAt", type: "datetime"},
					]
					usesValueObjects: [
						"vo-confidence-class-snapshot",
						"vo-certification-scope-boundary",
					]
					rationale: "Entity own identidade porque carries Tier 2 lifecycle distinct from per-dispatch binding. Multiple bindings can snapshot same certification at different times — entity preserves canonical identity. Não é aggregate root separado porque lifecycle integrally coupled a guarantee-contract-execution aggregate (per-dispatch admissibility is the operational unit)."
				},
				{
					code:        "ent-provider-capability-claim"
					name:        "ProviderCapabilityClaim"
					description: "Tier 1 entity canonical do substrate NTF — assertion (com backing evidence) que provider supports specific capability dimension. Per founder Phase 3.6 ajuste #3: gate consumes claim+evidence as inputs and produces separate Tier 2 certification — claim entity preserved as distinct artifact even after gate run."
					identity: {
						field: "claimId"
						type: {kind: "primitive", type: "string"}
					}
					fields: [
						{kind: "primitive", name: "providerRef", type: "string"},
						{kind: "primitive", name: "transportContractDimension", type: "string"},
						{kind: "primitive", name: "verificationEvidenceRefs", type: "string"},
						{kind: "primitive", name: "verificationMethod", type: "string"},
						{kind: "value-object-ref", name: "currentConfidence", valueObjectRef: "vo-confidence-class-snapshot"},
						{kind: "primitive", name: "lifecycleState", type: "string"},
						{kind: "primitive", name: "submittedAt", type: "datetime"},
					]
					usesValueObjects: [
						"vo-confidence-class-snapshot",
						"vo-verification-evidence-record",
						"vo-negative-capability-evidence",
					]
					rationale: "Entity own identidade porque carries Tier 1 lifecycle distinct from Tier 2 certification — claims accumulate evidence + may produce multiple distinct certifications over time (different scope/class). Não é aggregate root separado porque lifecycle integrally coupled ao gate process living dentro do mesmo aggregate."
				},
			]

			usesValueObjects: [
				"vo-admissibility-certification-snapshot",
				"vo-execution-certification-binding",
				"vo-certification-scope-boundary",
				"vo-observation-provenance",
				"vo-replay-semantics-discriminator",
				"vo-transport-contract-declaration",
				"vo-provider-capability-claim-record",
				"vo-verification-evidence-record",
				"vo-confidence-class-snapshot",
				"vo-negative-capability-evidence",
				"vo-fallback-policy-declaration",
				"vo-issuer-explicit-degradation-consent",
			]

			handlesCommands: [
				"cmd-submit-provider-capability-claim",
				"cmd-submit-verification-evidence",
				"cmd-submit-negative-capability-evidence",
				"cmd-issue-admissibility-certification",
				"cmd-refuse-admissibility-certification-issuance",
				"cmd-trigger-recertification-review",
				"cmd-degrade-admissibility-certification",
				"cmd-revoke-admissibility-certification",
				"cmd-validate-transport-contract-admissibility",
				"cmd-emit-execution-certification-binding",
				"cmd-dispatch-under-binding",
				"cmd-emit-transport-confirmation",
				"cmd-emit-transport-failure",
				"cmd-execute-issuer-declared-fallback",
				"cmd-revoke-pending-dispatch",
				"cmd-escalate-replay-forbidden-failure",
				"cmd-route-receiver-confirmation",
			]

			emitsEvents: [
				"evt-provider-capability-claim-submitted",
				"evt-verification-evidence-submitted",
				"evt-negative-capability-evidence-recorded",
				"evt-evidence-staleness-detected",
				"evt-admissibility-certification-issued",
				"evt-admissibility-certification-issuance-failed",
				"evt-admissibility-certification-degraded",
				"evt-admissibility-certification-suspended",
				"evt-admissibility-certification-revoked",
				"evt-recertification-review-triggered",
				"evt-capability-dependency-chain-impacted",
				"evt-dispatch-admissibility-certified",
				"evt-transport-contract-admissibility-refused",
				"evt-admissibility-conservatism-triggered",
				"evt-execution-certification-binding-emitted",
				"evt-dispatch-attempted",
				"evt-dispatch-confirmed-transport-layer",
				"evt-dispatch-failed-transport-layer",
				"evt-pending-dispatch-revoked",
				"evt-fallback-executed",
				"evt-fallback-unavailable",
				"evt-receiver-confirmation-routed",
				"evt-replay-forbidden-failure-escalated",
				"evt-certification-scope-exceeded",
			]

			protectsInvariants: [
				"inv-bdy-ntf-never-derives-recipient-semantics",
				"inv-bdy-no-substitution-without-class-equivalence",
				"inv-bdy-fallback-execution-only-not-decision",
				"inv-bdy-provider-identity-binding-preserved",
				"inv-bdy-receiver-confirmation-routed-untouched",
				"inv-adm-admissibility-conservatism-refuse-not-degrade",
				"inv-adm-binding-evidence-at-time-not-portable-token",
				"inv-adm-scope-as-certification-identity",
				"inv-adm-empirical-reliability-cannot-expand-ontology",
				"inv-adm-tier-separation-never-collapsed",
				"inv-adm-no-implicit-substitution-into-tier-2",
				"inv-adm-governed-change-path-not-implicit",
				"inv-eps-claim-preserving-handling-vs-fact-preserving-handling",
				"inv-eps-empirical-reliability-triggers-recertification-review-only",
				"inv-eps-truth-never-pays-partial",
				"inv-eps-replay-forbidden-failed-issuer-reissuance",
			]

			lifecycle: {
				initialState: "AwaitingAdmissibilityValidation"
				states: [
					"AwaitingAdmissibilityValidation",
					"AdmissibilityCertifiedForDispatch",
					"AdmissibilityRefused",
					"AdmissibilityConservatismDeferred",
					"BindingEmitted",
					"DispatchAttempted",
					"DeliveryConfirmedTransportLayer",
					"DeliveryFailedTransportLayer",
					"ReplayForbiddenEscalated",
					"PendingDispatchRevoked",
					"FallbackUnavailable",
				]
				transitions: [
					{
						from:               "AwaitingAdmissibilityValidation"
						to:                 "AdmissibilityCertifiedForDispatch"
						triggeredByCommand: "cmd-validate-transport-contract-admissibility"
						emitsEvents: ["evt-dispatch-admissibility-certified"]
						guards: [
							"inv-adm-tier-separation-never-collapsed",
							"inv-adm-scope-as-certification-identity",
							"inv-adm-no-implicit-substitution-into-tier-2",
							"inv-adm-admissibility-conservatism-refuse-not-degrade",
							"inv-eps-truth-never-pays-partial",
						]
						description: "Gate runs admissibility validation; certification snapshot ready para binding emission."
					},
					{
						from:               "AwaitingAdmissibilityValidation"
						to:                 "AdmissibilityRefused"
						triggeredByCommand: "cmd-validate-transport-contract-admissibility"
						emitsEvents: ["evt-transport-contract-admissibility-refused"]
						guards: [
							"inv-bdy-no-substitution-without-class-equivalence",
							"inv-eps-truth-never-pays-partial",
						]
						description: "Class A/B1/B2/C incompatibility detected; refusal canonical per C7."
					},
					{
						from:               "AwaitingAdmissibilityValidation"
						to:                 "AdmissibilityConservatismDeferred"
						triggeredByCommand: "cmd-validate-transport-contract-admissibility"
						emitsEvents: ["evt-admissibility-conservatism-triggered"]
						guards: [
							"inv-adm-admissibility-conservatism-refuse-not-degrade",
							"inv-adm-empirical-reliability-cannot-expand-ontology",
						]
						description: "Epistemic uncertainty triggered conservatism per C11; refusal-for-uncertainty distinct de structural impossibility."
					},
					{
						from:               "AdmissibilityCertifiedForDispatch"
						to:                 "BindingEmitted"
						triggeredByCommand: "cmd-emit-execution-certification-binding"
						emitsEvents: ["evt-execution-certification-binding-emitted"]
						guards: [
							"inv-adm-binding-evidence-at-time-not-portable-token",
							"inv-bdy-provider-identity-binding-preserved",
						]
						description: "Per-dispatch binding crystallized; certification snapshot + transport contract + scope + provider identity locked."
					},
					{
						from:               "BindingEmitted"
						to:                 "DispatchAttempted"
						triggeredByCommand: "cmd-dispatch-under-binding"
						emitsEvents: ["evt-dispatch-attempted"]
						guards: [
							"inv-bdy-fallback-execution-only-not-decision",
							"inv-adm-binding-evidence-at-time-not-portable-token",
						]
						description: "Transport submission under binding. Layer 6 dispatch NUNCA reopens Layer 1 admissibility."
					},
					{
						from:               "BindingEmitted"
						to:                 "PendingDispatchRevoked"
						triggeredByCommand: "cmd-revoke-pending-dispatch"
						emitsEvents: ["evt-pending-dispatch-revoked"]
						guards: ["inv-eps-replay-forbidden-failed-issuer-reissuance"]
						description: "Issuer-initiated revocation pre-dispatch. Replay-forbidden via guard rejects retry pathway."
					},
					{
						from:               "DispatchAttempted"
						to:                 "DeliveryConfirmedTransportLayer"
						triggeredByCommand: "cmd-emit-transport-confirmation"
						emitsEvents: ["evt-dispatch-confirmed-transport-layer"]
						guards: [
							"inv-eps-claim-preserving-handling-vs-fact-preserving-handling",
							"inv-bdy-ntf-never-derives-recipient-semantics",
						]
						description: "Transport layer confirmed delivery; provenance class explicit (provider-claim vs transport-observed asymmetric ontology)."
					},
					{
						from:               "DispatchAttempted"
						to:                 "DeliveryFailedTransportLayer"
						triggeredByCommand: "cmd-emit-transport-failure"
						emitsEvents: ["evt-dispatch-failed-transport-layer"]
						guards: [
							"inv-bdy-ntf-never-derives-recipient-semantics",
							"inv-eps-claim-preserving-handling-vs-fact-preserving-handling",
						]
						description: "Transport layer reported failure; failure class explicit. Non-replay-forbidden failures may trigger fallback via policy."
					},
					{
						from:               "DispatchAttempted"
						to:                 "ReplayForbiddenEscalated"
						triggeredByCommand: "cmd-escalate-replay-forbidden-failure"
						emitsEvents: ["evt-replay-forbidden-failure-escalated"]
						guards: ["inv-eps-replay-forbidden-failed-issuer-reissuance"]
						description: "Replay-forbidden message failed; escalate 'cannot replace via NTF — re-issue from source' per C9. NÃO retry path."
					},
					{
						from:               "DeliveryFailedTransportLayer"
						to:                 "DispatchAttempted"
						triggeredByCommand: "cmd-execute-issuer-declared-fallback"
						emitsEvents: ["evt-fallback-executed"]
						guards: [
							"inv-bdy-no-substitution-without-class-equivalence",
							"inv-bdy-fallback-execution-only-not-decision",
						]
						description: "Issuer-declared fallback path activated per C2; class-equivalence preserved per inv-bdy-2."
					},
					{
						from:               "DeliveryFailedTransportLayer"
						to:                 "FallbackUnavailable"
						triggeredByCommand: "cmd-execute-issuer-declared-fallback"
						emitsEvents: ["evt-fallback-unavailable"]
						guards: ["inv-bdy-fallback-execution-only-not-decision"]
						description: "No admissible fallback per issuer policy; escalation back to issuer — NÃO NTF degradation."
					},
					{
						from:               "DeliveryConfirmedTransportLayer"
						to:                 "DeliveryConfirmedTransportLayer"
						triggeredByCommand: "cmd-route-receiver-confirmation"
						emitsEvents: ["evt-receiver-confirmation-routed"]
						guards: ["inv-bdy-receiver-confirmation-routed-untouched"]
						description: "Receiver-side confirmation signal routed untouched. Self-loop por design — receiver confirmation NÃO mutes terminal state (terminal já alcançado)."
					},
					{
						from:               "AdmissibilityCertifiedForDispatch"
						to:                 "PendingDispatchRevoked"
						triggeredByCommand: "cmd-revoke-pending-dispatch"
						emitsEvents: ["evt-pending-dispatch-revoked"]
						guards: ["inv-eps-replay-forbidden-failed-issuer-reissuance"]
						description: "Issuer revokes after admissibility certified but before binding emission."
					},
				]
			}

			consistencyBoundary: {
				guarantees: [
					"Atomicidade transacional intra-aggregate: gate decisão é atomic produces certification OR refusal; binding emission é atomic ato.",
					"Lifecycle state machine: 11 states + 13 transitions com guards canonical; no implicit transitions.",
					"Tier 1 ↔ Tier 2 separation intra-aggregate: ent-provider-capability-claim e ent-admissibility-certification são distinct entities; gate consumes claim+evidence and issues separate certification.",
					"Binding immutability: vo-execution-certification-binding emitido é immutable; bindingOperationalStatus visible operationally NÃO mutates binding identity.",
				]
				explicitlyDoesNotGuarantee: [
					"Cross-BC consistency com issuing BCs em tempo real — eventual via published events.",
					"Cross-BC consistency com provider ecosystem — eventual via consumed events under asymmetric provenance semantics.",
					"Retroactive certification consistency for in-flight bindings — bindings preserve at-time semantics per inv-adm-binding-evidence-at-time-not-portable-token; Projection #4 surfaces in-flight degraded bindings as operational risk visibility (não retroactive invalidation).",
				]
				failureModes: [
					"Admissibility refusal: canonical first-class outcome (não failure ontologically).",
					"Conservatism deferred: epistemic uncertainty path explicit (não silent ignore).",
					"Replay-forbidden failure: escalation pathway exclusive (NÃO retry path).",
					"Fallback unavailable: escalation back to issuer (NÃO NTF improvises).",
					"Provider claim → certification gate refusal: claim preserved Tier 1; certification NÃO produced.",
				]
				rationale: "Per adr-081: consistency boundary intra-aggregate é atomic; cross-aggregate + cross-BC é eventual via events. Tier 1/Tier 2 separation intra-aggregate via nested entities preserva constitutional clause C8 (admissibility sovereignty)."
			}

			rationale: """
				Single aggregate root do BC NTF. Aggregate é consequência
				arquitetural de invariantes (16 tripartite) + bipartite
				state machine (Layer 1 substrate authority + Layer 2
				dependent operational lifecycle) + value objects (12) +
				services (6 admissibility guardians) — não estrutura
				primária per P6.

				Single-aggregate decision: GuaranteeContractExecution
				centraliza per-dispatch lifecycle porque transaction
				boundaries do BC convergem ao binding emission act. Tier
				1 (ent-provider-capability-claim) e Tier 2 (ent-
				admissibility-certification) modeladas como nested
				entities (não aggregates separados) porque lifecycle
				integrally coupled ao gate process living dentro do mesmo
				transactional boundary.

				Per founder Phase 3.6 ajuste #3: 'gate consumes claim+
				evidence and issues separate Tier 2 certification' framing
				canonical — entity gate é constitutional center between
				distinct entities (não claim mutation in-place).

				Bipartite state machine materialization:
				- Layer 1 (SubstrateAuthorityState): vivido via ent-
				  admissibility-certification.lifecycleState +
				  ent-provider-capability-claim.lifecycleState (Tier 1/
				  Tier 2 lifecycles).
				- Layer 2 (DependentOperationalState): vivido via
				  aggregate.lifecycle (11 states + 13 transitions). Layer
				  2 BINDS A snapshot of Layer 1 at time of binding
				  emission; Layer 2 NUNCA pode reopen Layer 1 decisions
				  (per founder Phase 3.1.B constraint).

				Lifecycle 11 states cobertura: AwaitingAdmissibilityValidation
				(initial), AdmissibilityCertifiedForDispatch (gate passed),
				AdmissibilityRefused (terminal — C7 refusal first-class),
				AdmissibilityConservatismDeferred (terminal — C11
				epistemic refusal), BindingEmitted (per-dispatch binding
				crystallized), DispatchAttempted (transport submission),
				DeliveryConfirmedTransportLayer / DeliveryFailedTransport
				Layer (transport-layer facts), ReplayForbiddenEscalated
				(C9 isolation), PendingDispatchRevoked (issuer revocation),
				FallbackUnavailable (escalation back to issuer). 13
				transitions com guards canonical per invariants tripartite.
				"""
		},
	]

	// =========================================================================
	// DOMAIN SERVICES — 6 (admissibility guardians per P4)
	// =========================================================================

	domainServices: [
		{
			code:        "svc-admissibility-certification-gate"
			name:        "AdmissibilityCertificationGate"
			description: "Admissibility guardian de gate sovereignty (C8). Consumes claim + evidence Tier 1 inputs and produces Tier 2 certification (issue OR refuse). Per founder Phase 3.6 ajuste #3: gate produces separate certification entity, NÃO claim mutation in-place. Conservatism check (C11) under uncertainty. Falha → refusal explicit (NÃO 'maybe certified')."
			orchestrates: ["agg-guarantee-contract-execution"]
			rationale:    "Materializa cap-admissibility-certification-issuance + constitutional center C8 + bd-substrate-two-tier. Admissibility guardian P4: protege constitutional admissibility sovereignty, NÃO 'certification throughput'. Per inv-adm-tier-separation-never-collapsed + inv-adm-admissibility-conservatism-refuse-not-degrade + inv-adm-empirical-reliability-cannot-expand-ontology."
		},
		{
			code:        "svc-binding-integrity-dispatch"
			name:        "BindingIntegrityDispatchService"
			description: "Admissibility guardian de binding integrity. Crystallizes per-dispatch binding (certification snapshot + transport contract + scope + provider identity) at-time; validates Layer 6 dispatch NÃO reopens Layer 1 admissibility; preserves bindingOperationalStatus visible distinct de admissibility validity. Falha → refuse dispatch + escalate, jamais bypass binding."
			orchestrates: ["agg-guarantee-contract-execution"]
			rationale:    "Materializa cap-contract-preserving-dispatch + cap-issuer-declared-fallback-execution operacionalmente. Admissibility guardian P4: protege inv-adm-binding-evidence-at-time-not-portable-token + inv-bdy-provider-identity-binding-preserved + inv-bdy-no-substitution-without-class-equivalence + inv-bdy-fallback-execution-only-not-decision."
		},
		{
			code:        "svc-transport-truth-emission"
			name:        "TransportTruthEmissionService"
			description: "Admissibility guardian de transport-layer truth ontology. Emits transport-layer facts only com explicit provenance class (provider-claim vs transport-observed asymmetric). Per founder Phase 3.4 ajuste #1: 'independently observed transport fact' framing canonical — service emits fact-ontology when independently observed, claim-ontology when provider-claimed. Behavioral inference forbidden por C3."
			orchestrates: ["agg-guarantee-contract-execution"]
			rationale:    "Materializa cap-transport-telemetry-emission operacionalmente. Admissibility guardian P4: protege inv-eps-claim-preserving-handling-vs-fact-preserving-handling + inv-bdy-ntf-never-derives-recipient-semantics + inv-bdy-receiver-confirmation-routed-untouched. Per CC1 + CC3."
		},
		{
			code:        "svc-evidentiary-audit-integrity"
			name:        "EvidentiaryAuditIntegrityService"
			description: "Admissibility guardian de evidentiary audit chain integrity. Maintains court-grade audit trail per regulatory dimension (cryptographic chain + immutable storage). Audit chain consumed externally para regulatory purposes; NÃO feeds policy engine internally (defends drift class #10)."
			orchestrates: ["agg-guarantee-contract-execution"]
			rationale:    "Materializa cap-evidentiary-audit-generation. Admissibility guardian P4: protege C6 generic-touches-legal-evidence-boundary + tc-regulatory-evidentiary canonical contract integrity + drift class #10 (audit-to-control gravity) defense."
		},
		{
			code:        "svc-evidence-substrate-maintenance"
			name:        "EvidenceSubstrateMaintenanceService"
			description: "Admissibility guardian de evidence substrate lifecycle. Operates evidence lifecycle (claims + verification cycles + revocation + degradation + staleness detection) per confidence class sensitivity schedule. Per founder Phase 3.4 ajuste #2: este service NUNCA invokes cmd-issue-admissibility-certification directly — apenas triggers recertification review which goes through gate."
			orchestrates: ["agg-guarantee-contract-execution"]
			rationale:    "Materializa cap-transport-capability-evidence-maintenance. Admissibility guardian P4: protege inv-eps-empirical-reliability-triggers-recertification-review-only + inv-adm-governed-change-path-not-implicit + bd-evidence-as-substrate. Service mantém substrate; gate decide promotions — separation preserved per founder ajuste."
		},
		{
			code:        "svc-replay-forbidden-isolation"
			name:        "ReplayForbiddenIsolationService"
			description: "Admissibility guardian de replay-forbidden lifecycle isolation. Segregates replay-forbidden dispatches from persistence/queue/DLQ/reprocessing flows; routes failures para escalation (NÃO retry queue). Per P8 + C9: replay-forbidden é ontological execution category, NÃO operational policy."
			orchestrates: ["agg-guarantee-contract-execution"]
			rationale:    "Materializa bd-replay-distinct-from-retry operacionalmente. Admissibility guardian P4: protege inv-eps-replay-forbidden-failed-issuer-reissuance + C9 + vm-ntf-replay-forbidden-isolation. Critical para OTP + single-use semantic contracts."
		},
	]

	// =========================================================================
	// POLICIES — 4
	// =========================================================================

	policies: [
		{
			code:        "pol-on-verification-evidence-trigger-recertification-review"
			name:        "OnVerificationEvidenceTriggerRecertificationReview"
			description: "Quando VerificationEvidence submitted impacting existing certification, trigger recertification review (NÃO mutation direct). Per founder Phase 3.7 ajuste #1: review-only — certification mutation depends on subsequent gate run via explicit governance commands."
			triggeredByEvent: "evt-verification-evidence-submitted"
			issuesCommand:    "cmd-trigger-recertification-review"
			guards: [
				"inv-eps-empirical-reliability-triggers-recertification-review-only",
				"inv-adm-governed-change-path-not-implicit",
			]
			rationale: "Evidence submission é Tier 1 substrate event; certification mutation é Tier 2 governance act. Policy bridges via review trigger — preserves two-stage governance path per inv-adm-tier-separation-never-collapsed + inv-adm-governed-change-path-not-implicit."
		},
		{
			code:        "pol-on-negative-evidence-trigger-recertification-review"
			name:        "OnNegativeEvidenceTriggerRecertificationReview"
			description: "Quando NegativeCapabilityEvidence recorded against existing certification, trigger recertification review. Per founder Phase 3.7 ajuste #1: review-only; subsequent gate decisão produces explicit mutation event (degrade/suspend/revoke per severity)."
			triggeredByEvent: "evt-negative-capability-evidence-recorded"
			issuesCommand:    "cmd-trigger-recertification-review"
			guards: [
				"inv-eps-empirical-reliability-triggers-recertification-review-only",
				"inv-adm-governed-change-path-not-implicit",
				"inv-adm-empirical-reliability-cannot-expand-ontology",
			]
			rationale: "Negative evidence é canonical input para certification lifecycle mutation, mas via two-stage explicit governance (review then gate decisão). Defends silent revocation drift mesmo sob strong negative — gate must run explicit."
		},
		{
			code:        "pol-on-provider-capability-change-trigger-dependency-cascade"
			name:        "OnProviderCapabilityChangeTriggerDependencyCascade"
			description: "Quando provider ecosystem capability change observed, trigger dependency cascade evaluation per Phase 1.5.B Section C: load-bearing → revocation; supporting → suspension; auxiliary → re-verification trigger."
			triggeredByEvent: "evt-provider-capability-change-notified"
			issuesCommand:    "cmd-trigger-recertification-review"
			guards: ["inv-adm-governed-change-path-not-implicit"]
			rationale: "Provider capability lifecycle drives cascading certification lifecycle response. Per Phase 3.7 ajuste #1: trigger recertification review canonical pathway — actual cascade outcome (revoke/suspend/re-verify) decided via subsequent gate run."
		},
		{
			code:        "pol-on-evidence-staleness-trigger-recertification-review"
			name:        "OnEvidenceStalenessTriggerRecertificationReview"
			description: "Quando evidence aging crosses sensitivity threshold (30/90/180 days per confidence class per Section B), trigger recertification review."
			triggeredByEvent: "evt-evidence-staleness-detected"
			issuesCommand:    "cmd-trigger-recertification-review"
			guards: [
				"inv-eps-empirical-reliability-triggers-recertification-review-only",
				"inv-adm-governed-change-path-not-implicit",
			]
			rationale: "Temporal dimension de evidence model materializada via staleness → review trigger pathway. Per Phase 3.7 ajuste #1: temporal triggers (staleness) tratados consistently com empirical triggers — review-only, gate produces outcome."
		},
	]

	// =========================================================================
	// PROJECTIONS — 4 (read models last per P6: collapse ontology into views)
	// =========================================================================

	projections: [
		{
			code:        "prj-certification-state-view"
			name:        "CertificationStateView"
			description: "Read model derivado de Tier 1 e Tier 2 substrate events. Surface canonical para QueryCertificationState — observer queries current certification state for transport class."
			consumesEvents: [
				"evt-provider-capability-claim-submitted",
				"evt-verification-evidence-submitted",
				"evt-negative-capability-evidence-recorded",
				"evt-evidence-staleness-detected",
				"evt-admissibility-certification-issued",
				"evt-admissibility-certification-issuance-failed",
				"evt-admissibility-certification-degraded",
				"evt-admissibility-certification-suspended",
				"evt-admissibility-certification-revoked",
				"evt-recertification-review-triggered",
				"evt-capability-dependency-chain-impacted",
			]
			queryCapabilities: [
				{
					code:        "qry-certification-state-by-transport-class"
					description: "Recupera Tier 1 claims + Tier 2 certifications + confidence class + scope boundary para transport contract class específica."
					rationale:   "Query canonical AdmissibilityPreflightCheck (canvas inbound)."
				},
				{
					code:        "qry-certification-history-by-cert-id"
					description: "Histórico de lifecycle events para certification specific."
					rationale:   "Audit trail surface para certification lifecycle inspection."
				},
			]
			rationale: "Per P6: projection collapses certification ontology em view. Per inv-adm-tier-separation-never-collapsed: view preserves Tier 1/Tier 2 distinction surface — sem this, queries silently collapse tiers."
		},
		{
			code:        "prj-delivery-attempt-lifecycle-view"
			name:        "DeliveryAttemptLifecycleView"
			description: "Read model derivado de execution lifecycle events. Flattens 11 states + 13 transitions em view consultável por dispatch attempt refs. Preserves observation provenance class explicit (provider-claim vs transport-observed)."
			consumesEvents: [
				"evt-dispatch-admissibility-certified",
				"evt-transport-contract-admissibility-refused",
				"evt-admissibility-conservatism-triggered",
				"evt-execution-certification-binding-emitted",
				"evt-dispatch-attempted",
				"evt-dispatch-confirmed-transport-layer",
				"evt-dispatch-failed-transport-layer",
				"evt-pending-dispatch-revoked",
				"evt-fallback-executed",
				"evt-fallback-unavailable",
				"evt-receiver-confirmation-routed",
				"evt-replay-forbidden-failure-escalated",
				"evt-certification-scope-exceeded",
			]
			queryCapabilities: [
				{
					code:        "qry-delivery-attempt-by-id"
					description: "Recupera lifecycle history + provenance + binding ref para dispatch attempt specific."
					rationale:   "Operational visibility canonical para per-dispatch diagnosis."
				},
				{
					code:        "qry-delivery-attempts-by-issuer"
					description: "Lista dispatch attempts associados a issuer + canonical contract class."
					rationale:   "Supports cross-BC query surface (issuing BC consumers)."
				},
			]
			rationale: "Per P6: projection collapses execution lifecycle em view com provenance class preservada — sem this, queries silently collapse provider-claim into transport-fact (drift class #9 vector)."
		},
		{
			code:        "prj-evidentiary-audit-trail"
			name:        "EvidentiaryAuditTrail"
			description: "Court-grade audit trail derivado de regulatory + financial dispatch events. Cryptographic chain + immutable references + provenance preserved. Surface canonical para RequestEvidentiaryAuditReconstruction (canvas inbound query)."
			consumesEvents: [
				"evt-dispatch-admissibility-certified",
				"evt-execution-certification-binding-emitted",
				"evt-dispatch-attempted",
				"evt-dispatch-confirmed-transport-layer",
				"evt-dispatch-failed-transport-layer",
				"evt-receiver-confirmation-routed",
				"evt-admissibility-certification-issued",
				"evt-transport-contract-admissibility-refused",
			]
			queryCapabilities: [
				{
					code:        "qry-evidentiary-reconstruction-by-correlation"
					description: "Reconstruct court-grade audit trail per correlation ref (regulatory case ID, financial dispatch ID)."
					rationale:   "Materializa C6 generic-touches-legal-evidence-boundary surface."
				},
			]
			rationale: "Per P6 + svc-evidentiary-audit-integrity: projection consumed externally para regulatory purposes; NÃO feeds policy engine internally (drift class #10 defense)."
		},
		{
			code:        "prj-binding-operational-status-view"
			name:        "BindingOperationalStatusView"
			description: "Read model focused em binding operational status. Surface para in-flight degraded binding visibility — per founder Phase 3.7 ajuste #2: visibilidade de risco operacional, NÃO invalidação retroativa. Bindings emitidos sob certification posteriormente degradada permanecem admissibility-valid (per inv-adm-binding-evidence-at-time-not-portable-token), mas surface operacional visibility para downstream decisão de proceder/abandonar/re-issue."
			consumesEvents: [
				"evt-execution-certification-binding-emitted",
				"evt-admissibility-certification-degraded",
				"evt-admissibility-certification-suspended",
				"evt-admissibility-certification-revoked",
				"evt-dispatch-attempted",
				"evt-dispatch-confirmed-transport-layer",
				"evt-dispatch-failed-transport-layer",
			]
			queryCapabilities: [
				{
					code:        "qry-in-flight-degraded-bindings"
					description: "Lista bindings ativos cuja certification subjacente foi degraded/suspended/revoked post-binding (status=degraded-cert-post-binding | certification-revoked-post-binding). Operational risk surface — NÃO declares bindings invalid."
					rationale:   "Per founder Phase 3.7 ajuste #2: surface operational risk visibility distinct from retroactive invalidation. Issuer/operator decide proceder OR escalate per their semantics; NTF NÃO retroactively invalidates."
				},
				{
					code:        "qry-binding-by-attempt"
					description: "Recupera binding ref + operational status + certification snapshot at-time + downstream lifecycle state para dispatch attempt specific."
					rationale:   "Operational diagnosis canonical para per-binding inspection."
				},
			]
			rationale: "Per founder Phase 3.7 ajuste #2: 'in-flight degraded binding é visibilidade de risco operacional, NÃO invalidação retroativa'. Materializa inv-adm-binding-evidence-at-time-not-portable-token operational surface — sem this view explicit, sistema either retroactively invalidates (constitutional violation) OR silently hides risk (governance failure). Surface visibility é canonical middle path."
		},
	]

	// =========================================================================
	// INTERPRETATION CONTRACTS (per adr-081)
	// =========================================================================

	systemConsistencyModel: {
		type: "eventual"
		intraAggregateGuarantees: [
			"Atomicidade transacional intra-aggregate: gate decisão atomic, binding emission atomic, lifecycle transitions single-step com guards canonical.",
			"Tier 1 ↔ Tier 2 separation intra-aggregate: ent-provider-capability-claim e ent-admissibility-certification são distinct nested entities; gate consumes claim+evidence and produces separate certification entity.",
			"Bipartite state machine: Layer 1 (substrate authority) ⊕ Layer 2 (dependent operational); Layer 2 binds snapshot of Layer 1; Layer 2 NUNCA reopens Layer 1 decisions.",
			"Binding immutability: vo-execution-certification-binding emitido é immutable; bindingOperationalStatus visible operationally NÃO mutates binding identity.",
		]
		crossAggregateGuarantees: [
			"Cross-BC eventual consistency com 12+ issuing BCs (FCE, BKR, CMT, DLV, IDC, INV, BDG, REW, NPM, P2P, CTR, SSC, + future) via published events.",
			"Cross-BC eventual consistency com provider ecosystem via consumed events under asymmetric provenance semantics (provider-claim HIGH suspicion + transport-observed LOW suspicion).",
			"Downstream consumers (audit/observability) consomem published lifecycle events sob eventual semantics — court-grade audit chain canonical via prj-evidentiary-audit-trail.",
		]
		explicitlyDoesNotGuarantee: [
			"Strong consistency cross-BC em tempo real.",
			"Retroactive certification consistency for in-flight bindings — bindings preserve at-time semantics per inv-adm-binding-evidence-at-time-not-portable-token; Projection #4 surfaces operational risk visibility.",
			"Delivery success rates sob optimization pressure — admissibility integrity precede delivery throughput per canonical evaluation metric (drift class #12 defense).",
			"Provider claim verification independence guarantees beyond declared verificationMethod + independenceClass.",
		]
		conflictResolution: {
			strategy: "explicit-command"
			rationale: "Conflitos cross-BC resolvidos via explicit commands canonical (cmd-trigger-recertification-review, cmd-validate-transport-contract-admissibility, cmd-execute-issuer-declared-fallback) — não last-write-wins (que permitiria stale state corrupção) nem causal-ordering automatic (NTF não infers ordering — inv-bdy-ntf-never-derives-recipient-semantics adjacent)."
		}
		rationale: "Per adr-081: eventual consistency com explicit-command resolution é correct posture para BC admissibility-centric com cross-BC ownership boundaries. Strong consistency cross-BC seria over-promise (issuing BCs + provider ecosystem evoluem independente); causal-ordering automatic implicaria inference (inv-eps-1 violation)."
	}

	decisionAuthorityModel: {
		type: "hybrid"
		authoritativeScope: "Admissibility certification authority over communication guarantee transports (NTF-owned admissibility sovereignty per C8) + per-dispatch binding crystallization + transport-layer fact emission (independently observed) + replay-forbidden lifecycle isolation + evidentiary audit chain integrity."
		advisoryScope:      "Provider claim observations (consumed as claim, NÃO promoted to fact per C10) + receiver-side confirmation signals (routed untouched per inv-bdy-receiver-confirmation-routed-untouched) + issuing BC declared semantics (issuer-owned per C2)."
		rationale: "Per adr-081: NTF é hybrid authority — authoritative sobre admissibility integrity + transport-layer truth emission, advisory sobre provider claims + receiver semantics + issuer-declared intents. Materializa constitutional triangle C7+C8+C11 (admissibility sovereignty cluster) + Family Mesh pattern paralelo a FCE downstream-authoritative posture."
	}

	// =========================================================================
	// OUTER RATIONALE — Centering principles embedding + class organization
	// =========================================================================

	rationale: """
		Domain model NTF materializa Phase 3 do WI-063 NTF bootstrap.
		Charter constitucional Phase 3.0 founder-approved aplicado
		throughout (9 centering principles embedded como lodestone +
		threat-class identification governando each sub-phase). Family
		Mesh pattern explicit: NTF preserva admissibility integrity of
		communication guarantees (paralelo arquitetural a FCE preserva
		semantic integrity of economic convergence).

		=========================================================================
		CENTERING PRINCIPLES EMBEDDED (charter Phase 3.0)
		=========================================================================

		P1 — GRAVITATIONAL CENTER: 'admissibility-governed execution
		under epistemic uncertainty' (NÃO notification/messaging/
		engagement intelligence platform). Each building block deve
		parecer derivado deste centro. Operational naming forbidden por
		construção.

		P2 — INVARIANT TRIPARTITION: 16 invariants em 3 classes (Boundary
		5 + Admissibility 7 + Epistemic 4). Constitutional triangle
		C7+C8+C11 forma admissibility sovereignty cluster.

		P3 — STATE MACHINE BIPARTITION: Layer 1 SubstrateAuthorityState
		(NTF-owned certification authority — Tier 1/Tier 2 lifecycle via
		nested entities) ⊕ Layer 2 DependentOperationalState (execution
		lifecycle bound a certification snapshot at-time). Layer 2 NUNCA
		reopens Layer 1 decisions.

		P4 — ADMISSIBILITY GUARDIANS: 6 services protect constitutional
		clauses C1-C15, NOT delivery success rates. Fail/defer/escalate
		semantics canonical; degrade-gracefully + best-effort-delivery
		forbidden.

		P5 — NAMING IS ARCHITECTURE: forbidden by construction —
		Delivery{Succeeded|Confirmed|Optimized|FastTracked|Smart};
		AutoApproved{Certification}; BestEffort{Dispatch};
		Engagement{Aware|Optimized}; BehavioralInference. Success-
		oriented + collapse-claim-into-fact naming proibidos.

		P6 — AUTHORING ORDER CANONICAL: invariants → state machine →
		VOs → services → cmds/events → aggregate assembly → policies →
		projections. Projections last (collapse ontology into views;
		derive from model never influence).

		P7 — THREAT MODEL ELEVATION: structural drift (Tier 1 ↔ Tier 2
		collapse) + ontological drift (claim ↔ fact collapse) + temporal
		drift (binding stale beyond snapshot) + institutional drift
		(refusal-reinterpretation gravity drift #12 + engagement gravity
		drift #5). Cada invariant carrega institutional-resistant tag
		quando aplicável.

		P8 — REPLAY-FORBIDDEN: ontological execution category, NÃO
		operational policy. Materialized via vo-replay-semantics-
		discriminator + state machine branch (ReplayForbiddenEscalated)
		+ isolated service (svc-replay-forbidden-isolation). Re-issuance
		é issuer responsibility per inv-eps-4.

		P9 — PROVIDER-CLAIM VS TRANSPORT-OBSERVED ASYMMETRIC EPISTEMIC
		ONTOLOGY: provider-confirmed-success HIGH suspicion (false-
		success catastrophic); transport-observed-success LOW suspicion
		(independent observation). False-failure menos perigoso que
		false-success — assimetria via vo-observation-provenance.

		=========================================================================
		INVARIANT CLASS ORGANIZATION & CROSS-CLASS REINFORCEMENT
		=========================================================================

		Boundary (5): ontology preservation across heterogeneity
		- inv-bdy-1 (never derives recipient semantics) — structural +
		  ontological-sensitive + institutional-resistant
		- inv-bdy-2 (no substitution without class equivalence) —
		  structural + ontological-sensitive
		- inv-bdy-3 (fallback execution only not decision) — structural +
		  institutional-resistant
		- inv-bdy-4 (provider identity binding preserved) — structural +
		  ontological-sensitive
		- inv-bdy-5 (receiver confirmation routed untouched) — structural +
		  ontological-sensitive

		Admissibility (7): certification gate sovereignty + tier
		separation + scope-as-identity
		- inv-adm-1 (conservatism refuses not degrades) — structural +
		  ontological-sensitive + institutional-resistant
		- inv-adm-2 (binding evidence-at-time not portable token) —
		  structural + temporal + epistemic-sensitive
		- inv-adm-3 (scope as certification identity) — structural +
		  ontological-sensitive + institutional-resistant
		- inv-adm-4 (empirical reliability cannot expand ontology) —
		  structural + epistemic-sensitive + institutional-resistant
		- inv-adm-5 (tier separation never collapsed) — structural +
		  ontological-sensitive + institutional-resistant
		- inv-adm-6 (no implicit substitution into Tier 2) — structural +
		  ontological-sensitive + institutional-resistant
		- inv-adm-7 (governed change path not implicit) — structural +
		  institutional-resistant

		Epistemic (4): uncertainty handling + claim-vs-fact asymmetry +
		replay isolation
		- inv-eps-1 (claim-preserving vs fact-preserving handling) —
		  structural + ontological-sensitive + institutional-resistant
		- inv-eps-2 (empirical reliability triggers recertification
		  review only) — structural + epistemic-sensitive +
		  institutional-resistant
		- inv-eps-3 (truth never pays partial) — structural +
		  ontological-sensitive + institutional-resistant
		- inv-eps-4 (replay-forbidden failed issuer re-issuance) —
		  structural + ontological-sensitive

		Cross-class reinforcement matrix:
		- inv-adm-5 (admissibility) ↔ inv-eps-1 (epistemic): tier
		  separation ⊕ claim-vs-fact preservation — same constitutional
		  theme via distinct vectors
		- inv-adm-4 (admissibility) ↔ inv-eps-2 (epistemic): empirical
		  reliability isolation — admissibility expansion prevention ⊕
		  certification mutation pathway protection
		- inv-bdy-1 (boundary) ↔ inv-eps-1 (epistemic): semantic
		  derivation prohibition ⊕ claim-vs-fact ontology preservation
		- inv-adm-2 (admissibility) ↔ inv-bdy-4 (boundary): binding
		  immutability ⊕ provider identity binding — temporal + identity
		  dimensions of same binding integrity invariant family
		- inv-eps-4 (epistemic) ↔ Replay isolation service + vo-replay-
		  semantics-discriminator: ontological category materialized
		  three ways structurally

		Distribution: 11/16 (69%) invariants carry institutional-
		resistant trait → strong defense Phase 5+ drift class.

		=========================================================================
		FOUNDER AJUSTES INTEGRATED PRE-WRITE (~20 total across 7 sub-phases)
		=========================================================================

		Phase 3.0 charter (9 refinements):
		1. P1 'admissibility-governed execution under epistemic
		   uncertainty' (NÃO notification platform)
		2. P2 tripartite (boundary+admissibility+epistemic) com
		   secondaryTraits canonical
		3. P3 bipartite state machine (Layer 1/Layer 2)
		4. P4 admissibility guardians (NÃO delivery orchestrators)
		5. P5 forbidden naming Delivery/AutoApproved/BestEffort/
		   Engagement/BehavioralInference
		6. P6 authoring order (projections last)
		7. P7 threat model elevation 4 dimensions
		8. P8 replay-forbidden ontological category
		9. P9 provider-claim vs transport-observed asymmetric ontology

		Phase 3.1.A Boundary (5 ajustes):
		- message classification framing
		- 'claims are evidence candidates' framing
		- rename to inv-bdy-never-derives-recipient-semantics
		- provider identity binding preservation (inv-bdy-4 nova)
		- terminal attractor matrix field

		Phase 3.1.B Admissibility (5 ajustes):
		- conservatism = refuse not safer transport
		- binding evidence-at-time not portable token
		- governed change path framing
		- scope as identity
		- Layer 6 dispatch cannot reopen Layer 1 admissibility

		Phase 3.1.C Epistemic (4 ajustes):
		- claim-preserving vs fact-preserving language (distinct
		  ontologies, NÃO probability gradient)
		- empirical reliability triggers recertification review only
		- 'não existe pagamento parcial da verdade' framing
		- failed replay-forbidden = issuer re-issuance responsibility

		Phase 3.2 state machine (5 ajustes):
		- evt-provider-claim-evidence-insufficient rename
		- 'independent observation supersedes' framing
		- transport-observed-satisfied naming consideration
		- admissibility-refused unified state + separated events

		Phase 3.3 VOs (5 ajustes):
		- bindingOperationalStatus (separates operational liveness
		  from admissibility validity)
		- supportsClaimRef (evidence sempre bound to claim)
		- provider-instrumented = non-independent constraint
		- issuerExplicitDegradationConsentRef (rare exception pathway)
		- CapabilityDependencyChainImpacted naming consistency

		Phase 3.4 services (2 ajustes):
		- 'independently observed transport fact' framing
		- Service #5 (evidence substrate maintenance) NEVER invokes
		  cmd-issue-admissibility-certification directly — triggers
		  review only

		Phase 3.5 commands/events (3 ajustes):
		- split cmd-issue-admissibility-certification em success/failure
		- split evt em completed/failed
		- recount 17 commands + 27 events

		Phase 3.6 aggregate (3 ajustes):
		- handlesCommands count 17 (não 15)
		- event count confirmed 24
		- 'gate consumes claim+evidence and issues separate Tier 2
		  certification' framing canonical

		Phase 3.7 policies/projections (2 ajustes):
		- Policy #2 explicit: cmd-trigger-recertification-review NÃO
		  altera certificação nem binding; só cria necessidade de
		  avaliação
		- Projection #4 'in-flight degraded binding é visibilidade de
		  risco operacional, NÃO invalidação retroativa'

		=========================================================================
		COVERAGE NUMERICAL
		=========================================================================

		16 invariants (5 bdy + 7 adm + 4 eps)
		27 events (3 internal ACL + 24 published)
		17 commands (8 substrate + 9 execution)
		12 value objects (incluindo binding immutability + replay
		   discriminator + observation provenance)
		1 aggregate root (GuaranteeContractExecution single root) + 2
		   nested entities (ent-admissibility-certification + ent-
		   provider-capability-claim) + 11 states + 13 transitions
		6 domain services (admissibility guardians per P4)
		4 policies (todas review-trigger only — não direct mutation)
		4 projections (certification state + delivery lifecycle +
		   evidentiary audit + in-flight binding operational status)

		=========================================================================
		CANVAS PHASE 1 + GLOSSARY PHASE 2 TRACEABILITY
		=========================================================================

		11 canvas capabilities mapped to building blocks:
		- cap-transport-contract-validation → cmd-validate-transport-
		  contract-admissibility + svc-admissibility-certification-gate
		- cap-transport-admissibility-refusal → evt-transport-contract-
		  admissibility-refused + state AdmissibilityRefused
		- cap-issuer-declared-fallback-execution → cmd-execute-issuer-
		  declared-fallback + vo-fallback-policy-declaration +
		  inv-bdy-fallback-execution-only-not-decision
		- cap-contract-preserving-dispatch → svc-binding-integrity-
		  dispatch + cmd-dispatch-under-binding
		- cap-transport-telemetry-emission → svc-transport-truth-emission
		  + vo-observation-provenance
		- cap-evidentiary-audit-generation → svc-evidentiary-audit-
		  integrity + prj-evidentiary-audit-trail
		- cap-provider-capability-normalization → ent-provider-capability-
		  claim + asymmetric provenance via vo-observation-provenance
		- cap-transport-capability-registry → ent-admissibility-
		  certification + ent-provider-capability-claim + Tier 1/Tier 2
		  separation
		- cap-delivery-attempt-lifecycle-tracking → aggregate.lifecycle
		  (11 states) + prj-delivery-attempt-lifecycle-view
		- cap-transport-capability-evidence-maintenance → svc-evidence-
		  substrate-maintenance + vo-verification-evidence-record +
		  vo-negative-capability-evidence + 4 policies (todas review-
		  trigger)
		- cap-admissibility-certification-issuance → svc-admissibility-
		  certification-gate + cmd-issue/refuse split + Tier 1 → Tier 2
		  gate

		10 canvas businessDecisions cited in invariant rationales:
		- bd-substrate-two-tier → inv-adm-5 + ent separation
		- bd-admissibility-sovereignty → svc-admissibility-certification-
		  gate + decisionAuthorityModel
		- bd-refusal-over-degradation → inv-adm-1 + AdmissibilityRefused
		  state
		- bd-conservatism-under-uncertainty → inv-adm-1 +
		  AdmissibilityConservatismDeferred state
		- bd-empirical-reliability-cannot-expand-ontology → inv-adm-4 +
		  inv-eps-2
		- bd-evidence-as-substrate → svc-evidence-substrate-maintenance +
		  vo-verification-evidence-record
		- bd-scope-bounded-certification → inv-adm-3 + vo-certification-
		  scope-boundary
		- bd-replay-distinct-from-retry → inv-eps-4 + vo-replay-
		  semantics-discriminator + svc-replay-forbidden-isolation
		- bd-provider-normalization-asymmetric → inv-eps-1 + vo-
		  observation-provenance
		- bd-observability-stays-transport-layer → inv-bdy-1 + svc-
		  transport-truth-emission

		22 glossary terms anchored in building blocks (cobertura
		canvas Phase 2):
		- term-admissibility-certification → ent-admissibility-
		  certification + vo-admissibility-certification-snapshot
		- term-provider-capability-claim → ent-provider-capability-claim
		  + vo-provider-capability-claim-record
		- term-guarantee-semantics → aggregate identity (guarantee-
		  contract-execution) + outer rationale
		- term-two-tier-substrate → inv-adm-5 + ent separation
		- term-admissibility-matrix → ent-admissibility-certification
		  collection + svc-admissibility-certification-gate scope
		- term-admissibility-incompatibility-class → evt-transport-
		  contract-admissibility-refused.incompatibilityClass field
		- term-admissibility-refusal → state AdmissibilityRefused +
		  evt-transport-contract-admissibility-refused
		- term-admissibility-conservatism → state AdmissibilityConservatism
		  Deferred + evt-admissibility-conservatism-triggered + inv-adm-1
		- term-certification-scope-boundary → vo-certification-scope-
		  boundary + inv-adm-3
		- term-canonical-transport-contract → vo-transport-contract-
		  declaration
		- term-fidelity-tripartition → inv-bdy-2 + canonical contract
		  3-tier preservation
		- term-semantic-equivalence → vo-transport-contract-declaration
		  .equivalenceDimension
		- term-representational-equivalence → equivalenceDimension
		  subordinate concept
		- term-replay-semantics → vo-replay-semantics-discriminator +
		  inv-eps-4 + svc-replay-forbidden-isolation
		- term-verification-evidence → vo-verification-evidence-record
		- term-confidence-class → vo-confidence-class-snapshot
		- term-negative-capability-evidence → vo-negative-capability-
		  evidence
		- term-observation-provenance → vo-observation-provenance +
		  inv-eps-1
		- term-delivery-attempt-lifecycle → aggregate.lifecycle (11
		  states) + prj-delivery-attempt-lifecycle-view
		- term-receiver-confirmation → cmd-route-receiver-confirmation
		  + evt-receiver-confirmation-routed + inv-bdy-5
		- term-engagement-gravity → drift class #5 defense via inv-bdy-1
		- term-refusal-reinterpretation-gravity → drift class #12
		  defense via institutional-resistant trait across 11/16
		  invariants

		=========================================================================
		LENSES (5)
		=========================================================================

		- lens-mechanism-design (primária): admissibility certification
		  gate as canonical mechanism — explicitly modeled (svc-
		  admissibility-certification-gate produces separate Tier 2
		  certification entity; gate é constitutional center).
		- lens-trust-and-credibility-design: evidence-grounded substrate
		  canonical (Tier 1 evidence + Tier 2 confidence class +
		  negative-evidence coexistence with positive); conservatism C11
		  refuse-not-degrade posture.
		- lens-distributed-systems-design: eventual consistency cross-BC
		  via events + provider-claim vs transport-observed asymmetric
		  ontology (inv-eps-1) + replay-forbidden lifecycle isolation
		  (P8 + inv-eps-4).
		- lens-regulatory-compliance-as-architecture: tc-regulatory-
		  evidentiary canonical contract + svc-evidentiary-audit-
		  integrity + prj-evidentiary-audit-trail court-grade canonical.
		- lens-domain-language-and-terminology-design: 22 glossary
		  terms anchored em building blocks; UL canonical preserved
		  estruturalmente.

		=========================================================================
		FAMILY MESH PATTERN VERIFICATION
		=========================================================================

		FCE: preserve semantic integrity of economic convergence (11
		invariants tripartite + 9-state lifecycle + 6 integrity guardians
		+ 1 aggregate root).
		NTF: preserve admissibility integrity of communication guarantees
		(16 invariants tripartite + 11-state lifecycle + 6 admissibility
		guardians + 1 aggregate root).

		Padrão arquitetural Mesh constitutional emergent:
		- Refusal canonical first-class (FCE Defer + NTF Refused/
		  ConservatismDeferred)
		- Integrity guardians (não delivery/throughput orchestrators)
		- Evidence-grounded substrate (FCE convergence sets + NTF
		  certification gates)
		- Cross-class invariant reinforcement matrix
		- Bipartite state machine separating authoritative ownership
		  (FCE Economic/Observed split + NTF Substrate/Operational)
		- Anti-degradation posture estruturalmente preserved

		Phase 3.8 SRR (srr-ntf-domain-model) próximo. Phase 4 (primary
		agent-spec) + Phase 5 (governance envelope) restam para fechar
		WI-063.
		"""
}
