package cmt

// cmt-primary-agent.governance.cue — Governance Envelope: CMT Primary Agent.
// Instância de #AgentGovernanceEnvelope (architecture/artifact-schemas/agent-governance.cue).
//
// Envelope de governança operacional do agente primário do CMT.
// Define COMO escalar (routing, canal, SLA, destinatário), limites de
// blast radius, drift detection, e calibração de autonomia.
//
// Fronteira com agent-spec (cmt-primary-agent.cue):
// - agent-spec declara QUANDO escalar → este envelope declara COMO
// - agent-spec declara autonomyLevel por ação → este envelope pode override
// - agent-spec declara observability signals → este envelope define drift thresholds
//
// Lenses aplicadas:
// - lens-ai-agent-governance (primária):
//   aag-autonomy-boundary, aag-escalation-protocol, aag-blast-radius-containment,
//   aag-agent-capability-lifecycle, aag-hitl-calibration, aag-drift-detection
// - lens-security-trust-infrastructure (secundária):
//   blast radius caps, defense in depth via limites conservadores
// - lens-contractual-and-legal-architecture (secundária):
//   impacto de compromissos condicionando BCs downstream informa canal de escalação
// - lens-regulatory-compliance-as-architecture (terciária):
//   governanceGlobalVersion rastreável, calibração vinculada a compliance
//
// Limitações conhecidas:
// - governanceGlobalVersion "0.1" é forward reference para
//   architecture/agent-governance.cue que ainda não existe.
//   Estruturalmente permitido: campo é string com regex no type system;
//   match com versão do global é validação de runner (tq-gv-12, warn).
//   Será satisfeito quando global for criado com version "0.1".
// - Categoria out-of-scope unifica duas condições semanticamente distintas
//   (tipo de compromisso não previsto e valor acima de threshold) por
//   limitação da taxonomia atual de categories no envelope.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

cmtPrimaryAgentGovernance: artifact_schemas.#AgentGovernanceEnvelope & {
	agentRef:                "agt-cmt-primary"
	governanceGlobalVersion: "0.1"
	lifecycleStage:          "onboarding"

	// =============================================
	// ESCALATION ROUTING
	// =============================================

	escalationRouting: [{
		category:       "out-of-scope"
		channel:        "async-queue"
		slaDescription: "Resposta dentro de 24 horas. Compromisso retido pendente de decisão sobre template ou threshold."
		recipient:      "founder"
		rationale:      "Cobre duas condições distintas que compartilham o mesmo routing por limitação da taxonomia atual de categories no envelope: (1) tipo de compromisso não previsto — falta de template semântico; (2) valor acima de threshold — contenção de blast radius financeiro. Ambas exigem decisão humana porque o agente não possui contexto para avaliar se a extensão é legítima ou se o valor justifica risco. Canal async-queue porque nenhuma das duas condições bloqueia operações em andamento — apenas o compromisso específico fica retido pendente de decisão. (aag-escalation-protocol: contexto mínimo inclui tipo de compromisso, partes envolvidas, e gap versus templates existentes.)"
	}, {
		category:       "ambiguous-case"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Compromisso bloqueado até resolução."
		recipient:      "founder"
		rationale:      "Compromissos com múltiplas interpretações válidas de termos, escopo ou obrigações requerem julgamento contextual que o agente não possui. Canal sync-human-review porque ambiguidade em compromissos que condicionam execução downstream (BDG, TCM, DRC) propaga incerteza — resolução rápida contém blast radius. (aag-escalation-protocol: contexto mínimo inclui interpretações identificadas, consequências de cada uma, e BCs afetados.)"
	}, {
		category:       "conflicting-signals"
		channel:        "sync-human-review"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até resolução."
		recipient:      "founder"
		rationale:      "Quando sinais upstream entram em contradição sobre o mesmo compromisso — e.g., REW sinaliza clearing de risco enquanto DRC mantém ordem de suspensão — o agente não tem autoridade para decidir precedência. Canal sync e SLA curto porque conflito não resolvido bloqueia pipeline e pode criar precedente inconsistente. (aag-escalation-protocol: contexto mínimo inclui invariantes em conflito, cenário concreto, e impacto em cada BC afetado.)"
	}, {
		category:       "insufficient-context"
		channel:        "alert-and-block"
		slaDescription: "Resposta dentro de 4 horas úteis. Operação bloqueada até contexto fornecido."
		recipient:      "founder"
		rationale:      "Ações que dependem de informação não disponível no contexto local do agente — e.g., estado atual de um compromisso em outro BC, ou histórico de renegociações — devem ser suspensas até que o contexto seja fornecido. alert-and-block porque prosseguir sem contexto viola integridade da decisão. (aag-escalation-protocol: contexto mínimo inclui qual informação falta, onde deveria estar, e impacto de operar sem ela.)"
	}]

	// =============================================
	// BLAST RADIUS CAPS
	// =============================================

	blastRadiusCaps: {
		maxConcurrentMutations: 5
		maxDailyActions:        80
		rationale: "CMT possui 10 ações declaradas (4 execute-and-log + 6 propose-and-wait). maxConcurrentMutations: 5 limita a metade do total para evitar saturação de contexto em execução paralela. maxDailyActions: 80 reflete volume operacional esperado em onboarding — compromissos são criados em lotes durante definição de domínio. Recomendação de implementação: queries (act-query-commitment-state) são leitura sem efeito colateral e não deveriam consumir orçamento de mutation/validation — decisão final depende do runner. (aag-blast-radius-containment: capability nova inicia com blast radius conservador e expande com track record.)"
	}

	// =============================================
	// DRIFT DETECTION
	// =============================================

	driftDetection: {
		evaluationCadence: "weekly"
		metrics: [{
			code:        "dm-escalation-response-latency"
			name:        "Latência de Resposta a Escalações"
			description: "p95 do tempo entre escalação e resposta do founder."
			baseline:    "< 12h para async-queue, < 4h para sync-human-review e alert-and-block"
			threshold:   "> 24h para qualquer canal"
			rationale:   "Se escalações consistentemente atingem o limite de SLA, o canal pode estar subdimensionado ou o founder sobrecarregado. Drift aqui indica que o agente opera em incerteza prolongada. (aag-drift-detection: baseline + threshold por canal.)"
		}, {
			code:        "dm-commitment-lifecycle-completion-rate"
			name:        "Taxa de Progressão Proposed→Accepted"
			description: "Percentual de compromissos que progridem de proposed para accepted sem cancelamento prematuro, suspensão prolongada ou abandono, versus compromissos que terminam em padrões anômalos."
			baseline:    "> 70% dos compromissos completam transição proposed→accepted"
			threshold:   "< 50% de conclusão da transição"
			rationale:   "Taxa abaixo de 50% sugere que compromissos estão sendo criados sem maturidade suficiente ou que o processo de aceitação tem fricção excessiva. Em onboarding, o threshold é conservador — será calibrado com dados reais. (aag-drift-detection: métrica de saúde do domínio, não apenas do agente.)"
		}, {
			code:        "dm-blast-radius-utilization"
			name:        "Utilização de Capacidade de Blast Radius"
			description: "Percentual médio de utilização do maxDailyActions."
			baseline:    "< 60% de utilização média"
			threshold:   "> 90% de utilização média em janela de avaliação"
			rationale:   "Utilização consistente acima de 90% indica que o cap está subdimensionado para a demanda real, forçando o agente a priorizar ou adiar ações. Pode justificar promoção de caps ou revisão de lifecycle stage. (aag-drift-detection: cap como indicador de dimensionamento, não apenas contenção.)"
		}]
		rationale: "Três métricas cobrem latência de supervisão (resposta a escalações), qualidade do ciclo de vida do domínio (progressão de compromissos) e dimensionamento operacional (utilização de caps). Cadência semanal adequada para onboarding — volume baixo, cada semana acumula amostra suficiente. (aag-drift-detection: drift é silencioso — detecção ativa é o mecanismo.)"
	}

	// =============================================
	// CALIBRATION
	// =============================================

	calibration: {
		promotionCriteria: [{
			description:              "Promoção de onboarding para validation"
			metric:                   "≥ 20 compromissos processados com zero violação de invariante e taxa de aprovação de recomendações ≥ 95% (supervisor aprova o que agente propôs em ações propose-and-wait)"
			minimumObservationPeriod: "30 days"
			rationale:                "20 compromissos é volume mínimo para padrão significativo em operação inicial de CMT. 30 dias garante exposição a variação temporal. Taxa de aprovação de 95% mede alinhamento entre julgamento do agente e do supervisor — rejeição > 5% indica necessidade de recalibração antes de reduzir supervisão. (aag-agent-capability-lifecycle: onboarding → validation com critérios ex ante.)"
		}, {
			description:              "Promoção de validation para operational"
			metric:                   "≥ 80 compromissos processados, zero violação de invariante, taxa de aprovação ≥ 98%, zero drift detectado acima de threshold por 4 semanas consecutivas, audit trail verificável com reconstrução bem-sucedida em amostra de 10 operações"
			minimumObservationPeriod: "60 days"
			rationale:                "Critérios mais exigentes: volume maior, aprovação mais alta, drift monitorado e estável, audit trail testado. 60 dias garante exposição a ciclos completos de compromissos. CMT é BC core cujos compromissos condicionam execução em BDG, TCM e DRC — promoção prematura amplifica risco. (aag-hitl-calibration: supervisão proporcional à maturidade e consequência.)"
		}]
		regressionTriggers: [{
			description:     "Violação de autonomy boundary"
			metric:          "Qualquer ação executada fora do autonomyLevel declarado no agent-spec ou override no envelope"
			threshold:       "1 ocorrência"
			immediateAction: "suspend-and-escalate"
			rationale:       "Violação de boundary é evento de severidade máxima — indica falha no modelo de contenção, não apenas no comportamento pontual. suspend-and-escalate porque o agente não pode operar enquanto a causa raiz não for identificada. (aag-autonomy-boundary: violação é falha estrutural.)"
		}, {
			description:     "Drift sustentado em qualquer métrica"
			metric:          "Qualquer métrica de driftDetection acima do threshold"
			threshold:       "2 avaliações consecutivas (2 semanas) fora do baseline"
			immediateAction: "reduce-autonomy"
			rationale:       "Drift sustentado indica desalinhamento estrutural entre o envelope e a operação real — promoção nesse estado amplificaria o problema. Redução de autonomia força revisão mais intensiva enquanto causa é investigada. (aag-drift-detection: detecção precoce + ação proporcional.)"
		}, {
			description:     "Breach de blast radius"
			metric:          "maxConcurrentMutations ou maxDailyActions excedido"
			threshold:       "1 ocorrência em qualquer janela de 24h"
			immediateAction: "reduce-autonomy"
			rationale:       "Breach de blast radius é contenção prioritária. Redução de autonomia cria margem de segurança enquanto a causa raiz é investigada. (aag-blast-radius-containment: breach indica subdimensionamento ou comportamento anômalo.)"
		}]
		rationale: "Promoção em dois estágios: onboarding→validation (20 compromissos, 30 dias) e validation→operational (80 compromissos, 60 dias). Regressão com tolerância zero para violação de autonomy boundary (suspend-and-escalate), detecção precoce para drift sustentado (2 semanas, reduce-autonomy), e contenção imediata para breach de blast radius. Calibração conservadora para BC core em fase pré-PMF — CMT como coordenador de compromissos exige priorizar safety sobre speed."
	}

	rationale: "Envelope de governança do agt-cmt-primary em lifecycle onboarding. CMT é BC core cujos compromissos condicionam execução em BCs downstream imediatos (BDG, TCM, DRC) e, indiretamente, em BCs de liquidação e settlement mais adiante na cadeia. Quatro rotas de escalação cobrindo as 4 categorias do agent-spec: async-queue para out-of-scope (não bloqueia operações em andamento), sync-human-review para ambiguous-case e conflicting-signals (resolução rápida contém propagação de incerteza), alert-and-block para insufficient-context (prosseguir sem contexto viola integridade). Blast radius caps dimensionados para onboarding (5 concurrent mutations, 80 daily actions). Drift detection semanal com 3 métricas cobrindo latência de supervisão, progressão de compromissos e utilização de capacidade. Calibração: promoção com critérios mensuráveis (volume, aprovação, drift, audit trail), regressão com tolerância zero para violação de boundary. Lenses: aag (primária: autonomia, escalation, blast radius, lifecycle, calibração, drift), sti (secundária: caps conservadores), cl (secundária: compromissos condicionam execução downstream), rc (terciária: compliance rastreável)."
}
