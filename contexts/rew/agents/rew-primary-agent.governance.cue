package rew

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// rew-primary-agent.governance.cue — Governance Envelope: REW Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Phase 5 do WI-046 REW bootstrap (close-out). Materializa control plane
// supervisório sobre execution layer Phase 4 (rew-primary-agent.cue):
// routing + caps + drift + calibration + failureHandling.
//
// Fronteira com agent-spec (rew-primary-agent.cue) per adr-037:
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → envelope pode override
//   (Phase 0: nenhum override declarado; promoção via calibration crossing
//    thresholds, NÃO via override retroativo — tq-gv-14 forbid execute-and-log
//    direto a mutations preserva P10 unconditionally)
// - agent-spec declara observability signals → envelope define drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária)
// - lens-regulatory-compliance-as-architecture (primária — LGPD Art. 20 + Bacen)
// - lens-decision-systems-with-truth-boundaries (primária — pattern post-INV
//   extraction per adr-085 + lens-truth-boundaries; REW é primeira instância
//   completa do pattern)
// - lens-security-trust-infrastructure (secundária — defense-in-depth via
//   replay determinism + structural gates + drift detection multi-camada)
//
// Phase 0 caveats:
// - governanceGlobalVersion "0.1" forward-ref canônico (per cmt/ctr/idc/npm/
//   bdg/ssc/dlv/inv pattern).
// - Nenhum autonomyOverride: 10 mutations propose-and-wait per spec; promoção
//   via calibration crossing thresholds — tq-gv-14 forbid override direto
//   preserva P10.
// - REW severity tier ALTO: guardrail de calibração epistemológica do sistema
//   (cascade REW → CMT-credit decisions); LGPD Art. 20 contestabilidade +
//   Bacen scrutiny + cross-BC explainability via replay determinístico.
//
// Authoring manual Phase 0 per manualAuthoringProtocol section-gates (3 sections
// + ten-012 tension-entry registered + Phase 5.1 BC isolation correction):
// - Section 1 (routing-and-blast-radius): 5 escalationRouting (1:1 com spec) +
//   blastRadiusCaps 2/30 mid-band conservador + routing precedence canonical
//   5-tier + multi-match resolution rule + scope elevation rule + unknown event
//   safety rule (narrowed to governance surface per founder ajuste) + HALT_AGENT
//   recovery protocol 4-condition.
// - Section 2 (drift-and-calibration): 8 drift metrics (2 OP + 3 HYBRID + 3 ADV)
//   + 3 drift→action bindings + 2 promotionCriteria com anti-gaming embedded +
//   realization tracking via EXTERNAL audit gate anti-Goodhart + 8
//   regressionTriggers + failureHandling 3 events anti-bypass discipline.
// - Section 3 (bidirectional-validation): tq-gv/tq-gvg checks all PASSING;
//   rationale outer cobertura completa de 19 disciplinas.
//
// Phase 5.1 CORRECTION (post-commit founder review): BC isolation violations
// detected — 3 cross-BC vazaments do pattern INV inadvertidamente aplicados
// ao REW. Corrigidos:
// (1) Removida métrica dm-cross-bc-evaluation-utilization-drift (downstream
//     observation viola envelope-is-control-plane tq-gvg-09; anti-mini-CMT;
//     REW BC ends em evt-risk-evaluation-emitted).
// (2) Reframada realization tracking em promotionCriteria 2: tirada do
//     metric (REW agent NÃO observa defaults downstream); declarada como
//     EXTERNAL audit gate executado por processo independente consumindo
//     CMT/SCF default events. Anti-Goodhart preservado; observation channel
//     separated from REW agent.
// (3) Removido cross-BC retry em failureHandling.onTimeout — ACL é push-based
//     per cst-14; REW agent NÃO query cross-BC durante evaluation; signal
//     absence = insufficient-context route (sem retry cross-BC).
// Vazaments originaram de pattern INV (INV faz cross-BC sync queries para
// CMT regime). REW spec.cst-14 acl-boundary-acknowledged declara push-based
// signals — inconsistência detectada e corrigida.
//
// Founder ajustes pre-write incorporados:
//   Section 1: governance-critical-activation discipline materializada via
//     metric + regression + rationale (NÃO via autonomyOverride retroativo;
//     NÃO via reuse de #EscalationCategory enum); routing precedence canonical
//     5-tier; HALT_AGENT recovery 4-condition incluindo SAFE STATE REPLAY.
//   Section 2 (4 ajustes): (1) dm-replay-divergence-rate → -detected (binary
//     breach detector, NÃO statistical rate); (2) threshold "1 breach in
//     monthly evaluation window" (unidade semântica clara); (3) realization
//     tracking GUARDRAIL EPISTEMOLÓGICO explicit anti-Goodhart note ('epistemic
//     validation ≠ reward shaping'); (4) evaluationCadence schema interpretation
//     note inline (drift compute cadence vs governance review vs human review).
//   Section 3 (2 ajustes): (1) unknown event safety rule narrowed to semantic/
//     domain/governance events within modeled governance surface (excludes
//     infrastructure telemetry); (2) 'runner' → 'runtime governance layer' em
//     usos implementation-sounding (preserva canonical references).
//
// Tension-entry ten-012 registered (status: accepted):
//   Schema #EscalationChannel enum + slaDescription field name leak runtime/
//   SRE/transport semantics. Trade-off: schema atual preservado + envelope REW
//   reframa CONTEÚDO em linguagem de governança (slaDescription como 'governance
//   response window'; channel enum values interpretados como review modes,
//   NÃO transport mechanisms). Schema rename deferred to dedicated ADR + 9-
//   envelope migration. Trigger reabertura: founder priority OR n=3 envelopes
//   futuros confusion.
//
// Forward-refs Phase N+1: governanceGlobalVersion '0.1' upgrade quando
// architecture/agent-governance.cue materializado; schema rename per ten-012;
// realization tracking telemetry feedback loop consumindo CMT downstream
// real default observations.

rewPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-rew-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING (5 routes — 1:1 com spec.escalationConditions)
	// 2 routes com sub-routing splits via rationale (suspicious-input
	// UNCERTAIN/VERIFIED; out-of-scope replay/pattern). Tensão ten-012
	// capturada: schema field names interpretados como governance review
	// modes, NÃO transport mechanisms.
	// =============================================

	escalationRouting: [{
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Governance response window: 2h business-hours. Block scope: evaluation-specific (NÃO global halt); outras evaluations continuam fluindo."
		recipient:      "founder"
		rationale: """
			Folded scenarios per spec: (A) act-request-risk-evaluation
			signal payload incompleto / projection unavailable / modelVersion
			OR policyVersion ativa unresolvable; (B) act-supersede-risk-
			evaluation predecessor não encontrada em projection (eventual
			consistency lag); (C) act-mark-evaluation-stale evaluation
			não encontrada; (D) act-acknowledge-risk-alert / act-resolve-
			risk-alert alert não encontrado.

			DECISION local ABORT_ACTION; ESCALATION DEFERRED com structured
			failureReason classified. Threshold-based escalation pode
			disparar Phase 1+ via envelope se condition persists.

			Block scope: evaluation-specific (paralelo INV item-specific
			pattern). NÃO global agent halt.

			Governance response window 2h business-hours: REW gating
			downstream CMT credit decisions; atraso bloqueia spine
			financeiro + amplifica risco LGPD Art. 20 contestabilidade
			gap (decisão pendente sem rationale auditable).
			"""
	}, {
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Governance response window: 2h synchronous-human-review. Block scope: evaluation/alert-specific (tuples afetadas); outras evaluations sem signal conflict continuam fluindo."
		recipient:      "founder"
		rationale: """
			Folded scenarios per spec: (A) act-request-risk-evaluation
			signal sources contradictórios pós-ACL com sub-classifications
			VERIFIED → HARD vs UNCERTAIN → SOFT; (B) act-raise-risk-alert
			alert state vs evaluation state inconsistentes (alert raised
			para evaluation já superseded).

			DECISION local ABORT_ACTION; ESCALATION HARD se VERIFIED
			contradiction (DOMAIN-INCONSISTENCY); SOFT retry-eligible se
			VERIFICATION-UNCERTAIN.

			Channel synchronous-human-review (não blocking-alert): sinais
			contraditórios = DOMAIN-INCONSISTENCY exigindo resolução
			humana sync (founder reconciliation com signal sources
			upstream — CMT/SSC/DLV ACL boundary). Pattern threshold seria
			insuficiente — sinais contraditórios entre signal sources
			não é noise estatístico, é symptom de upstream corruption
			OR adversarial coordination.

			Founder R2 distinction (verify-failed ≠ invariant-violated)
			preserved: VERIFIED é evidence; UNCERTAIN é hypothesis.
			Routing reflete ontologically.

			Governance response window 2h: sinais contraditórios sustentados
			bloqueiam risk decisioning para múltiplas evaluations; cada
			hora adicional acumula backlog operacional + risco drift cross-
			BC expandir downstream.
			"""
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Governance response window: 2h blocking-alert (VERIFICATION-UNCERTAIN default). OVERRIDE: 2h synchronous-human-review (VERIFIED-CORRUPTION). Block scope: actor-affected default; cluster-elevável quando ≥2 distinct actors involved within time window (anti-coordinated-fraud)."
		recipient:      "founder"
		rationale: """
			ROUTING SPLIT (MANDATORY) per founder discipline UNCERTAIN ≠
			VERIFIED:

			(A) VERIFICATION-UNCERTAIN — pattern flagged não confirmed:
			    statistical anomaly indication; pattern detection
			    downstream; cross-source reconciliation pending. Verify
			    failed mas violação NÃO confirmed. SOFT retry-eligible.
			    → channel: alert-and-block (blocking-alert mode);
			    → Governance response window: 2h (default);
			    → Block scope: actor-affected (signal source / asset
			      identifier em janela detecção);
			    → Pattern detection counter; HARD apenas em pattern
			      sustained.

			(B) VERIFIED-CORRUPTION — pattern confirmed: cross-source
			    reconciliation confirmed; explicit fraud signal arrived;
			    statistical anomaly + corroborating evidence. Real
			    structural breach. HARD imediato.
			    → channel OVERRIDE: sync-human-review (synchronous-human-
			      review mode);
			    → Governance response window: 2h (override);
			    → Block scope ELEVÁVEL: cluster-elevável quando ≥2
			      distinct actors involved within time window
			      (anti-coordinated-fraud). Cascade REW → CMT-credit
			      reforça severity — fraude em REW amplifica downstream
			      via decisões credit baseadas em score corrupto.

			Founder distinction (verify-failed ≠ invariant-violated)
			preserved: VERIFIED é evidence; UNCERTAIN é hypothesis.
			Routing reflete ontologically — channel sync garante founder
			review imediato + investigação raiz em VERIFIED breach;
			alert-and-block (paralelo a outras operations) insuficiente
			para severity tier verificado.

			Governance response window 2h: REW guardrail de calibração
			epistemológica; pattern sustentado escala risco sistêmico se
			não contido (cascade CMT credit decisions). Founder canonical:
			'guardrail epistemological do ponto onde sistema calibra
			confiança'.
			"""
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Governance response window: 12h deferred-review (replay legítimo / race condition operacional SOFT default). OVERRIDE: 4h synchronous-human-review para pattern adversarial sustained (Phase 1+ envelope threshold)."
		recipient:      "founder"
		rationale: """
			Folded scenarios per spec: (A) act-supersede-risk-evaluation
			tentativa de supersede pre-emit (cst-supersede-after-emit-only
			OR inv-rew-supersede-after-emit-only violado); (B) act-mark-
			evaluation-stale tentativa em evaluation terminal state
			(superseded OR já stale); (C) act-acknowledge-risk-alert /
			act-resolve-risk-alert tentativa de transição lifecycle
			inválida from terminal state (resolved → acknowledged OR
			resolved → raised — transições from terminal state proibidas).

			DECISION local ABORT_ACTION (structural gate boundary).
			ESCALATION SOFT default: out-of-scope tipicamente reflete
			eventual consistency lag OR retry pattern legítimo (não
			adversarial intent).

			Channel deferred-review (async-queue): SOFT severity é
			adequada para batch review (founder revisa pattern accumulated
			em janela 12h); sustained adversarial pattern eleva via
			Phase 1+ envelope threshold para 4h synchronous-human-review
			override.

			Block scope: item-specific em todos cenários (supersede =
			evaluation específica; mark-stale = evaluation específica;
			alert transition = alert específico). NÃO global halt.

			Governance response window 12h deferred-review: tolerância
			operacional para race condition + eventual consistency lag
			comum em distributed system; HARD apenas em pattern sustained.
			"""
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "sync-human-review"
		slaDescription: "Governance response window: 2h synchronous-human-review HARD. Block scope: agent-wide HALT_AGENT (todas actions param até reconciliação domain); recovery via 4-condition protocol obrigatório (root cause + revalidation + safe replay + founder authorization). Distinto de ABORT_ACTION (action-specific)."
		recipient:      "founder"
		rationale: """
			POST-EXECUTION invariant violation: sc-rew-* audit detecta
			invariant violado APESAR de gates passing pre-emit. Examples
			per spec: score outside bounded range (sc-rew-08 violation
			post-emit); semanticHash divergence em replay (cst-3
			cst-deterministic-replay-auditable trigger); alert raised
			sem evaluation referenced (cardinality breach); supersede
			chain cycle detected; modelVersion mutation post-emit
			(immutability breach).

			DECISION local HALT_AGENT (agent-wide, NÃO action-specific)
			per spec — distinção crítica vs ABORT_ACTION. ESCALATION
			HARD imediato — DOMAIN-CORRUPTION classification.

			Channel synchronous-human-review HARD: unclassifiable indica
			zone direta de LGPD Art. 20 contestabilidade breach OR Bacen
			scrutiny exposure OR cross-BC explainability comprometida —
			julgamento humano especializado imediato; approval autônomo
			OR pattern threshold seria inaceitável.

			Block scope: agent-wide HALT (NÃO item-specific): domain
			corruption afeta agent confidence inteira — invariant pós-
			emit violado significa que gates anteriores podem ter sido
			contornados; continuar operando autonomamente em qualquer
			action é risco amplificado. Justificativa de bloqueio amplo
			per tq-gvg-10: severity tier máximo (regulatory + cross-BC
			cascade — REW score corrupt amplifica downstream CMT
			credit decisions).

			Governance response window 2h: HALT_AGENT stops sistema
			inteiro REW — atraso é throughput zero + risco cascade
			downstream. Founder canonical: 'REW é guardrail de calibração
			epistemológica; erro silencioso aqui = vetor de ataque
			amplificado cross-BC'.

			RECOVERY PROTOCOL (MANDATORY — sem isso, HALT vira pausa
			NÃO proteção): Agent permanece HALTED até ALL 4 condições
			satisfeitas SEQUENCIALMENTE:
			(1) Root cause identified — investigação humana + audit
			    trail reconciliation MUST conclude qual gate foi
			    contornado, qual sub-component falhou, OR qual evento
			    externo gerou corruption;
			(2) Invariants revalidated against canonical state — sc-rew-*
			    check re-executado contra projection canonical pós-
			    reconciliação; corruption MUST estar resolvida em domain
			    state (NÃO apenas mascarada);
			(3) SAFE STATE REPLAY EXECUTED — replay determinístico de
			    eventos post-corruption sobre canonical state revalidated;
			    verifica semanticHash equivalence DURANTE replay (não
			    apenas em snapshot estático). Previne soft-failure
			    permanente onde corruption está mascarada mas reaparece
			    em next operation;
			(4) Explicit human authorization to resume — founder
			    authorization explícita (NÃO automático; NÃO timeout-
			    based; NÃO threshold-based recovery).

			Resume requires audit trail entry: AgentResumedAfterHalt
			event com fields {haltedAt, haltCause (sc-rew-* / cst-* code
			violado), rootCauseSummary, revalidatedInvariants,
			replayValidationResults, authorizedBy='founder', resumedAt}.
			Audit trail auditável — LGPD/Bacen exigem trace completo de
			halt+resume durante operação risk decisioning.

			Recovery Phase 0: humano + audit trail; agent NÃO 'corrige'
			domain corruption (fora envelope de autonomy).
			"""
	}]

	// =============================================
	// BLAST RADIUS CAPS — 2/30 mid-band conservador (REW severity tier alto)
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 2
		maxDailyActions:        30
		rationale: """
			REW: 10 mutations per spec (act-request-risk-evaluation +
			act-supersede + act-mark-stale + act-raise-alert + act-ack-
			alert + act-resolve-alert + 4 governance-critical activate/
			deprecate model/policy). maxConcurrentMutations 2 limita
			execução paralela — risk evaluation + alert lifecycle + version
			mgmt todos com cross-BC impact (CMT-credit consumer downstream;
			cascade REW → CMT score-based decisions).

			maxDailyActions 30 (vs gateway-padrão upper-end 2/50 SSC/BDG):
			REW severity tier ALTO — guardrail de calibração epistemológica
			do sistema; cascade REW → CMT-credit; LGPD Art. 20
			contestabilidade + Bacen scrutiny exigem audit trail completo
			por evaluation. 30/dia preserva blast radius pequeno enquanto
			onboarding acumula track record. Promoção a 50+ via calibration
			crossing thresholds (validation→operational stage).

			Sanity check: 30 daily ≥ 2 concurrent ✓.

			Lifecycle×caps monotonicidade (tq-gvg-07): faixa onboarding
			canônica 1-2/20-50; 2/30 mid-band conservador (vs 2/50 upper-
			end gateway-padrão). REW severity tier ALTO (LGPD
			contestabilidade + Bacen scrutiny + cross-BC explainability +
			cascade CMT-credit) justifica posição mid-band em vez de
			upper-end gateway-padrão. Pattern paralelo INV (2/30).

			Founder framing canonical: REW é 'guardrail de calibração
			epistemológica'; cascade REW → CMT-credit reforça severity
			(score corrupt amplifica downstream credit decisions);
			conservadorismo de blast radius é axiomatic Phase 0.
			"""
	}

	// =============================================
	// DRIFT DETECTION (8 metrics — 2 OPERATIONAL + 3 HYBRID + 3 ADVERSARIAL)
	// 3 drift→action bindings declarados (replay-divergence; gate-block;
	// governance-version-change). Multi-camada per founder anti-gaming
	// (paralelo INV pattern). Phase 5.1: removida métrica
	// dm-cross-bc-evaluation-utilization-drift por violar BC isolation
	// (downstream observation NÃO é REW control plane; anti-mini-CMT).
	//
	// SCHEMA INTERPRETATION NOTE: schema field 'evaluationCadence' refere-se
	// a drift metric computation cadence (quando runtime governance layer
	// re-avalia metrics against thresholds), NÃO governance review cadence
	// (quando founder revisa drift outcomes) NEM human review cadence.
	// Para evitar ambiguidade com leitores futuros: drift compute weekly;
	// governance review event-driven via escalation routing per breach
	// detected; human review frequency declarada implicitamente via
	// slaDescription windows. Schema rename candidate: evaluationCadence →
	// driftEvaluationCadence (low-stakes ambiguity; not promoted to
	// tension-entry — apply if n=3 envelopes future readers report confusion).
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-evaluation-cycle-time"
			name:        "Tempo de Ciclo Evaluation (compute → emit)"
			description: "p95 entre cmd-request-risk-evaluation acceptance e evt-risk-evaluation-emitted observed para mesmo evaluationId em janela semanal."
			baseline:    "p95 ≤ 30 segundos em horário operacional"
			threshold:   "p95 > 5 minutos em janela semanal"
			rationale:   "[CLASS: OPERATIONAL pure] Latência elevada indica gate friction (projection lag OR signal source unavailable cross-BC). NÃO signal adversarial primário — ataque não infla latency, infla volume/pattern. Threshold 5min onboarding-conservador; reflete janela operacional CMT-credit consumer downstream."
		}, {
			code:        "dm-emit-failure-rate"
			name:        "Taxa de Emit Failure"
			description: "% cmd-request-risk-evaluation que resultam em evt-risk-evaluation-emit-failed sobre total commands accepted em janela semanal."
			baseline:    "< 0.5% emissões"
			threshold:   "> 3% janela semanal"
			rationale:   "[CLASS: OPERATIONAL pure] Emit failure rate elevada indica issue infrastructure transactional outbox OR cross-BC delivery degradation. Distinto de domain corruption (sig-rew-domain-corruption-detected critical) — emit failure é transient retry-eligible."
		}, {
			code:        "dm-supersede-rate"
			name:        "Taxa de Supersede Pattern"
			description: "% evaluations emitted que sofrem supersede dentro 24h janela semanal. Segregado por trigger (signal arrival vs replay divergence vs governance recalibration)."
			baseline:    "< 5% evaluations supersede dentro 24h"
			threshold:   "> 12% janela semanal OR > 3 supersedes same evaluationId em 24h (chain inflation pattern)"
			rationale:   "[CLASS: HYBRID op/adv] (a) operacional: signal source drift / signal arrival pattern; (b) ADVERSARIAL: supersede gaming (forçar chain growth para bypass invariants OR para mascarar pattern). Sub-threshold same-evaluationId 24h captura chain inflation."
		}, {
			code:        "dm-replay-divergence-detected"
			name:        "Replay Determinism Breach Detection (binary invariant)"
			description: "Ocorrências de semanticHash divergence detected pelo runtime governance layer replay-audit periódico — replay com mesmas (modelVersion, policyVersion, signalSnapshotIds) frozen produz semanticHash diferente do stored."
			baseline:    "0 occurrences (replay determinístico é contrato binário, NÃO degradação gradual)"
			threshold:   "ANY occurrence in weekly window — DOMAIN-CORRUPTION HARD trigger"
			rationale:   "[CLASS: ADVERSARIAL fundamental] Métrica detecta breach de invariant binário (semanticHash equivalence required per cst-3 cst-deterministic-replay-auditable). NÃO é rate estatística degradável — qualquer divergence indica violação de contrato determinístico (LGPD Art. 20 contestabilidade breach; Bacen scrutiny risk). Naming 'detected' (vs 'rate') sinaliza corretamente que semântica é binary breach, NÃO statistical degradation. Founder ajuste Section 2: NÃO log-only normalizando corrupção; block-and-escalate em cst-3 + critical signal sig-rew-replay-divergence-detected + drift→action binding suspend-and-escalate."
		}, {
			code:        "dm-alert-acknowledge-latency"
			name:        "Latência de Alert Acknowledgment"
			description: "p50 entre evt-risk-alert-raised e evt-risk-alert-acknowledged para mesmo alertId em janela semanal."
			baseline:    "p50 < 4h business-hours"
			threshold:   "p50 > 24h em janela semanal"
			rationale:   "[CLASS: OPERATIONAL pure] Latência ack elevada indica operator review backlog OR alert volume excessivo OR operator availability gap. NÃO signal adversarial primário."
		}, {
			code:        "dm-alert-resolution-completeness"
			name:        "Completude de Alert Resolution"
			description: "% alerts raised que são eventually resolved (evt-risk-alert-resolved acked) dentro 30 dias janela mensal. Segregado por alertSeverity."
			baseline:    "> 95% alerts raised → resolved within 30d"
			threshold:   "< 85% em janela mensal"
			rationale:   "[CLASS: HYBRID op/adv] (a) operacional: alert volume excessivo OR resolution capacity gap; (b) ADVERSARIAL: alert evasion pattern (atacante força raises para overwhelm resolution capacity; OR alerts são suppressed downstream)."
		}, {
			code:        "dm-structural-gate-block-rate"
			name:        "Taxa de Block Gates Pre-Execution (multi-camada detection)"
			description: "% actions disparam structural gate block (cst-* pre-emit OR sc-rew-* enforcement) sobre total actions iniciadas. Segregado por gate code + actor (signal source / asset identifier). ANÁLISE MULTI-CAMADA: total + concentration single-actor + distribuição multi-actor."
			baseline:    "< 2% total (gates safety-net; volume operacional não dispara regularmente)"
			threshold:   "DETECÇÃO DUAL: (1) > 5% total janela semanal (drift básico); (2) Single-actor concentration > 30% blocks (intra-actor probing) — 1 evaluation HARD; (3) Multi-actor distribution: ≥4 actors DISTINTOS com block-rate individual > 8% no mesmo período + total > 5% — DISTRIBUTED PROBING PATTERN — 1 evaluation HARD"
			rationale:   "[CLASS: HYBRID op/adv com adv-CRITICAL] Detecção MULTI-CAMADA paralelo INV: single-actor concentration detecta ataque simples; multi-actor distribution detecta ataque sofisticado. (a) operacional: agent confidence baixa em pre-conditions (rebate de gates = aggregate/projection drift); (b) ADVERSARIAL CRÍTICO: probing pattern coordenado mapeando boundaries antes de bypass attempt. Single-actor > 30% captura coordenação intra-actor; multi-actor distribution (≥4 actors com block individual > 8% simultâneo + total > 5%) captura DISTRIBUTED PROBING — atacante usa múltiplos signal sources cada um abaixo de 30% para evitar single-actor flag. Tolerance 1 evaluation em ambos. Statistical signal discipline tq-gvg-11: confidence threshold = concentration distributions; window = weekly; scope = actor-affected default, cluster-elevável quando distributed."
		}, {
			code:        "dm-governance-version-change-frequency"
			name:        "Frequência de Mudança Governance Versions (model + policy)"
			description: "Total de activations + deprecations (model + policy combined) em janela mensal. Consumido como signal-as-contract per ADR-075 via sig-rew-governance-version-changed payload (semanticCategory='governance-critical-activation')."
			baseline:    "≤ 1 model activation + 1 policy activation per month (governance discipline baseline)"
			threshold:   "> 3 activations OR deprecations em janela mensal (instability OR adversarial baseline shift pattern)"
			rationale:   "[CLASS: ADVERSARIAL] Mais que 3 mudanças/mês em baseline sistêmico é signal de OR instability (model/policy iterating sem stabilization) OR adversarial pattern (alguém forçando frequent baseline shifts para mascarar drift OR para evade detection). REW: baseline shift afeta ALL subsequent evaluations — cascade REW → CMT-credit decisions amplifica. Statistical signal discipline tq-gvg-11: window = monthly (governance versioning operates monthly cadence); scope = global (governance affects all evaluations); threshold sustained 1 breach evaluation."
		}]
		rationale: """
			8 drift metrics organizadas em 3 classes:
			- OPERATIONAL pure (2): dm-evaluation-cycle-time + dm-emit-
			  failure-rate — latência + emit infrastructure health.
			- HYBRID op/adv (3): dm-supersede-rate + dm-alert-resolution-
			  completeness + dm-structural-gate-block-rate — operacional
			  baseline mas com camada adversarial detection (gaming
			  patterns).
			- ADVERSARIAL fundamental (3): dm-replay-divergence-detected
			  (binary contract integrity) + dm-governance-version-change-
			  frequency (baseline manipulation) + (combined via regression
			  trigger 8 'weak + weak = strong').

			Phase 5.1 CORRECTION: dm-cross-bc-evaluation-utilization-drift
			removida (versão inicial inadvertidamente incluía downstream
			observation que viola envelope-is-control-plane tq-gvg-09 +
			anti-mini-CMT + REW BC isolation que termina em evt-risk-
			evaluation-emitted). Downstream consumer behavior é jurisdição
			CMT/SCF, NÃO REW agent — métrica vazada do pattern INV
			(que tem cross-BC observation legítima de receivable
			realization) sem verificação de consistência com REW BC scope.

			DRIFT→ACTION BINDINGS (3 automatic enforcement per tq-gvg-06)
			— bindings materializados via #RegressionTrigger.immediateAction
			schema field, com additional runtime governance layer actions
			documented em respective trigger rationales:

			(1) dm-replay-divergence-detected > 0:
			    → schema action: suspend-and-escalate (regression trigger 2)
			    → runtime governance layer additional: throttle act-request-
			      risk-evaluation cap → 50%; block act-supersede-risk-
			      evaluation até root cause + replay revalidation;
			    → escalation route: unclassifiable-anomaly (HALT_AGENT +
			      4-condition recovery protocol);
			    → critical signal: sig-rew-replay-divergence-detected.

			(2) dm-structural-gate-block-rate single-actor > 30% OR multi-
			    actor distributed:
			    → schema action: suspend-and-escalate (regression trigger 4)
			    → runtime governance layer additional: throttle agent overall
			      cap → 50% durante investigação;
			    → escalation route: suspicious-input (VERIFIED).

			(3) dm-governance-version-change-frequency > 3/month:
			    → schema action: suspend-and-escalate (regression trigger 6)
			    → runtime governance layer additional: block governance-
			      critical actions até founder review;
			    → escalation route: suspicious-input (VERIFIED).

			Statistical signal discipline tq-gvg-11 aplicada por classe:
			ADVERSARIAL metrics declaram confidence threshold + window +
			scope contention explicitly (dm-replay-divergence-detected
			binary tolerance ZERO; demais com sustained breach thresholds).
			OPERATIONAL metrics não exigem discipline statistical avançada
			(deterministic operational thresholds).
			"""
	}

	// =============================================
	// CALIBRATION (promotion + regression with anti-gaming embedded +
	// realization tracking GUARDRAIL EPISTEMOLÓGICO anti-Goodhart)
	// =============================================

	calibration: {
		promotionCriteria: [{
			description: "Promoção onboarding → validation"
			metric: """
				≥ 20 risk evaluations emitted+superseded+stale combined
				AND ZERO replay divergence (dm-replay-divergence-detected == 0 sustained)
				AND ZERO sc-rew-* violation post-emit (todos PASSING em audit)
				AND ZERO unclassifiable-anomaly em observation period
				AND taxa aprovação ≥ 97% em mutations propose-and-wait
				AND supervisor-override-rate ≤ 8% sustentado
				AND COVERAGE: evaluations cobrem ≥ 5 model versions distintas em ≥ 3 policy versions distintas
				AND alert lifecycle completeness ≥ 95% (raised → ack → resolved closed)
				"""
			minimumObservationPeriod: "60 days"
			rationale: """
				ANTI-GAMING criteria embedded: (1) COVERAGE multi-version
				evita single-version gaming (atacante operando 1 caso fácil
				sem variabilidade); (2) ZERO replay divergence valida cst-3
				contrato binário (LGPD Art. 20 contestabilidade); (3) ZERO
				unclassifiable-anomaly valida domain integrity sustained;
				(4) supervisor-override ≤ 8% intermediário (entre baseline
				10% e drift threshold 20%) — exige operação aproximando
				target sem ainda atingir.
				20 evaluations em 60 days = volume mínimo para track record
				REW pré-PMF. 97% approval reflete severity tier alto
				(LGPD + Bacen + cross-BC explainability).
				"""
		}, {
			description: "Promoção validation → operational"
			metric: """
				≥ 60 risk evaluations emitted+superseded+stale combined
				AND ZERO replay divergence sustained 8 weeks
				AND ZERO sc-rew-* violation sustained
				AND taxa aprovação ≥ 99%
				AND supervisor-override-rate ≤ 5% sustentado por 8 semanas
				AND COVERAGE: ≥ 10 model versions × ≥ 5 policy versions; ≥ 8 distinct asset clusters
				AND audit trail reconstrução bem-sucedida amostra 10 evaluations (semanticHash + signalSnapshotIds + version freeze verificáveis)
				"""
			minimumObservationPeriod: "90 days"
			rationale: """
				Critérios escalados: volume 60 (vs 20), approval 99% (vs 97%),
				override ≤ 5% (vs 8%), coverage ampliada (10 model × 5 policy
				× 8 asset clusters). 90 days exposição múltiplos governance
				versioning cycles. Audit trail reconstrução é ANTI-GAMING
				crítico — LGPD Art. 20 contestabilidade exige reconstituição
				completa; gating promotion em reconstrução real previne
				'parecer auditável' sem ser.

				EXTERNAL AUDIT GATE (Phase 5.1 corrected — anti-Goodhart
				preservado via channel separation): promoção
				validation→operational adicionalmente requer audit gate
				externo executado FORA do REW agent control plane —
				processo de audit independente consome CMT/SCF default
				events + correlaciona com REW evaluations REJECT
				downstream + valida que decisões calibraram contra
				realidade observável. REW agent NÃO observa defaults
				(downstream observation viola BC isolation + anti-mini-
				CMT); audit gate é HUMAN-DRIVEN review com evidence
				externa, executado a cada promotion attempt. Founder
				framing canonical preserved: 'epistemic validation ≠
				reward shaping'; 'guardrail epistemológico, NÃO reward
				function'. CORREÇÃO Phase 5.1: versão inicial colocou
				realization tracking como metric do agent — incorreto,
				agent não observa defaults. Realization tracking
				rebatizada como external audit channel separada do
				runtime decision path (agent computa via signal + version
				frozen; audit observa fora-de-banda).
				"""
		}]
		regressionTriggers: [{
			description:     "Violação autonomy boundary (P10 invariant)"
			metric:          "Qualquer action executada fora autonomyLevel declarado em spec OR override"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Tolerance-zero per P10. REW: violação inclui emit sem signal-trace; supersede pre-emit; governance-critical action sem escalation pre-execução; ABORT_ACTION ignorado e action prosseguindo. suspend-and-escalate — agent NÃO pode operar enquanto causa não identificada."
		}, {
			description:     "Replay divergence HARD (DOMAIN-CORRUPTION binary)"
			metric:          "dm-replay-divergence-detected > 0 (qualquer ocorrência)"
			threshold:       "1 evaluation"
			immediateAction: "suspend-and-escalate"
			rationale:       "TIER MÁXIMO — LGPD Art. 20 contestabilidade breach; Bacen scrutiny risk; cross-BC explainability comprometida. Tolerance 1 evaluation reflete severity binary: 1 divergence indica decisão computada não reproduzível, contrato cst-3 violado. Drift→action binding (1) materializado: schema action suspend-and-escalate + runtime governance layer additional throttle + block supersede + escalation route unclassifiable-anomaly (HALT_AGENT + recovery protocol)."
		}, {
			description:     "Domain corruption post-emit detected"
			metric:          "sig-rew-domain-corruption-detected emitted (qualquer)"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "HALT_AGENT trigger per escalation route unclassifiable-anomaly. Recovery via 4-condition protocol obrigatório (root cause + invariants revalidated + safe state replay executed + explicit human authorization). DOMAIN-CORRUPTION afeta agent confidence inteira."
		}, {
			description:     "Gate-block concentration OR distributed probing"
			metric:          "dm-structural-gate-block-rate viola: single-actor concentration > 30% OR multi-actor distribution (≥ 4 actors com block individual > 8% + total > 5%)"
			threshold:       "1 evaluation"
			immediateAction: "suspend-and-escalate"
			rationale:       "Probe pattern coordenado (intra-actor OR distributed) — paralelo INV. REW: actor pode estar tentando mapear thresholds antes de gaming attempt; severity tier alto justifica halt vs reduce-autonomy gradual. Drift→action binding (2) materializado: schema action suspend-and-escalate + runtime governance layer additional throttle agent overall cap → 50%."
		}, {
			description:     "Cap breach blast radius"
			metric:          "maxConcurrentMutations OR maxDailyActions excedido"
			threshold:       "1 ocorrência em janela 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach amplifica risco LGPD audit gap + cascade CMT-credit decisions degraded. Reduce-autonomy enquanto causa investigada (cap subdimensionado vs comportamento anômalo)."
		}, {
			description:     "Governance-critical activation rate breach"
			metric:          "dm-governance-version-change-frequency > 3 activations OR deprecations em janela mensal"
			threshold:       "1 breach in monthly evaluation window"
			immediateAction: "suspend-and-escalate"
			rationale:       "Mais que 3 mudanças/mês em baseline sistêmico é signal de OR instability (model/policy iterating sem stabilization) OR adversarial pattern (alguém forçando frequent baseline shifts para mascarar drift OR para evade detection). REW: baseline shift afeta ALL subsequent evaluations — cascade REW → CMT-credit decisions amplifica. Drift→action binding (3) materializado: schema action suspend-and-escalate + runtime governance layer additional block governance-critical actions até founder review."
		}, {
			description:     "Sustained supersede pattern"
			metric:          "dm-supersede-rate > 12% janela semanal OR > 3 supersedes same evaluationId 24h"
			threshold:       "2 evaluations consecutivas (semanais)"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained high supersede rate indica OR signal source drift (eventual consistency lag amplificada) OR adversarial supersede gaming (forçar chain growth para bypass invariants OR para mascarar pattern). reduce-autonomy 1 level por 2 weeks enquanto causa investigada."
		}, {
			description:     "Combined adversarial signal (founder 'weak + weak = strong')"
			metric:          "≥ 2 métricas classificadas adversarial OR hybrid simultâneas violadas em janela mensal: dm-replay-divergence-detected (any) OR dm-structural-gate-block-rate (concentration OR distributed) OR dm-supersede-rate breach OR dm-governance-version-change-frequency breach"
			threshold:       "1 breach in monthly evaluation window"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Per founder canonical: 'ataques reais quase nunca aparecem
				em UMA métrica só; aparecem em combinações; weak signal +
				weak signal = strong signal'. Upgrade automático para
				suspend (não reduce-autonomy) reconhece que 2 sinais
				adversariais simultâneos é evidência de pattern coordenado,
				NÃO ruído operacional independente.
				Cobertura combos REW (4 métricas observáveis pelo agent):
				- replay-divergence + gate-block (probing pré-bypass);
				- supersede-rate + gate-block (chain inflation + probing);
				- governance-change + replay-divergence (model manipulation
				  para forçar baseline shift covering divergence);
				- supersede-rate + governance-change (recalibration timing
				  abuse).
				Phase 5.1 CORRECTION: removidas combos com
				dm-cross-bc-evaluation-utilization-drift (métrica removida
				per BC isolation). Cross-BC downstream gaming detection é
				responsabilidade de processo de audit externo, NÃO REW
				agent control plane.
				"""
		}]
		rationale: """
			Promoção 2 estágios: 20/60 onboarding→validation com 4 anti-
			gaming criteria embedded (coverage multi-version; ZERO replay
			divergence binary; ZERO unclassifiable; supervisor-override
			intermediário); 60/90 validation→operational com escalation
			ampla + audit trail reconstrução real + realization tracking
			via downstream CMT real outcome (GUARDRAIL EPISTEMOLÓGICO
			anti-Goodhart).

			8 regression triggers Phase 0: P10 boundary tolerance-zero
			(suspend); replay divergence HARD 1 evaluation (suspend; TIER
			MÁXIMO LGPD contract integrity); domain corruption post-emit
			(suspend → HALT_AGENT via unclassifiable-anomaly route); gate-
			block concentration OR distributed (suspend; probe pattern);
			cap breach (reduce); governance-critical activation rate breach
			(suspend); sustained supersede pattern (reduce); COMBINED
			ADVERSARIAL SIGNAL — ≥ 2 métricas adversarial/hybrid simultâneas
			(suspend per founder canonical 'weak + weak = strong').

			Calibração CONSERVADORA per REW severity tier alto — guardrail
			de calibração epistemológica do sistema; cascade REW → CMT-
			credit decisions; LGPD Art. 20 contestabilidade + Bacen
			scrutiny + cross-BC explainability priorizam safety sobre
			throughput axiomático.
			"""
	}

	// =============================================
	// FAILURE HANDLING (3 events; respeitam gates, não contornam —
	// anti-bypass discipline per founder canonical)
	// =============================================

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno agent (exception, comportamento não-determinístico em gate evaluation, signal validation logic failure): halt operations imediato; founder root cause analysis antes resume. REW severity tier alto — agent não-determinístico em risk decisioning compromete LGPD Art. 20 contestabilidade + cascade CMT-credit decisions. NÃO retry — erro estrutural, não transient."
		}
		onTimeout: {
			action: "suspend-and-escalate"
			retryPolicy: """
				DIFERENCIADO por escopo per founder discipline 'retry mínimo
				para diferenciar infra failure vs domain inconsistency':
				(1) Queries projection intra-BC (prj-active-risk-evaluations
				    / prj-active-risk-alerts): max 1 retry com exponential
				    backoff (initial 2s) — projection eventual consistency
				    tolerável;
				(2) sc-rew-* audit timeout (post-emit invariant check):
				    SEM RETRY — bug determinístico em audit logic; suspend
				    imediato.

				Phase 5.1 CORRECTION: removido cross-BC signal source retry
				(versão inicial herdou pattern INV que tem sync queries
				cross-BC para CMT regime). REW agent NÃO query cross-BC
				durante evaluation — signals chegam push-based via ACL
				pre-ingestion (spec.cst-14 acl-boundary-acknowledged).
				Signal absence durante evaluation = insufficient-context
				route (sem retry cross-BC), per discipline ACL push-based.
				"""
			description: "Timeout split per founder discipline. Intra-BC projection: 1 retry exponential (transient lag tolerável). Audit logic timeout: ZERO retry — não diferenciar entre bug e flakiness em gate evaluation; suspend imediato. ANTI-BYPASS CRITICAL: retry NUNCA contorna gates — gate failure é gate failure independente de retry; retry é APENAS para query infrastructure flakiness intra-BC, JAMAIS para gate evaluation OR invariant check OR cross-BC operations (ACL push-based; signal absence vira insufficient-context route, não retry)."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h indica issue sistêmico (signal source sustained degradation OR projection corrompida OR audit logic bug OR cross-BC reconciliation impossible). Suspend + immediate founder notification. REW NÃO tolera operação degraded sustentada — amplifica risco LGPD audit gap + cascade CMT-credit decisions degraded."
		}
		rationale: """
			Per adr-058 promotion tech debt narrative → field first-class.
			REW severity tier ALTO (LGPD Art. 20 contestabilidade + Bacen
			scrutiny + cross-BC explainability + cascade CMT-credit):
			- suspend-and-escalate em todos 3 events Phase 0 default
			- retry conservador em onTimeout APENAS queries projection
			  intra-BC (NUNCA cross-BC; NUNCA gate evaluation OR invariant
			  check; signal absence cross-BC = insufficient-context route)
			- 3/24h threshold paralelo INV/SSC/BDG tier alto

			ANTI-BYPASS DISCIPLINE per founder canonical: failureHandling
			NUNCA contorna gates — retry é APENAS para query infrastructure
			flakiness intra-BC, JAMAIS para gate evaluation OR invariant
			check OR cross-BC operations. Gate failure suspende; retry
			não 'salva' gate. P10 preserved: gates determinísticos validam
			sem ser bypassáveis via retry/timeout fallback.

			Phase 5.1 CORRECTION: removido cross-BC retry policy (versão
			inicial herdou de INV pattern sync queries cross-BC). REW
			discipline ACL push-based per spec.cst-14 — agent NÃO query
			cross-BC durante evaluation; cross-BC signal absence =
			insufficient-context route imediato (sem retry).
			"""
	}

	// =============================================
	// ENVELOPE-LEVEL RATIONALE (closing — cross-section discipline +
	// schema interpretation ten-012 reference)
	// =============================================

	rationale: """
		Envelope governança agt-rew-primary lifecycle onboarding. REW é
		guardrail de calibração epistemológica do sistema (cascade REW →
		CMT-credit decisions; LGPD Art. 20 contestabilidade + Bacen
		scrutiny + cross-BC explainability via replay determinístico).

		**Conceito central** (paralelo INV 'guardrail do ponto onde sistema
		cria dinheiro'): REW é guardrail do ponto onde sistema calibra
		confiança. Cascade REW (bounded score) → CMT (credit decision) →
		asset access. Replay divergence = LGPD contestabilidade breach
		cascading downstream.

		**BIDIRECTIONAL REF VALIDATED** (tq-gv-06): agent-spec.code
		'agt-rew-primary' == envelope.agentRef; agent-spec.governanceRef
		'rew-primary-agent' == base name deste arquivo (sem .governance.cue
		suffix).

		**ESCALATION ROUTING**: 5 routes cobrindo 5 spec.escalationConditions
		categories (tq-gvg-02 coverage). 2 routes com sub-routing splits
		via rationale (suspicious-input UNCERTAIN/VERIFIED; out-of-scope
		replay-default/sustained-pattern override).

		**ROUTING PRECEDENCE CANONICAL** (5-tier; resolve conflicts entre
		simultaneous matches in the runtime governance layer — sem isso,
		múltiplas implementações divergiriam em comportamento):
		1. unclassifiable-anomaly (HALT_AGENT) — highest precedence
		2. conflicting-signals (synchronous-human-review) OR
		   suspicious-input VERIFIED (synchronous-human-review override)
		3. suspicious-input UNCERTAIN (blocking-alert)
		4. insufficient-context (blocking-alert)
		5. out-of-scope (deferred-review) — lowest precedence
		Rule: highest precedence match wins; audit trail registra TODAS
		categories matched + qual foi aplicada (rastreabilidade preservada).

		**MULTI-MATCH RESOLUTION RULE**: se múltiplas categories são
		acionadas simultaneamente em um mesmo evento — aplicar SEMPRE a
		de maior precedência; ignorar side-effects das demais (no double
		escalation; no double routing; no race conditions). Garante
		determinismo global no runtime governance layer.

		**SCOPE ELEVATION RULE** (aplicável a suspicious-input):
		- Default scope: actor-affected (signal source / asset identifier
		  em janela detecção).
		- Elevate to cluster-affected WHEN: ≥2 distinct actors involved
		  within time window OR repeated suspicious-input across linked
		  counterparties (anti-coordinated-fraud).

		**UNKNOWN EVENT SAFETY RULE** (honesty arquitetural recursive —
		'o que quebra sistemas não é o conhecido; é o que não foi
		modelado'): qualquer SEMANTIC/DOMAIN/GOVERNANCE event observed
		within the modeled governance surface (spec.escalationConditions[]
		.category coverage / driftDetection.metrics coverage /
		failureHandling events coverage) que NÃO mapeia para nenhuma
		categoria modelada — MUST ser classified como unclassifiable-
		anomaly por DEFAULT → HALT_AGENT obrigatório (recovery protocol
		4-condition).

		Infrastructure telemetry outside the modeled governance surface
		is EXCLUDED unless linked to mutation/result/invariant/governance
		transition. Runtime metrics não-governance (memory utilization,
		CPU latency, network throughput outside drift compute window)
		NÃO disparam HALT por se default — observability runtime tem
		ownership separada do governance envelope. Governance surface
		coverage é deliberadamente restrita a semantic/domain/governance
		events; expansion para infrastructure telemetry exigiria ADR
		dedicated (anti-pattern: HALT por noise infrastructure).

		**HALT_AGENT RECOVERY PROTOCOL** (4-condition sequential — sem
		isso, HALT vira pausa, NÃO proteção):
		(1) Root cause identified — investigação humana + audit trail
		    reconciliation; qual gate foi contornado, qual sub-component
		    falhou, OR qual evento externo gerou corruption;
		(2) Invariants revalidated against canonical state — sc-rew-*
		    re-execução contra projection canonical pós-reconciliação;
		(3) SAFE STATE REPLAY EXECUTED — replay determinístico de
		    eventos post-corruption sobre canonical state revalidated;
		    verifica semanticHash equivalence DURANTE replay (previne
		    soft-failure permanente);
		(4) Explicit human authorization to resume — founder authorization
		    explícita (NÃO automático; NÃO timeout-based).
		Audit trail event AgentResumedAfterHalt mandatory com fields
		{haltedAt, haltCause (sc-rew-* / cst-* code violado),
		rootCauseSummary, revalidatedInvariants, replayValidationResults,
		authorizedBy='founder', resumedAt}.

		**BLAST RADIUS CAPS**: 2/30 mid-band conservador (faixa onboarding
		canônica 1-2/20-50; vs gateway-padrão SSC/BDG upper-end 2/50).
		REW severity tier ALTO (LGPD contestabilidade + Bacen scrutiny +
		cascade CMT-credit) justifica posição mid-band. Sanity check:
		30 daily ≥ 2 concurrent ✓; lifecycleStage×caps monotonicidade
		tq-gvg-07 ✓. Pattern paralelo INV (2/30).

		**DRIFT DETECTION**: 8 metrics com classification op/hybrid/adv
		(2 OPERATIONAL pure / 3 HYBRID / 3 ADVERSARIAL). Detecção multi-
		camada paralelo INV pattern (escopo intra-BC apenas — REW
		observa próprios emit + lifecycle + governance versioning;
		downstream consumer behavior é jurisdição CMT/SCF):
		- Replay divergence (dm-replay-divergence-detected — binary breach
		  detector, NÃO statistical rate; tolerance ZERO; LGPD Art. 20
		  contract integrity);
		- Gate-block multi-camada (single-actor concentration + multi-
		  actor distributed probing);
		- Governance version churn frequency (anti-instability +
		  anti-adversarial-baseline-shift).
		Drift compute cadence weekly (SCHEMA INTERPRETATION NOTE inline
		no driftDetection block clarifica vs governance review cadence
		vs human review cadence).

		Phase 5.1 CORRECTION: removida dm-cross-bc-evaluation-utilization-
		drift (versão inicial herdou observation downstream do INV
		pattern, viola REW BC isolation + anti-mini-CMT + envelope-is-
		control-plane). Downstream gaming detection é responsabilidade
		de processo de audit externo, NÃO REW agent.

		**3 DRIFT→ACTION BINDINGS** (automatic enforcement per tq-gvg-06,
		materializadas via #RegressionTrigger.immediateAction schema field
		+ runtime governance layer additional actions documentadas em
		respective trigger rationales):
		- dm-replay-divergence-detected > 0 → schema action suspend-and-
		  escalate (trigger 2) + runtime governance layer throttle act-
		  request-risk-evaluation cap → 50% + block act-supersede until
		  replay revalidation + sync HARD escalation via unclassifiable-
		  anomaly route;
		- gate-block concentration OR distributed → schema action
		  suspend-and-escalate (trigger 4) + runtime governance layer
		  throttle agent overall cap → 50% + escalation suspicious-input
		  VERIFIED route;
		- governance-version-change > 3/month → schema action suspend-
		  and-escalate (trigger 6) + runtime governance layer block
		  governance-critical actions até founder review + escalation
		  suspicious-input VERIFIED route.

		**CALIBRATION**: 20/60 onboarding→validation + 60/90 validation→
		operational com anti-gaming criteria embedded (coverage multi-
		version; ZERO replay divergence binary; ZERO unclassifiable;
		audit trail reconstrução real). Validation→operational
		adicionalmente requer EXTERNAL audit gate (Phase 5.1 corrected
		— processo independente fora do REW control plane consome
		CMT/SCF default events + correlaciona com REW evaluations
		REJECT downstream).

		**ANTI-GOODHART via EXTERNAL AUDIT CHANNEL** (Phase 5.1 corrected
		— founder ajuste crítico preservado): realization tracking via
		downstream CMT default observation existe como GUARDRAIL
		EPISTEMOLÓGICO validando que decisões calibram contra realidade
		observável — MAS observation channel está fora do REW agent
		(audit externo, NÃO drift metric do envelope). NÃO é target
		operacional de otimização — agent NÃO deve otimizar 'default
		rate' como métrica de performance (anti-pattern: optimizing
		for low default rate produz over-conservative decisions which
		harm credit access; over-rejection = miscalibration tipo).
		Founder framing canonical preserved: 'epistemic validation ≠
		reward shaping'; 'guardrail epistemológico, NÃO reward function'.
		Realization informa external audit gate em promotion
		validation→operational, NÃO runtime decision-making, NÃO drift
		metric do envelope — agent computa via signal + version frozen;
		realization é post-hoc validation completamente desacoplada do
		runtime decision path AND do envelope control plane.

		CORREÇÃO Phase 5.1 (relativo à versão inicial): realization
		tracking estava como metric em promotionCriteria 2 (incorreto
		— REW agent NÃO observa defaults downstream; viola BC
		isolation). Reframado como external audit gate executado por
		processo independente. Conceito anti-Goodhart preservado;
		observation channel separated from REW agent control plane.

		**REGRESSION TRIGGERS** (8 incluindo combined adversarial signal):
		P10 boundary tolerance-zero (suspend); replay divergence HARD 1
		evaluation (suspend; TIER MÁXIMO LGPD contract integrity); domain
		corruption post-emit (HALT_AGENT via unclassifiable-anomaly
		route); gate-block concentration OR distributed (suspend); cap
		breach (reduce); governance-critical activation rate breach
		(suspend); sustained supersede pattern (reduce); COMBINED
		ADVERSARIAL SIGNAL 'weak + weak = strong' (suspend) — combos
		cobertura (Phase 5.1 corrected, intra-BC observations apenas):
		replay-divergence + gate-block (probing pré-bypass); supersede-
		rate + gate-block (chain inflation + probing); governance-change
		+ replay-divergence (model manipulation); supersede-rate +
		governance-change (recalibration timing abuse).

		**FAILURE HANDLING** (adr-058 first-class): suspend-and-escalate
		em 3 events. Retry diferenciado: intra-BC projection 1 retry
		exponential; audit logic ZERO retry. ANTI-BYPASS DISCIPLINE per
		founder canonical: retry NUNCA contorna gates — gate failure
		suspende, retry NÃO 'salva' gate. P10 preserved unconditionally;
		retry é APENAS para query infrastructure flakiness intra-BC,
		JAMAIS para gate evaluation OR invariant check OR cross-BC
		operations (ACL push-based per cst-14 — signal absence vira
		insufficient-context route, NÃO retry cross-BC).

		Phase 5.1 CORRECTION: removido cross-BC retry policy (versão
		inicial herdou de INV pattern sync queries cross-BC); REW
		discipline ACL push-based per spec.cst-14 acl-boundary-
		acknowledged.

		**AUTONOMY OVERRIDES**: empty Phase 0. Promotion via calibration
		crossing thresholds — tq-gv-14 forbid execute-and-log override
		direto a mutations preserva P10 unconditional. Governance-critical
		activation discipline (cst-13 do spec) materializada via 4
		mecanismos:
		(a) dm-governance-version-change-frequency metric (drift detection);
		(b) regression trigger 6 (governance-critical activation rate
		    breach);
		(c) este rationale declara que escalation event PRE-execução é
		    mandatory para 4 governance-critical actions (act-activate-
		    risk-model + act-deprecate-risk-model + act-activate-risk-
		    policy + act-deprecate-risk-policy);
		(d) semanticCategory='governance-critical-activation' preservada
		    em sig-rew-governance-version-changed payload (signal-as-
		    contract per ADR-075).
		NÃO via autonomyOverride retroativo (anti-pattern: override é tool
		de calibração, não substituto de spec discipline).

		**ENVELOPE-IS-CONTROL-PLANE** (tq-gvg-09): envelope contém APENAS
		routing + caps + calibration + drift + lifecycle + failureHandling
		(control plane). Nenhuma business logic vazada — invariants Risk
		Evaluation/Alert + bounded score boundaries + replay determinismo
		contracts + structural gates + audit invariants + signal validation
		+ lifecycle state machines + version freeze + model/policy
		separation vivem em agent-spec.constraints + structural-checks
		Phase 3.5a + domain-model. Envelope governa, não decide negócio.

		**SCHEMA INTERPRETATION REFERENCE** (per ten-012):
		Schema #EscalationRoute carrega field names que sugerem runtime
		semantics (slaDescription, channel enum values 'async-queue' /
		'alert-and-block'). Interpretação canônica neste envelope:
		- slaDescription = governance response window (NOT operational SLA)
		- channel.sync-human-review = synchronous-human-review mode
		- channel.async-queue = deferred-review mode (NOT queue transport)
		- channel.alert-and-block = blocking-alert mode (NOT alerting infra)
		- channel.alert-and-continue = non-blocking-alert mode
		Schema rename deferred to ADR + 9-envelope migration per ten-012
		(status: accepted; trigger n=3 future envelopes confusion OR
		founder priority decision).

		**CROSS-ARTIFACT DEPENDENCIES**:
		- agent-spec contexts/rew/agents/rew-primary-agent.cue (sibling;
		  bidirectional ref validated tq-gv-06).
		- structural-checks Phase 3.5a sc-rew-01..15 (runtime governance
		  layer replay-audit + sc-rew-08 bounded-score audit consumed por
		  dm-replay-divergence-detected + dm-structural-gate-block-rate
		  triggers).
		- ACL boundary (CMT/SSC/DLV signals push-based pre-ingestion):
		  signal sources identificados em spec cst-14 acl-boundary-
		  acknowledged; envelope NÃO declara retry cross-BC (Phase 5.1
		  corrected — ACL é push, não pull; signal absence vira
		  insufficient-context route).
		- External audit channel (Phase 5.1 added): processo independente
		  fora do REW control plane consome CMT/SCF default events +
		  correlaciona com REW evaluations REJECT downstream + alimenta
		  promotion validation→operational gate via human review. REW
		  agent NÃO observa downstream behavior — audit channel é
		  separated by design.

		**FORWARD-REFS Phase N+1 deferrals**:
		- governanceGlobalVersion '0.1' forward-ref canônico (Phase 0;
		  per cmt/ctr/idc/npm/bdg/ssc/dlv/inv pattern); upgrade quando
		  global #AgentGovernanceGlobal materializado em architecture/
		  agent-governance.cue.
		- Schema field renames pending per ten-012 (low-stakes ambiguity;
		  trigger-based reabertura).
		- Realization tracking telemetry feedback loop consumindo CMT
		  downstream real default observations — operacional Phase N+1.

		Pattern paralelo INV/DLV/CTR primary agent envelope discipline;
		REW é segundo envelope consumindo structural-checks Phase 3.5
		(kind domain-invariant per ADR-080) após INV — sets pattern
		continuity para backfill cross-BC. Primeira instância completa
		do pattern decision-systems-with-truth-boundaries per adr-085 +
		lens-truth-boundaries (post-INV extraction).
		"""
}
