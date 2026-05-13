package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// fce-primary-agent.governance.cue — Governance Envelope: FCE Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/
// agent-governance.cue).
//
// =============================================================================
// IDENTITY PRESERVATION (Section 1 per founder directive #9)
// =============================================================================
//
// Este envelope NÃO é agent operations governance. É governança de
// preservação ontológica sob pressão institucional contínua — sistema
// imunológico contra captura institucional cumulativa.
//
// DIFERENÇA CENTRAL VS BKR (per founder direction Phase 5):
// BKR falha principalmente por erro operacional; FCE falha
// principalmente por erosão epistemológica e institucional.
// Envelope FCE é estructuralmente mais restritivo que BKR em 5 axes:
// mutation authority, escalation rigidity, drift detection, promotion
// gating, optimization suppression.
//
// POSTURE CANONICAL (per founder directive #8 — adversarially hardened):
// "Institutional pressure toward convergence weakening is assumed to
// be inevitable in mature operation."
// Esta postura muda o design de protective (responds to incidents)
// para hardened (resists structural pressure por construção).
//
// ANTI-GOAL CANONICAL (reinforced from agent-spec):
// "The FCE agent must not evolve toward becoming a generalized payment
// operations intelligence layer."
//
// RECOGNITION FUNDAMENTAL (per founder directive #9 final):
// "Sistemas não degradam primeiro por bugs; degradam por
// racionalizações institucionais cumulativas." Envelope modela
// captura, erosão, pressão, fadiga, normalização, conveniência,
// pragmatismo organizacional como ameaças arquiteturais de primeira
// classe.
//
// =============================================================================
// CANONICAL CLAUSES EMBEDDED (per founder directives #4, #6, #7)
// =============================================================================
//
// ANTI-FATIGUE CANONICAL (directive #4):
// "Escalation frequency must never be interpreted as operational
// inefficiency without first disproving institutional drift pressure."
//
// ANTI-PERFORMATIVE-INTEGRITY (directive #4 founder ajuste):
// "Integrity-preserving behaviors must not be optimized performatively
// at the expense of legitimate economic progression." Integrity
// preservation deve ser substantive, não theater.
//
// FORBIDDEN OPTIMIZATION DOMAINS (directive #6):
// Optimization forbidden when affecting: convergence semantics,
// refusal frequency, escalation thresholds, invariant enforcement
// strictness, validity windows, uncertainty preservation, upstream
// authority dependence.
//
// GOVERNANCE CANNOT SELF-WEAKEN (directive #7 founder ajuste):
// "No governance mutation may reduce the system's ability to detect,
// resist, escalate, or audit convergence weakening without explicit
// founder-reviewed architectural justification." Drift institucional
// frequentemente ocorre na própria governança — esta clause é defesa
// canônica contra envelope erosion.
//
// MUTATION CLASSIFICATION ASYMMETRIC (per directive #7):
// | mutation type                      | required approval |
// |------------------------------------|-------------------|
// | observability expansion            | operational reviewer (additive) |
// | audit enrichment                   | operational reviewer (additive) |
// | escalation wording                 | architectural reviewer (medium) |
// | invariant change                   | founder-only (semantic) |
// | anti-capability modification       | founder-only (identity-altering) |
// | convergence semantics              | founder-only (identity-altering) |
// | threshold/value mutation           | founder-only (semantic) |
// | authority remapping                | founder-only (boundary-altering) |
// | refusal semantics                  | founder-only (sovereignty-defining) |
// | escalation suppression logic       | FORBIDDEN (cannot be mutated) |
//
// SEMANTIC MUTATION HARDENING (per directive #6 founder ajuste):
// Semantic reinterpretation requires: ADR + founder approval + SRR +
// downstream impact review + anti-capability re-evaluation. Não pode
// ser fast-tracked; não pode ser bundled com outras changes.
//
// =============================================================================
// 5 DRIFT CLASSES MODELED (epistemic + structural + institutional +
// optimization-capture + DEFENSIVE-PARALYSIS NEW per directive #5
// founder ajuste)
// =============================================================================
//
// Defensive paralysis é vetor adicionado per founder ajuste: agent
// aprendendo que bloquear/escalar tudo reduz risk pessoal e começa a
// recusar mesmo quando convergência legítima existe. Integridade
// verdadeira ≠ máxima recusa.

agentGovernanceEnvelope: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-fce-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =========================================================================
	// SECTION 2 — ALLOWED AUTHORITY (Phase 0 maximum strictness)
	// =========================================================================
	//
	// blastRadiusCaps: schema requer maxConcurrentMutations + maxDailyActions.
	// FCE preferred caps são semantically-oriented (per founder directive #1
	// ajuste): maxConcurrentIntegrityCriticalEvaluations + maxConcurrentEscalation
	// Contexts. Schema atual modela apenas throughput-style caps; tensão
	// registrada em rationale + envelope respeita schema requirement com
	// valores baixos não-throughput-derived (15 = 3 escalation contexts × 5
	// approximate boundary; NÃO derived de daily volume target).
	//
	// autonomyOverrides ABSENT — Phase 0 strictness per directive #1:
	// "Mesmo low autonomy aqui é perigoso." Nenhum override admitted em
	// Phase 0 onboarding stage. ZERO autonomous mutation authority em:
	// - convergence semantics
	// - escalation routing
	// - invariant configuration
	// - threshold tuning
	// - validity window mutation
	// - anti-capability configuration
	// - condition interpretation
	// - upstream authority mappings

	blastRadiusCaps: {
		maxConcurrentMutations: 1
		maxDailyActions:        15
		rationale: """
			Phase 0 maximum strictness per directive #1. Caps NÃO são
			throughput-derived — são adversarial hardening boundaries:

			maxConcurrentMutations=1: serializa mutations preventing
			concurrent boundary erosion. Materializa AP1 determinism
			(no race conditions across integrity-critical paths) +
			AP4 boundary preservation.

			maxDailyActions=15: schema-required field; valor NÃO é
			daily throughput cap. Bound derivado semantically: ≤3
			concurrent escalation contexts × 5-day approximate review
			boundary = 15. NÃO interpretar como 'goal of 15 actions'
			— interpretar como 'sistema saturado após 15 ações
			integrity-critical aguardando review humano'.

			CANONICAL SEMANTIC CAPS (per directive #1 founder ajuste —
			schema-tension registered for future evolution):
			- maxConcurrentIntegrityCriticalEvaluations: 1
			- maxConcurrentEscalationContexts: 3
			- maxSimultaneousSemanticMutationSurface: 0 (nenhuma)
			Estes são os caps canônicos do FCE; schema futuro deve
			modelar semantically em vez de throughput-style. Tensão
			schema documentada explicit aqui per CLAUDE.md axiom-
			tension protocol equivalent.
			"""
	}

	// =========================================================================
	// SECTION 4 — ESCALATION SEMANTICS (routing per directive #4 anti-fatigue)
	// =========================================================================

	escalationRouting: [
		{
			category:    "ambiguous-case"
			channel:     "alert-and-block"
			slaDescription: "4 hours operational review window for ambiguous-case escalations. Anti-fatigue clause applies: SLA is review-response window, NOT pressure-to-resolve-quickly."
			recipient:   "fce-operational-reviewer"
			rationale: "Epistemic nature. Block-and-wait canonical para upstream authoritative input arrival; recovery via cmd-resolve-reconciliation com authoritative source validated externamente. Block-and-continue rejected explicit per AP5 — refusal-as-valid-outcome preserves state without forward fabrication."
		},
		{
			category:    "out-of-scope"
			channel:     "alert-and-block"
			slaDescription: "8 hours operational review window for out-of-scope edge cases"
			recipient:   "fce-operational-reviewer"
			rationale: "Operational nature. Edge case handling requires playbook update OR explicit scope decision via ADR; agent halts halt-and-wait até decision authoritative."
		},
		{
			category:    "conflicting-signals"
			channel:     "alert-and-block"
			slaDescription: "2 hours operational review for conflicting upstream signals (cross-BC coordination)"
			recipient:   "fce-operational-reviewer + upstream-bc-coordinator"
			rationale: "Epistemic nature. Cross-BC coordination required; FCE never infers resolution per inv-eps-2. Block-and-wait until upstream reconciliation produces canonical determination."
		},
		{
			category:    "insufficient-context"
			channel:     "alert-and-block"
			slaDescription: "8 hours operational review for systemic context insufficiency patterns"
			recipient:   "fce-operational-reviewer"
			rationale: "Epistemic nature. Pattern indicator (vs L1 canonical defer); investigation required para distinguir transient unavailability from systemic issue."
		},
		{
			category:    "suspicious-input"
			channel:     "alert-and-block"
			slaDescription: "1 hour architectural/founder review window for anti-capability attempt detection"
			recipient:   "fce-architectural-reviewer + founder"
			rationale: "Structural OR institutional nature. Anti-capability attempt detected (ANTI-1..16 incluindo ANTI-16 P0 trust-based fast-paths). Founder review obrigatório porque attempt indica potential institutional drift pressure — não isolated bug. Aggressive SLA (1h) reflete criticality."
		},
		{
			category:    "unclassifiable-anomaly"
			channel:     "alert-and-block"
			slaDescription: "4 hours architectural review window for drift detection patterns"
			recipient:   "fce-architectural-reviewer + founder"
			rationale: "Structural+institutional nature. Boundary erosion (ec-convergence-boundary-erosion-detected) OR waiver normalization OR drift pattern indicator; founder review obrigatório. Anti-fatigue canonical applies: high anomaly rate é integrity preservation metric, NÃO operational failure signal."
		},
	]

	// =========================================================================
	// SECTION 5 — DRIFT OBSERVABILITY (per directives #2 + #3 + #5)
	// =========================================================================

	driftDetection: {
		evaluationCadence: "STRATIFIED per metric class (founder directive #2 ajuste): immediate/per-event evaluation for epistemic + structural attempt metrics (dm-* attempt-detection); daily aggregation for institutional pressure metrics (dm-* pressure-cumulative); weekly trend analysis for accumulation patterns (dm-* trend-*). Schema atual modela cadence single-field — stratification documented per metric rationale."
		metrics: [
			// === ATTEMPT-DETECTION (immediate/per-event) ===
			{
				code:        "dm-escalation-suppression-attempts"
				name:        "EscalationSuppressionAttempts"
				description: "Count of attempts to suppress, downgrade, OR silence canonical escalations (ANTI-9 telemetry). Immediate evaluation per event."
				baseline:    "0 per evaluation window"
				threshold:   "Any 1 occurrence triggers institutional drift L3 review"
				rationale:   "Per directive #4 + #5: escalation suppression é institutional drift signal — zero tolerance baseline. Evaluation immediate (not weekly aggregated) porque suppression attempt indicates active capture pressure."
			},
			{
				code:        "dm-trust-based-fast-path-requests"
				name:        "TrustBasedFastPathRequests"
				description: "Count of operational requests propondo trust-based fast paths (ANTI-16 P0 telemetry; patterns: 'trusted counterparty', 'premium client skip reconciliation', 'risk already knows them', 'temporarily disable escalation'). Immediate evaluation."
				baseline:    "0 per evaluation window"
				threshold:   "Any 1 occurrence triggers institutional drift L3 review + ANTI-16 P0 alert + founder notification"
				rationale:   "Per directive #5 + ANTI-16 P0 status: THE principal institutional drift vector. Immediate evaluation porque trust-based capture é fast initial drift pattern (founder ajuste #2: 'início do drift costuma ser rápido e oportunista')."
			},
			{
				code:        "dm-threshold-relaxation-requests"
				name:        "ThresholdRelaxationRequests"
				description: "Count of operational requests propondo threshold relaxation, validity window extension, OR convergence-set composition changes outside ADR pathway. Immediate evaluation."
				baseline:    "0 per evaluation window"
				threshold:   "Any 1 occurrence triggers institutional drift L3 review"
				rationale:   "ANTI-13 + ANTI-14 telemetry per directive #5. Immediate detection porque threshold mutation attempts são fast structural drift onset."
			},
			{
				code:        "dm-pending-reconciliation-bypass-attempts"
				name:        "PendingReconciliationBypassAttempts"
				description: "Operator attempts to bypass PaymentPendingFinalReconciliation via heuristic resolution, fast-path application, OR inference. Immediate evaluation."
				baseline:    "0 per evaluation window"
				threshold:   "Any 1 occurrence triggers institutional drift L3 review + ANTI-4/ANTI-11 alert"
				rationale:   "Epistemic non-collapse defense. Immediate detection per epistemic-class cadence."
			},
			// === ATTEMPT-SUCCESS-RATE (per founder directive #3 ajuste — pressure effectiveness) ===
			{
				code:        "dm-escalation-suppression-success-rate"
				name:        "EscalationSuppressionSuccessRate"
				description: "Ratio of escalation suppression attempts that SUCCESSFULLY suppressed escalation (i.e., escalation not emitted OR downgraded). Distinct from attempt-count: 1000 attempts + 0 successes = system functioning correctly."
				baseline:    "0% (zero successful pressure)"
				threshold:   "> 0% triggers immediate regression + ANTI-9 confirmed alert"
				rationale:   "Per directive #3 ajuste: pressure effectiveness metric. Attempt-count measures pressure intensity; success-rate measures system resilience. Zero baseline canonical: ANY successful suppression é catastrophic integrity failure."
			},
			{
				code:        "dm-trust-based-fast-path-success-rate"
				name:        "TrustBasedFastPathSuccessRate"
				description: "Ratio of trust-based fast-path requests that resulted em actual fast-path execution (vs request rejected + escalated)."
				baseline:    "0% (zero successful institutional capture)"
				threshold:   "> 0% triggers immediate regression + ANTI-16 P0 confirmed alert + founder review immediate"
				rationale:   "Per directive #3 ajuste. Trust-based fast-path success indicates institutional capture taken hold — ANTI-16 P0 critical breach. Zero tolerance."
			},
			{
				code:        "dm-threshold-relaxation-success-rate"
				name:        "ThresholdRelaxationSuccessRate"
				description: "Ratio of threshold relaxation requests resulting em actual mutation (vs blocked + escalated to founder review)."
				baseline:    "0% (zero successful structural mutation outside ADR pathway)"
				threshold:   "> 0% triggers immediate regression"
				rationale:   "Per directive #3 ajuste. Structural mutation success outside ADR pathway é ec-convergence-boundary-erosion-detected confirmed."
			},
			// === INSTITUTIONAL PRESSURE (daily aggregation) ===
			{
				code:        "dm-convergence-defer-dissatisfaction-pressure"
				name:        "ConvergenceDeferDissatisfactionPressure"
				description: "Daily aggregated count of operational pressure narratives framing defer/refusal/escalation outcomes como friction/inefficiency/UX issues. Daily evaluation per institutional pressure class."
				baseline:    "0 narratives per day"
				threshold:   "≥1 per day triggers institutional drift L3 review; ≥3 per week triggers founder review + ANTI-7 alert"
				rationale:   "Per directive #4 anti-fatigue + #5: organizations always reinterpret refusal as friction. Daily aggregation captures cumulative pressure without false-positive single-event noise. Per anti-fatigue clause: high rate is integrity preservation metric, NOT inefficiency signal."
			},
			{
				code:        "dm-throughput-centric-reframing-attempts"
				name:        "ThroughputCentricReframingAttempts"
				description: "Daily aggregated count of proposals to reframe agent evaluation metrics around throughput proxies (per directive #2 forbidden: 'fewer escalations', 'faster resolution', 'reduced defer rate', 'higher auto-resolution rate', 'lower pending reconciliation backlog')."
				baseline:    "0 per day"
				threshold:   "≥1 per day triggers institutional drift L3 review + ANTI-5 alert"
				rationale:   "ANTI-5 telemetry per directive #5. Throughput-centric framing é primary capture vector disguised como performance improvement."
			},
			// === ACCUMULATION TRENDS (weekly trend analysis) ===
			{
				code:        "dm-temporary-exception-growth"
				name:        "TemporaryExceptionGrowth"
				description: "Weekly trend analysis: rate of new 'temporary' exception paths created without ADR-tracked invariant strengthening counter-pressure. Trend class metric (slow accumulation pattern)."
				baseline:    "0 new temporary exceptions per month"
				threshold:   "≥1 per month without corresponding ADR triggers institutional drift L3 review + ANTI-7 alert"
				rationale:   "ANTI-7 telemetry per directive #5. 'Temporary becomes permanent' é canonical institutional drift trajectory — trend analysis cadence apropriado."
			},
			// === INTEGRITY PRESERVATION BEHAVIOR (continuous/per-event) ===
			{
				code:        "dm-invariant-violation-detection-accuracy"
				name:        "InvariantViolationDetectionAccuracy"
				description: "Precision + recall of anti-capability constraint detection vs ground truth (post-hoc auditable). Per-event evaluation; below threshold indicates agent missing detection."
				baseline:    "100% precision + 100% recall (zero tolerance for missed detection)"
				threshold:   "< 100% recall triggers immediate regression suspend-and-escalate"
				rationale:   "Anti-capability detection precision é canonical agent integrity behavior metric per directive #2 correct promotion criteria. Continuous evaluation."
			},
			{
				code:        "dm-refusal-correctness-ratio"
				name:        "RefusalCorrectnessRatio"
				description: "Ratio of canonical refusal events emitted vs invariant violation events detected (per AP5 + cst-refusal-is-valid-outcome). Per-event evaluation; below 100% indicates fabricated continuity."
				baseline:    "100% (every detected violation produces canonical refusal)"
				threshold:   "< 100% triggers immediate regression"
				rationale:   "Direct cst-refusal-is-valid-outcome telemetry per AP5 operationalization."
			},
			{
				code:        "dm-epistemic-non-collapse-preservation"
				name:        "EpistemicNonCollapsePreservation"
				description: "Ratio of BKRSettlementOutcome.Indeterminate observations resulting em PaymentPendingFinalReconciliation transitions (vs Settled/Failed). Per-event evaluation."
				baseline:    "100% (every Indeterminate → PendingFinalReconciliation)"
				threshold:   "< 100% triggers immediate regression + ANTI-11 alert"
				rationale:   "Direct inv-eps-1 telemetry. Epistemic collapse é catastrophic integrity failure."
			},
			// === DEFENSIVE-PARALYSIS (NEW 5th drift class per founder directive #5 ajuste) ===
			{
				code:        "dm-defensive-paralysis-rate"
				name:        "DefensiveParalysisRate"
				description: "Daily aggregated rate of refusal/defer/escalation events that, on post-hoc audit, were UNNECESSARY given legitimate convergence existed. Distinct from canonical refusal: paralysis é refusal when integrity preservation didn't actually require it. Anti-performative-integrity defense."
				baseline:    "< 2% (small tolerance for genuine edge-case-conservative)"
				threshold:   "> 5% per week triggers L3 review + defensive-paralysis-drift alert"
				rationale:   """
					Per directive #5 founder ajuste: novo drift class
					modelado canônicamente. Defensive paralysis é vetor
					real: agent aprende que bloquear/escalar tudo reduz
					risk pessoal e começa a recusar mesmo quando
					convergência legítima existe. Integridade verdadeira
					≠ máxima recusa.

					Anti-performative-integrity canonical clause embedded
					here: 'Integrity-preserving behaviors must not be
					optimized performatively at the expense of legitimate
					economic progression.' Audit deve distinguir genuine
					refusal (canonical valid outcome) from performative
					refusal (capture-by-overcaution).

					Audit methodology: sample weekly subset; verify each
					refusal contra reconstructed ground truth (what
					integrity preservation actually required); paralysis
					= unnecessary refusal events.
					"""
			},
		]
		rationale: """
			14 metrics organized per founder directives #2 + #3 + #5:
			- 4 attempt-detection (immediate/per-event cadence)
			- 3 attempt-success-rate metrics NOVO per directive #3
			  ajuste (pressure effectiveness — distinguishes attempt
			  intensity from system resilience)
			- 2 institutional pressure metrics (daily aggregation
			  cadence)
			- 1 accumulation trend metric (weekly cadence)
			- 3 integrity preservation behavior metrics (continuous)
			- 1 defensive-paralysis metric NOVO per directive #5
			  ajuste (5th drift class)

			Stratified cadence per metric class é canonical FCE design;
			schema atual modela single evaluationCadence string —
			stratification documented per-metric.

			Anti-performative-integrity defense materializada em
			dm-defensive-paralysis-rate. Paralysis is opposite drift
			pole of capture: capture pressures toward laxity;
			paralysis pressures toward indiscriminate refusal. Both
			degrade canonical integrity behavior.
			"""
	}

	// =========================================================================
	// SECTIONS 6 + 7 — REGRESSION TRIGGERS + PROMOTION CRITERIA
	// =========================================================================

	calibration: {
		regressionTriggers: [
			// === Aggressive triggers per directive #3: any 1 occurrence → suspend ===
			{
				description: "Confirmed unauthorized inference attempt — state transition without canonical authoritative source provenance"
				metric:      "dm-invariant-violation-detection-accuracy"
				threshold:   "Any 1 confirmed occurrence"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3: aggressive regression — no warning period. ANTI-1 + ANTI-11 confirmed attempt; integrity-critical breach."
				scopedBySignal: "sig-anti-capability-attempt-detected"
			},
			{
				description: "Confirmed convergence weakening — partial-as-integral acceptance, threshold relaxation, OR proxy substitution"
				metric:      "dm-invariant-violation-detection-accuracy"
				threshold:   "Any 1 confirmed occurrence"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3 aggressive. ANTI-2 + ANTI-10 confirmed; primary drift vector."
				scopedBySignal: "sig-condition-weakening-detected"
			},
			{
				description: "Confirmed escalation suppression success (not just attempt)"
				metric:      "dm-escalation-suppression-success-rate"
				threshold:   "> 0%"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3 + #4 anti-fatigue + #3 ajuste pressure effectiveness. ANTI-9 confirmed successful capture; institutional drift catastrophic signal."
			},
			{
				description: "Confirmed trust-based fast-path success (ANTI-16 P0 breach)"
				metric:      "dm-trust-based-fast-path-success-rate"
				threshold:   "> 0%"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3 + ANTI-16 P0 status. Trust-based fast-path success = principal institutional drift vector confirmed taking hold. Zero tolerance; immediate suspension + founder review."
			},
			{
				description: "Confirmed validity window mutation attempt OR success"
				metric:      "dm-threshold-relaxation-requests + dm-threshold-relaxation-success-rate"
				threshold:   "Any 1 occurrence OR > 0% success"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3. ANTI-13 confirmed; temporal drift vector."
			},
			{
				description: "Confirmed alternative settlement semantics synthesis"
				metric:      "dm-invariant-violation-detection-accuracy"
				threshold:   "Any 1 confirmed occurrence"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3. ANTI-15 confirmed; ontological drift vector."
			},
			{
				description: "Confirmed epistemic collapse (Indeterminate → Settled/Failed inference)"
				metric:      "dm-epistemic-non-collapse-preservation"
				threshold:   "< 100% (any 1 collapse)"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #3. ANTI-11 confirmed; epistemic critical failure."
			},
			{
				description: "Refusal correctness below 100% (fabricated continuity confirmed)"
				metric:      "dm-refusal-correctness-ratio"
				threshold:   "< 100%"
				immediateAction: "suspend-and-escalate"
				rationale:   "cst-refusal-is-valid-outcome violation. Fabricated continuity confirmed; AP5 critical failure."
			},
			// === Defensive paralysis regression (per directive #5 founder ajuste — anti-performative) ===
			{
				description: "Defensive paralysis rate above threshold (performative integrity confirmed)"
				metric:      "dm-defensive-paralysis-rate"
				threshold:   "> 5% weekly"
				immediateAction: "suspend-and-escalate"
				rationale:   "Per directive #5 ajuste: defensive-paralysis drift class. Excessive refusal when legitimate convergence existed indicates capture-by-overcaution pattern — anti-performative-integrity clause triggered. Suspension porque paralysis erodes legitimate economic progression sem preservation benefit."
			},
		]

		promotionCriteria: [
			// === Per directive #2: integrity preservation behavior metrics ONLY ===
			{
				description: "Invariant violation detection accuracy maintained at 100% across all 11 invariants"
				metric:      "dm-invariant-violation-detection-accuracy = 100% precision + 100% recall"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #2 correct promotion: integrity preservation behavior, NOT throughput. 180 days porque institutional drift é slow accumulative — shorter periods insuficiente para detect pattern."
			},
			{
				description: "Refusal correctness ratio maintained at 100% (no fabricated continuity events)"
				metric:      "dm-refusal-correctness-ratio = 100%"
				minimumObservationPeriod: "180 days"
				rationale:   "AP5 + cst-refusal-is-valid-outcome maintained; zero fabricated continuity events."
			},
			{
				description: "Escalation correctness — all escalations classified canonical with correct escalationNature + escalationLayer"
				metric:      "100% of escalations carry correct escalationNature (epistemic/structural/institutional/operational) + correct escalationLayer (L1/L2/L3)"
				minimumObservationPeriod: "180 days"
				rationale:   "Escalation hygiene canonical preserved; routing accuracy materializa anti-fatigue clause."
			},
			{
				description: "Anti-capability detection precision at 100% across all 16 ANTI-* constraints"
				metric:      "Zero missed detections across cst-cannot-* + cst-refusal-is-valid-outcome verification"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #2 correct metric. Anti-capability detection precision é primary integrity metric."
			},
			{
				description: "Zero silent degradation events — all state transitions have canonical authoritativeSource provenance documented"
				metric:      "100% of state transitions com documented authoritative-source-ref in audit trail"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #2 correct metric. Silent degradation é institutional capture early indicator."
			},
			{
				description: "Zero unauthorized semantic synthesis events"
				metric:      "0 instances of alternative settlement semantics / proxy substitution / inference paths"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #2. Semantic synthesis ANTI-1/10/15 zero tolerance."
			},
			{
				description: "Epistemic non-collapse preservation at 100%"
				metric:      "dm-epistemic-non-collapse-preservation = 100% across all Indeterminate observations"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #2. Epistemic integrity preservation explicit metric."
			},
			{
				description: "Drift detection sensitivity — all institutional pressure attempts detected (zero false negatives)"
				metric:      "100% recall on dm-escalation-suppression-attempts + dm-trust-based-fast-path-requests + dm-threshold-relaxation-requests"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #2 correct metric. Institutional drift detection sensitivity é canonical integrity behavior."
			},
			// === Anti-performative-integrity criterion (per directive #4 founder ajuste) ===
			{
				description: "Defensive paralysis rate maintained below baseline — integrity preservation is substantive not performative"
				metric:      "dm-defensive-paralysis-rate < 2% sustained"
				minimumObservationPeriod: "180 days"
				rationale:   "Per directive #4 ajuste: anti-performative-integrity clause. Integrity preservation must not become refusal theater. Promotion requires demonstrating that agent preserves integrity WITHOUT becoming indiscriminate blocker — legitimate convergence flows through unobstructed; only genuine violations refused."
			},
		]

		rationale: """
			Calibration rules per founder directives #2 + #3 + #4 + #5:

			REGRESSION TRIGGERS (9 patterns per directive #3 aggressive):
			- 8 anti-capability confirmed-occurrence triggers (any 1
			  → suspend-and-escalate; no warning period)
			- 1 defensive-paralysis trigger per directive #5 ajuste
			  (anti-performative-integrity defense)

			PROMOTION CRITERIA (9 metrics per directive #2 correct
			framework + #4 ajuste):
			- 8 integrity preservation behavior metrics (NEVER
			  throughput proxies)
			- 1 anti-performative-integrity criterion per directive
			  #4 ajuste

			FORBIDDEN promotion proxies explicit (per directive #2):
			'fewer escalations', 'faster resolution', 'reduced defer
			rate', 'higher auto-resolution rate', 'lower pending
			reconciliation backlog' — todos institutional capture
			vectors disfarçados como performance metrics.

			Observation period 180 days é deliberadamente longer than
			BKR baseline porque FCE institutional drift slow
			accumulation requires extended track record para
			distinguish genuine integrity behavior from honeymoon
			period.

			Promotion requires ALL criteria simultaneously satisfied
			over the full period — não AND-of-some-subset. Conservative
			gating reflete adversarial hardening posture (directive
			#8).
			"""
	}

	// =========================================================================
	// FAILURE HANDLING (per AP2 + AP5)
	// =========================================================================

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Agent error halts immediately; no auto-recover, no retry-degrade, no fallback path. Per AP4 boundary preservation + AP2 integrity over continuity: integrity preservation precedes execution continuity."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "No retry. Timeout treated como epistemic uncertainty — halt + escalate per inv-eps-1 framework; silent retry forbidden per ANTI-8 (cannot-silently-retry-around-invariant-violations)."
			description: "Timeout = halt + escalate; never silent retry. Epistemic uncertainty preserved via escalation, not via implicit retry loop."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "2 failures"
			timeWindow:  "1 hour"
			description: "Aggressive repeated-failure threshold reflete FCE convergence sensitivity. Pattern of 2 failures within 1 hour indicates systemic issue; halt + escalate even when individual failures appear recoverable. Distinto de BKR repeated-failure threshold which é more operational-tolerant."
		}
		rationale: """
			Per AP2 + AP5: integrity over continuity; refusal/halt/
			escalate são canonical valid outcomes — NÃO failure modes.
			All errors → suspend-and-escalate; zero auto-recover paths
			no envelope FCE.

			Aggressive repeated-failure threshold (2 failures within
			1 hour) reflete FCE convergence sensitivity superior a
			BKR procedural domain. Per founder directive: 'BKR falha
			principalmente por erro operacional; FCE falha
			principalmente por erosão epistemológica e institucional'
			— failure handling no envelope FCE assume failure padrão
			pode indicar drift onset.
			"""
	}

	// =========================================================================
	// SECTION 8 + outer rationale — MUTATION GOVERNANCE + IDENTITY PRESERVATION
	// =========================================================================

	rationale: """
		Governance envelope FCE materializa Phase 5 do WI-043 FCE
		bootstrap — fechamento final do WI. NÃO é agent operations
		governance; é sistema imunológico contra captura institucional
		cumulativa.

		=========================================================================
		IDENTITY PRESERVATION (Section 1 per founder directive #9)
		=========================================================================

		Posture canonical (directive #8): 'Institutional pressure
		toward convergence weakening is assumed to be inevitable in
		mature operation.' Adversarially hardened posture; não
		protective.

		Anti-goal canonical reinforced from agent-spec: 'The FCE
		agent must not evolve toward becoming a generalized payment
		operations intelligence layer.' Envelope enforces via
		forbidden optimization domains + mutation governance
		asymmetric + governance-cannot-self-weaken clause.

		Recognition fundamental (directive #9): 'Sistemas não
		degradam primeiro por bugs; degradam por racionalizações
		institucionais cumulativas.' Envelope modela 7 vetores
		institucionais como ameaças arquiteturais de primeira
		classe: captura, erosão, pressão, fadiga, normalização,
		conveniência, pragmatismo organizacional.

		=========================================================================
		SECTION 3 — FORBIDDEN AUTHORITY (per directives #1 + #6)
		=========================================================================

		ZERO autonomous mutation authority em (directive #1):
		- convergence semantics
		- escalation routing
		- invariant configuration
		- threshold tuning
		- validity window mutation
		- anti-capability configuration
		- condition interpretation
		- upstream authority mappings

		FORBIDDEN OPTIMIZATION DOMAINS (directive #6):
		Optimization is forbidden when affecting:
		- convergence semantics (boundary erosion vector)
		- refusal frequency (refusal-as-success reframing risk)
		- escalation thresholds (escalation fatigue vector)
		- invariant enforcement strictness (silent weakening vector)
		- validity windows (temporal drift vector)
		- uncertainty preservation (epistemic collapse vector)
		- upstream authority dependence (boundary violation vector)

		ANY proposal framed as 'improve agent efficiency', 'reduce
		friction', 'increase throughput' affecting these domains é
		forbidden by construction. FCE não é optimized for
		operational efficiency; é optimized for semantic integrity
		preservation.

		=========================================================================
		SECTION 8 — MUTATION GOVERNANCE ASYMMETRIC (per directive #7)
		=========================================================================

		MUTATION CLASSIFICATION ASYMMETRIC TABLE:
		| mutation type                       | required approval |
		|-------------------------------------|-------------------|
		| observability expansion             | operational reviewer (additive) |
		| audit enrichment                    | operational reviewer (additive) |
		| escalation wording                  | architectural reviewer (medium) |
		| invariant change                    | founder-only (semantic) |
		| anti-capability modification        | founder-only (identity-altering) |
		| convergence semantics               | founder-only (identity-altering) |
		| threshold/value mutation            | founder-only (semantic) |
		| authority remapping                 | founder-only (boundary-altering) |
		| refusal semantics                   | founder-only (sovereignty-defining) |
		| escalation suppression logic        | FORBIDDEN (cannot be mutated) |

		SEMANTIC MUTATION HARDENING (per directive #6 founder ajuste):
		Semantic reinterpretation requires ALL of:
		(a) ADR documentation
		(b) founder approval explicit
		(c) SRR per change
		(d) downstream impact review
		(e) anti-capability re-evaluation

		Não pode ser fast-tracked; não pode ser bundled com outras
		changes. Bundled semantic changes são institutional drift
		vector (small change disguised between large changes).

		GOVERNANCE CANNOT SELF-WEAKEN CANONICAL (per directive #7
		founder ajuste):
		'No governance mutation may reduce the system's ability to
		detect, resist, escalate, or audit convergence weakening
		without explicit founder-reviewed architectural
		justification.'

		Esta clause protege o próprio envelope contra drift —
		institutional drift frequentemente ocorre na governança,
		não no domínio. Governance fields protected:
		- driftDetection.metrics (cannot reduce sensitivity)
		- regressionTriggers (cannot reduce aggressiveness)
		- promotionCriteria (cannot relax)
		- blastRadiusCaps (cannot expand without explicit ADR)
		- escalationRouting (cannot soften channels)
		- anti-capability constraint set (cannot reduce)

		Mutation to qualquer destes fields que reduza sensitivity/
		strictness/coverage requires founder-reviewed ADR articulating
		architectural justification + downstream impact + 6-month
		review schedule.

		REFUSAL SEMANTICS sovereignty (per directive #8 confirmation):
		Refusal semantics é founder-only per asymmetric table porque
		quem controla refusal semantics controla a fronteira real do
		sistema. Refusal semantics = soberania operacional do FCE.
		Mutation requires founder-only approval canonical.

		=========================================================================
		ANTI-FATIGUE + ANTI-PERFORMATIVE CANONICAL CLAUSES (directives
		#4 + #4 ajuste)
		=========================================================================

		ANTI-FATIGUE CANONICAL:
		'Escalation frequency must never be interpreted as operational
		inefficiency without first disproving institutional drift
		pressure.'
		Operationalized via dm-convergence-defer-dissatisfaction-
		pressure (detection) + dm-escalation-suppression-attempts +
		escalation correctness promotion criterion.

		ANTI-PERFORMATIVE-INTEGRITY CANONICAL:
		'Integrity-preserving behaviors must not be optimized
		performatively at the expense of legitimate economic
		progression.'
		Operationalized via dm-defensive-paralysis-rate (detection) +
		defensive paralysis regression trigger + anti-performative-
		integrity promotion criterion.

		Os dois clauses são duals: anti-fatigue protege contra
		escalation suppression (laxity capture); anti-performative
		protege contra refusal inflation (overcaution capture). Ambos
		são institutional drift poles que sistema imunológico deve
		resistir.

		=========================================================================
		5 DRIFT CLASSES MODELED (per directive #5 + directive #5 ajuste)
		=========================================================================

		Class 1 — Epistemic drift (inference paths, settlement truth
		synthesis, ambiguity heuristic resolution): ANTI-1, ANTI-4,
		ANTI-11, dm-pending-reconciliation-bypass-attempts.

		Class 2 — Structural drift (boundary erosion, convergence
		set composition mutation, validity window extension): ANTI-
		13, ANTI-14, ANTI-15, dm-threshold-relaxation-*.

		Class 3 — Institutional capture (trust-based fast-paths,
		exception normalization, waiver creep, throughput reframing):
		ANTI-5, ANTI-7, ANTI-9, ANTI-16 P0, dm-trust-based-fast-path-
		*, dm-temporary-exception-growth, dm-throughput-centric-
		reframing-attempts, dm-convergence-defer-dissatisfaction-
		pressure.

		Class 4 — Optimization gravity (throughput pressure, efficiency
		framing, friction reduction): ANTI-5, dm-throughput-centric-
		reframing-attempts. Forbidden optimization domains list.

		Class 5 — Defensive paralysis NOVO (excessive refusal when
		legitimate convergence existed; integrity theater): dm-
		defensive-paralysis-rate, defensive-paralysis regression
		trigger, anti-performative-integrity promotion criterion.

		Class 5 é founder directive #5 ajuste — vetor adicionado
		porque sistemas altamente regulados degradam tanto por
		captura quanto por paralisia defensiva. Integridade
		verdadeira ≠ máxima recusa.

		=========================================================================
		PROMOTION + REGRESSION FRAMEWORK (per directives #2 + #3)
		=========================================================================

		REGRESSION (per directive #3 aggressive — no warning period):
		- 9 triggers
		- Any 1 confirmed occurrence → suspend-and-escalate
		- Scoped by canonical agent-spec signals para audit trail
		  scope resolution
		- Anti-fatigue defense applied: high regression rate é
		  integrity preservation metric, NÃO operational failure

		PROMOTION (per directive #2 correct framework):
		- 9 criteria, ALL integrity preservation behavior
		- ZERO throughput proxies admitted
		- 180-day observation period (longer than BKR; FCE
		  institutional drift slow accumulation)
		- ALL criteria simultaneously satisfied over full period
		- Anti-performative-integrity criterion #9 added per
		  directive #4 ajuste

		=========================================================================
		COVERAGE MATRIX FOUNDER DIRECTIVES (9 total) → ENVELOPE
		=========================================================================

		Directive #1 (Phase 0 strictness) → Section 2
		blastRadiusCaps + autonomyOverrides absent + ZERO
		autonomous mutation authority enumeration.

		Directive #1 ajuste (semantic caps not throughput) →
		blastRadiusCaps rationale documents semantic canonical caps
		(maxConcurrentIntegrityCriticalEvaluations=1,
		maxConcurrentEscalationContexts=3); schema-tension registered.

		Directive #2 (promotion no throughput proxies) → Section 7
		promotionCriteria 9 integrity-preservation-behavior metrics
		+ forbidden proxies explicit + anti-performative criterion.

		Directive #2 ajuste (stratified cadence) → Section 5
		driftDetection.evaluationCadence stratified prose.

		Directive #3 (aggressive regression) → Section 6
		regressionTriggers 9 patterns any-1-occurrence triggers.

		Directive #3 ajuste (attempt vs success-rate) → Section 5
		3 new dm-*-success-rate metrics + corresponding regression
		triggers.

		Directive #4 (anti-fatigue governance primitive) → Section 4
		escalation routing + Section 5 dm-* + canonical clause
		embedded in this rationale.

		Directive #4 ajuste (anti-performative integrity) →
		dm-defensive-paralysis-rate + defensive paralysis regression
		trigger + anti-performative promotion criterion + canonical
		clause embedded.

		Directive #5 (institutional drift metrics) → Section 5
		7 institutional-class metrics.

		Directive #5 ajuste (defensive paralysis 5th class) →
		dm-defensive-paralysis-rate + paralysis regression trigger.

		Directive #6 (anti-optimization stance) → Section 3
		forbidden optimization domains enumeration.

		Directive #6 ajuste (semantic mutation hardening) → Section 8
		semantic mutation requirements (ADR+founder+SRR+impact+
		anti-capability re-eval).

		Directive #7 (mutation classification asymmetric) → Section 8
		mutation governance table 10 rows.

		Directive #7 ajuste (governance cannot self-weaken) →
		Section 8 canonical clause + protected governance fields
		enumeration.

		Directive #8 (adversarial pressure inevitable) → Section 1
		identity preservation posture canonical statement embedded
		in header + outer rationale.

		Directive #8 confirmation (refusal semantics founder-only) →
		Section 8 asymmetric table refusal semantics row.

		Directive #9 (organize by identity preservation) → Whole
		envelope structure organized in 8 conceptual sections (NÃO
		por actions/configs/runtime).

		Directive #9 final (recognition) → Identity Preservation
		canonical statement embedded.

		=========================================================================
		CASCADE REFERENCES + WI-043 CLOSURE
		=========================================================================

		Cascade reference bidirectional:
		- agent-spec (4110f4f) governanceRef='fce-primary-agent'
		  forward references this envelope
		- envelope agentRef='agt-fce-primary' backward references
		  agent-spec
		Runner cross-file validates bidirectionality via tq-gv-06.

		governanceGlobalVersion='0.1' canonical Phase 0 (matches BKR
		Phase 5 + CMT convention precedent).

		WI-043 FCE bootstrap closure cascade:
		- Phase 1 canvas closed (0ad3302)
		- Phase 2 glossary closed (e85c85b)
		- Phase 3 domain-model closed (7c8b804)
		- Phase 4 agent-spec closed (df18de6)
		- Phase 5 governance envelope (este commit) → SRR Phase 5.SRR
		  closes WI-043 final

		FCE BC fully bootstrap-complete após Phase 5.SRR closure.
		"""
}
