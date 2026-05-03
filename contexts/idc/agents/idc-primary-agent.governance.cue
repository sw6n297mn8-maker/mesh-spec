package idc

// idc-primary-agent.governance.cue — Governance Envelope: IDC Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do IDC.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (idc-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode override
//   (Phase 0: nenhum override declarado; promoção via calibration)
// - agent-spec declara observability signals → este envelope define drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária):
//   aag-autonomy-boundary, aag-escalation-protocol, aag-blast-radius-containment,
//   aag-agent-capability-lifecycle, aag-hitl-calibration, aag-drift-detection
// - lens-security-trust-infrastructure (secundária):
//   blast radius caps conservadores; defense in depth via IDC = raiz de confiança
// - lens-regulatory-compliance-as-architecture (secundária):
//   IDC verifica identity contra fontes autoritativas (Bacen/SCD); compliance
//   rastreável via audit trail criptográfico
//
// Limitações conhecidas (Phase 0):
// - governanceGlobalVersion "0.1" é forward reference para
//   architecture/agent-governance.cue que ainda não existe (canônico Phase 0).
// - failureHandling declarado em envelope.failureHandling field per
//   #FailureHandling shape (schema first-class per adr-058). Narrative
//   anterior em comment block + driftDetection.rationale removida per P0
//   (single source of truth no field declarativo).
// - Cobertura parcial Phase 0 de 3 dos 6 invariants (IDC é único enforcer
//   pré-resolução de ten-003 e ten-004 — declarado em agent-spec rationale).
// - Caps 2/40 dentro da faixa onboarding canônica (1-2/20-50 per tq-gvg-07);
//   conservadorismo Phase 0 reforçado dado raiz-de-confiança status sem
//   global governance — promoção via
//   calibration declarada, não inflação inicial.
//
// Per PG-B (architecture/production-guides/agent-governance.cue): 3 sections
// (routing-and-blast-radius, drift-and-calibration, bidirectional-validation).
// Authoring per founder direction como proposta integral one-shot (não
// section-by-section gates) — padrão paralelo a adr-057.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

idcPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-idc-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING
	// =============================================
	//
	// 6 categories do agent-spec.escalationConditions[]:
	// conflicting-signals, insufficient-context, suspicious-input,
	// ambiguous-case, out-of-scope, unclassifiable-anomaly.
	//
	// Routing precedence quando categories concorrem (tq-gvg-05):
	// (1) blocking > non-blocking — alert-and-block precede sync-human-review;
	// (2) mutation-related > informational — categories ligadas a mutations
	// precedem queries; (3) explicit route > fallback global. Sem declaração
	// explícita, runner choice seria não-determinística.

	escalationRouting: [{
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "Fontes externas autoritativas (RF, JC, bureaus) divergem sobre mesma identidade — outcome do protocolo de verificação não é derivável; agente não tem autoridade para decidir precedência entre fontes. Canal sync e SLA curto porque conflito não-resolvido bloqueia pipeline downstream (NPM/LOG/DLV consumers aguardam) e cria risco de precedente inconsistente em decisões regulatory. (aag-escalation-protocol: contexto mínimo inclui fontes consultadas, divergência específica, identity organizacional alvo.)"
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Verificação bloqueada até contexto fornecido."
		recipient:      "founder"
		rationale:      "Fonte autoritativa indisponível ou retorna dados ambíguos durante verification (canvas 'verification-source-systematic-failure'). Prosseguir sem contexto autoritativo viola integridade da verificação de identidade — IDC é raiz de confiança downstream (qualquer evidência assinada com identidade não-verificada compromete cadeia). Canal alert-and-block porque outcome rejected automático sem fonte autoritativa é diligência regulatory inadequada. (aag-escalation-protocol: contexto mínimo inclui qual fonte falhou, tentativas realizadas, alternativas consultadas.)"
	}, {
		category:       "suspicious-input"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação retida até validação."
		recipient:      "founder"
		rationale:      "Padrão anômalo em requisições de assinatura (canvas 'signature-pattern-anomaly') OU requisição de BC fora da whitelist Phase 0 (canvas 'sign-evidence-gap'). IDC integra com fontes externas (RF/JC/bureaus) e processa requests de múltiplos BCs — vetor de segurança real. Canal sync porque suspicious-input em raiz de confiança requer triagem humana antes de prosseguir; ignorar amplifica risco de comprometimento. (aag-escalation-protocol: contexto mínimo inclui padrão anômalo detectado, baseline de comparação, BC requester.)"
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Verificação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "CNPJ com dígitos válidos mas ausente em todas fontes consultadas — caso intermediário entre verified e rejected que protocolo não resolve sozinho (não confirma fraude, não confirma não-existência). Canal sync porque decisão entre treat-as-rejected vs request-additional-sources é judgment, não derivável. (aag-escalation-protocol: contexto mínimo inclui CNPJ alvo, fontes consultadas com timestamps, hipóteses sobre causa da ausência.)"
	}, {
		category:       "out-of-scope"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até decisão sobre taxonomia."
		recipient:      "founder"
		rationale:      "Requisição de classe de evidência fora da taxonomia interna (Phase 0 antes de ten-004 resolver) — canvas 'sign-evidence-gap'. Per agent-spec act-sign-evidence per-action override: out-of-scope é mandatory escalation enquanto taxonomia formal não existe. Canal alert-and-block porque assinar evidência fora de taxonomia conhecida cria precedente regulatory questionável e compromete inv-evidence-class-conforms-taxonomy. (aag-escalation-protocol: contexto mínimo inclui classe solicitada, BC requester, comparação com whitelist Phase 0.)"
	}, {
		category:       "unclassifiable-anomaly"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 1 hora útil. Operação bloqueada e contenção imediata."
		recipient:      "founder"
		rationale:      "Cobre 2 escalation conditions do spec: 'identity-compromise-suspected' (assinaturas anômalas sugerem comprometimento de identidade) E 'drift-detected-in-verification-pattern' (desvio estatístico no self-monitoring). Severity máxima: comprometimento de identidade compromete TODA evidência assinada com identity afetada — contenção imediata é prioridade absoluta sobre throughput. SLA 1h (vs 4h padrão) reflete que cada hora de operação adicional pós-detecção amplia blast radius criptográfico. (aag-escalation-protocol: contexto mínimo inclui anomaly type, identity afetada, range temporal de assinaturas potencialmente comprometidas.)"
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 2
		maxDailyActions:        40
		rationale: "IDC tem 10 ações declaradas (3 queries execute-and-log + 1 generation execute-and-log + 1 validation execute-and-log + 4 mutations propose-and-wait + 1 escalation collect-and-report). maxConcurrentMutations: 2 limita execução paralela conservadoramente em onboarding — IDC é raiz de confiança regulatory sem global governance materializado; breach amplifica risco cross-BC (NPM/LOG/DLV são consumers). maxDailyActions: 40 reflete throughput esperado em onboarding (verificações organizacionais não são alto volume; assinaturas vêm em lotes via LOG conforme demanda construtiva). Caps abaixo do patamar ctr/npm (3/50) reflete maior conservadorismo Phase 0 dado raiz-de-confiança status — promoção via calibration declarada, não inflação inicial. Sanity check: 40 daily ≥ 2 concurrent ✓. Lifecycle×caps monotonicidade (tq-gvg-07): faixa onboarding canônica 1-2 / 20-50; 2/40 está dentro. (aag-blast-radius-containment: capability nova inicia conservadora, expande com track record via calibration.)"
	}

	// =============================================
	// DRIFT DETECTION
	// =============================================
	//
	// Automatic enforcement bindings drift→action (tq-gvg-06):
	// - dm-escalation-response-latency threshold breach → reduce-autonomy
	//   via regression trigger (sem necessidade de calibration humana)
	// - dm-audit-completeness-rate < 100% → block operations imediatamente
	//   (regulatory grade requirement; tolerance-zero; ver métrica abaixo)
	//
	// Failure handling per envelope.failureHandling field (schema first-class
	// per adr-058; substituiu narrative anterior em comment block + drift
	// Detection.rationale per P0 — single source of truth no field declarativo).

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-escalation-response-latency"
			name:        "Latência de Resposta a Escalações"
			description: "p95 do tempo entre escalação e resposta do founder, segregado por SLA tier."
			baseline:    "< 4h para sync-human-review e alert-and-block; < 1h para unclassifiable-anomaly"
			threshold:   "> 8h para sync/alert; > 2h para unclassifiable-anomaly"
			rationale:   "Se escalações consistentemente atingem o limite de SLA, canal pode estar subdimensionado ou founder sobrecarregado. Drift aqui indica IDC opera em incerteza prolongada — risco amplificado por raiz-de-confiança status (downstream consumers aguardam verification/signature). Threshold tier-aware reflete que unclassifiable-anomaly tem SLA 4x mais agressivo. (aag-drift-detection: baseline + threshold por tier de SLA.)"
		}, {
			code:        "dm-verification-completion-rate"
			name:        "Taxa de Conclusão de Verificações de Identidade"
			description: "Percentual de cmd-verify-organization-identity que progridem para outcome verified ou rejected definitivo (vs ambiguous escalations)."
			baseline:    "> 80% das verificações completam com outcome definitivo"
			threshold:   "< 60% de outcome definitivo (>40% ambiguous)"
			rationale:   "Taxa baixa de conclusão indica fontes externas degradadas ou heurística de matching mal-calibrada — em ambos casos IDC entra em modo escalation-heavy que satura founder e atrasa downstream. Em onboarding threshold conservador (60%); calibrado com dados reais. (aag-drift-detection: métrica de saúde do protocolo de verificação.)"
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions."
			baseline:    "< 60% de utilização média"
			threshold:   "> 90% de utilização média em janela semanal"
			rationale:   "Utilização consistente acima de 90% indica cap subdimensionado para demanda real, forçando agente a priorizar ou adiar operações. Pode justificar promoção de caps via calibration ou revisão de lifecycle stage. (aag-drift-detection: cap como indicador de dimensionamento, não apenas contenção.)"
		}, {
			code:        "dm-cryptographic-operation-anomaly-rate"
			name:        "Taxa de Anomalia em Operações Criptográficas"
			description: "Detecções de act-detect-signature-pattern-anomaly (escalation collect-and-report) sobre total de assinaturas em janela. Métrica IDC-specific (canvas escalations identity-compromise-suspected + drift-detected-in-verification-pattern)."
			baseline:    "< 1% de anomaly detections sobre signature volume"
			threshold:   "> 3% de anomaly detections em janela semanal"
			rationale:   "Spike em anomaly detections sugere comprometimento sistêmico, atacante explorando padrão, OU calibração mal-feita do detector estatístico. Em qualquer caso, escalation manual + redução de autonomia até root cause é a resposta. IDC-specific porque signature anomaly é vetor primário de comprometimento da raiz de confiança. (aag-drift-detection: métrica direta para canvas escalation 'identity-compromise-suspected'.)"
		}, {
			code:        "dm-audit-completeness-rate"
			name:        "Taxa de Completude do Audit Trail"
			description: "Percentual de operações com audit trail completo (todos 11 requiredFields preenchidos: 7 minimum per #AuditTrail._minimumAuditFields + 4 IDC-specific cnpj-subject/signing-operation-id/evidence-class/source-references-consulted) sobre total de operações."
			baseline:    "100% completude (zero-tolerance regulatory)"
			threshold:   "< 100% (qualquer ausência de field obrigatório)"
			rationale:   "Audit trail incompleto compromete reconstituição regulatory (Bacen retention 5+ anos para evidência criptográfica). Tolerance-zero porque qualquer field ausente em raiz de confiança quebra cadeia de prova downstream — não é métrica de degradação gradual; é gate binário. Threshold ativo binding direto a immediate action 'block operations' (tq-gvg-06) — drift→action sem passar por calibration humana, dado severity regulatory. (aag-drift-detection: única métrica com binding automático direto a block, refletindo severity tier máximo regulatory.)"
		}]
		rationale: "Cinco métricas cobrem latência de supervisão (resposta tier-aware), qualidade do protocolo de verificação (completion rate), dimensionamento operacional (cap utilization), segurança criptográfica (anomaly rate IDC-specific) e completude regulatory (audit completeness com binding automático a block). Cadência semanal adequada para onboarding — volume baixo, cada semana acumula amostra suficiente. Failure handling vive em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058) — narrative duplicada anterior removida (P0). Automatic enforcement bindings drift→action (tq-gvg-06): dm-escalation-response-latency threshold breach → reduce-autonomy via regression trigger; dm-audit-completeness-rate < 100% → block immediately (zero-tolerance regulatory; única métrica com binding direto não-mediado por calibration humana, refletindo severity tier máximo). (aag-drift-detection: drift é silencioso — detecção ativa é o mecanismo.)"
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 15 verificações de identidade processadas com zero violação de invariante (inv-source-authority-required, inv-revocation-preserves-trail, inv-signature-requires-active-identity, inv-cas-content-immutability, inv-signature-idempotency, inv-evidence-class-conforms-taxonomy) e taxa de aprovação de recomendações ≥ 95% (founder aprova outcome em mutations propose-and-wait: act-execute-identity-verification, act-propose-identity-revocation, act-sign-evidence, act-generate-integrity-proof)"
			minimumObservationPeriod: "60 days"
			rationale:                "15 verificações é volume mínimo para padrão significativo em IDC (throughput baixo: organizational identity verification não é high-volume vs commitments em CMT). 60 dias garante exposição a variação temporal e cobertura de fontes externas em ciclos diferentes. Taxa de aprovação 95% mede alinhamento agente↔founder em decisões regulatory irreversíveis (rejected, revocation, signature) — rejeição > 5% indica recalibração antes de reduzir supervisão. (aag-agent-capability-lifecycle: onboarding → validation com critérios ex ante.)"
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 50 verificações processadas, zero violação de invariante, taxa de aprovação ≥ 98%, zero drift detectado acima de threshold por 4 semanas consecutivas, zero anomaly em dm-cryptographic-operation-anomaly-rate por 8 semanas, dm-audit-completeness-rate sustentado em 100% por 8 semanas, audit trail criptográfico verificável com reconstrução bem-sucedida em amostra de 10 operações"
			minimumObservationPeriod: "90 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, drift estável, anomaly criptográfica zero (raiz de confiança não tolera drift criptográfico em operational stage), completude de audit sustentada (regulatory grade), audit testado. 90 dias garante exposição a múltiplos ciclos regulatory + variação de fonte externa. IDC é raiz de confiança regulatory cuja evidência criptográfica condiciona TODA cadeia downstream — promoção prematura amplifica risco sistêmico. (aag-hitl-calibration: supervisão proporcional à maturidade e consequência regulatory.)"
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — falha no modelo de contenção, não comportamento pontual. suspend-and-escalate porque agente não pode operar enquanto causa raiz não identificada. (aag-autonomy-boundary: violação é falha estrutural.)"
		}, {
			description:     "Drift sustentado em qualquer métrica"
			metric:          "Qualquer métrica de driftDetection acima do threshold (exceto dm-audit-completeness-rate que tem binding direto a block via tq-gvg-06)"
			threshold:       "2 avaliações consecutivas (2 semanas) fora do baseline"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado indica desalinhamento estrutural — promoção nesse estado amplificaria problema. Redução de autonomia força revisão mais intensiva enquanto causa investigada. dm-audit-completeness-rate é exceção: binding automático imediato a block (não passa por reduce-autonomy gradual) dado severity regulatory tolerance-zero. (aag-drift-detection: detecção precoce + ação proporcional.)"
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária. Redução de autonomia cria margem de segurança enquanto causa raiz investigada. (aag-blast-radius-containment: breach indica subdimensionamento ou comportamento anômalo.)"
		}, {
			description:     "Anomaly criptográfica sustentada"
			metric:          "dm-cryptographic-operation-anomaly-rate > 3% em janela semanal"
			threshold:       "1 avaliação acima de threshold"
			immediateAction: "suspend-and-escalate"
			rationale:       "IDC-specific: spike em anomaly detection na raiz de confiança é severity máxima — possível comprometimento de identidade ou attacker exploitation. suspend-and-escalate (não reduce-autonomy) porque anomaly criptográfica não tolera operação degraded; investigação completa antes de retomar. Tolerance mais agressiva (1 avaliação vs 2 para drift geral) reflete blast radius criptográfico. (aag-drift-detection: severity tier máximo para raiz de confiança.)"
		}]
		rationale: "Promoção em dois estágios: onboarding→validation (15 verificações, 60 dias) e validation→operational (50 verificações, 90 dias) com critério adicional de dm-audit-completeness-rate sustentado em 100% por 8 semanas para promoção a operational. Critérios mais conservadores que CMT (15/60 vs 20/80) refletem throughput baixo de identity verification + maior consequência por error (raiz de confiança). Regressão com tolerância zero para violação de autonomy boundary (suspend-and-escalate), detecção precoce para drift sustentado (2 semanas, reduce-autonomy), contenção imediata para breach de blast radius (reduce-autonomy), e severity máxima para anomaly criptográfica (suspend-and-escalate, tolerance 1 avaliação). dm-audit-completeness-rate tem binding automático direto a block (não regression trigger), refletindo severity regulatory máxima. Calibração conservadora para BC raiz de confiança em fase pré-PMF — IDC condiciona TODA cadeia downstream criptográfica (LOG/DLV/INV/FCE), priorizar safety sobre speed é axiomático."
	}

	failureHandling: {
		onAgentError: {
			action:      "suspend-and-escalate"
			description: "Erro interno do agente (exception, comportamento não-determinístico em raiz de confiança regulatory): halt operations imediatamente, escalate to founder for root cause analysis antes de retomar. IDC severity tier máximo — agente não-determinístico em raiz de confiança compromete cadeia downstream criptográfica."
		}
		onTimeout: {
			action:      "suspend-and-escalate"
			retryPolicy: "Max 1 retry com exponential backoff (initial 2s); aplicável a chamadas a fontes externas RF/JC/bureaus que retornam timeout. Sem retry para operações criptográficas internas (DSSE/Merkle) — timeout aqui é bug determinístico."
			description: "Timeout em operação: retry once para fontes externas; falha persiste = suspend e escalate via insufficient-context routing. Escalation routing carrega contexto de qual fonte externa timeout."
		}
		onRepeatedFailure: {
			action:      "suspend-and-escalate"
			threshold:   "3 failures"
			timeWindow:  "24h"
			description: "3 falhas em 24h sugerem issue sistêmico (degradação de fonte externa sustentada, bug em protocolo de verificação, attacker fuzzing). Suspend + immediate founder notification — IDC raiz de confiança não tolera operação degraded sustentada."
		}
		rationale: "Per adr-058 promotion de tech debt narrative para field first-class. IDC severity tier máximo (raiz de confiança regulatory): suspend-and-escalate em todos 3 eventos por padrão Phase 0; retry conservador em onTimeout aplicável apenas a fontes externas (operações criptográficas internas não retentam — timeout aqui é determinístico). 3/24h threshold para repeated failure reflete tolerance baixa apropriada para criticality regulatory."
	}

	rationale: "Envelope de governança do agt-idc-primary em lifecycle onboarding. IDC é a raiz de confiança regulatory da Mesh — único BC que verifica identity organizacional contra fontes autoritativas (RF/JC/bureaus), assina evidência via DSSE e gera Merkle proofs; toda cadeia downstream criptográfica (LOG/DLV/INV/FCE) depende da integridade desta raiz. Bidirectional ref validado: agent-spec.code 'agt-idc-primary' == agentRef; agent-spec.governanceRef 'idc-primary-agent' == base name deste arquivo (idc-primary-agent.governance.cue) (tq-gv-06). 6 rotas de escalação cobrindo 6 categories do agent-spec.escalationConditions: sync-human-review para conflicting-signals/suspicious-input/ambiguous-case (resolução rápida contém propagação de incerteza para downstream); alert-and-block para insufficient-context/out-of-scope (prosseguir sem fonte autoritativa ou fora de taxonomia viola integridade regulatory); alert-and-block com SLA tier-superior 1h para unclassifiable-anomaly (comprometimento de identidade ou drift criptográfico exigem contenção imediata). Routing precedence quando categories concorrem: blocking > non-blocking; mutation-related > informational; explicit > fallback (tq-gvg-05). Blast radius caps dimensionados para onboarding regulatory (2 concurrent mutations, 40 daily actions; dentro da faixa onboarding canônica 1-2/20-50 per tq-gvg-07; conservadorismo Phase 0 reforçado dado raiz-de-confiança status sem global governance). Drift detection semanal com 5 métricas: latência de supervisão tier-aware, completion rate de verificações, cap utilization, anomaly criptográfica IDC-specific, e audit completeness regulatory com binding direto a block. Failure handling declarado em envelope.failureHandling field per #FailureHandling shape (schema first-class per adr-058): suspend-and-escalate em todos 3 eventos com severity tier máximo (raiz de confiança regulatory); narrative anterior em comment block + driftDetection.rationale removida per P0 (single source of truth no field declarativo). Automatic enforcement bindings drift→action (tq-gvg-06): dm-escalation-response-latency threshold breach → reduce-autonomy; dm-audit-completeness-rate < 100% → block (zero-tolerance regulatory; única binding automático direto não-mediado por calibration humana). Calibração: promoção 15/60 onboarding→validation, 50/90 validation→operational com critério adicional de audit-completeness sustentado; regressão com 4 triggers incluindo tolerance 1-avaliação para anomaly criptográfica (severity máxima raiz de confiança). Envelope é control plane apenas (tq-gvg-09): routing + caps + calibration + drift + lifecycle; nenhuma business logic vazada (decisões de domain — invariants, taxonomy, source authority — vivem em agent-spec.constraints e domain-model). Sem autonomyOverrides em Phase 0 (todas mutations propose-and-wait per spec; promoção via calibration declarada, não override retroativo). Lenses: aag (primária), sti (secundária), rc (secundária). Phase 0 caveats explícitos no spec rationale (3/6 invariants com agente como único enforcer pré-resolução de ten-003/ten-004) refletidos aqui via tier-superior de severity em routing/regression para anomaly criptográfica e taxonomia, e via binding automático direto para audit completeness."
}
