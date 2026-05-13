package bkr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// bkr-primary-agent.governance.cue — Agent Governance Envelope:
// BKR Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/
// agent-governance.cue).
//
// Supervisory layer per-agent sobre fundação canvas (Phase 1) + glossary
// (Phase 2) + domain-model (Phase 3) + agent-spec (Phase 4). Phase 5
// final do WI-062 BKR bootstrap — fecha pair (agent-spec + envelope)
// bidirecional ref per ADR-037.
//
// Composição:
// - Identity + lifecycle (onboarding) + bidirectional ref agt-bkr-primary
// - 5 escalation routes cobrindo 5 categories from agent-spec; 3 com
//   queue governance bounded + auto-cancel-and-escalate overflow per
//   adr-075
// - blastRadiusCaps Phase 0 (1 concurrent mutation + 40 daily total
//   actions); concurrency cap = safety boundary; daily cap = operational
//   envelope (separação semântica explícita)
// - autonomyOverrides OMITIDO inteiramente — supervised onboarding +
//   explicitness over convenience
// - driftDetection 7 metrics (6 mapeando canvas vm-bkr-01..07 + 1
//   process health) com cadence daily; mix deterministic + statistical
// - calibration 4 promotionCriteria (50 attempts incluindo non-happy
//   paths × 60 days × 0 boundary violations × 100% audit completeness) +
//   5 regressionTriggers (catastrophic + structural + boundary +
//   operational + consistency) com clearanceCondition no-signal-in-window
//   per adr-075; 5 scopedBySignal refs ao agent-spec observability
// - failureHandling per adr-058: onAgentError + onTimeout +
//   onRepeatedFailure todos conservative (suspend OR revert; no
//   automatic recovery Phase 0)
//
// Anti-economic-autonomy proof (founder canonical gate Phase 5):
// 7 layers de defense + explicit canonical clause forecloses 4 drift
// vectors (override escalation + governance drift + temporary exception
// permanence + informal promotion). Detalhamento completo no outer
// rationale section dedicada.
//
// Forward-refs Phase 0:
// - governanceGlobalVersion="0.1" canonical Phase 0 per CMT convention
//   (architecture/agent-governance.cue ainda não materializado)
// - tq-gv-09 (caps ≤ global) + tq-gv-12 (version match) warn-equivalent
//   Phase 0; turn fail pós-global creation

agentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-bkr-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// ============================================================
	// ESCALATION ROUTING (5 routes, 3 com queue governance)
	// ============================================================

	escalationRouting: [{
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Response required within 15 minutes during business hours (06:30-18:00 BRT business days) or within 1 hour off-hours. BKR halts operational dispatch path for affected attemptId/instructionId family until resolution."
		recipient:      "founder + compliance officer (Phase 0 pre-PMF; founder canonical primary per ADR-037)"
		rationale:      "Suspicious input categories — proof verification failure pattern (ec-authorization-proof-verification-failure), classification side-channel leak (ec-classification-side-channel-leak-detected), BKR meta info leak (ec-bkr-info-leak-meta-detection) — são adversarial signals requiring synchronous halt + forensic investigation. alert-and-block channel preserva inv-anti-decision-boundary via supervised gate; sem halt, replay/forgery/side-channel-sweep poderiam continuar undetected. Compliance officer no recipient garante regulatory awareness (sanctions/AML pattern detection é compliance scope)."
		maxQueueDepth:  2
		maxQueueAge:    "1h"
		overflowPolicy: {
			action:           "auto-cancel-and-escalate"
			cancelReasonCode: "queue-overflow"
			escalateVia:      "out-of-scope"
		}
	}, {
		category:       "conflicting-signals"
		channel:        "alert-and-block"
		slaDescription: "Response required within 15 minutes during business hours or within 1 hour off-hours. Default halt scope is affected instructionId family. Global rail halt requires repeated signal across multiple instructionIds or provider-level suspicion. vm-bkr-01 duplicate settlement rate target 0% requires immediate forensic."
		recipient:      "founder + compliance officer (double-settlement = catastrophic operational risk; cross-attempt anomaly = potential adversarial pattern)"
		rationale:      "Conflicting signals — double settlement detected (ec-double-settlement-detected level=critical via sig-double-settlement-suspicion), rail finality irreversibility conflict (ec-rail-finality-irreversibility-conflict), cross-attempt anomaly under instruction (ec-cross-attempt-anomaly-under-instruction) — indicate either reconciliation logic bug, rail-side bug, OR adversarial manipulation. alert-and-block channel é mandatory per vm-bkr-01 + inv-idempotency-enforcement-per-attempt; resolução exige human-level forensic investigation across multiple attempts."
		maxQueueDepth:  1
		maxQueueAge:    "1h"
		overflowPolicy: {
			action:           "auto-cancel-and-escalate"
			cancelReasonCode: "queue-overflow"
			escalateVia:      "out-of-scope"
		}
	}, {
		category:       "insufficient-context"
		channel:        "async-queue"
		slaDescription: "Response within 4 hours business hours. BKR does NOT halt operational dispatch for other attempts; affected attempt persists em state=indeterminate até explicit cmd-resolve-indeterminate-state per inv-indeterminate-state-non-collapse."
		recipient:      "operations team + founder (manual reconciliation expertise + final authority Phase 0)"
		rationale: """
			Insufficient context — indeterminate state exceeds operational
			window (ec-indeterminate-state-exceeds-operational-window) — é
			operational scenario expected em rail edge cases (timeout sem
			signal final, value divergence, signal contradiction). async-
			queue acceptable porque non-final state preservation é
			intrinsic to inv-indeterminate-state-non-collapse — não há
			urgency to collapse; resolution requires evidence collection
			which is async by nature (re-query rail OR manual reconciliation
			OR escalation per rail-specific timeout policy).

			Sem queue governance fields porque async-queue é o queue
			mechanism canônico (non-blocking by design); bounded queue +
			overflow não aplicam ao não-bloqueante.
			"""
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Response within 30 minutes business hours. BKR does NOT halt operational dispatch broadly; routing decision per failure classification pending review."
		recipient:      "compliance officer + founder (side-channel routing policy authority)"
		rationale:      "Ambiguous case — regulatory classification routing (ec-regulatory-classification-routing) — é routing/visibility decision com causal category known mas detail-disclosure ambiguous. sync-human-review channel é imediato mas non-blocking (operational dispatch para outros attempts continua); decision requires compliance officer policy clarification antes de proceder com classification publication. Per Phase 4.3 ajuste 1: ambiguity é routing/visibility, NÃO regulatory domain."
	}, {
		category:       "out-of-scope"
		channel:        "alert-and-block"
		slaDescription: "Response required within 15 minutes during business hours or within 1 hour off-hours. BKR halts affected rail-specific behavior (capability scope; not necessarily all attempts) until capability/schema update reviewed."
		recipient:      "founder + regulatory specialist (Bacen/CIP/SWIFT spec change OR provider behavior divergence requires structural review, not heuristic adaptation)"
		rationale:      "Out-of-scope — regulatory boundary misalignment (ec-regulatory-boundary-misalignment) — indica Bacen/CIP/SWIFT spec drift OR provider behavior divergence. Per Phase 4.3 ajuste 2 + glossary term-regulatory-boundary: BKR halt affected rail-specific behavior and escalate for capability/schema update; NO heuristic adaptation inside BKR. alert-and-block protege boundary integrity — interpretation of regulation por BKR violaria inv-anti-decision-boundary. Routing precedence (per tq-gvg-05): blocking > non-blocking; critical > warn > info; mutation-related > informational; explicit route > fallback."
		maxQueueDepth:  3
		maxQueueAge:    "24h"
		overflowPolicy: {
			action:           "auto-cancel-and-escalate"
			cancelReasonCode: "queue-overflow"
			escalateVia:      "suspicious-input"
		}
	}]

	// ============================================================
	// BLAST RADIUS CAPS (Phase 0 conservative)
	// ============================================================

	blastRadiusCaps: {
		maxConcurrentMutations: 1
		maxDailyActions:        40
		rationale: """
			Caps Phase 0 onboarding lifecycle para BKR high-criticality
			generic BC. Justificativa:

			maxConcurrentMutations=1 (serialização total Phase 0):
			- BKR não é apenas high-criticality — é boundary financeiro
			  irreversível + reconciliador canônico cross-BC + detector
			  de double settlement + portador de estado epistemológico
			  (indeterminate) + integrador de sinais externos não-
			  confiáveis. Concurrency cap=1 elimina uma classe inteira
			  de erros: race entre dispatch/reconciliation/cancellation;
			  ordering ambiguity; replay timing ambiguity; causal-debug
			  complexity explosion; forensic reconstruction harder
			  under incident.
			- Princípio Mesh aplicado: pagamos custo de complexidade
			  cedo para eliminar classes de erro. Custo operacional de
			  serializar Phase 0 é pequeno porque throughput esperado
			  é baixo + objetivo é correctness/governance + promotion
			  futura pode elevar via calibration.
			- Empirical reference (PG agent-governance): cmt 5/80, ctr
			  3/50, npm 3/50; BKR 1/40 abaixo do range mais conservador
			  por (a) sem track record operacional; (b) cryptographic
			  boundary + 9 invariants + side-channel mitigation = surface
			  de risco maior; (c) lifecycleStage=onboarding requires
			  aggressive supervision.

			maxDailyActions=40:
			- Inclui todas categories (mutations + validations + queries
			  + escalations + observation). Estimativa pre-PMF: 2-3
			  attempts/day × ~16 actions per attempt processed = ~30-50
			  actions/day. Cap=40 acomoda baseline operational + margem;
			  volume acima dispara escalation.
			- Validation/query/escalation actions count toward the cap,
			  but mutation actions are separately constrained by
			  maxConcurrentMutations and supervised-gate throughput.
			  Concurrency cap = safety boundary; daily cap = operational
			  envelope. Separação semântica explícita evita: consumir
			  budget com queries/observability; bloquear mutations
			  críticas artificialmente; induzir tuning errado depois.

			tq-gv-09 (warn): caps Phase 0 são forward-ref ao global
			blastRadiusPolicy (architecture/agent-governance.cue ainda
			não materializado em Phase 0; warn aceitável per CMT
			convention). Quando global existir, runner valida 1 ≤
			global.maxConcurrentMutations + 40 ≤ global.maxDailyActions.

			Anti-economic-autonomy check: caps aplicam-se a TODAS actions
			independente de category; mesmo se invariant violation
			somehow bypassed, volume cap prevents economic damage scale.
			Caps são teto operacional, não controle econômico — protecção
			contra abuse vector mas não substitui inv-anti-decision-
			boundary (que enforça boundary even sob cap allowed).
			"""
	}

	// ============================================================
	// DRIFT DETECTION (7 metrics, daily cadence, mix det/stat)
	// ============================================================

	driftDetection: {
		evaluationCadence: "daily"
		metrics: [{
			code:        "dm-double-settlement-rate"
			name:        "Double Settlement Detection Rate"
			description: "Detection rate of multiple settlement confirmations for same attemptId across separate paths. Deterministic metric — any occurrence is operational catastrophe per vm-bkr-01 target 0%. Triggered via sig-double-settlement-suspicion (level=critical) emitted by svc-reconciliation detection algorithm."
			baseline:    "0 events per day across all operations"
			threshold:   "> 0 events in any 24h window — ANY occurrence triggers immediate forensic + halt"
			rationale:   "Per inv-idempotency-enforcement-per-attempt + vm-bkr-01: double settlement é vector adversarial #1 e falha operacional catastrófica. Deterministic threshold (any > 0) porque mesmo single occurrence indica system state inconsistency requiring imediato action."
		}, {
			code:        "dm-indeterminate-reconciliation-duration"
			name:        "Indeterminate Reconciliation Duration"
			description: "Duration distribution of attempts persisting in state=indeterminate vs rail operational window. Deterministic threshold per rail (Pix: timeout defined; STR: data útil cutoff; SILOC: D+0/D+1 batch close; SWIFT: correspondent SLA window). Triggered via sig-indeterminate-state-entered + window arithmetic."
			baseline:    "all indeterminate states resolve within rail-specific operational window"
			threshold:   "any attempt exceeds rail-specific operational window without explicit cmd-resolve-indeterminate-state"
			rationale:   "Per vm-bkr-02 + inv-indeterminate-state-non-collapse: persistence beyond window indicates resolution evidence missing + escalation per rail-specific timeout policy required. Window arithmetic é deterministic — não há ambiguidade temporal."
		}, {
			code:        "dm-unauthorized-dispatch-rejection-rate"
			name:        "Unauthorized Dispatch Rejection Rate"
			description: "Rate of cmd-dispatch-payment-instruction rejections devido authorization-proof-invalid classification em pre-dispatch boundary check. Spike pattern indicates either upstream key rotation issue, forgery attempt, or expired proof submission. Triggered via sig-constraint-violation associated with cst-authorization-proof-verification."
			baseline:    "< 1% rejection rate em normal operation (occasional expired proofs from upstream timing)"
			threshold:   "> 5% rejection rate sustained over 24h window OR > 1% daily for 3 consecutive days"
			rationale:   "Per vm-bkr-03 + inv-authorization-proof-verification-gate: rejection rate baseline reflete operational reality (occasional upstream proof staleness); spike sustained indicates structural issue. 5% single-day threshold é hard limit; 1% over 3-day window catches gradual drift patterns."
		}, {
			code:        "dm-reconciliation-consistency-rate"
			name:        "Reconciliation Consistency Rate"
			description: "Statistical rate of reconciliation outcomes determined deterministically (no manual intervention required) vs total reconciliation attempts. Rolling 7-day window. Drift indicator — rate < 99.9% signals systematic reconciliation logic divergence OR rail behavior change OR adversarial pattern."
			baseline:    "≥ 99.9% deterministic reconciliation across rolling 7-day window"
			threshold:   "rolling 7d < 99.9%, with any single-day breach requiring documented causal review"
			rationale:   "Per vm-bkr-05 + svc-reconciliation determinism requirement. Statistical metric porque normal operation tem variance (rail latency, signal arrival ordering); deterministic threshold a 99.9% acomoda variance enquanto detecta systematic divergence. Confidence threshold + window per Phase 4.4 founder direction — drift estatístico needs window to avoid spurious blocking."
		}, {
			code:        "dm-side-channel-leakage-count"
			name:        "Side-Channel Leakage Detection Count"
			description: "Count of detected side-channel leak events — classification routing payload containing compliance-sensitive detail (regulatory subtype, sanctions list inference, AML trigger specifics) reaching non-authorized consumer. Deterministic — any occurrence is structural policy gap requiring revert."
			baseline:    "0 events"
			threshold:   "> 0 events in any time window — zero tolerance"
			rationale:   "Per vm-bkr-06 + side-channel mitigation Phase 1.2 cap 6: leak é amplification risk informing attacker sobre sanctions/AML target state. Deterministic threshold porque any occurrence indica side-channel filter (em prj-failure-classification projection layer) falhou + policy review necessária."
		}, {
			code:        "dm-provider-anomaly-escalation-rate"
			name:        "Provider Anomaly Escalation Rate"
			description: "Statistical rate of escalations triggered by partner/PSTI behavior anomalies — rail status divergence patterns, provider availability drift, response time degradation patterns. Observability-only metric (per vm-bkr-07 — meta-aggregator); tracks provider operational health indirectly via BKR-side escalation signal."
			baseline:    "TBD per provider — initial baseline established post first 30 days operational data collection"
			threshold:   "spike > 2σ from rolling 7d baseline (statistical anomaly) OR > 10 events in 24h (volume anomaly)"
			rationale:   "Per vm-bkr-07: observability metric tracking provider behavior indirectly via BKR signals (sig-rail-status-divergence + sig-escalation-triggered escalation patterns). 2σ statistical threshold acomoda normal provider variance enquanto detecta material drift; absolute volume threshold backstop para sudden patterns."
		}, {
			code:        "dm-supervision-request-rate"
			name:        "Supervision Request Rate"
			description: "Process health metric — rate of sig-supervision-requested signals emitted vs propose-and-wait action invocations. Indicates whether supervised gate Phase 0 protocol is operating per design (all propose-and-wait actions producing signal before execution)."
			baseline:    "all propose-and-wait actions should produce sig-supervision-requested before execution; validations/queries should not"
			threshold:   "rate < 100% for propose-and-wait actions (bypass concern — supervision gate not being invoked) OR rate > 0% for execute-and-log actions (supervision protocol leaking into non-applicable categories)"
			rationale:   "Process integrity metric Phase 0 — distinct from settlement outcome metrics. 100% rate para propose-and-wait actions garante supervised onboarding protocol é operating per design; non-zero rate em execute-and-log actions indicaria misclassification ou spec drift. Per founder direction Phase 5.4 ajuste 1: evita misturar 'mutation' com 'supervision' baseline."
		}]
		rationale: """
			Cadência daily Phase 0 — high-criticality BC + small operational
			scale = drift signals devem ser detectados rapidamente. 7 métricas
			alinham com canvas Phase 1.6 vm-bkr-* verificationMetrics (6
			diretas: vm-bkr-01..07 mapeadas + 1 process health metric — supervision-
			request-rate — para Phase 0 supervised onboarding protocol integrity).
			Mix deterministic (4 metrics: double-settlement, indeterminate-duration,
			side-channel-leakage, supervision-rate) + statistical (3 metrics:
			unauthorized-dispatch-rate, reconciliation-consistency, provider-
			anomaly) per Phase 4.4 founder direction (drift estatístico needs
			confidence threshold + window; deterministic needs hard zero-tolerance
			boundary).

			Anti-economic-autonomy check: nenhuma drift metric é economic
			outcome metric (volume processed, revenue generated, cost
			efficiency). Todas medem boundary integrity OR operational
			correctness OR adversarial detection patterns. Drift metric set
			NÃO introduce economic feedback loop.
			"""
	}

	// ============================================================
	// CALIBRATION (4 promotionCriteria + 5 regressionTriggers)
	// ============================================================

	calibration: {
		promotionCriteria: [{
			description:              "Operational track record demonstrating successful settlement execution across full outcome distribution (não apenas happy path) without boundary violations. Required threshold para validar competence técnica em volume operacional realista pre-PMF."
			metric:                   "≥ 50 SettlementAttempts, including finalized, failed, rejected and indeterminate paths, with at least 5 non-happy-path cases reviewed (failed/rejected/indeterminate). 0 invocations triggering inv-anti-decision-boundary enforcement during the observation period (measured via sig-mutation-executed for state transitions + sig-constraint-violation for boundary check failures)."
			minimumObservationPeriod: "60 days"
			rationale:                "Volume threshold alinhado com PG empirical (cmt 20/80; ctr 30/100; npm 10/40); BKR threshold mais alto (50) por high-criticality + sem track record + 9 invariants protegidos. Non-happy-path inclusion (per Phase 5.5 ajuste 1 founder) garante que promotion não incentiva apenas casos fáceis — agent precisa provar robustez em bordas (rejection paths via T2; failed paths via T5/T8; indeterminate paths via T6 + resolution). Period mínimo 60 days porque operational patterns emergem em multiple weekly cycles + rail edge cases precisam observation across diferentes operational windows."
		}, {
			description:              "Reconciliation determinism sustained across rolling measurement windows. Demonstrates svc-reconciliation produces canonical outcomes deterministicamente without progressive degradation. Allow controlled exceptions via documented causal review."
			metric:                   "dm-reconciliation-consistency-rate rolling 7d ≥ 99.9%, with any single-day breach requiring documented causal review (acceptable causes: external rail outage, partner/PSTI maintenance, Bacen incident — all externally attributable AND time-bounded)"
			minimumObservationPeriod: "60 days"
			rationale:                "Per vm-bkr-05 + inv-settlement-finality-post-reconciliation-only: BKR canonicalization depends on Reconciliation determinism. Per Phase 5.5 ajuste 2 founder: single-day breach com documented causal review é acceptable — um único dia ruim não precisa resetar tudo se houver causa externa comprovada. Rolling 7d enforcement captures sustained degradation; documented review captures legitimate transient exceptions vs structural drift."
		}, {
			description:              "Boundary integrity zero-violation track record. Demonstrates agent operates within technical boundary per all 9 invariants without observed adversarial breakthrough OR catastrophic operational failures."
			metric:                   "0 sig-constraint-violation events (any cst-* triggered) AND 0 sig-double-settlement-suspicion events (level=critical) during observation period"
			minimumObservationPeriod: "60 days"
			rationale:                "Zero-tolerance metric Phase 0 → validation promotion porque: (a) sig-constraint-violation indicates inv-* enforcement fired = boundary integrity broken; (b) sig-double-settlement-suspicion é vector adversarial #1 + vm-bkr-01 target 0%; any occurrence resets observation period. Promotion sem zero-baseline seria over-promise on boundary preservation."
		}, {
			description:              "Audit trail completeness regulatory-grade. Verifies que all 13 audit fields populated per action invocation + reconstrução forensic é possible from audit data alone."
			metric:                   "100% audit trail completeness verified via prj-audit-trail spot-checks (random 20% sample of audit entries) confirms all 13 fields populated + reconstruction possible without external data"
			minimumObservationPeriod: "30 days"
			rationale:                "Per inv-anti-decision-boundary + auditTrail._minimumAuditFields + 6 BKR-specific fields: audit trail é o mecanismo de prova retroativa que agente nunca exerceu decisão econômica. Spot-check 20% sampling balanceia verification rigor com operational overhead. 30-day window suffices porque audit completeness é structural property; quaisquer gap aparece imediatamente."
		}]

		regressionTriggers: [{
			description:     "Critical double settlement detection — any occurrence é catastrophic operational failure per vm-bkr-01 + inv-idempotency-enforcement-per-attempt; ANY event triggers immediate suspend + forensic."
			metric:          "dm-double-settlement-rate detected occurrence"
			threshold:       "> 0 events in any time window — zero tolerance"
			immediateAction: "suspend-and-escalate"
			rationale:       "Vector adversarial #1 per canvas + vm-bkr-01 target 0%. Suspend-and-escalate é única response apropriada — reduce-autonomy seria insuficiente pois indicates system state inconsistency that requires forensic investigation across all attempts under affected instructionId family. clearanceCondition rigorous (30d no-signal global maxOccurrences=0) garante prolonged forensic + corrective action antes de re-promotion."
			scopedBySignal:  "sig-double-settlement-suspicion"
			clearanceCondition: {
				type:           "no-signal-in-window"
				signalRef:      "sig-double-settlement-suspicion"
				window:         "30d"
				scope:          "global"
				maxOccurrences: 0
			}
		}, {
			description:     "Side-channel leakage detection — classification routing leak of compliance-sensitive detail to non-authorized consumer. Triggers revert-to-previous-stage porque indicates side-channel mitigation failure structural — não é fixable per attempt; envelope policy + projection layer need review."
			metric:          "dm-side-channel-leakage-count detected occurrence via ec-classification-side-channel-leak-detected OR ec-bkr-info-leak-meta-detection"
			threshold:       "> 0 events in any time window — zero tolerance"
			immediateAction: "revert-to-previous-stage"
			rationale:       "Per side-channel mitigation Phase 1.2 cap 6 + cst-classification-no-auto-remediation: side-channel leak é amplification risk — informa attacker sobre sanctions/AML target state. Stronger than suspend (suspend é temporary halt; revert downgrades lifecycle stage) porque indicates structural policy gap not transient operational issue. In onboarding, revert-to-previous-stage materializes as suspend-and-escalate plus promotion freeze until correction is reviewed (per Phase 5.5 ajuste 4 founder direction). 14-day clearance window (more aggressive than double-settlement 30d) reflects que side-channel patterns evolve faster than rail behavior."
			scopedBySignal:  "sig-escalation-triggered"
			clearanceCondition: {
				type:           "no-signal-in-window"
				signalRef:      "sig-escalation-triggered"
				window:         "14d"
				scope:          "global"
				maxOccurrences: 0
			}
		}, {
			description:     "Constraint violation pattern — sig-constraint-violation events detected within 24h window. Indicates inv-* enforcement firing pattern that exceeds baseline (which is 0 occurrences). Trigger reduce-autonomy to halt mutations + escalate for boundary review."
			metric:          "sig-constraint-violation event count in 24h rolling window"
			threshold:       "> 0 events in 24h window (zero-tolerance baseline)"
			immediateAction: "reduce-autonomy"
			rationale:       "Per 9 cst-* + inv-* coverage: constraint violation indicates real-time boundary breach attempt. reduce-autonomy halts mutation autonomy enquanto retém validation/query autonomy para investigation. clearanceCondition 7d inherit-from-trigger scope means clearance only when no further sig-constraint-violation within 7-day window applied to the specific actor/constraint context that fired (not global)."
			scopedBySignal:  "sig-constraint-violation"
			clearanceCondition: {
				type:           "no-signal-in-window"
				signalRef:      "sig-constraint-violation"
				window:         "7d"
				scope:          "inherit-from-trigger"
				maxOccurrences: 0
			}
		}, {
			description:     "Indeterminate state cluster — pattern of multiple indeterminate state instances exceeding rail operational window within 7d. Indicates either systematic reconciliation issue OR rail behavior change OR upstream policy gap (retry pre-authorization missing for cases where it should exist). Trigger reduce-autonomy + operational review."
			metric:          "dm-indeterminate-reconciliation-duration breach count in rolling 7d window"
			threshold:       "> 3 instances exceeding rail operational window within 7d"
			immediateAction: "reduce-autonomy"
			rationale:       "Operational degradation pattern (not adversarial signature) — high indeterminate persistence rate indicates reconciliation pipeline pressure OR systemic rail behavior change. reduce-autonomy halt mutations enquanto operations team investigates root cause. Sem clearanceCondition declarada porque trigger resolves via metric improvement (3+ breaches → < 3 breaches in 7d via investigation + remediation) — pattern recovery is observable directly em dm-indeterminate-reconciliation-duration, não em signal absence."
			scopedBySignal:  "sig-indeterminate-state-entered"
		}, {
			description:     "Reconciliation consistency degradation — rolling 7d rate of deterministic reconciliation drops below 99.9% threshold sustained OR single-day catastrophic breach. Triggers reduce-autonomy to halt mutations enquanto reconciliation logic review proceeds."
			metric:          "dm-reconciliation-consistency-rate sustained breach"
			threshold:       "rolling 7d < 99.9% sustained over 3+ consecutive days OR any single-day < 95%"
			immediateAction: "reduce-autonomy"
			rationale:       "Per vm-bkr-05: reconciliation determinism is structural BKR property; degradation indicates either logic bug OR rail behavior drift OR adversarial pattern affecting Reconciliation 4-conditions evaluation. reduce-autonomy halts mutation autonomy enquanto svc-reconciliation behavior + recent rail signals reviewed. Sem clearanceCondition porque pattern recovery is observable directly em dm-reconciliation-consistency-rate — metric returns to ≥ 99.9% sustained = effective clearance."
			scopedBySignal:  "sig-validation-result"
		}]

		rationale: """
			Phase 0 onboarding → validation promotion + Phase 0 regression
			triggers. Promotion path is monotonic in onboarding (cannot
			regress to pre-onboarding); regression actions are graduated
			(reduce-autonomy < revert-to-previous-stage < suspend-and-
			escalate) per criticality of trigger.

			Promotion empirical alignment: BKR threshold (50 attempts ×
			60 days × zero boundary violations + non-happy-path inclusion)
			mais conservador que cmt 20/80, ctr 30/100, npm 10/40 —
			justifies por high-criticality + 9 invariants + cryptographic
			boundary. Non-happy-path inclusion previne incentivo de
			cherry-picking happy cases.

			Single-day reconciliation breach allows documented causal
			review (per Phase 5.5 ajuste 2 founder) — externally
			attributable + time-bounded causes (rail outage, Bacen
			incident) shouldn't reset 60-day clock; structural drift
			(sustained breach) does.

			Regression triggers cover 5 distinct deterioration patterns:
			catastrophic (double settlement → suspend-and-escalate +
			30d global clearance) + structural policy gap (side-channel
			leak → revert-to-previous-stage [in onboarding materializes
			as suspend-and-escalate + promotion freeze per Phase 5.5
			ajuste 4 founder] + 14d global clearance) + boundary breach
			pattern (constraint violation cluster → reduce-autonomy +
			7d inherit-scope clearance) + operational degradation
			(indeterminate cluster → reduce-autonomy + metric-recovery
			clearance) + consistency drift (reconciliation rate decay
			→ reduce-autonomy + metric-recovery clearance).

			clearanceCondition per adr-075 implementa sustained
			containment — agent cannot re-promote prematuramente após
			regression sem demonstrating no-signal-in-window proof.
			Scope hierarchy: global (rt-1 double settlement + rt-2 side-
			channel — system-wide concern) > inherit-from-trigger (rt-3
			constraint violation — actor-localized).

			scopedBySignal links 5 regression triggers ao agent-spec
			observability contract (signal-as-contract per adr-075).
			Trigger runtime evaluation derives state from audit log
			(single source of truth); envelope declares contracts only.

			Anti-economic-autonomy guarantee: promotion criteria são
			measurable + technical; nenhum promotion criterion é
			economic metric (e.g., volume processed = OK; revenue
			generated = NEVER). Regression triggers preserve human gate
			em todas conditions onde autonomy could be promoted via
			informal patterns.
			"""
	}

	// ============================================================
	// FAILURE HANDLING (per adr-058)
	// ============================================================

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "When agent encounters internal error during action execution (exception, deadlock, unexpected state), suspend agent operations + escalate to founder via alert-and-block channel. Action é conservadora Phase 0 — agent error indicates system state may be inconsistent; resumption requires explicit human authorization após investigation. No automatic resumption."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "No automatic retry Phase 0. Retry decision requires explicit human authorization após root-cause investigation. Phase 1+ may introduce policy-driven retry under calibration if pattern emerges (e.g., transient infrastructure timeouts vs systemic issues)."
			description: "When agent action exceeds expected execution duration (per-action timeout thresholds defined operational; not in spec/envelope), suspend + escalate. Timeout typically indicates external dependency failure (rail unresponsive, partner/PSTI unavailable, internal state lock) OR adversarial slow-path attack. Phase 0 conservatism: no automatic recovery."
		}
		onRepeatedFailure: {
			action:      "revert-to-previous-stage"
			threshold:   "3 failures of any single action within 1 hour OR 10 failures across all actions within 24 hours"
			timeWindow:  "1 hour (single action) / 24 hours (cross-action)"
			description: "Repeated failure pattern indicates either systematic issue (action implementation bug, persistent external failure, calibration gap) OR adversarial probe sequence. Revert-to-previous-stage (currently onboarding → no further regression possible Phase 0) materializes as effective full suspend + escalation + promotion freeze. Phase 1+ progression: validation → onboarding."
		}
		rationale: """
			Conservative Phase 0 failure handling — all paths suspend OR
			revert; nenhum automatic recovery action que could mask
			systemic issue OR enable adversarial pattern continuation.

			adr-058 promotion: failureHandling declared como schema first-
			class field per #FailureHandling struct (não mais heuristic
			tech debt narrative). 3 distinct failure classes mapped:
			agent error (internal) + timeout (external dependency or slow
			attack) + repeated failure (systematic or adversarial).

			Threshold calibration onRepeatedFailure: 3/1h reflects que
			repeated single-action failure indicates focused operational
			issue; 10/24h cross-action reflects que pervasive failures
			across multiple actions indicates broader systemic concern OR
			coordinated probe. Both thresholds intentionally
			conservative — Phase 0 prefers false-positive suspensions
			(operationally annoying mas safe) over false-negative
			non-detection (catastrophic risk acceptance).

			Phase 1+ promotion may relax thresholds OR introduce retry
			policies under calibration (e.g., transient network
			failures justify policy-driven retry; systemic failures
			always require human authorization).
			"""
	}

	// ============================================================
	// OUTER RATIONALE (com anti-economic-autonomy dedicated section)
	// ============================================================

	rationale: """
		Governance envelope BKR primary agent Phase 5 WI-062 BKR
		bootstrap. Última phase do bootstrap — materializa supervisory
		layer per-agent sobre fundação canvas (Phase 1) + glossary
		(Phase 2) + domain-model (Phase 3) + agent-spec (Phase 4).

		Composição:
		- Identity (agentRef=agt-bkr-primary) + lifecycle (onboarding)
		  + bidirectional ref + governanceGlobalVersion='0.1' forward-
		  ref Phase 0 per CMT convention
		- 5 escalation routes cobrindo 5 categories from agent-spec;
		  3 com queue governance bounded + auto-cancel-and-escalate
		  overflow policy per adr-075 (suspicious-input/conflicting-
		  signals/out-of-scope com queue + 2 sem queue: insufficient-
		  context async + ambiguous-case sync-review)
		- blastRadiusCaps Phase 0 (1 concurrent mutation + 40 daily
		  total actions) — concurrency cap = safety boundary; daily
		  cap = operational envelope
		- autonomyOverrides OMITIDO inteiramente — supervised
		  onboarding + explicitness over convenience + impede
		  promotion informal
		- driftDetection 7 metrics (6 mapeando canvas vm-bkr-01..07 +
		  1 process health — supervision-request-rate) com cadence
		  daily; mix deterministic + statistical
		- calibration 4 promotionCriteria (50 attempts inc non-happy
		  paths × 60 days × 0 boundary violations × 100% audit
		  completeness) + 5 regressionTriggers com clearanceCondition
		  no-signal-in-window per adr-075; 5 scopedBySignal refs ao
		  agent-spec observability
		- failureHandling per adr-058: onAgentError + onTimeout +
		  onRepeatedFailure todos conservative (suspend OR revert; no
		  automatic recovery Phase 0)

		===========================================================
		ANTI-ECONOMIC-AUTONOMY PROOF (founder canonical gate)
		===========================================================

		Founder Phase 4/5 central direction: 'agente BKR pode executar
		decisões técnicas determinísticas, mas nunca pode transformar
		isso em decisão econômica.' Phase 5 envelope materializa este
		gate via 7 layers de defense:

		LAYER 1 — Lifecycle stage onboarding: per global taxonomy
		forward-ref, onboarding allows no-autonomous-action +
		collect-and-report + propose-and-wait apenas; execute-and-
		log é categoricamente bloqueado para qualquer action via
		spec/envelope path em Phase 0.

		LAYER 2 — Blast radius caps tight: maxConcurrentMutations=1
		serializes mutation execution (elimina race + interleaving
		ambiguity class); maxDailyActions=40 cap volumétrico previne
		sustained adversarial pattern even sob hypothetical bypass.
		Concurrency cap = safety boundary; daily cap = operational
		envelope (separação semântica explícita para evitar tuning
		errado).

		LAYER 3 — AutonomyOverrides omitido inteiramente: nenhum
		override path para Phase 0; spec autonomyLevel é authoritative
		sem exceção. Schema tq-gv-14 enforça que mesmo se override
		field tentasse conceder execute-and-log a mutation, rejeição
		estrutural (P10 hardcoded).

		LAYER 4 — Escalation routing exhaustive: 5 categories × human
		review channels (sync OR async OR alert-and-block); zero
		auto-approve paths em qualquer categoria. Overflow policies
		fail-safe (auto-cancel-and-escalate, never auto-approve
		under queue pressure).

		LAYER 5 — Calibration promotionCriteria technical only:
		50 attempts (including non-happy paths) + 60 days + 0
		boundary violations + 99.9% consistency rolling + 100%
		audit completeness. Nenhum promotion criterion é economic
		metric (volume processed = OK; revenue/cost/timing efficiency
		= NEVER). Promotion requires sustained technical track
		record, não outcome favorável.

		LAYER 6 — Regression triggers preserve human gate:
		clearanceCondition no-signal-in-window per adr-075 garante
		que após regression, re-promotion requires sustained no-
		signal proof; nenhum self-clearance automático.

		LAYER 7 — Audit trail proof retroativo: 13 fields (incluindo
		authorization-proof-reference hash, lifecycle-transition,
		failure-classification-tuple) documentam que cada decisão é
		technical + traceable. Audit completeness é regulatory-grade
		+ verifiable.

		EXPLICIT CANONICAL CLAUSE (founder Phase 5.3 direction):
		No governance mechanism may increase autonomy beyond the
		action-level autonomy declared in the agent-spec without an
		explicit calibration-mediated promotion event recorded in
		audit trail. This forecloses 4 specific drift vectors:
		(a) override escalation (autonomyOverrides bypassing spec);
		(b) governance drift (envelope changes silently increasing
		autonomy); (c) 'temporary exception becoming permanent' via
		expired-but-not-removed overrides; (d) informal promotion
		via repeated successful operations without calibration
		event.

		Per adr-058 governance versioning + calibration audit:
		every autonomy change MUST produce calibration event in
		audit trail with (promotion criterion satisfied + reviewer
		identity + governance-version at time of promotion +
		action-level autonomy before/after). No exceptions Phase 0.

		===========================================================

		5 lenses ativadas:
		- lens-ai-agent-governance (primária): supervisory layer
		  autonomy + lifecycle stage + escalation routing +
		  calibration matrix per-agent
		- lens-security-trust-infrastructure (primária): blast radius
		  caps tight Phase 0 + queue governance bounded + side-channel
		  leak regression trigger
		- lens-regulatory-compliance-as-architecture (secundária):
		  audit trail completeness as promotion criterion +
		  regulatory-grade 13 fields + retention policy forward-ref
		- lens-observability-operational-intelligence (terciária):
		  7 drift metrics + scopedBySignal contract per adr-075 +
		  signal-as-contract for trigger runtime evaluation
		- lens-mechanism-design (indireta via agent-spec): 5
		  regression triggers preserve human gate; clearance windows
		  sustained per adversarial pattern (30d/14d/7d graduated)

		Forward-looking acknowledged:
		- Global agent-governance.cue ainda não materializado Phase 0;
		  governanceGlobalVersion='0.1' forward-ref per CMT convention;
		  blastRadiusPolicy global + lifecycleStages enum + escalation
		  defaults vivem em separate singleton when materialized
		- tq-gv-09/12 warn-equivalent Phase 0 (forward-ref); turn fail
		  pós-global creation
		- Phase 1+ promotion paths (onboarding → validation →
		  operational → mature) trigger via calibration.promotionCriteria
		  sustained satisfaction
		- Phase 1+ may introduce autonomyOverrides para actions
		  específicas após calibration-mediated promotion event;
		  sempre logged in audit trail per anti-economic-autonomy
		  clause

		WI-062 BKR bootstrap completo após Phase 5 (canvas + glossary
		+ domain-model + agent-spec + governance envelope). Próximo:
		retornar a FCE bootstrap (WI-043) — original target antes da
		BKR cascade dependency identificada.
		"""
}
