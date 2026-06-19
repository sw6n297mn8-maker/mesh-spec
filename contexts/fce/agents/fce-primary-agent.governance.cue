package fce

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// fce-primary-agent.governance.cue — Governance Envelope do agt-fce-primary.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/
// agent-governance.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// agent-governance.cue (manualAuthoringProtocol per adr-057). Par sequencial
// do agent-spec (fce-primary-agent.cue) per ADR-037 / cascade adr-054:
// o spec declara CAPACIDADE + QUANDO escalar; este envelope declara
// AUTONOMIA atual + COMO escalar (channel/SLA/recipient). tq-gv-06:
// agentRef == spec.code (agt-fce-primary); o filename base == spec.governanceRef
// (fce-primary-agent).
//
// RATIFICAÇÃO adr-155 — a assimetria promovível-vs-permanente ganha enforcement
// aqui: o calibration.promotionCriteria terá como alvo as 3 mutations
// autônomas (gate/dispatch/settle) rumo ao execute-and-log/24h do canvas, e
// NUNCA o override (act-resolve-guard-escalation) — tq-gv-14 (override jamais
// execute-and-log). Neste bloco (routing), a categoria unclassifiable-anomaly
// (que carrega o breach, p11-invariant-breach-detected) roteia para
// alert-and-block — o freeze do (ii) do rtd-018; e a ambiguous-case (o override
// central) roteia para o supervisor humano que supre o supervisorId.

fcePrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-fce-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING
	// =============================================
	//
	// 1 routing por categoria dos 6 escalationConditions do spec.

	escalationRouting: [{
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Autorização do Payment afetado bloqueada até reconciliação."
		recipient:      "founder"
		rationale:      "Sinais divergentes entre as fontes do guard (fatura INV / elegibilidade REW / cadeia de evidência) OR lineage cancel-then-reissue. Canal sync + SLA curto porque divergência não-resolvida não pode mover dinheiro (P11) nem ser rejeitada automaticamente (rejeição falsa propaga). O agente não tem autoridade para decidir precedência entre fontes. Contexto mínimo: paymentId, commitmentRef, fatos das 3 fontes e a divergência."
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Dispatch autônomo bloqueado até o gate garantir P11."
		recipient:      "founder"
		rationale:      "Inputs do guard indisponíveis/stale (REW/INV stale, EvidencePort indisponível — prepayment-guard-systemic-failure) OR SettlementIndeterminate persistente. alert-and-block porque gate comprometido = nenhuma garantia de money-on-proof; o fail-safe é parar de mover dinheiro, não degradar a verificação (dp-04). Bloqueio é mais conservador que rejeição falsa em Phase 0. Contexto mínimo: qual input falhou, latência observada, paymentId pendente."
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Payment retido em escalated até decisão nominal do supervisor."
		recipient:      "supervisor sh-05 + founder (autoridade canônica per ADR-037)"
		rationale:      "O PrePaymentGuard reprovou NÃO-LIMPO (stale/incompleta/ambígua-mas-PRESENTE) — o Payment está em escalated (canvas supervisedDecision override-prepayment-guard). É a escalada CENTRAL do adr-155: o supervisor humano julga que a prova existe e decide override (→authorized) ou recusa (→refused), suprindo o supervisorId nominal + reason. Canal sync porque o Payment específico fica retido, mas não bloqueia operações concorrentes em outros Payments. O agente PROPÕE; JAMAIS supre o supervisorId (cst-override-requires-human-attribution). Contexto mínimo: paymentId, quais das 3 condições estão não-limpas, recommendation do agente."
	}, {
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. Item específico retido pendente de decisão supervisora."
		recipient:      "founder (coordenação REW para default)"
		rationale:      "Decisão fora da autoridade do gate determinístico: declarar PaymentObligationDefaulted (impacto reputacional/risco em REW — canvas supervisedDecision confirm-payment-obligation-default) OR autorizar reemissão pós-cancelamento (cancel-then-reissue, sh-06, verificação anti-laundering). async-queue porque nenhuma bloqueia operações concorrentes — apenas o item fica retido; pagamentos limpos continuam fluindo. SLA 24h reflete decisão planejada, não emergência. Contexto mínimo: condição específica, paymentId/commitmentRef, justificativa."
	}, {
		category:       "suspicious-input"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Dispatch para a tupla afetada pausado até security review."
		recipient:      "founder + security review (vetor sh-06)"
		rationale:      "2º dispatch para a mesma tupla (commitmentRef, invoice) OR replay de PaymentInstruction (canvas escalationCriteria replay-or-double-pay-attempt, sh-06). O reject é fail-safe determinístico (no-op idempotente), mas alert-and-block porque o padrão exige análise humana de origem (bug vs ataque) e pausar a tupla afetada contém propagação. Contexto mínimo: tupla afetada, padrão de tentativa, InstructionIds candidatos."
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "alert-and-block"
		slaDescription: "Freeze IMEDIATO do pipeline de dispatch autônomo (containment precede diagnosis, ADR-079); forensics + parecer do founder dentro de 4 horas úteis."
		recipient:      "founder + supervisor sh-05"
		rationale:      "BREACH de P11: dispatch ocorrido/tentado sem as 3 condições (violação do gate por reconciliação/tripwire — canvas escalationCriteria p11-invariant-breach-detected), a violação mais grave (integridade legal nível-1); OR zona cinza regulatória/jurídica (regulatory-or-juridical-ambiguity, AML/sanctions). alert-and-block É O FREEZE — é o (ii) do rtd-018 (freeze-routing do breach) pareado com o constraint cst-breach-bypasses-escalation do spec: breach permanece em guarded, dispara este routing, e o pipeline autônomo congela. Nenhum pagamento autônomo enquanto o gate não garante P11. Contexto mínimo: paymentId, natureza da violação/zona cinza, evidência do tripwire."
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 1
		maxDailyActions:        30
		rationale:              "O FCE é o gate que efetivamente MOVE DINHEIRO (P11, nível-1) — mais crítico que o BDG (orçamento prospectivo, 2/50) ou o IDC (raiz criptográfica, 2/40). Postura de onboarding MAXIMAMENTE conservadora: maxConcurrentMutations 1 SERIALIZA o caminho de movimento de valor (nenhuma mutation financeira autônoma em paralelo enquanto o gate não estiver provado) — em Phase 0 todas as mutations autônomas são propose-and-wait (humano aprova cada uma), então a serialização não estrangula o fluxo planejado. maxDailyActions 30 reflete volume de onboarding do caminho crítico (compromissos faturados chegam do INV em cadência derivada; maioria das ações são queries/generation execute-and-log). Promoção para 2+/maior é decisão do calibration (rumo ao 24/7 do canvas, cc-03) quando a métrica provar o gate — NÃO baseline. Sanity: 30 ≥ 1. Monotonicidade lifecycle×caps (tq-gvg-07): faixa onboarding canônica 1-2/20-50; 1/30 é o lower-end deliberado para o gate de dinheiro. Recomendação ao runner: act-materialize-payment (pré-money) e queries não deveriam consumir orçamento de mutation financeira — decisão final do runner."
	}

	// =============================================
	// DRIFT DETECTION
	// =============================================
	//
	// 7 métricas, cadência semanal. 3 materializam as verificationMetrics
	// CONTROL do canvas (p11-breach-rate, double-pay-effected, prepayment-
	// guard-consistency) — todas zero-tolerance / suspend-and-escalate; 2
	// cobrem o submecanismo de override do adr-155 (alinhamento proposta↔
	// decisão + taxa de recusa); 1 taxa de escalada geral; 1 utilização de
	// blast radius. dm-p11-breach-rate é o control da (ii) do rtd-018: detecta
	// se a freeze-routing do breach foi mal-implementada (qualquer breach > 0
	// = o freeze falhou ou foi contornado). O freeze de domain-state
	// (PaymentSlice retido) é T2 separada no mesh-runtime; aqui o envelope
	// ROTEIA o breach (alert-and-block) e SUSPENDE o agente (regression
	// trigger) — o lado agente-level do freeze.

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-p11-breach-rate"
			name:        "Taxa de Breach de P11"
			description: "Número de dispatches ocorridos ou tentados sem as 3 condições P11 satisfeitas (fatura INV + elegibilidade REW + evidência), detectado por reconciliação ou tripwire (act-detect-breach-or-replay → sig-escalation-triggered categoria unclassifiable-anomaly). Materializa canvas verificationMetric p11-breach-rate."
			baseline:    "0 breaches (canvas verificationMetric p11-breach-rate target zero-tolerance)."
			threshold:   "≥ 1 breach em qualquer janela — zero-tolerance, não há banda de drift tolerada."
			rationale:   "Control metric e guarda da (ii) do rtd-018: a freeze-routing do breach (escalationRouting unclassifiable-anomaly → alert-and-block) só vale se um breach efetivo for impossível silenciosamente; qualquer breach > 0 significa gate violado ou freeze contornado. Causalidade determinística metric→escalation (canvas onBreach p11-invariant-breach-detected). Binding 1:1 ao regression trigger suspend-and-escalate (tolerance zero). É a violação mais grave do FCE — integridade legal nível-1."
		}, {
			code:        "dm-double-pay-rate"
			name:        "Taxa de Double-Pay Efetivado"
			description: "Número de PaymentSettled duplicados (≥2 para a mesma tupla commitmentRef/invoice). Materializa canvas verificationMetric double-pay-effected."
			baseline:    "0 double-pays efetivados (canvas verificationMetric double-pay-effected target)."
			threshold:   "≥ 1 PaymentSettled duplicado para a mesma tupla (commitmentRef, invoice) em qualquer janela — zero-tolerance."
			rationale:   "Control metric da invariante de idempotência at-most-once (as-fce-2 / cst-at-most-once-dispatch). O reject de replay é fail-safe determinístico; efetivar um double-pay significa que a idempotência falhou — severidade máxima, suspend-and-escalate. Causalidade metric→escalation (canvas onBreach replay-or-double-pay-attempt)."
		}, {
			code:        "dm-guard-consistency"
			name:        "Consistência do PrePaymentGuard"
			description: "Reprodutibilidade das decisões do PrePaymentGuard em replay + frescor dos inputs REW/INV no caminho crítico. Materializa canvas verificationMetric prepayment-guard-consistency."
			baseline:    "100% das decisões reproduzíveis em replay; inputs REW/INV stale < 24h no caminho crítico (canvas target)."
			threshold:   "< 100% de reprodutibilidade OR inputs stale ≥ 24h no caminho crítico."
			rationale:   "Control metric de dp-04 (determinismo) e de cst-guard-deterministic: um gate não-reproduzível ou alimentado por inputs stale não garante P11 — a decisão deixa de ser auditável como determinística. Causalidade metric→escalation (canvas onBreach prepayment-guard-systemic-failure → freeze fail-safe)."
		}, {
			code:        "dm-override-proposed-vs-approved"
			name:        "Alinhamento Override Proposto vs Aprovado"
			description: "Percentual das propostas de override do agente (act-resolve-guard-escalation, recommendation) que o supervisor humano confirma (proposta→authorized quando o supervisor autoriza) sobre o total proposto. Refina canvas verificationMetric supervised-override-rate na dimensão de alinhamento agente↔humano."
			baseline:    "≥ 90% de alinhamento entre a recommendation do agente e a decisão nominal do supervisor (provisório — calibração Phase 1)."
			threshold:   "< 75% de alinhamento em janela semanal."
			rationale:   "Mede qualidade da recommendation, JAMAIS autonomia: o agente PROPÕE e nunca supre o supervisorId (cst-override-requires-human-attribution). Alinhamento baixo sustentado significa que a recommendation diverge do julgamento humano — sinal para recalibrar a recommendation, NÃO para promover o override (propose-and-wait permanente per cst-override-never-autonomous + tq-gv-14). Drift aqui nunca destrava execute-and-log."
		}, {
			code:        "dm-override-refusal-rate"
			name:        "Taxa de Recusa de Override"
			description: "Percentual de Payments escalados ao supervisor em que a decisão humana RECUSA o override (→refused) sobre o total escalado para override-prepayment-guard."
			baseline:    "< 30% das escaladas terminando em refused (provisório — calibração Phase 1)."
			threshold:   "> 50% de recusa em janela semanal (a maioria das escaladas terminando em refused indica escalada indevida)."
			rationale:   "Diagnóstico: recusa alta indica que o agente escala casos que não deveriam alcançar o override (falsas escaladas) OR que os inputs REW/INV chegam frequentemente ambíguos/stale ao gate. Sinal para calibração do gate determinístico (cobertura do espectro operacional), não ação automática nem autonomia. Correlaciona com canvas supervised-override-rate."
		}, {
			code:        "dm-escalation-rate"
			name:        "Taxa de Escalada"
			description: "Percentual de Payments processados que disparam qualquer escalationCondition do agent-spec (sig-escalation-triggered emitido) sobre o total processado, segregado por categoria (conflicting-signals / insufficient-context / ambiguous-case / out-of-scope / suspicious-input / unclassifiable-anomaly)."
			baseline:    "< 10% dos Payments processados (provisório — calibração Phase 1)."
			threshold:   "> 25% em janela semanal."
			rationale:   "Taxa de escalada alta sustentada indica que o gate determinístico não cobre o espectro operacional — inputs frequentemente stale/ambíguos OR configuração em janela de transição. A segregação por categoria distingue escalada de override (ambiguous-case) de escalada de breach (unclassifiable-anomaly, já coberta por dm-p11-breach-rate zero-tolerance). Drift sustentado → reduce-autonomy (recalibração estrutural pendente, não comportamento anômalo)."
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions (30/dia) em janela semanal."
			baseline:    "< 60% de utilização média."
			threshold:   "> 90% de utilização média em janela semanal."
			rationale:   "Utilização consistente > 90% indica cap subdimensionado para a demanda real do caminho crítico — Payments faturados podem ficar retidos em fila, propagando latência para o spine financeiro. Pode justificar promoção de cap via calibration (rumo ao 24/7 cc-03) OR revisão de lifecycle stage. Binding automático drift→action via regression trigger (breach > 90% → reduce-autonomy enquanto o cap é redimensionado)."
		}]
		rationale: "Sete métricas em cadência semanal (volume de onboarding baixo — cada semana acumula amostra suficiente). Três materializam as verificationMetrics CONTROL do canvas (p11-breach-rate, double-pay-effected, prepayment-guard-consistency), todas zero-tolerance com binding 1:1 a regression triggers suspend-and-escalate — alinhamento direto entre detecção de drift técnico e os controls de integridade do domínio. Duas cobrem o submecanismo de override do adr-155 (alinhamento proposta↔decisão e taxa de recusa), ambas diagnósticas de qualidade-de-recommendation e cobertura-do-gate, NUNCA gatilhos de autonomia (o override é propose-and-wait permanente). Uma taxa de escalada geral segregada por categoria e uma de utilização de cap. dm-p11-breach-rate é o control da (ii) do rtd-018: detecta freeze-routing mal-implementada (qualquer breach > 0). Automatic enforcement bindings drift→action (tq-gvg-06): os 3 controls → suspend-and-escalate; override/escalada sustentados e cap > 90% → reduce-autonomy via calibration regression. Failure handling vive em envelope.failureHandling field per #FailureHandling shape (adr-058)."
	}

	// =============================================
	// CALIBRATION
	// =============================================
	//
	// Promoção em 2 estágios mira EXCLUSIVAMENTE as 3 mutations autônomas
	// promovíveis (act-execute-prepayment-guard, act-dispatch-payment-
	// instruction, act-settle-payment) rumo a execute-and-log / 24-7 (canvas
	// cc-03). O override (act-resolve-guard-escalation) NÃO aparece aqui POR
	// DESIGN — teto permanente propose-and-wait (cst-override-never-autonomous
	// + tq-gv-14 + cst-override-requires-human-attribution). A exclusão é
	// declarada, não mera ausência: um leitor futuro NÃO deve adicionar o
	// override ao promotionCriteria.

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation — APENAS para as 3 mutations autônomas promovíveis (act-execute-prepayment-guard, act-dispatch-payment-instruction, act-settle-payment). O override act-resolve-guard-escalation NÃO é elegível (teto permanente)."
			metric:                   "≥ 25 Payments processados (dispatched + settled) com ZERO p11-breach (dm-p11-breach-rate = 0), ZERO double-pay (dm-double-pay-rate = 0), dm-guard-consistency 100% reproduzível, e taxa de aprovação das mutations propose-and-wait ≥ 95% (founder/supervisor aprova o outcome proposto pelo agente). Aplicável SOMENTE às 3 mutations promovíveis; act-resolve-guard-escalation permanece propose-and-wait independentemente desta métrica."
			minimumObservationPeriod: "60 days"
			rationale:                "25 Payments é volume mínimo para padrão significativo no caminho de movimento de dinheiro (compromissos faturados chegam do INV em cadência derivada). 60 dias expõe variação de rail/provider e de frescor REW/INV. Zero-tolerance nos 3 controls é pré-condição inviolável — sem provar a integridade do gate, nenhuma mutation autônoma sobe de propose-and-wait. Taxa de aprovação 95% mede alinhamento agente↔humano nas decisões propostas. O override está fora deste critério por design (cst-override-never-autonomous): julgamento humano sobre prova não-limpa não é promovível."
		}, {
			description:              "Promoção de validation para operational — APENAS para as 3 mutations autônomas promovíveis, rumo ao 24/7 (canvas cc-03). O override act-resolve-guard-escalation continua excluído (teto permanente)."
			metric:                   "≥ 80 Payments processados, ZERO p11-breach e ZERO double-pay sustentados por 8 semanas, dm-guard-consistency 100% sustentada, taxa de aprovação ≥ 98%, dm-escalation-rate e dm-override-refusal-rate estáveis abaixo de threshold por 8 semanas, dispatch-latency dentro do target canvas, e audit trail verificável com reconstrução bem-sucedida em amostra cobrindo todos os requiredFields (incluindo a tríade de override supervisor-id / override-reason / overridden-conditions). Aplicável SOMENTE às 3 mutations promovíveis."
			minimumObservationPeriod: "90 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, os 3 controls em target sustentado por 8 semanas, drift estável e audit trail testado com reconstrução incluindo a tríade de override (sustenta a atribuição humana cst-override-requires-human-attribution). 90 dias cobre múltiplos ciclos de rail. FCE é o gate que MOVE DINHEIRO — promoção prematura amplifica risco de violação de P11 downstream. O override permanece excluído: nenhum volume ou janela o torna execute-and-log (tq-gv-14)."
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope — inclui o override act-resolve-guard-escalation executado autonomamente (sem supervisorId humano) e dispatch sem as 3 condições P11."
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é severidade máxima — falha no modelo de contenção. Em FCE inclui mover dinheiro sem as 3 condições (viola cst-money-moves-only-on-proof + P11) OR resolver escalada de guard sem atribuição humana (viola cst-override-never-autonomous + cst-override-requires-human-attribution + tq-gv-14). suspend-and-escalate porque o agente não pode operar o gate de dinheiro enquanto a causa raiz não for identificada."
		}, {
			description:     "Breach de P11 detectado (control metric, rtd-018 (ii))"
			metric:          "dm-p11-breach-rate ≥ 1 (qualquer dispatch ocorrido/tentado sem as 3 condições)"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Zero-tolerance: um único breach é violação de invariante crítica e de integridade legal nível-1. É o guarda da freeze-routing do breach — se o alert-and-block (escalationRouting unclassifiable-anomaly) falhar em conter, este trigger suspende o agente. Containment precede diagnóstico (ADR-079). O freeze de domain-state (PaymentSlice) é T2 separada no mesh-runtime; este trigger é o freeze agente-level."
		}, {
			description:     "Double-pay efetivado (control metric)"
			metric:          "dm-double-pay-rate ≥ 1 (≥2 PaymentSettled para a mesma tupla commitmentRef/invoice)"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Zero-tolerance: a idempotência at-most-once (as-fce-2 / cst-at-most-once-dispatch) é inviolável. Efetivar um double-pay significa que o reject fail-safe falhou — suspend-and-escalate imediato, pois movimento de valor duplicado já ocorreu e exige contenção + forensics antes de retomar."
		}, {
			description:     "Inconsistência do PrePaymentGuard (control metric)"
			metric:          "dm-guard-consistency abaixo de 100% de reprodutibilidade OR inputs REW/INV stale ≥ 24h no caminho crítico"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Gate não-reproduzível ou alimentado por inputs stale não garante P11 (viola cst-guard-deterministic + dp-04). suspend-and-escalate porque a decisão deixa de ser auditável como determinística — operar degraded moveria dinheiro sob um gate comprometido."
		}, {
			description:     "Drift sustentado em override/escalada (recommendation quality / cobertura do gate)"
			metric:          "dm-override-proposed-vs-approved, dm-override-refusal-rate ou dm-escalation-rate acima de threshold"
			threshold:       "2 avaliações consecutivas (2 semanas) acima do threshold"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado nessas métricas indica que o gate determinístico não cobre o espectro operacional (inputs frequentemente stale/ambíguos) OU que a recommendation de override diverge do julgamento humano. Reduzir autonomia força revisão mais intensiva enquanto a causa estrutural é endereçada — não é comportamento anômalo, é sinal de calibração pendente. NÃO afeta o override (já permanente propose-and-wait); reduz as 3 mutations promovíveis. Binding automático drift→action (tq-gvg-06)."
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido (dm-blast-radius-utilization)"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária — em FCE amplifica risco de movimento de valor além do envelope provado. reduce-autonomy cria margem de segurança enquanto a causa raiz é investigada (cap subdimensionado vs comportamento anômalo)."
		}]
		rationale: "Promoção em 2 estágios (onboarding→validation 25/60d; validation→operational 80/90d) mirando EXCLUSIVAMENTE as 3 mutations autônomas promovíveis (act-execute-prepayment-guard, act-dispatch-payment-instruction, act-settle-payment) rumo a execute-and-log / 24-7 (canvas cc-03), com os 3 controls em zero-tolerance como pré-condição. O override act-resolve-guard-escalation é PERMANENTEMENTE EXCLUÍDO — teto propose-and-wait por design, não por ausência: cst-override-never-autonomous + tq-gv-14 (override jamais execute-and-log) + cst-override-requires-human-attribution (o agente nunca supre o supervisorId). Nenhum volume, janela ou métrica o promove; um leitor futuro NÃO deve adicioná-lo aqui. 6 regression triggers: suspend-and-escalate (tolerance zero) para violação de autonomy boundary, p11-breach (rtd-018 (ii)), double-pay e inconsistência do guard — os 4 controls de integridade; reduce-autonomy para drift sustentado de override/escalada e breach de blast radius. Phase 0 baseline preserva 4 mutations propose-and-wait (3 promovíveis + override permanente) sem autonomyOverrides; promoção para execute-and-log via calibration crossing thresholds aplica-se apenas às 3 — tq-gv-14 forbid override direto preserva P10."
	}

	// =============================================
	// FAILURE HANDLING
	// =============================================

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno do agente (exception, comportamento não-determinístico no gate que move dinheiro): halt imediato, escalate ao founder para root cause antes de retomar. FCE é severity tier MÁXIMO (movimento de valor, P11/P10 nível-1, mais crítico que o gate orçamentário prospectivo do BDG) — agente não-determinístico no gate de dinheiro compromete P11 diretamente."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s) aplicável APENAS a queries de input/projeção (frescor REW/INV, prj-payment-status). SEM retry para a operação de gate determinístico (a checagem das 3 condições) — timeout aqui é bug determinístico, não transiente. EvidencePort indisponível → suspend sem retry (prepayment-guard-systemic-failure)."
			description: "Timeout em operação: retry once para queries de projeção/input stale; falha persistente = suspend e escalate via insufficient-context routing (alert-and-block) carregando qual input falhou e a latência observada. Gate determinístico e EvidencePort não retentam — fail-safe é parar de mover dinheiro, não degradar a verificação (dp-04)."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h sugerem issue sistêmico (degradação sustentada de SoT de input, EvidencePort instável, OR rail/provider em janela de falha prolongada). Suspend + notificação imediata ao founder — o gate de dinheiro não tolera operação degraded sustentada, pois cada ação degraded arrisca mover valor sob garantia P11 comprometida."
		}
		rationale: "Per adr-058 (promotion de tech debt narrative para field first-class). FCE é severity tier máximo (gate que move dinheiro, P11/P10 nível-1): suspend-and-escalate nos 3 eventos por padrão Phase 0; retry conservador em onTimeout aplicável apenas a queries de input/projeção — a operação de gate determinístico e o EvidencePort não retentam (timeout ali é determinístico ou estrutural). 3/24h para repeated failure reflete tolerance baixa apropriada ao caminho de movimento de valor."
	}

	rationale: "Envelope de governança do agt-fce-primary em lifecycle onboarding. FCE é o gate que MOVE DINHEIRO no commitment lifecycle — owner exclusivo do PrePaymentGuard determinístico (fatura INV + elegibilidade REW + cadeia de evidência íntegra), conduz o Payment de guarded a settled sob proof e materializa P11 (dinheiro só se move quando a operação comprova). Bidirectional ref validado: agent-spec.code 'agt-fce-primary' == agentRef; agent-spec.governanceRef 'fce-primary-agent' == base name deste arquivo (tq-gv-06). Pareamento spec↔envelope fechado (tq-ag-09): o spec declara CAPACIDADE + QUANDO escalar e referencia este envelope via governanceRef; este envelope existe e declara AUTONOMIA atual + COMO escalar (channel/SLA/recipient). 6 rotas cobrindo as 6 categories do agent-spec.escalationConditions: sync-human-review para conflicting-signals e ambiguous-case (o override central do adr-155 — supervisor sh-05 supre supervisorId + reason); alert-and-block para insufficient-context (gate comprometido = fail-safe parar de mover dinheiro), suspicious-input (replay/double-pay sh-06) e unclassifiable-anomaly (o BREACH de P11 — freeze); async-queue para out-of-scope. Routing precedence: blocking > non-blocking; mutation-related > informational; explicit > fallback (tq-gvg-05). Blast radius caps 1/30 — mais conservador que BDG 2/50 e IDC 2/40 porque o FCE efetivamente move dinheiro (P11, nível-1); canonical band onboarding 1-2/20-50 no lower-end deliberado (tq-gvg-07). Drift detection semanal com 7 métricas: 3 materializam as verificationMetrics CONTROL do canvas (p11-breach-rate, double-pay-effected, prepayment-guard-consistency, todas zero-tolerance), 2 cobrem o submecanismo de override (alinhamento proposta↔decisão + taxa de recusa, diagnósticas, nunca gatilhos de autonomia), 1 taxa de escalada e 1 utilização de cap; dm-p11-breach-rate é o control da (ii) do rtd-018 (monitora se a freeze-routing do breach foi mal-implementada — qualquer breach > 0). Failure handling per #FailureHandling shape (adr-058): suspend-and-escalate nos 3 eventos, severity tier MÁXIMO (gate que move dinheiro); retry conservador apenas para queries de input/projeção. Automatic enforcement bindings drift→action (tq-gvg-06): os 3 controls → suspend-and-escalate; override/escalada sustentados e cap > 90% → reduce-autonomy. RATIFICAÇÃO adr-155 — a assimetria promovível-vs-permanente, DECLARADA no spec, ganha ENFORCEMENT aqui: o calibration.promotionCriteria mira EXCLUSIVAMENTE as 3 mutations autônomas (act-execute-prepayment-guard, act-dispatch-payment-instruction, act-settle-payment) rumo a execute-and-log / 24-7 (canvas cc-03) quando o gate estiver provado (25/60 onboarding→validation; 80/90 validation→operational), e o override (act-resolve-guard-escalation) é PERMANENTEMENTE EXCLUÍDO do promotionCriteria — teto propose-and-wait por design, blindado em 5 lugares. Phase 0 baseline preserva as 4 mutations propose-and-wait SEM autonomyOverrides (tq-gv-14: nenhum autonomyOverride concede execute-and-log a mutation; e o override fora do promotionCriteria garante que nenhum caminho de promoção o alcança — DENTE 2 enforced). Essa assimetria É a enforcement P10 que ratifica o adr-155 (proposed→accepted), do lado do envelope: o spec DECLARA as duas naturezas, o envelope as SEPARA operacionalmente (promovível vs teto permanente). Freeze-routing do breach (ii do rtd-018): unclassifiable-anomaly roteia para alert-and-block (freeze do pipeline autônomo; containment precede diagnóstico, ADR-079) e é monitorada pelo dm-p11-breach-rate zero-tolerance — o piso fecha o loop: garantido-no-domínio (handler exige as 3 condições) + roteado-no-envelope (alert-and-block) + monitorado-aqui (breach-rate = 0); o freeze de domain-state (PaymentSlice retido) é T2 separada no mesh-runtime, este envelope é o lado agente-level (rota + suspende). Envelope é control plane apenas (tq-gvg-09): routing + caps + calibration + drift + lifecycle; nenhuma business logic vazada — as decisões de domínio (PrePaymentGuard, as 7 invariantes, atribuição de override, detecção de breach) vivem em agent-spec.constraints e domain-model. Boundaries do canvas businessDecisions preservadas: bd-payment-canonical-state (caps/routing não permitem dispatch autônomo fora do gate provado), bd-settlement-fact-canonical (PaymentSettled é fato único; routing de suspicious-input contém replay), e o gate P11 não é condicionado a caixa/orçamento (TCM/BDG fora do routing). Tensão com axiomas: nenhuma — o envelope HONRA P10 (autonomia só via promotion provada; override é teto humano-only) e P11 (caps serializam o movimento de valor; breach freeze antes de mover); a permanência do override honra a linha vermelha P10/P11, não a tensiona."
}
