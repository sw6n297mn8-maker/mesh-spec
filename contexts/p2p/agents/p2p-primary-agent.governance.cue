package p2p

// p2p-primary-agent.governance.cue — Governance Envelope: P2P Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do P2P.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (p2p-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode
//   override (Phase 0: nenhum override declarado)
// - agent-spec declara observability signals → este envelope define
//   drift thresholds + scopedBySignal references via signal-as-contract
//   pattern (per adr-075 Caminho D')
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária)
// - lens-incentive-alignment (secundária — Actor-Scoped Adaptive
//   Containment 3-tier para sh-01/sh-02/sh-05 vetores via routing
//   alert-and-block ator-afetado + 2 progressive regression triggers
//   com scopedBySignal + clearanceCondition typed)
// - lens-organizational-resource-allocation (secundária — caps + lifecycle)
// - lens-regulatory-compliance-as-architecture (terciária — Lei 12.846
//   procurement audit 5 anos retention)
//
// Authoring manual Phase 0 (Phase 5 do WI-057 P2P bootstrap) per
// founder choice — paralelo a SSC envelope approach Phase 0.
// 5 ciclos red team aplicados pre-write + 3 ajustes founder Phase 5
// + 1 Recomendação founder forte (Actor-Scoped Adaptive Containment
// substituindo trigger Fracionamento global suspend-and-escalate por
// containment progressivo scoped + reversível) + 5 ciclos red team
// adicionais sobre proposta Caminho D' refinement + 5 founder ajustes
// precisão pré-write.
//
// Caminho D' (adr-075) materializado: signal-as-contract +
// clearanceCondition discriminated union typed + queue governance
// route extensions fail-safe-only. Princípio canônico estabelecido:
// runtime evaluation derives state from audit log; envelope declares
// contracts, not state.
//
// Phase 0 caveats:
// - governanceGlobalVersion "0.1" forward-ref canônico (per cmt/ctr/
//   idc/npm/bdg/ssc).
// - Nenhum autonomyOverride: 1 mutation propose-and-wait per spec
//   (act-emit-purchase-order; promotion possível via calibration) +
//   1 mutation hard-supervised per spec (act-cancel-purchase-order
//   com escalationOverride hard-supervised mesmo após governance
//   promotion futura). 2 escalations collect-and-report
//   (act-detect-allocation-drift + act-detect-fragmentation-pattern).
// - dm-allocation-drift-frequency observability-only per Patch 3
//   founder domain-model + tq-gvg-09: drift é upstream SSC issue,
//   não P2P misbehavior; threshold breach → escalation async-queue
//   founder↔SSC via existing route out-of-scope (NÃO regression P2P).
// - cst-cancellation-pre-formalization-only é best-effort heuristic
//   per Ajuste 2 founder Phase 4 — failureHandling.onTimeout NÃO
//   cobre CMT formalization status check (race condition é cross-BC
//   reconciliation oq-p2p-2 deferred Phase 1+).
// - Schema limitations Phase 0 acknowledged via def-013: typing
//   payloadSchema deferred + ClearanceCondition variants extensions
//   deferred + runtime evaluation engine como separação arquitetural.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

p2pPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-p2p-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING (6 routes — match spec.escalationConditions)
	// =============================================

	escalationRouting: [{
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Decisão para a PO específica bloqueada até resolução; outras POs continuam fluindo. Block scope: po-specific (PO em validation com authorityRef divergente)."
		recipient:      "founder"
		rationale:      "Multi-authority overlap (mesmo supplier+category com 2 authorities ativas com binding regimes diferentes); cache prj-active-purchase-authorities vs sync fallback QuerySourcingDecision divergem (cache stale OR SSC mais recente); claimedAuthorityRef vs resolved authority discrepancy. Canvas escalationCriterion conflicting-authority. Canal sync e SLA curto porque conflito não-resolvido bloqueia transition requested→emitted da PO específica — anti-mini-NIM exige authority resolvida deterministicamente; agente NÃO interpreta conflito. Block scope po-specific: outras POs em estágios distintos continuam fluindo. Contexto mínimo: purchaseOrderId, claimedAuthorityRef, authorities conflitantes destacados, supplier afetado."
	}, {
		category:        "insufficient-context"
		channel:         "alert-and-block"
		slaDescription:  "Bounded wait 4h úteis: emit da PO específica bloqueado até resolução SSC OR timeout operacional que força decisão supervisionada (founder escolhe entre 2 escape hatches P2P-side: approve-po-without-sourcing-authority supervisedDecision OR cancel attempt cleanup via cmd-cancel-purchase-order de state=requested). Out-of-band recovery: SSC re-issue authority é coordenação founder externa ao P2P — requer cancel cleanup local + novo emit downstream pós-SSC restored. Outras POs com authorityRef já em cache continuam fluindo. Block scope: po-specific."
		recipient:       "founder"
		rationale:       "Cache stale > SLO 5s (prj-active-purchase-authorities desatualizada) E sync fallback QuerySourcingDecision indisponível simultaneamente; cache miss + sync failure (SSC down OR network partition). Canvas escalationCriterion insufficient-authority Phase 0 cache miss + sync failure cenário. Bounded wait 4h evita deadlock sistêmico per Ajuste 1 founder Phase 5 — agente NÃO controla disponibilidade SSC nem SLA real de recuperação; ausência de fallback operacional torna bloqueio infinito anti-padrão. Timeout 4h dispara decisão supervisionada obrigatória escolhendo escape hatch P2P-side. Queue governance per adr-075 Caminho D' (Ciclo 1 Phase 5): bounded queue com maxQueueDepth + maxQueueAge + overflowPolicy fail-safe (auto-cancel-and-escalate) preserva invariants sob queue pressure (NÃO auto-approve sob pressure — classe de erro adversarial vetada). Coerente com blast radius pequeno por padrão. Contexto mínimo: purchaseOrderId, authorityRef solicitada, qual SoT falhou, latência observada, tempo decorrido vs SLA bound."
		// Queue governance per adr-075 Caminho D' (bounded wait):
		maxQueueDepth: 10
		maxQueueAge:   "4h"
		overflowPolicy: {
			action:           "auto-cancel-and-escalate"
			cancelReasonCode: "queue-overflow"
			escalateVia:      "out-of-scope"
		}
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. PO específica retida pendente de decisão supervisora; outras POs continuam fluindo. Block scope: po-specific OR category-affected (allocation drift coordination founder↔SSC OR queue overflow escalation)."
		recipient:      "founder"
		rationale:      "Cobre 6 condições compartilhando routing por taxonomia atual: (1) authority válida no momento mas budget/volume consumido (canvas escalationCriterion authority-exhausted); (2) approve-po-without-sourcing-authority supervisedDecision; (3) cancel-emitted-po supervisedDecision (mesma rota async porque cancel é gate humano per spec escalationOverride hard-supervised mas não bloqueia operações concorrentes); (4) override-allocation-policy supervisedDecision; (5) allocation drift sustained breach (dm-allocation-drift-frequency > 5 signals/categoria/mês) → escalation founder↔SSC coordination per Ciclo 3 red team Phase 5 (NÃO regression P2P; envelope-is-control-plane tq-gvg-09 — drift é upstream SSC issue, não P2P misbehavior; scope category-affected porque fitness rules são per-categoryRef); (6) queue overflow escalation per adr-075 Caminho D' (insufficient-context route bounded queue overflow → auto-cancel-and-escalate via overflowPolicy.escalateVia=out-of-scope; cancelReasonCode queue-overflow; preserva invariants sob queue pressure). async-queue porque nenhuma das 6 bloqueia operações concorrentes. SLA 24h reflete tempo razoável para founder avaliar sem urgência sub-diária. Contexto mínimo: condição específica, purchaseOrderId/categoryRef, justificativa do proponente OR drift evidence agregada OR queue overflow context."
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Bloqueio escopado ao ator afetado (proponente sh-01 OR fornecedor sh-02 em janela de detecção); POs envolvendo outros atores/categorias continuam fluindo. Block scope: ator-afetado (Tier 1 Soft do Actor-Scoped Adaptive Containment per Recomendação founder Phase 5)."
		recipient:      "founder"
		rationale:      "Padrão de Fracionamento detectado por act-detect-fragmentation-pattern (sh-01 vector — múltiplas POs sub-threshold do mesmo proponente em janela curta) OR padrão renegotiation pressure detected (sh-02 vector). alert-and-block (block scope = ator afetado per janela de detecção; POs/decisões envolvendo outros proponentes/fornecedores/categorias continuam fluindo — não é global agent halt nem categoria-wide ban) constitui Tier 1 Soft Containment do mecanismo Actor-Scoped Adaptive Containment per Recomendação founder Phase 5 forte: novas POs do ator suspeito bloqueadas via routing; ator marcado under-review via signal sig-fragmentation-detected payload (requesterRef OR supplierRef + categoryRef + window — observability metadata via signal payload + audit trail; not first-class schema state). Em Phase 0, act-emit já é propose-and-wait baseline — Tier 1 = block ator + flag (autonomy já no menor nível auto-disponível). Tier 2 Hard via regression trigger reduce-autonomy actor-scoped (declarado em calibration); Tier 3 Systemic via regression trigger reduce-autonomy + cap reduction estrutural (declarado em calibration). Statistical signal discipline (tq-gvg-11): confidence threshold (mediana ± 1σ por categoria), janela mínima 30 dias, scope ator-afetado por default. Coordenação cross-BC com BDG (Fracionamento bidirecional, oq-p2p-6 análogo) pendente reforça severity. Anti-mini-NIM preservado: P2P escopa containment, NÃO julga intent. Contexto mínimo: ator afetado (proponente requesterRef OR fornecedor supplierRef), purchaseOrderId(s) envolvidas, padrão temporal observado, statistical evidence (mediana + desvio padrão da categoria via prj-purchase-history-by-category)."
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. PO específica retida; outras POs continuam fluindo. Block scope: po-specific."
		recipient:      "founder"
		rationale:      "Multi-supplier authority cobertura unclear (claimedAuthorityRef cobre supplier mas allocationPolicy split entre múltiplos sem percentage match para volume requerido); RFQScope match ambiguous (categoryRef inferido vs declarado divergem; supplier qualificado em múltiplas categorias); decisionType strategic-award Phase 0 advisory binding (operações sob authority que vai ter hard binding pós-CTR ContractActivated PHASE 1+ per oq-p2p-1). Caso intermediário entre processo padrão e supervisedDecision explícita. Canal sync porque retém PO específica mas não bloqueia operações concorrentes em outras POs com authority unambiguous. Strategic-award Phase 0 advisory bridge é openQuestion oq-p2p-1. Contexto mínimo: purchaseOrderId, authorityRef, scope/allocation/type ambiguity description, hipóteses de classificação."
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Emit/cancel da PO específica bloqueado até parecer especializado; outras POs continuam fluindo. Block scope: po-specific (zona cinza Lei 12.846 procurement audit OR cross-BC drift inesperado)."
		recipient:      "founder"
		rationale:      "Canvas escalationCriterion regulatory-fiscal-ambiguity (Lei 12.846 procurement zona cinza public-private boundary; fiscal anomaly em cross-border supply; sanção a fornecedor durante PO ativa entre emit e CMT formalization); cross-BC drift inesperado (CMT pre-CMT race condition pós-emit antes Cancelled chegar — oq-p2p-2 não modelado Phase 0; CTR ContractActivated não chega após StrategicAward em janela esperada — oq-p2p-1 timing; SSC strategic-award authority transition advisory→hard timing inconsistency — oq-ssc-5 cache stale). Integridade legal é constraint inviolável (nível 1 per CLAUDE.md); zona cinza exige julgamento humano especializado. alert-and-block (po-specific scope: bloqueia emit/cancel desta PO específica; outras POs continuam fluindo — não é global agent halt) porque approval autônomo em zona cinza procurement cria precedente regulatory questionável. Contexto mínimo: purchaseOrderId, natureza fiscal/regulatória/cross-BC do anomaly, hipóteses de classificação."
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 2
		maxDailyActions:        50
		rationale:              "P2P tem 8 actions (2 mutations: act-emit-purchase-order propose-and-wait per spec + act-cancel-purchase-order propose-and-wait + escalationOverride hard-supervised per spec; 2 validations execute-and-log; 2 escalations collect-and-report; 2 queries execute-and-log). maxConcurrentMutations 2 limita execução paralela das 2 mutations — mutations com impacto cross-BC (CMT consumer hard binding via PurchaseOrderEmitted; NTF transversal supplier-specific). Onboarding paralelo a SSC (2/50, gateway primário) é decisão deliberada: P2P é gateway-adjacent BC (segundo do trio canônico SSC→P2P→CMT) — emit volume pode exceder SSC ao longo do dia (preferred validityPeriod permite múltiplos emits por authority). Promoção prematura amplifica risco de procurement audit gap (Lei 12.846) downstream + drift cross-BC para CMT. 2 concurrent permite processamento paralelo de até 2 emits/cancels em estágios distintos. maxDailyActions 50 reflete volume esperado em onboarding pre-PMF. Sanity check: 50 daily ≥ 2 concurrent. Lifecycle×caps monotonicidade (tq-gvg-07): faixa onboarding canônica 1-2/20-50; 2/50 está no upper-end da banda canônica para gateway BCs em onboarding (paralelo a SSC 2/50 + BDG 2/50). Promoção para 3+ é decisão futura via calibration. Tier 3 Systemic Containment (regression trigger Fracionamento sistêmico per Recomendação founder Phase 5) pode disparar redução temporária de caps (2→1 OR 50→25) via founder calibration adjustment quando padrão coordenado cross-actor + cross-category detectado — redução de caps NÃO é runner action automática mas decisão founder advisada via signal sig-fragmentation-detected aggregated."
	}

	// =============================================
	// DRIFT DETECTION (5 métricas semanal)
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-po-emission-latency"
			name:        "Tempo de Emissão de PO"
			description: "p95 do tempo entre cmd-emit-purchase-order recebido (requestedAt) e PurchaseOrderEmitted publicado OR aggregate persistindo em state=requested (validation failure attempt recorded)."
			baseline:    "p95 ≤ 4h para emit success normal (cache hit + validation pass)"
			threshold:   "> 12h p95 em janela semanal"
			rationale:   "Latência alta indica gargalo no gate de authority — cache stale frequente; sync fallback saturado; insufficient-context retentions sustentados; OR supervised gate aprovação humana propose-and-wait com latência alta (founder bottleneck pre-PMF). Threshold conservador em onboarding. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-po-attempt-persistence-rate"
			name:        "Taxa de Attempts Persistentes em state=requested"
			description: "Percentual de cmd-emit-purchase-order recebidos que resultam em aggregate persistindo em state=requested sem progredir para emitted (per Patch 1 founder domain-model: 'emit attempt recorded' semantic — validation failed; audit trail de attempt). Excluído: cancellations administrativas em state=requested (cleanup deliberate)."
			baseline:    "< 5% attempts persistindo (validation pass rate ≥ 95%)"
			threshold:   "> 12% em janela semanal"
			rationale:   "Taxa alta indica problema sistêmico de authority — as-p2p-1 invalidação (authority cobertura insuficiente sustained); cache invalidation pós-CTR cancel não propagada (oq-ssc-5/oq-p2p-2 compartilhada); SSC fitness rules subdimensionadas. Renomeado de 'po-rejection-rate' per founder Patch 1 framing: requested NÃO é 'rejection' — é 'attempt recorded' (audit trail). Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-supervisor-override-rate"
			name:        "Taxa de Override Supervisor"
			description: "Percentual de POs que requerem supervisedDecision (cancel-emitted-po + approve-po-without-sourcing-authority + override-allocation-policy) sobre total de POs em janela semanal."
			baseline:    "< 8% das POs"
			threshold:   "> 18% em janela semanal"
			rationale:   "Taxa alta indica que autoridade pré-validada SSC + gate determinístico de allocation não cobrem o espectro operacional — possível necessidade de revisar SSC fitness rules, validar allocation policy enforcement (oq-p2p-3 + oq-ssc-3 bridge feedback loop). Threshold 18% margem sobre target 8% para acomodar variação onboarding. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-allocation-drift-frequency"
			name:        "Frequência de Allocation Drift Signals"
			description: "Quantidade de sig-allocation-drift signals emitidos por act-detect-allocation-drift por categoryRef em janela mensal. Statistical signal discipline (tq-gvg-11): confidence threshold mediana ± 1σ por categoria; janela mínima 30 dias para padrões significativos."
			baseline:    "< 2 signals por categoria/mês"
			threshold:   "> 5 signals por categoria/mês"
			rationale:   "Frequência alta de drift signals indica desalinhamento sustentado entre allocationPolicy upstream SSC e volume real emitido. Métrica é OBSERVABILITY-ONLY — NÃO regression binding automático: drift é upstream SSC issue, NÃO P2P misbehavior; reduce P2P autonomy não corrige causa estrutural; envelope-is-control-plane (tq-gvg-09). Action binding via routing per Ciclo 3 red team Phase 5: threshold breach > 5 signals/categoria/mês → escalation async-queue para founder ↔ SSC coordination via existing route out-of-scope (scope category-affected; fitness rules são per-categoryRef). Esse binding routing-level satisfaz tq-gvg-06 (automatic enforcement drift→action) sem violar tq-gvg-09 (envelope-is-control-plane) — ação é cross-BC coordination signal, não regression P2P autonomy."
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions (50/dia) em janela semanal."
			baseline:    "< 60% de utilização média"
			threshold:   "> 90% de utilização média em janela semanal"
			rationale:   "Utilização consistente acima de 90% indica que cap está subdimensionado para demanda real, forçando agente a priorizar ou adiar operações — POs podem ficar retidas em filas, propagando latência para spine procurement-lifecycle. Pode justificar promoção de caps via calibration ou revisão de lifecycle stage. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}]
		rationale: "Cinco métricas cobrem latência do gate de authority (po-emission-latency), qualidade da cobertura de authority (po-attempt-persistence-rate per Patch 1 founder semantic), demanda de supervisão (supervisor-override-rate), drift agregado de allocation (allocation-drift-frequency observability-only com binding routing-level founder↔SSC coordination per Ciclo 3 — satisfaz tq-gvg-06 sem violar tq-gvg-09) e dimensionamento operacional (cap utilization). Cadência semanal adequada para onboarding. Failure handling vive em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058). Automatic enforcement bindings drift→action: 4 via regression trigger reduce-autonomy + 1 via routing async-queue founder↔SSC."
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 15 POs emitted (PurchaseOrderEmitted publicado) com zero violação de invariante (5 invariantes do spec) e taxa de aprovação de recomendações ≥ 95% (founder aprova outcome em act-emit-purchase-order propose-and-wait — act-cancel-purchase-order hard-supervised também conta), supervisor-override-rate ≤ 12% sustentado, po-attempt-persistence-rate ≤ 8% sustentado, zero allocation-drift signals classificados como P2P misbehavior (todos drifts atribuídos corretamente a upstream SSC fitness rules), zero Tier 2 Hard containment ativo (Tier 1 Soft routing alert-and-block tolerado para investigation, mas Hard containment ativo indica padrão Fracionamento não-resolvido ainda)"
			minimumObservationPeriod: "60 days"
			rationale:                "15 POs é volume mínimo para padrão significativo. 60 dias garante exposição a variação temporal. Taxa de aprovação 95% mede alinhamento agente↔founder. Allocation drift attribution check: founder revisa signals para confirmar drifts upstream SSC. Tier 2 Hard containment check: nenhum ator com containment ativo no momento da promoção."
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 50 POs emitted, zero violação de invariante, taxa de aprovação ≥ 98%, supervisor-override-rate ≤ 8% sustentado por 8 semanas, po-attempt-persistence-rate ≤ 5% sustentado por 8 semanas, po-emission-latency p95 ≤ 4h sustentado por 8 semanas, zero drift detectado acima de threshold por 4 semanas consecutivas (excluindo dm-allocation-drift-frequency observability-only), zero Tier 2 Hard containment ativo nas últimas 8 semanas, audit trail verificável com reconstrução bem-sucedida em amostra de 10 POs cobrindo todos 14 audit fields incluindo decisionRationaleLink ref/hash apontando para SSC sourcingDecisionId"
			minimumObservationPeriod: "90 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, todos thresholds sustentados em target, drift estável, zero Tier 2 Hard containment recente (Actor-Scoped Adaptive Containment lifecycle 'cleared' sustentado), audit trail testado. 90 dias garante exposição a múltiplos ciclos estratégicos."
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — falha do PRÓPRIO agente (não dependência externa), justifica suspend global per princípio Phase 5 dependência externa ≠ falha do agente. Em P2P inclui emit autônomo sem authority válida; cancel sem aprovação humana; query a NPM (viola inv-no-supplier-revalidation-by-p2p NEGATIVO); transition emitted→cancelled sem heuristic flag cmt-formalization-status registrado."
		}, {
			description:     "Drift sustentado em supervisor-override-rate"
			metric:          "dm-supervisor-override-rate acima de threshold (> 18%)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach sinaliza desalinhamento estrutural — SSC fitness rules subdimensionadas; allocation policies frequentemente unclear; authority-exhausted recorrente. Redução de autonomia força revisão mais intensiva. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Drift sustentado em po-attempt-persistence-rate"
			metric:          "dm-po-attempt-persistence-rate acima de threshold (> 12%)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach sinaliza desalinhamento entre demanda operacional e cobertura de authority SSC. Redução de autonomia preserva safety enquanto fontes de attempts failed são endereçadas estruturalmente. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Drift sustentado em po-emission-latency"
			metric:          "dm-po-emission-latency acima de threshold (> 12h p95)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach sinaliza gargalo no gate de authority. Redução de autonomia preserva safety enquanto causa investigada. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária — em P2P, breach amplifica risco de procurement audit gap (Lei 12.846) e drift cross-BC. Redução de autonomia cria margem de segurança."
		}, {
			description:     "Padrão Fracionamento actor-localized persistente (Tier 2 Hard containment)"
			metric:          "act-detect-fragmentation-pattern emite ≥ 3 anomaly reports na mesma janela semanal apontando para mesmo requesterRef + mesma categoryRef (vetor sh-01 padrão actor-localized) — sustained pós-Tier 1 routing alert-and-block ativo"
			threshold:       "1 avaliação acima de threshold (statistical signal discipline tq-gvg-11: confidence mediana ± 1σ por categoria + janela mínima 30 dias)"
			immediateAction: "reduce-autonomy"
			scopedBySignal:  "sig-fragmentation-detected"
			clearanceCondition: {
				type:           "no-signal-in-window"
				signalRef:      "sig-fragmentation-detected"
				window:         "30d"
				scope:          "inherit-from-trigger"
				maxOccurrences: 0
			}
			rationale: "Tier 2 Hard containment per Recomendação founder Phase 5 forte (Actor-Scoped Adaptive Containment): ator persiste padrão após Tier 1 routing soft containment — escalation para hard containment via reduce-autonomy actor-scoped via signal-as-contract pattern (per adr-075 Caminho D'). Scope resolution determinístic via sig-fragmentation-detected payload (requesterRef + categoryRef snapshot at trigger time); audit trail captures {trigger code, signal-payload-snapshot, action, resolved-scope}. Operacionalmente: TODAS POs do requester suspeito forçam aprovação humana SEM bypass + justificativa explícita por PO obrigatória. Opcional shadow aggregation view: agregar automaticamente POs suspeitas para detection cross-PO retroativa. Schema #RegressionTrigger.immediateAction é single global enum — actor-scoping é runner behavior heuristic-level Phase 0 per def-013 trigger 1 (promotion path para schema first-class deferred Phase 1+). Anti-mini-NIM preservado: P2P NÃO julga intent; apenas escopa containment ao ator detectado via signal. NÃO suspend global agent: outros requesters/categorias continuam fluindo. Reversível: clearanceCondition typed per adr-075 (#ClearanceByNoSignalInWindow com signalRef + window + scope inherit-from-trigger + maxOccurrences=0) — runtime evaluation derives state from audit log: clearance fires quando ausência sustentada de sig-fragmentation-detected matching scope ator-afetado por 30 dias consecutivos."
		}, {
			description:     "Padrão Fracionamento sistêmico (Tier 3 cross-actor + cross-categoria co-occurrence)"
			metric:          "act-detect-fragmentation-pattern emite anomaly reports cross-actor + cross-category na mesma janela mensal: ≥2 atores E ≥2 categorias com Fracionamento patterns simultaneamente ativos (statistical co-occurrence, NÃO inferência de coordenação) — overlap de anomaly reports em janela ≥30 dias"
			threshold:       "1 avaliação acima de threshold (janela mensal; statistical signal discipline tq-gvg-11)"
			immediateAction: "reduce-autonomy"
			scopedBySignal:  "sig-fragmentation-detected"
			clearanceCondition: {
				type:           "no-signal-in-window"
				signalRef:      "sig-fragmentation-detected"
				window:         "30d"
				scope:          "global"
				maxOccurrences: 0
			}
			rationale: "Tier 3 Systemic escalation per Recomendação founder Phase 5: padrão estatisticamente concentrado cross-actor + cross-category sugere problema sistêmico (drift de SSC fitness rules thresholds OR ataque externo). Anti-mini-NIM: P2P detecta CO-OCCURRENCE (deterministic statistical via sig-fragmentation-detected payload aggregation), NÃO infere COORDINATION (judgment-driven, downstream founder assessment) per Ciclo 2 red team Phase 5. NÃO suspend global agent — escalation estrutural a SSC + BDG (Fracionamento bidirecional, oq-p2p-6 análogo). reduce-autonomy + redução temporária de caps via calibration regression (founder action via calibration adjustment: caps 2→1 OR 50→25 enquanto investigação cross-BC progride; redução de caps NÃO é runner action automática mas decisão founder advisada via signal). Containment via signal sig-fragmentation-detected agregado + escalation async-queue para founder ↔ SSC/BDG coordination structural. Trata problema sistêmico sem colapsar operação. Atributo emergente strategic Mesh: aprende com o ataque. clearanceCondition typed per adr-075 com scope=global (todo P2P clearance vs scope=inherit-from-trigger ator-localized do Tier 2): clearance fires quando ausência GLOBAL de sig-fragmentation-detected por 30 dias — runtime evaluation derives state from audit log."
		}]
		rationale: "Promoção em dois estágios: onboarding→validation (15/60d, override ≤ 12%, attempt-persistence ≤ 8%, allocation-drift attribution check, zero Tier 2 Hard containment ativo) e validation→operational (50/90d, supervisor-override ≤ 8% + attempt-persistence ≤ 5% + emission-latency p95 ≤ 4h em target sustentado por 8 semanas + zero Tier 2 Hard recent + audit trail reconstruction com decisionRationaleLink). Regressão com 7 triggers: tolerance zero para violação de autonomy boundary (suspend-and-escalate, falha do próprio agente), 3 drift triggers operacionais (reduce-autonomy), blast radius breach (reduce-autonomy), e Actor-Scoped Adaptive Containment per Recomendação founder Phase 5 forte: Tier 2 Hard via reduce-autonomy actor-scoped (scopedBySignal sig-fragmentation-detected + clearanceCondition typed scope=inherit-from-trigger) + Tier 3 Systemic via reduce-autonomy + cap reduction estrutural (scopedBySignal sig-fragmentation-detected + clearanceCondition typed scope=global; co-occurrence statistical NÃO coordination inference per Ciclo 2). dm-allocation-drift-frequency DELIBERADAMENTE excluída de regression binding per Patch 3 + tq-gvg-09 + Ciclo 3: drift é upstream SSC issue; routing-level escalation async-queue founder↔SSC coordination satisfaz tq-gvg-06 sem violar tq-gvg-09. Substituição trigger Fracionamento global suspend-and-escalate por Actor-Scoped Adaptive Containment 3-tier preserva continuidade operacional + evita falso positivo destrutivo + mantém blast radius mínimo. Phase 0 baseline preserva 1 mutation propose-and-wait + 1 hard-supervised via spec sem autonomyOverrides. Schema #RegressionTrigger.immediateAction é single global enum — actor-scoping é runner behavior heuristic-level Phase 0 per def-013 trigger 1 (promotion path para schema first-class deferred Phase 1+); paralelo tq-gvg-08 promotion path per adr-058."
	}

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno do agente (exception, comportamento não-determinístico em authority validation gate, ou falha em statistical detection): halt operations imediatamente, escalate to founder for root cause analysis antes de retomar. P2P severity tier alto (gateway-adjacent) — agente não-determinístico em emit compromete spine procurement-lifecycle (CMT consume PurchaseOrderEmitted como trigger commitment lifecycle hard binding); Lei 12.846 procurement audit exige reproducibilidade do gate. Falha do PRÓPRIO agente (não dependência externa) justifica suspend global per princípio Phase 5 dependência externa ≠ falha do agente."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s); aplicável APENAS a queries de projeção intra-BC P2P (prj-active-purchase-authorities + prj-purchase-orders + prj-allocation-tracking + prj-purchase-history-by-category). Falha persiste = suspend agent — timeout local indica issue na infraestrutura P2P (projection corruption, hang interno), justifica suspend global por design fail-safe."
			description: "Princípio canônico per Ajuste 2 founder Phase 5: dependência externa ≠ falha do agente — separação rigorosa entre falhas locais (justificam suspend global) e falhas externas (seguem routing escalation, NÃO suspend). (a) Timeout LOCAL (projection intra-BC P2P): retry once + suspend-and-escalate se persistir — issue na própria infraestrutura P2P. (b) Timeout EXTERNO (QuerySourcingDecision sync fallback cross-BC SSC): NÃO suspend global; emit segue routing insufficient-context (alert-and-block po-specific bounded wait 4h com escape hatch supervisionado per Ajuste 1 founder Phase 5 + queue governance per adr-075) carregando contexto SSC unavailability — SSC indisponibilidade NÃO derruba P2P. Per Ajuste 2 founder Phase 4: CMT formalization status check NÃO existe Phase 0; race condition pós-emit é cross-BC reconciliation oq-p2p-2 deferred Phase 1+. Schema limitation per Ciclo 4 red team Phase 5 e def-013: action enum é single global; runner MUST distinguish source per description; promotion path para schema first-class (per-source action shape) deferred Phase 1+."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h sugerem issue sistêmico. 'Failure' aqui = onAgentError + onTimeout (categorias acima); EXCLUÍDO: constraint violations (são correct behavior — block-and-escalate per design) e routing escalations (são gates funcionando corretamente). Causas possíveis: degradação de SSC QuerySourcingDecision sustentada per oq-ssc-5; prj-active-purchase-authorities corrompida; OR network partition cross-BC sustained. Suspend + immediate founder notification — P2P gateway-adjacent não tolera operação degraded sustentada porque amplifica risco de procurement audit gap cross-BC."
		}
		rationale: "Per adr-058 promotion de tech debt narrative para field first-class. P2P severity tier alto: suspend-and-escalate em todos 3 eventos por padrão Phase 0; retry conservador em onTimeout aplicável apenas a queries de projeção intra-BC; cross-BC SSC sync queries não retentam — timeout aqui é estrutural e segue routing insufficient-context (NÃO suspend global) per princípio Phase 5 dependência externa ≠ falha do agente. 3/24h threshold para repeated failure reflete tolerance baixa apropriada; excludes constraint violations + routing escalations da contagem (são comportamento correto). Race condition CMT formalization pós-emit (oq-p2p-2) NÃO coberta. Schema limitation acknowledgment per Ciclo 4 e def-013: action enum é single global; runner MUST distinguish source; promotion path deferred Phase 1+."
	}

	rationale: "Envelope de governança do agt-p2p-primary em lifecycle onboarding. P2P é segundo BC do trio canônico Mesh (SSC → P2P → CMT). Bidirectional ref validado (tq-gv-06): agent-spec.code 'agt-p2p-primary' == agentRef; agent-spec.governanceRef 'p2p-primary-agent' == base name deste arquivo. 6 rotas escalation cobrindo 6 categories spec; routing precedence canônica (tq-gvg-05): blocking > non-blocking; mutation-related > informational; explicit > fallback. Insufficient-context route com queue governance per adr-075 Caminho D' (maxQueueDepth=10 + maxQueueAge=4h + overflowPolicy=auto-cancel-and-escalate via cancelReasonCode='queue-overflow' + escalateVia=out-of-scope) — fail-safe-only preserva invariants sob queue pressure (NÃO auto-approve). Blast radius caps 2/50 paralelo SSC (gateway-adjacent + onboarding upper-end faixa canônica). Drift detection semanal com 5 métricas: 4 com regression binding automático reduce-autonomy + 1 observability-only com action binding via routing async-queue founder↔SSC (allocation-drift-frequency per Ciclo 3 red team — satisfaz tq-gvg-06 sem violar tq-gvg-09). Failure handling per adr-058 schema first-class: princípio Ajuste 2 founder Phase 5 — dependência externa ≠ falha do agente; suspend global apenas para falhas LOCAIS. Calibração 2 estágios paralelo SSC (15/60 + 50/90). Regressão com 7 triggers incluindo Actor-Scoped Adaptive Containment 3-tier per Recomendação founder Phase 5 forte: Tier 1 Soft via routing alert-and-block ator-afetado (suspicious-input route já declarado), Tier 2 Hard via reduce-autonomy actor-scoped (scopedBySignal=sig-fragmentation-detected + clearanceCondition typed scope=inherit-from-trigger), Tier 3 Systemic via reduce-autonomy + cap reduction estrutural (scopedBySignal=sig-fragmentation-detected + clearanceCondition typed scope=global). Princípio canônico per adr-075: runtime evaluation derives state from audit log; envelope declares contracts, not state. Phase 0 baseline preserva 1 mutation propose-and-wait + 1 hard-supervised via spec sem autonomyOverrides; promotion via calibration crossing thresholds — tq-gv-14 forbid override direto preserva P10. Envelope é control plane apenas (tq-gvg-09). Schema limitations Phase 0 acknowledged via def-013 (typing payloadSchema + ClearanceCondition variants extensions + runtime evaluation engine como separação arquitetural por design). Lenses: aag (primária), incentive-alignment (secundária — Actor-Scoped Adaptive Containment 3-tier), ora (secundária), rc (terciária — Lei 12.846)."
}
