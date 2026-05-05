package ssc

// ssc-primary-agent.governance.cue — Governance Envelope: SSC Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do SSC.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (ssc-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode
//   override (Phase 0: nenhum override declarado; promoção via
//   calibration declarada, não via override retroativo)
// - agent-spec declara observability signals → este envelope define
//   drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária)
// - lens-incentive-alignment (secundária — defesa contra manipulação
//   sh-01/sh-02 via routing alert-and-block escopado para suspicious-input)
// - lens-organizational-resource-allocation (secundária — caps + lifecycle)
// - lens-regulatory-compliance-as-architecture (terciária — Lei 12.846
//   procurement audit)
//
// Phase 0 caveats:
// - governanceGlobalVersion "0.1" forward-ref canônico (per cmt/ctr/idc/
//   npm/bdg).
// - Nenhum autonomyOverride: 3 mutations propose-and-wait permanecem per
//   spec (act-open-rfq, act-evaluate-and-conclude-rfq, act-cancel-rfq);
//   act-revalidate-rfq-pool é execute-and-log per spec quando remoção
//   preserva pool ≥2 (mutation determinística sob signal autoritativo
//   NPM single-owner per dp-04) e escala via escalationOverride
//   conditional (insufficient-qualified-pool → out-of-scope async-queue)
//   quando pool <2 — human gate alcançado via escalation routing, NÃO
//   via mudança de autonomyLevel. Promotion para execute-and-log das 3
//   propose-and-wait via calibration crossing thresholds — tq-gv-14
//   forbid override direto execute-and-log para mutations preserva P10.
// - Detecção de Fracionamento sh-01 e low-balling sh-02 são mecanismos
//   secundários per spec; defesa estrutural primária depende de
//   coordenação cross-BC com BDG (Fracionamento bidirecional, oq-bdg-1
//   análogo) e dados acumulados em prj-rfq-history-by-category.
//
// Authoring manual Phase 0 (Phase 5 do WI-060 SSC bootstrap) per founder
// choice (vs subagent dispatch) — paralelo a BDG approach Phase 0.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

sscPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-ssc-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING (6 routes — match spec.escalationConditions)
	// =============================================

	escalationRouting: [{
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Decisão para a RFQ específica bloqueada até resolução; outras RFQs continuam fluindo."
		recipient:      "founder"
		rationale:      "fitnessSignals contém signals contraditórios sem path determinístico (NPM eligibility=true mas existingCommitments saturated; NIM performanceScore baixo mas RFQ price competitivo; supplier qualification scope expirado mas eligibility=eligible-for-sourcing). Canal sync e SLA curto porque conflito não-resolvido bloqueia decisão emitida — RFQ pode ter window aberta mas anti-mini-NIM exige fitness rules sobre signals consistentes; agente NÃO interpreta conflito (viola integridade do gate). Scope: item-specific (rfqId); outras RFQs em estágios distintos continuam fluindo. Contexto mínimo: rfqId, signals conflitantes destacados, fonte autoritativa de cada signal, fornecedores afetados."
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Decisão para a RFQ específica bloqueada até contexto fornecido; outras RFQs continuam fluindo."
		recipient:      "founder"
		rationale:      "Required Phase 0 signals incompleto (NPM eligibility / RFQ context / RFQ responses ausentes); projection stale > SLO 5s; rfq-no-quotations-received; fitness rules vigentes não acessíveis. alert-and-block (item-specific scope: bloqueia decisão emitida para esta RFQ específica; outras RFQs em estágios distintos continuam fluindo — não é global agent halt) porque outcome rejected automático seria conclusão definitiva de ausência de cobertura, não falta de visibility — rejeição inadequada propaga para P2P (autoridade procurement) e CTR (formalização). Bloqueio item-specific é mais conservador que rejeição falsa em Phase 0 dada criticidade procurement audit (Lei 12.846). Contexto mínimo: rfqId, qual SoT falhou, latência observada, signals faltantes/inconsistentes."
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. RFQ específica retida; outras RFQs continuam fluindo."
		recipient:      "founder"
		rationale:      "RFQScope cobre múltiplas categorias sem critério de partição claro; allocationPolicy split unclear sem critério estruturado (multi-supplier sem percentage distribution declarada); decisionType declarado pelo category manager incompatível com pool pós-revalidation. Caso intermediário entre processo padrão e supervisedDecision explícita — ambiguidade exige julgamento humano sobre como partir/decidir. Canal sync porque retém RFQ específica mas não bloqueia operações concorrentes em outras categorias. Contexto mínimo: rfqId, scope/allocation/type ambiguity description, hipóteses de classificação."
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. RFQ/operação específica retida pendente de decisão supervisora; outras RFQs continuam fluindo."
		recipient:      "founder"
		rationale:      "Cobre 5 condições compartilhando routing por taxonomia atual: (1) pool qualified < 2 fornecedores no decision time (canvas supervisedDecision approve-decision-with-insufficient-pool — caminho permitido; cobre também escalation conditional de act-revalidate-rfq-pool quando re-validation reduz pool a <2); (2) override-fitness-rule solicitado; (3) configure-fitness-rules solicitado; (4) cancel-rfq triggered (escalationCriterion rfq-no-quotations-received OU mudança estratégica); (5) ajuste de validityPeriod de preferred designation pós-emit (não modelado Phase 0). async-queue porque nenhuma das 5 bloqueia operações concorrentes — apenas item específico fica retido; outras RFQs em estágios distintos continuam fluindo. SLA 24h reflete tempo razoável para founder avaliar sem urgência sub-diária dado que essas operações são fluxo planejado, não emergência. Contexto mínimo: condição específica, rfqId, justificativa do proponente, dados relevantes (pool size, regra atual, novo valor proposto)."
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Bloqueio escopado ao ator afetado (proponente OR fornecedor OR categoria específica em janela de detecção); RFQs concorrentes envolvendo outros atores/categorias continuam fluindo."
		recipient:      "founder"
		rationale:      "Padrão de Fracionamento detectado por act-detect-fragmentation-pattern (sh-01 vector — múltiplas RFQs sub-threshold do mesmo proponente em janela curta) OR low-balling/inflation/collusion-suspect detectado por act-detect-suspicious-quotation (sh-02 vector — cotação fora de range estatístico via prj-rfq-history-by-category). alert-and-block (block scope = ator afetado per janela de detecção; RFQs/decisões envolvendo outros proponentes/fornecedores/categorias continuam fluindo — não é global agent halt nem categoria-wide ban) porque continuar operando para o ator afetado durante investigação amplifica blast radius — patterns são coordenados, não evento pontual; pausar autonomia per ator afetado contém propagação enquanto humano avalia agregação retroativa, revogação ou ajuste de regra. Coordenação cross-BC com BDG (Fracionamento bidirecional, oq-bdg-1 análogo) pendente reforça severity — defesa estrutural primária ainda não existe. Contexto mínimo: ator afetado (proponente OR fornecedor), rfqId(s) envolvidas, padrão temporal observado, statistical evidence (mediana + desvio padrão da categoria)."
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Decisão para a RFQ específica bloqueada até parecer especializado; outras RFQs continuam fluindo."
		recipient:      "founder"
		rationale:      "Decisão envolve zona cinza regulatória (Lei 12.846 procurement public-private boundary, fiscal anomaly em cross-border supply, sanção a fornecedor durante RFQ ativa) OR cross-BC drift inesperado (CTR cancela contrato pós-StrategicAward sem signal Phase 0 per oq-ssc-5; preferred designation com override-rate sustentado em P2P sinalizando drift de fitness per oq-ssc-3). Integridade legal é constraint inviolável (nível 1 per CLAUDE.md); zona cinza exige julgamento humano especializado (compliance officer ou category manager designado). alert-and-block (item-specific scope: bloqueia decisão emitida para esta RFQ específica; outras RFQs continuam fluindo — não é global agent halt) porque approval autônomo em zona cinza procurement cria precedente regulatory questionável — Lei 12.846 procurement audit é constraint hard; SLA 4h proporcional a SSC gateway-primário (vs IDC raiz criptográfica 1h, BDG gate financeiro 4h). Contexto mínimo: rfqId, natureza fiscal/regulatória/cross-BC do anomaly, hipóteses de classificação."
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 2
		maxDailyActions:        50
		rationale:              "SSC tem 13 actions (4 mutations: 3 propose-and-wait per spec — act-open-rfq + act-evaluate-and-conclude-rfq + act-cancel-rfq + 1 execute-and-log per spec — act-revalidate-rfq-pool com escalationOverride conditional para pool <2 + 4 validations + 2 queries + 1 generation + 2 escalations). maxConcurrentMutations 2 limita execução paralela das 4 mutations — mutations com impacto cross-BC (P2P binding, CTR formalização, NTF transversal). Onboarding paralelo a BDG (2/50, gateway financeiro) é decisão deliberada: SSC é gateway primário do macrofluxo Mesh (primeiro BC do trio SSC→CTR→P2P) — promoção prematura amplifica risco de procurement audit gap (Lei 12.846) downstream. 2 concurrent permite processamento paralelo de até 2 RFQs em estágios distintos (uma em decision evaluation + uma em pool revalidation execute-and-log non-blocking; act-revalidate-rfq-pool conta como mutation enquanto opera autonomamente, mas quando escala via escalationOverride conditional para pool <2 não consome cap até human gate resolver). Promoção para 3+ é decisão futura via calibration. maxDailyActions 50 reflete volume esperado em onboarding pre-PMF — múltiplas RFQs por dia em diferentes estágios; queries dominam volume (P2P/CTR/controllers consumindo QuerySourcingDecision + QueryActiveSourcingDecisions). Sanity check: 50 daily ≥ 2 concurrent. Lifecycle×caps monotonicidade (tq-gvg-07): faixa onboarding canônica 1-2/20-50; 2/50 está no upper-end da banda canônica para gateway BCs em onboarding (paralelo a BDG 2/50 gateway financeiro). Recomendação de implementação: queries (act-query-*) são leitura sem efeito colateral e não deveriam consumir orçamento de mutation/validation — decisão final depende do runner."
	}

	// =============================================
	// DRIFT DETECTION (5 métricas semanal)
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-rfq-cycle-time"
			name:        "Tempo de Ciclo de RFQ"
			description: "p95 do tempo entre cmd-open-rfq (rfqOpenedAt) e evt-rfq-concluded OR evt-rfq-cancelled publicado para o mesmo rfqId, segregado por outcome (concluded com tipo de decisão vs cancelled)."
			baseline:    "p95 ≤ 7 dias para RFQs normais (one-shot/preferred), ≤ 14 dias para strategic-award (negociação multi-round potencial)"
			threshold:   "> 14 dias p95 em janela semanal para one-shot/preferred; > 30 dias para strategic-award"
			rationale:   "Latência alta indica processo competitivo travado — possível causa: insufficient-context retentions sustentados (NPM/projection latency); ambiguous-case frequente (RFQScope mal-definido sintoma de coordenação fraca com category managers); multi-round negotiation acima do esperado (oq-ssc-9 BAFO não modelado Phase 0). Threshold conservador em onboarding para acomodar variação de ciclo de category manager + janela quotation."
		}, {
			code:        "dm-rfq-cancellation-rate"
			name:        "Taxa de Cancelamento de RFQ"
			description: "Percentual de RFQs abertas que terminam em evt-rfq-cancelled (vs evt-rfq-concluded com decisão emitida) sobre total de RFQs abertas em janela semanal."
			baseline:    "< 5% das RFQs abertas (janela quotation gera cotações suficientes para decidir)"
			threshold:   "> 12% em janela semanal"
			rationale:   "Taxa alta indica scope mal-definido OR pool inadequado sustentado — possíveis causas: as-ssc-1 invalidação (pool qualificado viável violado para categorias específicas); category manager declarando RFQs sem demanda real; janela quotation curta demais. Sustained breach via regression trigger reduz autonomy enquanto causa estrutural é investigada. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-supervisor-override-rate"
			name:        "Taxa de Override Supervisor"
			description: "Percentual de RFQs que requerem supervisedDecision (override-fitness-rule OR approve-decision-with-insufficient-pool OR configure-fitness-rules OR cancel-rfq) sobre total de RFQs em janela semanal."
			baseline:    "< 10% das RFQs (canvas target hipotético — supervisedDecisions devem ser exceção, não norma)"
			threshold:   "> 20% em janela semanal"
			rationale:   "Taxa alta indica que regras determinísticas (fitness rules + signals + pool ≥ 2) não cobrem o espectro operacional — possível necessidade de revisar configuração de fitness rules, validar pool qualification scope (oq-ssc-6), ou capacidade de classificação automática. Threshold 20% margem sobre target 10% para acomodar variação onboarding; sustained breach indica calibração estrutural pendente, NÃO comportamento anômalo do agente. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-escalation-response-latency"
			name:        "Latência de Resposta a Escalações"
			description: "p95 do tempo entre escalação e resposta do founder, segregado por SLA tier (alert-and-block 4h / sync-human-review 4h / async-queue 24h)."
			baseline:    "< 4h para alert-and-block e sync-human-review; < 24h para async-queue"
			threshold:   "> 8h para alert-and-block/sync; > 48h para async-queue"
			rationale:   "Se escalações consistentemente atingem o limite de SLA, canal pode estar subdimensionado ou founder sobrecarregado. Em SSC especificamente, escalação não-resolvida retém RFQ no spine procurement-lifecycle — P2P não emite pedido sem decisão SSC vigente (bd-procurement-requires-sourcing-authority); CTR não formaliza contrato sem strategic award. Threshold tier-aware reflete que async-queue tem SLA 6x mais permissivo."
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions (50/dia) em janela semanal."
			baseline:    "< 60% de utilização média"
			threshold:   "> 90% de utilização média em janela semanal"
			rationale:   "Utilização consistente acima de 90% indica que cap está subdimensionado para demanda real, forçando agente a priorizar ou adiar operações — RFQs podem ficar retidas em filas, propagando latência para spine procurement-lifecycle. Pode justificar promoção de caps via calibration ou revisão de lifecycle stage. Binding automático drift→action via regression trigger (tq-gvg-06): breach > 90% → reduce-autonomy enquanto cap é redimensionado."
		}]
		rationale: "Cinco métricas cobrem latência do processo competitivo (rfq-cycle-time tier-aware por decisionType), qualidade de scope/pool (rfq-cancellation-rate), demanda de supervisão (supervisor-override-rate), latência de supervisão (escalation response tier-aware) e dimensionamento operacional (cap utilization). Cadência semanal adequada para onboarding — volume baixo (target 50/dia), cada semana acumula amostra suficiente. Failure handling vive em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058). Automatic enforcement bindings drift→action (tq-gvg-06): dm-rfq-cancellation-rate breach → reduce-autonomy via regression trigger; dm-supervisor-override-rate breach → reduce-autonomy via regression trigger; dm-blast-radius-utilization > 90% → reduce-autonomy via regression trigger — todas via calibration regression (não via humano direto), refletindo automatic containment quando degradação é estrutural não-comportamental."
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 15 RFQs concluded (decisão emitida — one-shot/preferred/strategic) com zero violação de invariante (inv-decision-from-structured-signals, inv-decision-type-declared-upfront, inv-qualification-as-precondition, inv-decision-rationale-required, inv-rfq-public-lifecycle-events, inv-competitive-pool-or-supervised-exception, inv-fitness-rules-versioned-config) e taxa de aprovação de recomendações ≥ 95% (founder aprova outcome em 3 mutations propose-and-wait), supervisor-override-rate ≤ 15% sustentado, rfq-cancellation-rate ≤ 8% sustentado"
			minimumObservationPeriod: "60 days"
			rationale:                "15 RFQs é volume mínimo para padrão significativo em SSC (throughput esperado em onboarding pre-PMF: <1 RFQ/dia inicialmente). 60 dias garante exposição a variação temporal (categorias com cycle distinto + estratégicas vs operacionais) e cobertura de tipos de decisão distintos (esperado distribution: ~70% one-shot, ~20% preferred, ~10% strategic-award). Taxa de aprovação 95% mede alinhamento agente↔founder em decisões propose-and-wait (3 actions; act-revalidate-rfq-pool execute-and-log NÃO entra na métrica salvo quando escala via escalationOverride conditional para pool <2). supervisor-override-rate ≤ 15% e rfq-cancellation-rate ≤ 8% são thresholds intermediários entre target hipotético (10%/5%) e drift threshold (20%/12%) — promoção exige operação aproximando-se do target sem ainda atingir."
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 50 RFQs concluded, zero violação de invariante, taxa de aprovação ≥ 98%, supervisor-override-rate ≤ 10% sustentado por 8 semanas, rfq-cancellation-rate ≤ 5% sustentado por 8 semanas, rfq-cycle-time p95 ≤ 7 days para one-shot/preferred sustentado por 8 semanas, zero drift detectado acima de threshold por 4 semanas consecutivas, audit trail verificável com reconstrução bem-sucedida em amostra de 10 decisões cobrindo todos 13 audit fields (7 mínimos + 6 SSC-specific incluindo decision-rationale como ref/hash + reconstrução do payload completo via sourcingDecisionId)"
			minimumObservationPeriod: "90 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, todos thresholds sustentados em target (não margem), drift estável, audit trail testado com reconstrução incluindo SSC-specific fields (rfq-id, sourcing-decision-id, category-ref, decision-type, selected-suppliers, fitness-rule-snapshot-id — sustentam reconstituição cap-04 auditoria contínua + Lei 12.846 procurement audit + moat de inteligência via NIM consumer pendente oq-ssc-2). 90 dias garante exposição a múltiplos ciclos estratégicos (revisões trimestrais de category strategy + fitness rules versioning per oq-ssc-8). SSC é gateway primário do macrofluxo — promoção prematura amplifica risco de procurement audit gap (Lei 12.846) e drift estrutural cross-BC."
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — falha no modelo de contenção, não comportamento pontual. Em SSC, ação fora de autonomy boundary inclui emitir decisão autônoma com pool < 2 (viola inv-competitive-pool-or-supervised-exception + cst-competitive-pool-or-supervision); cancelar RFQ sem aprovação humana (viola cst-supervised-operations-require-human-gate); aplicar fitness rules sem snapshot capturado (viola cst-fitness-rules-snapshot-immutable); act-revalidate-rfq-pool executando autonomamente quando pool resultante <2 (viola escalationOverride conditional). suspend-and-escalate porque agente não pode operar enquanto causa raiz não identificada."
		}, {
			description:     "Drift sustentado em supervisor-override-rate"
			metric:          "dm-supervisor-override-rate acima de threshold (> 20%)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach de supervisor-override-rate sinaliza desalinhamento estrutural — fitness rules subdimensionadas para volume real OR pool qualification scope frequentemente ambíguo (oq-ssc-6 invalidação) OR category managers declarando tipo incompatível com pool sustained. Promoção nesse estado amplificaria problema. Redução de autonomia força revisão mais intensiva enquanto reconfiguração estrutural está pendente — não é comportamento anômalo do agente, é sinal de governance procurement externa precisando recalibração. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Drift sustentado em rfq-cancellation-rate"
			metric:          "dm-rfq-cancellation-rate acima de threshold (> 12%)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach de rfq-cancellation-rate sinaliza desalinhamento entre demanda real e processo competitivo: scope mal-definido (categoria de compra fora da taxonomia), pool inadequado sustentado (as-ssc-1 invalidation), OR janela quotation curta demais. Redução de autonomia preserva safety enquanto fontes de cancellation são endereçadas estruturalmente. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Drift sustentado em qualquer outra métrica"
			metric:          "Qualquer métrica de driftDetection acima do threshold (exceto supervisor-override-rate e rfq-cancellation-rate cobertas acima)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado em métrica geral indica desalinhamento estrutural entre envelope e operação real — promoção nesse estado amplificaria problema. Redução de autonomia força revisão mais intensiva enquanto causa investigada."
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária — em SSC, breach amplifica risco de procurement audit gap (Lei 12.846) e drift cross-BC (P2P binding hard, CTR formalização mandatory). Redução de autonomia cria margem de segurança enquanto causa raiz investigada (cap subdimensionado vs comportamento anômalo)."
		}, {
			description:     "Padrão Fracionamento ou low-balling sustentado"
			metric:          "act-detect-fragmentation-pattern OR act-detect-suspicious-quotation emite ≥ 3 anomaly reports na mesma janela semanal apontando para padrão coordenado (mesmo proponente OR mesmo fornecedor OR padrão temporal recorrente)"
			threshold:       "1 avaliação acima de threshold"
			immediateAction: "suspend-and-escalate"
			rationale:       "Sustained anomaly detection sugere vetor adversarial ativo (sh-01 manipulationVector OR sh-02 manipulationVector). suspend-and-escalate (não reduce-autonomy gradual) porque patterns são coordenados — continuar operando degraded amplifica blast radius cross-RFQ enquanto coordenação cross-BC com BDG (Fracionamento bidirecional, oq-bdg-1 análogo) pendente; tolerance 1 avaliação reflete severity tier alto. Suspend é global agent halt nesta camada (regression trigger), distinto de routing alert-and-block que é per-actor scope."
		}]
		rationale: "Promoção em dois estágios: onboarding→validation (15/60d, override ≤ 15%, cancellation ≤ 8%) e validation→operational (50/90d, supervisor-override ≤ 10% + rfq-cancellation ≤ 5% + rfq-cycle-time ≤ 7d em target sustentado por 8 semanas). Critérios alinhados com BDG (25/60 e 80/90) ajustados para SSC: volume menor onboarding→validation (15 vs BDG 25) reflete que SSC tem ciclo mais longo por RFQ que BDG (gate vs aprovação imediata); volume validation→operational (50 vs BDG 80) reflete cadência menor de procurement vs aprovação orçamentária. Regressão com 6 triggers: tolerance zero para violação de autonomy boundary (suspend-and-escalate; inclui act-revalidate-rfq-pool executando autonomamente quando pool resultante <2 — viola escalationOverride conditional do spec), detecção precoce com binding automático drift→action para 2 métricas operacionais (supervisor-override-rate e rfq-cancellation-rate, ambas reduce-autonomy), drift sustentado geral (reduce-autonomy), breach de blast radius (reduce-autonomy), e severity máxima para Fracionamento/low-balling sustentado (suspend-and-escalate, tolerance 1 avaliação refletindo vetores adversariais conhecidos sem defesa estrutural primária per oq-bdg-1 análogo). Calibração conservadora para BC gateway primário do macrofluxo Mesh em fase pré-PMF — SSC condiciona spine procurement-lifecycle (P2P/CTR consumem decisão), priorizar safety sobre speed é axiomático. Phase 0 baseline preserva 3 mutations propose-and-wait + 1 execute-and-log via spec; promotion para execute-and-log das 3 propose-and-wait via calibration crossing thresholds — tq-gv-14 forbid override direto preserva P10."
	}

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno do agente (exception, comportamento não-determinístico em fitness rule application): halt operations imediatamente, escalate to founder for root cause analysis antes de retomar. SSC severity tier alto — agente não-determinístico em gateway procurement compromete spine procurement-lifecycle (P2P/CTR consumem decisão como pré-condição de pedido/contrato per bd-procurement-requires-sourcing-authority); Lei 12.846 procurement audit exige reproducibilidade do gate."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s); aplicável a queries de prj-active-sourcing-decisions + prj-sourcing-decision-by-id + prj-rfq-history-by-category que retornem timeout. Sem retry para QueryParticipantStatus cross-BC (NPM single-owner): timeout aqui é estrutural — re-validation falhada não pode ser overlooked, suspend imediato via insufficient-context routing."
			description: "Timeout em operação: retry once para queries de projeção intra-BC; falha persiste = suspend e escalate via insufficient-context routing (alert-and-block item-specific) carregando contexto de qual SoT timeout. Para QueryParticipantStatus cross-BC NPM (act-build-supplier-pool, act-revalidate-qualification, act-revalidate-rfq-pool), suspend imediato sem retry — fallback humano via insufficient-context. Para act-evaluate-and-conclude-rfq fitness rule application timeout (svc-fitness-rule-evaluator hang), suspend imediato sem retry — bug determinístico em rule application exige investigação antes de retry."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h sugerem issue sistêmico (degradação de NPM QueryParticipantStatus sustentada, fitness rules config externa indisponível per oq-ssc-8, OR projection prj-rfq-history-by-category corrompida). Suspend + immediate founder notification — SSC gateway primário não tolera operação degraded sustentada porque amplifica risco de procurement audit gap cross-BC (P2P emite pedido sem decisão SSC vigente é violação de bd-procurement-requires-sourcing-authority)."
		}
		rationale: "Per adr-058 promotion de tech debt narrative para field first-class. SSC severity tier alto (gateway primário do macrofluxo Mesh, Lei 12.846 procurement audit): suspend-and-escalate em todos 3 eventos por padrão Phase 0; retry conservador em onTimeout aplicável apenas a queries de projeção intra-BC; cross-BC NPM queries e fitness rule application não retentam — timeout aqui é estrutural ou determinístico. 3/24h threshold para repeated failure reflete tolerance baixa apropriada para criticality procurement sem ser raiz criptográfica (vs idc 3/24h tier máximo regulatory; paralelo a BDG 3/24h tier alto financeiro)."
	}

	rationale: "Envelope de governança do agt-ssc-primary em lifecycle onboarding. SSC é gateway primário do macrofluxo Mesh — primeiro BC do trio canônico SSC→CTR→P2P (SSC decide sourcing; CTR formaliza contrato; P2P executa compra). Bidirectional ref validado: agent-spec.code 'agt-ssc-primary' == agentRef; agent-spec.governanceRef 'ssc-primary-agent' == base name deste arquivo (tq-gv-06). 6 rotas de escalação cobrindo 6 categories do agent-spec.escalationConditions: sync-human-review para conflicting-signals/ambiguous-case (resolução rápida contém propagação de incerteza, item-specific scope); alert-and-block para insufficient-context (item-specific scope: bloqueia decisão emitida para esta RFQ; outras RFQs continuam fluindo) + suspicious-input (block scope = ator afetado per janela de detecção; outras RFQs com outros atores/categorias continuam fluindo) + unclassifiable-anomaly (item-specific scope: zona cinza Lei 12.846 procurement audit); async-queue para out-of-scope (item-specific; cobre também escalation conditional de act-revalidate-rfq-pool quando pool <2). Routing precedence quando categories concorrem: blocking > non-blocking; mutation-related > informational; explicit > fallback (tq-gvg-05). Blast radius caps dimensionados conservadoramente para onboarding gateway primário (2/50; paralelo a BDG 2/50 gateway financeiro — gateway primário do macrofluxo exige promoção gradual de cap via calibration; entra na canonical band onboarding 1-2/20-50 upper-end). Drift detection semanal com 5 métricas: rfq-cycle-time tier-aware por decisionType + rfq-cancellation-rate + supervisor-override-rate (3 métricas operacionais SSC) + latência de supervisão tier-aware + cap utilization. Failure handling declarado em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058): suspend-and-escalate em todos 3 eventos com severity tier alto; retry conservador em onTimeout aplicável apenas a queries de projeção intra-BC; cross-BC NPM queries não retentam (timeout estrutural). Automatic enforcement bindings drift→action (tq-gvg-06): supervisor-override-rate breach → reduce-autonomy; rfq-cancellation-rate breach → reduce-autonomy; blast-radius-utilization > 90% → reduce-autonomy. Calibração: promoção 15/60 onboarding→validation com supervisor-override ≤ 15% / cancellation ≤ 8% intermediários; 50/90 validation→operational com 3 métricas em target sustentado por 8 semanas + audit trail reconstrução com decision-rationale ref/hash; regressão com 6 triggers incluindo tolerance 1-avaliação para Fracionamento/low-balling sustentado (severity máxima vetores adversariais sem defesa estrutural primária — suspend-and-escalate é global halt nesta camada, distinto de routing alert-and-block que é per-actor scope). Phase 0 baseline preserva 3 mutations propose-and-wait + 1 execute-and-log via spec sem autonomyOverrides; act-revalidate-rfq-pool é execute-and-log quando preserva pool ≥2 e escala via escalationOverride conditional para out-of-scope async-queue quando pool <2 (human gate via escalation, não via mudança de autonomyLevel); promotion para execute-and-log das 3 propose-and-wait via calibration crossing thresholds — tq-gv-14 forbid override direto preserva P10. Envelope é control plane apenas (tq-gvg-09): routing + caps + calibration + drift + lifecycle; nenhuma business logic vazada (decisões de domain — invariants Decision/Qualification/Pool/Rationale/Lifecycle/Fitness-Rules + fitness rule application + pool building + Fracionamento/low-balling detection + taxonomy de Categoria de Compra — vivem em agent-spec.constraints e domain-model). Boundaries do canvas businessDecisions preservadas: bd-deterministic-decision-from-structured-signals (drift metrics não interpretam signals; routing trata signals conflitantes como bloqueio item-specific, não como autonomia implícita), bd-decision-type-is-declared-upfront (sem caps por tipo de decisão — caps uniformes preservam tipo declarado upfront), bd-qualification-as-absolute-precondition (insufficient-context routing trata NPM unavailability como bloqueio item-specific), bd-rfq-lifecycle-public-minimal (drift metrics rastreiam lifecycle pareado RFQOpened/Concluded/Cancelled), bd-procurement-requires-sourcing-authority (regression triggers tolerance zero para violação de autonomy boundary preserva autoridade SSC cross-BC). Lenses: aag (primária), incentive-alignment (secundária — defesa contra manipulação via routing alert-and-block escopado para suspicious-input), ora (secundária), rc (terciária — Lei 12.846 procurement audit)."
}
