package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// rew-domain-model.cue — Structural checks para REW domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem +
// semantic enforcement.
//
// Phase 3.5 do WI-046 REW bootstrap (Part 2.1 — war game hardening
// boundary commit). Materializa primeiro batch de 5 invariants
// derivados da War Game Round 2 (founder pressure test) como
// structural-checks executáveis.
//
// Boundary commit principle (founder ratified): invariants
// declarativos em domain-model deixam de ser DESIGN e passam a
// ser CONTRATO EXECUTÁVEL via structural-check rules.
//
// Coverage diferenciada por natureza do invariant (founder ajuste —
// 'NÃO escreva todos no mesmo estilo de check'):
// - sc-rew-01 (acl-validation-cost-bounded): RUNTIME GUARD
//   — coverage runtime-only; build-time enforces field presence
// - sc-rew-02 (obsolete-evaluation-must-link-successor): SEMANTIC
//   CONSISTENCY — validation-time enforces emit handler logic
// - sc-rew-03 (successor-chain-bounded): CONSUMER CONTRACT
//   — runtime enforced consumer-side; REW declara contract
// - sc-rew-04 (replay-confidence-propagation): METADATA
//   INTEGRITY — runtime + downstream lineage tracking
// - sc-rew-05 (decision-binding-to-evaluation-version): CROSS-BC
//   CONTRACT — consumer-side TOCTOU defense
//
// inv-rew-undetectable-pattern-risk-declared NÃO tem structural-
// check correspondente (founder ratified): é HONESTY INVARIANT
// puramente declarativo — força VISIBILIDADE em systemFailureModes,
// NÃO COMPORTAMENTO. Não bloqueia, não valida, não interfere.
//
// Restantes 39 invariants Part 1+2 são deferred a expansão de
// structural-checks Part 2.2+ commits — incremental coverage com
// evidência empírica de necessidade.
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pattern: forbidden é proibição de ESTADO ou
// PROPRIEDADE, não de ação procedural).

structuralChecks: "sc-rew-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-rew-01"
	title:        "ACL validation cost bounded (per-signal AND per-window)"
	artifactType: "domain-model"
	description:  "ACL validation enforces 2 cost budgets distintos: (a) per-signal cost ≤ aclValidationCostBudgetPerSignalMs (default 50ms); single signal exceeding rejeita com 'cost-exceeded'. (b) cumulative cost per second ≤ aclValidationCostBudgetPerSecondMs (default 50000ms = 50 cores @ 1s wall); window exhausted → ACL throttle + backpressure upstream. Ataque distribuído (signals individualmente baratos mas caros em agregação) precisa AMBOS budgets para ser detectado — per-signal só protege spike attack."
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-rew-acl-validation-cost-bounded"
		assertion: """
			∀ signal ∈ ACL ingress queue:
			  validationCost(signal) ≤ aclValidationCostBudgetPerSignalMs
			∧ ∀ window of 1 second:
			    Σ(validationCost(signals in window))
			      ≤ aclValidationCostBudgetPerSecondMs
			∧ exceeded(per-signal) ⇒ emit evt-signal-rejected
			    with validationCheckFailed='cost-exceeded'
			∧ exceeded(per-window) ⇒ ACL throttle + backpressure upstream
			    (NÃO drop silent; NÃO deplete maxEmissionRatePerSecond
			     domain budget)
			"""
		coverage: {
			buildTime:       true   // schema-time: aclValidationCostBudget* fields presentes em RiskPolicy
			validationTime:  false
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cost budget enforcement requires runtime measurement de validation cost per signal + cumulative per window. Build-time valida apenas presença dos fields em RiskPolicy. Runtime gate measures (timer ao redor de validation pipeline; window aggregator para cumulative). Sem runtime measurement: ataque distribuído passa invisível (founder War Game 2 insight: 'protege output mas não protege processamento')."
			enforcedBy:  "ACL validation pipeline runtime instrumentation (per-signal timer + per-second cumulative aggregator) + backpressure mechanism (signal queue throttled at ingress when window budget exhausted; upstream BC receives backpressure indication)"
		}
		forbidden: [
			"per-signal validation OR per-window cumulative cost without enforced ceiling (silent saturation)",
			"rejection events draining maxEmissionRatePerSecond domain budget (rejection budget separated via aclIngressRatePerSecond)",
			"silent drop of signals exceeding cost budget (NEVER drop — emit rejection OR backpressure with audit trail)",
		]
	}
	errorMessage: "domain-invariant inv-rew-acl-validation-cost-bounded: violação detectada — ACL validation cost budget exceeded sem enforcement runtime. Verifique aclValidationCostBudgetPerSignalMs + aclValidationCostBudgetPerSecondMs em RiskPolicy active + runtime instrumentation per signal + per window."
	rationale:    "Founder War Game Round 2 Quebra 1: distributed cheap-but-many cost attack. Modelo Phase 3 protegia OUTPUT (maxEmissionRatePerSecond) mas não PROCESSAMENTO. 2 budgets distintos (per-signal anti-spike + per-window anti-distributed) são ambos necessários — per-signal só ≠ proteção completa. Runtime gap explícito porque cost measurement é runtime concern; build-time valida presença dos field guards."
}

structuralChecks: "sc-rew-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-rew-02"
	title:        "Late emit blocked by newer evaluation MUST link successor"
	artifactType: "domain-model"
	description:  "Quando emit handler detecta newer evaluation E_other para mesmo scope com emittedAt > THIS.computedAt, THIS DEVE emitir evt-risk-evaluation-emit-superseded-by-newer (NÃO evt-risk-evaluation-emit-failed). Distinção semântica: failure = sistema não conseguiu computar; obsolescence = sistema computou mas newer reality já existe. Successor reference (successorEvaluationId) permite consumer ADOPT em vez de RETRY → previne consumer retry loop."
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-rew-obsolete-evaluation-must-link-successor"
		assertion: """
			∀ evaluation E in compute phase:
			  emit_handler(E) detects ∃ E_other where:
			    E_other.scope == E.scope
			    ∧ E_other.status ∈ {emitted, stale}
			    ∧ E_other.emittedAt > E.computedAt
			  ⇒ emit evt-risk-evaluation-emit-superseded-by-newer with:
			      evaluationId = E.evaluationId
			      successorEvaluationId = E_other.evaluationId
			      supersededAt = now()
			∧ ¬emit evt-risk-evaluation-emit-failed for this case
			    (failure event reservado para genuine compute/emit failures)
			∧ THIS NÃO entra em lifecycle (igual a emit-failed —
			    obsolete fact preservado em event log mas evaluation NÃO
			    válida no domínio)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true   // event log analysis pode validar pareamento computed→superseded-by-newer
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Detection de newer evaluation no scope é runtime query no aggregate state. Build-time não vê event log; validation-time pode auditar event log post-hoc verificando que cada computed event seguiu por (emitted | emit-failed | emit-superseded-by-newer) — nenhum orphan computed permitido."
			enforcedBy:  "agg-risk-evaluation aggregate emit handler logic (CAS check on supersededBy/active rule) + event log auditor (validation-time advisory verificando absence of orphan computed)"
		}
		forbidden: [
			"orphan computed event (computed sem followup emit OR fail OR superseded-by-newer)",
			"emit-failed emitido para caso obsolescence (semantic confusion failure vs obsolescence)",
			"successorEvaluationId reference apontando para evaluation NÃO emitted (broken link)",
		]
	}
	errorMessage: "domain-invariant inv-rew-obsolete-evaluation-must-link-successor: emit-failed emitido para caso de obsolescence — esperava-se emit-superseded-by-newer com successorEvaluationId. Distinção FAILURE ≠ OBSOLESCENCE crítica para evitar consumer retry loop."
	rationale:    "Founder War Game Round 2 Quebra 2: false negative semântico. Modelo Phase 3 + production-safety assumiu emit-failed para qualquer pre-emit blocking; war game expôs que CONCURRENT NEWER evaluation é obsolescence (recoverable), não failure (genuine). Distinção semântica em event level previne consumer retry loop indefinido. Coverage validation-time porque event log auditor pode catch violations post-hoc."
}

structuralChecks: "sc-rew-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-rew-03"
	title:        "Successor chain bounded (consumer max-hops; default N=3)"
	artifactType: "domain-model"
	description:  "Consumer seguindo successorEvaluationId chain (E1→E2→E3→...) NÃO pode seguir além de N hops (default 3; configurable per consumer policy). Após N hops sem chegar a evaluation 'fresh-and-valid', consumer DEVE: (a) emitir cmd-request-risk-evaluation novo OR (b) escalate via ADR override OR (c) abort decisão. Sem bound: consumer-side livelock em high-throughput scenarios."
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-rew-successor-chain-bounded"
		assertion: """
			∀ consumer following successor chain starting from evaluation E_0:
			  ∃ N (consumer-policy-defined; default 3) such that
			    consumer MUST NOT follow chain beyond N hops
			∧ chain_length(E_0 → E_1 → ... → E_n) > N
			    ⇒ consumer abort chain following
			    ∧ consumer DEVE emit cmd-request-risk-evaluation NEW
			      OR escalate via ADR override
			      OR abort downstream decision
			∧ chain bound is CONSUMER-SIDE responsibility
			    (REW emits chain naturally; bound enforcement
			     reside em consumerProtocol)
			"""
		coverage: {
			buildTime:       false
			validationTime:  false
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Consumer-side runtime concern: REW emite successor chain naturalmente quando concurrent evaluations cascateiam. Bound enforcement é responsabilidade do consumer code (CMT/FCE/SCF SDK OR application logic). REW NÃO pode forçar consumer behavior runtime — apenas DECLARAR contract via consumerProtocol entry. Compliance via post-hoc audit (consumer behavior logs revisados periodicamente)."
			enforcedBy:  "consumer SDK code (chain following with hop counter) + consumerProtocol entry MANDATORY + audit periódica de consumer behavior pos-hoc + ADR override required quando consumer atinge bound recurrentemente"
		}
		forbidden: [
			"consumer following successor chain unbounded (livelock vector)",
			"REW attempting to enforce chain bound runtime (out of scope — consumer responsibility)",
		]
	}
	errorMessage: "domain-invariant inv-rew-successor-chain-bounded: consumer following successor chain unbounded detected via post-hoc audit. Consumer DEVE implement chain hop counter + bound enforcement; configurar consumer policy maxSuccessorHops; ADR override se bound atingido recurrentemente."
	rationale:    "Founder War Game Round 2 Ajuste Extra 2: loop de resolução indireto. Successor chain mecanismo (sc-rew-02) cria possibilidade de chain longa em high-throughput cenários — bound previne consumer livelock. Pattern paralelo a TCP-style hop limit (defense-in-depth contra loops). Enforcement consumer-side porque REW emite naturalmente; consumer responsável por bound."
}

structuralChecks: "sc-rew-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-rew-04"
	title:        "Replay confidence propagation through downstream usage chain"
	artifactType: "domain-model"
	description:  "Outputs de replay com replayConfidence != 'complete' DEVEM propagar confidence metadata para qualquer downstream usage chain: training pipelines, analytics aggregations, derived signal generation, audit reports. Downstream usage MUST attach confidenceProvenance: {originalReplayConfidence, propagationDepth, derivedFromReplayId}. Sem propagação: erro parcial vira verdade futura via training contamination."
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-rew-replay-confidence-propagation"
		assertion: """
			∀ replay output R with replayConfidence ∈ {partial, degraded}:
			  ∀ downstream usage U(R):
			    U attaches confidenceProvenance metadata:
			      originalReplayConfidence = R.replayConfidence
			      propagationDepth = depth(U) in derivation chain
			      derivedFromReplayId = R.replayId
			∧ ∀ training pipeline T consuming U:
			    T inherits confidenceProvenance + extends propagationDepth
			∧ ∀ derived signal/model M trained com U:
			    M tags com confidenceProvenance
			    (modelo aprendido sob partial replay flagged accordingly)
			∧ replay output 'complete' propagates without flagging
			    (no contamination concern)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true   // data lineage tracking pode validar propagação
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Propagação requires DATA LINEAGE TRACKING infrastructure runtime — every derived artifact (training data; analytics aggregation; model retraining) declara provenance. Build-time pode declarar contrato; runtime instrumentation via lineage tooling enforces. Sem lineage tracking: 'partial' replay output flue silently into authoritative chain via training (founder War Game insight: 'erro parcial vira verdade futura')."
			enforcedBy:  "data lineage tracking infrastructure (datasets + models + analytics tagged com provenance) + training pipeline gates rejecting un-provenanced inputs + audit periódica de model training datasets verificando confidenceProvenance attached"
		}
		forbidden: [
			"derived artifact (training data; trained model; analytics aggregation) sem confidenceProvenance metadata quando origin replay had replayConfidence != 'complete'",
			"'partial' replay output usado directly como ground truth para model retraining (deve ser flagged + filtered ou explicit ADR override)",
		]
	}
	errorMessage: "domain-invariant inv-rew-replay-confidence-propagation: derived artifact detected sem confidenceProvenance metadata; origin replay teve replayConfidence != 'complete'. Configure data lineage tracking + propagation gates."
	rationale:    "Founder War Game Round 2 Quebra 4: erro parcial vira verdade futura via uso indireto. Modelo Phase 3 protegia uso direto (replayConfidence enum + consumerProtocol entry); war game expôs uso indireto via training contamination chain. Propagação metadata força transparency através de chain longa. Runtime gap porque data lineage é infrastructure concern; structural-check declara contract."
}

structuralChecks: "sc-rew-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-rew-05"
	title:        "Decision binding to evaluation version (TOCTOU defense)"
	artifactType: "domain-model"
	description:  "Toda ação downstream usando REW evaluation DEVE: (a) referenciar evaluationId em ação metadata; (b) RECHECK evaluation status no aggregate (não projection) ANTES de commit final da ação; (c) se evaluation foi superseded entre leitura e commit → ação DEVE FALHAR com 'evaluation-superseded-during-execution' OR REVALIDATE com new evaluation. Defesa contra TOCTOU (time-of-check vs time-of-use) gap."
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-rew-decision-binding-to-evaluation-version"
		assertion: """
			∀ consumer action A using REW evaluation E:
			  A.metadata MUST include:
			    evaluationId = E.evaluationId
			    evaluationStatus_at_read = E.status_at_read_time
			    readTimestamp = T_read
			∧ before commit(A):
			    consumer queries qry-rew-evaluation-current-status(E.evaluationId)
			    (consulta aggregate, NÃO projection — projection lag invalida defense)
			    response = current_status_now
			∧ current_status_now != evaluationStatus_at_read OR
			    E was superseded between T_read and T_commit
			    ⇒ commit(A) MUST FAIL with reason 'evaluation-superseded-during-execution'
			    OR consumer revalidates com new evaluation
			∧ TOCTOU gap fechado entre T_read e T_commit
			    via mandatory pre-commit recheck
			"""
		coverage: {
			buildTime:       false
			validationTime:  false
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Cross-BC contract enforcement runtime: REW provides qry-rew-evaluation-current-status API; consumer implements pre-commit recheck. Build-time NÃO pode forçar consumer code behavior; runtime cross-BC contract validation requires consumer SDK compliance + audit. Sem runtime gate: gap entre read e action commit cria silent staleness window (founder War Game insight: 'TOCTOU: protege leitura, não intervalo entre leitura e ação')."
			enforcedBy:  "consumer SDK pre-commit recheck pattern (CMT/FCE/SCF code includes evaluationId binding + pre-commit query) + consumerProtocol entry MANDATORY + cross-BC audit verificando ação metadata contém evaluationId + recheck timestamp + future attestation infrastructure (per def-016) cross-BC compliance"
		}
		forbidden: [
			"consumer action committed sem evaluationId binding em metadata",
			"consumer action committed sem pre-commit recheck (TOCTOU window aberta)",
			"pre-commit recheck consultando projection em vez de aggregate state (projection lag invalida defense)",
		]
	}
	errorMessage: "domain-invariant inv-rew-decision-binding-to-evaluation-version: consumer action sem evaluationId binding OR sem pre-commit recheck detected via cross-BC audit. TOCTOU window aberta — configurar consumer SDK com pattern de pre-commit recheck contra aggregate state."
	rationale:    "Founder War Game Round 2 Quebra 5: TOCTOU defense. Modelo Phase 3 protegia LEITURA (active rule + temporal validity); war game expôs INTERVALO ENTRE leitura e ação. Pre-commit recheck fecha gap. Cross-BC contract enforcement runtime — consumer SDK responsibility. Pattern paralelo a optimistic concurrency control (CAS-style version check)."
}

// ============================================================
// PHASE 3.5a EXPANSION (WI-072) — Part 1 invariants coverage
// ============================================================
// 10 sc-rew-* rules cobrindo invariants 1-12 from Part 1 (minus 2
// BEHAVIORAL deferred: inv-rew-model-policy-independence + inv-rew-
// payload-opacity — architectural review-only; no structural-check).
//
// Template level-2 ratificado via 14 fissures iterativas:
// (1-5) sc-rew-08 first iteration: range→semantic; local→cross-BC;
// implicit→resolvable; static→versioned; authoritative→strategy
// (6-9) sc-rew-08 second iteration: calibration freshness;
// discoverability ≠ adoption; replay ≠ contextual; interpretation ≠ action
// (10-13) sc-rew-08 third iteration: TOCTOU semântico; hash ≠ significado;
// freshness local ≠ global; multi-BC feedback loop
// (14) edge crack final: coerente ≠ correto (decision context declaration)
// + 2 edge cracks pre-batch: sc-rew-10 binding real (não declarativo);
// sc-rew-14 full coverage (== não ⊆)
//
// 7 LAYERS canonical (selectively applied per invariant nature):
// L1 PRESENCE · L2 CROSS-FIELD · L2.5 ADOPTION PROOF · L3 RESOLVABLE CONTRACT
// L4 VERSIONED · L5 FRESHNESS · L6 DECISION↔INTERPRETATION COHERENCE
// L7 DECISION CONTEXT DECLARATION + RE-VALIDATION REQUIREMENT

structuralChecks: "sc-rew-06": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-06"
	title: "Signal traceability via immutable snapshot triple integrity (entity-scoped + cardinality-bounded)"
	artifactType: "domain-model"
	description: """
		Snapshot integrity invariant. Layers ativos: L1 PRESENCE
		(signalSnapshotIds non-empty); L2 CROSS-FIELD CONSISTENCY
		(signal entity scope == evaluation entity; capturedAt ≤
		decisionContextTime); L4 VERSIONED IMMUTABILITY (post-emit
		mutation forbidden via aggregate write model CAS); RE-VAL
		(replay engine + audit periódico).

		HONESTY: event log assumed append-only + queryable O(1)
		via signalId. Hash↔content match runtime concern.
		COST BOUND: cardinality limit RiskPolicy.maxSignalsPerEvaluation
		(default 50) anti distributed-lookup attack.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-signal-traceability"
		assertion: """
			∀ evaluation E:
			  [L1] E.signalSnapshotIds non-empty (≥1)
			    ∧ |E.signalSnapshotIds| ≤ RiskPolicy.maxSignalsPerEvaluation
			  [L2] ∀ signalId ∈ E.signalSnapshotIds:
			      ∃ evt-signal-received(signalId) reachable via
			        eventLog.lookup(signalId) — O(1) bounded-time
			      ∧ evt-signal-received.eventTimestamp ≤ E.computedAt
			  [L4] post evt-risk-evaluation-emitted(E.evaluationId):
			      E.signalSnapshotIds IMMUTABLE
			      (aggregate write model CAS rejects mutation)
			[RE-VAL] replay engine + periodic auditor
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "BUILD-TIME schema NÃO cobre event log existence + cardinality bound + immutability post-emit + hash↔content match. VALIDATION-TIME auditor scans event log referential integrity. RUNTIME aggregate write model + event log query layer enforce. ASSUMPTION (honesty): event log = append-only, ordered, queryable by eventId via O(1) lookup. COST BOUND: cardinality limit closes lookup × N attack vector."
			enforcedBy: "(1) Aggregate write model rejects signalSnapshotIds mutation post emit (CAS check). (2) Event log lookup O(1) bounded-time (storage layer guarantee). (3) Cardinality enforcement at evaluation creation. (4) Validation-time auditor advisory."
		}
		forbidden: [
			"signalSnapshotIds empty post-creation",
			"any event mutating signalSnapshotIds after evt-risk-evaluation-emitted",
			"signalSnapshotIds cardinality unbounded (cost attack vector)",
			"signalId reference without corresponding evt-signal-received emitted (orphan)",
		]
	}
	errorMessage: """
		inv-rew-signal-traceability violated:
		- empty snapshot OR cardinality > policy limit
		- orphan signalId (no evt-signal-received in event log)
		- post-emit mutation attempted
		- event log assumption (O(1) lookup, append-only) violated
		"""
	rationale: """
		Snapshot imutável é base de inv-rew-deterministic-replay +
		inv-rew-snapshot-temporal-consistency. War Game fixes:
		COST BOUND (cardinality) anti distributed-lookup attack;
		IMMUTABILITY mechanism explicit (CAS); EVENT LOG ASSUMPTION
		declared (honesty).
		Como quebra: storage layer não-O(1) lookup sob carga;
		aggregate sem CAS check; cardinality unbounded (10k signals
		per evaluation cost attack).
		"""
}

structuralChecks: "sc-rew-07": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-07"
	title: "Contextual completeness via cross-field consistency + authoritative source resolution + continuous re-validation"
	artifactType: "domain-model"
	description: """
		ApplicableContext invariant em 4 layers (template level-2):
		L1 PRESENCE; L2 CROSS-FIELD CONSISTENCY (entity match cross
		signals; policy↔FULL CONTEXT not only product; scope↔assetRef
		semantic binding); L3 RESOLVABLE CONTRACT (authoritative
		source via canvas.contextDependencies — resolution strategy
		'canvas-declared-priority-order'); L7 (no — context não é
		consumer decision); RE-VAL (replay + periodic + pre-critical
		consumer commit).

		HONESTY: resolution strategy = canvas-declared (single-authority
		Phase 3); alternatives priority-order/consensus/context-dependent
		registered Phase N+1. Sistema NÃO assume one truth source —
		assume coherence with strategy declared explicitly.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-contextual-completeness"
		assertion: """
			∀ evaluation E:
			  [L1 PRESENCE] required fields populated +
			    enums {assetVisibility, evaluationScope}
			  [L2 CROSS-FIELD CONSISTENCY]
			    ∀ signalId ∈ E.signalSnapshotIds:
			      signal_entity_of(eventLog.lookup(signalId)) ==
			      E.context.entityRef
			    ∧ E.policyVersion → policy.applicabilityContext
			      COVERS (productCode + decisionContextTime + country
			              + segment + riskTier) — FULL CONTEXT
			    ∧ E.context.evaluationScope == 'asset_level' ⇒
			      E.context.assetRef non-empty
			      ∧ ∃ signal where signal.scope == asset_level
			      (semantic binding, NÃO apenas form)
			  [L3 AUTHORITATIVE SOURCE]
			    E.context.entityRef == authoritative_entity_source(E)
			      where authoritative_entity_source resolves via
			      canvas.contextDependencies.inbound[cmt|npm]
			      (alinhamento com REALIDADE; não apenas consistency
			       interna; resolution strategy 'canvas-declared')
			[RE-VAL] replay + periodic audit + pre-critical consumer
			commit boundary
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "BUILD-TIME schema apenas presence + enum membership. VALIDATION-TIME auditor 4-layer check + drift detection. RUNTIME aggregate write model REJECTS evaluation com cross-field inconsistency. AUTHORITATIVE SOURCE STRATEGY 'canvas-declared-priority-order' — Phase 3 single-source; alternatives Phase N+1. COST BOUND: signal entity extraction × N closed via cardinality limit + RiskPolicy.revalidationPeriodSeconds (default 3600s)."
			enforcedBy: "(1) Aggregate write model 4-layer pre-creation gate. (2) Event log lookup O(1). (3) Canvas contextDependencies cached registry com TTL. (4) Validation-time auditor periodic. (5) Consumer SDK pre-critical commit re-runs check."
		}
		forbidden: [
			"presence-only validation aceita como suficiente (form ≠ truth)",
			"cross-field consistency aceita como suficiente (sistema NÃO se contradiz ≠ sistema está correto)",
			"entityRef NOT derived from authoritative source declared em canvas",
			"policy applicability check apenas em productCode (must include FULL context)",
			"asset_level evaluation sem signals com scope==asset_level (form sem semantic binding)",
			"invariant validated apenas at-creation (permite consistente falso estável)",
			"single-authority assumption sem explicit resolution strategy",
		]
	}
	errorMessage: """
		inv-rew-contextual-completeness violated:
		- entityRef mismatch (cross-signal OR vs authoritative source)
		- policy↔context binding broken (não cobre FULL context)
		- scope↔assetRef incoherence OR sem semantic binding
		- presence/consistency-only check sem authoritative source + re-validation
		"""
	rationale: """
		FOUNDER LEVEL-2 INSIGHTS: errors reais não são absence —
		são inconsistência entre dados que parecem válidos. Authoritative
		source via canvas declared = resolution strategy explícita.
		Como quebra (3 cenários): entityRef mismatch silently (signal
		bug); policy↔product binding broken (compliance fails audit);
		scope↔assetRef incoherence (decision aplicada a asset NULL).
		REGRA FINAL V2: 'esse erro continuaria válido ao longo do
		tempo?' → NÃO via re-validation triggers.
		"""
}

structuralChecks: "sc-rew-08": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-08"
	title: "Bounded score with cross-BC semantic equivalence + adoption proof + interpretation contract + freshness + interpretation/action separation + decision context"
	artifactType: "domain-model"
	description: """
		Bounded score invariant em 7 layers (template level-2 final
		— 14 fissures fechadas via 3 iterações + edge cracks):
		L1 RANGE; L2 SEMANTIC EQUIVALENCE; L2.5 ADOPTION PROOF
		(interpretationSourceRef binding com semanticHash, NÃO
		contractHash — captures thresholds + calibration signature
		+ distribution snapshot); L3 RESOLVABLE CONTRACT (registry
		via agg-risk-model; INTERPRETATION ≠ ACTION POLICY explícita);
		L4 VERSIONED + COMPATIBILITY; L5 CALIBRATION FRESHNESS
		(heuristic; NÃO suprime external signals); L6 DECISION↔
		INTERPRETATION COHERENCE; L7 DECISION CONTEXT DECLARATION
		(decisionScope + decisionMagnitude — eliminate desproporção).

		HONESTY: resolution strategy 'model-version-canonical';
		semanticHash ≠ textual hash; freshness heuristic não garantia;
		feedback loop risk Phase N+1; replay catches consistência
		histórica NÃO contextual.

		TESTE EPISTEMOLÓGICO V2: novo BC consegue interpretar +
		provar uso correto + detectar drift contextual sem context
		adicional? SIM via L3 + L2.5 + L5 (PARCIAL Phase N+1).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-bounded-score"
		assertion: """
			∀ RiskScore S in evaluation E:
			  [L1] S.value ∈ scale-determined range
			    (probability:[0,1]; normalized:[0,100]; custom:[min,max])
			  [L2 SEMANTIC EQUIVALENCE]
			    same (scale, calibrationProfile, modelVersion,
			          calibrationFreshnessWindow) ⇒ same interpretation
			    cross consumers
			  [L2.5 ADOPTION PROOF]
			    ∀ consumer decision D using S:
			      D.metadata.interpretationSourceRef = {
			        modelVersion, semanticHash, consumerSDKVersion}
			      where semanticHash = hash(thresholds +
			        calibration_dataset_fingerprint + distribution_snapshot)
			      ∧ semanticHash matches current registry entry
			  [L3 RESOLVABLE CONTRACT]
			    ∃ riskModelRegistry.lookup(modelVersion) → contract O(1)
			    ∧ contract DEFINES MEANING ONLY (NO action policies)
			  [L4 VERSIONED] contract immutable per modelVersion
			    ∧ consumer SDK validates compatibility pre-action
			  [L5 FRESHNESS]
			    now() - calibrationProfile.calibratedAt ≤
			      calibrationFreshnessWindow
			    ⇒ formal interpretation CONTEXTUALLY VALID (HEURISTIC)
			    freshness pass DOES NOT suppress external invalidation
			  [L6 COHERENCE]
			    consumer.decisionOutcome compatible com S.classification
			    (high-risk ⇏ approved; good ⇏ blocked sem override)
			  [L7 DECISION CONTEXT]
			    consumer decision metadata includes:
			      decisionScope ∈ enum
			      decisionMagnitude (numeric per scope)
			    ∧ decision coherent com (interpretation + scope)
			[RE-VAL] replay + SDK upgrade + cross-BC audit + freshness
			expiry + telemetry-driven (Phase N+1)
			"""
		coverage: { buildTime: true, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "BUILD-TIME range only. VALIDATION-TIME auditor 7-layer sweep + adoption proof + freshness drift + lexicon (interpretation ≠ action) + feedback loop pattern detection + decisionScope/Magnitude validity. RUNTIME aggregate + consumer SDK enforce. AUTHORITATIVE STRATEGY 'model-version-canonical'. SEMANTIC IDENTITY = semanticHash (not contractHash); textual hash insufficient. FRESHNESS HEURISTIC: static window detect drift estático; dataset shift mid-window Phase N+1 telemetry. FEEDBACK LOOP RISK: decisões erradas viram dados → reforçam erro (honesty Phase 3; mitigation Phase N+1). COST BOUND: registry + adoption proof × N closed via interpretationCacheSeconds (60s default) + batched audit."
			enforcedBy: "(1) Aggregate write model: reject score com modelVersion lacking scoreInterpretation OR calibration stale OR decision incoherent. (2) Consumer SDK: interpretationSourceRef binding mandatory + semanticHash match check + decisionScope/Magnitude declaration. (3) Validation-time auditor: 7-layer sweep + lexicon check + feedback pattern detection. (4) Replay engine: L1-L4 deterministic; L5 PARCIAL. (5) Phase N+1: telemetry-driven recalibration + cross-BC adversarial testing."
		}
		forbidden: [
			"score com value fora do range per scale",
			"comparison cross-model sem normalization (semantic equivalence violated)",
			"score emitted com modelVersion lacking published scoreInterpretation",
			"contract mutated post-publication (immutability)",
			"consumer interpreting sem interpretationSourceRef binding (adoption proof missing)",
			"consumer using stale semanticHash (uniform adoption violated)",
			"consumer override silencioso of registry (private knowledge)",
			"scoreInterpretation contract containing action policies (interpretation ≠ action)",
			"calibration stale beyond freshness window AND no recalibration trigger",
			"freshness pass suppressing external invalidation signals",
			"single-authority assumption sem explicit resolution strategy",
			"decision metadata sem decisionScope OR decisionMagnitude (proportion invisível)",
			"decisionMagnitude desproporcional ao decisionScope sem documented justification",
			"decision coerente com classification MAS desproporcional ao scope (L6 + L7 violation)",
		]
	}
	errorMessage: """
		inv-rew-bounded-score violated:
		- value fora range (L1)
		- cross-BC drift OR adoption proof missing (L2/L2.5)
		- contract NÃO resolvable OR contains action policy (L3)
		- versioning OR compatibility violation (L4)
		- calibration stale OR suppressing external signals (L5)
		- decision incoherent com classification (L6) OR desproporcional (L7)
		"""
	rationale: """
		FOUNDER 14 FISSURES embedded. TESTE EPISTEMOLÓGICO V2 +
		REGRA FINAL V2 ('esse erro continuaria válido ao longo do
		tempo?'). 8 cenários como quebra (range; cross-BC drift;
		implicit knowledge; versioning drift; calibration stale;
		external signal suppressed; decision incoherence; decision
		desproporcional). Sistema saiu de validar dados → decisões
		→ semântica → significado compartilhado → validade do
		significado over time → controle da evolução do erro →
		decisão dentro de contexto explícito.
		"""
}

structuralChecks: "sc-rew-09": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-09"
	title: "Deterministic replay via SHA-256 + canonical serialization"
	artifactType: "domain-model"
	description: """
		Replay determinism em 3 layers: L1 PRESENCE (replayHash regex);
		L4 VERSIONED COMPATIBILITY (canonical spec immutable per
		modelVersion); L5 FRESHNESS HONESTY (replay catches consistência
		histórica L1-L4; NÃO catches contextual drift Phase N+1).
		HONESTY: canonical serialization assumed bijective. Test:
		'consumer pode reconstruir replayHash sem documentação privada?'
		SIM via published canonical spec.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-deterministic-replay"
		assertion: """
			∀ evaluation E:
			  [L1] E.replayHash =~ ^[a-f0-9]{64}$
			  [L4] E.replayHash == SHA256(canonicalSerialize(
			    sortAsc(E.signalSnapshotIds) + E.modelVersion +
			    E.policyVersion + ISO8601_UTC(E.context.decisionContextTime)))
			    ∧ canonicalSerializationSpec immutable per modelVersion
			  [L5 HONESTY] replayHash match ⇒ inputs identical (formal);
			    NÃO ⇒ contextual validity preserved
			[RE-VAL] replay engine + audit periódico
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "Canonical serialization runtime concern. Build-time só regex. Validation-time auditor recomputa hash sample. Runtime hash recompute on demand. HONESTY: canonical spec mutation breaks all historical replay → IMMUTABLE per modelVersion."
			enforcedBy: "(1) Aggregate hash compute at creation. (2) Replay engine recompute on demand; mismatch → replayConfidence='degraded'. (3) Auditor sample recompute. (4) Canonical spec versioning bound to modelVersion."
		}
		forbidden: [
			"replayHash format violation",
			"canonical serialization spec mutation sem modelVersion bump",
			"replay match assumed as contextual validity (founder honesty: replay catches consistência histórica não adequação contextual)",
			"non-deterministic compute steps unaudited (stochastic outputs sem seed)",
		]
	}
	errorMessage: "inv-rew-deterministic-replay violated: regex / canonical spec mutation / contextual assumption / non-deterministic compute."
	rationale: "Replay determinism foundation. War Game: 'determinismo é propriedade de execução, não de dado'. Como quebra: stochastic compute sem seed; canonical spec mutation silent; replay match interpreted as decision still valid today (contextual drift)."
}

structuralChecks: "sc-rew-10": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-10"
	title: "Model-policy version drift visibility (não collision — invisible drift detection com binding real)"
	artifactType: "domain-model"
	description: """
		Founder ajuste: invariant NÃO é collision (string igual). É
		DRIFT INVISÍVEL: model muda, policy não → evaluation muda
		sem policy awareness. Layers: L2 cross-field (model+policy
		bound em evaluation); L4 versioned com explicit drift
		signaling; L6 decision↔interpretation coherence (consumer
		PROVA interpretedModelVersion via interpretationSourceRef
		binding match — NÃO declarativo); RE-VAL on model activation.

		EDGE CRACK FIX: detectedModelVersion → interpretedModelVersion
		bound to interpretationSourceRef.modelVersion + semanticHash
		registry match. Consumer não declares 'vi modelo X' — PROVA
		que interpretou aquele contrato.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-model-policy-separation"
		assertion: """
			∀ evaluation E:
			  [L2] E.modelVersion ≠ E.policyVersion (string namespace)
			    ∧ both bound em evaluation metadata + emit event
			  [L4] modelVersion change MUST produce:
			    (a) new evaluation identity (cmd-request triggers new
			        evaluationId), OR
			    (b) explicit cmd-supersede-risk-evaluation
			    NEVER silent drift sem identity mutation
			  [L6 BINDING REAL — não declarativo]
			    consumer.decision.metadata MUST include:
			      interpretedModelVersion ==
			      consumer.interpretationSourceRef.modelVersion
			      ∧ interpretationSourceRef.semanticHash matches current
			        registry entry for interpretedModelVersion
			    (consumer PROVA via binding match — não DECLARES)
			[RE-VAL] cross-BC audit + consumer SDK upgrade boundary
			"""
		coverage: { buildTime: true, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "BUILD-TIME schema enforces ≠ namespaces. VALIDATION-TIME auditor scans evt-risk-model-activated vs evt-risk-evaluation-emitted timeline (drift signal) + verifies consumer interpretationSourceRef binding match. RUNTIME aggregate write model + consumer SDK semanticHash check. HONESTY: model change WITHOUT policy change is LEGITIMATE (independent versioning); MAS DEVE ser visível via evaluation identity OR explicit supersede + consumer binding proof."
			enforcedBy: "(1) Aggregate rejects evaluation com stale modelVersion post-activation. (2) Consumer SDK interpretedModelVersion mandatory + semanticHash match enforced pre-action. (3) Auditor cross-references model activation timeline."
		}
		forbidden: [
			"modelVersion == policyVersion (namespace collision)",
			"silent drift: modelVersion change sem evaluation identity bump OR explicit supersede",
			"consumer declares interpretedModelVersion sem interpretationSourceRef binding match (declarativo, não verificável — drift permitido silenciosamente)",
			"consumer semanticHash stale vs current registry (uniform adoption violated)",
			"interpretation 'collision'-only framing (founder ajuste: real risk é drift invisible)",
		]
	}
	errorMessage: "inv-rew-model-policy-separation violated: collision / silent drift / consumer declarativo sem binding match / stale semanticHash."
	rationale: "Founder ajuste: NÃO 'naming problem' — DRIFT INVISÍVEL. EDGE CRACK FIX (binding real não declarativo): consumer PROVA interpretation via semanticHash registry match. Como quebra: model recalibration mid-flow; consumer cache v2 enquanto evaluation v3; declarativo 'detectedModelVersion=v3' passa silenciosamente sem binding proof."
}

structuralChecks: "sc-rew-11": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-11"
	title: "Alert lifecycle with condition-resolution coupling (false closure prevention)"
	artifactType: "domain-model"
	description: """
		Founder ajuste: alert resolved + resolutionReason presente
		MAS condition ainda exists = FALSE CLOSURE. Layers: L1
		PRESENCE (status enum + resolutionReason quando resolved);
		L2 CROSS-FIELD CONSISTENCY (resolutionReason coherent com
		alertCategory); L6 DECISION↔INTERPRETATION COHERENCE
		(resolved IMPLIES condition no longer present OR explicitly
		waived); RE-VAL (periodic check for false closures).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-alert-lifecycle"
		assertion: """
			∀ alert A:
			  [L1] A.status ∈ {open, acknowledged, resolved}
			    ∧ resolved ⇒ A.resolutionReason non-empty
			  [L2] A.resolutionReason ∈ vo-decision-reason enum
			    coherent com A.alertCategory
			  [L6 COHERENCE]
			    resolved ⇒
			      EITHER triggering_condition_no_longer_active(A) —
			        verified via re-evaluation of original condition
			        vs current state
			      OR A.resolutionReason == 'explicitly-waived' com
			        documented waiver authority
			[RE-VAL] periodic auditor re-evaluates triggering condition
			vs current state; flags false closures
			"""
		coverage: { buildTime: true, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "BUILD-TIME schema enum + presence. VALIDATION-TIME periodic auditor re-evaluates triggering condition vs current state for resolved alerts. RUNTIME cmd-resolve-risk-alert handler validates resolutionReason coherence. HONESTY: condition re-evaluation requires querying current evaluation state — async/cached results may produce stale signal. Phase N+1: evt-risk-alert-reopened event quando false closure detected (deferred)."
			enforcedBy: "(1) Aggregate write model resolutionReason coherence at cmd-resolve. (2) Auditor periodic false-closure detection. (3) Phase N+1 reopen event."
		}
		forbidden: [
			"resolved alert sem resolutionReason",
			"resolutionReason incoherent com alertCategory",
			"resolved alert com triggering condition still active sem 'explicitly-waived' (false closure)",
			"alert reopening via mutation (must be new alert per inv-rew-alert-evaluation-binding-immutability)",
		]
	}
	errorMessage: "inv-rew-alert-lifecycle violated: missing resolutionReason / incoherent reason / false closure / mutation-based reopening."
	rationale: "Founder ajuste: NÃO audit gap superficial — FALSE CLOSURE. L6 forces condition re-evaluation OR explicit waiver. Como quebra: operator clicks resolve sem investigation; alert closed; condition continues; fraud/risk continues sem signal."
}

structuralChecks: "sc-rew-12": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-12"
	title: "Model-version binding cross-VO (RiskScore.computedFromModelVersion == evaluation.modelVersion)"
	artifactType: "domain-model"
	description: """
		Cross-VO consistency: RiskScore VO embedded em evaluation MUST
		declare same modelVersion. Score gerado por modelo X em
		evaluation declarando modelo Y = corrupção semântica. Layers:
		L1 PRESENCE; L2 CROSS-FIELD CONSISTENCY (path-style unification);
		L4 VERSIONED IMMUTABILITY (binding immutable post-emit).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-model-version-binding"
		assertion: """
			∀ evaluation E:
			  [L1] E.score.computedFromModelVersion non-empty
			    ∧ E.modelVersion non-empty
			  [L2 PATH UNIFICATION]
			    E.score.computedFromModelVersion == E.modelVersion
			  [L4] post emit: binding IMMUTABLE
			    (aggregate write model CAS rejects mutation)
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "Schema #ValueObject closed-struct impede path-ref unification em VO catalog (RiskScore catalog VO; embedding via valueObjectRef code, não direct path). Binding enforcement em aggregate + structural-check. HONESTY: VO catalog reference indireta requires explicit binding check."
			enforcedBy: "(1) Aggregate pre-emit gate validating equality. (2) Auditor event log scan. (3) Replay engine binding check during reconstruction."
		}
		forbidden: [
			"E.score.computedFromModelVersion ≠ E.modelVersion",
			"score generated by model X attached to evaluation declaring model Y",
			"binding mutation post-emit",
		]
	}
	errorMessage: "inv-rew-model-version-binding violated: cross-VO binding broken OR post-emit mutation."
	rationale: "Strong invariant. Como quebra: aggregate bug → score VO created with stale modelVersion ref; evaluation updated to current; binding mismatch silently."
}

structuralChecks: "sc-rew-13": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-13"
	title: "Asset-aware discipline cross-VO conditional (assetVisibility=='gap' ⇒ decision != 'eligible')"
	artifactType: "domain-model"
	description: """
		Cross-VO conditional: ApplicableContext.assetVisibility=='gap'
		⇒ EligibilityDecision.decision NÃO PODE ser 'eligible'.
		Sistema afirmaria verdade que NÃO pode justificar = falso
		positivo estrutural. Layers: L2 CROSS-FIELD CONSISTENCY;
		L6 DECISION↔INTERPRETATION COHERENCE (gap = ignorância
		sistêmica; eligible = decision com confidence — mutuamente
		exclusivos).
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-asset-aware-discipline"
		assertion: """
			∀ evaluation E:
			  [L2] E.context.assetVisibility ∈ {visible, indirect, gap}
			    ∧ E.eligibility.decision ∈ {eligible, conditionally_eligible,
			                                ineligible}
			  [L6 CONDITIONAL]
			    E.context.assetVisibility == 'gap' ⇒
			      E.eligibility.decision ∈ {conditionally_eligible,
			                                ineligible}
			    ∧ conditionally_eligible sob gap ⇒
			      E.eligibility.constraints includes 'asset-visibility-gap'
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "Cross-VO conditional NÃO expressável em VO catalog closed-struct. Aggregate write model pre-emit gate + auditor periodic. HONESTY: 'gap' classification depende de ACL signal interpretation upstream — gap signaled but actually visible (bug upstream) generates false negatives; inverse impossible by construction."
			enforcedBy: "(1) Aggregate pre-emit conditional check. (2) Auditor cross-VO consistency scan."
		}
		forbidden: [
			"E.assetVisibility=='gap' ∧ E.decision=='eligible' (falso positivo estrutural)",
			"conditionally_eligible sob gap sem 'asset-visibility-gap' constraint",
			"gap classification ignored em decision compute (treated as visible)",
		]
	}
	errorMessage: "inv-rew-asset-aware-discipline violated: gap + eligible (falso positivo) OR conditional sem gap constraint."
	rationale: "Glossary Phase 2 anchor: 'sistema afirma verdade que não pode justificar'. Como quebra: ACL bug treats gap as visible silently; aggregate sem cross-VO gate accepts; consumer pays/grants sob gap = financial loss + compliance failure."
}

structuralChecks: "sc-rew-14": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-14"
	title: "Reasoning trace causally linked to output with FULL signal coverage (replay reproduces decision)"
	artifactType: "domain-model"
	description: """
		Founder ajuste: trace existe + cardinality OK MAS NÃO
		corresponde ao output = pseudo-explanation. Layers: L1
		PRESENCE (≥2 intermediateSteps); L2 CROSS-FIELD (trace
		inputs == evaluation signalSnapshotIds — FULL COVERAGE,
		não subset); L3 RESOLVABLE CONTRACT (trace structure
		published); L6 DECISION↔INTERPRETATION COHERENCE (replay
		reproduces decision — causal, não rationalization).

		EDGE CRACK FIX: trace inputs ⊆ signalSnapshotIds → trace
		inputs == signalSnapshotIds (full coverage requirement).
		Trace coerente mas incompleto = signal C ignored = partial
		explanation = auditor cego.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-reasoning-completeness"
		assertion: """
			∀ evaluation E with ent-reasoning-trace T:
			  [L1] |T.intermediateSteps| ≥ 2
			    ∧ T.inputs.{signals, modelVersion, policyVersion} non-empty
			    ∧ T.outputs.{score, eligibility, confidence} non-empty
			  [L2 FULL COVERAGE — não subset]
			    T.inputs.signals == E.signalSnapshotIds
			    (todos signals usados em compute MUST appear em trace;
			     subset permite signal C ignored sem auditor detect)
			    ∧ T.inputs.modelVersion == E.modelVersion
			    ∧ T.inputs.policyVersion == E.policyVersion
			  [L3] trace structure published (canonical schema)
			  [L6 CAUSAL]
			    T.outputs == E.{score, eligibility, confidence}
			    ∧ replay(T.intermediateSteps from T.inputs) reproduces
			      T.outputs (causal chain — explanation, não
			      rationalization post-hoc)
			[RE-VAL] periodic auditor + replay engine
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "BUILD-TIME schema só presence + cardinality. VALIDATION-TIME auditor replays sample traces + verifies output match + signal coverage. RUNTIME aggregate write model gates trace creation com causal validation. HONESTY: 'replay reproduces decision' assumes deterministic compute (per inv-rew-deterministic-replay); stochastic models require seed registered. Causal vs rationalized depends on stepType semantics — auditor lexicon check."
			enforcedBy: "(1) Aggregate causal validation at trace creation. (2) Replay engine reproduces decision from trace. (3) Auditor periodic causal coherence + lexicon match."
		}
		forbidden: [
			"trace com cardinality OK MAS outputs ≠ evaluation outputs (rationalization)",
			"T.inputs.signals ⊊ E.signalSnapshotIds (signal usado em compute mas omitted from trace — partial explanation, não causal — EDGE CRACK FIX)",
			"intermediateSteps com non-canonical stepType (lexicon violated)",
			"trace published sem replay reproducibility (causal claim sem evidence)",
		]
	}
	errorMessage: "inv-rew-reasoning-completeness violated: trace ≠ causal / inputs ≠ full coverage / non-canonical steps / replay diverges."
	rationale: "Founder ajuste: NÃO cardinality — CAUSAL LINK + FULL COVERAGE. EDGE CRACK FIX: subset (⊆) → equality (==). Como quebra: trace generated post-hoc para 'explain' decision sem actually being compute path; signal C ignored em trace mas usado em compute; auditor accepts plausible narrative; regulatory audit fails on adversarial inspection."
}

structuralChecks: "sc-rew-15": artifact_schemas.#StructuralCheck & {
	id: "sc-rew-15"
	title: "Temporal consistency with bounded clock-skew tolerance (no time-travel sob skew real)"
	artifactType: "domain-model"
	description: """
		Founder ajuste: timestamps válidos + clock skew → ordem
		errada sem violar regra. Layers: L2 CROSS-FIELD CONSISTENCY
		(temporal chain monotonia); L5 FRESHNESS HEURISTIC
		(tolerance bounds skew sem mascarar corrupção). HONESTY:
		tolerance > 15min indicates infrastructure problem (clock
		sync), NÃO temporal violation domínio.

		MINOR HONESTY (founder note): tolerance permits 2 realities
		simultâneas temporary — replay pode divergir dependendo do
		ponto de observação. Temporal determinism is CONDITIONAL
		on tolerance window. Não absolute determinism.
		"""
	kind: "domain-invariant"
	rule: {
		invariantId: "inv-rew-temporal-consistency"
		assertion: """
			∀ evaluation E and ∀ signal s ∈ E.signalSnapshotIds:
			  [L2 CHAIN com tolerance cross-BC]
			  s.observedAt ≤ s.recordedAt + RiskPolicy.toleranceWindowSeconds
			  ∧ s.recordedAt ≤ s.capturedAt + tolerance
			  ∧ s.capturedAt ≤ E.signalSnapshotTime
			  ∧ E.signalSnapshotTime ≤ E.context.decisionContextTime
			  ∧ E.context.decisionContextTime ≤ E.evaluatedAt
			  (intra-REW chain — single clock authority — sem tolerance;
			   cross-BC observedAt/recordedAt — tolerance applies)
			  [L5 BOUNDED HEURISTIC]
			    tolerance default 5min;
			    tolerance > 15min ⇒ infrastructure problem signal
			    (NOT temporal violation absorbable)
			[RE-VAL] periodic auditor flags violations beyond tolerance
			"""
		coverage: { buildTime: false, validationTime: true, runtimeRequired: true }
		runtimeGap: {
			description: "Cross-system clock skew real-world; tolerance bounded absorve operational noise. BUILD-TIME schema só datetime presence. VALIDATION-TIME auditor checks chain monotonia com tolerance. RUNTIME aggregate write model rejects beyond tolerance. HONESTY: tolerance HEURISTIC; extreme skew (>15min) sinaliza infrastructure problem NÃO temporal corruption masquerading as legitimate. TEMPORAL DETERMINISM CONDITIONAL on tolerance window — replay pode divergir dependendo do ponto de observação. Não absolute determinism."
			enforcedBy: "(1) Aggregate temporal chain check com tolerance at creation. (2) Auditor periodic flag of violations + tolerance excess (>15min) escalation. (3) Phase N+1 clock-sync infrastructure monitoring + cross-BC time authority alignment."
		}
		forbidden: [
			"temporal chain violation beyond tolerance (time-travel)",
			"tolerance assumed unlimited (>15min sem infrastructure escalation)",
			"intra-REW chain com tolerance applied (single clock authority — tolerance só cross-BC)",
			"freshness check assumido como suprimindo external invalidation signals",
			"temporal determinism assumed absolute (tolerance creates conditional determinism — replay divergence possible)",
		]
	}
	errorMessage: "inv-rew-temporal-consistency violated: chain monotonia broken beyond tolerance / tolerance > 15min sem infra escalation / intra-REW tolerance misapplied / determinism assumed absolute."
	rationale: "Founder ajuste: real-world clock skew + retry semantics + ingestion delay break ordering estrita cross-BC. Tolerance bounded absorve ruído operacional sem mascarar corrupção. MINOR HONESTY: temporal determinism CONDITIONAL on tolerance window — replay divergence possible. Como quebra: clock skew 30s ACL → signal capturedAt > decisionContextTime apparently; tolerance 5min absorbs; legitimate. MAS skew 20min indicates infrastructure problem; tolerance shouldn't mask — escalation required."
}

// ============================================================
// BEHAVIORAL INVARIANTS — NO STRUCTURAL-CHECK APPLICABLE
// ============================================================
// Per founder Phase 3 directive: 2 invariants from Part 1 são
// puramente architectural/behavioral; enforcement via review +
// disciplina arquitetural; NÃO structural-check applicable.
//
// inv-rew-model-policy-independence — model NÃO depende de policy;
//   architectural rule (verificável apenas via review humano +
//   ADR enforcement). Tentar enforcement structural seria over-
//   reach do mecanismo.
//
// inv-rew-payload-opacity — REW logic NÃO branch em payload field
//   específico de Signal; architectural discipline anti-corruption.
//   Verification via code review + ADR de policy implementations.
//
// Quando architectural review subagent operacional (Phase N+1),
// pode-se materializar advisory checks para esses BEHAVIORAL
// invariants como validation-prompts (architecture/validation-
// prompts/) — NÃO structural-checks (per ADR-040 separation of
// structural vs semantic validation).
