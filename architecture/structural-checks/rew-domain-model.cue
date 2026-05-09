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
