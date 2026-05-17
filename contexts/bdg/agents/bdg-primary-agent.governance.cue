package bdg

// bdg-primary-agent.governance.cue — Governance Envelope: BDG Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do BDG.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (bdg-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode
//   override (Phase 0: nenhum override declarado; promoção via
//   calibration declarada, não via override retroativo)
// - agent-spec declara observability signals → este envelope define
//   drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária)
// - lens-security-trust-infrastructure (secundária)
// - lens-organizational-resource-allocation (secundária)
// - lens-regulatory-compliance-as-architecture (terciária)
//
// Phase 0 caveats:
// - governanceGlobalVersion "0.1" é forward reference (Phase 0
//   canonical pattern per cmt/ctr/idc/npm).
// - Nenhum autonomyOverride: 2 mutations (act-execute-coverage-gate,
//   act-propose-budget-commitment-release) permanecem propose-and-wait.
//   Promotion para execute-and-log da gate determinística é decisão
//   futura via calibration crossing thresholds — tq-gv-14 forbid
//   override direto execute-and-log para mutations preserva P10.
// - Detecção de Fracionamento cross-BC (oq-bdg-1) não modelada como
//   métrica de drift local; fica em escalation routing como
//   suspicious-input.
//
// Authoring via subagent dispatch (disp-007, WI-048 phase 5 — final
// do BDG BC bootstrap). Founder review aplicou 1 ajuste obrigatório
// pre-write: blastRadiusCaps.maxConcurrentMutations 3→2 (gateway
// financeiro mais conservador que CTR/NPM em onboarding; entra na
// canonical band onboarding 1-2/20-50 sem upper-end).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

bdgPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-bdg-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING
	// =============================================

	escalationRouting: [{
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "Configuração de Centro de Custo divergente entre fontes (escopo CMT aponta para Centro X, configuração externa associa o tipo de operação a Centro Y) OR mudança em curso de plano de Centros de Custo. Canal sync e SLA curto porque conflito não-resolvido bloqueia spine commitment-lifecycle (DLV aguarda BudgetApproved) e pode criar precedente inconsistente entre Centros — divergência propaga para reconciliação contábil cross-BC. Agente não tem autoridade para decidir precedência entre fontes per bd-cost-center-as-sot. Contexto mínimo: CommitmentId, escopo CMT recebido, Centros candidatos, fonte de cada classificação."
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até contexto fornecido."
		recipient:      "founder"
		rationale:      "prj-cost-center-availability indisponível ou stale; tabela de Alçadas não acessível; configuração de Centros de Custo em janela de transição (as-bdg-3 invalidation signal). alert-and-block porque prosseguir sem SoT autoritativa de Saldo viola integridade de inv-coverage-gate-deterministic — outcome rejected automático sem visibilidade seria conclusão definitiva de ausência de cobertura, não falta de visibilidade (rejeição inadequada propaga inadimplência programática downstream). Bloqueio é mais conservador que rejeição falsa em Phase 0. Contexto mínimo: qual SoT falhou, latência observada, alternativas consultadas, CommitmentId pendente."
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Aprovação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "Centro de Custo aplicável é ambíguo — escopo cobre múltiplos Centros, OR Centro indicado conflita com escopo CMT (canvas supervisedDecision approve-budget-with-cost-center-ambiguity). Caso intermediário entre identificação determinística (as-bdg-1) e impossibilidade total — classificação errada propaga para reconciliação contábil e quebra bd-cost-center-as-sot. Canal sync porque ambiguidade retém compromisso específico, mas não bloqueia operações concorrentes em outros Centros — async-queue seria insuficiente porque latência acumula em Centros com volume alto de ambiguidade (sintoma de as-bdg-1 invalidação). Contexto mínimo: CommitmentId, escopo CMT recebido, Centros candidatos com rationale de cada hipótese."
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. Compromisso retido pendente de decisão supervisora."
		recipient:      "founder"
		rationale:      "Cobre 3 condições compartilhando routing por taxonomia atual: (1) aprovação fora de Alçada (canvas supervisedDecision approve-budget-out-of-alcada); (2) ajuste de Limite de Centro de Custo (canvas supervisedDecision adjust-cost-center-limit, fora do escopo per inv-allocation-not-treasury); (3) liberação de Comprometimento com trigger cross-BC ainda não formalizado (oq-bdg-2). async-queue porque nenhuma das 3 bloqueia operações concorrentes — apenas o item específico fica retido; aprovações dentro de Alçada continuam fluindo. SLA 24h reflete tempo razoável para founder avaliar sem urgência sub-diária dado que approval fora de Alçada é fluxo planejado, não emergência. Contexto mínimo: condição específica, CommitmentId/CostCenterId/BudgetCommitmentId conforme aplicável, valor solicitado vs Alçada vigente, justificativa do proponente."
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Aprovações para o proponente afetado pausadas até decisão."
		recipient:      "founder"
		rationale:      "Padrão de Fracionamento detectado por act-detect-fragmentation-pattern (canvas escalationCriteria fragmentation-pattern-detected). Threshold gaming é vetor adversarial conhecido per canvas incentiveAnalysis (sh-01 manipulationVector). alert-and-block (não sync-human-review) porque continuar aprovando para o proponente afetado durante investigação amplifica blast radius — Fracionamento é padrão coordenado, não evento pontual; pausar autonomia per proponente afetado contém propagação enquanto humano avalia agregação retroativa, revogação ou ajuste de regra. Coordenação cross-BC com REW pendente (oq-bdg-1) reforça severity — defesa estrutural primária ainda não existe. Contexto mínimo: proponente afetado, Centro de Custo, padrão temporal observado, CommitmentIds candidatos a agregação retroativa."
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Aprovação bloqueada até parecer especializado."
		recipient:      "founder"
		rationale:      "Compromisso envolve estrutura orçamentária em zona cinza fiscal ou regulatória — Centro de Custo associado a operação tributária não rotineira, comprometimento que pode requerer reporte específico (canvas escalationCriteria regulatory-or-fiscal-ambiguity). Integridade legal é constraint inviolável (nível 1 per CLAUDE.md); zona cinza exige julgamento humano especializado. alert-and-block porque approval autônomo de comprometimento em zona cinza fiscal cria precedente regulatory questionável — diferentemente de IDC (raiz criptográfica com SLA 1h), BDG opera em camada orçamentária prospectiva, então 4h é proporcional. Contexto mínimo: CommitmentId, natureza fiscal/regulatória da operação, Centro de Custo associado, hipóteses de classificação tributária."
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 2
		maxDailyActions:        50
		rationale:              "BDG tem 8 actions (2 mutations propose-and-wait + 2 queries + 2 validations + 1 generation + 1 escalation, todas execute-and-log exceto as 2 mutations). maxConcurrentMutations 2 limita execução paralela de act-execute-coverage-gate + act-propose-budget-commitment-release — mutations com impacto financeiro cross-BC. Onboarding mais conservador que CTR/NPM (3/50) é decisão deliberada: BDG é gateway financeiro do commitment lifecycle (DLV consume BudgetApproved como invariante per bd-coverage-as-invariant; CMT/DRC consumem BudgetRejected/BudgetCommitmentReleased pendente oq-bdg-2) — promoção prematura do cap amplifica risco de inadimplência programática downstream. 2 concurrent permite processamento paralelo de até 2 compromissos em estágios distintos do gate sem saturar contexto do agente; promoção para 3+ é decisão futura via calibration. maxDailyActions 50 reflete volume esperado em onboarding — compromissos chegam de CMT em cadência derivada de spine commitment-lifecycle (não high-volume vs CMT 80/dia que origina os compromissos); maioria das ações são queries (act-query-budget-approval-status, act-query-cost-center-availability) consumidas por CMT/DRC/controllers e validações pré-gate. Sanity check: 50 daily ≥ 2 concurrent. Lifecycle×caps monotonicidade (tq-gvg-07): faixa onboarding canônica 1-2/20-50; 2/50 está dentro da banda canônica para gateway BCs em onboarding (vs ctr/npm 3/50 upper-end, idc 2/40 raiz criptográfica). Recomendação de implementação: queries (act-query-*) são leitura sem efeito colateral e não deveriam consumir orçamento de mutation/validation — decisão final depende do runner."
	}

	// =============================================
	// DRIFT DETECTION
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-budget-approval-time"
			name:        "Tempo Médio de Aprovação Orçamentária"
			description: "p95 do tempo entre evt-commitment-accepted-received (ACL de CommitmentAccepted) e evt-budget-approved OR evt-budget-rejected publicado para o mesmo CommitmentId, segregado por outcome (approved vs rejected). Materializa canvas verificationMetric budget-approval-time."
			baseline:    "< 5 minutos para 95% dos compromissos dentro de Alçada (canvas target)"
			threshold:   "> 15 minutos p95 em janela semanal"
			rationale:   "Latência alta indica que Gate de Cobertura não opera como gate sub-segundo — possível regressão para semi-manual (as-bdg-1 invalidação: ambiguidade de Centro de Custo frequente força sequência de escalations) OR tabela de Alçadas/configuração de Centros de Custo em janela de transição (as-bdg-3) gerando insufficient-context retentions. Threshold 15min em onboarding (vs target 5min canvas) é tolerância pós-Phase-0 inicial — Phase 0 propose-and-wait adiciona latência de aprovação humana que será removida via promotion. Vinculada direta a canvas verificationMetric."
		}, {
			code:        "dm-budget-rejection-rate"
			name:        "Taxa de Rejeição Orçamentária"
			description: "Percentual de evt-commitment-accepted-received que resultam em evt-budget-rejected (vs evt-budget-approved) sobre total avaliado, segregado por reason code (insufficient-balance / invalid-cost-center / alcada-exceeded). Materializa canvas verificationMetric budget-rejection-rate."
			baseline:    "< 3% dos compromissos avaliados (canvas target)"
			threshold:   "> 8% em janela semanal"
			rationale:   "Taxa alta indica desalinhamento entre formalização (CMT) e governance orçamentária (BDG) — possíveis causas: configuração de Limite restritiva (sintoma de as-bdg-2 invalidation), falta de visibilidade pré-formalização (oq-bdg-3), drift de plano de Centros de Custo (as-bdg-3). Threshold 8% em onboarding é margem sobre target 3% para acomodar variação de início; sustained breach via regression trigger reduz autonomy enquanto causa estrutural é investigada. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-supervisor-override-rate"
			name:        "Taxa de Override Supervisor"
			description: "Percentual de aprovações que requerem supervisedDecision (approve-budget-out-of-alcada OR approve-budget-with-cost-center-ambiguity OR adjust-cost-center-limit) sobre total de aprovações. Materializa canvas verificationMetric supervisor-override-rate."
			baseline:    "< 10% das aprovações totais (canvas target)"
			threshold:   "> 20% em janela semanal"
			rationale:   "Taxa alta indica que regras determinísticas não cobrem o espectro operacional — possível necessidade de revisar tabela de Alçadas (Alçada do agente subdimensionada para volume), plano de Centros de Custo (as-bdg-3), ou capacidade de classificação automática (as-bdg-1 invalidação). Threshold 20% é margem sobre target 10% canvas; sustained breach indica calibração estrutural pendente, NÃO comportamento anômalo do agente. Binding automático drift→action via regression trigger (tq-gvg-06)."
		}, {
			code:        "dm-escalation-response-latency"
			name:        "Latência de Resposta a Escalações"
			description: "p95 do tempo entre escalação e resposta do founder, segregado por SLA tier (alert-and-block 4h / sync-human-review 4h / async-queue 24h)."
			baseline:    "< 4h para alert-and-block e sync-human-review; < 24h para async-queue"
			threshold:   "> 8h para alert-and-block/sync; > 48h para async-queue"
			rationale:   "Se escalações consistentemente atingem o limite de SLA, canal pode estar subdimensionado ou founder sobrecarregado. Em BDG especificamente, escalação não-resolvida retém compromisso no spine commitment-lifecycle — DLV não progride sem BudgetApproved (bd-coverage-as-invariant). Threshold tier-aware reflete que async-queue tem SLA 6x mais permissivo."
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions (50/dia) em janela semanal."
			baseline:    "< 60% de utilização média"
			threshold:   "> 90% de utilização média em janela semanal"
			rationale:   "Utilização consistente acima de 90% indica que cap está subdimensionado para demanda real, forçando agente a priorizar ou adiar operações — compromissos podem ficar retidos em filas, propagando latência para spine commitment-lifecycle. Pode justificar promoção de caps via calibration ou revisão de lifecycle stage. Binding automático drift→action via regression trigger (tq-gvg-06): breach > 90% → reduce-autonomy enquanto cap é redimensionado."
		}]
		rationale: "Cinco métricas cobrem latência do gate (budget-approval-time vinculada a canvas verificationMetric), qualidade de classificação (budget-rejection-rate vinculada a canvas verificationMetric), demanda de supervisão (supervisor-override-rate vinculada a canvas verificationMetric), latência de supervisão (escalation response tier-aware) e dimensionamento operacional (cap utilization). Cadência semanal adequada para onboarding — volume baixo (target 50/dia), cada semana acumula amostra suficiente. 3 das 5 métricas materializam diretamente as 3 verificationMetrics do canvas BDG — alinhamento direto entre detecção de drift técnico e detecção de degradação de saúde de domínio. Failure handling vive em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058). Automatic enforcement bindings drift→action (tq-gvg-06): dm-budget-rejection-rate breach → reduce-autonomy via regression trigger; dm-supervisor-override-rate breach → reduce-autonomy via regression trigger; dm-blast-radius-utilization > 90% → reduce-autonomy via regression trigger — todas via calibration regression (não via humano direto), refletindo automatic containment quando degradação é estrutural não-comportamental."
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 25 compromissos processados (approved + rejected) com zero violação de invariante (inv-coverage-gate-deterministic, inv-cost-center-required, inv-alcada-respected, inv-commitment-not-payment, inv-allocation-not-treasury, inv-released-amount-matches-commitment, inv-commitment-id-global-uniqueness-active) e taxa de aprovação de recomendações ≥ 95% (founder aprova outcome em mutations propose-and-wait), supervisor-override-rate ≤ 15% sustentado, budget-rejection-rate ≤ 5% sustentado"
			minimumObservationPeriod: "60 days"
			rationale:                "25 compromissos é volume mínimo para padrão significativo em BDG (throughput médio: gate orçamentário recebe de CMT em cadência derivada — entre cmt high 20/80 e idc low 15/60). 60 dias garante exposição a variação temporal de planejamento (ciclos quinzenais de plano de Centros de Custo) e cobertura de Alçadas distintas. Taxa de aprovação 95% mede alinhamento agente↔founder em decisões propose-and-wait. supervisor-override-rate ≤ 15% e budget-rejection-rate ≤ 5% são thresholds intermediários entre target canvas (10%/3%) e drift threshold (20%/8%) — promoção exige operação aproximando-se do target sem ainda atingir."
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 80 compromissos processados, zero violação de invariante, taxa de aprovação ≥ 98%, supervisor-override-rate ≤ 10% sustentado por 8 semanas (canvas target), budget-rejection-rate ≤ 3% sustentado por 8 semanas (canvas target), budget-approval-time p95 ≤ 5min sustentado por 8 semanas (canvas target), zero drift detectado acima de threshold por 4 semanas consecutivas, audit trail verificável com reconstrução bem-sucedida em amostra de 10 operações cobrindo todos 12 audit fields (7 mínimos + 5 BDG-specific)"
			minimumObservationPeriod: "90 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, todas 3 verificationMetrics canvas sustentadas em target (não margem), drift estável, audit trail testado com reconstrução incluindo BDG-specific fields (commitment-id, cost-center-id, budget-commitment-id, available-balance-snapshot, alcada-applied — sustentam reconstituição cap-04 auditoria contínua regulatory-grade). 90 dias garante exposição a múltiplos ciclos de plano de Centros de Custo (revisões trimestrais per as-bdg-3). BDG é gate financeiro do commitment lifecycle — promoção prematura amplifica risco de inadimplência programática downstream (DLV/INV/FCE consumem cobertura como invariante)."
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — falha no modelo de contenção, não comportamento pontual. Em BDG, ação fora de autonomy boundary inclui aprovar autonomamente compromisso fora de Alçada (viola inv-alcada-respected + cst-alcada-respected-autonomous + mech-agent-gate) OR materializar liberação sem aprovação humana (viola cst-release-and-out-of-alcada-require-supervision). suspend-and-escalate porque agente não pode operar enquanto causa raiz não identificada."
		}, {
			description:     "Drift sustentado em supervisor-override-rate (canvas verificationMetric)"
			metric:          "dm-supervisor-override-rate acima de threshold (> 20%)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach de supervisor-override-rate sinaliza desalinhamento estrutural — tabela de Alçadas subdimensionada para volume real OR as-bdg-1 invalidação (Centro de Custo não-determinístico frequente) OR as-bdg-3 invalidação (plano de Centros de Custo em mutação). Promoção nesse estado amplificaria problema. Redução de autonomia força revisão mais intensiva enquanto reconfiguração estrutural está pendente — não é comportamento anômalo do agente, é sinal de governance financeira externa precisando recalibração. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Drift sustentado em budget-rejection-rate (canvas verificationMetric)"
			metric:          "dm-budget-rejection-rate acima de threshold (> 8%)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Sustained breach de budget-rejection-rate sinaliza desalinhamento CMT↔BDG: compromissos chegam sem cobertura possível (Limite restritivo per as-bdg-2 invalidation, OR ausência de query pré-formalização per oq-bdg-3, OR as-bdg-3 drift). Redução de autonomia preserva safety enquanto fontes de rejeição são endereçadas estruturalmente. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Drift sustentado em qualquer outra métrica"
			metric:          "Qualquer métrica de driftDetection acima do threshold (exceto supervisor-override-rate e budget-rejection-rate cobertas acima)"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado em métrica geral indica desalinhamento estrutural entre envelope e operação real — promoção nesse estado amplificaria problema. Redução de autonomia força revisão mais intensiva enquanto causa investigada."
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária — em BDG, breach amplifica risco financeiro (mutations afetam Saldo Disponível e Comprometimento Orçamentário cross-Centro). Redução de autonomia cria margem de segurança enquanto causa raiz investigada (cap subdimensionado vs comportamento anômalo)."
		}, {
			description:     "Padrão de Fracionamento sustentado (canvas escalation criterion)"
			metric:          "act-detect-fragmentation-pattern emite ≥ 3 anomaly reports na mesma janela semanal apontando para padrão coordenado (mesmo proponente OR mesmo Centro de Custo OR padrão temporal recorrente)"
			threshold:       "1 avaliação acima de threshold"
			immediateAction: "suspend-and-escalate"
			rationale:       "Sustained Fracionamento detection sugere vetor adversarial ativo (sh-01 manipulationVector). suspend-and-escalate (não reduce-autonomy gradual) porque Fracionamento é padrão coordenado — continuar operando degraded amplifica blast radius cross-compromisso enquanto coordenação cross-BC com REW (oq-bdg-1) pendente; tolerance 1 avaliação reflete severity tier alto."
		}]
		rationale: "Promoção em dois estágios: onboarding→validation (25/60d, override ≤ 15%, rejection ≤ 5%) e validation→operational (80/90d, todas 3 verificationMetrics canvas em target sustentado por 8 semanas). Critérios alinhados com cmt (20/30 e 80/60) ajustados para BDG: período mais longo onboarding→validation (60 dias vs cmt 30) reflete necessidade de exposição a ciclos de plano de Centros de Custo; volume maior validation→operational reflete que BDG é gate de spine commitment-lifecycle — promoção prematura amplifica risco financeiro downstream. Regressão com 6 triggers: tolerance zero para violação de autonomy boundary (suspend-and-escalate), detecção precoce com binding automático drift→action para 2 verificationMetrics canvas (supervisor-override-rate e budget-rejection-rate, ambas reduce-autonomy), drift sustentado geral (reduce-autonomy), breach de blast radius (reduce-autonomy), e severity máxima para Fracionamento sustentado (suspend-and-escalate, tolerance 1 avaliação refletindo vetor adversarial conhecido sem defesa estrutural primária per oq-bdg-1). Calibração conservadora para BC gateway financeiro em fase pré-PMF — BDG condiciona spine commitment-lifecycle (DLV/INV/FCE consumem cobertura), priorizar safety sobre speed é axiomático. Phase 0 baseline preserva 2 mutations propose-and-wait; promotion para execute-and-log via calibration crossing thresholds — tq-gv-14 forbid override direto preserva P10."
	}

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno do agente (exception, comportamento não-determinístico em gate de cobertura financeiro): halt operations imediatamente, escalate to founder for root cause analysis antes de retomar. BDG severity tier alto — agente não-determinístico em gate financeiro compromete spine commitment-lifecycle (BudgetApproved consumido por DLV como pré-condição inviolável per bd-coverage-as-invariant)."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s); aplicável a queries de prj-cost-center-availability + prj-budget-approval-status que retornem timeout. Sem retry para operações de gate determinístico (comparação numérica Saldo+Alçada) — timeout aqui é bug determinístico."
			description: "Timeout em operação: retry once para queries de projeção (prj-cost-center-availability stale ou indisponível); falha persiste = suspend e escalate via insufficient-context routing (alert-and-block) carregando contexto de qual SoT timeout. Para act-identify-cost-center timeout (configuração externa de Centros de Custo indisponível), suspend imediato sem retry — fallback humano via ambiguous-case routing."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h sugerem issue sistêmico (degradação de SoT prj-cost-center-availability sustentada, configuração externa de Centros de Custo em janela de mutação prolongada per as-bdg-3, OR tabela de Alçadas inacessível). Suspend + immediate founder notification — BDG gate financeiro não tolera operação degraded sustentada porque amplifica risco de inadimplência programática cross-BC."
		}
		rationale: "Per adr-058 promotion de tech debt narrative para field first-class. BDG severity tier alto (gate financeiro de spine commitment-lifecycle): suspend-and-escalate em todos 3 eventos por padrão Phase 0; retry conservador em onTimeout aplicável apenas a queries de projeção (prj-cost-center-availability, prj-budget-approval-status); operações de gate determinístico (comparação numérica) e configuração externa não retentam — timeout aqui é determinístico ou estrutural. 3/24h threshold para repeated failure reflete tolerance baixa apropriada para criticality financeira sem ser raiz criptográfica (vs idc 3/24h tier máximo regulatory)."
	}

	rationale: "Envelope de governança do agt-bdg-primary em lifecycle onboarding. BDG é gate de cobertura orçamentária do commitment lifecycle — consome CommitmentAccepted de CMT (via ACL evt-commitment-accepted-received) e publica BudgetApproved para DLV (spine commitment-lifecycle no context-map). Bidirectional ref validado: agent-spec.code 'agt-bdg-primary' == agentRef; agent-spec.governanceRef 'bdg-primary-agent' == base name deste arquivo (tq-gv-06). 6 rotas de escalação cobrindo 6 categories do agent-spec.escalationConditions: sync-human-review para conflicting-signals/ambiguous-case (resolução rápida contém propagação de incerteza); alert-and-block para insufficient-context (prosseguir sem SoT autoritativa de Saldo viola inv-coverage-gate-deterministic) + suspicious-input (Fracionamento padrão coordenado — pausar autonomia per proponente afetado contém propagação dado coordenação cross-BC com REW pendente per oq-bdg-1) + unclassifiable-anomaly (zona cinza fiscal/regulatória); async-queue para out-of-scope. Routing precedence quando categories concorrem: blocking > non-blocking; mutation-related > informational; explicit > fallback (tq-gvg-05). Blast radius caps dimensionados conservadoramente para onboarding gateway financeiro (2/50; mais conservador que ctr/npm 3/50 — gateway financeiro do commitment lifecycle exige promoção gradual de cap via calibration; entra na canonical band onboarding 1-2/20-50 sem upper-end). Drift detection semanal com 5 métricas: 3 vinculadas diretamente a canvas verificationMetrics (budget-approval-time, budget-rejection-rate, supervisor-override-rate) + latência de supervisão tier-aware + cap utilization. Failure handling declarado em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058): suspend-and-escalate em todos 3 eventos com severity tier alto; retry conservador em onTimeout aplicável apenas a queries de projeção. Automatic enforcement bindings drift→action (tq-gvg-06): supervisor-override-rate breach → reduce-autonomy via regression trigger; budget-rejection-rate breach → reduce-autonomy; blast-radius-utilization > 90% → reduce-autonomy. Calibração: promoção 25/60 onboarding→validation com supervisor-override ≤ 15% / rejection ≤ 5% intermediários; 80/90 validation→operational com 3 verificationMetrics canvas em target sustentado por 8 semanas; regressão com 6 triggers incluindo tolerance 1-avaliação para Fracionamento sustentado (severity máxima vetor adversarial sem defesa estrutural primária). Phase 0 baseline preserva 2 mutations propose-and-wait sem autonomyOverrides; promotion para execute-and-log via calibration crossing thresholds — tq-gv-14 forbid override direto preserva P10. Envelope é control plane apenas (tq-gvg-09): routing + caps + calibration + drift + lifecycle; nenhuma business logic vazada (decisões de domain — invariants Coverage/CostCenter/Alcada, Fracionamento detection, taxonomy de Centros de Custo — vivem em agent-spec.constraints e domain-model). Boundaries do canvas businessDecisions preservadas: bd-commitment-not-payment (drift metrics não consultam TCM nem FCE; routing não envolve esses BCs), bd-allocation-not-treasury (caps e routing não permitem realocação autônoma — adjust-cost-center-limit é out-of-scope async-queue), bd-cost-center-as-sot (insufficient-context/conflicting-signals/ambiguous-case routing tratam ambiguidade de Centro como bloqueio, não como autonomia implícita), bd-coverage-as-invariant (regression triggers tolerance zero para violação de inv-coverage-gate-deterministic). Lenses: aag (primária), sti (secundária), ora (secundária), rc (terciária)."
}
