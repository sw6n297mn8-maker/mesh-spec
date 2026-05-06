package dlv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// dlv-primary-agent.governance.cue — Governance Envelope: DLV Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do DLV (BC quinto
// do macrofluxo Mesh: SSC → {P2P, CTR} → CMT → BDG → DLV → INV → FCE).
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, calibração de autonomia, e failure
// handling. Phase 5 do WI-042 DLV bootstrap pos-canvas + glossary +
// domain-model + agent-spec.
//
// Fronteira com agent-spec (dlv-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode
//   override (Phase 0: nenhum override declarado — preserva autonomous
//   defaults per founder mapping ajuste 'autonomia é DEFAULT; override
//   é EXCEÇÃO via escalation/config — NÃO redução por padrão')
// - agent-spec declara observability signals → este envelope define
//   drift thresholds + scopedBySignal references via signal-as-contract
//   pattern (per adr-075 Caminho D')
//
// Envelope antifragility model (founder 4 blocos pre-write Phase 5):
//
// BLOCK 1 — AutonomyOverrides (types + scope):
// Override muda QUEM decide, NUNCA o que é decidido. 5 types
// disponíveis Phase 0+ (instâncias materializadas via founder
// calibration quando triggers fire — Phase 0 baseline NENHUM
// override declarado per founder mapping):
// - force-supervised-ingestion (scope: flow): RecordEvidence vira
//   propose-and-wait; trigger: integrity-failure rate spike per Metric 5;
//   FECHA vetor de ataque mais crítico (entrada do sistema) per
//   founder ajuste 1 obrigatório Phase 5 conceptual review.
// - disable-autonomous-emit (scope: flow): bloqueia act-emit-terminal
//   autonomous; trigger: tripwire violation OR sustained metric breach;
//   supervised propose-and-wait CONTINUA.
// - require-supervised-evaluation (scope: flow): act-evaluate-verification
//   vira propose-and-wait per evaluation; trigger: criteria-override-rate
//   sustained breach.
// - block-specific-commitment (scope: commitment): bloqueia DLV
//   operations on (commitmentRef, evidenceRef) específica; trigger:
//   regulatory case 1 OR DRC dispute trigger; supervised override
//   possível.
// - restrict-criteria-version (scope: criteria class): suspende
//   evaluations sob criteriaVersion class; trigger: regulatory case 2
//   systemic.
//
// BLOCK 2 — EscalationMap (trigger → destination → action):
// 5 routes mapeadas para 5 escalationConditions agent-spec; cada com
// overridePolicy explícita (none | optional | mandatory) per founder
// refinement Phase 5: trigger → ação determinística (NÃO implícita).
//
// BLOCK 3 — Reconciliation (estados + transitions):
// Per founder refinement Phase 5: simplificado para pending → resolved
// | expired; expired → escalated (auto); escalated → resolved (único
// caminho de saída). Pending sustained > 14d aparece em OBS metric
// pending-reconciliation-rate (M4 founder ajuste Phase 1.5 reinforced).
//
// BLOCK 4 — FreezeModel (types + scope + effects):
// 3 freeze types: tripwire-freeze (autonomous-emit-pipeline ONLY) +
// commitment-scoped-freeze (specific identity) + criteria-class-freeze
// (criteriaVersion class). REGRA UNIVERSAL: freeze NUNCA bloqueia
// supervised path (deadlock prevention). Per founder ajuste 2
// obrigatório Phase 5: tripwire-freeze ALSO previne terminal-ready
// accumulation (evaluation pode rodar MAS não pode produzir estado
// terminal consumível) — evita backlog silencioso de decisões "quase
// publicadas".
//
// 5 ajustes founder mapping pre-write (agent-spec Phase 4) referenciados:
// (1) atomic emit via primitive — failureHandling.onAgentError suspend-
//     and-escalate cobre quando primitive falha;
// (2) supersession event-handler — pol-supersession-applied-handler
//     domain-model é triggered, agent reage; envelope NÃO override
//     supersession path;
// (3) escalation default no autonomy reduction — Phase 0 autonomyOverrides
//     vazio; mandatory artifact ordering tension/deferred/ADR via
//     escalationRouting actions;
// (4) tripwire FREEZE scope — failureHandling onAgentError suspend +
//     calibration regressionTriggers tripwire-violation suspend-and-
//     escalate (action targeted, NÃO global);
// (5) regulatory 2 levels — escalationRouting unclassifiable-anomaly
//     route handles case 1 local; case 2 systemic via reduce-autonomy +
//     restrict-criteria-version override (founder calibration adjustment).
//
// 2 ajustes obrigatórios + 3 refinamentos founder Phase 5 conceptual
// review aplicados:
// - OBRIGATÓRIO 1: force-supervised-ingestion override declared como
//   override type disponível (rationale Block 1).
// - OBRIGATÓRIO 2: tripwire-freeze previne terminal-ready accumulation
//   (rationale Block 4 + failureHandling.onAgentError description).
// - REFINAMENTO 3: reconciliation transitions simplificadas (Block 3).
// - REFINAMENTO 4: governance-review Phase 0 → founder + ADR mandatory
//   artifact (escalationRouting unclassifiable-anomaly route).
// - REFINAMENTO 5: overridePolicy per escalation declarada explícita
//   (mandatory para tripwire/regulatory; optional para rate-based;
//   none para queries/audit).
//
// Phase 0 caveats:
// - governanceGlobalVersion "0.1" forward-ref canônico (per cmt/ctr/
//   idc/npm/bdg/ssc/p2p).
// - Nenhum autonomyOverride: Phase 0 baseline preserva autonomous
//   defaults per agent-spec — supervised channels operacionalizadas
//   via propose-and-wait per spec; founder calibration adjustments
//   futuros podem materializar override types per Block 1.
// - 4 supervised paths agent-spec (act-propose-emergency-override +
//   act-propose-post-finality-supersession + act-propose-criteria-
//   version-override + act-propose-exception-extension + act-propose-
//   re-evaluation + act-propose-revert-auto-rejection) operacionalmente
//   founder único approver Phase 0; tier separation Phase 1+.
// - Reconciliation manual Phase 0; auto-trigger Phase 1+ via OBS infra.
// - Schema limitations Phase 0 acknowledged via def-013 + def-014:
//   payloadSchema typing + ClearanceCondition variants extensions +
//   runtime evaluation engine como separação arquitetural por design.

dlvPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-dlv-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING (5 routes — match spec.escalationConditions)
	// Cada route declara overridePolicy explícita per founder Phase 5
	// refinement 5: mandatory | optional | none
	// =============================================

	escalationRouting: [{
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Verification específica retida; outras Verifications continuam fluindo. Block scope: verification-specific (commitmentRef, evidenceRef). overridePolicy: optional — founder MAY autorizar criteria-version-override OR re-evaluation com new criteriaVersion."
		recipient:      "founder"
		rationale: """
			Criteria ambíguo OR conflicting cross-evidence consistency
			(BD9 Layer 2 detectou inconsistência irresolvível por
			function pura). Canal sync porque retém Verification
			específica mas não bloqueia operações concorrentes em
			outras Verifications. Anti-mini-NIM: agent NÃO infere via
			heurística; escala quando function pura não converge per
			BD1 RECTOR. overridePolicy=optional: founder pode aprovar
			criteria-version-override (BD12) OR re-evaluation
			(override-rejection) com new evidence/criteria.
			"""
	}, {
		category:       "out-of-scope"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até decisão. Block scope: operation-specific (e.g., scoring solicitado, criteria inference solicitada). overridePolicy: mandatory ADR artifact — boundary violation requer registro estrutural."
		recipient:      "founder"
		rationale: """
			Operação fora do operationalScope DLV — scoring solicitado
			(viola BD10 + BND-1), criteria inference solicitada (viola
			BD12 + BND-2), supplier prioritization solicitada (anti-
			mini-NIM transversal), history mutation solicitada (viola
			BD2 + BD3 + cst-no-history-mutation). Boundary preservation
			transversal: agent BLOQUEIA + escala. overridePolicy=mandatory
			ADR: tentativa de operação fora do escopo é structural
			signal de drift cognitivo OR adversarial pressure —
			merece registro estrutural mesmo que isolated incident.
			"""
	}, {
		category:       "conflicting-signals"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. Verification específica continua sob fallback ordering DLV; signal cross-BC LOG-side investigation Phase 1+ via OBS metric sig-supersession-lineage-drift. overridePolicy: none — robust-against-failure-of-adjacent-BC: DLV continua sob LOG falha; nenhum override autonomyLevel necessário."
		recipient:      "founder"
		rationale: """
			EvidenceSuperseded LOG event chega tardio para fluxo já em
			fallback ordering DLV (sig-supersession-lineage-drift OBS
			metric). DLV continua via fallback determinístico (BD5
			robust-against-failure-of-adjacent-BC); signal cross-BC
			para investigation upstream LOG-side via OBS aggregation
			Phase 1+. async-queue porque NÃO bloqueia operações
			concorrentes; sustained pattern triggers founder review +
			LOG-side coordination. overridePolicy=none: divergence é
			signal sustainability informativo, NÃO actionable
			autonomyOverride; resolução é cross-BC infra issue.
			"""
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Bounded wait 4h úteis: Verification em state evaluating-pending-criteria internal (NÃO publicado cross-BC) until criteria activation OR timeout operacional força founder decision. Other Verifications com criteria active continuam fluindo. Block scope: verification-specific. overridePolicy: optional — founder MAY autorizar criteria-version-override (BD12)."
		recipient:      "founder"
		rationale: """
			criteriaVersion não disponível em CMT (cache miss + sync
			timeout) OR EvidenceRecord ingerida mas Layer 1 verification
			fails (proof unverifiable local). Agent transita para
			state evaluating-pending-criteria internal (BD12) OR
			rejected com reasonCode estruturado (BD11 integrity-proof-
			unverifiable-local). Bounded wait 4h evita deadlock
			sistêmico — agent NÃO controla disponibilidade CMT/IDC
			sync nem SLA real de recuperação. Timeout 4h dispara
			decisão supervisionada obrigatória. overridePolicy=optional:
			founder pode autorizar criteria-version-override (BD12)
			com criteria existing OR aceitar rejected se integrity
			fails sustained.
			"""
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Bloqueio escopado ao input afetado (specific supervisedDecision proposal) com elevated audit; outras operações continuam fluindo. Block scope: input-specific. overridePolicy: mandatory artifact (tension-entry → deferred-decision → ADR per artifact ordering canvas Phase 1.5)."
		recipient:      "founder"
		rationale: """
			Possível prompt injection em emergency-override proposal
			OR justificativa supervisedDecision com pattern adversarial
			(sustained override-rate breach detected). External-
			untrusted-freeform input em supervisedDecision proposals
			exige defense (BD13 mandatory rationale + audit trail Lei
			12.846/SCD/CVM). Agent flagga + escala com elevated audit
			context. overridePolicy=mandatory artifact: pattern
			sustained de suspicious input é signal estrutural de
			adversarial pressure — merece artifact ordering tension/
			deferred/ADR per antifragility loop.
			"""
		maxQueueDepth: 10
		maxQueueAge:   "4h"
		overflowPolicy: {
			action:           "auto-cancel-and-escalate"
			cancelReasonCode: "queue-overflow"
			escalateVia:      "out-of-scope"
		}
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 3
		maxDailyActions:        100
		rationale: """
			DLV tem 18 actions: 7 autonomous mutations (validate-
			integrity + ingest + resolve-criteria + evaluate +
			emit-terminal + react-to-supersession + transition-
			exception-timer) + 6 supervised mutations (4 override
			channels + 2 normal recovery; propose-and-wait, NÃO
			executam autonomamente) + 3 reactive escalations + 1
			query + 1 detect-tripwire-violation. maxConcurrentMutations
			3 limita execução paralela das 7 autonomous mutations
			(supervised mutations bloqueiam até founder approval, sem
			impact em concurrency cap). Lifecycle×caps monotonicidade
			(tq-gvg-07): faixa onboarding canônica gateway-tier 1-3/
			20-100; 3/100 está no upper-end da banda canônica para
			gateway BCs em onboarding (paralelo a SSC 2/50 + P2P
			2/50 — DLV é gateway-tier core BC com volume superior por
			ser gate central do macrofluxo). DLV é compliance-enforcer
			thesis-level (canvas Phase 1.1) — gate central bloqueia
			INV/REW/FCE downstream se não processar. maxDailyActions
			100 reflete volume esperado em onboarding pre-PMF (DLV
			processa todo evidence + verification do macrofluxo).
			Tier 3 Systemic Containment via regression trigger pode
			disparar redução temporária de caps (3→2 OR 100→50) via
			founder calibration adjustment quando padrão sustained
			detectado. Sanity check: 100 daily ≥ 3 concurrent.
			"""
	}

	// =============================================
	// DRIFT DETECTION (8 métricas semanal — match canvas Phase 1.6)
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-emergency-override-rate"
			name:        "Emergency Override Rate"
			description: "Match canvas Phase 1.6 verificationMetric emergency-override-rate. Rate sustained de approve-with-emergency-override (BD7) sobre total terminal verifications em janela 30d com sample gate (N≥50 OR janela≥14d)."
			baseline:    "< 5% sustained em janela trimestral steady-state"
			threshold:   "> 5% sustained em janela 30d com sample gate"
			rationale:   "Antifragility loop M2: rate sustained = signal de ingestion path failure técnico OR sh-01 abuse pattern. Action binding via regression trigger reduce-autonomy + considerar autonomyOverride force-supervised-ingestion via founder calibration adjustment (Block 1 Phase 5 conceptual)."
		}, {
			code:        "dm-post-finality-correction-rate"
			name:        "Post-Finality Correction Rate"
			description: "Match canvas verificationMetric post-finality-correction-rate. Rate de correção pós-finality (BD8 path A + path B Phase 1+) sobre total terminal verifications em janela 30d com sample gate."
			baseline:    "< 1% sustained em janela trimestral"
			threshold:   "> 1% sustained com sample gate"
			rationale:   "Antifragility loop M2: rate sustained = window calibration inadequada (oq-dlv-2). Action binding via regression trigger reduce-autonomy + escalation founder review."
		}, {
			code:        "dm-criteria-override-rate"
			name:        "Criteria Override Rate"
			description: "Match canvas verificationMetric criteria-override-rate. Rate de criteria-version-override (BD12) sobre total terminal verifications em janela 30d com sample gate."
			baseline:    "< 2% sustained"
			threshold:   "> 2% sustained com sample gate"
			rationale:   "M2: rate sustained = CMT criteria-activation timing inadequate (oq-dlv-1) OR sh-01 abuse. Cross-BC coord CMT via routing async-queue founder + cmt-coord (P6 cross-BC awareness)."
		}, {
			code:        "dm-exception-extension-rate"
			name:        "Exception Extension Rate"
			description: "Match canvas verificationMetric exception-extension-rate. Rate de extend-exception-window invocations sobre unique exception instances em janela 30d com sample gate."
			baseline:    "< 10% sustained"
			threshold:   "> 10% sustained com sample gate"
			rationale:   "M2: rate sustained = 14-day window inadequate per criteria type (oq-dlv-7) OR humano capacity insuficiente. Action binding via regression trigger reduce-autonomy."
		}, {
			code:        "dm-integrity-failure-at-ingestion-rate"
			name:        "Integrity Failure at Ingestion Rate"
			description: "Match canvas verificationMetric integrity-failure-at-ingestion-rate. Rate de RecordEvidence rejected at parsing (BD11) em janela 30d com sample gate. Phase 0 OBSERVATIONAL ONLY com spike detection guardrail (3x rolling median)."
			baseline:    "Phase 0 baseline TBD via primeiros 3-6 meses operação"
			threshold:   "Phase 0: spike > 3x rolling median 30d → logging + founder review (NÃO automated escalation). Phase 1+ acionável após baseline empírico estabelecido."
			rationale:   "F1 forgery vector signal OR LOG-side operational issue (P6 cross-BC awareness). Phase 0 spike-detection-only previne 'silêncio de governança' enquanto baseline estabiliza. Action binding via regression trigger reduce-autonomy + autonomyOverride force-supervised-ingestion via founder calibration adjustment per founder ajuste 1 obrigatório Phase 5 (FECHA vetor de ataque mais crítico — entrada do sistema)."
		}, {
			code:        "dm-exception-cap-hit-count"
			name:        "Exception Cumulative Cap Hit Count"
			description: "Match canvas verificationMetric exception-cap-hit-count (absolute count, NOT rate). Count de exceptions atingindo 30d hard cap absoluto (BD6) em janela 90d. Sample gate NOT applicable (per-incident significant)."
			baseline:    "0 (cap hits são structural signal, não operational baseline)"
			threshold:   "> 0 sustained em janela 90d"
			rationale:   "ABSOLUTE threshold: cap hit é evento individual significant. Action binding via regression trigger reduce-autonomy + escalation founder review + conexão oq-dlv-7 + tier separation Phase 1+."
		}, {
			code:        "dm-regulatory-flag-count"
			name:        "Regulatory Flag Count"
			description: "Match canvas verificationMetric regulatory-flag-count (absolute, per-incident). Count de verifications onde regulatory-fiscal-ambiguity escalation triggered em janela 90d. Sample gate NOT applicable (per-incident inviolable). PRIORITY: OVERRIDES ALL rate-based escalation criteria."
			baseline:    "0 (regulatory ambiguity é per-incident exception, não baseline)"
			threshold:   "Qualquer ≥ 1 = escalation imediata"
			rationale:   "Integridade legal CLAUDE.md nivel 1 inviolable: single incident escalation imediata via routing unclassifiable-anomaly route. Sustained > 0 em 90d = pattern systemic signal triggering autonomyOverride restrict-criteria-version (Block 1) via founder calibration."
		}, {
			code:        "dm-tripwire-violation-count"
			name:        "Tripwire Violation Count (CRITICAL)"
			description: "Match canvas verificationMetric verified-without-evidence-or-override-attempts. Count CRÍTICO de DeliveryVerified emits sem EvidenceRecord precedente OR supervisedDecision approve-with-emergency-override (BD7 INV-7 violation). PRIORITY: CRITICAL — overrides all other signals."
			baseline:    "0 (deve = 0 sempre por construção)"
			threshold:   "Qualquer ≥ 1 = critical implementation bug"
			rationale:   "Invariant tripwire NÃO operational metric — single violation = sistema quebrado. FREEZE SCOPE per founder ajuste 4 + ajuste 2 obrigatório Phase 5: block autonomous terminal emits ONLY + previne terminal-ready accumulation (evaluation pode rodar MAS não pode produzir estado terminal consumível); allow supervised emits + ingestion + evaluation continuar; ADR mandatory antes de unfreeze."
		}]
		rationale: """
			8 métricas alinhadas 1:1 com 8 verificationMetrics canvas
			Phase 1.6 (5 rate-based + 2 absolute + 1 invariant
			tripwire). Cadência semanal adequada para onboarding;
			sample gate aplicado conforme rate-based vs absolute
			(per founder ajuste rate-vs-absolute Phase 1.5). Action
			bindings: 5 rate-based via regression triggers reduce-
			autonomy + 1 cap absoluto via reduce-autonomy + 1
			regulatory single-incident via routing unclassifiable-
			anomaly route (escalation immediate) + 1 tripwire via
			suspend-and-escalate failureHandling.onAgentError. Anti-
			mini-NIM preservado: dm-integrity-failure observability-
			only Phase 0 com spike-detection 3x rolling median (per
			founder Phase 1.6 ajuste 3); promotion para acionável
			Phase 1+ após baseline empírico (3-6 meses operação).
			"""
	}

	// =============================================
	// CALIBRATION (promotion + regression — antifragility loop)
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 30 verifications terminal (DeliveryVerified|DeliveryRejected) com zero violação de invariante (14 invariants spec) e zero tripwire violations sustainable, supervised-decision-rate ≤ 12% sustentado, integrity-failure rate dentro de baseline empírico estabelecido (3-6 meses operação), zero cap absoluto BD6 hit no período, zero regulatory flag escalation"
			minimumObservationPeriod: "60 days"
			rationale: """
				30 verifications é volume mínimo para padrão
				significativo. 60 dias garante exposição a variação
				temporal. Zero tripwire violations = invariant
				estrutural mantido. Baseline empírico integrity-
				failure estabelecido permite Phase 1+ acionável.
				Zero cap hit + zero regulatory flag = sistema operando
				within expected boundaries.
				"""
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 100 verifications terminal, zero violação de invariante, zero tripwire violations, supervised-decision-rate ≤ 8% sustentado por 8 semanas, todos drift thresholds em target sustentado por 4 semanas consecutivas, audit trail verificável com reconstrução bem-sucedida em amostra de 20 verifications cobrindo todos 14 audit fields, replay determinism property-based test passa em 100% das amostras"
			minimumObservationPeriod: "90 days"
			rationale: """
				Critérios mais exigentes: volume maior (100 vs 30);
				supervised-decision-rate target 8% (vs 12%); todos
				drifts em target sustentado; audit trail testado;
				replay determinism property-based test passa (BD3
				inv-replay-determinism). 90 dias garante exposição a
				múltiplos ciclos completos.
				"""
		}]
		regressionTriggers: [{
			description:     "Tripwire violation (CRITICAL)"
			metric:          "dm-tripwire-violation-count"
			threshold:       "Qualquer ≥ 1"
			immediateAction: "suspend-and-escalate"
			rationale: """
				Tripwire violation é structural invariant violation =
				sistema quebrado per BD7 INV-7. FREEZE SCOPE per
				founder ajuste 4 + ajuste 2 obrigatório Phase 5:
				suspend autonomous emit pipeline ONLY (allow
				supervised + ingestion + evaluation continuar; previne
				terminal-ready accumulation — evaluation pode rodar
				mas NÃO produzir terminal consumível). ADR mandatory
				+ structural investigation antes de unfreeze. NÃO usa
				BD6 fail-safe (BD6 é exception operacional; isso é
				governança per founder Phase 5): permanece frozen
				até pressão externa resolver via ADR + design
				correction.
				"""
		}, {
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — falha do PRÓPRIO agente (não dependência externa), justifica suspend global per princípio Phase 5 dependência externa ≠ falha do agente. Em DLV inclui: emit verified sem evidence (viola BD7 + inv-verified-requires-evidence-or-override); scoring inline (viola BD10 + cst-no-scoring); criteria inference (viola BD12 + cst-no-criteria-inference); evidence selection (viola BD5 + cst-no-evidence-selection); history mutation (viola BD2 + BD3 + cst-no-history-mutation)."
		}, {
			description:     "Drift sustentado em emergency-override-rate"
			metric:          "dm-emergency-override-rate"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold > 5%"
			immediateAction: "reduce-autonomy"
			scopedBySignal:  "sig-rate-breach-detected"
			clearanceCondition: {
				type:           "no-signal-in-window"
				signalRef:      "sig-rate-breach-detected"
				window:         "30d"
				scope:          "global"
				maxOccurrences: 0
			}
			rationale: "Sustained breach sinaliza ingestion path failure técnico OR sh-01 abuse pattern. Reduce-autonomy + considerar autonomyOverride force-supervised-ingestion via founder calibration adjustment (Block 1 Phase 5: FECHA vetor de ataque mais crítico). Reversível via clearanceCondition typed (per adr-075): clearance fires quando ausência sustentada de sig-rate-breach-detected por 30d (scope=global porque rate breach é signal sistêmico)."
		}, {
			description:     "Drift sustentado em criteria-override-rate"
			metric:          "dm-criteria-override-rate"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold > 2%"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach sinaliza CMT criteria-activation timing inadequate (oq-dlv-1) OR sh-01 abuse. Cross-BC coordination CMT via routing async-queue founder + cmt-coord. Reduce-autonomy preserva safety enquanto causa investigada estruturalmente."
		}, {
			description:     "Drift sustentado em exception-extension-rate"
			metric:          "dm-exception-extension-rate"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold > 10%"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach sinaliza 14-day window inadequate per criteria type (oq-dlv-7) OR humano capacity insuficiente. Reduce-autonomy + tier separation Phase 1+ candidate."
		}, {
			description:     "Cap absoluto de exception cumulative atingido sustained"
			metric:          "dm-exception-cap-hit-count"
			threshold:       "1 cap hit em janela 90d"
			immediateAction: "reduce-autonomy"
			rationale:       "ABSOLUTE threshold: single cap hit (30d cumulative absolute) é evento estrutural significant. Reduce-autonomy + propose deferred-decision artifact + tier separation Phase 1+."
		}, {
			description:     "Regulatory ambiguity sistêmico (case 2)"
			metric:          "dm-regulatory-flag-count"
			threshold:       "≥ 2 incidents em janela 90d (statistical co-occurrence indicating systemic pattern, NÃO single isolated)"
			immediateAction: "reduce-autonomy"
			rationale: """
				Per founder ajuste 5 mapping pre-write Phase 4 +
				refinement 4 Phase 5: case 2 systemic ambiguity
				pattern → escalate governance review (Phase 0 founder
				+ ADR mandatory artifact, NÃO governance-board
				fantasma) + MAY suspend related criteria class via
				autonomyOverride restrict-criteria-version (Block 1).
				Reduce-autonomy preserva safety; cap reduction
				estrutural temporário via founder calibration
				adjustment. Anti-mini-NIM preservado: DLV detecta
				co-occurrence statistical, NÃO infere systemic
				coordination (judgment-driven downstream founder
				assessment).
				"""
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations OR maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária — em DLV, breach amplifica risco de procurement/finance audit gap (Lei 12.846/SCD/CVM) e drift cross-BC para INV/REW/FCE. Redução de autonomia cria margem de segurança enquanto causa investigada."
		}]
		rationale: """
			Promoção em dois estágios (paralelo P2P + SSC pattern):
			onboarding→validation (30/60d, supervised-decision-rate
			≤ 12%, baseline integrity-failure estabelecido, zero
			tripwire/cap-hit/regulatory) e validation→operational
			(100/90d, supervised-decision-rate ≤ 8%, todos drifts em
			target sustentado, audit trail testado, replay determinism
			property test passa). Regressão com 8 triggers cobrindo:
			tripwire violation (CRITICAL — suspend-and-escalate
			global per founder Phase 5 ajuste 2 obrigatório); autonomy
			boundary violation (suspend-and-escalate per princípio
			dependência externa ≠ falha do agente); 4 drift triggers
			operacionais (reduce-autonomy: emergency-override-rate +
			criteria-override-rate + exception-extension-rate +
			exception-cap-hit-count); regulatory ambiguity sistêmico
			(reduce-autonomy + restrict-criteria-version override
			candidate); blast radius breach (reduce-autonomy).
			Antifragility loop fechado per Block 4 + 2 obrigatórios
			Phase 5: trigger → reduce-autonomy → tension-entry →
			deferred-decision → ADR (mandatory artifact ordering per
			canvas Phase 1.5 + escalationRouting overridePolicy).
			Reversível via clearanceCondition typed para emergency-
			override-rate trigger (paralelo P2P fragmentation
			pattern). Schema #RegressionTrigger.immediateAction é
			single global enum — actor-scoping é runner behavior
			heuristic-level Phase 0 per def-013 trigger 1 (promotion
			path para schema first-class deferred Phase 1+).
			"""
	}

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: """
				Erro interno do agente (exception, comportamento não-
				determinístico em verification function, OR falha em
				atomic_emit() primitive call): halt operations
				imediatamente, escalate to founder for root cause
				analysis antes de retomar. DLV severity tier
				MÁXIMO (compliance-enforcer thesis-level central
				gate): agente não-determinístico em emit compromete
				spine completo do macrofluxo (INV/REW/FCE downstream
				bloqueados se DLV não decide). Lei 12.846/SCD/CVM
				exige reproducibilidade do gate (BD3 replay
				determinism). Falha do PRÓPRIO agente (não
				dependência externa) justifica suspend global per
				princípio Phase 5 dependência externa ≠ falha do
				agente. Atomic_emit() primitive failure é categoria
				especial: agent calls primitive (cst-atomic-emit-via-
				primitive); infrastructure guarantees atomicity (BD14
				+ INV-D1); primitive failure = infrastructure issue
				suspend até infra recovery + integration test.
				"""
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s); aplicável APENAS a queries de projeção intra-BC DLV (prj-canonical-current-verification + prj-evidence-lineage + prj-exception-tracking). Falha persiste = suspend agent — timeout local indica issue na infraestrutura DLV (projection corruption, hang interno), justifica suspend global por design fail-safe."
			description: """
				Princípio canônico per Ajuste 2 founder Phase 5
				P2P/SSC pattern: dependência externa ≠ falha do
				agente — separação rigorosa entre falhas locais
				(justificam suspend global) e falhas externas
				(seguem routing escalation, NÃO suspend). (a) Timeout
				LOCAL (projection intra-BC DLV): retry once + suspend-
				and-escalate se persistir — issue na própria
				infraestrutura DLV. (b) Timeout EXTERNO
				(QueryCommitmentCriteria sync fallback cross-BC CMT
				OR QueryEvidenceProof IDC): NÃO suspend global; agent
				transita para state evaluating-pending-criteria
				internal (BD12) OR rejected com reasonCode=integrity-
				unverifiable-remote (BD11 fail-safe) — CMT/IDC
				indisponibilidade NÃO derruba DLV. Per BD12 cache
				invalidation explicit deferred Phase 1+; sync fallback
				absorve cost Phase 0. Schema limitation per Ciclo 4
				red team Phase 5 e def-013: action enum é single
				global; runner MUST distinguish source per description;
				promotion path para schema first-class (per-source
				action shape) deferred Phase 1+.
				"""
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: """
				3 falhas em 24h sugerem issue sistêmico. 'Failure'
				aqui = onAgentError + onTimeout (categorias acima);
				EXCLUÍDO: constraint violations (são correct behavior
				— block-and-escalate per design) e routing escalations
				(são gates funcionando corretamente). Causas possíveis:
				degradação de CMT QueryCommitmentCriteria sustentada
				per oq-dlv-1; prj-canonical-current-verification
				corrompida; OR network partition cross-BC sustained.
				Suspend + immediate founder notification — DLV
				compliance-enforcer thesis-level NÃO tolera operação
				degraded sustentada porque amplifica risco regulatory
				+ comerciais (INV/REW/FCE downstream bloqueados).
				Tripwire violation excluído desta contagem
				(suspend-and-escalate immediate via regression
				trigger separado dm-tripwire-violation-count).
				"""
		}
		rationale: """
			Per adr-058 promotion de tech debt narrative para field
			first-class. DLV severity tier MÁXIMO (gate central
			compliance-enforcer thesis-level): suspend-and-escalate
			em todos 3 eventos por padrão Phase 0; retry conservador
			em onTimeout aplicável apenas a queries de projeção intra-
			BC; cross-BC sync queries (CMT QueryCommitmentCriteria
			+ IDC QueryEvidenceProof) NÃO retentam — timeout aqui é
			estrutural e segue routing insufficient-context (NÃO
			suspend global) per princípio Phase 5 dependência externa
			≠ falha do agente. 3/24h threshold para repeated failure
			reflete tolerance baixa apropriada; excludes constraint
			violations + routing escalations + tripwire violations
			da contagem (são comportamento correto OR signal
			separado). Schema limitation acknowledgment per Ciclo 4
			e def-013: action enum é single global; runner MUST
			distinguish source; promotion path deferred Phase 1+.
			"""
	}

	rationale: """
		Envelope de governança do agt-dlv-primary em lifecycle
		onboarding. DLV é quinto BC do macrofluxo Mesh + gate
		central compliance-enforcer thesis-level (canvas Phase 1.1
		classification): sem decisão DLV, INV/REW/FCE downstream
		bloqueados; bug em DLV invalida invariante central da tese
		'no evidence verified → no economic progression'.
		Bidirectional ref validado (tq-gv-06): agent-spec.code
		'agt-dlv-primary' == agentRef; agent-spec.governanceRef
		'dlv-primary-agent' == base name deste arquivo.

		5 routes escalation cobrindo 5 categories agent-spec
		(ambiguous-case + out-of-scope + conflicting-signals +
		insufficient-context + suspicious-input). Cada route declara
		overridePolicy explícita per founder Phase 5 refinement 5
		(none | optional | mandatory). insufficient-context route
		com queue governance per adr-075 Caminho D' (maxQueueDepth=10
		+ maxQueueAge=4h + overflowPolicy=auto-cancel-and-escalate
		via cancelReasonCode='queue-overflow' + escalateVia=out-of-
		scope) — fail-safe-only preserva invariants sob queue
		pressure; governance-review Phase 0 → founder + ADR
		mandatory artifact per founder Phase 5 refinement 4 (NÃO
		governance-board fantasma).

		Blast radius caps 3/100 (gateway-tier core BC upper-end faixa
		canônica onboarding; paralelo P2P/SSC 2/50 com volume
		superior por DLV ser gate central).

		Drift detection semanal com 8 métricas alinhadas 1:1 com 8
		verificationMetrics canvas Phase 1.6 (5 rate-based + 2
		absolute + 1 invariant tripwire). dm-integrity-failure
		observability-only Phase 0 com spike-detection 3x rolling
		median; promotion para acionável Phase 1+ após baseline
		empírico (3-6 meses operação).

		Calibração 2 estágios paralelo P2P/SSC (30/60 + 100/90).
		Regressão com 8 triggers: tripwire violation CRITICAL
		(suspend-and-escalate global per founder Phase 5 ajuste 2
		obrigatório — FREEZE SCOPE block autonomous terminal emits
		ONLY + previne terminal-ready accumulation; allow supervised
		+ ingestion + evaluation continuar); autonomy boundary
		violation (suspend-and-escalate per princípio dependência
		externa ≠ falha do agente); 4 drift triggers operacionais
		(reduce-autonomy: emergency-override-rate com clearance
		Condition typed scope=global per adr-075 + criteria-override-
		rate + exception-extension-rate + exception-cap-hit-count);
		regulatory ambiguity sistêmico case 2 (reduce-autonomy +
		restrict-criteria-version override candidate per Block 1);
		blast radius breach (reduce-autonomy).

		Antifragility loop fechado (4 blocks Phase 5 conceptual
		model):
		- Block 1: 5 autonomyOverride types disponíveis (force-
		  supervised-ingestion FECHA vetor de ataque mais crítico
		  per founder ajuste 1 obrigatório + disable-autonomous-emit
		  + require-supervised-evaluation + block-specific-commitment
		  + restrict-criteria-version); Phase 0 baseline NENHUM
		  override declarado (autonomous defaults preserved);
		- Block 2: EscalationMap 5 routes com overridePolicy
		  explícita (mandatory para tripwire/regulatory; optional
		  para rate-based; none para conflicting-signals);
		- Block 3: Reconciliation transitions simplificadas per
		  founder refinement 3 (pending → resolved | expired;
		  expired → escalated auto; escalated → resolved único
		  caminho saída); pending sustained > 14d em OBS metric;
		- Block 4: FreezeModel 3 types — tripwire-freeze
		  (autonomous-emit-pipeline ONLY + previne terminal-ready
		  accumulation per founder ajuste 2 obrigatório),
		  commitment-scoped-freeze (specific identity), criteria-
		  class-freeze (criteriaVersion class). REGRA UNIVERSAL:
		  freeze NUNCA bloqueia supervised path.

		5 ajustes founder mapping pre-write Phase 4 referenciados
		via spec consumption + envelope mechanisms:
		(1) atomic emit via primitive — failureHandling.onAgentError
		    suspend-and-escalate cobre primitive failures;
		(2) supersession event-handler — pol-supersession-applied-
		    handler domain-model é triggered, agent reage; envelope
		    NÃO override supersession path;
		(3) escalation default no autonomy reduction — Phase 0
		    autonomyOverrides empty; mandatory artifact via routing
		    overridePolicy;
		(4) tripwire FREEZE scope — failureHandling.onAgentError
		    suspend + regression trigger tripwire-violation suspend-
		    and-escalate (action targeted, NÃO global per ajuste 2
		    obrigatório Phase 5);
		(5) regulatory 2 levels — escalationRouting unclassifiable-
		    anomaly route handles case 1; case 2 systemic via
		    regression trigger reduce-autonomy + restrict-criteria-
		    version override candidate (founder calibration
		    adjustment).

		Princípio canônico per adr-075: runtime evaluation derives
		state from audit log; envelope declares contracts, not state.
		Phase 0 baseline preserva autonomous defaults via spec sem
		autonomyOverrides; promotion via calibration crossing
		thresholds — tq-gv-14 forbid override direto preserva P10.
		Envelope é control plane apenas (tq-gvg-09).

		Schema limitations Phase 0 acknowledged via def-013 + def-014
		(typing payloadSchema + ClearanceCondition variants +
		runtime evaluation engine como separação arquitetural por
		design + canvas communication schema enrichment).

		Lenses aplicadas:
		- lens-ai-agent-governance (primária — autonomyLevel,
		  escalation, observability, lifecycle calibration);
		- lens-incentive-alignment (secundária — antifragility loop
		  4 blocks; metrics → escalation → override → reconciliation
		  → ADR);
		- lens-regulatory-compliance-as-architecture (secundária —
		  Lei 12.846/SCD/CVM 5 anos retention; integridade legal
		  CLAUDE.md nivel 1 inviolable);
		- lens-organizational-resource-allocation (terciária —
		  blastRadiusCaps + lifecycle).
		"""
}
