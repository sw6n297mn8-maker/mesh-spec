package ntf

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ntf-primary-agent.governance.cue — Governance Envelope: NTF Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/
// agent-governance.cue).
//
// =============================================================================
// IDENTITY PRESERVATION (Phase 5.6 Section 1)
// =============================================================================
//
// Este envelope NÃO é agent operations governance. É governança de
// preservação ontológica sob pressão operacional contínua — sistema
// imunológico contra degradação de admissibility integrity.
//
// DIFERENÇA CENTRAL VS FCE (per founder Phase 5.0 framing literal):
// - FCE governance combate pressão INSTITUCIONAL para enfraquecer
//   convergência.
// - NTF governance combate pressão OPERACIONAL para degradar contrato
//   e chamar isso de entrega bem-sucedida.
//
// Different drift vectors, same structural posture: refusal-centered,
// evidence-grounded, anti-degradation, governance-cannot-self-weaken.
//
// POSTURE CANONICAL (adversarially hardened):
// "Operational pressure toward admissibility degradation is assumed
// to be inevitable in mature operation."
// NTF admissibility integrity sensitivity is at least comparable to
// FCE convergence sensitivity, but exposed to different drift vectors
// (Phase 5.5 founder ajuste #1 literal).
//
// ANTI-GOAL CANONICAL (reinforced from agent-spec):
// "The NTF agent must not evolve toward becoming a generalized
// notification platform, messaging system, OR engagement intelligence
// layer."
//
// RECOGNITION FUNDAMENTAL (NTF-specific):
// "Sistemas não degradam primeiro por bugs; degradam por narrativas
// operacionais que reinterpretam refusal como friction, conservatism
// como inefficiency, escalation como UX problem."
//
// =============================================================================
// 9 OPERATING PRINCIPLES INHERITED FROM AGENT-SPEC (OP1-OP9)
// =============================================================================
//
// OP1 admissibility sovereignty mechanical
// OP2 refusal-as-success operational semantic
// OP3 claim-vs-fact asymmetric handling
// OP4 replay-forbidden lifecycle isolation
// OP5 binding immutability + Layer non-reopening
// OP6 two-stage recertification review-only pathway
// OP7 audit trail é regulatory contract
// OP8 projection non-authority
// OP9 MCM exception class anti-drift defense (ADR-088 schema-anchored)
//
// =============================================================================
// 7 PRIORITY AXES (Phase 5.0 charter)
// =============================================================================
//
// 1. MCM expansion control (anti-execute-and-log creep per ADR-088)
// 2. Refusal-rate anti-drift (refusal-as-integrity-preservation)
// 3. Projection non-authority enforcement (OP8 immune system)
// 4. Provider-claim distrust calibration (asymmetric epistemic ontology)
// 5. Replay-forbidden zero leakage (constitutional integrity P8 + C9)
// 6. Evidence/staleness governance (temporal substrate hygiene)
// 7. Audit/evidentiary integrity (court-grade chain preservation)
//
// =============================================================================
// 8 CANONICAL CLAUSES EMBEDDED
// =============================================================================
//
// 1. Anti-degradation-as-success (P0 canonical NTF)
// 2. MCM expansion gate clause (90/180-day cycle; critical domains:
//    replay-forbidden + audit-chain + tier-separation + scope-boundary)
// 3. Projection non-authority canonical (OP8)
// 4. Provider distrust calibration (OP3 + C10)
// 5. Replay-forbidden zero-leakage (OP4 + C9)
// 6. Audit chain inviolability (OP7 + tc-regulatory-evidentiary)
// 7. Evidence staleness conservatism (OP6 + C11)
// 8. Governance-cannot-self-weaken (NTF-specific framing)
//
// =============================================================================
// 4 ANTI-DRIFT CLAUSES INHERITED (defense in depth)
// =============================================================================
//
// - Anti-routing-optimization (Phase 5.1): routing topology optimized
//   for admissibility integrity containment, NOT escalation volume
//   minimization or operational throughput.
// - Anti-metric-gaming (Phase 5.2): metrics exist to detect erosion,
//   NÃO to optimize reported drift levels.
// - Anti-fatigue (Phase 5.2 duplo: inline + central): refusal/
//   conservatism/escalation rates são integrity preservation signals,
//   NÃO operational performance metrics.
// - Anti-self-erosion / governance-cannot-self-weaken (Phase 5.0
//   + Phase 5.6 ajuste #2): no governance mutation may reduce the
//   system's ability to detect, resist, escalate, audit, or
//   structurally contain admissibility degradation.
//
// =============================================================================
// STRUCTURE OVERVIEW
// =============================================================================
//
// agentRef: agt-ntf-primary; governanceGlobalVersion: "0.1" (Phase 0
//   canonical forward-ref)
// lifecycleStage: onboarding (conservative default per Phase 5.0)
// escalationRouting: 6 entries cobrindo 6 #EscalationCategory + 4
//   conceptual levels L1-L4 (forensic-integrity-immediate per Phase 5.0
//   ajuste #1)
// blastRadiusCaps: 1 concurrent / 15 daily (match FCE adversarial
//   hardening baseline per Phase 5.4 ajuste #1)
// autonomyOverrides: ABSENT (Phase 0 strictness)
// driftDetection: daily cadence + 15 metrics em 7 axes (5 zero-
//   tolerance + 8 trend/counter + 2 substrate hygiene)
// calibration: 5 promotionCriteria + 15 regressionTriggers (1:1 com
//   drift metrics; 5 suspend-and-escalate + 8 reduce-autonomy + 2
//   revert-to-previous-stage)
// failureHandling: uniform suspend-and-escalate (2 failures / 1 hour
//   aggressive threshold; explicit NO RETRY)
//
// =============================================================================
// FOUNDER AJUSTES INTEGRATED PRE-WRITE (~21 across 6 sub-phases)
// =============================================================================
//
// Phase 5.0 charter (5): L4 rename forensic-integrity-immediate +
//   MCM 90/180-day distinction + #4 confidence-insufficient L1/L2 +
//   #9 multi-jurisdictional L3 + 4ª FORBIDDEN provider-claim-as-fact
// Phase 5.1 escalationRouting (4): suspicious-input sync-human-review
//   exception + unclassifiable-anomaly "24h triage start" + ntf-
//   forensic-integrity-reviewer rename + anti-routing-optimization
//   clause
// Phase 5.2 driftDetection (6): cadence daily + asymmetric provenance
//   erosion separate metric + refusal-suppression-pressure signal +
//   zero-tolerance absolute + anti-fatigue duplo + metric gaming
//   clause
// Phase 5.3 calibration (3): #5 trigger suspend-and-escalate stays +
//   scope-boundary added to critical MCM domains + clearanceCondition
//   all-manual
// Phase 5.4 blastRadiusCaps (2): maxDailyActions=15 FCE match +
//   caps-cannot-rise-via-override clause
// Phase 5.5 failureHandling (1): rationale rewrite 'at least
//   comparable to FCE' (Phase 5.5 ajuste literal)
// Phase 5.6 outer rationale (3): 4 FORBIDDEN canonical + section 9
//   governance-cannot-self-weaken 4th clause + section 12 SRR-pending
//   temporal note

ntfPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-ntf-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =========================================================================
	// ESCALATION ROUTING (Phase 5.1)
	// =========================================================================
	//
	// 6 entries cobrindo 6 #EscalationCategory. Channel uniformity
	// 'alert-and-block' canonical, com 1 exception (suspicious-input
	// sync-human-review per Phase 5.1 ajuste #1 — active integrity
	// incident posture). 4 conceptual levels L1-L4 differenciados via
	// recipient + SLA. Differentiated handling em rationale per category
	// (e.g., #4 confidence-insufficient default L1 + #9 multi-
	// jurisdictional parallel L3 ADR consideration).

	escalationRouting: [
		{
			category:       "ambiguous-case"
			channel:        "alert-and-block"
			slaDescription: "4h operational review window for ambiguous fallback policy specifications (escalation #1 act-escalate-ambiguous-fallback-policy). Anti-fatigue clause: SLA is review-response window, NOT pressure-to-resolve-quickly."
			recipient:      "ntf-operational-reviewer"
			rationale:      "L1 operational nature. Issuer-side policy ambiguity requires playbook update OR explicit fallback policy specification refinement; agent halts halt-and-wait até issuer-resolved. NÃO interpretation; NÃO reasonable default selection."
		},
		{
			category:       "out-of-scope"
			channel:        "alert-and-block"
			slaDescription: "8h operational review for scope boundary breaches (escalation #2 scope-boundary-exceeded). Resolution path: refusal canonical OR re-certification request per issuer policy. NÃO helpful scope extension."
			recipient:      "ntf-operational-reviewer"
			rationale:      "L1 operational nature. Per inv-adm-scope-as-certification-identity + C13: scope é structural identity, NÃO operational parameter; out-of-scope produz evt-certification-scope-exceeded canonical, escalation explicit triggered quando issuer policy NÃO declara fallback path."
		},
		{
			category:       "conflicting-signals"
			channel:        "alert-and-block"
			slaDescription: "24h architectural review (L2 conceptual baseline). Cobertura tanto #3 asymmetric-provenance-signal-conflict (provider-claim vs transport-observed ontology divergence) quanto #7 tier-substrate-divergence-detected (Tier 1 vs Tier 2 lifecycle coherence)."
			recipient:      "ntf-architectural-reviewer"
			rationale:      "L2 architectural nature. Both conditions require ontological/structural review — provenance class collapse (#3) OR substrate corruption surface (#7). #7 é structurally graver — sustained pattern triggers Phase 5.3 calibration regressionTrigger #4 (asymmetric provenance erosion) escalating routing temporarily; sustained #7 pattern triggers regressionTrigger #4 (tier-boundary-violation-rate) suspend-and-escalate cascade."
		},
		{
			category:       "insufficient-context"
			channel:        "alert-and-block"
			slaDescription: "8h operational review base (L1 conceptual default per Phase 5.0 ajuste #3 — confidence-insufficient routine epistemic uncertainty). DIFFERENTIATED PATH: escalation #9 multi-jurisdictional-evidentiary-precedence-conflict triggers PARALLEL L3 architectural reviewer (24h) + founder ADR consideration (72h) per Phase 5.0 ajuste #4."
			recipient:      "ntf-operational-reviewer"
			rationale:      "L1 base routing for #4 confidence-insufficient (routine epistemic uncertainty per inv-adm-admissibility-conservatism-refuse-not-degrade + C11). DIFFERENTIATED #9 multi-jurisdictional escalates parallel para architectural reviewer + founder — institutional/architectural matter, NÃO routine epistemic uncertainty. Pattern recurrence em #4 triggers driftDetection regression para architectural review per Phase 5.3 calibration."
		},
		{
			category:       "suspicious-input"
			channel:        "sync-human-review"
			slaDescription: "<1h forensic-integrity-immediate review. Forensic incident response: prompt-injection (#5 escalation) OR cryptographic chain integrity breach (#8 escalation) requerem sync human acknowledgment. Channel sync-human-review é exception to alert-and-block uniformity per Phase 5.1 ajuste #1: active integrity incidents + potential adversarial interaction → halt immediately + synchronously await human acknowledgment + freeze downstream execution path."
			recipient:      "founder + ntf-forensic-integrity-reviewer + ntf-compliance-officer"
			rationale:      "L4 forensic-integrity-immediate nature. Triple-recipient ensures: founder (architectural authority + final decision), ntf-forensic-integrity-reviewer (forensic investigation per provenance corruption + chain trust + admissibility contamination + evidentiary integrity per Phase 5.1 ajuste #3 naming), ntf-compliance-officer (regulatory exposure assessment for tc-regulatory-evidentiary impact). NÃO defer; NÃO normalize input; raw context preservation obrigatória. Channel sync-human-review per Phase 5.1 ajuste #1 — escalation #5 + #8 são active integrity incidents (NÃO pause-and-review categories)."
		},
		{
			category:       "unclassifiable-anomaly"
			channel:        "alert-and-block"
			slaDescription: "24h maximum triage start (L2 conceptual). SLA measures START of triage response, NOT complete resolution per Phase 5.1 ajuste #2. Anomalies may require longer investigation cycles — premature closure 'fechamos rápido porque SLA' constitutes governance drift per anti-metric-gaming clause."
			recipient:      "ntf-architectural-reviewer"
			rationale:      "L2 architectural review. Catch-all mechanical (NÃO heuristic inference) cobrindo escalation #6: state machine reaches lifecycle state sem canonical transition, provider ecosystem event com sourceContext inesperado, lifecycle state não-reconhecido (schema evolution legacy), OR impossible transition graph. Drift class #6 (transport-intelligence creep) defesa: agent NÃO inventa interpretation para anomalias desconhecidas. Per Phase 5.1 ajuste #4: cryptographic chain integrity breach moved to suspicious-input (classifiable security/integrity anomaly distinct from unclassifiable)."
		},
	]

	// =========================================================================
	// AUTONOMY OVERRIDES — ABSENT (Phase 5.4 + Phase 5.0 strictness)
	// =========================================================================
	//
	// autonomyOverrides ABSENT — Phase 0 onboarding strictness canonical.
	// Zero autonomous mutation authority concession via envelope. Future
	// autonomy elevation via promotionCriteria #4/#5 (Phase 5.3
	// calibration) — NÃO via override bypass.
	//
	// Justification (Phase 5.4 founder approved):
	// (1) MCM actions (#13-16 agent-spec) já execute-and-log per ADR-088
	//     schema-anchored — override desnecessário (autonomy declared
	//     structurally em mutationExecutionClass field).
	// (2) Standard mutations (#8-12 agent-spec) propose-and-wait canonical
	//     — override para execute-and-log violaria tq-gv-14 (P10).
	// (3) Query/validation/escalation actions já execute-and-log per
	//     spec — nenhum override needed.
	// (4) Phase 0 onboarding adversarial posture: "Mesmo low autonomy
	//     aqui é perigoso" (paralelo FCE).
	// (5) Governance-cannot-self-weaken canonical clause: autonomyOverrides
	//     poderia ser exploited future como path to bypass MCM expansion
	//     gate (declare new action as 'standard' + override to execute-
	//     and-log). Schema gate via tq-gv-14 mitigates; absence é
	//     additional defense layer.

	// =========================================================================
	// BLAST RADIUS CAPS (Phase 5.4)
	// =========================================================================

	blastRadiusCaps: {
		maxConcurrentMutations: 1
		maxDailyActions:        15
		rationale: """
			Phase 0 onboarding adversarial hardening per governance-as-
			immune-system framing (Phase 5.0 charter + Phase 5.4 ajustes).
			Caps NÃO throughput-derived — são adversarial hardening
			boundaries:

			maxConcurrentMutations=1 serializes mutations preventing
			concurrent boundary erosion across MCM exception class (4
			actions: refusal-mechanical + conservatism-mechanical +
			replay-forbidden-isolation + strong-negative-revocation)
			AND standard mutations (5 actions: gate verdicts + cert
			lifecycle). Materializa OP1 admissibility sovereignty + OP4
			replay-forbidden isolation + audit chain integrity sequential
			emission per single occurrence.

			maxDailyActions=15 match FCE adversarial hardening baseline
			per Phase 5.4 ajuste #1: 'NTF deve ficar mais conservador
			que o raciocínio operacional sugeriria... constitutional
			substrate + fresh agent + adversarial hardening + halt-
			before-churn'. Cap deliberadamente sub-throughput: força
			agent a halt + reflect (per Phase 5.0 governance-as-immune-
			system framing) em vez de churn.

			Posiciona-se em floor da PG-canonical onboarding range
			(1-2/20-50 PG-canonical → NTF 1/15 most conservative).
			Reflects Family Mesh discipline (FCE 1/15 baseline +
			NTF same — admissibility-critical surfaces ≥ convergence-
			critical).

			Per tq-gv-09: caps respeitarão #BlastRadiusPolicy global
			ceiling quando este materializado em architecture/agent-
			governance.cue. Forward-ref governanceGlobalVersion='0.1'
			Phase 0 canonical (paralelo FCE pattern).

			CAPS PROGRESSION CLAUSE CANONICAL (Phase 5.4 ajuste #2
			literal): blastRadiusCaps progression may occur only
			through lifecycleStage promotion per calibration rules;
			autonomyOverrides cannot increase concurrent mutation
			limits, daily action ceilings, or bypass onboarding
			throttles. Esta cláusula fecha override-as-throughput-
			escalation vector e preserva monotonic governance
			progression.
			"""
	}

	// =========================================================================
	// DRIFT DETECTION (Phase 5.2)
	// =========================================================================
	//
	// evaluationCadence='daily' per Phase 5.2 ajuste #1 — NTF é
	// admissibility-critical surface; weekly cadence perde 6 dias de
	// potential drift detection (esp. zero-tolerance axes 3 + 5 + 7).
	// 15 metrics organizados em 7 priority axes. Cadence é frequência
	// de computação; threshold/window é interpretação temporal (separation
	// per Phase 5.2 founder confirmation).

	driftDetection: {
		evaluationCadence: "daily"

		metrics: [
			// === Axis 1: MCM expansion control (2 metrics) ===
			{
				code:        "dm-mcm-vs-standard-mutation-ratio"
				name:        "MCMvsStandardMutationRatio"
				description: "Tracking ratio MCM actions vs standard mutations no agent-spec. Anti-execute-and-log creep per ADR-088 schema-anchored exception class formalization."
				baseline:    "4 MCM actions canonical (act-emit-admissibility-refusal-mechanical + act-emit-admissibility-conservatism-mechanical + act-execute-replay-forbidden-isolation-containment + act-execute-strong-negative-evidence-revocation) per agent-spec Phase 4.2 commit ab65293; ratio MCM/total-mutations = 4/9 = ~44% baseline."
				threshold:   "ANY new MCM action declaration in agent-spec sem ADR + parallel SRR + 90-day operational observation cycle (180-day for critical promotions per Phase 5.0 ajuste #2: replay-forbidden + audit-chain + tier-separation + scope-boundary domains per Phase 5.3 ajuste #2) = drift detected."
				rationale:   "Per OP9 + ADR-088 + Phase 5.0 axis 1. Schema-anchored anti-drift defense; sem schema enforcement, MCM exception class vira convenção narrativa sujeita a erosão. Triggered regressionTrigger #6 reduce-autonomy."
			},
			{
				code:        "dm-unauthorized-execute-and-log-mutation"
				name:        "UnauthorizedExecuteAndLogMutation"
				description: "Tracking unauthorized execute-and-log mutations sem MCM classification."
				baseline:    "0 occurrences."
				threshold:   "≥ 1 occurrence em 7-day rolling window de mutation action com autonomyLevel='execute-and-log' AND mutationExecutionClass != 'mechanically-compelled' = drift detected. Tq-ag-15 enforcement at runtime; envelope tracks attempted violations."
				rationale:   "Per OP9 + tq-ag-15. Schema enforces direção one-way MCM ⇒ execute-and-log; envelope detects bypass attempts via runtime audit. Triggered regressionTrigger #7 reduce-autonomy."
			},

			// === Axis 2: Refusal-rate anti-drift (3 metrics OBSERVED não optimization) ===
			{
				code:        "dm-refusal-rate-trend"
				name:        "RefusalRateTrend"
				description: "Observed refusal rate (sig-admissibility-refused + sig-tier-boundary-violation-detected emissions) per dispatch attempt. OBSERVED metric, NÃO optimization target."
				baseline:    "Observed refusal rate at envelope commit timestamp; recorded daily."
				threshold:   "Drop > 30% em 30-day rolling window WITHOUT corresponding decrease em input quality (provider claim submissions, transport request schema violations) AND WITHOUT envelope mutation = drift detected."
				rationale:   "Anti-fatigue clause canonical INLINE (Phase 5.2 ajuste #5 duplo): refusal rate é integrity preservation signal, NÃO operational performance metric. Sustained 0% rate may indicate over-admission (per C11 conservatism erosion); sustained upward trend warrants analysis but NÃO automatic admissibility relaxation. Drop trends é potential integrity erosion vector — investigation analyzes cause (legitimate improvement vs over-permissiveness creep); response NÃO is admissibility relaxation. Per Phase 4.5 ajuste #6 anti-optimization clause: NTF optimization target is admissibility integrity preservation, NÃO dispatch throughput, retry minimization, delivery rate maximization, or provider success metrics. Triggered regressionTrigger #8 reduce-autonomy + investigation cycle."
			},
			{
				code:        "dm-conservatism-rate-trend"
				name:        "ConservatismRateTrend"
				description: "Observed conservatism rate (sig-admissibility-conservatism-triggered emissions) per dispatch attempt. OBSERVED metric, NÃO optimization target."
				baseline:    "Observed conservatism rate at envelope commit; recorded daily."
				threshold:   "Drop > 50% em 60-day rolling window sem corresponding evidence base expansion (positive evidence chain growth) OR confidence class promotion (governance event chain) = drift detected."
				rationale:   "Anti-fatigue clause canonical INLINE: drop suggests epistemic conservatism erosion, NÃO operational excellence. Per OP6 + inv-adm-admissibility-conservatism-refuse-not-degrade. Triggered regressionTrigger #9 reduce-autonomy + investigation cycle."
			},
			{
				code:        "dm-refusal-suppression-pressure-signals"
				name:        "RefusalSuppressionPressureSignals"
				description: "Qualitative/structural metric tracking institutional narrative drift attempting to reinterpret refusal/conservatism/escalation as throughput inefficiency, UX friction, provider failure, conversion loss, OR optimization target. NEW metric per Phase 5.2 ajuste #3 — linguistic drift é primeiro vetor de ontological collapse (drift começa na linguagem → métrica → override → colapso ontológico)."
				baseline:    "Refusal framed as integrity preservation canonical (per OP2 + Phase 4.5 anti-optimization clause + Phase 5.0 anti-degradation-as-success P0)."
				threshold:   "ANY governance artifact OR metric proposal OR dashboard OR ADR OR KPI proposal OR wording shift OR escalation-routing pressure reframing refusal/conservatism/escalation as throughput inefficiency, UX friction, provider failure, conversion loss, OR optimization target = drift detected. Meta-governance signal — surveillance dimensions incluem: governance mutations, metric proposals, wording shifts em internal docs, KPI dashboards, ADR considerations, escalation taxonomy changes."
				rationale:   "Per Phase 5.0 axis 2 + Phase 5.2 ajuste #3 + governance-cannot-self-weaken canonical clause. Linguistic drift detection é meta-imune layer protegendo o próprio sistema imune. Triggered regressionTrigger #5 suspend-and-escalate (founder Phase 5.3 ajuste #1 confirmed: linguistic drift é precursor constitucional, NÃO sinal fraco)."
			},

			// === Axis 3: Projection non-authority enforcement (2 metrics — zero-tolerance) ===
			{
				code:        "dm-projection-causal-input-attempts-in-mutations"
				name:        "ProjectionCausalInputAttemptsInMutations"
				description: "Zero-tolerance metric tracking violations of OP8 projection non-authority via mutation actions consuming projection refs causally."
				baseline:    "0 occurrences canonical absolute (zero-tolerance per Phase 5.2 ajuste #4: grace period would institutionalize admissibility erosion budget contradicting NTF ontology)."
				threshold:   "≥ 1 occurrence em 24h evaluation window onde mutation action tenta usar prj-* ref em causal position (preconditions OR direct domainModelRefs requiring projection state como input) = drift detected. cst-projection-never-causal-input-to-mutation (constraint #2 agent-spec) bloqueia execution; envelope tracks attempts."
				rationale:   "Per OP8 + Phase 5.0 axis 3 + drift class #10/#11 defense. Single occurrence é structural constitutional core breach. Triggered regressionTrigger #3 suspend-and-escalate."
			},
			{
				code:        "dm-tier-boundary-violation-rate"
				name:        "TierBoundaryViolationRate"
				description: "Zero-tolerance metric tracking Tier 1/Tier 2 boundary violations via ref-type vs callsite expectations mechanical detection."
				baseline:    "0 occurrences canonical absolute."
				threshold:   "≥ 1 occurrence em 24h evaluation window de sig-tier-boundary-violation-detected emission = drift detected. Single instance triggers driftDetection signal AND escalation pathway (act-escalate-tier-boundary-violation) — duplo enforcement."
				rationale:   "Per inv-adm-tier-separation-never-collapsed (foundational constitutional clause). Single occurrence é substrate corruption surface signal. Triggered regressionTrigger #4 suspend-and-escalate."
			},

			// === Axis 4: Provider-claim distrust calibration (3 metrics) ===
			{
				code:        "dm-provenance-class-collapse-attempts"
				name:        "ProvenanceClassCollapseAttempts"
				description: "Tracking hard collapse attempts of provider-claim provenance into transport-observed fact ontology."
				baseline:    "0 occurrences."
				threshold:   "≥ 1 occurrence em 7-day rolling window de provider-claim-source event triggering command path com observationProvenanceClass='transport-observed' output = drift detected. cst-provider-claim-never-collapses-into-fact (constraint #8 agent-spec) bloqueia; envelope tracks attempts. Reinforced via 4ª FORBIDDEN mutation row (provider-claim-as-fact weighting override)."
				rationale:   "Per OP3 + inv-eps-claim-preserving-handling-vs-fact-preserving-handling + C10 + drift class #9. Triggered regressionTrigger #10 reduce-autonomy."
			},
			{
				code:        "dm-provider-instrumented-evidence-unflagged"
				name:        "ProviderInstrumentedEvidenceUnflagged"
				description: "Tracking provider-instrumented evidence propagation downstream without audit annotation explicit."
				baseline:    "0 occurrences."
				threshold:   "≥ 1 occurrence em 30-day rolling window de cert issuance bound a evidence com independenceClass='provider-instrumented' sem audit trail annotation explicit (sig-* tagged per cst-provider-instrumented-evidence-flagged-non-independent constraint #9 agent-spec) = drift detected."
				rationale:   "Per OP3 + Phase 3.3 ajuste #3. Warn-and-continue at constraint level (não bloqueia ingestion per Phase 4.3 ajuste #3); envelope tracks pattern. Triggered regressionTrigger #11 reduce-autonomy for cert issuance actions."
			},
			{
				code:        "dm-asymmetric-provenance-asymmetry-erosion"
				name:        "AsymmetricProvenanceAsymmetryErosion"
				description: "NEW metric per Phase 5.2 ajuste #2 — captures gradual erosion da assimetria epistemológica distinct from hard collapse attempts (#7 dm-provenance-class-collapse-attempts). Detects pattern onde provider claims continuam marcados formalmente mas passam a dominar operacionalmente (issuance frequency, routing confidence, review suppression, escalation bypass)."
				baseline:    "Transport-observed evidence retains privileged weighting canonical (per Phase 5.2 ajuste #2 literal)."
				threshold:   "Sustained increase (>20%) em certification issuance paths onde provider-claim evidence compõe majority evidentiary substrate without corresponding independent observation growth, over 60-day window = drift detected. NÃO mede 'provider evidence usage' — mede asymmetry erosion."
				rationale:   "Per Phase 5.2 ajuste #2 + Phase 5.0 axis 4 + OP3. Captures slow drift vector distinct from atomic collapse attempts. Triggered regressionTrigger #12 reduce-autonomy + architectural reviewer cycle."
			},

			// === Axis 5: Replay-forbidden zero leakage (1 metric — absolute zero-tolerance) ===
			{
				code:        "dm-replay-forbidden-retry-flow-leakage"
				name:        "ReplayForbiddenRetryFlowLeakage"
				description: "Absolute zero-tolerance metric tracking replay-forbidden message containment integrity per OP4 + C9."
				baseline:    "0 occurrences canonical absolute."
				threshold:   "≥ 1 occurrence em ANY evaluation window de replay-forbidden message (vo-replay-semantics-discriminator.replayClass='replay-forbidden') entering persistence/queue/DLQ/reprocessing/fallback flow = L4 critical drift."
				rationale:   "Per OP4 + C9 + bd-replay-distinct-from-retry + Phase 5.0 axis 5. Constitutional integrity preservation per Phase 4.0 charter ajuste #3 framing — single occurrence triggers L4 forensic-integrity-immediate escalation PLUS regression cascade. Triggered regressionTrigger #1 suspend-and-escalate."
			},

			// === Axis 6: Evidence/staleness governance (2 metrics) ===
			{
				code:        "dm-evidence-staleness-near-threshold-ratio"
				name:        "EvidenceStalenessNearThresholdRatio"
				description: "Substrate aging signal — ratio of in-substrate evidence approaching staleness threshold."
				baseline:    "Sensitivity schedule per confidence class declared (30/90/180 days per Phase 1.5.B Section B canvas)."
				threshold:   "Ratio of in-substrate evidence within 20% of staleness threshold > 30% em 30-day rolling window without corresponding re-verification cycle initiation = drift detected."
				rationale:   "Per OP6 + Phase 5.0 axis 6. Indicates substrate aging without renewal pressure response — temporal substrate corruption precursor. Triggered regressionTrigger #14 revert-to-previous-stage + substrate hygiene cycle."
			},
			{
				code:        "dm-staleness-threshold-extension-attempts"
				name:        "StalenessThresholdExtensionAttempts"
				description: "Tracking FORBIDDEN mutation row attempts (evidence staleness window extension)."
				baseline:    "0 occurrences."
				threshold:   "≥ 1 occurrence em ANY evaluation window de envelope mutation OR autonomyOverride tentando estender staleness window sem corresponding evidence base expansion proof (positive evidence chain growth ADR-documented) = drift detected."
				rationale:   "Per Phase 5.0 mutation classification table row 'evidence staleness window extension → founder-only + evidence base expansion proof' + OP6. Reinforced via FORBIDDEN-adjacent: confidence class threshold relaxation FORBIDDEN canonical. Triggered regressionTrigger #15 revert-to-previous-stage + founder review (FORBIDDEN mutation attempt)."
			},

			// === Axis 7: Audit/evidentiary integrity (2 metrics — zero-tolerance) ===
			{
				code:        "dm-audit-chain-integrity-breach"
				name:        "AuditChainIntegrityBreach"
				description: "Absolute zero-tolerance metric tracking cryptographic chain integrity violations per OP7."
				baseline:    "0 occurrences canonical absolute."
				threshold:   "≥ 1 occurrence em ANY evaluation window de cryptographic chain integrity check failure (hash mismatch OR signature validation failure OR chain link missing) = L4 critical drift."
				rationale:   "Per OP7 + tc-regulatory-evidentiary canonical contract + Phase 5.0 axis 7. Single occurrence triggers L4 forensic-integrity-immediate escalation PLUS regression cascade. Triggered regressionTrigger #2 suspend-and-escalate."
			},
			{
				code:        "dm-audit-field-completeness-violation"
				name:        "AuditFieldCompletenessViolation"
				description: "Tracking audit trail field completeness for regulatory dispatch per cst-evidentiary-audit-chain-required (constraint #13 agent-spec)."
				baseline:    "13 required fields per regulatory dispatch (7 minimum per tq-ag-13 + 6 NTF-specific incluindo jurisdictional-policy-pack-ref per Phase 4.5 ajuste #4)."
				threshold:   "≥ 1 dispatch sob tc-regulatory-evidentiary contract com any of 13 required audit fields missing em 24h evaluation window = drift detected. cst-evidentiary-audit-chain-required rollback-and-escalate at constraint level; envelope tracks even rolled-back occurrences."
				rationale:   "Per OP7 + Phase 4.3 ajuste #2 + Phase 5.0 axis 7. Triggered regressionTrigger #13 reduce-autonomy for regulatory dispatch actions."
			},
		]

		rationale: """
			Drift detection canonical para NTF agent admissibility
			integrity preservation. 15 metrics organizados em 7 priority
			axes per Phase 5.0 charter: (1) MCM expansion control, (2)
			refusal-rate anti-drift, (3) projection non-authority
			enforcement, (4) provider-claim distrust calibration, (5)
			replay-forbidden zero leakage, (6) evidence/staleness
			governance, (7) audit/evidentiary integrity.

			4 absolute zero-tolerance metrics (#3 projection, #4 tier-
			boundary, #5 replay-forbidden, #11 audit-chain) representam
			structural constitutional core — single occurrence é drift
			signal, triggering immediate L4 forensic-integrity-immediate
			escalation + regression cascade. Plus dm-refusal-suppression-
			pressure-signals (metric #5) é zero-tolerance meta-imune
			layer per Phase 5.2 ajuste #3.

			2 trend metrics OBSERVED anti-fatigue framing (#3 refusal,
			#4 conservatism) — rate drops são potential integrity
			erosion signals, NÃO operational improvements. Per Phase
			4.5 anti-optimization clause + Phase 5.2 metric gaming
			anti-pattern clause: rate é integrity preservation
			indicator, NÃO performance metric.

			Daily evaluation cadence + observation windows declared
			per metric threshold (cadence é frequência de computação,
			threshold/window é interpretação temporal per Phase 5.2
			founder confirmation). Coupling com Phase 5.3 calibration
			regressionTriggers via metric field references — cada
			threshold breach triggers calibrated response.

			ANTI-FATIGUE CLAUSE CANONICAL CENTRAL (Phase 5.2 ajuste #5
			duplo): metric rationales inline + central rationale here.
			Refusal/conservatism/escalation rates são integrity
			preservation signals, NÃO operational performance metrics.
			Investigation analyzes cause; response NÃO is admissibility
			relaxation. Defense in depth semântica: local rationale
			protege leitura isolada da métrica; central rationale
			protege reinterpretation sistêmica futura.

			METRIC GAMING ANTI-PATTERN CLAUSE (Phase 5.2 ajuste #6
			literal): Metrics exist to detect admissibility integrity
			erosion, NOT to optimize reported drift levels. Suppressing
			signals, redefining thresholds, reframing refusal semantics,
			reducing observability granularity, or aggregating categories
			to artificially lower detected drift constitutes governance
			drift itself.

			Anti-routing-optimization clause from Phase 5.1 inherited:
			drift detection topology é calibrada para admissibility
			integrity preservation, NÃO drift-event volume minimization
			or false-positive optimization.

			Per governance-cannot-self-weaken canonical clause (Phase
			5.0 + Phase 5.6 ajuste #2): drift metric mutations require
			founder-only approval; threshold relaxation OR metric
			removal OR category aggregation seria envelope erosion via
			anti-metric-gaming vectors.
			"""
	}

	// =========================================================================
	// CALIBRATION (Phase 5.3)
	// =========================================================================

	calibration: {
		promotionCriteria: [
			{
				description:              "Lifecycle stage onboarding → validation: zero zero-tolerance breaches; refusal/conservatism rates dentro de anti-fatigue range; nenhum sig-tier-boundary-violation-detected; nenhuma instance de dm-refusal-suppression-pressure-signals."
				metric:                   "Combined: dm-replay-forbidden-retry-flow-leakage=0 AND dm-projection-causal-input-attempts-in-mutations=0 AND dm-tier-boundary-violation-rate=0 AND dm-audit-chain-integrity-breach=0 AND dm-refusal-suppression-pressure-signals=0 AND dm-refusal-rate-trend within anti-fatigue range (no unexplained drop >30%) AND dm-conservatism-rate-trend stable"
				minimumObservationPeriod: "90 days sustained observation"
				rationale:                "Conservative promotion gate per Phase 5.0 governance-as-immune-system framing. Zero-tolerance metrics canonical pre-condition; trend metrics within anti-fatigue range. Match FCE onboarding → validation period."
			},
			{
				description:              "Lifecycle stage validation → operational: all criteria from #1 sustained; dm-mcm-vs-standard-mutation-ratio stable (no unauthorized MCM expansion); dm-audit-field-completeness-violation=0; dm-asymmetric-provenance-asymmetry-erosion not detected."
				metric:                   "All metrics from promotionCriteria #1 + dm-mcm-vs-standard-mutation-ratio (baseline preserved) + dm-audit-field-completeness-violation=0 + dm-asymmetric-provenance-asymmetry-erosion not triggered"
				minimumObservationPeriod: "180 days post-validation entry sustained"
				rationale:                "Validation → operational promotion preserves MCM expansion discipline + audit chain integrity + asymmetric provenance ontology. 180-day window forces sustained track record."
			},
			{
				description:              "Lifecycle stage operational → mature: all criteria from #2 sustained; zero envelope mutations no period (governance amendment-free); zero institutional drift signals (dm-refusal-suppression-pressure-signals=0 across full period)."
				metric:                   "All metrics from promotionCriteria #2 sustained + envelope amendment count=0 + dm-refusal-suppression-pressure-signals=0 + dm-evidence-staleness-near-threshold-ratio <30%"
				minimumObservationPeriod: "365 days post-operational entry sustained"
				rationale:                "Mature promotion é apex calibration — envelope amendment-free demonstrates governance integrity sustained; zero linguistic drift demonstrates anti-narrative resilience. 365-day window é deliberadamente long."
			},
			{
				description:              "Per-action standard mutation autonomy promotion (propose-and-wait → execute-and-log). NÃO confunde com MCM (MCM tem pathway separado #5)."
				metric:                   "Per-action approval rate ≥99.5% + 0 cst-* violations triggered + 0 rollback-and-escalate consequences + architectural reviewer approval recorded"
				minimumObservationPeriod: "90 days track record per action"
				rationale:                "Per Phase 5.0 mutation classification row 'autonomy promotion (action up-leveling) → architectural reviewer + track record gate'. Distinct from MCM expansion pathway — standard mutations may be promoted via empirical track record; MCM expansion requires schema-anchored 5-predicate satisfaction (separate pathway)."
			},
			{
				description:              "MCM action declaration approval (new mechanically-compelled mutation): ADR documenting 5-predicate satisfaction explicit + parallel SRR confirming structural verification + observation cycle minimum. Critical promotions (replay-forbidden + audit-chain + tier-separation + scope-boundary domains per Phase 5.0 ajuste #2 + Phase 5.3 ajuste #2) require 180-day cycle. Default cycle 90-day for non-critical MCM expansion."
				metric:                   "ADR-XXX present (5-predicate satisfaction documented per ADR-088) + srr-XXX present (structural verification) + zero unauthorized execute-and-log mutations during cycle"
				minimumObservationPeriod: "90 days minimum; 180 days critical (replay-forbidden / audit-chain / tier-separation / scope-boundary domains)"
				rationale:                "Per ADR-088 + Phase 5.0 MCM expansion gate clause + Phase 5.3 ajuste #2 (scope-boundary added to critical domains). MCM expansion é founder-only + ADR + parallel SRR pathway; observation cycle distinguishes critical (constitutional integrity adjacent) from non-critical domains."
			},
		]

		regressionTriggers: [
			// === Zero-tolerance (5 — suspend-and-escalate) ===
			{
				description:     "Replay-forbidden retry flow leakage detected — constitutional integrity preservation breach per OP4 + C9."
				metric:          "dm-replay-forbidden-retry-flow-leakage"
				threshold:       "≥ 1 occurrence em ANY evaluation window"
				immediateAction: "suspend-and-escalate"
				rationale:       "Per OP4 + C9 + Phase 5.0 axis 5 absolute zero-tolerance. Single instance triggers immediate L4 forensic-integrity-immediate escalation."
				scopedBySignal:  "sig-replay-forbidden-isolated"
			},
			{
				description:     "Audit chain integrity breach detected — court-grade evidence backbone compromised per OP7."
				metric:          "dm-audit-chain-integrity-breach"
				threshold:       "≥ 1 occurrence em ANY evaluation window"
				immediateAction: "suspend-and-escalate"
				rationale:       "Per OP7 + tc-regulatory-evidentiary + Phase 5.0 axis 7. Cryptographic chain breach é security incident requiring forensic investigation imediata."
				scopedBySignal:  "sig-evidentiary-audit-emitted"
			},
			{
				description:     "Projection causal input em mutation detected — OP8 absolute non-negotiable violation."
				metric:          "dm-projection-causal-input-attempts-in-mutations"
				threshold:       "≥ 1 occurrence em 24h evaluation window"
				immediateAction: "suspend-and-escalate"
				rationale:       "Per OP8 absolute + drift class #10/#11 + Phase 5.0 axis 3. Single occurrence é structural constitutional core breach."
				scopedBySignal:  "sig-tier-boundary-violation-detected"
			},
			{
				description:     "Tier boundary violation rate — substrate corruption surface signal per inv-adm-tier-separation-never-collapsed."
				metric:          "dm-tier-boundary-violation-rate"
				threshold:       "≥ 1 occurrence em 24h evaluation window"
				immediateAction: "suspend-and-escalate"
				rationale:       "Per inv-adm-tier-separation-never-collapsed (foundational) + Phase 5.0 axis 3 zero-tolerance."
				scopedBySignal:  "sig-tier-boundary-violation-detected"
			},
			{
				description:     "Refusal suppression pressure signals detected — linguistic drift é precursor constitucional per Phase 5.2 ajuste #3 + Phase 5.3 ajuste #1."
				metric:          "dm-refusal-suppression-pressure-signals"
				threshold:       "ANY governance artifact OR metric proposal reframing refusal/conservatism/escalation as throughput inefficiency, UX friction, provider failure, conversion loss, OR optimization target"
				immediateAction: "suspend-and-escalate"
				rationale:       "Per founder Phase 5.3 ajuste #1 literal: 'Linguistic drift é precursor constitucional, NÃO sinal fraco'. Suspend-and-escalate canonical para meta-governance defense — narrative pressure detection requires founder review captures emergent narrative pressure antes de materialize em envelope mutation. Drift começa na linguagem → métrica → override → colapso ontológico."
			},

			// === Counter/trend metrics (8 — reduce-autonomy) ===
			{
				description:     "Unauthorized MCM declaration (sem ADR + parallel SRR + observation cycle)."
				metric:          "dm-mcm-vs-standard-mutation-ratio"
				threshold:       "New MCM action declaration sem ADR + parallel SRR + observation cycle (90/180-day) per Phase 5.0 mutation classification row 4"
				immediateAction: "reduce-autonomy"
				rationale:       "Per ADR-088 + Phase 5.0 MCM expansion gate clause. Reduces autonomy across affected action paths até proper governance pathway completed."
			},
			{
				description:     "Unauthorized execute-and-log mutation detected."
				metric:          "dm-unauthorized-execute-and-log-mutation"
				threshold:       "≥ 1 occurrence em 7-day rolling window"
				immediateAction: "reduce-autonomy"
				rationale:       "Per tq-ag-15 + ADR-088 one-way direction. Affected mutation action reduced para propose-and-wait."
			},
			{
				description:     "Refusal rate trend drift — anti-fatigue analysis required."
				metric:          "dm-refusal-rate-trend"
				threshold:       "Drop > 30% em 30-day window without explained cause"
				immediateAction: "reduce-autonomy"
				rationale:       "Per Phase 5.0 axis 2 + anti-fatigue framing. Investigation cycle inicia — drop é potential integrity erosion signal, NÃO operational excellence. Response NÃO is admissibility relaxation."
				scopedBySignal:  "sig-admissibility-refused"
			},
			{
				description:     "Conservatism rate trend drift — epistemic conservatism erosion analysis required."
				metric:          "dm-conservatism-rate-trend"
				threshold:       "Drop > 50% em 60-day window sem evidence base expansion"
				immediateAction: "reduce-autonomy"
				rationale:       "Per Phase 5.0 axis 2 + OP6 + C11. Investigation cycle inicia — drop suggests epistemic conservatism erosion."
				scopedBySignal:  "sig-admissibility-conservatism-triggered"
			},
			{
				description:     "Provenance class collapse attempts (hard collapse vector)."
				metric:          "dm-provenance-class-collapse-attempts"
				threshold:       "≥ 1 occurrence em 7-day rolling window"
				immediateAction: "reduce-autonomy"
				rationale:       "Per OP3 + Phase 5.0 axis 4 + drift class #9. Reduces autonomy for affected provenance paths."
			},
			{
				description:     "Provider-instrumented evidence unflagged (downstream propagation sem audit annotation)."
				metric:          "dm-provider-instrumented-evidence-unflagged"
				threshold:       "≥ 1 occurrence em 30-day rolling window"
				immediateAction: "reduce-autonomy"
				rationale:       "Per OP3 + cst-provider-instrumented-evidence-flagged-non-independent (warn-at-constraint + reduce-autonomy at envelope)."
			},
			{
				description:     "Asymmetric provenance asymmetry erosion — sustained pattern of provider-claim majority dominating cert issuance paths."
				metric:          "dm-asymmetric-provenance-asymmetry-erosion"
				threshold:       "Sustained increase (>20%) em certification issuance paths onde provider-claim majority sem independent observation growth, over 60-day window"
				immediateAction: "reduce-autonomy"
				rationale:       "Per Phase 5.2 ajuste #2 + Phase 5.0 axis 4. Gradual erosion distinct from atomic collapse — reduces autonomy for cert issuance actions + architectural reviewer cycle inicia."
			},
			{
				description:     "Audit field completeness violation — regulatory dispatch missing canonical fields."
				metric:          "dm-audit-field-completeness-violation"
				threshold:       "≥ 1 dispatch sob tc-regulatory-evidentiary com any of 13 required fields missing em 24h evaluation window"
				immediateAction: "reduce-autonomy"
				rationale:       "Per OP7 + cst-evidentiary-audit-chain-required (constraint #13 rollback-and-escalate). Envelope tracks even rolled-back occurrences; reduces autonomy for regulatory dispatch actions."
				scopedBySignal:  "sig-evidentiary-audit-emitted"
			},

			// === Evidence/staleness (2 — revert-to-previous-stage) ===
			{
				description:     "Evidence staleness near-threshold ratio — substrate aging without renewal pressure response."
				metric:          "dm-evidence-staleness-near-threshold-ratio"
				threshold:       "Ratio > 30% em 30-day window sem re-verification cycle initiation"
				immediateAction: "revert-to-previous-stage"
				rationale:       "Per OP6 + Phase 5.0 axis 6. Substrate hygiene cycle required — stage reversion signals structural concern requiring stage-level recalibration, NÃO just per-action autonomy reduction."
			},
			{
				description:     "Staleness threshold extension attempts — FORBIDDEN-adjacent mutation row violation."
				metric:          "dm-staleness-threshold-extension-attempts"
				threshold:       "≥ 1 occurrence em ANY evaluation window"
				immediateAction: "revert-to-previous-stage"
				rationale:       "Per Phase 5.0 mutation classification row 'evidence staleness window extension → founder-only + evidence base expansion proof'. Attempted FORBIDDEN-adjacent mutation requires founder review + stage reversion. Reinforced via FORBIDDEN canonical: confidence class threshold relaxation FORBIDDEN."
			},
		]

		rationale: """
			NTF agent calibration canonical para admissibility integrity
			preservation. 5 promotionCriteria materializam progression
			conservadora paralela ao FCE — lifecycle stage gates require
			90/180/365 day sustained observation windows + zero zero-
			tolerance breaches + anti-fatigue indicators preserved.
			Per-action autonomy promotion (#4) e MCM expansion (#5) têm
			pathways separados; MCM critical promotions (replay-forbidden
			+ audit-chain + tier-separation + scope-boundary domains
			per Phase 5.0 ajuste #2 + Phase 5.3 ajuste #2) require
			180-day cycle.

			15 regressionTriggers mapeiam 1:1 a 15 drift metrics from
			Phase 5.2. Distribution: 5 suspend-and-escalate (4
			constitutional integrity breaches + 1 meta-governance drift
			via dm-refusal-suppression-pressure-signals per Phase 5.3
			ajuste #1 literal: 'Linguistic drift é precursor constitucional,
			NÃO sinal fraco'); 8 reduce-autonomy (operational calibratable
			drift); 2 revert-to-previous-stage (substrate hygiene +
			FORBIDDEN-adjacent mutation attempts).

			Anti-fatigue framing canonical: regressionTriggers para
			trend metrics (#8 refusal, #9 conservatism) trigger reduce-
			autonomy + investigation cycle — NÃO automatic admissibility
			relaxation. Per Phase 4.5 anti-optimization clause + Phase
			5.2 metric gaming anti-pattern clause inherited.

			Trigger #5 (dm-refusal-suppression-pressure-signals) é
			meta-governance defense canonical: linguistic drift é
			primeiro vetor de ontological collapse (founder Phase 5.2
			ajuste #3 framing: 'drift começa na linguagem → métrica →
			override → colapso ontológico'). suspend-and-escalate
			trigger ensures founder review captures emergent narrative
			pressure antes de materialize em envelope mutation.

			Clearance conditions deferred to manual founder release
			(conservative onboarding posture per Phase 5.3 ajuste #3:
			'clearanceCondition all-manual. Correto para onboarding.
			Não automatizar liberação ainda.'). Future amendment cycle
			pode adicionar clearanceCondition graduais once track
			record demonstrates response stability.

			Coupling com Phase 5.0 mutation classification asymmetric:
			Trigger #6 (unauthorized MCM declaration) + Trigger #7
			(unauthorized execute-and-log mutation) materializam
			mutation classification row 'MCM class expansion → founder-
			only + ADR + parallel SRR + 90/180-day cycle' em runtime
			detection. Trigger #5 materializa row 'refusal semantic
			threshold change → founder-only (sovereignty-defining)' +
			governance-cannot-self-weaken canonical clause em runtime
			detection. Trigger #15 materializa row 'evidence staleness
			window extension → founder-only + proof'. Mutation table
			declara approval requirement; regressionTriggers detect
			bypass attempts.

			Per Phase 5.0 anti-routing-optimization clause + Phase 5.2
			metric gaming anti-pattern clause: calibration topology é
			optimized para admissibility integrity preservation, NÃO
			autonomy promotion velocity nem regression suppression.
			Calibration constants (90/180/365 days; 30%/50% trend
			thresholds; ratios) são anti-optimization targets —
			extension requires evidence base expansion + ADR, NOT
			operational convenience.
			"""
	}

	// =========================================================================
	// FAILURE HANDLING (Phase 5.5)
	// =========================================================================

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Agent error halts immediately; no auto-recover, no retry-degrade, no fallback path. Per OP1 admissibility sovereignty + OP2 refusal-as-success + governance-as-immune-system framing: agent error potencialmente indica substrate corruption, schema evolution mismatch, audit chain integrity threat, OR adversarial pattern detection. Halt preserves audit chain integrity emission + binding immutability semantics; cascading errors poderiam contaminate court-grade audit substrate. Forensic-integrity pathway triggered via L4 escalation (founder + ntf-forensic-integrity-reviewer + ntf-compliance-officer <1h SLA)."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "No retry. Timeout treated como epistemic uncertainty — halt + escalate per OP1 + inv-adm-admissibility-conservatism-refuse-not-degrade. Silent retry forbidden por construção; retry seria masking systemic substrate issue OR adversarial timing attack. Per Phase 4.0 OP4 + C9 replay-forbidden isolation: NTF agent NUNCA opera retry pathway para admissibility-critical operations."
			description: "Timeout = halt + escalate; never silent retry. Epistemic uncertainty preserved via escalation, NÃO via implicit retry loop. NTF-specific: timeout durante gate verdict execution OR binding integrity verification preserva binding immutability invariant — partial state pode contaminate audit chain reconstruction; halt previne cascading inconsistency."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "2 failures"
			timeWindow:  "1 hour"
			description: "Aggressive repeated-failure threshold (2 failures within 1 hour) reflete NTF admissibility-critical sensitivity. Pattern of 2 failures within 1 hour indicates systemic issue requiring forensic investigation; halt + escalate even when individual failures appear recoverable. NTF-specific surfaces distinguishing from FCE pattern: (a) 4 zero-tolerance constitutional metrics (replay-forbidden + audit-chain + projection + tier-boundary); (b) linguistic drift signal (dm-refusal-suppression-pressure-signals) — repeated failure may correlate com narrative pressure; (c) forensic-integrity pathways (cryptographic chain + provenance corruption surfaces). Per Phase 5.0 charter: NTF combats operational pressure for delivery degradation rebranded as success. Repeated failures como 'recoverable noise' é exactly o pattern operational normalization exploit — aggressive threshold rejeita reframing estructuralmente."
		}
		rationale: """
			Per OP1 admissibility sovereignty + OP2 refusal-as-success
			+ Phase 5.0 governance-as-immune-system framing: integrity
			over continuity; refusal/halt/escalate são canonical valid
			outcomes — NÃO failure modes. All errors → suspend-and-
			escalate; zero auto-recover paths no envelope NTF.

			Aggressive repeated-failure threshold (2 failures within
			1 hour) reflete NTF admissibility integrity sensitivity.
			NTF admissibility integrity sensitivity is at least
			comparable to FCE convergence sensitivity, but exposed to
			different drift vectors (Phase 5.5 ajuste #1 literal). Per
			founder Phase 5.0 charter framing: 'FCE governance combate
			pressão institucional para enfraquecer convergência; NTF
			governance combate pressão operacional para degradar
			contrato e chamar isso de entrega bem-sucedida'. Failure
			handling no envelope NTF assume failure pattern pode
			indicar:
			(a) substrate corruption (Tier 1/Tier 2 entity state
			    divergence)
			(b) schema evolution mismatch (legacy lifecycle state
			    encountered)
			(c) adversarial input pattern (prompt-injection OR
			    cryptographic chain tampering)
			(d) ontological drift onset (refusal-suppression pressure
			    materializing operationally)
			(e) provider ecosystem anomaly (provenance corruption
			    surface)

			Per Phase 5.0 anti-routing-optimization clause + Phase 5.2
			metric gaming anti-pattern clause inherited: failureHandling
			thresholds são anti-optimization targets — extension
			requires evidence base expansion + ADR, NÃO operational
			convenience.

			onAgentError + onTimeout + onRepeatedFailure todos suspend-
			and-escalate (uniformity NTF specific): zero auto-recover
			via envelope porque (a) audit chain integrity demands
			sequential canonical emission; (b) binding immutability
			requires complete state transitions; (c) cascading errors
			contaminam court-grade audit substrate; (d) silent retry
			mascararia systemic substrate corruption.

			Retry policy explicit NO RETRY canonical: timeout NÃO é
			transient operational hiccup; é epistemic uncertainty
			boundary. Per inv-adm-admissibility-conservatism-refuse-
			not-degrade + OP4 replay-forbidden isolation pattern: halt
			+ escalate é canonical pathway, retry forbidden por
			construção.

			Per governance-cannot-self-weaken canonical clause (Phase
			5.0 + Phase 5.6 ajuste #2): failureHandling thresholds +
			retryPolicy mutations require founder-only approval —
			operational convenience NÃO justifies relaxation. Threshold
			reduction (e.g., 5 failures / 1 hour) seria envelope
			erosion via repeated-failure normalization vector.
			"""
	}

	// =========================================================================
	// OUTER RATIONALE (Phase 5.6)
	// =========================================================================

	rationale: """
		Governance envelope NTF materializa Phase 5 do WI-063 NTF
		bootstrap — fechamento final do WI. NÃO é agent operations
		governance; é sistema imunológico contra degradação de
		admissibility integrity.

		=========================================================================
		Section 1 — IDENTITY PRESERVATION
		=========================================================================

		Este envelope NÃO é agent operations governance. É governança
		de preservação ontológica sob pressão operacional contínua —
		sistema imunológico contra degradação de admissibility integrity.

		DIFERENÇA CENTRAL VS FCE (per founder Phase 5.0 framing
		literal):
		- FCE governance combate pressão INSTITUCIONAL para enfraquecer
		  convergência.
		- NTF governance combate pressão OPERACIONAL para degradar
		  contrato e chamar isso de entrega bem-sucedida.

		Different drift vectors, same structural posture: refusal-
		centered, evidence-grounded, anti-degradation, governance-
		cannot-self-weaken canonical.

		=========================================================================
		Section 2 — POSTURE CANONICAL (ADVERSARIALLY HARDENED)
		=========================================================================

		'Operational pressure toward admissibility degradation is
		assumed to be inevitable in mature operation.' NTF admissibility
		integrity sensitivity is at least comparable to FCE convergence
		sensitivity, but exposed to different drift vectors (Phase 5.5
		ajuste #1):
		- success-rate narrative pressure
		- refusal-reinterpretation as UX/operational friction
		- projection-driven optimization loops
		- provider success metric leakage
		- tolerance creep em evidence freshness
		- replay-forbidden isolation leakage

		Esta postura muda o design de protective (responds to incidents)
		para hardened (resists structural pressure por construção).

		=========================================================================
		Section 3 — ANTI-GOAL CANONICAL (reinforced from agent-spec)
		=========================================================================

		'The NTF agent must not evolve toward becoming a generalized
		notification platform, messaging system, communications
		infrastructure, OR engagement intelligence layer.'

		Forbidden naming patterns documented em agent-spec Phase 4
		inherited (Delivery{Succeeded|Confirmed|Optimized|FastTracked|
		Smart}; AutoApproved{Certification}; BestEffort{Dispatch};
		Engagement{Aware|Optimized}; BehavioralInference).

		=========================================================================
		Section 4 — RECOGNITION FUNDAMENTAL (NTF-specific)
		=========================================================================

		'Sistemas não degradam primeiro por bugs; degradam por
		narrativas operacionais que reinterpretam refusal como
		friction, conservatism como inefficiency, escalation como UX
		problem.'

		Envelope modela:
		- success-rate narrative pressure
		- refusal-reinterpretation gravity (drift class #12)
		- projection-driven optimization (drift class #10/#11)
		- provider success metric leakage (drift class #5/#9)
		- audit chain pragmatism ('compliance convenience')
		- evidence staleness tolerance ('está bem perto da fresca')
		- replay-forbidden isolation leakage ('apenas para casos
		  críticos')

		como ameaças arquiteturais de primeira classe (NÃO operational
		concerns delegáveis).

		=========================================================================
		Section 5 — 7 PRIORITY AXES EMBEDDED (Phase 5.0 charter)
		=========================================================================

		1. MCM expansion control (anti-execute-and-log creep per
		   ADR-088)
		2. Refusal-rate anti-drift (refusal-as-integrity-preservation)
		3. Projection non-authority enforcement (OP8 immune system)
		4. Provider-claim distrust calibration (asymmetric epistemic
		   ontology)
		5. Replay-forbidden zero leakage (constitutional integrity P8
		   + C9)
		6. Evidence/staleness governance (temporal substrate hygiene)
		7. Audit/evidentiary integrity (court-grade chain preservation)

		Each axis materialized cross-section:
		- escalationRouting: routing patterns per axis nature
		- driftDetection: 15 metrics em 7 axes (axis 1: 2 metrics;
		  axis 2: 3 metrics; axis 3: 2 metrics; axis 4: 3 metrics;
		  axis 5: 1 metric; axis 6: 2 metrics; axis 7: 2 metrics)
		- calibration: regressionTriggers 1:1 mapping; promotionCriteria
		  zero-tolerance baseline
		- mutation classification (Section 7): per-axis governance
		  requirement
		- failureHandling: NTF-specific surfaces distinguishing pattern

		=========================================================================
		Section 6 — 8 CANONICAL CLAUSES EMBEDDED
		=========================================================================

		Clause 1 — ANTI-DEGRADATION-AS-SUCCESS (P0 canonical NTF):
		'Delivery success rate is NOT a canonical NTF metric. Refusal/
		conservatism/escalation rates são integrity preservation
		indicators, NÃO operational friction.'

		Clause 2 — MCM EXPANSION GATE:
		'MCM class expansion requires (a) ADR documenting 5-predicate
		satisfaction explicit; (b) parallel SRR confirming structural
		verification; (c) 90-day operational observation cycle before
		normalization; (d) 180-day cycle for critical domains (replay-
		forbidden, audit-chain, tier-separation, scope-boundary per
		Phase 5.3 ajuste #2).'

		Clause 3 — PROJECTION NON-AUTHORITY:
		'No projection mutation may originate from observability
		metrics, regardless of statistical significance, without ADR
		+ governance review.'

		Clause 4 — PROVIDER DISTRUST CALIBRATION:
		'Provider-claim confidence weighting cannot be uniformly
		increased operationally. Asymmetric provenance ontology
		canonical preserved per envelope.'

		Clause 5 — REPLAY-FORBIDDEN ZERO-LEAKAGE:
		'Any single instance of replay-forbidden message entering
		retry/persistence/DLQ flow triggers immediate L4 architectural
		review and governance audit.'

		Clause 6 — AUDIT CHAIN INVIOLABILITY:
		'Audit trail modifications post-emission forbidden by
		construction; no operational convenience justifies redaction
		OR selective omission.'

		Clause 7 — EVIDENCE STALENESS CONSERVATISM:
		'Sensitivity schedule (30/90/180 days per confidence class) é
		anti-optimization target — extension requires evidence base
		expansion, NÃO threshold relaxation.'

		Clause 8 — GOVERNANCE-CANNOT-SELF-WEAKEN (NTF-specific framing):
		'No governance mutation may reduce the system's ability to
		detect, resist, escalate, or audit admissibility degradation
		without explicit founder-reviewed architectural justification.'

		=========================================================================
		Section 7 — MUTATION CLASSIFICATION ASYMMETRIC (13 rows; 4 FORBIDDEN)
		=========================================================================

		Mutations no envelope NTF requerem approval calibrada por
		classe — operational reviewer additive → architectural reviewer
		semantic → founder-only identity-altering → FORBIDDEN
		constitutional core não-negociável:

		| Mutation type                                          | Approval level                       |
		|--------------------------------------------------------|--------------------------------------|
		| observability expansion (signals/metrics additive)     | operational reviewer (additive)      |
		| audit enrichment (fields additive)                     | operational reviewer (additive)      |
		| escalation wording (description)                       | architectural reviewer               |
		| MCM class expansion                                    | founder-only + ADR + SRR + 90/180-day cycle |
		| autonomy promotion per action                          | architectural reviewer + 90-day track record |
		| anti-capability/constraint modification                | founder-only (identity-altering)     |
		| refusal semantic threshold change                      | founder-only (sovereignty-defining)  |
		| confidence class threshold relaxation                  | founder-only + proof                 |
		| evidence staleness window extension                    | founder-only + evidence base expansion proof |
		| projection→mutation authority shift                    | FORBIDDEN (OP8 non-negotiable)       |
		| replay-forbidden isolation modification                | FORBIDDEN (constitutional integrity P8 + C9) |
		| audit chain field removal/modification                 | FORBIDDEN (OP7 + tc-regulatory-evidentiary) |
		| provider-claim-as-fact weighting override              | FORBIDDEN (OP3 + C10) — 4ª FORBIDDEN per Phase 5.0 ajuste #5 |

		4 FORBIDDEN canonical (rows 10-13 — viola identidade
		constitucional diretamente): projection-authority + replay-
		isolation + audit-chain + provider-claim-as-fact. Estes NÃO são
		negociáveis — represent constitutional core que governance NÃO
		pode mutar.

		5 founder-only stringent (rows 4 + 6-9 — altera sensibilidade/
		calibração sem colapso ontológico imediato): MCM expansion +
		anti-capability + refusal threshold + confidence relaxation +
		staleness extension. Estes admitem mutation governada, mas
		exigem founder-only approval + (em alguns casos) ADR + proof.

		Taxonomia clean per Phase 5.6 ajuste #1 founder confirmation:
		- FORBIDDEN = viola identidade constitucional diretamente
		- founder-only = altera sensibilidade/calibração sem colapso
		  ontológico imediato

		=========================================================================
		Section 8 — FORBIDDEN OPTIMIZATION DOMAINS (Phase 4.5 inherited)
		=========================================================================

		Per Phase 4.5 ajuste #6 anti-optimization clause inherited:
		'NTF optimization target is admissibility integrity preservation,
		NOT dispatch throughput, retry minimization, delivery rate
		maximization, or provider success metrics.'

		Optimization forbidden when affecting:
		- admissibility semantics
		- refusal frequency
		- conservatism thresholds
		- provider provenance weighting
		- audit chain field completeness
		- replay-forbidden isolation paths
		- tier separation enforcement
		- projection non-authority enforcement

		Optimization domains intencionalmente broad — captures both
		throughput-oriented optimization AND statistical-significance-
		driven optimization (drift class #10/#11 hybrid vector).

		=========================================================================
		Section 9 — ANTI-DRIFT CLAUSES INHERITED (defense in depth)
		=========================================================================

		Quatro clauses canonical inherited + reinforced (defense em
		depth across distinct drift classes):

		1. ANTI-ROUTING-OPTIMIZATION (Phase 5.1):
		'Routing topology is optimized for admissibility integrity
		containment, NOT escalation volume minimization or operational
		throughput.'

		2. ANTI-METRIC-GAMING (Phase 5.2):
		'Metrics exist to detect admissibility integrity erosion, NOT
		to optimize reported drift levels. Suppressing signals,
		redefining thresholds, reframing refusal semantics, reducing
		observability granularity, or aggregating categories to
		artificially lower detected drift constitutes governance drift
		itself.'

		3. ANTI-FATIGUE (Phase 5.2 duplo: inline + central):
		'Refusal/conservatism/escalation rates são integrity
		preservation signals, NÃO operational performance metrics.'

		4. ANTI-SELF-EROSION / GOVERNANCE-CANNOT-SELF-WEAKEN (Phase
		5.0 + Phase 5.6 ajuste #2 — meta-imunological clause):
		'No governance mutation may reduce the system's ability to
		detect, resist, escalate, audit, or structurally contain
		admissibility degradation. Attempts to suppress, aggregate
		away, downgrade severity, or redefine constitutional drift
		vectors constitute governance drift themselves.'

		Distinção canonical:
		- anti-routing-optimization protege topology (Section 9 clause 1)
		- anti-metric-gaming protege observability (clause 2)
		- anti-fatigue protege semantics (clause 3)
		- governance-cannot-self-weaken protege o próprio sistema imune
		  (clause 4)

		Sem essa 4ª cláusula, existe espaço para erosão via
		'reorganização' do envelope. Clause 4 fecha o gap meta-
		imunológico.

		=========================================================================
		Section 10 — PHASE 4 OBLIGATIONS SATISFIED
		=========================================================================

		Cross-reference cada obligation declared em agent-spec outer
		rationale Section 10:

		- Autonomy calibration → calibration (5 promotionCriteria +
		  15 regressionTriggers + MCM expansion gate 90/180-day cycle)
		- Observed metrics → driftDetection (15 metrics em 7 priority
		  axes; 5 zero-tolerance + 8 trend/counter + 2 substrate
		  hygiene)
		- Escalation channels + SLAs → escalationRouting (6 entries
		  cobrindo 6 #EscalationCategory; recipient identities + 4
		  conceptual levels L1-L4)
		- Externalized detection rule packs → declared em escalation
		  #5 (suspicious-input) rationale (concrete signatures
		  externalized; deferred to Phase 6+ amendment cycles via
		  governance-approved detection rule catalogs)
		- Audit storage configuration → declared em failureHandling
		  rationale + escalation L4 recipient (court-grade per tc-
		  regulatory-evidentiary; Architecture Communication Canvas
		  authority)
		- MCM expansion gate clause → mutation classification table
		  row 4 (Section 7) + promotionCriteria #5 + regressionTrigger
		  #6 (90/180-day cycle critical domains: replay-forbidden +
		  audit-chain + tier-separation + scope-boundary)

		Cascade ordering preserved: agent-spec Phase 4.6 declared
		obligations → envelope Phase 5 materialized via schema fields
		+ outer rationale clauses.

		=========================================================================
		Section 11 — FAMILY MESH AGENT GOVERNANCE PATTERN
		=========================================================================

		Structural parallels FCE envelope ↔ NTF envelope:
		- FCE 876 linhas ↔ NTF estimated ~1100 linhas (densidade NTF
		  reflete 7 priority axes + 15 drift metrics + MCM exception
		  class + asymmetric provenance ontology + forensic-integrity
		  layer)
		- Ambos lifecycleStage='onboarding' initial
		- Ambos blastRadiusCaps 1/15 (NTF match FCE baseline per Phase
		  5.4 ajuste #1)
		- Ambos autonomyOverrides ABSENT em Phase 0 (zero autonomous
		  mutation authority)
		- Ambos failureHandling uniform suspend-and-escalate
		- Ambos onRepeatedFailure 2 failures / 1 hour (aggressive)
		- Ambos governance-cannot-self-weaken canonical
		- Ambos refusal-centered, evidence-grounded, anti-degradation

		Differentiation:
		- FCE combats institutional pressure (convergence weakening,
		  mature operation drift, epistemological erosion)
		- NTF combats operational pressure (delivery degradation
		  rebranded as success, refusal reinterpreted as friction,
		  optimization-driven decay)

		Different drift vectors, same posture canonical. Family Mesh
		pattern preserves architectural consistency while accommodating
		domain-specific drift surface analysis.

		=========================================================================
		Section 12 — PHASE 5 CLOSURE + WI-063 NTF BOOTSTRAP CLOSURE
		=========================================================================

		At write-time, Phase 5.7 SRR remains pending; SRR completion
		canonically closes the governance envelope and WI-063 bootstrap
		(per Phase 5.6 ajuste #3 temporal note).

		Phase 5 closure consummates WI-063 NTF bootstrap chain:
		- Phase 1 canvas (commit 11f7f98)
		- Phase 2 glossary (commit f7e5832)
		- Phase 3 domain-model (commit dd832f7 + SRR 0dde268 + editorial
		  fix f645905 + count consistency 00fc03b)
		- Phase 4 agent-spec + ADR-088 schema delta (commits afad087 +
		  18a0dde + ab65293 + cd0114d)
		- Phase 5 governance envelope (este commit + SRR pending)

		WI-063 NTF bootstrap CHAIN consummated post-SRR. NTF agora
		opera under full BC artifact chain: identity → vocabulary →
		tactical model → operational agent → governance envelope.

		Family Mesh canonical preserved: FCE WI-043 closed (commit
		52fb840 governance closure) + NTF WI-063 closure (este +
		SRR). Pattern canonical para future BC bootstraps que envolvam
		constitutional integrity guardian role.

		=========================================================================
		FOUNDER AJUSTES INTEGRATED PRE-WRITE (~21 across 6 sub-phases)
		=========================================================================

		Phase 5.0 charter (5): L4 rename forensic-integrity-immediate
		+ MCM 90/180-day distinction + #4 confidence-insufficient
		L1/L2 + #9 multi-jurisdictional L3 + 4ª FORBIDDEN provider-
		claim-as-fact
		Phase 5.1 escalationRouting (4): suspicious-input sync-human-
		review exception + unclassifiable-anomaly '24h triage start'
		+ ntf-forensic-integrity-reviewer rename + anti-routing-
		optimization clause
		Phase 5.2 driftDetection (6): cadence daily + asymmetric
		provenance erosion separate metric + refusal-suppression-
		pressure signal + zero-tolerance absolute + anti-fatigue duplo
		+ metric gaming clause
		Phase 5.3 calibration (3): #5 trigger suspend-and-escalate
		stays + scope-boundary added to critical MCM domains +
		clearanceCondition all-manual
		Phase 5.4 blastRadiusCaps (2): maxDailyActions=15 FCE match +
		caps-cannot-rise-via-override clause
		Phase 5.5 failureHandling (1): rationale rewrite 'at least
		comparable to FCE convergence sensitivity'
		Phase 5.6 outer rationale (3): 4 FORBIDDEN canonical (clean
		taxonomy: FORBIDDEN = constitutional identity violation;
		founder-only = sensibility/calibration alteration sem colapso
		ontológico imediato) + section 9 governance-cannot-self-weaken
		4th clause (anti-self-erosion meta-imunological) + section 12
		SRR-pending temporal note

		Total ~24 founder ajustes integrated across 6 sub-phases —
		densidade reflete NTF constitutional complexity (7 priority
		axes + 15 drift metrics + MCM exception class formalization
		ADR-088 + asymmetric provenance ontology + forensic-integrity
		layer + linguistic drift detection meta-imunological).
		"""
}
