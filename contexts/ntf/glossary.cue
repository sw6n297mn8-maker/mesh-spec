package ntf

// glossary.cue — Ubiquitous Language: Notifications & Communications.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// =============================================================================
// CENTERING PRINCIPLE
// =============================================================================
//
// NTF glossary é constitutional vocabulary artifact for admissibility-
// certified guarantee transport governance — NÃO notification terminology
// dictionary. Cada termo canoniza concept cuja má-interpretação levaria
// NTF a colapsar em "notification infrastructure" OR "messaging platform"
// OR "engagement intelligence layer".
//
// Family Mesh pattern: paralelo a FCE glossary (boundary-hardening
// artifact for conditional economic authority); NTF glossary é
// boundary-hardening artifact for communication guarantee admissibility.
//
// =============================================================================
// 22 termos em 5 axes semânticas:
// (A) Substrate & Identity — 4 termos
// (B) Admissibility Framework — 5 termos
// (C) Transport Contract — 5 termos
// (D) Evidence & Provenance — 4 termos
// (E) Lifecycle & Anti-Patterns — 4 termos
//
// Cross-canvas alignment: glossary materializes 15 constitutional clauses
// (C1-C15) + 12 drift classes + 6 canonical contracts + 4 communication
// clauses (CC1-CC4) declarados em canvas Phase 1 (commit 2484b2f).
//
// Lenses aplicadas (5):
// - lens-mechanism-design (primária — admissibility certification gate)
// - lens-trust-and-credibility-design
// - lens-distributed-systems-design
// - lens-regulatory-compliance-as-architecture
// - lens-domain-language-and-terminology-design

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "ntf"
	name: "Glossário NTF — Notifications & Communications"

	boundedContextRef: "ntf"

	terms: [{
		// === CLUSTER A — SUBSTRATE & IDENTITY (4 terms) ===
		code:   "term-admissibility-certification"
		name:   "Certificação de Admissibilidade"
		termEn: "Admissibility Certification"
		definition: """
			Tier 2 entity canonical do substrate NTF — guarantee
			estructuralmente accepted into admissibility matrix após
			passar gate de certificação per C8 (admissibility
			sovereignty) + C11 (conservatism) + C13 (scope bounded) +
			C14 (evidence ≠ expansion) + C15 (non-transitive). Carries
			capability claim + verification evidence chain + confidence
			class + scope boundary + sensitivity context. Distinct from
			Tier 1 ProviderCapabilityClaim — claim alone NUNCA enter
			canonical substrate; passage requires explicit certification
			act under governance.
			"""
		category:  "entity"
		rationale: "Term canoniza Tier 2 substrate — NTF admissibility authority materializada. Sem este term explicit, sistema collapses Tier 1 claims into Tier 2 substrate silently (operational folklore precursor). Identity nucleus do BC: admissibility certification é what NTF preserves; provider capability claims é what providers assert."
		antiTerms: [{
			term:          "Provider Capability"
			clarification: "Provider capability é Tier 1 claim — assertion plus evidence. Certification é Tier 2 promotion via gate. Confundir é foundational error — provider capability alone NÃO grants ontological admission per C14."
		}, {
			term:          "Empirical Reliability"
			clarification: "Empirical reliability é production observability metric — informs confidence within already-certified scope per C12. NUNCA grants certification expansion per C14 (evidence-vs-expansion asymmetry)."
		}, {
			term:          "Service Level Agreement"
			clarification: "SLA é commercial commitment between issuer and provider. Certification é internal ontological admission gate em NTF. Mismatch: SLAs negotiated, certifications gated mechanically per evidence + scope + class."
		}]
		rejectedAlternatives: [{
			term:   "AdmissibilityRecord"
			reason: "Record sugere passive accounting artifact; certification é active gate-passage with explicit governance."
		}, {
			term:   "AdmittedCapability"
			reason: "Conflates capability (claim) com admission (gated state) — anti-pattern para Tier 1/Tier 2 separation."
		}, {
			term:   "TrustedProviderCapability"
			reason: "Trust-based framing é forbidden by construction per ANTI-16 P0 (cannot-create-trust-based-fast-paths em FCE pattern adapted). Certification é evidence-grounded, NÃO trust-grounded."
		}]
		examples: [{
			context:   "Provider claim → admissibility certification"
			instance:  "Twilio SMS provider claims ordered-delivery via verification methodology 'production-validated'; evidence pointer documented; NTF gate applies C11 conservatism + C12 boundary check; promotes claim to Tier 2 admissibility certification for tc-transactional-financial contract class with scope (BR/LATAM, ≤160 chars UTF-8, < 100/sec)."
			rationale: "Gate-passage materialized; certification ≠ claim."
		}, {
			context:   "Certification scope boundary"
			instance:  "Certification scope binds: out-of-scope query (e.g., 500/sec burst exceeding certified 100/sec) triggers CertificationScopeExceeded event + refusal OR re-certification per issuer policy. Certification NÃO inherits universally."
			rationale: "C13 + C15: scope sovereignty + non-transitivity enforced canonically."
		}]
		relatedTerms: [
			"term-provider-capability-claim",
			"term-admissibility-matrix",
			"term-certification-scope-boundary",
			"term-verification-evidence",
			"term-confidence-class",
			"term-two-tier-substrate",
		]
		layerMapping: {
			codeTerm: "AdmissibilityCertification"
			apiTerm:  "admissibility-certifications"
		}
	}, {
		code:   "term-provider-capability-claim"
		name:   "Alegação de Capability de Provider"
		termEn: "Provider Capability Claim"
		definition: """
			Tier 1 entity canonical do substrate NTF — assertion (com
			backing evidence) que provider supports specific capability
			along dimension of canonical transport contract (ordering /
			durability / equivalence / retry / ack / replay / etc).
			Carries claim subject + verification methodology + evidence
			artifacts + confidence assessment. Per C10 (provider-claim
			epistemic limitation): claim é structural input para
			certification gate, NUNCA auto-promoted to admissibility
			absent gate passage.
			"""
		category:  "entity"
		rationale: "Term canoniza Tier 1 substrate — assertion layer distinct from admission layer. Cross-BC critical separation: provider says vs NTF accepts. Sem este term, sistema collapses provider assertion into admissibility silently — foundational drift vector destroyed."
		antiTerms: [{
			term:          "Provider Capability"
			clarification: "Capability é abstract property; claim é specific assertion about capability backed by evidence at moment of claiming. Distinção semantic: capability is what provider does; claim is what provider asserts (com evidence)."
		}, {
			term:          "Verified Provider Feature"
			clarification: "Feature é commercial/marketing term; claim is canonical substrate term. Features can be marketing without verification; claims require evidence by construction."
		}, {
			term:          "Provider Documentation"
			clarification: "Documentation é support material para claim; claim é canonical assertion within NTF substrate. Documentation flows into evidence layer; claim é the structural unit."
		}]
		rejectedAlternatives: [{
			term:   "ProviderAssertion"
			reason: "Assertion technically correct mas perde 'capability' specificity. Claim é más linked to specific transport contract dimension being asserted."
		}, {
			term:   "ProviderClaim"
			reason: "Ambiguous — could mean billing claim, support claim, marketing claim. Capability-specific naming preserves substrate canonical meaning."
		}]
		examples: [{
			context:   "Provider claim Tier 1 entry"
			instance:  "Twilio claims byte-identical equivalence for SMS deliveries; verification methodology 'internal-functional-testing'; evidence pointer 'twilio-byte-test-report-2026-q1'; confidence class 'moderate-evidence'. Entry enters Tier 1; admissibility gate decides Tier 2 promotion."
			rationale: "Claim entry distinct from admissibility decision; substrate canonical preserved."
		}, {
			context:   "Claim → negative evidence → revocation"
			instance:  "Earlier ordered-delivery claim with strong-evidence confidence class; production observation detects out-of-order delivery pattern; NegativeCapabilityEvidence recorded; auto-revocation triggered per Section C model."
			rationale: "Claims revocable upon negative evidence; substrate self-corrects."
		}]
		relatedTerms: [
			"term-admissibility-certification",
			"term-verification-evidence",
			"term-confidence-class",
			"term-negative-capability-evidence",
			"term-two-tier-substrate",
		]
		layerMapping: {
			codeTerm: "ProviderCapabilityClaim"
			apiTerm:  "provider-capability-claims"
		}
	}, {
		code:   "term-guarantee-semantics"
		name:   "Semântica de Garantia"
		termEn: "Guarantee Semantics"
		definition: """
			Object canonical preserved by NTF per identity formulation —
			declared meaning of transport contract dimensions (ordering /
			durability / equivalence / retry / ack / replay / audience /
			regulatory / scope) as semantic commitment, NÃO operational
			SLA. Preservação significa: payload fidelity + delivery
			intent fidelity + transport fidelity simultaneamente
			maintained (3-tier per C1). NTF preserva guarantee
			semantics declaradas, NÃO 'messages' nem 'contracts-as-
			objects'.
			"""
		category:  "value"
		rationale: "Term canoniza preserved object — what NTF actually protects. Per identity refinement Phase 1.3.C: 'NTF preserves declared communication guarantees across heterogeneous transports e providers' — guarantee é gravitational object. Sem este term, sistema interpretation drifts to 'message preservation' OR 'contract preservation' (objects), perdendo ontological subtlety."
		antiTerms: [{
			term:          "Message Content"
			clarification: "Message content é ephemeral instance; guarantee semantics é structural property estable. NTF preserves the structural property not the instance."
		}, {
			term:          "Service Quality"
			clarification: "Service quality é operational metric; guarantee semantics é constitutional commitment. Quality is observed; semantics is preserved."
		}, {
			term:          "Delivery Promise"
			clarification: "Promise é marketing/commercial framing; semantics é structural canonical commitment governed by C1 fidelity tripartition. NTF não makes promises — preserves semantics."
		}]
		rejectedAlternatives: [{
			term:   "DeliveryGuarantees"
			reason: "Generic; loses distinction between SLA (operational) and semantic commitment (constitutional). Guarantee semantics é canonical em substantive sense."
		}, {
			term:   "TransportCommitments"
			reason: "Commitments contextual; semantics é structural property. Per Phase 1.3.C identity refinement final."
		}]
		examples: [{
			context:   "Semantic preservation across providers"
			instance:  "tc-regulatory-evidentiary declared with strict semantic equivalence + byte-identical representational equivalence + persistent retry + receiver-confirmation-required + evidentiary regulatory + replay-forbidden. NTF preserves ALL declared dimensions across provider substitution — Twilio swap to Sendgrid não muda guarantee semantics."
			rationale: "Provider-agnostic preservation per substitutability preservation principle."
		}, {
			context:   "Refusal preserves semantics"
			instance:  "Issuer declares contract NTF cannot preserve (e.g., byte-identical over format-translating channels only available). Per C7: refusal preserves semantic integrity by halting rather than degrading. Guarantee semantics preserved via refusal, not via best-effort attempt."
			rationale: "Refusal canonical é semantic preservation, NÃO failure."
		}]
		relatedTerms: [
			"term-canonical-transport-contract",
			"term-fidelity-tripartition",
			"term-admissibility-refusal",
		]
		layerMapping: {
			codeTerm: "GuaranteeSemantics"
			apiTerm:  "guarantee-semantics"
		}
	}, {
		code:   "term-two-tier-substrate"
		name:   "Substrate de Duas Camadas"
		termEn: "Two Tier Substrate"
		definition: """
			Canonical framework do NTF separating Tier 1 (provider
			capability claim layer — assertions com evidence) de
			Tier 2 (admissibility certification layer — accepted into
			matrix). Provider claims NUNCA enter canonical substrate
			directly; devem cruzar admissibility certification gate
			(cap-admissibility-certification-issuance) under C7 + C8 +
			C11 + C12 + C13 + C14 + C15. Substrate two-tier é
			structural epistemic separation: 'o que provider faz' vs
			'o que sistema aceita assumir como verdade'.
			"""
		category:  "classification"
		rationale: "Term canoniza foundational structural distinction — provider assertion layer separated from system admission layer. Per bd-substrate-two-tier (canvas Phase 1.4): without two-tier separation, provider claims silently entram operational folklore (precursor de drift class #6 transport-intelligence creep). Substrate é truth substrate do NTF; two-tier é structural organization."
		antiTerms: [{
			term:          "Capability Registry"
			clarification: "Registry sugere flat catalog of capabilities. Two-tier é structured separation com gate. Catalog model loses gate semantics — provider entries silently treated as admissible."
		}, {
			term:          "Provider Database"
			clarification: "Database é storage abstraction; substrate é epistemic structure. Database can hold claims AND certifications interchangeably — substrate separates them by ontological status."
		}]
		rejectedAlternatives: [{
			term:   "EvidenceLayer"
			reason: "Single-layer framing; loses structural separation. Two-tier explicit names the canonical structural commitment."
		}, {
			term:   "CapabilityHierarchy"
			reason: "Hierarchy implies ordering/depth; tier é discriminating ontological status (claim vs certified), NÃO depth."
		}]
		examples: [{
			context:   "Gate-passage as ontological promotion"
			instance:  "Provider X submits claim 'ordered-delivery for SMS' in Tier 1 with verification evidence. Operator submits SubmitVerificationEvidence command; gate evaluates confidence class meets threshold + provenance independence adequate + scope declared. Gate emits CertificationIssued event; claim promoted to Tier 2 admissibility certification."
			rationale: "Two-tier transition is canonical structural event."
		}, {
			context:   "Tier collapse rejected"
			instance:  "Operator attempts shortcut: 'just add this claim directly to admissibility matrix; we trust provider'. Action rejected by construction — gate cannot be bypassed; Tier 1 → Tier 2 only via cap-admissibility-certification-issuance. Trust-based promotion (ANTI-16 P0 pattern) forbidden."
			rationale: "Structural separation enforced by capability separation, NÃO policy."
		}]
		relatedTerms: [
			"term-admissibility-certification",
			"term-provider-capability-claim",
			"term-admissibility-matrix",
			"term-verification-evidence",
		]
		layerMapping: {
			codeTerm: "TwoTierSubstrate"
			apiTerm:  "two-tier-substrate"
		}
	}, {
		// === CLUSTER B — ADMISSIBILITY FRAMEWORK (5 terms) ===
		code:   "term-admissibility-matrix"
		name:   "Matriz de Admissibilidade"
		termEn: "Admissibility Matrix"
		definition: """
			Gravitational core operational do NTF — canonical mechanical
			artifact owned pelo BC mapping declared transport contract
			dimensions (per AdmissibilityCertification) against
			incompatibility classes (A contract-internal / B1
			unsatisfiable / B2 temporarily-unavailable / C provider-
			specific). Matrix application produces admissibility verdict
			mechanically; NÃO semantic interpretation. Equivalent
			estrutural ao AuthorizationConvergenceSet do FCE. Mutations
			are ADR-grade decisions, NÃO runtime improvisation.
			"""
		category:  "value"
		rationale: "Term canoniza gravitational operational core — everything in NTF derives from matrix application. Per founder Phase 1.2.B framing: matrix é equivalente estrutural ao FCE ConvergenceSet. Sem este term canonicamente posto, capability discussion drifts to channel-orientation (per founder ajuste Phase 1.3 'capabilities derive from matrix, NÃO channels')."
		antiTerms: [{
			term:          "Routing Table"
			clarification: "Routing table é dynamic operational artifact mapping requests to handlers. Matrix é static canonical artifact mapping declared dimensions to admissibility verdicts. Routing implies dynamic decision; matrix implies mechanical lookup."
		}, {
			term:          "Configuration"
			clarification: "Configuration é tunable operational parameters; matrix é canonical structural commitment. Configuration changes via operator; matrix mutations via ADR + founder approval."
		}, {
			term:          "Policy Rules"
			clarification: "Policies are procedural decision logic; matrix é declarative mapping. Policy can be runtime-adjusted; matrix changes are architectural decisions."
		}]
		rejectedAlternatives: [{
			term:   "CompatibilityMatrix"
			reason: "Compatibility é symmetric concept; admissibility é one-directional (issuer requests, NTF admits/refuses). Naming preserves direction asymmetry."
		}, {
			term:   "AdmissibilityTable"
			reason: "Table is generic; matrix specifically denotes dimensional mapping. Multiple dimensions intersect at admissibility verdicts — matrix is structurally appropriate."
		}]
		examples: [{
			context:   "Matrix application produces verdict"
			instance:  "Issuer requests dispatch with contract: ordered + durable + byte-identical + persistent + receiver-confirmation + human + evidentiary + replay-forbidden. Matrix applied: all dimensions compatible structurally; no Class A internal contradiction; transport class for evidentiary + receiver-confirmation requires specific provider mode; certification scope checked. Verdict: admissible (DispatchAdmissibilityCertified event emitted)."
			rationale: "Mechanical verdict; no semantic interpretation."
		}, {
			context:   "Matrix application detects Class A incompatibility"
			instance:  "Issuer requests: retry=persistent + replay=replay-forbidden. Matrix applies: dimensions internally contradictory per founder Phase 1.2.B Section D incompatibility pair. Verdict: Class A refusal; TransportContractAdmissibilityRefused event emitted with failing dimensions enumerated."
			rationale: "Internal contradiction detected mechanically; refusal canonical."
		}]
		relatedTerms: [
			"term-admissibility-incompatibility-class",
			"term-admissibility-refusal",
			"term-canonical-transport-contract",
			"term-certification-scope-boundary",
		]
		layerMapping: {
			codeTerm: "AdmissibilityMatrix"
			apiTerm:  "admissibility-matrix"
		}
	}, {
		code:   "term-admissibility-incompatibility-class"
		name:   "Classe de Incompatibilidade de Admissibilidade"
		termEn: "Admissibility Incompatibility Class"
		definition: """
			Canonical 4-class enumerable of admissibility refusal reason
			discriminating structural impossibility, transport
			unavailability, and provider-specific limitation:
			- Class A: contract-internal incompatibility (dimensions
			  internamente contraditórias by issuer);
			- Class B1: unsatisfiable (no transport class architecturally
			  capable of preserving all declared dimensions);
			- Class B2: temporarily-unavailable (structurally satisfiable
			  but transient unavailability — provider outage, capacity
			  exhaustion, certification lapsed);
			- Class C: provider-specific (contract + transport class
			  admissible, mas selected provider has constraint).
			"""
		category:  "classification"
		rationale: "Term canoniza explicit refusal taxonomy. Per Phase 1.5 + Phase 1.5.B Section split: Class B unified versus split é canonical refinement — B1 architectural impossibility (issuer adjusts intent) versus B2 transient (issuer retry semantics). Conflating Class B variants encourages drift toward 'best-effort' tolerance."
		antiTerms: [{
			term:          "Error Code"
			clarification: "Error code is technical fault identifier; incompatibility class is canonical structural diagnostic. Classes have ontological meaning (structural impossible vs transient unavailable); errors are technical signals."
		}, {
			term:          "Failure Reason"
			clarification: "Failure reason is operational diagnostic; incompatibility class is structural refusal taxonomy. Refusal é canonical valid outcome NÃO failure."
		}]
		rejectedAlternatives: [{
			term:   "RefusalReason"
			reason: "Reason is descriptive but loses class taxonomy commitment. Class é structured enumerable with distinct ontological status (A/B1/B2/C)."
		}, {
			term:   "AdmissibilityVerdict"
			reason: "Verdict is the OUTCOME of matrix application; class is the STRUCTURAL CATEGORY of incompatibility. Both terms exist canonically but distinguish role."
		}]
		examples: [{
			context:   "Class A contract-internal"
			instance:  "Issuer declares retry=persistent + replay=replay-forbidden in same contract. Internal contradiction (replay-forbidden cannot retry via persistence — that IS replay). Class A verdict; issuer must adjust contract dimensions before re-request."
			rationale: "Internal contradiction = Class A."
		}, {
			context:   "Class B2 temporarily-unavailable"
			instance:  "Provider Twilio undergoing maintenance outage; previously admissible contract briefly unsatisfiable. Class B2 verdict (not B1 — structurally admissible just currently unavailable); issuer policy decides retry semantics."
			rationale: "Transient unavailability = Class B2, distinct from architectural impossibility B1."
		}, {
			context:   "Class C provider-specific"
			instance:  "Contract requires byte-identical equivalence; matrix admissible structurally; but selected provider mode strips certain Unicode characters. Class C verdict; alternative provider per issuer policy OR refusal."
			rationale: "Provider-specific limitation = Class C, distinguishes from transport class limitation B1."
		}]
		relatedTerms: [
			"term-admissibility-matrix",
			"term-admissibility-refusal",
			"term-certification-scope-boundary",
		]
		layerMapping: {
			codeTerm: "AdmissibilityIncompatibilityClass"
			apiTerm:  "admissibility-incompatibility-class"
		}
	}, {
		code:   "term-admissibility-refusal"
		name:   "Recusa de Admissibilidade"
		termEn: "Admissibility Refusal"
		definition: """
			Canonical first-class outcome do NTF per C7 (constitutional
			center) — explicit emission of TransportContractAdmissibilityRefused
			event quando admissibility matrix produces incompatibility
			verdict (Class A/B1/B2/C) OR AdmissibilityConservatismTriggered
			event quando epistemic uncertainty insufficient per C11. NÃO
			silent degradation; NÃO best-effort fallback; NÃO retry-and-
			hope. Refusal é structural preservation outcome — equivalent
			estrutural ao FCE AP5 (cst-refusal-is-valid-outcome).
			"""
		category:  "event"
		rationale: "Term canoniza first-class valid outcome — counter-intuitive ao reviewers institucionais que reinterpret refusal como operational failure. Per founder Phase 1.3 framing: refusal preserves contract integrity by halting rather than degrading. Sem this term canonicamente posto, BC drift para 'best-effort delivery' attractor."
		antiTerms: [{
			term:          "Delivery Failure"
			clarification: "Failure implies operational fault; refusal is canonical preservation outcome. Refusal protects integrity; failure indicates system breakdown."
		}, {
			term:          "Rejection"
			clarification: "Rejection is generic term (database rejection, validation rejection); admissibility refusal is constitutional outcome carrying explicit class + failing dimensions + resolution path."
		}, {
			term:          "Service Unavailable"
			clarification: "Service unavailable implies transient operational state; refusal can be structural (Class A internal contradiction = permanent until issuer adjusts contract)."
		}]
		rejectedAlternatives: [{
			term:   "AdmissibilityVerdictNegative"
			reason: "Technically correct mas loses 'first-class outcome' canonical framing. Refusal carries structural dignity equal to successful delivery."
		}, {
			term:   "DispatchDenied"
			reason: "Denied is binary; refusal carries class taxonomy (A/B1/B2/C) + resolution path + scope context."
		}]
		examples: [{
			context:   "Refusal canonical event emission"
			instance:  "Issuer requests contract with Class A internal contradiction. TransportContractAdmissibilityRefused event emitted with payload: class=Class-A, failingDimensions=[retry=persistent, replay=replay-forbidden], resolutionPath='Adjust contract: retry=bounded OR replay=replayable'. State preserved (no partial dispatch)."
			rationale: "Refusal carries structural dignity; consumer can act on canonical event."
		}, {
			context:   "Refusal-as-success in audit trail"
			instance:  "Daily metrics show 8% refusal rate. Anti-fatigue clause (governance envelope Phase 5) applies: high refusal rate é integrity preservation metric, NÃO operational failure. Refusal events stored with same dignity as DispatchConfirmedTransportLayer events em audit trail."
			rationale: "Refusal-as-success operational semantic preserved."
		}]
		relatedTerms: [
			"term-admissibility-matrix",
			"term-admissibility-incompatibility-class",
			"term-admissibility-conservatism",
			"term-refusal-reinterpretation-gravity",
		]
		layerMapping: {
			codeTerm: "AdmissibilityRefusal"
			apiTerm:  "admissibility-refusal"
		}
	}, {
		code:   "term-admissibility-conservatism"
		name:   "Conservadorismo de Admissibilidade"
		termEn: "Admissibility Conservatism"
		definition: """
			Canonical posture per C11 — when evidence quality insufficient
			to certify guarantee at level required by contract class, NTF
			must conservatively REJECT admissibility rather than
			optimistically assume capability. Default sob incerteza é
			refusal, NÃO optimistic admission. Manifests as
			AdmissibilityConservatismTriggered event (distinct from
			TransportContractAdmissibilityRefused — that's structural
			impossibility; this is epistemic insufficiency). Completes
			triangle constitutional C7 + C8 + C11.
			"""
		category:  "rule"
		rationale: "Term canoniza epistemic closure of constitutional layer. Per founder Phase 1.3.C: without conservatism, BC drift lentamente para pragmatic optimism — 'we trust this provider', 'this evidence is good enough', 'we'll re-verify later'. C11 closes that drift vector by construction. Sem this term, 'caution' becomes negotiable rather than structural."
		antiTerms: [{
			term:          "Risk Aversion"
			clarification: "Risk aversion is operational/commercial posture; conservatism is structural epistemic commitment. Risk can be managed; epistemic insufficiency must be honored."
		}, {
			term:          "Best Effort"
			clarification: "Best effort is exactly opposite — accept what's available, attempt with what's known. Conservatism refuses what's insufficient."
		}, {
			term:          "Defensive Programming"
			clarification: "Defensive programming is implementation pattern; conservatism is constitutional commitment. Programming defense can be relaxed; constitutional conservatism is structural."
		}]
		rejectedAlternatives: [{
			term:   "EpistemicCaution"
			reason: "Caution implies operational discretion; conservatism implies structural commitment. Per C11: refusal under uncertainty é default, not discretionary choice."
		}, {
			term:   "AdmissibilityPrudence"
			reason: "Prudence carries deliberation connotation; conservatism implies mechanical default. Conservatism = if uncertain → refuse, applied mechanically."
		}]
		examples: [{
			context:   "Conservatism triggers under insufficient evidence"
			instance:  "Provider capability claim has confidence class 'provisional' (insufficient methodology); issuer requests evidentiary contract requiring 'strong-evidence' threshold per Section B sensitivity. Conservatism triggers: AdmissibilityConservatismTriggered event emitted; refusal explicit not for structural impossibility but for epistemic insufficiency."
			rationale: "Distinction: 'I cannot guarantee' (conservatism) vs 'I cannot do' (impossibility)."
		}, {
			context:   "Conservatism resists pragmatism pressure"
			instance:  "Operator pressure: 'this provider has worked 12 months reliably, just admit them for evidentiary class'. C12 + bd-empirical-reliability-cannot-expand-ontology: empirical reliability does NOT grant expansion. Conservatism + C14 (evidence-vs-expansion asymmetry): refusal canonical until proper certification methodology applied."
			rationale: "Conservatism protects against pragmatic drift structurally."
		}]
		relatedTerms: [
			"term-admissibility-refusal",
			"term-confidence-class",
			"term-verification-evidence",
		]
		layerMapping: {
			codeTerm: "AdmissibilityConservatism"
			apiTerm:  "admissibility-conservatism"
		}
	}, {
		code:   "term-certification-scope-boundary"
		name:   "Fronteira de Escopo de Certificação"
		termEn: "Certification Scope Boundary"
		definition: """
			Canonical structural property of AdmissibilityCertification
			per C13 + C15 — certifications são scope-bounded
			(non-transitive and non-inheritable) across traffic profile +
			geography + payload constraints + provider mode +
			environmental assumptions. Out-of-scope queries (burst
			exceeding profile, payload exceeding constraints, geography
			outside admitted regions, provider mode differing,
			environmental assumptions unmet) trigger CertificationScopeExceeded
			event + refusal OR re-certification per issuer policy. NÃO
			silent extension; NÃO 'partial certification leakage'.
			"""
		category:  "value"
		rationale: "Term canoniza explicit scope-bounded property — without scope boundary, certifications tend to leak universality (common drift via implicit assumption that low-throughput certification extends to peak). Per founder ajuste Phase 1.3.C: scope boundary forces explicit envelope; out-of-scope queries require new certification cycle."
		antiTerms: [{
			term:          "SLA Range"
			clarification: "SLA range is commercial parameter; scope boundary is structural certification limit. SLA negotiated commercially; scope boundary enforced canonically."
		}, {
			term:          "Operational Envelope"
			clarification: "Envelope is operational concept (system's operational range); scope boundary is structural certification commitment. Envelope can expand operationally; scope boundary changes require re-certification."
		}, {
			term:          "Service Limits"
			clarification: "Service limits are quotas; scope boundary is canonical structural commitment. Quotas exist for billing/capacity; scope boundary exists for admissibility integrity."
		}]
		rejectedAlternatives: [{
			term:   "CertificationLimits"
			reason: "Limits implies operational quotas; boundary implies structural commitment. Per C13: scope sovereignty preserved canonically."
		}, {
			term:   "AdmissibilityRange"
			reason: "Range loses dimensional structure; boundary carries 5-dimensional structure (traffic + geography + payload + provider mode + environmental)."
		}]
		examples: [{
			context:   "Scope-bounded certification protects against burst"
			instance:  "Certification 'ordered SMS via provider X, throughput < 100/sec, regions BR/LATAM, UTF-8, ≤160 chars'. Issuer request during peak (500/sec). Out-of-scope query triggers CertificationScopeExceeded event; refusal OR re-certification required."
			rationale: "Burst conditions trigger boundary canonically — universality leak prevented."
		}, {
			context:   "Provider mode change invalidates scope"
			instance:  "Provider announces capability change (API version migration, new feature). ProviderCapabilityChangeNotified event triggers re-certification per C13 boundary check + cascading dependency invalidation per Phase 1.5.B Section C."
			rationale: "Scope boundary tracks provider lifecycle; cascading invalidation preserves integrity."
		}]
		relatedTerms: [
			"term-admissibility-certification",
			"term-admissibility-matrix",
			"term-canonical-transport-contract",
		]
		layerMapping: {
			codeTerm: "CertificationScopeBoundary"
			apiTerm:  "certification-scope-boundary"
		}
	}, {
		// === CLUSTER C — TRANSPORT CONTRACT (5 terms) ===
		code:   "term-canonical-transport-contract"
		name:   "Contrato Canônico de Transporte"
		termEn: "Canonical Transport Contract"
		definition: """
			Issuer-declared structured commitment specifying preserved
			guarantee semantics across 9 canonical dimensions: ordering +
			durability + semantic-equivalence + representational-
			equivalence + retry + ack + audience + regulatory + replay.
			6 named bundles canonical: tc-transactional-financial,
			tc-regulatory-evidentiary, tc-system-webhook,
			tc-operational-update, tc-alerting, tc-otp-single-use.
			Dimensions são issuer-owned (declares what guarantees são
			desired); admissibility é NTF-owned (declares whether
			guarantees são structurally preservable per C8).
			"""
		category:  "value"
		rationale: "Term canoniza canonical contract structure per founder Phase 1.2 transport contract model. Sem this term as central canonical concept, contract dimensions discussed as channel-specific features (drift to channel-orientation). Per founder ajuste Phase 1.3: capabilities derive from contract model (não from channels)."
		antiTerms: [{
			term:          "Message Type"
			clarification: "Message type is operational classification (email vs SMS vs push); contract is dimensional semantic specification. Type implies channel; contract implies semantic guarantee."
		}, {
			term:          "Delivery Configuration"
			clarification: "Configuration implies tunable parameters; contract implies declared semantic commitment. Configuration adjusted; contract preserved or refused."
		}, {
			term:          "Communication Channel"
			clarification: "Channel is transport mechanism (SMS, email, webhook); contract is semantic commitment across channels. Channel is implementation; contract is intent."
		}]
		rejectedAlternatives: [{
			term:   "TransportProfile"
			reason: "Profile suggests pre-set configurations; contract suggests bespoke per-message declaration with structural commitment."
		}, {
			term:   "DispatchSpecification"
			reason: "Dispatch is operational action; contract precedes dispatch — admissibility validated antes de dispatch attempt."
		}]
		examples: [{
			context:   "tc-otp-single-use canonical"
			instance:  "Contract: ordering=unordered + durability=ephemeral + semantic-equivalence=preserved + representational-equivalence=byte-identical + retry=none + ack=fire-and-forget + audience=human + regulatory=non-evidentiary + replay=replay-forbidden. Resend = nova issuance (different semantic act), NÃO retry of same."
			rationale: "Replay-forbidden + retry=none combination prevents OTP corruption."
		}, {
			context:   "tc-regulatory-evidentiary canonical"
			instance:  "Contract: ordering=ordered + durability=durable + semantic-equivalence=preserved + representational-equivalence=byte-identical + retry=persistent + ack=receiver-confirmation-required + audience=human + regulatory=evidentiary + replay=replay-forbidden. Court-grade audit trail + receiver acknowledgment routed to issuer."
			rationale: "Legal evidence requires highest fidelity + receiver confirmation."
		}]
		relatedTerms: [
			"term-fidelity-tripartition",
			"term-semantic-equivalence",
			"term-representational-equivalence",
			"term-replay-semantics",
			"term-receiver-confirmation",
			"term-admissibility-matrix",
		]
		layerMapping: {
			codeTerm: "CanonicalTransportContract"
			apiTerm:  "canonical-transport-contracts"
		}
	}, {
		code:   "term-fidelity-tripartition"
		name:   "Tripartição de Fidelidade"
		termEn: "Fidelity Tripartition"
		definition: """
			Canonical 3-tier fidelity preservation framework per C1 —
			NTF preserves three types of fidelity simultaneously, none
			substitutable for another: (1) payload fidelity (content
			semantic identity governed by equivalence dimensions);
			(2) delivery intent fidelity (constraints/requirements
			declared by issuer governed by ordering/retry/ack
			dimensions); (3) transport fidelity (agreed transport
			guarantees preserved governed by durability/audience/
			regulatory dimensions). Optimization that preserves any
			one while degrading another é forbidden by construction.
			"""
		category:  "rule"
		rationale: "Term canoniza foundational fidelity structure — sem this term, 'fidelity' becomes single-dimensional concept (payload only OR delivery only). Per founder Phase 1.2.B Section C1: tripartition closes gap onde 'NTF poderia ajudar operacionalmente' silently degrading some dimensions while preserving others."
		antiTerms: [{
			term:          "Data Integrity"
			clarification: "Data integrity é payload-only concept; tripartition includes delivery intent + transport fidelity. Reducing to data integrity loses 2/3 of canonical structure."
		}, {
			term:          "Message Reliability"
			clarification: "Reliability is operational concept; tripartition is structural commitment across 3 fidelity types. Reliability can be optimized; tripartition must be preserved integrally."
		}]
		rejectedAlternatives: [{
			term:   "MultiDimensionalFidelity"
			reason: "Generic; tripartition specifies exactly 3 types — payload + delivery intent + transport. Multi-dimensional could imply arbitrary count."
		}, {
			term:   "FullFidelity"
			reason: "Full implies completeness without structure; tripartition names structural commitment explicitly."
		}]
		examples: [{
			context:   "Tripartition preservation across canonical contracts"
			instance:  "tc-transactional-financial: payload fidelity preserved (lossy-forbidden equivalence); delivery intent fidelity preserved (ordered + persistent retry); transport fidelity preserved (durable + transport-ack). All 3 dimensions preserved simultaneously — refusal triggered if any cannot be preserved."
			rationale: "All 3 fidelity types treated structurally equal."
		}, {
			context:   "Forbidden tripartition violation"
			instance:  "Operator proposal: 'allow lossy delivery for better throughput'. Per C1 tripartition: optimization that degrades payload fidelity while preserving transport fidelity is forbidden by construction. Refusal canonical."
			rationale: "Tripartition preservation is structural commitment NÃO operational trade-off."
		}]
		relatedTerms: [
			"term-canonical-transport-contract",
			"term-semantic-equivalence",
			"term-representational-equivalence",
			"term-guarantee-semantics",
		]
		layerMapping: {
			codeTerm: "FidelityTripartition"
			apiTerm:  "fidelity-tripartition"
		}
	}, {
		code:   "term-semantic-equivalence"
		name:   "Equivalência Semântica"
		termEn: "Semantic Equivalence"
		definition: """
			Canonical contract dimension distinguishing semantic identity
			preservation per founder Phase 1.2.B Section A ajuste: split
			from representational-equivalence. Values: preserved (semantic
			identity required across channel-specific reformulation) OR
			degraded-admissible-with-issuer-consent (semantic degradation
			explicitly authorized by issuer). Distinct from
			representational-equivalence which governs byte/structure
			preservation. Issuer-owned dimension — declares semantic-
			equivalence-class per message.
			"""
		category:  "classification"
		rationale: "Term canoniza semantic-vs-representational distinction. Per founder Phase 1.2.B ajuste #1: equivalence dimension splits into semantic + representational because regulatory/evidentiary generally requires both, but operational updates may accept representational reformulation while preserving semantics."
		antiTerms: [{
			term:          "Content Equivalence"
			clarification: "Content equivalence ambiguous between semantic and representational. Semantic equivalence specifically means meaning-preserving; representation can vary."
		}, {
			term:          "Format Compatibility"
			clarification: "Format compatibility is representational concept; semantic equivalence is meaning-preserving concept. Email HTML and SMS plaintext may be semantically equivalent but format-incompatible."
		}]
		rejectedAlternatives: [{
			term:   "MeaningPreservation"
			reason: "Plain language but loses 'equivalence' canonical structural framing across contract dimensions."
		}, {
			term:   "SemanticIdentity"
			reason: "Identity is binary (identical or not); equivalence permits structural variation while preserving semantic content."
		}]
		examples: [{
			context:   "Semantic equivalence under channel reformulation"
			instance:  "Email HTML body: '<p>Your payment of <b>R\\$ 47,250.00</b> was confirmed.</p>'. SMS reformulation: 'Your payment of R$ 47,250.00 was confirmed.' Representationally different (HTML vs plaintext) but semantically equivalent. Contract with semantic-equivalence=preserved + representational-equivalence=format-translated-admissible accepts this transformation."
			rationale: "Semantic preserved across representational variance."
		}, {
			context:   "Semantic equivalence violation"
			instance:  "Original: 'Your account has been frozen pending investigation.' SMS truncation: 'Your account frozen.' Representationally close but semantically different (loses investigation context + temporal qualifier). Per semantic-equivalence=preserved: refusal canonical (admissibility refused for this channel)."
			rationale: "Truncation crossed semantic boundary; refusal preserves contract."
		}]
		relatedTerms: [
			"term-representational-equivalence",
			"term-canonical-transport-contract",
			"term-fidelity-tripartition",
		]
		layerMapping: {
			codeTerm: "SemanticEquivalence"
			apiTerm:  "semantic-equivalence"
		}
	}, {
		code:   "term-representational-equivalence"
		name:   "Equivalência Representacional"
		termEn: "Representational Equivalence"
		definition: """
			Canonical contract dimension distinguishing byte/structure
			preservation per founder Phase 1.2.B Section A ajuste #1.
			Values: byte-identical (legal/regulatory contracts requiring
			byte preservation) OR structure-preserved (canal pode
			reformatar estrutura mas semantic preserved) OR
			format-translated-admissible (channel-specific reformulation
			allowed within semantic-equivalence preservation). Distinct
			from semantic-equivalence — representation can vary while
			semantic preserved; semantic cannot degrade while
			representation preserved. Issuer-owned.
			"""
		category:  "classification"
		rationale: "Term canoniza byte/structure layer of equivalence. Per founder Phase 1.2.B ajuste #1 + tc-regulatory-evidentiary contract: regulatory/evidentiary requires byte-identical (legal evidence reconstruction); transactional financial accepts structure-preserved; operational updates accept format-translated."
		antiTerms: [{
			term:          "Format Matching"
			clarification: "Format matching is operational concept; representational equivalence is canonical structural commitment per contract dimension."
		}, {
			term:          "Byte Equality"
			clarification: "Byte equality is strictest case (byte-identical); representational equivalence taxonomically includes 3 levels."
		}]
		rejectedAlternatives: [{
			term:   "StructuralEquivalence"
			reason: "Structural ambiguous between data structure and semantic structure. Representational specifically means byte/format/structure preservation."
		}, {
			term:   "FormatEquivalence"
			reason: "Format limits scope to format-level; representation includes byte-level + structure-level + format-level."
		}]
		examples: [{
			context:   "Byte-identical regulatory contract"
			instance:  "tc-regulatory-evidentiary requires byte-identical representational equivalence for legal evidence reconstruction. Payload payload-hash signed and chain-of-custody preserved; receiving system can reconstruct byte-for-byte. Format translation (HTML→PDF, JSON→XML) forbidden — alteration of bytes invalidates evidence."
			rationale: "Legal evidence requires byte preservation; representational dimension enforces."
		}, {
			context:   "Format-translated-admissible operational"
			instance:  "tc-operational-update accepts format-translated representational equivalence. Status update HTML email reformulated as SMS plaintext: representation differs but semantic-equivalence=preserved (status meaning unchanged). Acceptable trade-off for operational class."
			rationale: "Representational flexibility within semantic preservation."
		}]
		relatedTerms: [
			"term-semantic-equivalence",
			"term-canonical-transport-contract",
			"term-evidentiary-audit-trail",
		]
		layerMapping: {
			codeTerm: "RepresentationalEquivalence"
			apiTerm:  "representational-equivalence"
		}
	}, {
		code:   "term-replay-semantics"
		name:   "Semântica de Replay"
		termEn: "Replay Semantics"
		definition: """
			Canonical contract dimension per C9 distinguishing replay
			possibility from retry semantics: replayable (message safe
			to redeliver — downstream consumers idempotent OR semantic
			invariance OR canonical sequence preservation) OR
			replay-forbidden (replay corrupts semantic identity — OTP,
			single-use authentication codes, certain regulatory
			notifications). retry semantics applies to delivery attempts;
			replay semantics applies to message identity. Conflating is
			catastrophic semantic corruption.
			"""
		category:  "classification"
		rationale: "Term canoniza distinction crítica per founder Phase 1.3.B ajuste #5. OTP canonical example: replay-forbidden + retry=none. Webhooks: retry=persistent + replay=replayable. Sem distinção explícita, queue replay flows corrupt OTP semantics silently (catastrophic integrity breach)."
		antiTerms: [{
			term:          "Retry Policy"
			clarification: "Retry policy concerns delivery attempts (how many, with what intervals); replay semantics concerns message identity (is redelivery semantically valid). Different concepts; conflating destroys OTP integrity."
		}, {
			term:          "Idempotency"
			clarification: "Idempotency is downstream consumer property (handler idempotent); replay semantics is message identity property (canonical sequence identity). Idempotency may make replay safe; replay-forbidden means replay is structurally invalid regardless of idempotency."
		}, {
			term:          "Resend Capability"
			clarification: "Resend ambiguous between retry of same message and new issuance. Replay semantics distinguishes: replay-forbidden = same message replayed corrupts; new issuance = different message (e.g., new OTP) is valid."
		}]
		rejectedAlternatives: [{
			term:   "MessageRedeliverySemantics"
			reason: "Verbose; replay specifically captures structural concept of identity preservation under redelivery."
		}, {
			term:   "DuplicationPolicy"
			reason: "Duplication is consumer-side concept; replay semantics is message-identity property. Different layer."
		}]
		examples: [{
			context:   "OTP replay-forbidden canonical"
			instance:  "OTP issued for authentication: code='483921', validity=5min. Replay-forbidden semantics: if dispatch fails, NTF cannot replay via queue/DLQ — that's the same OTP being resent (replay). Required action: issuer re-issues new OTP (different code, new semantic act). Replay-forbidden enforces via C9 lifecycle isolation."
			rationale: "OTP identity tied to issuance event; replay corrupts."
		}, {
			context:   "Webhook replayable canonical"
			instance:  "Webhook to ERP: payment confirmation event. Replayable semantics: failed delivery triggers persistent retry; receiver expects idempotency-key for de-duplication; replay safe because semantic identity preserved (same event, same correlation-id)."
			rationale: "Webhooks replayable when receivers idempotent; canonical pattern."
		}]
		relatedTerms: [
			"term-canonical-transport-contract",
			"term-delivery-attempt-lifecycle",
		]
		layerMapping: {
			codeTerm: "ReplaySemantics"
			apiTerm:  "replay-semantics"
		}
	}, {
		// === CLUSTER D — EVIDENCE & PROVENANCE (4 terms) ===
		code:   "term-verification-evidence"
		name:   "Evidência de Verificação"
		termEn: "Verification Evidence"
		definition: """
			Canonical artifact required for Tier 1 ProviderCapabilityClaim
			entry into substrate — assertion-only claims são structurally
			inadmissible. Carries evidence type (provider-documentation,
			internal-functional-testing, internal-production-observation,
			third-party-audit-validated, cryptographic-protocol-verified)
			+ pointer + date + scope + verification method. Evidence
			degradation: confidence class lowers if evidence ages without
			re-verification (staleness rules per Section B). Negative
			evidence model coexists — failures contradict positive evidence.
			"""
		category:  "value"
		rationale: "Term canoniza evidence substrate underlying registry. Per founder Phase 1.3.C ajuste: capability claims require verification evidence; without evidence model, registry vira wishful abstraction (drift class #6 precursor)."
		antiTerms: [{
			term:          "Provider Marketing"
			clarification: "Marketing material is commercial assertion; verification evidence requires structural validation (testing, audit, observation). Marketing may be source of provider documentation evidence type, but alone insufficient for higher confidence classes."
		}, {
			term:          "Provider SLA"
			clarification: "SLA is contractual commitment; verification evidence is structural validation. SLA documents commitment; evidence validates capability."
		}]
		rejectedAlternatives: [{
			term:   "CapabilityProof"
			reason: "Proof implies mathematical certainty; evidence acknowledges epistemic uncertainty and degrees of confidence (confidence class lattice)."
		}, {
			term:   "ValidationData"
			reason: "Validation data is generic; verification evidence is canonical structural artifact with specific fields (type + pointer + date + scope + method)."
		}]
		examples: [{
			context:   "Third-party audit evidence"
			instance:  "Provider Twilio claims ordered-delivery for SMS. Verification evidence: type='third-party-audit-validated', pointer='audit-report-twilio-ordering-2026-q1', date='2026-01-15', scope='BR/LATAM, < 100/sec, UTF-8 ≤160 chars', method='production-observation-with-cryptographic-validation'. Confidence class assessment: 'strong-evidence' (third-party audit + cryptographic validation)."
			rationale: "Strong-evidence class enables evidentiary contract certification."
		}, {
			context:   "Evidence staleness degradation"
			instance:  "Strong-evidence claim aging past 180-day re-verification threshold. EvidenceStalenessDetected event emitted; confidence class automatically downgrades to moderate-evidence per Section B degradation rules. Re-verification cycle obligatory before claim returns to strong-evidence class."
			rationale: "Evidence requires renewal; staleness triggers degradation mechanically."
		}]
		relatedTerms: [
			"term-provider-capability-claim",
			"term-confidence-class",
			"term-negative-capability-evidence",
			"term-observation-provenance",
		]
		layerMapping: {
			codeTerm: "VerificationEvidence"
			apiTerm:  "verification-evidence"
		}
	}, {
		code:   "term-confidence-class"
		name:   "Classe de Confiança"
		termEn: "Confidence Class"
		definition: """
			Canonical 4-class ordinal evaluation of verification evidence
			supporting claim: strong-evidence (third-party audit OR
			cryptographic verification) > moderate-evidence (internal
			production observation OR functional testing) > provisional
			(provider declaration only OR limited evidence) > inadmissible
			(insufficient OR failed verification). Per Section B
			sensitivity rules: contract classes have admissibility
			thresholds (evidentiary requires strong; transactional
			accepts moderate+; operational accepts provisional+).
			Degradation lifecycle: staleness OR negative evidence
			automatically lowers class.
			"""
		category:  "classification"
		rationale: "Term canoniza ordinal evidence quality assessment. Per founder Phase 1.3.C ajuste #2: per-contract-class admissibility sensitivity allows operational flexibility while preserving evidentiary rigor. Sem this term, evidence treated binary (valid/invalid) — loses degradation nuance."
		antiTerms: [{
			term:          "Trust Level"
			clarification: "Trust is commercial/relational concept; confidence class is structural evidence quality. Trust between operators; confidence class for evidence."
		}, {
			term:          "Reliability Score"
			clarification: "Reliability score is empirical performance metric; confidence class is evidence quality classification. Empirical reliability may inform confidence within scope per C12 but not expand admissibility per C14."
		}]
		rejectedAlternatives: [{
			term:   "EvidenceQuality"
			reason: "Quality is generic; class implies discrete ordinal taxonomy with specific 4-level structure."
		}, {
			term:   "VerificationTier"
			reason: "Tier suggests hierarchy of structural status; class implies categorical quality assessment within evidence."
		}]
		examples: [{
			context:   "Class sensitivity per contract"
			instance:  "tc-regulatory-evidentiary requires confidence-class ≥ strong-evidence. Claim with moderate-evidence class queries this contract: AdmissibilityConservatismTriggered (C11) — claim insufficient for required class threshold. Issuer must use claim only for lower-threshold contracts OR provide additional evidence to reach strong-evidence."
			rationale: "Class sensitivity matches contract criticality."
		}, {
			context:   "Class degradation on negative evidence"
			instance:  "Strong-evidence claim has accumulating negative evidence (3 contradiction events in production). Section C rules: moderate-to-strong negative evidence triggers investigation; meanwhile claim auto-degrades strong → moderate. CertificationDegraded event emitted; downstream certifications with strong-evidence threshold lose admissibility."
			rationale: "Class lattice enables structural defense against capability degradation."
		}]
		relatedTerms: [
			"term-verification-evidence",
			"term-negative-capability-evidence",
			"term-provider-capability-claim",
		]
		layerMapping: {
			codeTerm: "ConfidenceClass"
			apiTerm:  "confidence-class"
		}
	}, {
		code:   "term-negative-capability-evidence"
		name:   "Evidência Negativa de Capability"
		termEn: "Negative Capability Evidence"
		definition: """
			Canonical artifact recording observed failure / contradiction /
			drift in provider capability claim per Phase 1.3.C Section C
			model — failure-evidence (provider claim violated
			observably), contradiction-evidence (production observation
			contradicts claim), drift-evidence (claim baseline shifted —
			provider behavior changed). Triggers either auto-revocation
			(strong negative evidence) OR investigation cycle (moderate)
			OR confidence class degradation (per Section B rules).
			Coexists with positive evidence — admissibility considers
			both.
			"""
		category:  "value"
		rationale: "Term canoniza explicit negative evidence handling. Per founder Phase 1.3.C ajuste #3: positive-only evidence is operational optimism; negative evidence model makes contradiction observable and actionable. Sem this term, drift signals lost or rationalized."
		antiTerms: [{
			term:          "Provider Failure"
			clarification: "Failure is operational event; negative evidence is structural artifact about capability claim. Failures observed; evidence recorded canonically with provenance."
		}, {
			term:          "Service Disruption"
			clarification: "Service disruption is transient operational state; negative evidence is structural commitment recording observed contradiction. Disruptions resolved; evidence persists in substrate."
		}]
		rejectedAlternatives: [{
			term:   "FailureRecord"
			reason: "Record loses 'negative evidence' canonical framing — opposing positive evidence in admissibility consideration."
		}, {
			term:   "CapabilityContradictionLog"
			reason: "Log implies operational logging; negative evidence is canonical substrate artifact."
		}]
		examples: [{
			context:   "Failure-evidence triggers revocation"
			instance:  "Strong-evidence claim: 'byte-identical equivalence for webhook delivery via provider X'. Production observation: webhook payload arrived with extra whitespace (deviation from byte-identical). NegativeCapabilityEvidenceRecorded with type='failure-evidence'; strong negative evidence triggers auto-revocation per Section C model. CertificationRevoked event emitted."
			rationale: "Strong negative evidence = revocation, not investigation."
		}, {
			context:   "Drift-evidence triggers suspension"
			instance:  "Provider Y delivery latency p99 doubled over 30 days; ordering guarantee historically reliable shows drift toward out-of-order patterns. Drift-evidence recorded; moderate severity triggers investigation cycle + CertificationSuspended event (recoverable via re-verification, not permanent revocation)."
			rationale: "Drift evidence = suspension + investigation, not immediate revocation."
		}]
		relatedTerms: [
			"term-verification-evidence",
			"term-confidence-class",
			"term-observation-provenance",
		]
		layerMapping: {
			codeTerm: "NegativeCapabilityEvidence"
			apiTerm:  "negative-capability-evidence"
		}
	}, {
		code:   "term-observation-provenance"
		name:   "Proveniência de Observação"
		termEn: "Observation Provenance"
		definition: """
			Canonical classification of independence + source of
			observation supporting (or contradicting) capability claim
			per Phase 1.3.C Section D + Phase 1.5.B Section D
			asymmetric weighting. Source categories: first-party-
			instrumentation (NTF instrumented) | independent-third-party-
			monitor (distinct from provider) | provider-instrumented
			(NOT independent — collapses back to claim per C10) |
			external-audit-report | regulatory-acknowledgment.
			Independence class: fully-independent | partially-independent
			| non-independent. Provider-instrumented observations são
			canonical NÃO promoted to facts.
			"""
		category:  "classification"
		rationale: "Term canoniza independence verification per founder Phase 1.3.C ajuste #5: 'production-observation' alone doesn't grant independence — must distinguish first-party-instrumentation from provider-instrumented (collapse back to claim per C10)."
		antiTerms: [{
			term:          "Observation Source"
			clarification: "Source is descriptive; provenance includes structural independence classification with implications for confidence weighting + admissibility."
		}, {
			term:          "Data Origin"
			clarification: "Data origin is generic; observation provenance is canonical structural commitment within evidence substrate."
		}]
		rejectedAlternatives: [{
			term:   "ObservationSourceClassification"
			reason: "Verbose; provenance preserves canonical 'where it came from' framing concisely."
		}, {
			term:   "VerificationAuthority"
			reason: "Authority implies decision-making power; provenance describes source independence (mechanical property) NÃO authority (delegation)."
		}]
		examples: [{
			context:   "Fully-independent third-party"
			instance:  "Audit report from independent compliance firm validates Twilio SMS ordering across 30-day production sample. Observation provenance: source='external-audit-report', independence='fully-independent', verification-method='third-party-audit-validated'. Strong-evidence class enabled."
			rationale: "Full independence = strong evidence eligibility."
		}, {
			context:   "Provider-instrumented = non-independent"
			instance:  "Provider X dashboard reports 99.99% delivery rate. Observation provenance: source='provider-instrumented', independence='non-independent', confidence-impact='claim-equivalent'. Per C10 + Section D: claim, NÃO observation — does not auto-promote to evidence. Requires complementary independent verification for evidence promotion."
			rationale: "Provider self-reporting structurally classified as claim, NÃO observation."
		}]
		relatedTerms: [
			"term-verification-evidence",
			"term-negative-capability-evidence",
			"term-delivery-attempt-lifecycle",
		]
		layerMapping: {
			codeTerm: "ObservationProvenance"
			apiTerm:  "observation-provenance"
		}
	}, {
		// === CLUSTER E — LIFECYCLE & ANTI-PATTERNS (4 terms) ===
		code:   "term-delivery-attempt-lifecycle"
		name:   "Ciclo de Vida de Tentativa de Entrega"
		termEn: "Delivery Attempt Lifecycle"
		definition: """
			Canonical mechanical state machine per cap-delivery-attempt-
			lifecycle-tracking + Phase 1.5.B Section D epistemic
			asymmetry hardening: validated → dispatched → {provider-
			confirmed-success | transport-observed-success | provider-
			reported-failure | transport-observed-failure | refused-pre-
			dispatch | refused-post-attempt}. Lifecycle states carry
			epistemic provenance — provider-confirmed states have HIGH
			suspicion weight (false-success dangerous); transport-
			observed states have LOW suspicion. Asymmetry deliberate:
			false-success catastrophic; false-failure recoverable.
			"""
		category:  "process"
		rationale: "Term canoniza factual mechanical lifecycle. Per founder Phase 1.5.B Section D ajuste: epistemic asymmetry preserves distinction between provider claims about success vs independent verification. Sem this term + asymmetry, false-success silently amplifies (catastrophic integrity failure)."
		antiTerms: [{
			term:          "Delivery Status"
			clarification: "Status is observable state; lifecycle is canonical mechanical state machine with epistemic provenance. Status flat; lifecycle structured."
		}, {
			term:          "Message Tracking"
			clarification: "Tracking is observability concept; lifecycle is canonical structural state machine with explicit refusal states + epistemic weighting."
		}]
		rejectedAlternatives: [{
			term:   "DeliveryStateMachine"
			reason: "Generic; delivery-attempt-lifecycle preserves 'attempt' framing (multiple attempts may exist for one message under retry semantics)."
		}, {
			term:   "DispatchFlow"
			reason: "Flow implies linear progression; lifecycle includes refusal branches (refused-pre-dispatch, refused-post-attempt) explicit as terminal states."
		}]
		examples: [{
			context:   "Lifecycle with provider-confirmed (high suspicion)"
			instance:  "Webhook dispatched; provider returns HTTP 200. Lifecycle state: provider-confirmed-success (provider claim). HIGH suspicion weight per epistemic asymmetry — independent verification recommended. If subsequent transport-observed evidence confirms (e.g., receiver-side callback), lifecycle progresses to transport-observed-success (LOW suspicion)."
			rationale: "Asymmetric weighting preserves provider-vs-independent distinction."
		}, {
			context:   "Lifecycle terminates in refusal"
			instance:  "Issuer requests dispatch; admissibility matrix produces Class A verdict. Lifecycle state: refused-pre-dispatch (canonical refusal). Distinct from refused-post-attempt (admissibility passed but transport layer refused execution). State preserved; no transport attempt initiated."
			rationale: "Refusal is canonical lifecycle terminal state — first-class outcome."
		}]
		relatedTerms: [
			"term-observation-provenance",
			"term-admissibility-refusal",
			"term-replay-semantics",
			"term-receiver-confirmation",
		]
		layerMapping: {
			codeTerm: "DeliveryAttemptLifecycle"
			apiTerm:  "delivery-attempt-lifecycle"
		}
	}, {
		code:   "term-receiver-confirmation"
		name:   "Confirmação de Receptor"
		termEn: "Receiver Confirmation"
		definition: """
			Canonical ack semantics value per founder Phase 1.2.B ajuste
			#2 rename (avoiding 'semantic-ack' gravity): receiver-side
			signal indicating message receipt + handling acknowledgment.
			Contract values: fire-and-forget (no ack) | transport-ack
			(NTF property — delivery confirmation transport-layer) |
			receiver-confirmation-required (issuer property — NTF
			transports ack signal upstream para issuer interpretation,
			never interprets within NTF). Receiver-confirmation signal
			routed untouched via ReceiverConfirmationRouted event per
			C10 epistemic limitation.
			"""
		category:  "value"
		rationale: "Term canoniza receiver-side signal handling. Per founder ajuste #2 Phase 1.2.B: 'semantic-ack' rename to 'receiver-confirmation-required' avoids dangerous 'semantic' framing. NTF transports signal; issuer interprets — boundary preserved."
		antiTerms: [{
			term:          "Semantic Acknowledgment"
			clarification: "Semantic ack is forbidden term per founder ajuste — implies NTF interprets receiver intent. Receiver confirmation strictly transports signal; semantic interpretation upstream."
		}, {
			term:          "Read Receipt"
			clarification: "Read receipt is consumer/email-specific concept; receiver confirmation is canonical NTF ack semantics applicable across human-receivable + system-receivable transports."
		}, {
			term:          "Delivery Acknowledgment"
			clarification: "Delivery ack is transport-layer concept (transport-ack value); receiver confirmation is receiver-side signal distinct from transport-side confirmation."
		}]
		rejectedAlternatives: [{
			term:   "SemanticAck"
			reason: "Founder Phase 1.2.B ajuste #2 explicit rename — semantic framing creates gravity errada (NTF interprets vs transports)."
		}, {
			term:   "EndUserAck"
			reason: "End-user implies human-only; receiver confirmation applies to system-receivable (webhook callback) + human-receivable transports."
		}]
		examples: [{
			context:   "Regulatory contract with receiver-confirmation-required"
			instance:  "tc-regulatory-evidentiary requires receiver-confirmation-required. BACEN regulatory body receives transport; signs cryptographic acknowledgment; signal flows back via NTF transport infrastructure to issuer (REW/IDC) as ReceiverConfirmationRouted event. NTF does NOT interpret regulatory implications — transports signal untouched."
			rationale: "Receiver signal routed untouched; semantic interpretation upstream."
		}, {
			context:   "Operational update with fire-and-forget"
			instance:  "tc-operational-update with ack=fire-and-forget. Status notification dispatched; no ack requested; lifecycle terminates at dispatched OR transport-confirmed-success without receiver confirmation. Acceptable for class semantics (operational class accepts loss tolerance)."
			rationale: "Ack semantics align with contract class criticality."
		}]
		relatedTerms: [
			"term-canonical-transport-contract",
			"term-delivery-attempt-lifecycle",
			"term-fidelity-tripartition",
		]
		layerMapping: {
			codeTerm: "ReceiverConfirmation"
			apiTerm:  "receiver-confirmation"
		}
	}, {
		code:   "term-engagement-gravity"
		name:   "Gravidade de Engajamento"
		termEn: "Engagement Gravity"
		definition: """
			Canonical drift class #5 + anti-goal materializado — pressure
			toward NTF acquiring engagement intelligence features: smart
			send windows, fatigue suppression, semantic prioritization,
			user scoring, behavioral optimization, A/B test orchestration.
			This drift attracts NTF toward Braze / Iterable /
			Customer.io / Salesforce Marketing Cloud terminal state.
			NTF rejeita estructuralmente — engagement intelligence é
			explicit anti-goal canonical (per Phase 1.1 NTPs + 12 drift
			classes + 15 constitutional clauses).
			"""
		category:  "rule"
		rationale: "Term canoniza THE attractor gravitational terminal state — without naming canonical anti-goal, BC drifts unconsciously. Per founder Phase 1.1 framing: 'NTF must not evolve toward becoming a communication intelligence engine'. Naming the attractor is structural defense — operational pressure that calls itself something else is detectable when canonical anti-pattern is named explicitly."
		antiTerms: [{
			term:          "Customer Experience Optimization"
			clarification: "CX optimization is product/UX concept; engagement gravity is NTF anti-pattern. Optimization tempts engagement features adoption — refused per construction."
		}, {
			term:          "Communication Effectiveness"
			clarification: "Effectiveness is operational metric; engagement gravity is anti-pattern. Effectiveness pressure may be domain-legitimate but NTF cannot host engagement logic for it."
		}, {
			term:          "Notification Intelligence"
			clarification: "Intelligence is the exact attractor terminal state. Notification intelligence is what NTF must NOT become."
		}]
		rejectedAlternatives: [{
			term:   "MarketingDrift"
			reason: "Marketing too specific; engagement gravity broader, including operational pressure (fatigue suppression, smart timing) that doesn't self-identify as marketing."
		}, {
			term:   "IntelligenceCreep"
			reason: "Generic creep framing; engagement gravity preserves attractor force metaphor — pulls system toward specific terminal state."
		}]
		examples: [{
			context:   "Engagement gravity attempt detected"
			instance:  "Operator proposal: 'Add A/B testing for subject lines — Twilio Sendgrid supports this natively'. Provider semantic intelligence leakage attempt + engagement gravity vector. Per C4 + Phase 1.3.C: provider semantic intelligence leakage forbidden mesmo when provider offers 'for free'. Refusal canonical + escalation criterion 'provider-semantic-intelligence-leakage' triggers."
			rationale: "Drift detected canonically; structural refusal."
		}, {
			context:   "Engagement gravity narrative"
			instance:  "Pressure framing: 'Users complain about notification fatigue — let's implement smart suppression in NTF'. Anti-fatigue canonical clause: 'Escalation frequency must never be interpreted as operational inefficiency without first disproving institutional drift pressure'. Fatigue suppression in NTF = drift class #5 confirmed; semantic suppression é IDC concern (consent semantics), NÃO NTF concern."
			rationale: "Engagement gravity disguised as user experience; structural separation preserves NTF identity."
		}]
		relatedTerms: [
			"term-refusal-reinterpretation-gravity",
			"term-admissibility-refusal",
		]
		layerMapping: {
			codeTerm: "EngagementGravity"
			apiTerm:  "engagement-gravity"
		}
	}, {
		code:   "term-refusal-reinterpretation-gravity"
		name:   "Gravidade de Reinterpretação de Recusa"
		termEn: "Refusal Reinterpretation Gravity"
		definition: """
			Canonical drift class #12 (NEW Phase 1.5.B Section F) —
			cultural/institutional pressure reframing refusal as
			'operational failure' OR 'system unreliability' OR 'reduce
			refusals KPI' OR 'improve success rate target'. Distinct
			from C7/C11 protections (which protect refusal canonical) —
			this protects against META-cultural reinterpretation that
			frames refusal-as-success as failure. Path: refusal-rate
			metric → operational pressure → 'improve UX/throughput'
			framing → admissibility threshold downgrade → silent
			boundary erosion.
			"""
		category:  "rule"
		rationale: "Term canoniza meta-cultural drift vector. Per founder Phase 1.5.B Section F + Phase 1.6 anti-fatigue canonical clause: refusal-rate is integrity preservation metric, NÃO operational failure signal. Without explicit naming, cultural pressure reinterprets refusal mechanically — KPI optimization erodes admissibility silently."
		antiTerms: [{
			term:          "Reliability Issue"
			clarification: "Reliability issue is operational fault framing; refusal-reinterpretation gravity is cultural drift class. Refusal NÃO is reliability problem — it's integrity preservation outcome."
		}, {
			term:          "User Experience Degradation"
			clarification: "UX degradation is operational/product concept; refusal-reinterpretation gravity is structural cultural drift. UX impact may be real but reframing refusal as UX problem is the gravity vector."
		}, {
			term:          "Service Quality Issue"
			clarification: "Service quality conflates operational reliability with admissibility integrity; refusal-reinterpretation gravity specifically names the conflation as drift."
		}]
		rejectedAlternatives: [{
			term:   "CulturalErosion"
			reason: "Generic; refusal-reinterpretation specifically names the mechanism (reframing refusal semantics)."
		}, {
			term:   "MetricDrift"
			reason: "Metric drift loses cultural framing; this drift class is specifically about cultural reinterpretation of canonical outcomes."
		}]
		examples: [{
			context:   "Refusal-reinterpretation in operational review"
			instance:  "Quarterly operational review: 'NTF refusal rate increased from 5% to 8%; we need to reduce this metric'. Anti-fatigue + anti-performative-integrity clauses (governance envelope Phase 5): refusal rate é OBSERVED integrity preservation metric, NÃO operational failure target. Investigation analyzes CAUSE (legitimate refusal patterns vs system over-conservatism vs institutional drift pressure attempts) — NÃO admissibility relaxation."
			rationale: "Cultural pressure detected; canonical response preserves refusal semantics."
		}, {
			context:   "Reinterpretation disguised as customer success"
			instance:  "Customer success team: 'Our biggest customers complain when we refuse their dispatches'. Path canonical: refusal → customer pressure → 'reduce refusal' → admissibility threshold downgrade. C8 admissibility sovereignty: NTF admissibility authority NOT subject to customer authority status. Refusal preserved canonical regardless de customer importance."
			rationale: "Sovereignty protected against status pressure; structural defense."
		}]
		relatedTerms: [
			"term-admissibility-refusal",
			"term-engagement-gravity",
			"term-admissibility-conservatism",
		]
		layerMapping: {
			codeTerm: "RefusalReinterpretationGravity"
			apiTerm:  "refusal-reinterpretation-gravity"
		}
	}]

	rationale: """
		Glossary canoniza Ubiquitous Language do BC NTF como
		boundary-hardening artifact for communication guarantee
		admissibility, NÃO notification terminology dictionary. Cada
		termo materializa decisão de design semantica: o que NTF é
		(constitutional governance layer for communication guarantees),
		o que NTF não é (Braze / Iterable / Customer.io / Salesforce
		Marketing Cloud / engagement intelligence engine), e onde
		boundaries com BCs adjacentes (CMT decide conteúdo; NGR decide
		growth; IDC governs consent semantics; REW governs regulatory
		compliance; provider ecosystem provides transport infrastructure)
		são preservadas.

		22 termos organizados em 5 clusters:
		(A) Substrate & Identity (4): canonical Tier 1/Tier 2
		    substrate + identity nucleus
		(B) Admissibility Framework (5): gravitational core
		    operacional (matrix + refusal + conservatism + scope)
		(C) Transport Contract (5): dimensional structure + fidelity
		    + equivalence + replay semantics
		(D) Evidence & Provenance (4): substrate underlying registry
		    + degradation lifecycle + negative evidence + independence
		    classification
		(E) Lifecycle & Anti-Patterns (4): mechanical state machine +
		    receiver confirmation + canonical anti-goals (engagement
		    gravity + refusal-reinterpretation gravity)

		Cross-canvas alignment: 22 terms materializam 15 constitutional
		clauses (C1-C15) + 12 drift classes + 6 canonical contracts
		(tc-*) + 4 communication canonical clauses (CC1-CC4) declarados
		em canvas Phase 1 (commit 2484b2f). Cada term referencia
		canonical canvas decisions via rationale.

		Family Mesh pattern explicit (paralelo a FCE glossary):
		- FCE glossary: 22 terms preserving conditional economic
		  authority canonical (boundary-hardening artifact)
		- NTF glossary: 22 terms preserving communication guarantee
		  admissibility canonical (boundary-hardening artifact)
		Both são constitutional vocabulary artifacts protecting
		different ontologies sob canonical canonical defensive
		structure.

		Lenses aplicadas (5):
		- lens-mechanism-design (primária): admissibility certification
		  gate + evidence model + transport contract dimensions canonical
		  mechanism
		- lens-trust-and-credibility-design: integrity-over-throughput
		  posture + provider distrust + epistemic asymmetry
		- lens-distributed-systems-design: eventual consistency cross-BC
		  via events + epistemic preservation across heterogeneous
		  transports
		- lens-regulatory-compliance-as-architecture: evidentiary
		  contracts + court-grade audit + regulatory boundary
		  delegation
		- lens-domain-language-and-terminology-design: 22 canonical
		  terms with anti-terms + rejected alternatives + examples
		  preserving Ubiquitous Language structurally

		domainModelRefs deferidos a Phase 3 quando domain-model.cue
		materializar building blocks (per PG gapPolicy: preenchidos
		incrementalmente quando domain-model surgir).

		Materializado em Phase 2 WI-063 NTF bootstrap. Single-shot
		write per founder direction 'Fase 2 de uma vez tb' (post-
		Phase 1 canvas closed at 2484b2f). Cluster organization
		preserved from Phase 1 sub-phase structure.

		Phase 3 (domain-model) próximo — primeira instância onde
		domainModelRefs do glossary podem ser preenchidos incrementalmente
		com agg-* / vo-* / inv-* references.
		"""
}
