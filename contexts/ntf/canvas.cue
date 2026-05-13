package ntf

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Notifications & Communications.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// =============================================================================
// IDENTITY CANONICAL
// =============================================================================
//
// NTF é admissibility-certified guarantee transport governance layer.
// Preserva admissibility integrity of communication guarantees sob
// heterogeneity of transports, providers, and operational pressure.
//
// NTF NÃO entrega mensagens. NTF preserva guarantee semantics
// declaradas across heterogeneous transports e providers.
//
// NÃO é: notification infrastructure, messaging system,
// communications platform, Braze, Iterable, Customer.io, Salesforce
// Marketing Cloud, engagement intelligence engine, semantic routing
// layer, CRM logic.
//
// É: constitutional governance layer for communication guarantees —
// paralelo arquitetural ao FCE (constitutional infrastructure for
// economic convergence integrity).
//
// =============================================================================
// CANONICAL HEADER CLAUSE
// =============================================================================
//
// "If a requested transport contract cannot be preserved across
// available transports, NTF must refuse delivery rather than silently
// degrade contract guarantees." (C7 — constitutional center)
//
// =============================================================================
// FAMILY MESH PATTERN
// =============================================================================
//
// FCE: preserve semantic integrity of economic convergence.
// NTF: preserve admissibility integrity of communication guarantees.
//
// Ambos: refusal over degradation; sovereignty over convenience;
// provenance preservation; anti-optimistic expansion; explicit
// uncertainty handling; institutional pressure detection;
// anti-semantic drift posture.
//
// =============================================================================
// 15 CONSTITUTIONAL CLAUSES (C1-C15)
// =============================================================================
//
// C1  — Fidelity tripartition (payload + delivery intent + transport)
// C2  — Fallback authorization model (policy issuer-owned; execution NTF)
// C3  — Transport-layer truth interpretation boundary
// C4  — Provider semantic leakage prohibition
// C5  — Semantic-routing prohibition
// C6  — Generic ≠ simples (legal evidence boundary respected)
// C7  — Refuse rather than silently degrade (CONSTITUTIONAL CENTER)
// C8  — Admissibility sovereignty (NTF owns admissibility authority)
// C9  — Replay-forbidden lifecycle isolation
// C10 — Provider-claim epistemic limitation
// C11 — Admissibility conservatism under uncertainty
// C12 — Observational contamination boundary
// C13 — Certification scope sovereignty
// C14 — Evidence-accumulation-vs-admissibility-expansion asymmetry (NEW Phase 1.7)
// C15 — Certification non-transitivity and non-inheritance (NEW Phase 1.7)
//
// =============================================================================
// 12 DRIFT CLASSES CANONICAL
// =============================================================================
//
//  1 — Decision leak (NTF decides semanticamente)
//  2 — Fidelity erosion (payload entregue ≠ payload emitido)
//  3 — Provider coupling (substitutability erosion)
//  4 — Semantic coupling (business logic em delivery layer)
//  5 — Engagement gravity (otimização human behavior)
//  6 — Transport-intelligence creep (retry vira semantic interpretation)
//  7 — Semantic-routing gravity (transport selection via inferência)
//  8 — Delivery-priority gravity (priority via interpretation)
//  9 — Observability-to-semantics drift (telemetry → behavioral inference)
// 10 — Audit-to-control gravity (audit → policy engine)
// 11 — Evidence-to-policy gravity (epistemic substrate → decision engine)
// 12 — Refusal-reinterpretation gravity (refusal → "operational failure" cultural reframing)
//
// =============================================================================
// 6 CANONICAL TRANSPORT CONTRACTS
// =============================================================================
//
// tc-transactional-financial   — ordered + durable + lossy-forbidden + persistent + ack-confirmed
// tc-regulatory-evidentiary    — strict equivalence + durable + persistent + receiver-confirmation + evidentiary + replay-forbidden
// tc-system-webhook            — ordered-per-correlation + durable + byte-identical + persistent + system + replayable
// tc-operational-update        — unordered + ephemeral + format-translated-admissible + bounded + fire-and-forget + replay-forbidden
// tc-alerting                  — unordered + ephemeral + lossy-forbidden + bounded + fire-and-forget
// tc-otp-single-use            — unordered + ephemeral + byte-identical + retry=none + replay-forbidden
//
// =============================================================================
// AUTHORING ORDER (per manualAuthoringProtocol adr-057)
// =============================================================================
//
// Phase 1.1 — Identity + classification + 5 NTPs + 8 drift classes
// Phase 1.2 — Canonical transport contract model (7 dimensions; 5 contracts)
// Phase 1.2.B — Refined model + admissibility matrix + 6 contracts
//               + C7 constitutional center
// Phase 1.3 — 9 capabilities derived from matrix
// Phase 1.3.B — Transport capability evidence model + C8/C9/C10 +
//               Class B split + drift #9 + 10 capabilities
// Phase 1.3.C — Two-tier substrate + C11/C12 + drift #11 +
//               11 capabilities + identity refinement
// Phase 1.4 — 10 businessDecisions + 7 stakeholders + costs
// Phase 1.5 — Communication (14 inbound + 20 outbound) + 4 CC clauses
// Phase 1.5.B — Refusal/certification taxonomy split + drift #12 +
//               dependency graph + epistemic asymmetry
// Phase 1.6 — incentiveAnalysis + governanceScope (3-tier)
// Phase 1.7 — C14 + C15 + 3 assumptions + 9 openQuestions +
//             7 verificationMetrics + outer rationale (este commit)
// Phase 1.8 — SRR srr-ntf-canvas

canvas: artifact_schemas.#Canvas & {
	code: "ntf"
	name: "Notifications & Communications"

	purpose: """
		Preservar admissibility integrity of communication guarantees
		sob heterogeneity of transports, providers, and operational
		pressure. NTF é constitutional governance layer where issuer-
		declared transport contracts são structurally validated antes
		de dispatch, certified providers são evidence-grounded via
		two-tier substrate (Tier 1 claims + Tier 2 admissibility
		certifications), and refusal é first-class canonical outcome
		(C7 — refuse rather than degrade).

		NTF NÃO entrega mensagens; NTF preserva guarantee semantics
		declaradas across heterogeneous transports e providers. NÃO
		decide o que comunicar nem quando — responsibility dos
		subdomínios emissores (CMT, FCE, BKR, DLV, IDC, INV, BDG,
		REW, NPM, P2P, CTR, SSC, etc.). NÃO é Braze/Iterable/
		Customer.io/Salesforce Marketing Cloud — engagement
		intelligence layer é explicit anti-goal.

		Boundary canônico: provider capability claims (Tier 1) NÃO
		entram canonical substrate directly — devem cruzar
		admissibility certification gate (Tier 2) under conservatism
		(C11) and constitutional clauses C1-C15. Empirical reliability
		alone NÃO grants admissibility expansion (C12 + C14).
		Certifications são non-transitive and non-inheritable across
		contract classes / scope dimensions / provider modes (C15).

		Paralelo arquitetural ao FCE: FCE preserva semantic integrity
		of economic convergence; NTF preserva admissibility integrity
		of communication guarantees. Ambos refusal-centered,
		mechanically conservative, anti-degradation infrastructures.
		"""

	classification: {
		subdomainType:    "generic"
		businessRole:     "operational-enabler"
		wardleyEvolution: "commodity"
		rationale: """
			Generic-subdomain porque entrega de notificações é
			infraestrutura comoditizada — providers intercambiáveis
			(Twilio, Sendgrid, SES, FCM, APNS, webhook services).
			Nenhuma diferenciação competitiva da Mesh reside em
			'como' notificações são entregues. operational-enabler
			role: enables other BCs without competing. Commodity
			Wardley stage: substitutable infrastructure.

			Per founder Phase 1.3 framing: 'generic ≠ simples'
			(C6) — NTF touches legal evidence boundary,
			regulatory communications, transactional truth, audit
			trails, e delivery guarantees. Generic significa
			non-competitive, NÃO 'menos importante'. Generic-
			subdomain drift differs de core-subdomain drift:
			NTF preserva substitutability + admissibility integrity
			(vs FCE preservando institutional meaning).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: "NTF é por construção vertical-agnostic — admissibility certification model + canonical transport contracts operam independente de vertical de cadeia produtiva. Substitutability preservation requer vertical agnosticism."
	}

	domainRoles: {
		primary: "execution"
		secondary: ["gateway"]
		rationale: """
			Primary execution: NTF executa mechanical dispatch sob
			certified contracts; deterministic protocol execution
			only (per Phase 1.6 governanceScope autonomous set).
			NÃO é analysis (semantic interpretation forbidden por
			C3/C5/C9), NÃO é draft (sem authorship semântica), NÃO
			é specification (preserva contracts emitted por issuers,
			não emite specifications).

			Secondary gateway: NTF é gateway entre issuing BCs e
			provider ecosystem — canonical translation layer
			(ACL on both sides). Provider claims entram via gateway
			com epistemic provenance preserved (C10); issuer
			declarations cruzam admissibility gate (C8) antes de
			provider engagement.

			Engagement role explicitly REJECTED — engagement gravity
			é drift class #5 + anti-goal canonical.
			"""
	}

	// NOTE: negativeBoundaries vivem em strategic/subdomains/ntf.cue
	// (not canvas field). NTF subdomain canonical declara CMT (decide
	// conteúdo/timing), NGR (decide growth strategy), IDC (semantic
	// preferences), REW (regulatory compliance semantics) como
	// negative boundary delegations. Canvas refletisce em
	// businessDecisions + governanceScope sem replicar.

	capabilities: {
		operational: [{
			description: "Transport contract validation — mechanical admissibility matrix application; produces verdict (admissible | Class-A/B1/B2/C incompatibility). Maps to C7+C1+C5+C8."
			rationale:   "Per Phase 1.3 cap-transport-contract-validation. Foundation capability: every dispatch request validated antes de transport submission. Mechanical NÃO interpretive."
		}, {
			description: "Transport admissibility refusal — canonical refusal event emission per C7 constitutional center; carries class + failing dimensions + resolution path."
			rationale:   "Per Phase 1.3 cap-transport-admissibility-refusal. Refusal é first-class valid outcome (paralelo a FCE AP5)."
		}, {
			description: "Issuer-declared fallback execution — mechanical fallback per issuer policy; NÃO infers fallback paths."
			rationale:   "Per Phase 1.3 cap-issuer-declared-fallback-execution. C2 fallback authorization model materialized."
		}, {
			description: "Contract-preserving dispatch — execute under all declared contract dimensions preserved (ordering/durability/equivalence/retry/ack/replay)."
			rationale:   "Per Phase 1.3 cap-contract-preserving-dispatch. C1 3-tier fidelity preservation + C9 replay isolation."
		}, {
			description: "Transport telemetry emission — transport-layer truth observations only; behavioral interpretation forbidden por C3 + drift class #9."
			rationale:   "Per Phase 1.3 cap-transport-telemetry-emission. Bounce ≠ disengagement; telemetry é fact NÃO inference."
		}, {
			description: "Evidentiary audit generation — court-grade audit trail per regulatory dimension; cryptographic chain + immutable storage."
			rationale:   "Per Phase 1.3 cap-evidentiary-audit-generation. C6 generic-touches-legal-evidence-boundary."
		}, {
			description: "Provider capability normalization — asymmetric (lossy toward providers, never toward contracts); provider semantic intelligence leakage forbidden."
			rationale:   "Per Phase 1.3.B cap-provider-capability-normalization. C4 provider semantic leakage prohibition + lossy-direction asymmetry per founder ajuste #3."
		}, {
			description: "Transport capability registry — canonical registry of available transports + capability profiles per contract dimension; predeclared artifact."
			rationale:   "Per Phase 1.3.B cap-transport-capability-registry. Equivalent estrutural ao AuthorizationConvergenceSet do FCE."
		}, {
			description: "Delivery attempt lifecycle tracking — mechanical state machine with epistemic provenance (provider-confirmed vs transport-observed asymmetric weighting)."
			rationale:   "Per Phase 1.3.B cap-delivery-attempt-lifecycle-tracking + Phase 1.5.B epistemic asymmetry hardening. C10 provider-claim epistemic limitation."
		}, {
			description: "Transport capability evidence maintenance — operates evidence lifecycle (claims + verification cycles + revocation + degradation per confidence class)."
			rationale:   "Per Phase 1.3.C cap-transport-capability-evidence-maintenance. C10 + C12; evidence substrate avoiding wishful abstraction."
		}, {
			description: "Admissibility certification issuance — canonical gate between Tier 1 (provider claims) and Tier 2 (admissibility matrix); mechanical certification criteria application."
			rationale:   "Per Phase 1.3.C cap-admissibility-certification-issuance. C8 + C11 + C12 + C13; gate é constitutional center between substrate tiers."
		}]
		hasSyncSurface:  true   // AdmissibilityPreflightCheck + QueryCertificationState + RequestEvidentiaryAuditReconstruction são sync
		hasAsyncSurface: true   // 20 outbound events + 14 inbound events (mostly async)
	}

	businessDecisions: [{
		id:           "bd-substrate-two-tier"
		decision:     "Substrate é canonically two-tier: provider capability claim layer (Tier 1 — assertions + evidence) e NTF admissibility certification layer (Tier 2 — accepted into matrix). Provider claims NUNCA enter canonical substrate directly; devem cruzar admissibility gate."
		consequences: "cap-admissibility-certification-issuance é canonical gate capability. Provider claims persistem como Tier 1 artifacts; só passar gate become Tier 2 certifications. Capability claims aging-drift produce automatic certification revocation per Section B degradation lifecycle."
		rationale:    "Materializa founder seminal insight: 'separação rara entre o que provider faz vs o que sistema aceita assumir como verdade'. Sem dois tiers, provider claims silently entram operational folklore (drift class #6 transport-intelligence creep precursor)."
	}, {
		id:           "bd-admissibility-sovereignty"
		decision:     "Admissibility authority é NTF-owned mechanically (C8). Issuer owns contract intent; NTF owns whether intent é structurally preservable. Issuer status/seniority irrelevant — admissibility é structural property, não negotiable."
		consequences: "Issuer declaring 'strict ordering over SMS' triggers Class A refusal regardless de issuer authority. Escalation paths preservam separation: NTF refusal returns admissibility verdict; semantic resolution stays upstream. C8 + C11 + C13 form admissibility sovereignty cluster."
		rationale:    "Sem this decision, issuer pressure derives BC para ontology submission ('important issuer = accept anyway'). C8 canonical center sovereignty preservada by construction."
	}, {
		id:           "bd-refusal-over-degradation"
		decision:     "Refusal é first-class valid outcome (C7 constitutional center). Sistema halts via canonical refusal antes de degrade contract guarantees. Refusal-as-success operational semantic — paralelo a FCE AP5 cst-refusal-is-valid-outcome."
		consequences: "cap-transport-admissibility-refusal materializa refusal canonical. Audit trail records refusal events com same dignity como successful delivery (counter-intuitive aos reviewers institucionais). Métricas observability tratam refusal rate como integrity preservation metric, NÃO operational failure signal."
		rationale:    "Per founder Phase 1.3 recognition: 'refusal preserves contract integrity by halting rather than degrading'. Without this decision, BC derive para 'best-effort delivery' attractor."
	}, {
		id:           "bd-conservatism-under-uncertainty"
		decision:     "Default sob incerteza é refusal, NÃO optimistic admission (C11). When evidence quality insufficient OR provenance independence inadequate OR scope boundary uncertain, NTF rejects rather than assume."
		consequences: "Evidence model degradation triggers automatic admissibility downgrade. Scope boundary out-of-envelope triggers re-certification request OR refusal. 'Empirical reliability' não expand ontology (C12)."
		rationale:    "Completes triangle C7+C8+C11 — without conservatism, BC derive lentamente para pragmatic optimism. Conservatism é epistemic closure of constitutional layer."
	}, {
		id:           "bd-empirical-reliability-cannot-expand-ontology"
		decision:     "Production reliability observations NÃO grant capability certification absent verification evidence meeting class threshold (C12). 'Funciona na prática' canonical insufficient para certification expansion."
		consequences: "12 months production reliability sem methodology verification = stays uncertified for that class. Empirical performance é admissibility input only WITHIN already-certified envelope. Negative evidence model captures contradiction patterns — positive empirical observations cannot offset."
		rationale:    "Defends contra 'empirically justified drift' — the mecanismo pelo qual pragmatic accommodation erodes formal guarantees over time. Per founder framing: 'auditability + governance + revogabilidade preserved'."
	}, {
		id:           "bd-evidence-as-substrate"
		decision:     "Capability claims em registry são canonical apenas quando backed por VerificationEvidence com declared confidence + verification method + staleness tracking. Capability claims absent evidence são structurally inadmissible."
		consequences: "cap-transport-capability-evidence-maintenance é canonical capability. Registry stays evidence-grounded, NÃO wishful abstraction. Negative evidence layer coexists com positive — admissibility considers both."
		rationale:    "Per founder ajuste Phase 1.3.B: capability claims require verification evidence + são revocable. Sem evidence model, registry vira operational folklore (precursor de drift class #6)."
	}, {
		id:           "bd-scope-bounded-certification"
		decision:     "Certifications são scope-bounded canonically (C13). Out-of-scope queries do NOT inherit certification implicitly — re-certification cycle required OR refusal triggered."
		consequences: "AdmissibilityCertification carries certificationScope explicit (traffic + geography + payload + provider mode + environmental). Burst conditions, payload size exceeding envelope, geography outside admitted regions todos trigger refusal mechanically. Prevents 'universal leak'."
		rationale:    "Per founder final ajuste pre-Phase 1.4: certifications tend to leak universality without explicit scope. Scope boundary é structural property of certification, NÃO operational policy."
	}, {
		id:           "bd-replay-distinct-from-retry"
		decision:     "Replay semantics são structurally distinct from retry semantics (C9). retry=persistent applies a delivery attempts; replay=replay-forbidden applies a message identity. Persistence/queue/reprocessing flows são bypassed para replay-forbidden messages."
		consequences: "OTP canonical example: retry=none + replay=replay-forbidden; failed delivery triggers re-issuance request, NÃO retry. Webhook/financial events canonical: retry=persistent + replay=replayable; idempotency-key obligatory downstream. DLQ/replay/reprocessing pipelines structurally segregate by replay dimension."
		rationale:    "Per founder ajuste Phase 1.3.B: OTP é canonical example. Conflating retry com replay produce semantic corruption — replay-forbidden message entering queue replay flow é critical integrity breach."
	}, {
		id:           "bd-provider-normalization-asymmetric"
		decision:     "Provider capability normalization é asymmetric (C4 + Phase 1.3.C hardening). Provider richness IS lossy normalized into canonical contract dimensions; contract guarantees são NÃO degraded to fit provider limitations. Provider semantic intelligence (smart send windows, engagement scores, fatigue prevention) explicitly excluded."
		consequences: "cap-provider-capability-normalization implementa direction asymmetric. Provider 'free intelligence' features rejected by construction. Substitutability preserved (NTP2) — provider swap não muda contract semantics."
		rationale:    "Per founder Phase 1.3 ajuste: provider semantic intelligence leakage é principal vector de engagement gravity creep. Asymmetric normalization makes provider drift architecturally visible."
	}, {
		id:           "bd-observability-stays-transport-layer"
		decision:     "Delivery telemetry observations stay canonical no transport layer. Reinterpretation into behavioral/engagement/preference/interest/urgency semantics within NTF é forbidden (C3). Audit-to-control gravity (drift #10) e evidence-to-policy gravity (drift #11) protegidos por construction."
		consequences: "cap-transport-telemetry-emission emits transport-layer facts only. Aggregation/scoring/ranking from telemetry NOT performed em NTF — consumers downstream can interpret. Audit trail consumed externally para regulatory purposes; NÃO feeds policy engine internally."
		rationale:    "Per founder ajustes Phase 1.3.B + drift class #9/#10/#11 sequence: observability é precursor mais cedo de engagement platform drift. Protection é structural separation, NÃO policy."
	}]

	communication: {
		inbound: [
			// === From issuing BCs (cross-BC pattern, all 12 currently bootstrapped + future) ===
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Issuing BC (FCE/BKR/CMT/DLV/IDC/INV/BDG/REW/NPM/P2P/CTR/SSC) requests transport dispatch under declared contract"
				command:         "DispatchTransportRequest"
				resultingEvents: ["DispatchAdmissibilityCertified", "TransportContractAdmissibilityRefused", "AdmissibilityConservatismTriggered"]
				description:     "Carries TransportContractDeclaration + payload + fallback policy + scope context. Triggers admissibility validation (C7 gate) antes de transport submission."
			},
			{
				type:         "query-surface"
				query:        "AdmissibilityPreflightCheck"
				returnType:   "AdmissibilityVerdict (admissible | Class-A/B1/B2/C-incompatible | conservatism-triggered)"
				description:  "Side-effect-free preflight: issuer valida contract admissibility antes de commit dispatch."
			},
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Issuing BC requests revocation of pending dispatch (não yet transport-attempted)"
				command:         "RevokePendingDispatch"
				resultingEvents: ["PendingDispatchRevoked", "ReplayForbiddenFailureEscalated"]
				description:     "Replay-forbidden dispatches revogadas immediately escalate 'cannot replace via NTF — re-issue from source' (C9)."
			},
			// === From compliance/regulatory upstream ===
			{
				type:          "event-consumer"
				sourceContext: "rew"
				event:         "RegulatoryContractDeclarationObserved"
				reaction:      "IDC/REW canonicaliza regulatory directive into evidentiary contract declaration. NTF translates ACL → admissibility query; never interpretation."
				description:   "Per C6 generic-touches-legal-evidence-boundary: NTF transports regulatory comms; never interprets compliance."
			},
			// === From platform operators (canonical operator interactions) ===
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Operator submits new provider capability claim para Tier 1"
				command:         "SubmitProviderCapabilityClaim"
				resultingEvents: ["NegativeCapabilityEvidenceRecorded"]
				description:     "Claim NÃO triggers admissibility automatically — gate per C8 + C11. Carries VerificationEvidence pointer + confidence + verification method declared."
			},
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Operator submits verification evidence supporting existing claim"
				command:         "SubmitVerificationEvidence"
				resultingEvents: ["CertificationIssued", "CertificationDegraded"]
				description:     "Triggers confidence class assessment per Phase 1.3.B Section B sensitivity rules."
			},
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Operator submits negative evidence (failure/contradiction/drift)"
				command:         "SubmitNegativeCapabilityEvidence"
				resultingEvents: ["CertificationRevoked", "CertificationSuspended", "NegativeCapabilityEvidenceRecorded"]
				description:     "Strong negative evidence triggers auto-revocation; moderate triggers investigation cycle (suspension per Phase 1.5.B Section B)."
			},
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Operator requests revocation citing evidence"
				command:         "RequestCapabilityRevocation"
				resultingEvents: ["CertificationRevoked"]
				description:     "Distinct from auto-revocation — explicit operator-initiated path."
			},
			{
				type:            "command-handler"
				interactionMode: "async"
				trigger:         "Post-staleness OR post-provider-change re-certification request"
				command:         "RequestRecertification"
				resultingEvents: ["CertificationIssued", "CertificationDegraded"]
				description:     "Provisional confidence class defaults during re-cert window."
			},
			// === From evidence/audit consumers ===
			{
				type:         "query-surface"
				query:        "RequestEvidentiaryAuditReconstruction"
				returnType:   "CourtGradeAuditTrail (cryptographic chain + immutable references + provenance preserved)"
				description:  "Evidentiary-consumer (auditor/jurídico/compliance interno/court-facing archive — split per founder Phase 1.4 ajuste) requests reconstruction."
			},
			{
				type:         "query-surface"
				query:        "QueryCertificationState"
				returnType:   "CertificationStateView (Tier 1 claims + Tier 2 certifications + confidence + scope boundary)"
				description:  "Observer queries current certification state for transport class."
			},
			// === From provider ecosystem (ACL-translated) ===
			{
				type:          "event-consumer"
				sourceContext: "ext-provider-ecosystem"
				event:         "ProviderDispatchAcknowledgmentObserved"
				reaction:      "Provider claims dispatch success (Tier 1 claim per C10); preserved as claim NOT promoted to fact absent independent verification."
				description:   "Per C10 + Phase 1.5.B Section D ajuste: provider-confirmed vs transport-observed asymmetric — HIGH suspicion weight para provider claims."
			},
			{
				type:          "event-consumer"
				sourceContext: "ext-provider-ecosystem"
				event:         "ProviderDispatchFailureObserved"
				reaction:      "Provider reports failure. Treated as claim per C10; consumed by lifecycle tracking com epistemic provenance labeling (NORMAL suspicion weight — false-failure menos perigoso)."
				description:   "Asymmetric weighting: provider-confirmed-success HIGH suspicion; provider-reported-failure NORMAL."
			},
			{
				type:          "event-consumer"
				sourceContext: "ext-provider-ecosystem"
				event:         "ProviderCapabilityChangeNotified"
				reaction:      "Provider announces capability changes. Triggers re-certification per C13 scope boundary check + cascading dependency invalidation per Phase 1.5.B Section C."
				description:   "Provider API version change, feature deprecation, mode change — todos triggers certification lifecycle events."
			},
		]
		outbound: [
			// === To issuing BCs (refusal + lifecycle events) ===
			{
				type:      "event-publisher"
				trigger:   "Admissibility matrix produces incompatibility verdict (Class A/B1/B2/C)"
				event:     "TransportContractAdmissibilityRefused"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C7 + CC2: explicit refusal carrying class + failing dimensions + resolution path. First-class canonical outcome (paralelo a FCE PaymentObligationDeferred)."
			},
			{
				type:      "event-publisher"
				trigger:   "Confidence class insufficient OR evidence stale OR provenance inadequate OR scope boundary uncertain"
				event:     "AdmissibilityConservatismTriggered"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C11 + Phase 1.5.B Section A: refusal for EPISTEMIC uncertainty (distinct de structural impossibility). 'I cannot guarantee' vs 'I cannot do'."
			},
			{
				type:      "event-publisher"
				trigger:   "Admissibility validation passed; transport submission imminent"
				event:     "DispatchAdmissibilityCertified"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C8: certification verdict explicit (não silent acceptance)."
			},
			{
				type:      "event-publisher"
				trigger:   "Dispatch submitted to transport layer"
				event:     "DispatchAttempted"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Lifecycle state `dispatched`. Carries scope context for downstream correlation."
			},
			{
				type:      "event-publisher"
				trigger:   "Transport layer confirms delivery (provider-confirmed OR transport-observed)"
				event:     "DispatchConfirmedTransportLayer"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C10 + CC3: payload carries provenance class (provider-confirmed OR transport-observed) + independence classification — issuer interprets confidence per their semantics."
			},
			{
				type:      "event-publisher"
				trigger:   "Transport layer reports failure"
				event:     "DispatchFailedTransportLayer"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Failure with class: transient (B2-eligible retry) vs structural (B1) vs provider-specific (C). Per CC1: transport-layer fact only — não behavioral inference."
			},
			{
				type:      "event-publisher"
				trigger:   "Issuer-initiated revocation processed"
				event:     "PendingDispatchRevoked"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Acknowledges issuer-initiated revocation; lifecycle terminated."
			},
			{
				type:      "event-publisher"
				trigger:   "Issuer-declared fallback path activated per policy"
				event:     "FallbackExecuted"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C2: fallback policy issuer-owned; execution NTF mechanical. Original + substitute transports both recorded."
			},
			{
				type:      "event-publisher"
				trigger:   "No admissible fallback per issuer policy; escalation back to issuer"
				event:     "FallbackUnavailable"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Issuer decides next action (re-issue with relaxed contract, abandon, etc) — NÃO NTF degradation."
			},
			{
				type:      "event-publisher"
				trigger:   "Receiver-confirmation-required signal received from receiver-side"
				event:     "ReceiverConfirmationRouted"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C10 — receiver-side signal routed upstream untouched. Semantic interpretation by issuer, NÃO NTF."
			},
			{
				type:      "event-publisher"
				trigger:   "Replay-forbidden delivery failed; cannot retry via persistence"
				event:     "ReplayForbiddenFailureEscalated"
				consumers: ["fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C9: issuer must re-issue from source (new semantic act, not retry). Distinct from generic dispatch failure."
			},
			// === To audit/observability stakeholders ===
			{
				type:      "event-publisher"
				trigger:   "New certification entered Tier 2 matrix per CC4"
				event:     "CertificationIssued"
				consumers: ["obs"]
				description: "Carries claim + evidence chain + scope boundary + sensitivity context. NÃO emitted implicitly via empirical correlation (CC4)."
			},
			{
				type:      "event-publisher"
				trigger:   "Certification permanently invalidated (confirmed negative evidence / operator revocation / provider capability withdrawn)"
				event:     "CertificationRevoked"
				consumers: ["obs"]
				description: "Per Phase 1.5.B Section B: ontological invalidation distinct de suspension."
			},
			{
				type:      "event-publisher"
				trigger:   "Certification temporarily unsafe pending investigation/re-verification (moderate negative evidence accumulating)"
				event:     "CertificationSuspended"
				consumers: ["obs"]
				description: "Per Phase 1.5.B Section B: epistemic uncertainty escalation — recoverable via re-verification cycle."
			},
			{
				type:      "event-publisher"
				trigger:   "Confidence class lowered per Section B degradation rules"
				event:     "CertificationDegraded"
				consumers: ["obs"]
				description: "Per CC4: explicit lifecycle event — admissibility nunca degraded implicitly. Strong → moderate → provisional → inadmissible."
			},
			{
				type:      "event-publisher"
				trigger:   "Query made outside certified scope (traffic burst / payload exceeded / geography mismatch / provider mode change)"
				event:     "CertificationScopeExceeded"
				consumers: ["obs", "fce", "bkr", "cmt", "dlv", "idc", "inv", "bdg", "rew", "npm", "p2p", "ctr", "ssc"]
				description: "Per C13: triggers refusal OR re-certification request per issuer policy."
			},
			{
				type:      "event-publisher"
				trigger:   "Evidence aging triggered re-verification cycle"
				event:     "EvidenceStalenessDetected"
				consumers: ["obs"]
				description: "Per Section B: confidence class transitioning per sensitivity schedule (30/90/180 days per class)."
			},
			{
				type:      "event-publisher"
				trigger:   "Negative evidence artifact created (failure/contradiction/drift observed)"
				event:     "NegativeCapabilityEvidenceRecorded"
				consumers: ["obs"]
				description: "Per Phase 1.3.C Section C: may trigger auto-revocation (strong) OR investigation cycle (moderate)."
			},
			{
				type:      "event-publisher"
				trigger:   "Upstream dependency change cascades to certification lifecycle"
				event:     "CapabilityDependencyChainImpacted"
				consumers: ["obs"]
				description: "Per Phase 1.5.B Section C: load-bearing dependency change → revocation; supporting → suspension; auxiliary → re-verification."
			},
			{
				type:      "event-publisher"
				trigger:   "ADR-grade mutation applied to admissibility matrix (rare)"
				event:     "AdmissibilityMatrixVersionUpdated"
				consumers: ["obs"]
				description: "Founder-only approval per future Phase 5 governance. Versioning + change rationale + downstream impact ref required."
			},
		]
		rationale: """
			34 communication entries (14 inbound + 20 outbound) preservam ontology canonical do BC via 4 communication clauses (CC1-CC4): CC1 transport facts only; CC2 refusal explicit; CC3 claim vs fact separation visible; CC4 certification lifecycle explicit. All outbound events preserve transport-layer fact framing; semantic interpretation upstream-only. Refusal canonical structurally first-class (paralelo a FCE AP5 refusal pattern). Provider claims ACL-translated as claims preserved Tier 1; never auto-promoted.

			Issuing BCs list completa atual: 12 bootstrapped (FCE, BKR, CMT, CTR, DLV, IDC, INV, NPM, P2P, REW, SSC, BDG) + futuras (ATO/TCM/SCF/etc) — consumers de canonical events. Provider ecosystem ACL-translated via prefix ext-provider-ecosystem.
			"""
	}

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Human receiver of communication transports"
		impactDescription: "Construtora recipients receive transactional/regulatory/operational/alerting messages via email/SMS/push. Experience NTF indirectly through delivery fidelity (correct timing, content, channel per contract)."
		rationale:         "End user B2B Mesh — não interage com NTF API; experimenta delivery quality. Fidelity preservation directly affects perceived system reliability."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Human receiver of communication transports (supplier-side)"
		impactDescription: "Fornecedor recipients receive payment notifications, evidence acknowledgments, retention release alerts via human-receivable transports. Same C1 fidelity preservation guarantees apply."
		rationale:         "Mirror complement de sh-01 no journey B2B. Receivers structurally aligned com fidelity preservation."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulatory authority + indirect evidentiary stakeholder"
		impactDescription: "Bacen (e equivalentes regulatory bodies) consume evidentiary contracts when effective channel exists (RegulatoryAcknowledgmentRouted). Indirectly served via evidentiary-consumers (auditor/jurídico/compliance interno) reconstructing audit trail per regulatory obligation."
		rationale:         "Per founder Phase 1.4 ajuste split: regulator não sempre é direct receiver. Evidentiary fidelity serves regulator indirectly via audit trail."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Platform operators (agents + humans operating NTF)"
		impactDescription: "Mesh agents + human operators execute mechanical processes (certification verification, evidence maintenance, registry curation, ADR-grade mutation governance). Subject to C7-C15 constitutional clauses + drift detection."
		rationale:         "Per founder Phase 1.6: operators structurally aligned but operationally exposed to all 12 drift class pressures. Governance envelope (Phase 5) provides protection."
	}, {
		stakeholderRef:    "sh-06"
		roleInContext:     "Adversarial actor — institutional drift pressure source"
		impactDescription: "Adversário econômico drives drift class #12 (refusal-reinterpretation gravity), #5 (engagement gravity), #11 (evidence-to-policy gravity). Pressure surfaces como operational narrative ('reduce friction', 'improve UX', 'smart routing'). Não bug, é design adversary."
		rationale:         "Per founder Phase 1.6 framing: institutional pressure inevitable em mature operation. sh-06 canonical adversary class material em incentive analysis."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Comprador B2B (Construtora) — recipient"
			desiredBehavior:           "Recebe communications timely + accurate + channel-appropriate; benefit-from-fidelity"
			correctOperationIncentive: "C1 fidelity preservation across transports — message arrives faithful to issuer intent"
			manipulationVector:        "Pressão para NTF carregar engagement logic ('reduce notification fatigue', 'consolidate signals') que cria semantic suppression — drift class #5"
			manipulationCost:          "Engagement gravity é canonical anti-goal; NTF rejeita engagement features estructuralmente; recipient pressure NÃO modifies NTF identity"
			vsBenefit:                 "Manipulation introduces engagement logic = boundary violation; recipient benefit é ephemeral OR illusory (semantic suppression erodes communication value over time)"
			designResponse:            "C5 semantic-routing prohibition + C3 transport-layer truth boundary + bd-observability-stays-transport-layer materializam refusal por construction"
			rationale:                 "Recipient structurally aligned com fidelity; adjacent functions (marketing, UX, engagement teams) misalign toward NTF carrying engagement logic — design resists structurally."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "Fornecedor B2B (recipient + integration via webhooks)"
			desiredBehavior:           "Recebe payment notifications + evidence ack via human transports; receives webhook structured payloads via system transports"
			correctOperationIncentive: "C1 fidelity + cross-class boundary preservation (human-receivable vs system-receivable distinct semantics)"
			manipulationVector:        "Provider-specific feature adoption ('use Twilio callbacks directly') erodes substitutability — drift class #3"
			manipulationCost:          "Substitutability erosion = canonical violation; NTF abstraction layer rejects provider-specific features mesmo quando provider offers them 'for free'"
			vsBenefit:                 "Manipulation creates hidden coupling; benefit (slightly richer features) << cost (long-term lock-in + integration brittleness)"
			designResponse:            "C4 provider semantic leakage prohibition + bd-provider-normalization-asymmetric materializam asymmetric direction by construction"
			rationale:                 "Suppliers tend to either over-rely on provider features OR under-leverage NTF guarantees — design constrains both."
		}, {
			stakeholderRef:            "sh-04"
			participantType:           "Regulatory authority + indirect evidentiary stakeholder"
			desiredBehavior:           "Compliance via evidentiary contracts (when receiver) OR audit trail reconstruction (when indirect via evidentiary-consumers)"
			correctOperationIncentive: "C6 generic-touches-legal-evidence-boundary + tc-regulatory-evidentiary contract + court-grade audit trail"
			manipulationVector:        "Form-over-substance compliance pressure (checkbox compliance vs substantive audit); regulatory directive interpretation pressure on NTF"
			manipulationCost:          "Interpretation responsibilities rejected estructuralmente — NTF transports compliance content; never interprets significance"
			vsBenefit:                 "Manipulation creates compliance theater; substantive audit serves regulator long-term"
			designResponse:            "C6 generic ≠ simples canonical + bd-empirical-reliability-cannot-expand-ontology (compliance evidence requires verification, NÃO inference) + neg-bound delegation to REW for compliance semantics"
			rationale:                 "Regulator structurally aligned com substantive evidentiary fidelity; adjacent operational functions create form-over-substance pressure."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Platform operators (Mesh agents + human operators)"
			desiredBehavior:           "Mechanical canonical operation per protocol — operators benefit from explicit refusals + audit trail + evidence model (clearer accountability)"
			correctOperationIncentive: "Constitutional clauses C1-C15 provide explicit operational guidance; refusal canonical avoids ambiguous discretionary judgment"
			manipulationVector:        "Operational pressure ('users complaining about refusals') → admissibility relaxation; convenience pressure ('expedite certification') → C11 conservatism erosion; optimization pressure → verification cycle shortcuts; folkloric capability assumption ('this provider has worked fine') → evidence model bypass"
			manipulationCost:          "Per drift class #12 refusal-reinterpretation gravity: cultural pressure detection via escalation criteria + governance envelope Phase 5"
			vsBenefit:                 "Short-term operational ease << long-term constitutional integrity; operators learn to value canonical refusal as integrity preservation metric (paralelo a FCE anti-fatigue clause)"
			designResponse:            "Phase 5 governance envelope materializes refusal-rate-as-integrity-metric + escalation criteria + mutation governance asymmetric (mirror de FCE)"
			rationale:                 "Operators exposed to ALL 12 drift class pressures; constitutional layer + governance envelope protect against erosion."
		}, {
			stakeholderRef:            "sh-06"
			participantType:           "Adversarial actor (institutional pressure source)"
			desiredBehavior:           "N/A — adversary; design rejects adversary's preferred behavior structurally"
			correctOperationIncentive: "N/A — design provides NO incentive alignment para adversary; refusal-as-success canonical detects adversary attempts"
			manipulationVector:        "Drift class #5 engagement gravity, #7 semantic-routing gravity, #11 evidence-to-policy gravity, #12 refusal-reinterpretation gravity — surface como operational narratives: 'smart routing', 'reduce friction', 'improve UX', 'data-driven optimization'"
			manipulationCost:          "Per founder framing: institutional pressure inevitable em mature operation. Phase 5 governance envelope materializes adversarial hardening posture — pressure surfaces estructuralmente flagged"
			vsBenefit:                 "Adversary benefits from semantic capture; design rejects capture structurally via 15 constitutional clauses + 12 drift classes + Phase 5 governance"
			designResponse:            "Whole constitutional structure (C1-C15 + 12 drift classes + admissibility sovereignty + mutation governance asymmetric) é collective adversarial response. Defensive posture mechanical, NÃO discretionary."
			rationale:                 "Per founder Phase 1.6 reflection: adversary é structural participant — design must explicitly model pressure as inevitable. sh-06 canonical adversary class."
		}]
		rationale: """
			5 participantes refletem incentive landscape do NTF:
			recipients aligned (sh-01, sh-02) mas com adjacent
			engagement pressure; regulator aligned (sh-04) mas com
			form-over-substance pressure; operators aligned (sh-05)
			mas operationally exposed to all 12 drift class pressures;
			adversary (sh-06) structurally misaligned — design must
			explicitly model pressure as inevitable. Per founder
			Phase 1.6: incentive analysis acknowledges pressure NÃO
			como exception, mas como structural participant.
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/ntf/agents/ntf-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "apply-admissibility-matrix-mechanically"
				description: "Apply admissibility matrix mechanically — produce Class A/B1/B2/C verdict per declared contract dimensions. NÃO judgment; purely mechanical matrix application."
				rationale:   "Per Phase 1.6: autonomous set is deterministic protocol execution only. Matrix application mechanical by construction (C8 admissibility sovereignty)."
			}, {
				id:          "execute-dispatch-under-certified-contract"
				description: "Execute dispatch with all declared contract dimensions preserved (C1 fidelity tripartition)."
				rationale:   "Per cap-contract-preserving-dispatch + C1 + C7. Mechanical execution under canonical contract; no semantic judgment."
			}, {
				id:          "emit-transport-layer-telemetry"
				description: "Emit transport-layer truth observations only (CC1 + C3 facts; behavioral inference forbidden)."
				rationale:   "Per C3 + drift class #9: telemetry stays transport-layer; semantic interpretation upstream-only."
			}, {
				id:          "execute-issuer-declared-fallback"
				description: "Execute fallback path per issuer policy (C2 mechanical path; NÃO infers fallback)."
				rationale:   "Per C2 fallback authorization model: policy issuer-owned; execution NTF mechanical."
			}, {
				id:          "generate-evidentiary-audit-trail"
				description: "Generate court-grade audit trail per evidentiary contract dimension (C6 + cryptographic chain)."
				rationale:   "Per cap-evidentiary-audit-generation: audit trail é mechanical generation per regulatory dimension declared; NTF nunca decides if message é evidentiary."
			}, {
				id:          "track-delivery-attempt-lifecycle"
				description: "Track delivery attempt lifecycle states with epistemic provenance (provider-confirmed vs transport-observed asymmetric weighting per Phase 1.5.B Section D)."
				rationale:   "Per cap-delivery-attempt-lifecycle-tracking + C10: lifecycle é mechanical state machine; epistemic provenance preserved structurally."
			}, {
				id:          "acl-translate-provider-acknowledgments"
				description: "ACL-translate provider acknowledgments as claims (C10; preserved Tier 1 substrate; never auto-promoted)."
				rationale:   "Per Tier 1 substrate + C10 + Phase 1.5.B Section D: provider claims preserved as claims; promotion to Tier 2 requires gate per cap-admissibility-certification-issuance."
			}]
			supervisedDecisions: [{
				id:          "certification-issuance-tier-1-to-tier-2"
				description: "Certification issuance — Tier 1 → Tier 2 promotion gate (C8 + C11 + C12 + C13 + C14 + C15). Requires founder approval per mutation governance asymmetric (paralelo a FCE)."
				rationale:   "Per cap-admissibility-certification-issuance: gate é constitutional center between tiers; mechanical criteria application MAS founder approval obligatory para acceptance into Tier 2."
			}, {
				id:          "certification-revocation"
				description: "Certification revocation per CC4 ontological invalidation. Founder approval para confirmed-negative-evidence-driven revocations affecting operational continuity."
				rationale:   "Per Phase 1.5.B Section B: revocation = permanent invalidation distinct from suspension; founder review preserves epistemic discipline."
			}, {
				id:          "certification-suspension"
				description: "Certification suspension per Phase 1.5.B Section B — epistemic uncertainty escalation path. Supervised review balances investigation urgency vs operational continuity."
				rationale:   "Suspension is recoverable; founder review confirms investigation methodology before suspension activates."
			}, {
				id:          "scope-boundary-changes"
				description: "Certification scope mutations (C13 — traffic profile / geography / payload / provider mode / environmental assumptions changes)."
				rationale:   "Per C13 + bd-scope-bounded-certification: scope changes structural; ADR-grade mutation per Phase 5 governance."
			}, {
				id:          "provider-capability-claim-tier-1-acceptance"
				description: "Initial provider capability claim entering Tier 1 substrate. Operator-submitted MAS founder review para new providers."
				rationale:   "Per bd-substrate-two-tier: Tier 1 entry é evidence-grounded gate; new provider relationships require founder structural approval."
			}, {
				id:          "verification-methodology-changes"
				description: "Verification methodology changes (confidence class assessment criteria, evidence types accepted, independence requirements). Affects ALL certifications under new methodology."
				rationale:   "Methodology changes alter confidence class semantics — semantic mutation requires founder approval + parallel SRR per mutation governance asymmetric."
			}, {
				id:          "admissibility-matrix-mutations"
				description: "Admissibility matrix mutations (incompatibility pairs additions/removals — ADR-grade decisions). Per Phase 1.5 outbound event AdmissibilityMatrixVersionUpdated."
				rationale:   "Matrix é canonical substrate; mutations é constitutional change requiring founder approval + ADR + SRR + downstream impact review per mutation governance asymmetric (mirror de FCE)."
			}]
			escalationCriteria: [{
				id:        "negative-evidence-accumulation"
				condition: "Moderate-to-strong negative evidence accumulating across multiple capability claims"
				action:    "Investigation cycle + suspension where applicable + founder review"
				rationale: "Per drift class #6 + Phase 1.5.B Section B suspended path: pattern indicates systemic capability degradation, not single-claim issue."
			}, {
				id:        "refusal-reinterpretation-pressure"
				condition: "Operational narrative emerging framing refusal as 'system unreliability' / 'reduce refusals' / 'improve success rate'"
				action:    "L3 architectural escalation + founder review + anti-fatigue clause reinforcement"
				rationale: "Per drift class #12 (NEW Phase 1.5.B Section F): refusal-reinterpretation gravity é cultural drift vector. Detection é primary defense."
			}, {
				id:        "optimization-gravity-narratives"
				condition: "Pressure framings detected proposing optimization affecting forbidden domains (convergence semantics, refusal frequency, escalation thresholds, invariant enforcement, validity windows, uncertainty preservation, upstream authority dependence)"
				action:    "L3 escalation + governance envelope (Phase 5) defense"
				rationale: "Per drift class #5 + anti-optimization stance + bd-observability-stays-transport-layer."
			}, {
				id:        "audit-to-control-gravity-patterns"
				condition: "Audit trail data being repurposed for policy enforcement, risk scoring, OR control plane decisions"
				action:    "L3 escalation + structural separation reinforcement"
				rationale: "Per drift class #10: audit → analytics → policy engine path destroys substitutability silently."
			}, {
				id:        "evidence-to-policy-gravity-patterns"
				condition: "Evidence substrate feeding policy/decision engines (confidence scoring → reliability ranking → routing optimization → provider preference)"
				action:    "L3 escalation + structural separation reinforcement"
				rationale: "Per drift class #11 (Phase 1.3.C Section G): evidence-to-policy gravity é earliest precursor of engagement platform drift."
			}, {
				id:        "provider-semantic-intelligence-leakage"
				condition: "Provider-originated semantic intelligence (smart send windows, engagement scores, fatigue prevention, behavioral predictions) detected in NTF abstraction layer"
				action:    "L3 escalation + C4 violation review + provider relationship review"
				rationale: "Per drift class #3 + C4 + bd-provider-normalization-asymmetric: provider semantic leakage é principal vector de engagement gravity."
			}, {
				id:        "scope-boundary-expansion-attempts"
				condition: "Scope boundary expansion attempts without re-certification cycle (implicit assumption that certification extends)"
				action:    "L3 escalation + C13 + C15 reinforcement + certification refusal"
				rationale: "Per C13 + C15 (Phase 1.7 NEW): scope sovereignty + non-transitivity preserved by construction."
			}, {
				id:        "stale-claim-acceptance"
				condition: "Stale capability claims being accepted (post-staleness without re-verification) — empirical drift attempt"
				action:    "Automatic admissibility downgrade + L3 escalation if pattern"
				rationale: "Per C12 + bd-empirical-reliability-cannot-expand-ontology: stale claims trigger degradation mechanically; pattern escalates."
			}, {
				id:        "empirical-reliability-expansion-attempts"
				condition: "Empirical reliability used as rationale for admissibility expansion (vs as confidence input within existing scope)"
				action:    "L3 escalation + C12 + C14 violation review"
				rationale: "Per C12 observational contamination boundary + C14 (Phase 1.7 NEW) evidence-vs-expansion asymmetry."
			}, {
				id:        "cross-class-admissibility-leakage"
				condition: "Certification under one contract class implicitly extended to different contract class without explicit re-certification"
				action:    "L3 escalation + C15 enforcement"
				rationale: "Per C15 (Phase 1.7 NEW): certifications non-transitive across contract classes. Partial-certification leakage é common operational drift."
			}, {
				id:        "replay-forbidden-retry-violations"
				condition: "Replay-forbidden messages entering persistence/queue/DLQ/reprocessing flows"
				action:    "Critical integrity breach review + C9 enforcement + immediate flow segregation"
				rationale: "Per C9 replay-forbidden lifecycle isolation: catastrophic semantic identity corruption (OTP re-issued vs new OTP)."
			}, {
				id:        "transport-observed-inference-attempts"
				condition: "Transport telemetry being reinterpreted into behavioral/engagement/preference/interest/urgency semantics within NTF"
				action:    "L3 escalation + C3 + drift class #9 violation review"
				rationale: "Per drift class #9 + C3: precursor of engagement platform drift. Bounce ≠ disengagement; click ≠ acceptance."
			}]
			rationale: """
				Governance scope distinct from FCE pattern porque NTF é
				generic-subdomain protecting substitutability vs FCE
				constitutional-integrity. Autonomous set é deterministic
				protocol execution — sem judgment. Supervised set protects
				canonical gates (certification, revocation, scope, matrix).
				Escalation criteria cover 12 drift classes + 15 constitutional
				clauses violations explicitly.

				Per founder framing 'admissibility-governed transport governance
				layer': governance scope explicit reflects this — autonomous é
				protocol execution; supervised é canonical change; escalation é
				cultural/institutional pressure detection.
				"""
		}
		rationale: "Ownership canonical: domain agent é agt-ntf-primary (Phase 4 materialization); governance scope materializa 7+7+12 canonical decisions structured by phase + clause + drift class coverage."
	}

	assumptions: [{
		id:                 "as-ntf-provider-incentive-misalignment-1"
		assumption:         "Provider commercial incentive é structurally misaligned com NTF identity. Providers (Twilio, Braze, Iterable, Salesforce Marketing Cloud, etc.) differentiate via engagement intelligence, semantic routing, optimization features — exactly o que NTF rejeita por construção. Misalignment é structural não transient — NÃO will resolve via provider 'maturity' OR partnership evolution."
		invalidationSignal: "Provider ecosystem demonstrably shifts away from engagement intelligence as commercial differentiator (industry-wide, sustained 3+ years). Currently no evidence; assumption holds robustly."
		rationale:          "Per founder Phase 1.6 reflection: provider differentiation incentives require semantic gravity. Provider drift toward 'smart features' é não bug, é commercial design. NTF must persist asymmetric provider normalization (C4 + lossy-toward-provider direction) por structural construction, não temporary defense."
	}, {
		id:                 "as-ntf-institutional-refusal-pressure-2"
		assumption:         "Institutional pressure toward 'reduce refusals', 'improve delivery success rate', 'minimize defer events' é inevitable em mature operation — NÃO exceptional. Surface as: dashboard metrics framing, OKR/KPI optimization, customer success narratives, executive review cycles. Pressure NÃO indicates sistema mal-design; indicates sistema é operating em organizational reality."
		invalidationSignal: "Sustained 12+ months operation without ANY refusal-reinterpretation pressure narrative emerging from operations/product/executive functions. Would invalidate assumption AND require recalibration of governance envelope drift sensitivity."
		rationale:          "Per founder framing: refusal-reinterpretation gravity (drift class #12) é predictable adversarial vector. Assumption explicit acknowledges this — governance envelope (Phase 5) must defend permanently, não treat as one-time concern."
	}, {
		id:                 "as-ntf-empirical-admissibility-independence-3"
		assumption:         "Empirical reliability (production observability) e certified admissibility (constitutional guarantees) evolve independently. Empirical reliability may be HIGH while certification confidence é PROVISIONAL (insufficient methodology); empirical reliability may be MODERATE while certification confidence é STRONG (rigorous methodology). Two dimensions são orthogonal — não derivable from each other."
		invalidationSignal: "Sustained pattern where empirical reliability monotonically maps to certification confidence class for ≥80% of registered capabilities, AND this mapping survives methodology audits. Would suggest single-dimension model sufficient — currently unsupported."
		rationale:          "Per C14: foundational independence assumption. Without explicit acknowledgment, sistema lentamente collapses empirical reliability and admissibility into single metric — destroys conservatism C11 + observational contamination boundary C12."
	}]

	openQuestions: [{
		id:       "oq-ntf-inheritance-semantics-1"
		question: "When canonical contract class evolves (e.g., tc-regulatory-evidentiary adds new dimension requirement post-regulatory update), how do existing certifications under that class inherit OR not inherit the change?"
		impact:   "Affects certification lifecycle stability across regulatory evolution. Current C15 (non-transitive) suggests full re-certification required for any class-level change — operationally expensive but ontologically clean."
		rationale: "Founder Phase 1.6 coverage area #1. Trade-off: certification velocity vs ontological cleanliness. Hypothesis: re-certification required (clean); operational mitigation via parallel certification cycles (não shortcuts)."
	}, {
		id:       "oq-ntf-admissibility-expansion-ceremony-2"
		question: "What is the canonical governance ceremony for legitimate admissibility expansion (e.g., adding new transport class admissible for evidentiary contracts)? ADR + structural review sufficient, OR additional founder approval gate required?"
		impact:   "Defines change-management protocol for ontological growth. Without explicit ceremony, ambiguity creates pressure toward informal expansion (drift)."
		rationale: "Founder Phase 1.6 coverage area #2. Hypothesis: ADR + founder-only approval + parallel SRR + downstream impact review (paralelo a FCE mutation governance asymmetric)."
	}, {
		id:       "oq-ntf-certification-transitivity-edge-cases-3"
		question: "Edge case scenarios for C15 non-transitivity: provider's underlying infrastructure (e.g., shared SMTP backend across multiple provider products) — does certification for one product transitively imply certification for another? Currently C15 says NO; operational reality may pressure toward exceptions."
		impact:   "Without explicit guidance, operational pressure may erode C15 via 'same infrastructure' reasoning."
		rationale: "Founder Phase 1.6 coverage area #3. Hypothesis: strict C15 holds even when underlying infrastructure shared — productized commercial offering é distinct unit of certification. Documentation gap to fill em Phase 3 domain-model."
	}, {
		id:       "oq-ntf-partial-certification-leakage-detection-4"
		question: "How does NTF detect partial-certification leakage operationally (e.g., contract requesting tc-transactional-financial but with payload dimensions exceeding tc-transactional-financial scope boundary)? Pre-dispatch admissibility validation catches this — but how detect via post-hoc audit?"
		impact:   "Affects audit trail observability for governance review."
		rationale: "Founder Phase 1.6 coverage area #4. Hypothesis: dm-partial-certification-leakage-detection metric em Phase 5 governance envelope; pattern analysis on admissibility refusal events + scope boundary correlation."
	}, {
		id:       "oq-ntf-scope-recomposition-attacks-5"
		question: "Scope recomposition: issuer decomposes one out-of-scope message into multiple in-scope messages para circumvent C13. Example: payload exceeds scope → issuer splits into N sub-payloads each in-scope. NTF dispatches all — effectively delivering out-of-scope content via recomposition. How detect/prevent?"
		impact:   "Adversarial scope attack vector."
		rationale: "Founder Phase 1.6 coverage area #5. Hypothesis: scope boundary é per-message; aggregate recomposition é issuer responsibility. NTF não tracks aggregate scope. Defense via issuer-side discipline + observability metrics flagging suspicious decomposition patterns."
	}, {
		id:       "oq-ntf-temporary-compatibility-narrative-6"
		question: "How does NTF respond to 'temporary compatibility' narratives (e.g., 'just allow this slightly out-of-scope dispatch this once, we'll re-certify next sprint')? Per drift class #12 + bd-empirical-reliability-cannot-expand-ontology, answer must be 'no exceptions' — but operational reality creates persistent pressure."
		impact:   "Defines cultural/operational response protocol."
		rationale: "Founder Phase 1.6 coverage area #6. Hypothesis: structural refusal canonical (C7 + C11); response NÃO is negotiation. 'Temporary compatibility' é institutionalization of exception. Phase 5 governance envelope formalizes refusal posture."
	}, {
		id:       "oq-ntf-operational-exception-formalization-7"
		question: "When operational exception (e.g., during incident) creates pressure to formalize ad-hoc admissibility expansion permanently, what governance gates prevent it? Mutation governance asymmetric (mirror de FCE) should suffice — but specific NTF formalization paths need explicit design."
		impact:   "Defines anti-formalization defenses against post-hoc exception canonicalization."
		rationale: "Founder Phase 1.6 coverage area #7. Hypothesis: Phase 5 governance envelope implements explicit 'incident-derived mutations require post-incident ADR + parallel SRR + 90-day review cycle before formalization'."
	}, {
		id:       "oq-ntf-cross-jurisdictional-evidentiary-8"
		question: "When evidentiary contract spans jurisdictions (e.g., LATAM regulatory body + Brazilian compliance authority), how compose audit chain canonical? Whose evidentiary standard prevails? Conflicting standards = refusal OR layered satisfaction?"
		impact:   "Cross-border evidentiary governance is complex; affects multi-region rollout."
		rationale: "Hypothesis: each jurisdiction declares its own evidentiary contract per regulatory authority via IDC/REW ACL translation. Conflicting requirements = layered satisfaction (satisfy strictest superset) OR canonical refusal if structurally incompatible. Defer to Phase 3 domain-model design + future cross-BC tekton-spec primitives."
	}, {
		id:       "oq-ntf-provider-lifecycle-cascading-9"
		question: "Provider goes out-of-business / undergoes M&A / undergoes capability change: cascading impact on dependent certifications? Per Phase 1.5.B Section C dependency graph + capability registry — partial automation exists. But for unforeseen scenarios?"
		impact:   "Operational continuity vs ontological integrity tension during provider lifecycle events."
		rationale: "Hypothesis: provider lifecycle events trigger CapabilityDependencyChainImpacted events + cascading suspension + re-certification cycle obligatory. Defer concrete protocol to Phase 5 governance envelope."
	}]

	verificationMetrics: [{
		id:     "vm-ntf-zero-silent-admissibility-expansion"
		metric: "Count of admissibility expansions (new contract class admissibility OR scope expansion) WITHOUT explicit certification ceremony"
		target: "0 occurrences per quarter; ANY occurrence triggers L3 architectural escalation"
		onBreach: {
			escalationRef: "scope-boundary-expansion-attempts"
			rationale:     "Per C14 + C15: ontological integrity primary. Any silent expansion = catastrophic constitutional violation."
		}
		rationale: "Materializes C14 + C15 mechanically. Verification via audit comparison: certifications-as-implemented vs certifications-as-formally-issued."
	}, {
		id:     "vm-ntf-refusal-rate-as-integrity-preservation"
		metric: "Refusal rate (TransportContractAdmissibilityRefused + AdmissibilityConservatismTriggered per total dispatch requests)"
		target: "Refusal rate é OBSERVED metric NOT optimization target. Sustained 0% may indicate over-admission (per C11 conservatism); sustained increasing trend warrants analysis but NÃO automatic admissibility relaxation."
		onBreach: {
			escalationRef: "refusal-reinterpretation-pressure"
			rationale:     "Per drift class #12 + founder anti-fatigue framing: refusal rate é integrity preservation signal, NÃO operational failure. Investigation analyzes cause (legitimate refusal vs over-conservatism); response NÃO is admissibility relaxation."
		}
		rationale: "Materializes anti-fatigue canonical clause (paralelo a FCE) + bd-refusal-over-degradation."
	}, {
		id:     "vm-ntf-certification-scope-adherence"
		metric: "Count of CertificationScopeExceeded events per quarter, classified por outcome (refused OR re-certified)"
		target: "100% of out-of-scope queries produce explicit event (no silent admission). Re-certification rate é OBSERVED (não optimization)."
		onBreach: {
			escalationRef: "scope-boundary-expansion-attempts"
			rationale:     "Per C13 + C15: scope sovereignty preserved. Silent extension = ontological violation."
		}
		rationale: "Materializes C13 mechanically; scope-bounded certification verified continuously."
	}, {
		id:     "vm-ntf-tier-separation-integrity"
		metric: "Count of provider claims entering Tier 2 (admissibility matrix) WITHOUT passing certification gate"
		target: "0 occurrences. Any occurrence indicates gate compromise."
		onBreach: {
			escalationRef: "stale-claim-acceptance"
			rationale:     "Per C8 admissibility sovereignty + bd-substrate-two-tier: gate is constitutional center. Bypass = sovereignty violation."
		}
		rationale: "Materializes two-tier substrate separation mechanically."
	}, {
		id:     "vm-ntf-replay-forbidden-isolation"
		metric: "Count of replay-forbidden messages entering persistence/queue/DLQ/reprocessing flows"
		target: "0 occurrences. Any occurrence = critical integrity breach."
		onBreach: {
			escalationRef: "replay-forbidden-retry-violations"
			rationale:     "Per C9 replay-forbidden lifecycle isolation: replay-forbidden in retry flow = semantic identity corruption (OTP being re-sent vs new OTP issued)."
		}
		rationale: "Materializes C9 + bd-replay-distinct-from-retry mechanically. Critical for OTP + single-use semantic contracts."
	}, {
		id:     "vm-ntf-epistemic-asymmetry-preserved"
		metric: "Confidence weighting differential between provider-confirmed-success and transport-observed-success states; provider-claim suspicion weight ≥ HIGH for confirmation states"
		target: "Differential maintained: provider claims = HIGH suspicion / transport-observed = LOW suspicion. Inversion indicates epistemic collapse."
		onBreach: {
			escalationRef: "transport-observed-inference-attempts"
			rationale:     "Per C10 + Phase 1.5.B Section D ajuste #4: asymmetry é canonical defense against false-success amplification."
		}
		rationale: "Materializes epistemic asymmetry: false-success é catastrophic; false-failure recoverable."
	}, {
		id:     "vm-ntf-empirical-reliability-ontology-isolation"
		metric: "Count of admissibility decisions referencing empirical reliability AS justification for admissibility expansion (vs as confidence input within existing scope)"
		target: "0 occurrences. Empirical reliability é admissibility INPUT within scope, NUNCA admissibility EXPANSION rationale."
		onBreach: {
			escalationRef: "empirical-reliability-expansion-attempts"
			rationale:     "Per C12 + C14: ontological boundary preserved against empirical seduction."
		}
		rationale: "Materializes C12 observational contamination boundary + C14 evidence-vs-expansion asymmetry."
	}]

	rationale: """
		Bounded context canvas: Notifications & Communications.
		NTF é admissibility-certified guarantee transport governance
		layer — preservation infrastructure paralelo arquitetural ao
		FCE (constitutional infrastructure for economic convergence).

		Identity canonical: NTF NÃO entrega mensagens. NTF preserva
		guarantee semantics declaradas across heterogeneous transports
		e providers. NÃO é messaging system, notification infrastructure,
		communications platform, OR engagement intelligence engine.

		Constitutional structure: 15 clauses C1-C15 + 12 drift classes
		+ 6 canonical transport contracts + 4 communication canonical
		clauses (CC1-CC4). C7 é constitutional center (refuse rather
		than degrade); C8 admissibility sovereignty; C11 conservatism
		under uncertainty; C14 evidence-vs-expansion asymmetry (NEW
		Phase 1.7); C15 certification non-transitivity (NEW Phase 1.7).

		Two-tier substrate canonical: Tier 1 provider capability claims
		(evidence-grounded) + Tier 2 admissibility certifications (gated
		via cap-admissibility-certification-issuance). Provider claims
		NUNCA enter canonical substrate directly. Empirical reliability
		alone CANNOT expand admissibility (C12 + C14).

		Family Mesh pattern emergent: FCE preserva semantic integrity
		of economic convergence; NTF preserva admissibility integrity
		of communication guarantees. Ambos refusal-centered,
		mechanically conservative, anti-degradation infrastructures.
		Padrão arquitetural Mesh constitutional emerging — protect
		different ontologies but share posture canonical.

		11 capabilities derived from admissibility matrix (Phase 1.3
		framework + 1.3.B evidence model + 1.3.C two-tier substrate +
		certification scope boundary).

		10 businessDecisions canonical (bd-substrate-two-tier
		foundational + 9 derived). 34 communication entries (14
		inbound + 20 outbound) materializam ontology canonical
		via 4 CC clauses.

		5 stakeholders (sh-01 + sh-02 + sh-04 + sh-05 + sh-06):
		recipients structurally aligned com fidelity preservation;
		regulator aligned via evidentiary contracts; operators aligned
		mas operationally exposed to all 12 drift class pressures;
		adversary structurally misaligned — design rejects estructuralmente.

		Governance scope 7+7+12: autonomous é deterministic protocol
		execution; supervised é canonical change requiring founder
		approval; escalation criteria cobrem 12 drift classes + 15
		constitutional clauses violations.

		3 assumptions (provider misalignment + institutional pressure +
		empirical-admissibility independence); 9 openQuestions
		(covering 7 founder Phase 1.6 coverage areas + 2 cross-
		jurisdictional/provider-lifecycle extensions); 7 verification
		metrics (covering C9-C15 constitutional protection + anti-
		fatigue clause).

		Authoring manual section-by-section per manualAuthoringProtocol
		(adr-057). Materializado em 7 sub-phases iterativas com
		founder review pre-write integrated: Phase 1.1 identity +
		classification + NTPs + 8 drift classes → Phase 1.2 transport
		contract model + admissibility matrix → Phase 1.3 capabilities
		→ Phase 1.3.B evidence model + C8/C9/C10 + drift #9-11 →
		Phase 1.3.C two-tier substrate + C11/C12/C13 + drift #11 →
		Phase 1.4 businessDecisions + stakeholders → Phase 1.5
		communication + 4 CC clauses → Phase 1.5.B refusal/certification
		split + dependency graph + epistemic asymmetry + drift #12 →
		Phase 1.6 incentiveAnalysis + governanceScope → Phase 1.7
		(este commit) C14 + C15 + assumptions + openQuestions +
		verificationMetrics + outer rationale.

		Phase 1.8 (SRR srr-ntf-canvas) closes Phase 1 canvas.
		Phase 2-5 (glossary + domain-model + agent-spec + governance
		envelope) close WI-063 NTF bootstrap.

		Cross-BC alignment com FCE (WI-043 closed): family Mesh
		pattern explicit. Future cross-BC propagation candidates
		identified via founder Phase 5 reflection: anti-capabilities
		framework, refusal-as-success semantics, attempt-vs-success-rate
		distinction, governance-cannot-self-weaken clause, etc.
		"""
}
